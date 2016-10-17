require_relative '../../lib/query_builder.rb'

describe QueryBuilder do

  let(:hash_param) { {amount: 5000, txn_id: 12345, name: 'Clark'} }
  let(:result) { described_class.join(hash_param) }

  describe '.join' do
    context 'when the arguments is a hash' do
      it "creates a string seperated by #{QueryBuilder::SEPARATOR}" do
        expect(result).to eql('amount=5000|txn_id=12345|name=Clark')
      end
    end

    context 'when the arguments is a mix of string and hash' do
      it "creates a string seperated by #{QueryBuilder::SEPARATOR}" do
        query = described_class.join(result, {hash: 'abcdefgh'})
        expect(query).
          to eql('amount=5000|txn_id=12345|name=Clark|hash=abcdefgh')
      end
    end
  end

end
