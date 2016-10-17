require 'digest/sha1'
require 'base64'

require 'hasher.rb'

# Class which encapsulated query building and making it suitable for the Payment Gateway
class Query

  # Exception thrown when the passed in params are invalid
  class InvalidParams < StandardError; end

  REQUIRED_FIELDS = %i[bank_ifsc_code bank_account_number amount merchant_transaction_ref
                     transaction_date payment_gateway_merchant_reference].sort
  def initialize(params)
    @params = params
    validate
    sanitize_params
  end

  def payload_to_payment_gateway
    Base64.encode64(encrypted_payload)
  end

  private

  def payload_with_sha
    actual_payload = QueryBuilder.join(@params)
    QueryBuilder.join(actual_payload, hash: Hasher.digest(actual_payload))
  end

  def encrypted_payload
    EncryptService.new(payload_with_sha).encrypt
  end

  def validate
    missing_keys = REQUIRED_FIELDS - @params.keys.sort
    if missing_keys.any?
      raise InvalidParams.new("missing keys: #{missing_keys.join(', ')}")
    end
  end

  def sanitize_params
    @params.reject! { |key, val| !REQUIRED_FIELDS.include?(key) }
  end
end
