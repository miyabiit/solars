'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var FacilitySchema = new Schema({
  name:           String,   // 発電施設名
  unit_price:     Number    // 単価(円/kWh)
});

module.exports = mongoose.model('Facility', FacilitySchema);
