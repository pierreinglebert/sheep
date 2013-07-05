define ['jquery', 'cs!sheep/drawable/container', 'cs!sheep/util'], ($, Container, Util) ->

  class World extends Container 

    @canvas = null;
    @dirty = true;
    @lastMoveEvent = null
    @lastTreatedMoveEvent = null
    @onmousemoveId = null

    constructor: (canvas) ->
      if typeof canvas is "string"
        canvas = document.getElementById(canvas)
      self = this
      canvas.onmouseover = () ->
        canvas.onmousemove = (event) -> 
          self.lastMoveEvent = event
        self.activateMouseMove(true)
      canvas.onmouseout = () ->
        canvas.onmousemove = null
        self.activateMouseMove(false)
      
      #Si on mettait le canvas en fullscreen
      height = 0
      width = 0
      if document.all?
        width = document.body.clientWidth
        height = document.body.clientHeight
      else
        width = window.innerWidth
        height = window.innerHeight
      
      height -= ($(canvas).offset().top + 10)
      $(canvas).css('height', height + 'px')
      canvas.height = height
      
      $(canvas).css('width', width + 'px')
      canvas.width = width
      
      if canvas
        super(0, 0, canvas.width, canvas.height, null)
        @canvas = canvas
        this.invalidate(0,0,@w,@h)
        $(@canvas).unbind('dblclick').on('dblclick',
          ((event) ->
            event.preventDefault()
            return false
          )
        )

        $(@canvas).unbind('mousedown').on('mousedown', 
          ((event) ->
            event.preventDefault()
            event.stopImmediatePropagation()
            #Bug, trigger twice with a pageX and pageY = 0
            if event.pageX and event.pageY
              pos = Util.getRelativePosition($(self.canvas), event)
              self.mouseDown(pos.x, pos.y)
            return false
          )
        )

        $(@canvas).unbind('mouseup').on('mouseup', 
          ((event) ->
            event.preventDefault()
            event.stopImmediatePropagation()
            #Bug, trigger twice with a pageX and pageY = 0
            if event.pageX and event.pageY
              pos = Util.getRelativePosition($(self.canvas), event)
              self.mouseUp(pos.x, pos.y)
            return false
          )
        )

        $(@canvas).unbind('click').on('click', 
          ((event) ->
            event.preventDefault()
            event.stopImmediatePropagation()
            #Bug, trigger twice with a pageX and pageY = 0
            if event.pageX and event.pageY
              pos = Util.getRelativePosition($(self.canvas), event)
              self.click(pos.x, pos.y)
            return false
          )
        )

    onmousemove: (event) ->
      event.stopImmediatePropagation()
      #Bug, trigger twice with a pageX and pageY = 0
      #if(event.pageX && event.pageY) {
      pos = Util.getRelativePosition($(this.canvas), event)
      #this.click(pos.x, pos.y);
      this.mouseOver(pos.x, pos.y)
    
    activateMouseMove: (activated) ->
      self = this;
      if @onmousemoveId?
        clearInterval(@onmousemoveId);
      if activated
        @onmousemoveId = setInterval(
          (() ->
            if self.lastMoveEvent? and (not self.lastTreatedMoveEvent or (self.lastTreatedMoveEvent.clientX isnt self.lastMoveEvent.clientX or self.lastTreatedMoveEvent.clientY isnt self.lastMoveEvent.clientY))
              self.lastTreatedMoveEvent = self.lastMoveEvent
              self.onmousemove(self.lastMoveEvent)
          ), 10
        )

    onMouseDown: (x, y) ->

    onMouseUp: (x, y) ->

    uncache: (rect) ->
      super(rect)
      @dirty = true

    tick: () ->
      if @dirty
        ctx = @canvas.getContext('2d')
        ctx.clearRect(0,0, @canvas.width, @canvas.height)
        ctx.drawImage(@_cacheCanvas,0,0)
        @dirty = false

  World
