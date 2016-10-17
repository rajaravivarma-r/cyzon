# Class used to build queries, sort of works like File.join
class QueryBuilder

  SEPARATOR = '|'

  def self.join(*args)
    args.collect do |arg|
      if arg.is_a?(String)
        arg
      elsif arg.is_a?(Hash)
        arg.to_a.map { |key, value| "#{key}=#{value}" }.join(SEPARATOR)
      end
    end.join(SEPARATOR)
  end

end
