# coding: utf-8
require 'mongoid'

class Facility
  include Mongoid::Document

  field   :name,          type: String    # 発電施設名
  field   :unit_price,    type: Integer   # 単価(円/kWh)
end
