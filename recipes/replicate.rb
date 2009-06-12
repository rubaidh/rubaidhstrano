desc <<-TEXT
Clone the deployment environment to your current environment. This will back
up the current database and any assets from the production environment, copy
them locally and load them. WARNING: This will totally and utterly destroy the
current data contents of your local environment. Don't do this unless you're
paying attention!
TEXT
task :replicate, :roles => [ :db ], :only => { :primary => true } do
  source_env = fetch(:rails_env, 'production')
  target_env = ENV['TARGET_ENV'] || 'development'

  find_and_execute_task("db:download")
  find_and_execute_task("assets:download")

  run_locally "rake RAILS_ENV=#{target_env} SOURCE_ENV=#{source_env} db:backup:load"

  unless asset_directories.empty?
    asset_directories.each do |dir|
      run_locally "rm -rf #{dir}"
    end
    run_locally "rake RAILS_ENV=#{target_env} SOURCE_ENV=#{source_env} assets:backup:load"
  end
end

depend :local, :command, "bzcat"
depend :local, :command, "tar"
depend :local, :command, "mysql"
