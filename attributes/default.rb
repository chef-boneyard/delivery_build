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

include_attribute 'delivery-base'

# The release channel that we should pull chefdk and delivery-cli from
default['delivery_build']['release-channel'] = 'stable'

# Directories we need for the builder workspace
default['delivery_build']['root'] = platform_family == 'windows' ? 'C:/delivery/ws' : '/var/opt/delivery/workspace'

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

# Sentry DSN for use with exception handling in delivery-cmd
default['delivery_build']['sentry_dsn'] = nil

# The location of the Delivery API
default['delivery_build']['api'] = nil

# ChefDK version
#
# Specify the chefdk version you want to install on the build-nodes
# set it to `latest` to always be in the latest version (:upgrade)
default['delivery_build']['chefdk_version'] = 'latest'

# set path to local package for chefdk install
default['delivery_build']['chefdk_package_source'] = nil

# Add trusted_certs to the build-node chefdk/cacerts.pem via trusted_certs.rb
# Example:
# {
#   'Delivery Supermarket Server' => '/my/supermarket.crt',
#   'Delivery Github Enterprise' => '/the/github.crt',
#   'Another Component' => '/another/component.crt'
# }
default['delivery_build']['trusted_certs'] = {}

delivery_cmd = File.join(node['delivery_build']['bin'], 'delivery-cmd')

default['push_jobs']['whitelist'] = { 'chef-client'         => 'chef-client',
                                      /^delivery-cmd (.+)$/ => "#{delivery_cmd} '\\1'" }

# Gemrc variables
#
# To customize the `~/.gemrc` file you have to modify the following variables,
# keep in mind that it is very important what type of variable you use since the
# file will be render the same way you configure it.
#
# Ex. If you add extra parameters like:
#
#   default['delivery_build']['gemrc'][:awesome_param] = 'this is a string'
#   default['delivery_build']['gemrc']['not_a_symbol'] = ['multiple', 'parameters']
#   default['delivery_build']['gemrc'][:number] = 1234
#
# It will get render like:
#
#   :awesome_param: this is a string
#   not_a_symbol:
#   - multiple
#   - parameters
#   :number: 1234
#
default['delivery_build']['gemrc'][:benchmark] = false
default['delivery_build']['gemrc'][:verbose] = true
default['delivery_build']['gemrc'][:update_sources] = true
default['delivery_build']['gemrc']['gem'] = '--no-rdoc --no-ri'
default['delivery_build']['gemrc']['install'] = '--no-user-install'
default['delivery_build']['gemrc'][:sources] = %w(http://rubygems.org/ http://gems.github.com/)
default['delivery_build']['gemrc'][:backtrace] = true
default['delivery_build']['gemrc'][:bulk_threshold] = 1000
