'use strict';

describe('Controller: DayCtrl', function () {

  // load the controller's module
  beforeEach(module('solarwebApp'));

  var DayCtrl, scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    DayCtrl = $controller('DayCtrl', {
      $scope: scope
    });
  }));

  it('should ...', function () {
    expect(1).toEqual(1);
  });
});
