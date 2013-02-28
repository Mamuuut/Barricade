
module.exports = 

  errorLogger: (err, req, res, next) ->
    console.log err.stack
    next err

  errorHandler: (err, req, res, next) ->
    res.status 500
    res.render 'error',
      title: 'Error ' + 500
      message: err
      
  notFoundHandler: (req, res, next) ->
    res.status 404
    msg = 'Not found'
    if req.accepts 'html'
      return res.render 'error',
        title: 'Error ' + 404
        message: msg
    
    if req.accepts 'json'
      return res.send { error: msg }

    res.type('txt').send msg