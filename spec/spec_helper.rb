require 'chefspec'
require 'chefspec/berkshelf'
require_relative '../libraries/helper'

def default_mocks
  dh = double("DeliveryHelper")
  allow(dh).to receive(:encrypted_data_bag_item).with(any_args).and_return(
    {
      'builder_key' => 'rocks_is_aerosmiths_best_album',
      'delivery_pem' => 'toys_in_the_attic_is_aerosmiths_best_album'
    }
  )
  allow(DeliveryHelper).to receive(:new).and_return(dh)
  stub_command("chef --version | grep 0.4.0").and_return(false)
  stub_command("knife ssl check -c /var/opt/delivery/workspace/etc/delivery.rb").and_return(false)
  stub_command("knife ssl check -c /var/opt/delivery/workspace/etc/delivery.rb https://192.168.33.1").and_return(false)
end
