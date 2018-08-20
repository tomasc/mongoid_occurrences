$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "bundler/setup"
require "minitest"
require "minitest/autorun"
require "minitest/spec"

require "mongoid_occurrence_views"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO
