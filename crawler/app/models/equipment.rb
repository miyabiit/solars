# coding: utf-8
require 'mongoid'

class Equipment
  include Mongoid::Document

  field   :name,          type: String    # 発電設備名
  field   :unit_price,    type: Float     # 単価(円/kWh)

  # custom id
  field   :self_id,       type: String

  field   :_id, type: String, overwrite: true, default: ->{ self_id }

  belongs_to :facility
end
