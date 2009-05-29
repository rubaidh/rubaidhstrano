namespace :deploy do
  namespace :cache do
    namespace :code do
      desc <<-TEXT
        Remove the cached copy of the code. This can sometimes be helpful
        when, for example, you've changed the upstream location of a git
        submodule. Git doesn't seem to want to update its working copy with
        that information, so chances are the easiest thing to do is nuke the
        cached copy and start again.
      TEXT
      task :remove, :except => { :no_release => true } do
        cache = strategy.send(:repository_cache)
        run "[ -d #{cache} ] && rm -rf #{cache}"
      end
    end
  end
end