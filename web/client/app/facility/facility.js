'use strict';

angular.module('solarwebApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('facility', {
        url: '/facility',
        templateUrl: 'app/facility/facility.html',
        controller: 'FacilityCtrl'
      });
  });
