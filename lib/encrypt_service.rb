require 'openssl'

class EncryptService

  KEY = 'Q9fbkBF8au24C9wshGRW9ut8ecYpyXye5vhFLtHFdGjRg3a4HxPYRfQaKutZx5N4'
  SCHEME = 'AES-128-CBC'

  def initialize(data)
    @data = data
  end

  def encrypt
    cipher.encrypt
    cipher.update(@data) + cipher.final
  end

  private

  def cipher
    # This memoization is not for performance, but the `update` and `final` has to be called
    # on the same cipher object.
    @cipher ||= OpenSSL::Cipher.new(SCHEME).tap do |cipher|
      cipher.key = KEY
    end
  end

end
