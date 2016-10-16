class Hasher

  def self.digest(data)
    Digest::SHA1.hexdigest(data)
  end

end
