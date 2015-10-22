require 'spec_helper'

describe DeliveryBuild::PathHelper do
  before { ENV['SYSTEMDRIVE'] = 'C:' }

  describe '.omnibus_embedded_path' do
    let(:product) { 'chefdk' }
    let(:path) { 'ssl/certs' }

    context 'on Windows' do
      it 'returns Windows location' do
        allow(ChefConfig).to receive(:windows?).and_return(true)

        expect(DeliveryBuild::PathHelper.omnibus_embedded_path(product, path)).to eq('C:/opscode/chefdk/embedded/ssl/certs')
      end
    end

    context 'elsewhere' do
      it 'returns POSIX location' do
        expect(DeliveryBuild::PathHelper.omnibus_embedded_path(product, path)).to eq('/opt/chefdk/embedded/ssl/certs')
      end
    end
  end
end
