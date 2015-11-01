'use strict';

angular.module('solarwebApp')
  .controller('DayCtrl', function ($scope, $http) {
		$scope.summary = [];
		$scope.datetime_str = '';
		
		$http.get('/api/days').success(function(summaries){
			var total = 0;
			$scope.summary = summaries;
		});
	});
