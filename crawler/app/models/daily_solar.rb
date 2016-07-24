# coding: utf-8
require 'mongoid'

class DailySolar
  include Mongoid::Document

  belongs_to :facility   # 発電施設マスターID
  belongs_to :megasolar_facility   # 発電施設マスターID
  belongs_to :eco_megane_facility   # 発電施設マスターID

  field   :total_kwh,     type: Integer   # 日の総発電電力量(kWh)
  field   :site_status,   type: String    # 日の最終障害状況
  field   :sales,         type: Integer   # 日の売電額
  field   :date,          type: String    # 作成日(yyyymmdd)
  field   :date_time,     type: Time      # 作成日時

  index({ date_time: -1 })
  index({ date: -1 })

  before_save { self.date = date_time.strftime('%Y%m%d') if self.date_time }

end
