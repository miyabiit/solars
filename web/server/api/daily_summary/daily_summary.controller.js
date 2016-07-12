'use strict';

var _ = require('lodash');
var DailySummary = require('./daily_summary.model');
var moment = require('moment');

exports.current = function(req, res) {
  DailySummary.findOne({'date': moment().format('YYYYMMDD')})
         .exec(function (err, daily_summary) {
    if(err) { return handleError(res, err); }
    if(!daily_summary) { return res.send(404); }
    return res.json(200, daily_summary);
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
