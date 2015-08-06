/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Solar = require('./solar.model');

exports.register = function(socket) {
  Solar.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Solar.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('solar:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('solar:remove', doc);
}
