# Why is this a class, and not a module? Why not a class method?
#
# Well, kids - turns out the way Chef loads these makes it impossible
# to mock a Class method. So we can't test this cookbook if we do that.
# Good times.
class DeliveryHelper
  def self.encrypted_data_bag_item(bag, id, secret = nil)
    dh = DeliveryHelper.new
    dh.encrypted_data_bag_item(bag, id, secret)
  end

  def encrypted_data_bag_item(bag, id, secret = nil)
    Chef::Log.debug "Loading encrypted data bag item #{bag}/#{id}"

    if secret.nil? && Chef::Config[:encrypted_data_bag_secret].nil?
      raise 'Please specify Chef::Config[:encrypted_data_bag_secret]'
    end

    secret ||= File.read(Chef::Config[:encrypted_data_bag_secret]).strip
    Chef::EncryptedDataBagItem.load(bag, id, secret)
  end
end
