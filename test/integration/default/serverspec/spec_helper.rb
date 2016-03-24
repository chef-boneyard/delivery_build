require 'serverspec'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
  set :path, 'C:/Program Files (x86)/Git/Cmd;C:/Program Files (x86)/Git/libexec/git-core;C:/Opscode/chefdk/bin;C:/Opscode/chefdk/embedded/bin'
end
