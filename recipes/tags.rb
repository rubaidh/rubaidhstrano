set :git_remote, "origin"

namespace :tags do
  desc <<-TEXT
    Tag the (git) repository with the release name and push that tag back
    upstream. This is double-entry book keeping. The actual deployment knows
    what revision was deployed (from the REVISION file) and the git repository
    also knows from the tag.
  TEXT
  task :repository, :role => :db, :only => { :primary => true } do
    release_name = fetch(:release_name)

    run_locally "git tag release-#{release_name}"
    run_locally "git push #{git_remote} release-#{release_name}"
  end
end

on :load do
  after_any_deployment "tags:repository" if fetch(:tag_on_deploy, false)
end

depend :local, :command, "git"
