require 'digest/sha1'
require 'base64'

require 'hasher.rb'

class Query

  class InvalidParams < StandardError; end

  SEPERATOR = '|'
  REQUIRED_FIELDS = %i[bank_ifsc_code bank_account_number amount merchant_transaction_ref
                     transaction_date payment_gateway_merchant_reference].sort
  def initialize(params)
    @params = params
    validate!
    sanitize_params!
  end

  def payload_to_payment_gateway
    Base64.encode64(encrypted_payload)
  end

  private

  def payload_with_sha
    plain_string = build_string
    "#{plain_string}|hash=#{Hasher.digest(plain_string)}"
  end

  def build_string
    fields = []
    @params.each do |field, value|
      fields << "#{field}=#{value}"
    end
    fields.join(SEPERATOR)
  end

  def encrypted_payload
    EncryptService.new(payload_with_sha).encrypt
  end

  def validate!
    missing_keys = REQUIRED_FIELDS - @params.keys.sort
    if missing_keys.any?
      raise InvalidParams.new("missing keys: #{missing_keys.join(', ')}")
    end
  end

  def sanitize_params!
    @params.reject! { |key, val| !REQUIRED_FIELDS.include?(key) }
  end
end
