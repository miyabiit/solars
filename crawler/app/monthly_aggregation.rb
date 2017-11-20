# -*- coding: utf-8 -*-

require 'mongo'

require 'active_support'
require 'active_support/core_ext'

AppRoute ||= Pathname.new(File.expand_path(File.dirname(__FILE__) + "/.."))

def load_app_libraries(load_paths)
  load_paths.each do |load_path|
    Dir[AppRoute.join(load_path).to_s + '/*.rb'].each do |path|
      require path
    end
  end
end
load_app_libraries ['app/models', 'app/lib']

if $0 === __FILE__
  AppEnv = ENV['APP_ENV'].presence || 'development'
  Mongoid.load!(AppRoute.join('config', 'mongoid.yml'), AppEnv)

  MonthlyAggregator.new(Time.now).aggregate
end
