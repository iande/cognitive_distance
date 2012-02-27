if ENV['SCOV']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'minitest/autorun'
require 'minitest/emoji'
require File.expand_path('../spec_stubbing', __FILE__)
require File.expand_path('../spec_dummies', __FILE__)
require 'cognitive_distance'

