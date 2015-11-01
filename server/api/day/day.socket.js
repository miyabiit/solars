/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Day = require('./day.model');

exports.register = function(socket) {
  Day.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Day.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('day:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('day:remove', doc);
}