module.exports = createCanvas = () ->
    canvas = document.createElement("canvas")
    if window.G_vmlCanvasManager?
        window.G_vmlCanvasManager.initElement(canvas)
    return canvas
