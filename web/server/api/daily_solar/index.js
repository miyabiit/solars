'use strict';

var express = require('express');
var controller = require('./daily_solar.controller');

var router = express.Router();

router.get('/eco_megane/current', controller.current_eco_megane);

module.exports = router;
