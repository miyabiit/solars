'use strict';

var _ = require('lodash');
var Summary = require('./summary.model');

// Get list of summary
exports.index = function(req, res) {
  Summary.find({'status':'last'}, function (err, summary) {
    if(err) { return handleError(res, err); }
    return res.json(200, summary);
  });
};

// Get list of day summary
exports.days = function(req, res) {
	Summary.find({'status':'day'}, function(err, summary){
		if(err){ return handleError(res, err); }
		return res.json(200, summary);
	});
};

// Get a single summary
exports.show = function(req, res) {
  Summary.findById(req.params.id, function (err, summary) {
    if(err) { return handleError(res, err); }
    if(!summary) { return res.send(404); }
    return res.json(summary);
  });
};

// Creates a new summary in the DB.
exports.create = function(req, res) {
  Summary.create(req.body, function(err, summary) {
    if(err) { return handleError(res, err); }
    return res.json(201, summary);
  });
};

// Updates an existing summary in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Summary.findById(req.params.id, function (err, summary) {
    if (err) { return handleError(res, err); }
    if(!summary) { return res.send(404); }
    var updated = _.merge(summary, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, summary);
    });
  });
};

// Deletes a summary from the DB.
exports.destroy = function(req, res) {
  Summary.findById(req.params.id, function (err, summary) {
    if(err) { return handleError(res, err); }
    if(!summary) { return res.send(404); }
    summary.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
