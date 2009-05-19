# This code has been chowned and modified from the capistrano-ext gem by Jamis
# Buck and the following license applies:
#
# Copyright (c) 2006 Jamis Buck
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

on :load do
  location = fetch(:stage_dir, "config/deploy")

  unless exists?(:stages)
    set :stages, Dir["#{location}/*.rb"].map { |f| File.basename(f, ".rb") }
  end

  unless stages.nil? || stages.empty?
    stages.each do |name|
      desc "Set the target stage to `#{name}'."
      task(name) do
        set :stage, name.to_sym
        load "#{location}/#{stage}"
      end
    end

    namespace :multistage do
      desc "[internal] Ensure that a stage has been selected."
      task :ensure do
        if !exists?(:stage)
          if exists?(:default_stage)
            logger.important "Defaulting to `#{default_stage}'"
            find_and_execute_task(default_stage)
          else
            abort "No stage specified. Please specify one of: #{stages.join(', ')} (e.g. `cap #{stages.first} #{ARGV.last}')"
          end
        end
      end
    end

    on :start, "multistage:ensure", :except => stages
  end
end
