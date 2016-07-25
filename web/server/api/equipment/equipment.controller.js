'use strict';

var _ = require('lodash');
var Equipment = require('./equipment.model');

// Get list of equipments
exports.index = function(req, res) {
  Equipment.find({})
    .sort("name")
    .populate('facility_id')
    .exec(function(err, equipments) {
      if(err) { return handleError(res, err); }
      return res.json(200, equipments);
    });
};

// Get a single equipment
exports.show = function(req, res) {
  Equipment.findById(req.params.id, function (err, equipment) {
    if(err) { return handleError(res, err); }
    if(!equipment) { return res.send(404); }
    return res.json(equipment);
  });
};

// Creates a new equipment in the DB.
exports.create = function(req, res) {
  Equipment.create(req.body, function(err, equipment) {
    if(err) { return handleError(res, err); }
    return res.json(201, equipment);
  });
};

// Updates an existing equipment in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Equipment.findById(req.params.id, function (err, equipment) {
    if (err) { return handleError(res, err); }
    if(!equipment) { return res.send(404); }
    var updated = _.merge(equipment, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, equipment);
    });
  });
};

// Deletes a equipment from the DB.
exports.destroy = function(req, res) {
  Equipment.findById(req.params.id, function (err, equipment) {
    if(err) { return handleError(res, err); }
    if(!equipment) { return res.send(404); }
    equipment.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
