'use strict';

var _ = require('lodash');
var DailySolar = require('./daily_solar.model');
var Facility = require('../facility/facility.model');
var moment = require('moment');
var ObjectId = require('mongoose').Types.ObjectId;

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
