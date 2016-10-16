require_relative '../../lib/query.rb'

describe Query do

  let(:bank_ifsc_code) { 'ICIC0000001' }
  let(:bank_account_number) { 11111111 }
  let(:amount) { 10000.00 }
  let(:merchant_transaction_ref) { 'txn001' }
  let(:transaction_date) { '2014-11-14' }
  let(:payment_gateway_merchant_reference) { 'merc001' }
  let(:query_params) {{ bank_ifsc_code: bank_ifsc_code,
                       bank_account_number: bank_account_number,
                       amount: amount,
                       merchant_transaction_ref: merchant_transaction_ref,
                       transaction_date: transaction_date,
                       payment_gateway_merchant_reference: payment_gateway_merchant_reference }}

  describe '#initialize' do
    it 'takes all necessary parameters to build the query' do
      expect { described_class.new(query_params) }.not_to raise_error
    end

    it 'throws an exception with missing keys in the error message' do
      invalid_query_params = query_params.delete_if { |key, val| key == :amount }
      expect { described_class.new(invalid_query_params) }.to raise_error(Query::InvalidParams, /amount/)
    end

  end
end
