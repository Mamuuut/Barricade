'use strict';

angular.module('drawMeAMamutApp')
.directive('drawing', function () {

  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      var bDown = false;
      var ctx = element[0].getContext('2d');

      ctx.strokeStyle = 'rgba(127,0,255,0.5)';
      ctx.lineWidth = 4;
      ctx.lineCap = 'round';

      var aoPath = [];
      var aoPos = [];

      /**
       * Draw the path on the canvas
       * @param  {Object} event - mouse event
       * @return {void}
       */
      var drawPath = function(event) {
        var canvas = event.target;
        var ctx = canvas.getContext('2d');
        ctx.clearRect ( 0 , 0 , canvas.width, canvas.height );

        for (var i = 0; i < aoPath.length; i++) {

          var aoPos = aoPath[i];

          ctx.beginPath();
          ctx.moveTo(aoPos[0].x - 0.01, aoPos[0].y - 0.01);

          for (var j = 1; j < aoPos.length; j++) {
            ctx.lineTo(aoPos[j].x, aoPos[j].y);
          };

          ctx.stroke();
          ctx.closePath();
        };
      };

      /**
       * Begin the path
       * @param  {Object} event - mouse event
       * @return {void}
       */
      var beginPath = function(event) {
        bDown = true;
        aoPos = [];
        aoPath.push(aoPos);
        addPos(event);
      };

      /**
       * End the path
       * @param  {Object} event - mouse event
       * @return {void}
       */
      var endPath = function(event) {
        if (bDown) {
          addPos(event);
          drawPath(event);
          bDown = false;
        }
      };

      /**
       * Add the mouse position to the path
       * @param  {Object} event - mouse event
       * @return {void}
       */
      var addPos = function(event) {
        aoPos.push({
          x: event.offsetX,
          y: event.offsetY
        });

        drawPath(event);
      };

      /**
       * Event listeners
       */
      element.on('mousedown', function(event) {
        beginPath(event);
      });

      element.on('mouseup', function(event) {
        if (bDown) {
          endPath(event);
        }
      });

      element.on('mouseleave', function(event) {
        if (bDown) {
          endPath(event);
        }
      });

      element.on('mouseenter', function(event) {
        if (event.which) {
          beginPath(event);
        }
      });

      element.on('mousemove', function(event) {
        if (bDown) {
          addPos(event);
        }
      });
    }
  };
});