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
default['delivery_build']['api'] = "https://192.168.33.1"

# If set, we will build the delivery-cli from scratch
default['delivery_build']['cli_dir'] = nil

