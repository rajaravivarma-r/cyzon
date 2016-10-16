require_relative '../../lib/encrypt_service.rb'

describe EncryptService do

  let(:data) { 'This string has to be encoded' }

  describe '#initialize' do
    it 'accepts the data to be encrypted' do
      expect { described_class.new(data) }.not_to raise_error
    end

    it 'throws when no data is passed in' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end

end
