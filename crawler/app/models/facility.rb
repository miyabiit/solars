# coding: utf-8
require 'mongoid'

class Facility
  include Mongoid::Document

  field   :name,          type: String    # 発電施設名
  field   :disp_name,     type: String    # 発電施設表示名
  field   :order_num,     type: Integer   # デフォルト並び順

  before_save { self.disp_name = self.name unless self.disp_name }
end
