'use strict';

angular.module('solarwebApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('day', {
        url: '/day',
        templateUrl: 'app/day/day.html',
        controller: 'DayCtrl'
      });
  });