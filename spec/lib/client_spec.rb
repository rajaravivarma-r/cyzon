require_relative '../../lib/client.rb'

describe Client do

  let(:client) { described_class.new }

  describe '#request_payment' do
    it 'prints the reponse when the reponse is intact' do
      expect(STDOUT).to receive(:puts).with(/Response received.*/)
      client.request_payment('http://examplepg.com/transaction/1')
    end

    it 'prints the error message to STDOUT and exits' do
      expect(STDOUT).to receive(:puts).with(/Response is not intact/)
      client.request_payment('http://examplepg.com/transaction/2')
    end
  end

  # private methods
  describe '#response_intact?' do
    let(:response) {'txn_status=success|amount=10000.00|merchant_transaction_ref=txn001|'\
                    'transaction_date=2014-11-14|payment_gateway_merchant_reference=merc001|'\
                    'payment_gateway_transaction_reference=pg_txn_0001'
    }

    let(:hash) { '858310b47ffdd818379943e1f452d45debba7320' }

    context 'when the reponse is intact' do
      it 'returns true' do
        expect(client).to receive(:response_and_sha).and_return([response, hash])
        expect(client.send(:response_intact?, PaymentGateway::RESPONSE)).to be(true)
      end
    end

    context 'when the reponse is modified' do
      it 'returns false' do
        expect(client).to receive(:response_and_sha).and_return([response, 'wrong hash'])
        expect(client.send(:response_intact?, PaymentGateway::RESPONSE)).to be(false)
      end
    end
  end

  describe '#response_and_sha' do
    it 'returns the actual payload and the hash part' do
      actual_payload, hash_part = client.send(:response_and_sha, PaymentGateway::RESPONSE)
      expect(hash_part).to eql('abdedffduedd000000988')
      expect("#{actual_payload}|hash=#{hash_part}").to eql(PaymentGateway::RESPONSE)
    end
  end
end
