# coding: utf-8
require 'mongoid'
require_relative 'number_decimal'

class MonthlySummary
  include Mongoid::Document

  field   :total_kwh,   type: NumberDecimal # 月の総発電電力量(kWh)
  field   :sales,       type: NumberDecimal # 月の売電額
  field   :month,       type: String        # 対象月(yyyymm)
  field   :date_time,   type: Time          # 作成日時

  index({ date_time: -1 })
  index({ month: -1 })
end
