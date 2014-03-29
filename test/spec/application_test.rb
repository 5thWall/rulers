require_relative '../test_helper'

include Rack::Test::Methods

class TestController < Rulers::Controller
  def index
    "Hello!"
  end
end

class TestApp < Rulers::Application
  def get_controller_and_action(env)
    [TestController, 'index']
  end
end

def app
  TestApp.new
end

describe TestApp do
  describe "test_request" do
    it "Returns hello" do
      get "/example/route"

      last_response.must_be :ok?
      last_response.body.must_be :include?, "Hello"
    end
  end
end
