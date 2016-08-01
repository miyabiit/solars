'use strict';

var _ = require('lodash');
var DailySummary = require('./daily_summary.model');
var moment = require('moment');
var csv = require('../../lib/csv_download.js');

exports.index = function(req, res) {
  var format = req.params.format;
  var dateFrom = req.query.from;
  var dateTo = req.query.to;
  if (!dateFrom && !dateTo) {
    var currentTime = moment();
    dateFrom = currentTime.format('YYYYMMDD');
    dateTo = currentTime.format('YYYYMMDD');
  }
  var query = {date: {}};
  if (dateFrom) {
    query.date.$gte = dateFrom
  }
  if (dateTo) {
    query.date.$lte = dateTo
  }

  DailySummary.find(query)
              .sort({date: -1})
              .exec(function(err, daily_summaries) {
                if(err) { return handleError(res, err); }
                if (format == 'csv') {
                  csv.downloadCSV(
                      res,
                      {date: '日時', total_kwh: '発電電力量', sales: '売電金額'},
                      _.map(daily_summaries, function(v){
                        v.date = moment(v.date, 'YYYYMMDD').format('YYYY/MM/DD');
                        return v;
                      }),
                      '発電所合計日別集計_' + dateFrom + "-" + dateTo);
                  return;
                } else {
                  return res.json(200, daily_summaries);
                }
              });
};

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
