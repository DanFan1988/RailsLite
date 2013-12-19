require 'uri'

class Params
  def initialize(req, route_params = {})
    @params = {}

    if req.body
      parse_www_encoded_form(req.body)
    end

    if req.query_string
      parse_www_encoded_form(req.query_string)
    end

    p @params

  end

  def [](key)
  end

  def to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    decoded_arrays = URI.decode_www_form(www_encoded_form)

    temp = {}

    decoded_arrays.map do |array|
      temp[array[0]] = array[1]
    end

    temp.each do |key, val|
      magic_hash = @params
      black_magic = parse_key(key)
      last_val = val

      black_magic.each_with_index do |el, idx|
        if idx == black_magic.count-1
          magic_hash[el] = last_val
        else
          magic_hash[el] ||= {}
          magic_hash = magic_hash[el]
        end
      end
      @params.merge!(magic_hash)
    end
  end

  def parse_key(key)
    keys = key.split(/\]\[|\[|\]/)

    # keys.count-1.times do |i|
    #   p keys[i]
    #   p keys[i+1]
    #   @params[keys[i]] = [keys][i+1]
    # end
  end
end
