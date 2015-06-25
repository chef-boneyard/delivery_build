# If you set a directory, we will compile the CLI from there, and link
# to it. Probably only useful in development, or in very dire situations.

# node['delivery_build']['cli_dir'] is deprecated, please use node['delivery_build']['delivery-cli']['source_dir'] instead
source_dir = node['delivery_build']['delivery-cli']['source_dir'] || node['delivery_build']['cli_dir']
if source_dir
  package "curl"
  include_recipe 'build-essential'

  # Run rustup.sh via the rustup make target in the delivery-cli repo
  execute "install rust and cargo" do
    cwd source_dir
    command "make rustup_builder"
  end

  execute "cargo build --release" do
    cwd source_dir
    environment('LD_LIBRARY_PATH' => '/usr/local/lib')
  end

  link "/usr/bin/delivery" do
    to File.join(source_dir, 'target', 'release', 'delivery')
  end
# Support passing in the url to the cli package.
elsif node['delivery_build']['delivery-cli']['artifact']
  case node['platform_family']
  when 'rhel'
    pkg_path = "#{Chef::Config[:file_cache_path]}/delivery-cli.rpm"
  when 'debian'
    pkg_path = "#{Chef::Config[:file_cache_path]}/delivery-cli.deb"
  end

  remote_file pkg_path do
    checksum node['delivery_build']['delivery-cli']['checksum'] if node['delivery_build']['delivery-cli']['checksum']
    source node['delivery_build']['delivery-cli']['artifact']
    owner "root"
    group "root"
    mode "0644"
  end

  package "delivery-cli" do
    source pkg_path
    version node['delivery_build']['delivery-cli']['version']
    provider Chef::Provider::Package::Dpkg if node["platform_family"].eql?('debian')
  end
else
  package "delivery-cli" do
    action :upgrade
  end
end
