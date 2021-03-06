noflo = require 'noflo'
ArrayableHelper = require 'noflo-helper-arrayable'

class MakeGrid extends noflo.Component
  description: 'Creates a grid or line of points'
  icon: 'crosshairs'
  constructor: ->
    ports =
      x:
        datatype: 'number'
        required: true
      y:
        datatype: 'number'
        required: true

    # OVERRIDE default to make x and y dimensional
    compute = (props) =>
      if @outPorts.point.isAttached()
        return unless props.x? and props.y?
        # Expand to grid
        if props.x instanceof Array or props.y instanceof Array
          props = expandToArray props
        @outPorts.point.send props

    ArrayableHelper @, 'point', ports, {compute}

# Make x*y array
expandToArray = (props) ->
  length = 0
  xLen = 1
  yLen = 1
  if props.x instanceof Array
    xLen = props.x.length
  if props.y instanceof Array
    yLen = props.y.length
  length = xLen*yLen
  arr = []
  for y in [0..yLen-1]
    for x in [0..xLen-1]
      obj = {}
      obj.type = 'point'
      if props.x instanceof Array
        obj.x = if props.x[x]? then props.x[x] else props.x[xLen-1]
      else
        obj.x = props.x
      if props.y instanceof Array
        obj.y = if props.y[y]? then props.y[y] else props.y[yLen-1]
      else
        obj.y = props.y
      if obj.x? and obj.y?
        arr.push obj
  return arr

exports.getComponent = -> new MakeGrid
