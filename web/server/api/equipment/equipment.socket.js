/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Equipment = require('./equipment.model');

exports.register = function(socket) {
  Equipment.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Equipment.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('equipment:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('equipment:remove', doc);
}
