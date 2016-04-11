'use strict';

angular.module('solarwebApp')
  .controller('SolarCtrl', function ($scope, $http, $state, $timeout) {
		$scope.solars = [];
		$scope.summary = [];
		$scope.total_today_amount = 0;
		$scope.datetime_str = '';

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
				if(isNaN(sol.amount)){
					total += 0;
					sol.amount_str = '--';
				}else{
					total += parseInt(sol.amount,10);
					sol.amount_str = String(parseInt(sol.amount,10)).replace(/(\d)(?=(\d\d\d)+(?!\d))/g,'$1,');
				}
			});
			$scope.total_today_amount = String(total).replace(/(\d)(?=(\d\d\d)+(?!\d))/g,'$1,');
			$scope.solars = solars;
		});
		$http.get('/api/summary').success(function(summary){
			$scope.summary = summary;
			var t = '';
			summary.forEach(function(sum){
				t = sum.date_time;
			});
			$scope.datetime_str = t.substr(0,4) + '/' + t.substr(4,2) + '/' + t.substr(6,2) + ' ' + t.substr(8,2) + ':' + t.substr(10,2);
		});
    // 5分間隔で画面リロード
    $scope.startTimer = function() {
      $timeout(function() {
        $state.reload();
      }, 5 * 60 * 1000);
    }
	});
