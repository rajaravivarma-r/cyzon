class QueryBuilder

  SEPARATOR = '|'

  def self.join(*args)
    fields = []
    args.each do |arg|
      if arg.is_a?(String)
        fields << arg
      elsif arg.is_a?(Hash)
        fields << arg.to_a.map { |k, v| "#{k}=#{v}" }.join(SEPARATOR)
      end
    end
    fields.join(SEPARATOR)
  end

end
