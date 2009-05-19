# Run rake on the remote server(s), using the version of rake that has been
# specified (defaulting to whatever is in the path) and the correct RAILS_ENV
# (defaulting to production if not specified).  Pass in one or more tasks to
# run.  This always runs tasks against the latest release, so it's only valid
# to use after +update_code+ has been run.
def rubaidh_run_rake(*tasks)
  rake = fetch(:rake, 'rake')
  rails_env = fetch(:rails_env, 'production')

  tasks.each do |task|
    run "cd #{latest_release}; #{rake} RAILS_ENV=#{rails_env} #{task}"
  end
end