define ['cs!sheep/drawable/displayObject'], (DisplayObject) ->

  class Bitmap extends DisplayObject
    
    constructor: (x,y,w,h,world, imageOrUri) ->
      super(x,y,w,h,world)
      if typeof imageOrUri is "string"
        @image = new Image()
        @image.src = imageOrUri
      else
        @image = imageOrUri
      this.uncache()
      
    @image = null;
    
    # * Indique la zone de l'image que l'on veut afficher
    # * @property sourceRect
    # * @type object
    # * @default null
    @sourceRect = null;

    uncache: () ->
      #Refresh the cached image
      if @image
        if @image.complete or this.image.readyState is "complete" or this.image.readyState is 4
          #On clear
          this.clear();
          #On affiche l'image
          if not this.sourceRect?
            #On affiche toute l'image
            @_cacheContext.drawImage(@image, 0, 0, @w, @h);
          else
            #On en affiche qu'une partie
            @_cacheContext.drawImage(@image, @sourceRect.x, @sourceRect.y, @sourceRect.w, @sourceRect.h, 0, 0, @w, @h)
          this.invalidate()
        else
          self = this;
          #L'image n'est pas encore chargée
          @image.onload = () ->
            #On rappelle uncache
            self.uncache()

    isVisible: () ->
      @visible and this.getAlpha() > 0 and @image? and (@image.complete or @image.readyState is "complete" or this.image.readyState is 4)

  Bitmap
