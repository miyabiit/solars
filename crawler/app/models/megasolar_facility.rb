# coding: utf-8
require 'mongoid'
require_relative 'facility'

class MegasolarFacility < Facility
  field   :unit_price,    type: Integer   # 単価(円/kWh)
end
