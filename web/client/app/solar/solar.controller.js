'use strict';

angular.module('solarwebApp')
  .controller('SolarCtrl', function ($scope, $http) {
		$scope.solars = [];
		$scope.summary = [];
		$scope.total_today_amount = 0;

		$http.get('/api/solars').success(function(solars){
			var total = 0;
			solars.forEach(function(sol){
				if(sol.name == "宝塚市境野（500kW）"){
					sol.amount = sol.today_kwh * 40;
				}else if(sol.name == "岩槻区長宮物流センタ（929kW）"){
					sol.amount = sol.today_kwh * 40;
				}else{
					sol.amount = sol.today_kwh * 36;
				}
				total += sol.amount;
				sol.amount_str = String(sol.amount).replace(/(\d)(?=(\d\d\d)+(?!\d))/g,'$1,');
			});
			$scope.total_today_amount = String(total).replace(/(\d)(?=(\d\d\d)+(?!\d))/g,'$1,');
			$scope.solars = solars;
		});
		$http.get('/api/summary').success(function(summary){
			$scope.summary = summary;
		});
	});
