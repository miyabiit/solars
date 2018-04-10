# coding: utf-8
require 'mongoid'

class Solar
  include Mongoid::Document

  belongs_to :facility, optional: true  # 発電施設マスターID

  field   :today_kwh,     type: Integer   # 本日の発電電力量(kWh)
  field   :now_kw,        type: Float     # 現在の発電電力(kw)
  field   :sun_value,     type: Float     # 日照強度(kw/㎡)
  field   :temp_value,    type: Float     # 外気温度(℃)
  field   :site_status,   type: String    # サイト状況(正常/異常)
  field   :sales,         type: Integer   # 売電額
  field   :date,          type: String    # 作成日(yyyymmdd)
  field   :date_time,     type: Time      # 作成日時

  field   :today_title,   type: String    # 本日の発電電力量量タイトル
  field   :today_unit,    type: String    # 本日の発電電力量単位
  field   :name,          type: String    # 発電施設名
  field   :now_title,     type: String    # 現在の発電電力タイトル
  field   :now_unit,      type: String    # 現在の発電電力量単位
  field   :sun_title,     type: String    # 日照強度タイトル
  field   :sun_unit,      type: String    # 日照強度単位
  field   :temp_title,    type: String    # 外気温度タイトル
  field   :temp_unit,     type: String    # 外気温度単位
  field   :site_title,    type: String    # サイト状況タイトル

  index({ date_time: -1 })
  index({ date: -1 })

  before_save { self.date = date_time.strftime('%Y%m%d') if self.date_time }

  def set_sales
    self.sales = today_kwh * facility.unit_price if today_kwh && facility
  end

end

