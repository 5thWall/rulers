require "rulers/version"
require "rulers/routing"

module Rulers
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      elsif env['PATH_INFO'] == '/'
        env['PATH_INFO'] = '/home/index'
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)

      begin
        text = controller.send(act)
        [200, {'Content-Type' => 'text/html'},
         [text]]
      rescue Exception => e
        [500, {'Content-Type' => 'text/html'}, [e.message]]
      end
    end
  end

  class Controller
    attr_reader :env

    def initialize(env)
      @env = env
    end
  end
end
