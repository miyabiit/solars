'use strict';

var express = require('express');
var controller = require('./day.controller');

var router = express.Router();

router.get('/', controller.index);
router.get('/month/:ym', controller.month);

module.exports = router;
