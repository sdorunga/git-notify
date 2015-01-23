require 'octokit'
require 'sinatra'
require 'pry'

Octokit.configure do |c|
  c.login = 'sdorunga-sb'
  c.password = 'Student3230'
end

class MyApp < Sinatra::Application
  binding.pry
  get '/hi' do
    erb Octokit.user.name
  end
end
