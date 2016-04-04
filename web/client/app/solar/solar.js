'use strict';

angular.module('solarwebApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('solar', {
        url: '/solar',
        templateUrl: 'app/solar/solar.html',
        controller: 'SolarCtrl'
      });
  });