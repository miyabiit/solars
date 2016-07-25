# coding: utf-8
require 'mongoid'

class Summary
  include Mongoid::Document

  field   :now_kw,         type: Float    # 現在の発電電力(kw)
  field   :today_kwh,      type: Integer  # 本日の発電電力量
  field   :total_kwh,      type: Float    # 積算発電電力量
  field   :site_status,    type: String   # サイト状況(正常/異常)
  field   :update_date,    type: String   # 表示更新日時(日)
  field   :update_time,    type: String   # 表示更新日時(時)
  field   :sales,          type: Integer  # 本日の売電額
  field   :date,          type: String    # 作成日(yyyymmdd)
  field   :date_time,      type: Time     # 作成日時

  field   :now_title,      type: String   # 現在の発電電力タイトル
  field   :now_unit,       type: String   # 現在の発電電力単位
  field   :total_title,    type: String   # 積算発電電力量タイトル
  field   :total_unit,     type: String   # 積算発電電力量単位
  field   :today_title,    type: String   # 本日の発電電力量タイトル
  field   :today_unit,     type: String   # 本日の発電電力量単位
  field   :site_title,     type: String   # サイト状況タイトル
  field   :update_title,   type: String   # 表示更新日時タイトル

  index({ date_time: -1 })
  index({ date: -1 })

  before_save { self.date = self.update_time.gsub(/\//, '') if self.update_time }

end
