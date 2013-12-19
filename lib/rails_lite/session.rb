require 'json'
require 'webrick'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req

    @req.cookies.each do |cookie|
      if cookie.name == "__rails_lite_app"
        p @monster = JSON.parse(cookie.value)
      else
        p @monster = Hash.new
      end
    end
  end

  def [](key)
    @monster[key]
  end

  def []=(key, val)
    @monster[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    cookie = WEBrick::Cookie.new("__rails_lite_app", @monster.to_json)
    res.cookies << cookie
  end
end
