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

if windows?
  gemrc_path = File.join(ENV['USERPROFILE'], '.gemrc')
else
  gemrc_path = '/root/.gemrc'
end

chef_ingredient 'chefdk' do
  if node['delivery_build']['chefdk_package_source']
    package_source node['delivery_build']['chefdk_package_source']
  else
    channel DeliveryHelper.release_channel(node)
    version node['delivery_build']['chefdk_version']
  end
end

# For now, we need to add a gemrc file to get Chef to install gems
# into ChefDKs gem directory (as opposed to the home directory).
#
# Please see https://github.com/opscode/chef-dk/issues/198 and
# https://gist.github.com/danielsdeleo/b13a7be090905bb97f2d for more
# (The '--no-user-install' bit is key for us currently)
#
# We're inlining the  file content as opposed to using a cookbook_file
# resource here because there were some issues resolving the file; we
# think it has to do with the fact that this cookbook is its own build
# cookbook, and the recursion and inception that results. We can come
# back later and tweak that if we want.
#
# Customizable .gemrc file (Read the attributes file)
file gemrc_path do
  mode '0644'
  content DeliveryHelper::Gemrc.to_yaml(node['delivery_build']['gemrc'])
  action :create
end.run_action(:create)

ENV['PATH'] = if windows?
                "C:/Opscode/chefdk/bin;C:/Opscode/chefdk/embedded/bin;#{ENV['PATH']}"
              else
                "/opt/chefdk/bin:/opt/chefdk/embedded/bin:#{ENV['PATH']}"
              end

# Install knife-supermarket Gem
#
# Needed by the delivery-cli to resolve build-cookbooks from
# both public/private Supermarket
gem_package 'knife-supermarket' do
  version '0.2.2'
  gem_binary windows? ? 'C:\opscode\chefdk\embedded\bin\gem' : '/opt/chefdk/embedded/bin/gem'
end
