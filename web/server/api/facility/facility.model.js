'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var FacilitySchema = new Schema({
  name:           String,   // 発電施設名
  _type:          String,   // 施設タイプ(メガソーラー/エコめがね)
  unit_price:     Number,   // 単価(円/kWh)
  prefecture:     String    // 県名
});

module.exports = mongoose.model('Facility', FacilitySchema);
