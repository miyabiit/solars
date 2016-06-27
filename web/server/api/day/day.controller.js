'use strict';

var _ = require('lodash');
var Summary = require('./../summary/summary.model');
var Solar = require('./../solar/solar.model');

// Get list of days
exports.index = function(req, res) {
	Summary.find({'status':'day'}, function(err, summary){
		if(err){ return handleError(res, err); }
		return res.json(200, summary);
	});
};

// Get list of days of any month
exports.month = function(req, res) {
	console.log(req.params.ym + '*');
	var re = new RegExp(req.params.ym);
	Solar.find({'status' : 'day','date_time' : re }, function (err, solars) {
	//Solar.find({'status' : 'day' , 'date_time' : /201508/ }, function (err, solars) {
		if(err) { return handleError(res, err); }
    return res.json(200, solars);
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
