/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var DailySummary = require('./daily_summary.model');

exports.register = function(socket) {
  DailySummary.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  DailySummary.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('daily_summary:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('daily_summary:remove', doc);
}
