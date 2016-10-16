require 'openssl'

class EncryptService

  KEY = 'Q9fbkBF8au24C9wshGRW9ut8ecYpyXye5vhFLtHFdGjRg3a4HxPYRfQaKutZx5N4'
  SCHEME = 'AES-128-CBC'

  def initialize(data)
    @data = data
  end

  private

  def cipher
    OpenSSL::Cipher.new(SCHEME).tap do |cipher|
      cipher.key = KEY
    end
  end

end
