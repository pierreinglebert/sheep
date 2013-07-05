define ['cs!sheep/drawable/displayObject'], (DisplayObject) ->

  class ProgressBar extends DisplayObject
    
    constructor: (x, y, width, height, value, backgroundColor, foregroudColor, world) ->
      super(x, y, width, height, world);
      @valueWidth = -1
      @backgroundColor = backgroundColor
      @foregroudColor = foregroudColor
      this.updateValue(value)
    
    uncache: () ->
      #Refresh the cached image
      #On dessine le fond
      context = this._cacheCanvas.getContext('2d')
      context.save()
      context.fillStyle = @backgroundColor
      context.fillRect(@x, @y, @w, @h)
      
      #on dessine le dessus
      context.fillStyle = @foregroudColor
      context.fillRect(@x+1, @y+1, Math.max(0,@valueWidth), @h-2)
      context.restore()
      
    updateValue: (value) ->
      tmpwidth = Math.floor(Math.min(value, 1) * (@w-2))
      if(@valueWidth isnt tmpwidth)
        @valueWidth = tmpwidth
        this.uncache()
        this.invalidate()
      
  ProgressBar