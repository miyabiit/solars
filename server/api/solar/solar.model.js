'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var SolarSchema = new Schema({
  name: String,
	today_title: String,
	today_kwh: String,
	today_unit: String,
	now_title: String,
	now_kw: String,
	now_unit: String,
	createdAt: {
		type: Date,
		default: Date.now
	}
});

module.exports = mongoose.model('Solar', SolarSchema);
