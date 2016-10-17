# Wraps the call to the underlying hash generation algorithm
class Hasher

  def self.digest(data)
    Digest::SHA1.hexdigest(data)
  end

end
