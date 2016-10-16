class Query


  class InvalidParams < StandardError; end

  SEPARATOR = '|'
  REQUIRED_FIELDS = %i[bank_ifsc_code bank_account_number amount merchant_transaction_ref
                     transaction_date payment_gateway_merchant_reference].sort
  def initialize(params)
    @params = params
    validate!
  end

  def payload
  end

  private

  def hash
  end

  def plain_string
  end

  def encrypt
    EncryptService.new(hash)
  end

  def validate!
    missing_keys = REQUIRED_FIELDS - @params.keys.sort
    if missing_keys.any?
      raise InvalidParams.new("missing keys: #{missing_keys.join(', ')}")
    end
  end

end
