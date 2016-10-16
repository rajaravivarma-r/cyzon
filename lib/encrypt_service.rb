require 'openssl'

class EncryptService

  KEY = 'Q9fbkBF8au24C9wshGRW9ut8ecYpyXye5vhFLtHFdGjRg3a4HxPYRfQaKutZx5N4'
  SCHEME = 'AES-128-CBC'

  def initialize(data)
    @data = data
  end

  def encrypt
    cipher.update(@data) + cipher.final
  end

  def decrypt
    decipher.update(@data) + decipher.final
  end

  private

  def cipher
    # This memoization is not for performance, but the `update` and `final` has to be called
    # on the same cipher object.
    @cipher ||= OpenSSL::Cipher.new(SCHEME).tap do |cipher|
      cipher.encrypt
      cipher.key = KEY
    end
  end

  def decipher
    @decipher ||= OpenSSL::Cipher.new(SCHEME).tap do |decipher|
      decipher.decrypt
      decipher.key = KEY
    end
  end

end
