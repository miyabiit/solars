'use strict';

angular.module('solarwebApp')
  .controller('DayCtrl', function ($scope, $http) {
    $scope.daily_solars = [];
    $scope.daily_summaries = [];
    $scope.loading = false;

    $scope.selectedTab = 'summaries';
    $scope.selectTab = function(tabName) {
      $scope.selectedTab = tabName;
    };

    var currentTime = moment();
    $scope.dateFrom = {
      value: currentTime.startOf('month').format('YYYY-MM-DD'),
      pickerOpen: false,
      toggle: function($event) {
        $event.stopPropagation();
        $scope.dateFrom.pickerOpen = !$scope.dateFrom.pickerOpen;
      }
    };
    $scope.dateTo = {
      value: currentTime.endOf('month').format('YYYY-MM-DD'),
      pickerOpen: false,
      toggle: function($event) {
        $event.stopPropagation();
        $scope.dateTo.pickerOpen = !$scope.dateTo.pickerOpen;
      }
    };

    var getParams = function() {
      var params = {};
      if ($scope.dateFrom.value) {
        params.from = moment($scope.dateFrom.value).format('YYYYMMDD');
      }
      if ($scope.dateTo.value) {
        params.to = moment($scope.dateTo.value).format('YYYYMMDD');
      }
      return params;
    }

    $scope.search = function() {
      $scope.loading = true;
      var solars_loading = true;
      var summaries_loading = true;

      $http.get('/api/daily_solars', {params: getParams()}).success(function(daily_solars){
        $scope.daily_solars = daily_solars;
        solars_loading = false;
        if (!solars_loading && !summaries_loading) { $scope.loading = false;}
      });
      $http.get('/api/daily_summaries', {params: getParams()}).success(function(daily_summaries){
        $scope.daily_summaries = daily_summaries;
        summaries_loading = false;
        if (!solars_loading && !summaries_loading) { $scope.loading = false;}
      });

    };

    $scope.getCsvDownloadURL = function() {
      if ($scope.selectedTab == 'solars') {
        return '/api/daily_solars/download/csv?' + $.param(getParams());
      } else {
        return '/api/daily_summaries/download/csv?' + $.param(getParams());
      }
    };

    var first = true;

    $scope.$watch('dateFrom.value', function(newValue) {
      if (first) {
        first = false;
      } else {
        $scope.search();
      }
    });
    $scope.$watch('dateTo.value', function(newValue) {
      if (first) {
        first = false;
      } else {
        $scope.search();
      }
    });

    var genSortObj = function(defaultSelect, defaultReverse) {
      return {
        selectedColumn: defaultSelect,
        reverse: defaultReverse,
        cssClass: function(columnName) {
          if (columnName === this.selectedColumn) {
            return 'glyphicon glyphicon-chevron-' + (this.reverse ? 'up' : 'down');
          }
          return '';
        },
        toggle: function(columnName) {
          this.selectedColumn = columnName;
          this.reverse = !this.reverse;
        }
      };
    };

    $scope.summariesSort = genSortObj('date', false);
    $scope.solarsSort = genSortObj('date', false);
  });
