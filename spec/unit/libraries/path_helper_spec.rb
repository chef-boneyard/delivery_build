require 'spec_helper'

describe DeliveryBuild::PathHelper do
  describe '.system_path_with_chefdk' do
    context 'on windows' do
      before do
        ENV['SYSTEMDRIVE'] = 'C:'
        stub_const('File::PATH_SEPARATOR', ';')
        allow(ChefConfig).to receive(:windows?).and_return(true)
      end

      let(:env)             { 'C:/windows/paths;C:/other/windows/path' }
      let(:chefdk)          { 'C:/opscode/chefdk/bin' }
      let(:chefdk_embedded) { 'C:/opscode/chefdk/embedded/bin' }

      it 'returns a windows like path with chefdk' do
        allow(ChefConfig).to receive(:windows?).and_return(true)

        expect(DeliveryBuild::PathHelper.system_path_with_chefdk(env)).to eq("#{chefdk};#{chefdk_embedded};#{env}")
      end
    end

    context 'elsewhere' do
      let(:env)             { '/some/other/path:/some/linux/thing' }
      let(:chefdk)          { '/opt/chefdk/bin' }
      let(:chefdk_embedded) { '/opt/chefdk/embedded/bin' }

      it 'returns a linux like path with chefdk' do
        expect(DeliveryBuild::PathHelper.system_path_with_chefdk(env)).to eq("#{chefdk}:#{chefdk_embedded}:#{env}")
      end
    end
  end

  describe '.omnibus_embedded_path' do
    let(:product) { 'chefdk' }
    let(:path) { 'ssl/certs' }

    context 'on Windows' do
      before do
        ENV['SYSTEMDRIVE'] = 'C:'
        stub_const('File::PATH_SEPARATOR', ';')
        allow(ChefConfig).to receive(:windows?).and_return(true)
      end

      it 'returns Windows location' do
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
