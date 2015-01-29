ENV['RACK_ENV'] = 'test'

require_relative '../git-notifier'
require 'rspec'
require 'rack/test'
