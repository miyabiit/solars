angular.module('solarwebApp').filter('date_slash', function() {
  return (function(value) {
    return moment(value, 'YYYYMMDD').format('YYYY/MM/DD');
  });
});
