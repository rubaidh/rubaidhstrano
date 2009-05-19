# If you're going to fork this project, this is probably the first file you
# want to nuke. It's a collection of hacks that are specific to our deployment
# environment(s) and probably won't be much use to anybody else.
on :load do
  case fetch(:host, nil)
  when "balblair.rubaidh.com" # Welcome to OpenSolaris.  *sigh*
    set :tar, "gtar"
  end
end