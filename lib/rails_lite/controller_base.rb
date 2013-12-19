require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params, :req, :res

  # setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(@req, route_params)
    @already_built_response = false
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    raise "already rendered" if already_rendered?
    session.store_session(@res)
    @res.body = content
    @res.content_type = type
    @already_built_response = true
  end

  # helper method to alias @already_rendered
  def already_rendered?
    @already_built_response
  end

  # set the response status code and header
  def redirect_to(url)
    raise "already rendered" if already_rendered?
    @already_built_response = true
    session.store_session(@res)
    @res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect, url)

  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.underscore
    f = File.read("views/#{controller_name}/#{template_name}.html.erb")
    template = ERB.new(f)
    b = binding
    content = template.result(b)

    render_content(content, "text")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    unless already_rendered?
      render Router.send(name)
    end
  end
end






























