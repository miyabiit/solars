'use strict';

angular.module('solarwebApp')
  .controller('SolarCtrl', function ($scope, $http, $interval) {
    $scope.solars = [];
    $scope.summary = [];

    var reloadData = function() {
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
    };

    $scope.autoReload = {
      value: false,
      timer: null,
      text: function() {
        return this.value ? 'ON' : 'OFF';
      },
      toggle: function() {
        this.value = !this.value;
        if (this.value) {
          this.timer = $interval(function() { 
            reloadData();
          }, 5 * 60 * 1000, 0);
        } else {
          if (this.timer !== null) {
            $interval.cancel(this.timer);
          }
        }
      }
    };

    reloadData();
  });
