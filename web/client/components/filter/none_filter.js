angular.module('solarwebApp').filter('none', function() {
  return (function(value) {
    if (value === undefined || value === null) {
      return '--';
    }
    return value;
  });
});
