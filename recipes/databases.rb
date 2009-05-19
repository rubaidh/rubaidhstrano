namespace :db do
  desc <<-DESC
    Back up the database from the deployment environment. This task dumps the
    MySQL database in the current deployment environment out to an SQL dump
    file which is bzip compressed. It will overwrite any existing backup from
    there.
  DESC
  task :backup, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, 'rake')
    rails_env = fetch(:rails_env, 'production')

    run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} db:backup:dump"
  end

  desc <<-DESC
    Back up the database in the deployment environment and take a local copy.
    This can be useful for mirroring the production database to another host
    if, for example, you're looking to reproduce a bug on the production
    server.
  DESC
  task :download, :roles => :db, :only => { :primary => true } do
    backup
    rails_env = fetch(:rails_env, 'production')
    get "#{current_path}/db/#{rails_env}-data.sql.bz2", "db/#{rails_env}-data.sql.bz2"
  end
end

on :load do
  if fetch(:backup_database_before_migrations, false)
    before "deploy:migrate", "db:backup"
  end
end