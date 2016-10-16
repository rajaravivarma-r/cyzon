require 'webmock'
require 'httparty'
require_relative './payment_gateway.rb'
require_relative './encrypt_service.rb'
require_relative './hasher.rb'

class Client
  include WebMock::API

  WebMock.enable!

  def initialize
    response_mapping = {
      "http://examplepg.com/transaction/1" => PaymentGateway::RIGHT_RESPONSE,
      "http://examplepg.com/transaction/2" => PaymentGateway::RESPONSE,
    }
    response_mapping.each do |url, response|
      stub_request(:post, url).to_return(body: Base64.encode64(EncryptService.new(response).encrypt))
    end
    @post_parameters = { bank_ifsc_code: 'ICIC0000001',
                         bank_account_number: 11111111,
                         amount: 10000.0,
                         merchant_transaction_ref: 'txn001',
                         transaction_date: '2014-11-14',
                         payment_gateway_merchant_reference: 'merc001' }
  end

  def request_payment(url)
    encrypted_response = HTTParty.post(url, @post_parameters)
    actual_response = EncryptService.new(Base64.decode64(encrypted_response)).decrypt
    if response_intact?(actual_response)
      puts "Response received: #{actual_response}"
    else
      puts "Response is not intact"
    end
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
