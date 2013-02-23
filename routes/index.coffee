
module.exports = 
  getIndex: (req, res) ->
    res.render 'index', 
      title: 'Welcome ' + req.user.username
    
  getUser: (req, res) ->
    res.json 
      name: req.user.username, 
      id: req.user.id