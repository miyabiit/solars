# coding: utf-8
require 'mongoid'

class DailySolar
  include Mongoid::Document

  belongs_to :facility   # 発電施設マスターID

  field   :total_kwh,     type: Integer   # 日の総発電電力量(kWh)
  field   :avg_kw,        type: Float     # 日の平均発電電力(kw)
  field   :avg_sun,       type: Float     # 日の平均日照強度(kw/㎡)
  field   :avg_temp,      type: Float     # 日の平均外気温度(℃)
  field   :site_status,   type: String    # 日の最終障害状況
  field   :sales,         type: Integer   # 日の売電額
  field   :date,          type: String    # 作成日(yyyymmdd)
  field   :date_time,     type: Time      # 作成日時

  index({ date_time: -1 })
  index({ date: -1 })

  before_save { self.date = date_time.strftime('%Y%m%d') if self.date_time }

end
