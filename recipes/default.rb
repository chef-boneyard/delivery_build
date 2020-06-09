#
# Cookbook:: delivery_build
# Recipe:: default
#
# Copyright:: 2015 Chef Software, Inc.
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

include_recipe 'chef-sugar'

# Delivery base cookbook that includes push-jobs
include_recipe 'delivery-base'

# Make sure client.rb is readable by dbuild
include_recipe 'delivery_build::chef_client'

# Install git
include_recipe 'delivery_build::_git'

if platform_family?('rhel', 'fedora', 'debian')
  # Create the dbuild user
  include_recipe 'delivery_build::user'
end

# Install the Chef DK
include_recipe 'delivery_build::chefdk'

# Create the root delivery job workspace
include_recipe 'delivery_build::workspace'

# Add trusted_certs to chefdk/cacert.pem
include_recipe 'delivery_build::trusted_certs'
