# coding: utf-8
require 'mongoid'

class EcoMeganeHourData
  include Mongoid::Document

  belongs_to :facility  # 施設マスターID
  belongs_to :equipment # 設備マスターID

  field   :kwh,       type: Float
  field   :sales,     type: Float
  field   :date,      type: String
  field   :date_time, type: Time
  field   :raw_data,  type: Hash

  index({ date_time: -1 })
  index({ date: -1 })

  before_save { self.date = date_time.strftime('%Y%m%d') if self.date_time }

  KWH_KEY = '発電電力量（ｋＷｈ）'
  EQUIPMENT_KEY = '商品ＩＤ'
  DATE_TIME_KEY = 'データ計測日'

  def set_values
    self.equipment_id = raw_data[EQUIPMENT_KEY].gsub(/^'/, '') if raw_data[EQUIPMENT_KEY]
    self.kwh = raw_data[KWH_KEY].to_f if raw_data[KWH_KEY]
    self.sales = kwh * equipment.unit_price if kwh && equipment
    self.date_time = raw_data[DATE_TIME_KEY] if raw_data[DATE_TIME_KEY]
  end

end

