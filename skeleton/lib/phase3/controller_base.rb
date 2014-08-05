require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      view_path = self.class.name.underscore

      template = File.read("views/#{view_path}/#{template_name}.html.erb")
      erb_template = ERB.new(template).result(binding)

      self.render_content(erb_template, "text/html")
    end
  end
end
