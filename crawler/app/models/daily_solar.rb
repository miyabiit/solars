# coding: utf-8
require 'mongoid'
require_relative 'number_decimal'

class DailySolar
  include Mongoid::Document

  belongs_to :facility, optional: true  # 発電施設マスターID

  field   :total_kwh,     type: NumberDecimal    # 日の総発電電力量(kWh)
  field   :site_status,   type: String           # 日の最終障害状況
  field   :sales,         type: NumberDecimal    # 日の売電額
  field   :date,          type: String           # 作成日(yyyymmdd)
  field   :date_time,     type: Time             # 作成日時
  field   :facility_name, type: String           # 発電施設名

  index({ date_time: -1 })
  index({ date: -1 })

  before_save {
    self.date = date_time.strftime('%Y%m%d') if self.date_time
    self.facility_name = facility.name if self.facility
  }

end
