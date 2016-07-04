/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Facility = require('./facility.model');

exports.register = function(socket) {
  Facility.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Facility.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('facility:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('facility:remove', doc);
}
