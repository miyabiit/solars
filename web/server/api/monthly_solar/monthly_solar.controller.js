'use strict';

var MonthlySolar = require('./monthly_solar.model');
var moment = require('moment');

exports.index = function(req, res) {
  var format = req.params.format;
  var monthFrom = req.query.from;
  var monthTo = req.query.to;
  if (!monthFrom && !monthTo) {
    var currentTime = moment();
    monthFrom = currentTime.format('YYYYMM');
    monthTo = currentTime.format('YYYYMM');
  }
  var query = {month: {}};
  if (monthFrom) {
    query.month.$gte = monthFrom
  }
  if (monthTo) {
    query.month.$lte = monthTo
  }
  if (req.query.facility_id) {
    query.facility_id = req.query.facility_id
  }

  MonthlySolar.find(query)
              .sort({month: -1})
              .exec(function(err, monthly_solars) {
                if(err) { return handleError(res, err); }
                return res.json(200, monthly_solars);
              });
};

function handleError(res, err) {
  return res.send(500, err);
}
