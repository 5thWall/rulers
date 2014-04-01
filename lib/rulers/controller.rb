require "rack/request"
require "erubis"
require "rulers/file_model"

module Rulers
  class Controller
    include Rulers::Model

    attr_reader :env

    def initialize(env)
      @env = env
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params
    end

    def response(text, status: 200, headers: {})
      raise "Already responded!" if @response
      body = Array(text)
      @response = Rack::Response.new(body, status, headers)
    end

    def get_response
      @response
    end

    def render_response(*args)
      response(render(*args))
    end

    def render(view_name, locals = {})
      filename = File.join 'app', 'views',
        controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)

      eruby.result locals.merge(instance_vars_hash).merge(env: env)
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ''

      Rulers.to_snake_case(klass)
    end

    private

    def instance_vars_hash
      self.instance_variables.reduce({}) do |hash, var|
        hash.merge(var => self.instance_variable_get(var))
      end
    end
  end
end
