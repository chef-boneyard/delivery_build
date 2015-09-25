#
# Copyright 2015 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# The Push client
include_attribute 'push-jobs'

case node['platform_family']
when 'rhel'
  default['push_jobs']['package_url']      = 'https://opscode-private-chef.s3.amazonaws.com/el/6/x86_64/opscode-push-jobs-client-1.1.5-1.el6.x86_64.rpm'
  default['push_jobs']['package_checksum'] = 'f5e6be32f60b689e999dcdceb102371a4ab21e5a1bb6fb69ff4b2243a7185d84'
when 'debian'
  default['push_jobs']['package_url']      = 'http://sales-at-getchef-dot-com.s3.amazonaws.com/opscode-push-jobs-client_1.0.1-1.ubuntu.12.04_amd64.deb'
  default['push_jobs']['package_checksum'] = '72ad9b23e058391e8dd1eaa5ba2c8af1a6b8a6c5061c6d28ee2c427826283492'
when 'windows'
  default['push_jobs']['package_url']      = 'https://opscode-private-chef.s3.amazonaws.com/windows/2008r2/x86_64/opscode-push-jobs-client-windows-1.1.5-1.windows.msi'
  default['push_jobs']['package_checksum'] = '411520e6a2e3038cd018ffacee0e76e37e7badd1aa84de03f5469c19e8d6c576'
end

# The repo that we should pull chefdk and delivery-cli
default['delivery_build']['repo_name'] = 'chef/stable'

# Directories we need for the builder workspace
default['delivery_build']['root'] = if platform_family == 'windows'
                                      # We have to do ALT_SEPARATOR || SEPARATOR because ALT_SEPARATOR isn't defined on non windows hosts so the unit tests explode
                                      File.join(ENV['USERPROFILE'], 'delivery', 'workspace').gsub(File::ALT_SEPARATOR || File::SEPARATOR, File::SEPARATOR)
                                    else
                                      '/var/opt/delivery/workspace'
                                    end

default['delivery_build']['bin'] = File.join(node['delivery_build']['root'], 'bin')
default['delivery_build']['lib'] = File.join(node['delivery_build']['root'], 'lib')
default['delivery_build']['etc'] = File.join(node['delivery_build']['root'], 'etc')
default['delivery_build']['dot_chef'] = File.join(node['delivery_build']['root'], '.chef')

# Settings for the Delivery SSH Wrapper
default['delivery_build']['ssh_user'] = 'builder'
default['delivery_build']['ssh_key'] = File.join(node['delivery_build']['etc'], 'builder_key')
default['delivery_build']['ssh_log_level'] = 'INFO'
default['delivery_build']['ssh_known_hosts_file'] = File.join(node['delivery_build']['etc'], 'delivery-git-ssh-known-hosts')

# Build User
default['delivery_build']['build_user'] = 'dbuild'

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

# ChefDK version
#
# Specify the chefdk version you want to install on the build-nodes
# set it to `latest` to always be in the latest version (:upgrade)
default['delivery_build']['chefdk_version'] = if platform_family == 'windows'
                                                # Currently there is no "easy" way to get the latest version
                                                # of chefdk for windows systems, therefore we will hardcode it
                                                # until we have a final solution for this.
                                                '0.7.0'
                                              else
                                                'latest'
                                              end

# Add trusted_certs to the build-node chefdk/cacerts.pem via trusted_certs.rb
# Example:
# {
#   'Delivery Supermarket Server' => '/my/supermarket.crt',
#   'Delivery Github Enterprise' => '/the/github.crt',
#   'Another Component' => '/another/component.crt'
# }
default['delivery_build']['trusted_certs'] = {}

# variable for delivery-cmd on windows
delivery_cmd = if platform_family == 'windows'
                 # We have to do ALT_SEPARATOR || SEPARATOR because ALT_SEPARATOR isn't defined on non windows hosts so the unit tests explode
                 File.join(node['delivery_build']['bin'], 'delivery-cmd').gsub(File::ALT_SEPARATOR || File::SEPARATOR, File::SEPARATOR)
               else
                 "#{node['delivery_build']['bin']}/delivery-cmd"
               end

default['push_jobs']['whitelist'] = { 'chef-client'         => 'chef-client',
                                      /^delivery-cmd (.+)$/ => "#{delivery_cmd} '\\1'" }
