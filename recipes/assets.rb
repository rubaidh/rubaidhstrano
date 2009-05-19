set :asset_directories, []
set(:shared_assets_path) { File.join(shared_path, 'assets') }

namespace :assets do
  namespace :directories do
    desc "[internal] Create all the shared asset directories"
    task :create, :roles => [ :app, :web ], :except => { :no_release => true } do
      asset_directories.each do |dir|
        run "umask 0002 && mkdir -p #{File.join(shared_assets_path, dir)}"
      end
    end

    desc "[internal] Symlink the shared asset directories into the new deployment"
    task :symlink, :roles => [ :app, :web ], :except => { :no_release => true } do
      asset_directories.each do |dir|
        run <<-CMD
          rm -rf #{latest_release}/#{dir} &&
          ln -s #{shared_assets_path}/#{dir} #{latest_release}/#{dir}
        CMD
      end
    end
  end
end

after 'deploy:setup',           'assets:directories:create'
after 'deploy:finalize_update', 'assets:directories:symlink'

# Add the assets directories to the list of dependencies we check for.
on :load do
  asset_directories.each do |dir|
    depend :remote, :directory, File.join(shared_assets_path, dir)
  end
end
