'use strict';

var _ = require('lodash');
var jconv = require('jconv');

exports.downloadCSV = function (res, header, data, fileName) {  
  res.setHeader('Content-disposition', 'attachment; filename*=UTF-8\'\'' + encodeURIComponent( fileName + '.csv' ));
  res.setHeader('Content-Type', 'text/csv; charset=Shift_JIS');
  var headerStr = _.map(_.values(header), function(v){return '"' + v.replace(/"/g, '""') + '"'}).join(',');
  res.write(jconv.convert(headerStr, 'UTF8', 'SJIS'));
  res.write("\r\n");

  _.forEach(data, function(value) {
    var dataStr = _.map(header, function(headerValue, headerKey) {
      var keys = headerKey.split('.');
      var dataValue = value;
      while (keys.length > 0 && dataValue) {
        var k = keys.shift();
        dataValue = dataValue[k];
      }
      if (dataValue) {
        dataValue = '"' + dataValue.toString().replace(/"/g, '""') + '"';
      } else {
        dataValue = "";
      }
      return dataValue;
    }).join(',');
    res.write(jconv.convert(dataStr, 'UTF8', 'SJIS'));
    res.write("\r\n");
  });

  res.end();
};
