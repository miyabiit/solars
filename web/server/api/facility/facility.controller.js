'use strict';

var _ = require('lodash');
var Facility = require('./facility.model');

// Get list of facilities
exports.index = function(req, res) {
  Facility.find({})
    .sort("name")
    .exec(function(err, facilities) {
      if(err) { return handleError(res, err); }
      return res.json(200, facilities);
    });
};

// Get a single facility
exports.show = function(req, res) {
  Facility.findById(req.params.id, function (err, facility) {
    if(err) { return handleError(res, err); }
    if(!facility) { return res.send(404); }
    return res.json(facility);
  });
};

// Creates a new facility in the DB.
exports.create = function(req, res) {
  Facility.create(req.body, function(err, facility) {
    if(err) { return handleError(res, err); }
    return res.json(201, facility);
  });
};

// Updates an existing facility in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Facility.findById(req.params.id, function (err, facility) {
    if (err) { return handleError(res, err); }
    if(!facility) { return res.send(404); }
    var updated = _.merge(facility, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, facility);
    });
  });
};

// Deletes a facility from the DB.
exports.destroy = function(req, res) {
  Facility.findById(req.params.id, function (err, facility) {
    if(err) { return handleError(res, err); }
    if(!facility) { return res.send(404); }
    facility.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
