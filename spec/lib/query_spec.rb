require_relative '../../lib/query.rb'

describe Query do

  let(:query_params) {{ bank_ifsc_code: 'ICIC0000001',
                       bank_account_number: 11111111,
                       amount: 10000.0,
                       merchant_transaction_ref: 'txn001',
                       transaction_date: '2014-11-14',
                       payment_gateway_merchant_reference: 'merc001' }}
  let(:query) { described_class.new(query_params) }

  describe '#initialize' do
    it 'takes all necessary parameters to build the query' do
      expect { described_class.new(query_params) }.not_to raise_error
    end

    it 'throws an exception with missing keys in the error message' do
      invalid_query_params = query_params.delete_if { |key, val| key == :amount }
      expect { described_class.new(invalid_query_params) }.to raise_error(Query::InvalidParams, /amount/)
    end

    it 'discards all keys which are not required' do
      unwanted_params = query_params.update(unwanted_field: 2435)
      query = described_class.new(unwanted_params)
      expect(query.instance_variable_get(:@params).keys).not_to include(:unwanted_field)
    end
  end

  describe '#payload_to_payment_gateway' do
    it 'encrypts the payload' do
      payload_with_sha = 'payload with sha'
      encrypt_service = double('EncryptService', encrypt: 'scrambled text')
      expect(query).to receive(:payload_with_sha).and_return(payload_with_sha)
      expect(encrypt_service).to receive(:encrypt)
      expect(EncryptService).to receive(:new).with(payload_with_sha).and_return(encrypt_service)
      query.payload_to_payment_gateway
    end
  end

  # private methods
  describe '#build_string' do
    it "returns #{Query::SEPERATOR} seperated field=value string" do
      expect(query.send(:build_string)).to eql('bank_ifsc_code=ICIC0000001|bank_account_number=11111111|'\
                                               'amount=10000.0|merchant_transaction_ref=txn001|'\
                                               'transaction_date=2014-11-14|payment_gateway_merchant_reference'\
                                               '=merc001')
    end
  end

  describe '#payload_with_sha' do
    it "returns #{Query::SEPERATOR} seperated string with hash=sha(build_string)" do
      sample_query_string = 'one=1'
      expect(query).to receive(:build_string).and_return(sample_query_string)
      expect(query.send(:payload_with_sha)).
        to eql("#{sample_query_string}|hash=#{Hasher.digest(sample_query_string)}")
    end
  end
end
