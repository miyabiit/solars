'use strict';

var express = require('express');
var controller = require('./daily_solar.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/download/:format', controller.index);
router.get('/eco_megane/current', controller.current_eco_megane);

module.exports = router;
