file "/etc/chef/client.rb" do
  mode 0644
end

directory "/etc/chef/trusted_certs" do
  mode 0644
  recursive true
end
