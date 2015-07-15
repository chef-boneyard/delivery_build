#
# Cookbook Name:: delivery_build
# Spec:: default
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

describe 'delivery_build::default' do
  context 'by default' do
    before do
      default_mocks
    end

    cached(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge('delivery_build::default')
    end

    it 'converges successfully' do
      chef_run
    end

    ['git',
     'delivery_build::chef_client',
     'delivery_build::repo',
     'delivery_build::chefdk',
     'delivery_build::user',
     'delivery_build::workspace',
     'delivery_build::cli'].each do |r|
      it "includes #{r}" do
        expect(chef_run).to include_recipe(r)
      end
    end
  end
end
