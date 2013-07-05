define ['cs!sheep/drawable/displayObject'], (DisplayObject) ->

  class Rectangle extends DisplayObject
    
    constructor: (x, y, width, height, color, world) ->
      super(x, y, width, height, world);
      @valueWidth = -1
      @color = color
      @uncache()
      @invalidate()
      
    uncache: () ->
      #Refresh the cached image
      #On dessine le fond
      context = this._cacheContext
      context.save()
      context.fillStyle = @color
      context.fillRect(0, 0, @w, @h)
      context.restore()
