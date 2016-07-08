'use strict';

angular.module('solarwebApp')
  .controller('FacilityCtrl', function ($scope, $http, Auth, User) {
    $scope.facilities = [];

		$http.get('/api/facilities').success(function(facilities){
			$scope.facilities = facilities;
		});

    $scope.save = function(facility) {
      $http.put('/api/facilities/' + facility._id, facility).success(function(result){
        facility.unit_price = result.unit_price;
        facility.isEdit = false;
      });
    };

    $scope.cancel = function(facility) {
      $http.get('/api/facilities/' + facility._id, facility).success(function(result){
        facility.unit_price = result.unit_price;
        facility.isEdit = false;
      });
    }

    $scope.edit = function(facility) {
      if (facility.isEdit === undefined || facility.isEdit == false) {
        facility.isEdit = true;
      } else {
        facility.isEdit = false
      }
    }
  });
