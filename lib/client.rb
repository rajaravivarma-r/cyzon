require 'webmock'
require_relative './payment_gateway.rb'

class Client
  include WebMock::API

  WebMock.enable!

  def initialize
    @url = "http://examplepg.com/transaction"
    stub_request(:post, @url).to_return { EncryptService.new(PaymentGateway::RESPONSE).encrypt }
    @post_parameters = { bank_ifsc_code: 'ICIC0000001',
                         bank_account_number: 11111111,
                         amount: 10000.0,
                         merchant_transaction_ref: 'txn001',
                         transaction_date: '2014-11-14',
                         payment_gateway_merchant_reference: 'merc001' }
  end

  def request_payment
    encrypted_response = HTTParty.post(@url, @post_parameters)
    actual_response = EncryptService.new(encrypted_response).decrypt

  end

  private

  def response_intact?(response)
    actual_payload, payload_sha = response_and_sha(response)
    Hasher.digest(actual_payload) == payload_sha
  end

  def response_and_sha(response)
    response.match(/(.*?)\|hash=(.*)/).captures
  end

end
