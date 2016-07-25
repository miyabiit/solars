'use strict';

angular.module('solarwebApp')
  .controller('FacilityCtrl', function ($scope, $http, Auth, User) {
    $scope.facilities = [];

		$http.get('/api/facilities/type/MegasolarFacility').success(function(facilities){
			$scope.facilities = facilities;
		});

    $scope.save_facility = function(facility) {
      $http.put('/api/facilities/' + facility._id, facility).success(function(result){
        facility.unit_price = result.unit_price;
        facility.isEdit = false;
      });
    };

    $scope.cancel_facility = function(facility) {
      $http.get('/api/facilities/' + facility._id, facility).success(function(result){
        facility.unit_price = result.unit_price;
        facility.isEdit = false;
      });
    }

    $scope.edit_facility = function(facility) {
      if (facility.isEdit === undefined || facility.isEdit == false) {
        facility.isEdit = true;
      } else {
        facility.isEdit = false
      }
    }

		$http.get('/api/equipments').success(function(equipments){
			$scope.equipments = equipments;
		});

    $scope.save_equipment = function(equipment) {
      $http.put('/api/equipments/' + equipment._id, equipment).success(function(result){
        equipment.unit_price = result.unit_price;
        equipment.isEdit = false;
      });
    };

    $scope.cancel_equipment = function(equipment) {
      $http.get('/api/equipments/' + equipment._id, equipment).success(function(result){
        equipment.unit_price = result.unit_price;
        equipment.isEdit = false;
      });
    }

    $scope.edit_equipment = function(equipment) {
      if (equipment.isEdit === undefined || equipment.isEdit == false) {
        equipment.isEdit = true;
      } else {
        equipment.isEdit = false
      }
    }

  });
