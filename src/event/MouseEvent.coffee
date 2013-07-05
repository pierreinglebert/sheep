class MouseEvent
  @x = 0
  @y = 0
  @type = 'click'
  constructor: (@type, @x, @y) ->
  	
module.exports = MouseEvent;