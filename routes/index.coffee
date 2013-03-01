
module.exports = 
  getIndex: (app) ->
    (req, res) ->
      socketioPort = app.get('config').socketio.port
      socketioBaseUrl = req.protocol + '://' + req.ip + ':' + socketioPort

      res.render 'index', 
        title: req.user.username
        socketio_base_url: socketioBaseUrl
    
  getUser: (req, res) ->
    res.json 
      name: req.user.username, 
      id: req.user.id
      victories: req.user.victories