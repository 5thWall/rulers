require "erubis"

module Rulers
  class Controller
    attr_reader :env

    def initialize(env)
      @env = env
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
