# coding: utf-8
require 'mongoid'

class MonthlySolar
  include Mongoid::Document

  belongs_to :facility   #   発電施設マスターID

  field   :total_kwh,     type: Integer     # 月の総発電電力量(kWh)
  field   :sales,         type: BigDecimal  # 月の売電額
  field   :month,         type: String      # 対象月(yyyymm)
  field   :date_time,     type: Time        # 作成日時
  field   :site_status,   type: String      # 月の最終障害状況

  index({ date_time: -1 })
  index({ month: -1 })
end
