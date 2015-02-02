require 'pry'
Given /I like horses/ do
  visit '/repositories'
  binding.pry
end
