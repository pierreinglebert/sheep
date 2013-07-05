define ['cs!sheep/util'], (Util) ->

  class DisplayObject
    @_cacheCanvas = null
    @_cacheContext = null
    
    # Reference to the world
    # @property world
    # @final
    # @type Container
    # @default null
    @_world = null

    # Indique si l'objet doit être affiché
    # @property visible
    # @type Boolean
    # @default true
    @visible = true

    #Indique si l'objet peut capturer un mouseover
    # @property visible
    # @type Boolean
    # @default false
    @_mouseEnabled = false

    @_mouseIn = false

    # Indique si l'objet peut être cliqué
    # @property visible
    # @type Boolean
    # @default false
    @hitable = false

    # Reference to the parent container
    # @property parent
    # @final
    # @type Container
    # @default null
    @parent = null

    #La position en X de l'objet dans son parent
    # * @property x
    # * @type Number
    # * @default 0
    @x = 0

    # La position en Y de l'objet dans son parent
    # @property y
    # @type Number
    # @default 0
    @y = 0

    # Largeur de l'objet
    # @property w
    # @type Number
    # @default 0
    @w = 0;

    # Hauteur de l'objet
    # @property h
    # @type Number
    # @default 0
    @h = 0;

    constructor: (@x,@y,@w,@h,@world) ->
      @visible = true
      @_mouseEnabled = false
      @_mouseIn = false
      if not @_cacheCanvas? or not @_cacheContext?
        @_cacheCanvas = Util.createCanvas()
      @_cacheCanvas.width  = w
      @_cacheCanvas.height = h
      @_cacheContext = @_cacheCanvas.getContext("2d")

    getAlpha: () ->
      @_cacheContext.globalAlpha

    setAlpha: (alpha) ->
      if Math.abs(@_cacheContext.globalAlpha - alpha) > 0.001
        @_cacheContext.globalAlpha = alpha
        this.invalidate()

    absoluteX: () ->
      if @parent?
        @parent.absoluteX() + @x
      else
        return @x

    absoluteY: () ->
      if @parent?
        @parent.absoluteY() + @y;
      else
        return @y;

    invalidate: (rect) ->
      #On invalide toute la zone couverte par l'objet (x,y,w,h)
      if @w > 0 and @h > 0 and @parent?
        rect = {x: @x, y: @y, w: @w, h: @h};
        this.parent.invalidate(rect);
      #if(this.w > 0 && this.h > 0 && this.world !== null) {
      #    var rect = {x: this.absoluteX(), y: this.absoluteY(), w: this.w, h: this.h};
      #    this.world.invalidate(rect);
      #}

    clear: () ->
      @_cacheContext.clearRect(0, 0, @w, @h)

    draw: (ctx) ->
      if ctx?
        ctx.drawImage(@_cacheCanvas, @x, @y, @w, @h)
        true
      else
        false

    drawPart: (ctx, rect) ->
      if ctx? and rect.w > 0 and rect.h > 0
        ctx.drawImage(@_cacheCanvas, rect.x - @x, rect.y - @y, rect.w, rect.h, rect.x, rect.y, rect.w, rect.h);
        #ctx.drawImage(@_cacheCanvas, rect.x, rect.y)
        true
      else 
        false

    uncache: () ->

    isVisible: () ->
      @visible and this.getAlpha() > 0

    getMouseEnabled: () ->
      @_mouseEnabled

    setMouseEnabled: (enable) ->
      if @_mouseEnabled isnt enable
        @_mouseEnabled = enable
        if @parent? and @parent.getMouseEnabled() isnt enable
          @parent.setMouseEnabled(enable)
            
        
    click: (absX, absY) ->
      x = absX - @x
      y = absY - @y
      if @_cacheContext.getImageData(x, y, 1, 1).data[3] > 10
        #On a un fils correct
        if @hitable
          this.onClick(x,y)
        return true;
      return false;

    onClick: () ->

    mouseOver: (absX, absY) ->
      x = absX - @x
      y = absY - @y
      if x >=0 and y >= 0 and @_cacheContext.getImageData(x, y, 1, 1).data[3] > 10
        if @_mouseIn? or not @_mouseIn
          @_mouseIn = true
          @onMouseEnter(x,y)
        @onMouseOver(x,y)
        return true
      else
        #MouseOut
        if @_mouseIn
          @_mouseIn = false
          this.onMouseOut(x, y)
      return false;

    onMouseOver: (x, y) ->

    onMouseEnter: (x, y) ->

    onMouseOut: () ->

    mouseDown: (absX, absY) ->
      x = absX - @x
      y = absY - @y
      this.onMouseDown(x, y)

    mouseUp: (absX, absY) ->
      x = absX - @x
      y = absY - @y
      this.onMouseUp(x, y)

    onMouseDown: (x, y) ->

    onMouseUp: (x, y) ->


    moveTo: (x,y) ->
      if @x isnt x or @y isnt y
        #il faut effacer l'ancien et réafficher le nouveau
        oldVisibility = @visible
        @visible = false
        this.invalidate()
        @x = x
        @y = y
        @visible = oldVisibility
        if @parent
          @parent.sortByY()
        this.invalidate()

  DisplayObject
