class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
    pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    req.request_method.downcase.to_sym == http_method
  end

  def run(req, res)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes
  end

  def add_route(pattern, method, controller_class, action_name)

    return "unacceptable pattern" if pattern != /^..([a-z]*)$\$/

    @routes < Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) { add_route(pattern, http_method,
      controller_class, action_name)}
    end
  end

  def match(req)
  end

  def run(req, res)
  end
end


#