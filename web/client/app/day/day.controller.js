'use strict';

angular.module('solarwebApp')
  .controller('DayCtrl', function ($scope, $http) {
		$scope.solars = [];
		$scope.summary = [];

		$http.get('/api/days/month/201508').success(function(solars){
			$scope.solars = solars;
		});
		
		$http.get('/api/days').success(function(summaries){
			$scope.summary = summaries;
		});
	});
