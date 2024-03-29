'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var DaySchema = new Schema({
  name: String,
  info: String,
  active: Boolean
});

module.exports = mongoose.model('Day', DaySchema);