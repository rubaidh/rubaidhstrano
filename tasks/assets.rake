namespace :assets do

  desc <<-TEXT
    Compress static assets so they can be be served more quickly. This task
    will take all javascript and CSS stylesheets, and minify them to reduce
    their size, using the YUI Compressor. WARNING: It will overwrite the
    existing copies of the files. Please don't check the minified versions
    into version control!
  TEXT
  task :compress => ["assets:compress:javascripts", "assets:compress:stylesheets"]

  namespace :compress do
    def compress_js(filename)
      compress(filename, "--type js")
    end

    def compress_css(filename)
      compress(filename, "--type css")
    end

    def compress(filename, *args)
      args << "-o #{filename}.minified"
      args << "--charset utf-8"
      args << filename

      yui_compressor(*args)

      sh "mv #{filename}.minified #{filename}"
    end

    def yui_compressor(*args)
      sh "java -jar #{File.join(File.dirname(__FILE__), '..', 'support', 'yuicompressor-2.4.2.jar')} #{args.join(" ")}"
    end

    task :javascripts => FileList["public/javascripts/**/*.js"] do |task|
      task.prerequisites.each do |js_file|
        compress_js js_file
      end
    end

    task :stylesheets => FileList["public/stylesheets/**/*.css"] do |task|
      task.prerequisites.each do |css_file|
        compress_css css_file
      end
    end
  end

  namespace :backup do
    desc <<-TEXT
    Loads an existing download from your deployment's assets into the current
    host's assets. WARNING: This will overwrite any existing assets that are
    in the upstream version. Unfortunately, it's not a complete sync because
    it will not delete assets that are *not* in the upstream copy.
    TEXT
    task :load do
      source_env = ENV['SOURCE_ENV'] || 'production'
      sh "tar jxf #{source_env}-assets.tar.bz2"
    end
  end
end