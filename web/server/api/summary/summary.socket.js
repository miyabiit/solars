/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Summary = require('./summary.model');

exports.register = function(socket) {
  Summary.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Summary.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('summary:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('summary:remove', doc);
}