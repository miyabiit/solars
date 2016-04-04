'use strict';

describe('Controller: SolarCtrl', function () {

  // load the controller's module
  beforeEach(module('solarwebApp'));

  var SolarCtrl, scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    SolarCtrl = $controller('SolarCtrl', {
      $scope: scope
    });
  }));

  it('should ...', function () {
    expect(1).toEqual(1);
  });
});
