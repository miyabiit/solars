/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var DailySolar = require('./daily_solar.model');

exports.register = function(socket) {
  DailySolar.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  DailySolar.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('daily_solar:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('daily_solar:remove', doc);
}
