'use strict';

var express = require('express');
var controller = require('./daily_summary.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/download/:format', controller.index);
router.get('/current', controller.current);

module.exports = router;
