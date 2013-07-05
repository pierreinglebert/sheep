define ->
  createCanvas: () ->
    canvas = document.createElement "canvas"
    if window.G_vmlCanvasManager?
      window.G_vmlCanvasManager.initElement canvas
    canvas
  ,
  getRelativePosition: (element, event) ->
    offset = element.offset();
    x: event.pageX - offset.left, y: event.pageY - offset.top
