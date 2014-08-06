require_relative '../phase7/controller_base'
module Phase8

  class ControllerBase < Phase7::ControllerBase
    def initialize
      super
      @form_authenticity_token = SecureRandom::urlsafe_base64
    end

    attr_reader :form_authenticity_token

    def protected_from_csrf?
      puts "In protection method"
      return false if self.params[:authenticity_token].nil?
      self.params[:authenticity_token] == form_authenticity_token
    end

    def invoke_action(name)
      p "In invoke_action"
      p self.params
      p self.form_authenticity_token
      if name != :get && !protected_from_csrf?
        @res.status = 404
      end

      super(name)
    end
  end

end