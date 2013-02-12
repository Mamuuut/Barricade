should = require 'should'

describe 'My test', ->

    it 'should run synchronously', () ->
        should.exist(true)

    it 'should run asynchronously', (next) ->
        should.exist(true)
        next()