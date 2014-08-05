module Phase7

  class Flash
    def initialize(req)
      @flash_hash = {}

      req_cookie = req.cookies.find do |cookie|
        cookie.name == "_rails_lite_flash"
      end

      @flash_hash = JSON.parse(req_cookie.value) unless req_cookie.nil?
      @incoming_keys = @flash_hash.keys

      puts req.cookies
    end

    def [](key)
      @flash_hash[key.to_s]
    end

    def []=(key, value)
      @flash_hash[key.to_s] = value
    end

    def store_flash(res)
      remove_incoming_keys
      puts @flash_hash

      res_cookie = WEBrick::Cookie.new(
        "_rails_lite_flash",
        @flash_hash.to_json
      )

      res_cookie.path = "/"

      res.cookies << res_cookie
    end

    private

    def remove_incoming_keys
      puts @incoming_keys
      puts "In remove-incoming_keys"
      @incoming_keys.each { |key| @flash_hash.delete(key) }
    end
  end

end