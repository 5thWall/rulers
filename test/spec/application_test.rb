require_relative '../test_helper'

include Rack::Test::Methods

class TestApp < Rulers::Application
end

def app
  TestApp.new
end

describe TestApp do
  describe "test_request" do
    it "Returns hello" do
      get "/"

      last_response.must_be :ok?
      last_response.body.must_be :include?, "Hello"
    end
  end
end
