'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var EquipmentSchema = new Schema({
  _id: String,
  self_id: String,
  facility_id:   { type: Schema.Types.ObjectId, ref: 'Facility' },
  name:           String,   // 発電設備名
  unit_price:     Number    // 単価(円/kWh)
});

module.exports = mongoose.model('Equipment', EquipmentSchema);
