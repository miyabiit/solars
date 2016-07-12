# coding: utf-8
require 'mongoid'

class Facility
  include Mongoid::Document

  field   :name,          type: String    # 発電施設名
end
