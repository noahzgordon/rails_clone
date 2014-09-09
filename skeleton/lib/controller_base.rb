require 'active_support/core_ext'
require 'erb'

require_relative "./url_helper.rb"

class ControllerBase
  extend UrlHelper

  attr_reader :req, :res, :params, :form_authenticity_token

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = Params.new(req, route_params)

    @form_authenticity_token = SecureRandom::urlsafe_base64

    @already_built_response = false
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "Can not build two responses!" if already_built_response?

    @res.status = 302
    @res.header["location"] = url

    session.store_session(@res)
    flash.store_flash(@res)
    @already_built_response = true
  end

  def render_content(content, type)
    raise "Can not build two responses!" if already_built_response?

    @res.body = content
    @res.content_type = type

    session.store_session(@res)
    flash.store_flash(@res)
    @already_built_response = true
  end

  def render(template_name)
    view_path = self.class.name.underscore

    template = File.read("skeleton/views/#{view_path}/#{template_name}.html.erb")
    erb_template = ERB.new(template).result(binding)

    form_finder = /<form.*\>(.|\s)*\<\/form\>/
    store_auth_token if !!form_finder.match(erb_template)

    self.render_content(erb_template, "text/html")
  end

  def invoke_action(name)
    if !!@req.body && !protected_from_csrf?
      @res.status = 403
      render_content("403: Don't hack me, bro!", "text/html")
    else
      self.send(name)
      render name unless already_built_response?
    end
  end

  def protected_from_csrf?
    self.params[:authenticity_token] == session[:authenticity_token]
  end

  def store_auth_token
    session[:authenticity_token] = form_authenticity_token
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end
end