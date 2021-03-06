#
# encapsulates a Hash that enforces type rules on keys/vals
# and provides special to_s output
#
class MetricsHash < Hash
  KEY_REGEX = /^[a-zA-Z0-9\-_]+$/

  def initialize
    @metrics = {}
  end

  def []=(key, val)
    fail "Key must be a string matching #{KEY_REGEX}" unless KEY_REGEX.match(key)
    fail 'Val must respond to :to_s' unless val.respond_to?(:to_s)
    @metrics[key] = val
  end

  def [](key)
    @metrics[key]
  end

  def clear
    @metrics.clear
  end

  ##
  # create a splunk-friendly representation of the hash:
  # tuples joined with equals and separated by spaces
  def to_s
    @metrics.sort.map do |key, val|
      klass = val.class
      if klass == Float
        # ruby likes to output small floats in scientific notation, but we don't
        val = sprintf('%0.6f', val)
      elsif klass == String
        # escape quotes
        val.gsub!('"', '\"')
        # quote strings that have spaces
        val = "\"#{val}\"" if val.index(' ') || val.empty?
      elsif klass == NilClass
        val = '""'
      end
      "#{key}=#{val}"
    end.join(' ')
  end
end
