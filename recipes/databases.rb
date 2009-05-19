namespace :db do
  desc <<-DESC
    Back up the database from the deployment environment. This task dumps the
    MySQL database in the current deployment environment out to an SQL dump
    file which is bzip compressed. It will overwrite any existing backup from
    there.
  DESC
  task :backup, :roles => :db, :only => { :primary => true } do
    rubaidh_run_rake "db:backup:dump"
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
    get "#{latest_release}/db/#{rails_env}-data.sql.bz2", "db/#{rails_env}-data.sql.bz2"
  end
end

on :load do
  if fetch(:backup_database_before_migrations, false)
    before "deploy:migrate", "db:backup"
  end

  if fetch(:disable_web_during_migrations, false)
    before "deploy:migrations", "deploy:web:disable"
    after  "deploy:migrations", "deploy:web:enable"
  end
end

# Note the dependency this code creates on mysqldump and bzip2
depend :remote, :command, 'mysqldump'
depend :remote, :command, 'bzip2'
