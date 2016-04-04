'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var SummarySchema = new Schema({
  now_title: String,
	now_kw: String,
	now_unit: String,
	today_title: String,
	today_kwh: String,
	today_unit: String,
	total_title: String,
	total_kwh: String,
	total_unit: String,
	site_title: String,
	site_status: String,
	update_title: String,
	update_date: String,
	date_time: String
});

module.exports = mongoose.model('Summary', SummarySchema, 'summary');
