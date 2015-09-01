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
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/sugar'
require_relative '../libraries/helper'

ChefSpec::Coverage.start!

def default_mocks
  dh = double('DeliveryHelper')
  allow(dh).to receive(:encrypted_data_bag_item).with(any_args).and_return(
    'builder_key' => 'rocks_is_aerosmiths_best_album',
    'delivery_pem' => 'toys_in_the_attic_is_aerosmiths_best_album'
  )
  allow(DeliveryHelper).to receive(:new).and_return(dh)
  stub_command('chef --version | grep 0.4.0').and_return(false)
  stub_command('knife ssl check -c /var/opt/delivery/workspace/etc/delivery.rb').and_return(false)
  stub_command('knife ssl check -c /var/opt/delivery/workspace/etc/delivery.rb https://192.168.33.1').and_return(false)
  stub_command('knife ssl check -c C:/Users/Administrator/delivery/workspace/etc/delivery.rb').and_return(false)
  stub_command('knife ssl check -c C:/Users/Administrator/delivery/workspace/etc/delivery.rb https://192.168.33.1').and_return(false)
end
