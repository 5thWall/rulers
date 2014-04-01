require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

module Rulers
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      elsif env['PATH_INFO'] == '/'
        env['PATH_INFO'] = '/home/index'
      end

      klass, action = get_controller_and_action(env)
      controller = klass.new(env)
      controller.send(action)

      if controller.response
        controller.response.finish
      else
        controller.render(action)
        controller.response.finish
      end
    end
  end
end
