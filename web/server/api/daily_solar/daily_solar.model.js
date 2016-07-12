'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var DailySolarSchema = new Schema({
  facility_id:   { type: Schema.Types.ObjectId, ref: 'Facility' },
  total_kwh:     Number,   // 日の総発電電力量(kWh)
  avg_kw:        Number,   // 日の平均発電電力(kw)
  avg_sun:       Number,   // 日の平均日照強度(kw/㎡)
  avg_temp:      Number,   // 日の平均外気温度(℃)
  site_status:   String,   // 日の最終障害状況
  sales:         Number,   // 日の売電額
  date:          String,   // 作成日(yyyymmdd)
  date_time:     Date      // 作成日時
});

module.exports = mongoose.model('DailySolar', DailySolarSchema, 'daily_solars');
