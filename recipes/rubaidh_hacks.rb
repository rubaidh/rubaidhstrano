on :load do
  case fetch(:host, nil)
  when "balblair.rubaidh.com" # Welcome to OpenSolaris.  *sigh*
    set :tar, "gtar"
  end
end