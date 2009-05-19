# Some defaults, based upon how we tend to work.

# Repository defaults
set :scm, :git
set :git_enable_submodules, true
set(:repository) { "git@github.com:rubaidh/#{application}.git" }
set :deploy_via, :remote_cache

# Deployment configuration
set :daemon_strategy, :passenger
set(:user) { application }
set :use_sudo, false
role(:app) { host }
role(:web) { host }
role(:db)  { host }

# SSH options
ssh_options[:forward_agent] = true
ssh_options[:keys] = [
  File.join(ENV['HOME'], '.ssh', 'identity'),
  File.join(ENV['HOME'], '.ssh', 'id_rsa'),
  File.join(ENV['HOME'], '.ssh', 'id_dsa')
]
