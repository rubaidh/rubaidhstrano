namespace :assets do
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