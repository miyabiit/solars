# coding: utf-8
require 'mongoid'

class DailySummary
  include Mongoid::Document

  field   :avg_kw,      type: Float     # 日の平均発電電力(kw)
  field   :total_kwh,   type: Integer   # 日の合計発電電力量(kWh)
  field   :site_status, type: String    # 日の最終障害状況
  field   :sales,       type: Integer   # 日の売電額
  field   :date,        type: String    # 作成日(yyyymmdd)
  field   :date_time,   type: Time      # 作成日時

  index({ date_time: -1 })
  index({ date: -1 })

  before_save { self.date = date_time.strftime('%Y%m%d') if self.date_time }

end
