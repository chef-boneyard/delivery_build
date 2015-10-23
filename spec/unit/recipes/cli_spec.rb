#
# Cookbook Name:: delivery_build
# Spec:: cli
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

describe 'delivery_build::cli' do
  context 'by default' do
    before do
      default_mocks
    end

    cached(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge('delivery_build::cli')
    end

    it 'converges successfully' do
      chef_run
    end
  end

  context "with a node['delivery_build']['cli_dir'] set" do
    let(:cli_dir) { '/tmp/clime' }
    let(:delivery_rust_dir) { '/tmp/clime/cookbooks/delivery_rust' }

    cached(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.set['delivery_build']['cli_dir'] = cli_dir
      end
      runner.converge('delivery_build::cli')
    end

    it 'converges successfully' do
      chef_run
    end

    it 'vendor cookbooks locally' do
      expect(chef_run).to run_execute('berks vendor cookbooks').with(cwd: delivery_rust_dir)
    end

    it 'runs the build cookbook default recipe' do
      expect(chef_run).to run_execute('chef-client -z -o delivery_rust::default').with(cwd: delivery_rust_dir)
    end

    it 'creates a release build' do
      expect(chef_run).to run_execute('make build')
    end

    it 'links itself to /usr/bin/delivery' do
      expect(chef_run).to create_link('/usr/bin/delivery').with(
        to: '/tmp/clime/target/release/delivery'
      )
    end
  end
end
