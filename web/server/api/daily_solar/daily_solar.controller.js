'use strict';

var _ = require('lodash');
var DailySolar = require('./daily_solar.model');
var Facility = require('../facility/facility.model');
var moment = require('moment');
var csv = require('../../lib/csv_download.js');
var ObjectId = require('mongoose').Types.ObjectId;

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

  DailySolar.find(query)
              .sort({date: -1, facility_name: 1})
              .populate('facility_id')
              .exec(function(err, daily_solars) {
                if(err) { return handleError(res, err); }
                if (format == 'csv') {
                  csv.downloadCSV(
                      res,
                      {date: '日時', 'facility_id.name': '発電所', total_kwh: '発電電力量', sales: '売電金額', site_status: '障害'},
                      _.map(daily_solars, function(v){
                        v.date = moment(v.date, 'YYYYMMDD').format('YYYY/MM/DD');
                        return v;
                      }),
                      '発電所別日別集計_' + dateFrom + "-" + dateTo);
                  return;
                } else {
                  return res.json(200, daily_solars);
                }
              });

};

exports.current_eco_megane = function(req, res) {
  Facility.find({'_type': 'EcoMeganeFacility'})
          .exec(function(err, facilities) {
            if(err) { return handleError(res, err); }
            var eco_megane_facilities = _.map(facilities, function(d){return new ObjectId(d._id);});
            DailySolar.find({'date': moment().format('YYYYMMDD'), 'facility_id': {'$in': eco_megane_facilities}})
              .populate('facility_id')
              .exec(function(err, daily_solars) {
                if(err) { return handleError(res, err); }
                return res.json(200, daily_solars);
            });
          });
};

function handleError(res, err) {
  return res.send(500, err);
}
