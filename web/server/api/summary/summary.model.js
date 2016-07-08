'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var SummarySchema = new Schema({
  now_kw:         Number,  // 現在の発電電力(kw)
  today_kwh:      Number,  // 本日の発電電力量
  total_kwh:      Number,  // 積算発電電力量
  site_status:    String,  // サイト状況(正常/異常)
  update_date:    String,  // 表示更新日時
  sales:          Number,  // 本日の売電額
  date:           String,  // 作成日(yyyymmdd)
  date_time:      Date,    // 作成日時
  now_title:      String,  // 現在の発電電力タイトル
  now_unit:       String,  // 現在の発電電力単位
  total_title:    String,  // 積算発電電力量タイトル
  total_unit:     String,  // 積算発電電力量単位
  today_title:    String,  // 本日の発電電力量タイトル
  today_unit:     String,  // 本日の発電電力量単位
  site_title:     String,  // サイト状況タイトル
  update_title:   String   // 表示更新日時タイトル
});

module.exports = mongoose.model('Summary', SummarySchema);
