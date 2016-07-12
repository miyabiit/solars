'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var DailySummarySchema = new Schema({
  total_kwh:     Number,   // 累積発電電力量(kWh)
  sales:         Number,   // 売電額
  date:          String,   // 作成日(yyyymmdd)
  date_time:     Date      // 作成日時
});

module.exports = mongoose.model('DailySummary', DailySummarySchema, 'daily_summaries');
