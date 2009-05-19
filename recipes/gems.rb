namespace :gems do
  desc <<-TEXT
    Build any binary gems that need compilation. This does require that your
    deployment environment have the right build tools installed.
  TEXT
  task :build, :except => { :no_release => true } do
    rubaidh_run_rake "gems:build"
  end
end

on :load do
  if fetch(:build_gems, false)
    after "deploy:update_code", "gems:build"
  end
end
