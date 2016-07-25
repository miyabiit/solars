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
		$http.get('/api/daily_solars/eco_megane/current').success(function(eco_megane_solars){
			$scope.eco_megane_solars = eco_megane_solars;
		});
		$http.get('/api/daily_summaries/current').success(function(daily_summary){
			$scope.daily_summary = daily_summary;
		});
	});
