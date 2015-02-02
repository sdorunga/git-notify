require_relative '../../spec/spec_helper'
require 'capybara/cucumber'

Capybara.app = MyApp

class MyWorld
  include Rack::Test::Methods

  def app
    run MyApp
  end
end

World do
  MyWorld.new
end
