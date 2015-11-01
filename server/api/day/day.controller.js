'use strict';

var _ = require('lodash');
var Day = require('./day.model');
var Summary = require('./../summary/summary.model');

// Get list of days
exports.index = function(req, res) {
	Summary.find({'status':'day'}, function(err, summary){
		if(err){ return handleError(res, err); }
		return res.json(200, summary);
	});
};

// Get a single day
exports.show = function(req, res) {
  Day.findById(req.params.id, function (err, day) {
    if(err) { return handleError(res, err); }
    if(!day) { return res.send(404); }
    return res.json(day);
  });
};

// Creates a new day in the DB.
exports.create = function(req, res) {
  Day.create(req.body, function(err, day) {
    if(err) { return handleError(res, err); }
    return res.json(201, day);
  });
};

// Updates an existing day in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Day.findById(req.params.id, function (err, day) {
    if (err) { return handleError(res, err); }
    if(!day) { return res.send(404); }
    var updated = _.merge(day, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, day);
    });
  });
};

// Deletes a day from the DB.
exports.destroy = function(req, res) {
  Day.findById(req.params.id, function (err, day) {
    if(err) { return handleError(res, err); }
    if(!day) { return res.send(404); }
    day.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
