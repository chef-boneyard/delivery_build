require 'serverspec'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
  set :path, '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/vagrant/.local/bin'
else
  set :backend, :cmd
  set :os, family: 'windows'
  set :path, 'C:/Program Files (x86)/Git/Cmd;C:/Program Files (x86)/Git/libexec/git-core;C:/Opscode/chefdk/bin;'
end

def windows?
  os[:family] == 'windows'
end
