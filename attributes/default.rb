# The Push client
case node['platform_family']
when "rhel"
  default['push_jobs']['package_url']      = "https://opscode-private-chef.s3.amazonaws.com/el/6/x86_64/opscode-push-jobs-client-1.1.5-1.el6.x86_64.rpm"
  default['push_jobs']['package_checksum'] = "f5e6be32f60b689e999dcdceb102371a4ab21e5a1bb6fb69ff4b2243a7185d84"
when "debian"
  default['push_jobs']['package_url']      = "http://sales-at-getchef-dot-com.s3.amazonaws.com/opscode-push-jobs-client_1.0.1-1.ubuntu.12.04_amd64.deb"
  default['push_jobs']['package_checksum'] = "72ad9b23e058391e8dd1eaa5ba2c8af1a6b8a6c5061c6d28ee2c427826283492"
end

default['push_jobs']['whitelist']        = {"chef-client" => "chef-client",
                                            /^delivery-cmd (.+)$/ => '/var/opt/delivery/workspace/bin/delivery-cmd \'\1\''}


# The version of Chef DK we want available on the builders
default['delivery_build']['chefdk_version'] = '0.4.0'

# Directories we need for the builder workspace
default['delivery_build']['root'] = '/var/opt/delivery/workspace'
default['delivery_build']['bin'] = File.join(node['delivery_build']['root'], 'bin')
default['delivery_build']['lib'] = File.join(node['delivery_build']['root'], 'lib')
default['delivery_build']['etc'] = File.join(node['delivery_build']['root'], 'etc')
default['delivery_build']['dot_chef'] = File.join(node['delivery_build']['root'], '.chef')

# Settings for the Delivery SSH Wrapper
default['delivery_build']['ssh_user'] = "builder"
default['delivery_build']['ssh_key'] = File.join(node['delivery_build']['etc'], "builder_key")
default['delivery_build']['ssh_log_level'] = 'INFO'
default['delivery_build']['ssh_known_hosts_file'] = File.join(node['delivery_build']['etc'], "delivery-git-ssh-known-hosts")

# Build User
default['delivery_build']['build_user'] = "dbuild"

# In which encrypted data bags to find the needed keys, i.e.
# the private key for the 'builder' delivery user, and the
# private key for the 'delivery' Chef user
default['delivery_build']['builder_keys'] = {
  'builder_key' => {
    'bag' => 'keys',
    'item' => 'delivery_builder_keys',
    # a data bag is a hash; what key in the hash?
    'key' => 'builder_key'
  },
  'delivery_pem' => {
    'bag' => 'keys',
    'item' => 'delivery_builder_keys',
    'key' => 'delivery_pem'
  }
}

# The location of the Delivery API
default['delivery_build']['api'] = nil

# If set, we will build the delivery-cli from scratch
default['delivery_build']['cli_dir'] = nil

# If set, download the package from the given url.
default['delivery_build']['delivery-cli']['version'] = nil
default['delivery_build']['delivery-cli']['artifact'] = nil
default['delivery_build']['delivery-cli']['checksum'] = nil
