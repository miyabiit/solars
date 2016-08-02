'use strict';

var _ = require('lodash');
var Solar = require('./solar.model');
var moment = require('moment');

// Get list of solars
exports.index = function(req, res) {
  Solar.findOne({'date': moment().format('YYYYMMDD')})
         .sort('-date_time') 
         .exec(function (err, solar) {
    if(err) { return handleError(res, err); }
    if(!solar) { return res.send(404); }
    Solar.find({date_time: solar.date_time})
            .populate('facility_id')
            .exec(function(err, solars) {
      if(err) { return handleError(res, err); }
      solars = _.sortBy(solars, ['facility_id.order_num', 'facility_id.disp_name', 'name']);
      return res.json(200, solars);
    });
  });
};

// Get a single solar
exports.show = function(req, res) {
  Solar.findById(req.params.id, function (err, solar) {
    if(err) { return handleError(res, err); }
    if(!solar) { return res.send(404); }
    return res.json(solar);
  });
};

// Creates a new solar in the DB.
exports.create = function(req, res) {
  Solar.create(req.body, function(err, solar) {
    if(err) { return handleError(res, err); }
    return res.json(201, solar);
  });
};

// Updates an existing solar in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Solar.findById(req.params.id, function (err, solar) {
    if (err) { return handleError(res, err); }
    if(!solar) { return res.send(404); }
    var updated = _.merge(solar, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, solar);
    });
  });
};

// Deletes a solar from the DB.
exports.destroy = function(req, res) {
  Solar.findById(req.params.id, function (err, solar) {
    if(err) { return handleError(res, err); }
    if(!solar) { return res.send(404); }
    solar.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
