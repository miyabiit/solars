'use strict';

angular.module('solarwebApp')
  .controller('SolarCtrl', function ($scope, $http) {
		$scope.solars = [];
		$scope.summary = [];

		$http.get('/api/solars').success(function(solars){
			$scope.solars = solars;
		});
		$http.get('/api/summary').success(function(summary){
			$scope.summary = summary;
		});
	});
