#
# Cookbook Name:: delivery_build
# Spec:: chefdk
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

require 'spec_helper'

describe 'delivery_build::chefdk' do
  context "by default" do
    before do
      default_mocks
    end

    cached(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.set['delivery_build']['chefdk_version'] = "0.4.0"
      end
      runner.converge('delivery_build::chefdk')
    end

    it 'converges successfully' do
      chef_run
    end

    it 'downloads install.sh' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/install.sh").with(
        source: 'https://www.chef.io/chef/install.sh',
        mode: '0755'
      )
    end

    it 'installs chefdk' do
      expect(chef_run).to run_execute('install_chefdk').with(
        command: "#{Chef::Config[:file_cache_path]}/install.sh -P chefdk -v 0.4.0"
      )
    end

    it 'configures .gemrc' do
      expect(chef_run).to create_file('/root/.gemrc').with(
        owner: 'root',
        mode: '0644'
      )
    end
  end
end

