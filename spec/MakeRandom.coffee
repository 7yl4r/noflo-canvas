noflo = require 'noflo'

unless noflo.isBrowser()
  chai = require 'chai' unless chai
  MakeRandom = require '../components/MakeRandom.coffee'
else
  MakeRandom = require 'noflo-canvas/components/MakeRandom.js'


describe 'MakeRandom component', ->
  c = null
  sock_min = null
  sock_max = null
  sock_count = null
  out = null

  beforeEach ->
    c = MakeRandom.getComponent()
    sock_min = noflo.internalSocket.createSocket()
    sock_max = noflo.internalSocket.createSocket()
    sock_count = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.min.attach sock_min
    c.inPorts.max.attach sock_max
    c.inPorts.count.attach sock_count
    c.outPorts.numbers.attach out

  describe 'positive min/max', ->
    it 'values should be w/in bounds', ->
      count = 10
      min = 1
      max = 100
      out.once "data", (data) ->
        for v in data
          chai.expect(v).to.be.at.most(max)
          chai.expect(v).to.be.at.least(min)
      sock_min.send min
      sock_max.send max
      sock_count.send count
    describe 'positive string min/max/count', ->
      it 'values should be w/in bounds', ->
        # must pass this test to work in noflo-ui
        count = "10"
        min = '1'
        max = '100'
        out.once "data", (data) ->
          for v in data
            chai.expect(v).to.be.at.most(max)
            chai.expect(v).to.be.at.least(min)
        sock_min.send min
        sock_max.send max
        sock_count.send count
