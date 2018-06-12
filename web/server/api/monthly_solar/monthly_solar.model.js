'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var MonthlySolarSchema = new Schema({
  facility_id:   { type: Schema.Types.ObjectId, ref: 'Facility' },
  total_kwh:     Number,   // 累積発電電力量(kWh)
  sales:         Number,   // 売電額
  month:         String,   // 対象月(yyyymm)
  date_time:     Date,     // 作成日時
  site_status:   String    // 月の最終障害状況
});

module.exports = mongoose.model('MonthlySolar', MonthlySolarSchema, 'monthly_solars');
