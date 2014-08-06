require 'json'
require 'webrick'


class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @cookie = req.cookies.find do |cookie|
      cookie.name == "_rails_lite_app"
    end

    @value = @cookie.nil? ? {} : JSON.parse(@cookie.value)
  end

  def [](key)
    @value[key]
  end

  def []=(key, val)
    @value[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res_cookie =  WEBrick::Cookie.new(
      "_rails_lite_app",
      @value.to_json
    )

    res_cookie.path = "/"
    res.cookies << res_cookie
  end
end
