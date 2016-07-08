'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var SolarSchema = new Schema({
  today_kwh:     Number,   // 本日の発電電力量(kWh)
  now_kw:        Number,   // 現在の発電電力(kw)
  sun_value:     Number,   // 日照強度(kw/㎡)
  temp_value:    Number,   // 外気温度(℃)
  site_status:   String,   // サイト状況(正常/異常)
  sales:         Number,   // 売電額
  date:          String,   // 作成日(yyyymmdd)
  date_time:     Date,     // 作成日時
  today_title:   String,   // 本日の発電電力量量タイトル
  today_unit:    String,   // 本日の発電電力量単位
  name:          String,   // 発電施設名
  now_title:     String,   // 現在の発電電力タイトル
  now_unit:      String,   // 現在の発電電力量単位
  sun_title:     String,   // 日照強度タイトル
  sun_unit:      String,   // 日照強度単位
  temp_title:    String,   // 外気温度タイトル
  temp_unit:     String,   // 外気温度単位
  site_title:    String    // サイト状況タイトル
});

module.exports = mongoose.model('Solar', SolarSchema);
