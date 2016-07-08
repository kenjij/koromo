require 'json'

module Koromo

  module Helper

    # Convert object into JSON, optionally pretty-format
    # @param obj [Object] any Ruby object
    # @param opts [Hash] any JSON options
    # @return [String] JSON string
    def json_with_object(obj, pretty: nil, opts: nil)
      return '{}' if obj.nil?
      pretty ||= Koromo.config[:global][:pretty_json]
      if pretty
        opts = {
          indent: '  ',
          space: ' ',
          object_nl: "\n",
          array_nl: "\n"
        }
      end
      JSON.fast_generate(json_format_value(obj), opts)
    end

    # Return Ruby object/value to JSON standard format
    # @param val [Object]
    # @return [Object]
    def json_format_value(val)
      case val
      when Array
        val.map { |v| json_format_value(v) }
      when Hash
        val.reduce({}) { |h, (k, v)| h.merge({k => json_format_value(v)}) }
      when BigDecimal
        # val.to_s('F')
        val.to_f
      when String
        val.encode!('UTF-8', {invalid: :replace, undef: :replace})
      when Time
        val.utc.iso8601
      else
        val
      end
    end

    def valid_token?(token, method = :any)
      tokens = Koromo.config[:global][:auth_tokens][method]
      return true if tokens.nil?
      tokens.include?(token)
    end

  end

end
