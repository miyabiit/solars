angular.module('solarwebApp').filter('none', function() {
  return (function(value) {
    if (value === undefined) {
      return '--';
    }
    return value;
  });
});
