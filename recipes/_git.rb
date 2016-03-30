if windows?
  git_client 'default' do
    windows_display_name node['git']['display_name']
    windows_package_url format(node['git']['url'], version: node['git']['version'], architecture: node['git']['architecture'])
    windows_package_checksum node['git']['checksum']
    action :install
  end
else
  git_client 'default' do
    provider Chef::Provider::GitClient::Source
    source_checksum node['git']['checksum']
    source_prefix node['git']['prefix']
    source_url format(node['git']['url'], version: node['git']['version'])
    source_use_pcre node['git']['use_pcre']
    source_version node['git']['version']
    action :install
  end
end
