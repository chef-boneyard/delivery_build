#
# Copyright 2016 Chef Software, Inc.
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

delivery_cli_path = nil

if node['delivery_build']['delivery-cli']['artifact']
  delivery_cli_path = ::File.join(Chef::Config[:file_cache_path], ::File.basename(node['delivery_build']['delivery-cli']['artifact']))

  remote_file delivery_cli_path do
    source node['delivery_build']['delivery-cli']['artifact']
    checksum node['delivery_build']['delivery-cli']['checksum']
  end
end

chef_ingredient 'delivery-cli' do
  if delivery_cli_path
    package_source delivery_cli_path
  else
    channel node['delivery_build']['release-channel'].to_sym
    version node['delivery_build']['delivery-cli']['version']
    options node['delivery_build']['delivery-cli']['options']
  end
end
