require_relative '../phase6/controller_base'
require_relative '../phase6/router'
require_relative './flash'

module Phase7

  class ControllerBase < Phase6::ControllerBase
    def redirect_to(url)
      super(url)
      flash.store_flash(@res)
    end

    def render_content(content, type)
      super(content, type)
      flash.store_flash(@res)
    end

    def flash
      @flash ||= Flash.new(@req)
    end
  end

end