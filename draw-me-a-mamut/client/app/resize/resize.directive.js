'use strict';

angular.module('drawMeAMamutApp')
  .directive('resize', function ($window) {

    /**
     * Resize the Element to its parent size
     * @param  {Element} element - element to resize
     * @return {void}
     */
    var onResize = function(element) {
        element.attr('width', element.parent().innerWidth());
        element.attr('height',element.parent().innerHeight());
    }

    return {
      restrict: 'A',
      link: function (scope, element, attrs) {
        onResize(element);

        angular.element($window).on('resize', function()
        {
            onResize(element);
        });
      }
    };
  });