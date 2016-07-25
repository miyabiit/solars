# coding: utf-8
require 'mongoid'

class MonthlySummary
  include Mongoid::Document

  field   :total_kwh,   type: Integer      # 月の総発電電力量(kWh)
  field   :sales,       type: BigDecimal   # 月の売電額
  field   :date,        type: String       # 作成日(yyyymmdd)
  field   :date_time,   type: Time         # 作成日時

  index({ date_time: -1 })
  index({ date: -1 })

  before_save { self.date = date_time.strftime('%Y%m%d') if self.date_time }

end
