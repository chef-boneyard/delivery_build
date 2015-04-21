# If you set a directory, we will compile the CLI from there, and link
# to it. Probably only useful in development, or in very dire situations.
if node['delivery_build']['cli_dir']
  package "curl"

  remote_file "#{Chef::Config[:file_cache_path]}/rustup.sh" do
    source "https://static.rust-lang.org/rustup.sh"
  end

  # Note - you'll want to switch this to a stable rust in March,
  # or move it forward in the interim.
  execute "install rust and cargo" do
    command "bash #{Chef::Config[:file_cache_path]}/rustup.sh --date=2015-04-01 --channel=nightly"
  end

  execute "cargo build --release" do
    cwd node['delivery_build']['cli_dir']
    environment('LD_LIBRARY_PATH' => '/usr/local/lib')
  end

  link "/usr/bin/delivery" do
    to File.join(node['delivery_build']['cli_dir'], 'target', 'release', 'delivery')
  end
# Support passing in the url to the cli package.
elsif node['delivery_build']['cli_url']
  case node['platform_family']
  when 'rhel'
    pkg_path = "#{Chef::Config[:file_cache_path]}/delivery-cli.rpm"
  when 'debian'
    pkg_path = "#{Chef::Config[:file_cache_path]}/delivery-cli.deb"
  end

  remote_file pkg_path do
    checksum node['delivery_build']['cli_checksum'] if node['delivery_build']['cli_checksum']
    source node['delivery_build']['cli_url']
    owner "root"
    group "root"
    mode "0644"
  end

  package "delivery-cli" do
    source pkg_path
    version node['delivery-cli']['version']
    provider Chef::Provider::Package::Dpkg if node["platform_family"].eql?('debian')
  end
else
  packagecloud_repo 'chef/stable' do
    type value_for_platform_family(debian: 'deb', rhel: 'rpm')
  end

  package "delivery-cli" do
    action :upgrade
  end
end
