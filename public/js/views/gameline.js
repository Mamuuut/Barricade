// Generated by CoffeeScript 1.3.3

/*
  gameline.coffee
*/


(function() {

  define(['underscore', 'backbone'], function(_, Backbone) {
    var GameLineView;
    GameLineView = Backbone.View.extend({
      tagName: 'li',
      template: _.template($('#game-template').html()),
      initialize: function() {
        return this.playerid = this.options.playerid;
      },
      events: {
        "click .delete": "deleteGame"
      },
      render: function() {
        var params;
        params = {
          status: this.model.get('status'),
          date: this.model.getDateStr()
        };
        this.$el.html(this.template(params));
        this.updateNbPlayers();
        this.updateStatus();
        this.updateJoinBtn();
        return this.updateOpenBtn();
      },
      updateJoinBtn: function() {
        if (this.model.hasPlayer(this.playerid)) {
          return this.$('.join').hide();
        } else {
          return this.$('.join').show();
        }
      },
      updateOpenBtn: function() {
        if (this.model.hasPlayer(this.playerid)) {
          return this.$('.open').show();
        } else {
          return this.$('.open').hide();
        }
      },
      updateNbPlayers: function() {
        return this.$('.players').html(this.model.getPlayersStr());
      },
      updateStatus: function() {
        return this.$el.addClass(this.model.getStatusStr());
      },
      deleteGame: function() {
        var _this = this;
        return this.model.destroy({
          success: function(model, response) {
            return _this.$el.remove();
          }
        });
      }
    });
    return GameLineView;
  });

}).call(this);
