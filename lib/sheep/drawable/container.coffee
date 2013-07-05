define ['cs!sheep/drawable/displayObject'], (DisplayObject) ->

  class Container extends DisplayObject

    constructor: (x, y, w, h, world) ->
      super(x, y, w, h, world)
      @setForceMouseEnabled false
      @children = []
      this.uncache()
    
    # Enfants du conteneur
    # @property children
    # @type Array[DisplayObject]
    # @default null
    @children = null

    # Initialisation
    # @method initialize
    # @protected
    isVisible: () ->
      return @visible and this.getAlpha() > 0 and @children.length

    addChild: (child) ->
      if child?
        if child.parent? 
          child.parent.removeChild(child)
        child.parent = this
        @children.push(child)
        this.sortByY()
        if child.getMouseEnabled() and !this.getMouseEnabled()
          @setMouseEnabled(true)
        #Invalidate zone
        child.invalidate()
      return child

    removeChildAt: (index) ->
      if index >= 0 and index < @children.length
        child = @children[index]
        if child?
          #Invalidate zone
          child.parent = null
          @children.splice(index, 1)
          rect = {x: child.x, y:child.y, w:child.w, h:child.h}
          this.invalidate(rect)
          if child.getMouseEnabled()
            this.checkMouseEnabled()
          return true
      return false

    setForceMouseEnabled: (enabled) ->
      @_forceMouseEnabled = enabled
      @setMouseEnabled true

    checkMouseEnabled: () ->
      if not @_forceMouseEnabled
        @_mouseEnabled = false
        for child in @children
          if child.getMouseEnabled()
            @setMouseEnabled(true)
            break
      else
        this.setMouseEnabled(true)

    removeChild: (child) ->
      this.removeChildAt(@children.indexOf(child))

    sortByY: () ->
      @children.sort(
        ((a,b) -> 
          if a.y is b.y
            return 0
          if a.y is 0
            return -1
          if b.y is 0
            return 1
          if a.y <= b.y
            return -1
          else
            return 1
        )
      )

    uncache: (rect) ->
      if not rect?
        rect = {x: 0, y:0, w: this.w, h: this.h}
      @_cacheContext.clearRect(rect.x, rect.y, rect.w, rect.h)
      list = @children.slice(0);
      for child in list
        if child.isVisible()
          rectx2 = rect.x + rect.w
          recty2 = rect.y + rect.h
          childx2 = child.x + child.w
          childy2 = child.y + child.h
          #Si le fils est dans la zone concernée
          if rect.x < childx2 and rectx2 > child.x and rect.y < childy2 and recty2 > child.y
            childRect = {x: Math.max(rect.x, child.x), y: Math.max(rect.y, child.y), w: 0, h: 0}
            childRect.w = Math.min(rectx2, childx2) - childRect.x
            childRect.h = Math.min(recty2, childy2) - childRect.y
            child.drawPart(@_cacheContext, childRect)
      return true

    getChildrenAt: (rect) ->
      children = []
      list = @children.slice(0)
      for child in list
        if child.isVisible()
          rectx2 = rect.x + rect.w
          recty2 = rect.y + rect.h
          childx2 = child.x + child.w
          childy2 = child.y + child.h
          #Si le fils est dans la zone concernée
          if not (rect.x > childx2 or child.x > rectx2 or rect.y > childy2 or child.y > recty2)
            children.push(child)
      return children

    invalidate: (rect) ->
      #Un enfant a prévenu qu'une zone avait été invalidée, on doit la redessiner dans le cache
      this.uncache(rect)
      if @parent?
        newRect = {x: this.x, y: this.y, w: this.w, h: this.h}
        if rect
          newRect.x += rect.x
          newRect.y += rect.y
          newRect.w = rect.w
          newRect.h = rect.h
        @parent.invalidate(newRect)

    click: (x,y) ->
      super(x,y)
      children = this.getChildrenAt({x: x, y: y, w: 1, h: 1})
      clicked = false
      i = children.length-1;
      while i >= 0 and not clicked
        #Les enfants sont triés
        if children[i].isVisible()
          clicked = children[i].click(x, y)
        i--

    mouseOver: (absX, absY) ->
      super(absX, absY)
      x = absX - @x
      y = absY - @y
      overed = false
      #On prend tous les fils qui ont le mouseEnabled
      for child in @children
        if child? and child.getMouseEnabled()
          overed |= child.mouseOver(x, y)
      return overed

  Container