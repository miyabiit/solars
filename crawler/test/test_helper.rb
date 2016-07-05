require 'minitest/autorun'
require 'nokogiri'
require 'mongoid'

AppRoute = Pathname.new(File.expand_path(File.dirname(__FILE__) + '/..'))
AppEnv = 'test'
Mongoid.load!(AppRoute.join('config', 'mongoid.yml'), AppEnv)
Mongoid::Clients.default.database.drop
