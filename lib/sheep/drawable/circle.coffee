define ['cs!sheep/drawable/displayObject'], (DisplayObject) ->

  class Circle extends DisplayObject
    
    constructor: (x, y, radius, color, world) ->
      super(x, y, radius*2, radius*2, world);
      @valueWidth = -1
      @color = color
      @uncache()
      @invalidate()
      @hitable = yes
      
    uncache: () ->
      #Refresh the cached image
      #On dessine le fond
      context = this._cacheContext
      context.beginPath();
      context.arc(@w/2, @h/2, @h/2, 0, 2 * Math.PI, false);
      context.fillStyle = @color;
      context.fill();
      #context.lineWidth = 5;
      #context.strokeStyle = '#003300';
      #context.stroke();
      context.restore()

    onClick: () ->
      console.log 'click'
      @color = "#FF0000"
      @uncache()
      @invalidate()






    