'use strict';

angular.module('drawMeAMamutApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('draw', {
        url: '/draw',
        templateUrl: 'app/draw/draw.html',
        controller: 'DrawCtrl'
      });
  });