class Ticker

Ticker._inited = false
Ticker.useRAF = null
#Ticker.backDirty = false
Ticker.dirty = false
Ticker._rafActive = false
Ticker._startTime = 0
Ticker._lastTime = 0
Ticker._tickTimes = null
Ticker._times = []
Ticker._timeoutID = null
Ticker._interval = 10 #READ-ONLY

Ticker.init = (world) ->
  Ticker.world = world
  Ticker._inited = true
  Ticker._tickTimes = []
  Ticker._times.push(Ticker._lastTime = Ticker._startTime = Ticker._getTime())
  Ticker.setInterval(Ticker._interval)
  
Ticker.setInterval = (interval) ->
  Ticker._interval = interval
  if Ticker._inited
    Ticker._setupTick()

Ticker.setFPS = (value) ->
  Ticker.setInterval(1000/value)

Ticker.getFPS = () ->
  1000/Ticker._interval

Ticker.getMeasuredFPS = (ticks) ->
  if Ticker._times.length < 2
    return -1
  # by default, calculate fps for the past 1 second:
  if not ticks?
    ticks = Ticker.getFPS()|0
  ticks = Math.min(Ticker._times.length-1, ticks)
  1000/((Ticker._times[0]-Ticker._times[ticks])/ticks)

Ticker._setupTick = () ->
  if not Ticker._rafActive and not Ticker._timeoutID?
    if Ticker.useRAF
      f = window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame
      if f
        f(Ticker._handleAF)
        Ticker._rafActive = true
        return;
    Ticker._timeoutID = setTimeout(Ticker._handleTimeout, Ticker._interval)

Ticker._handleTimeout = () ->
  Ticker._timeoutID = null
  Ticker._setupTick()
  Ticker._tick()

Ticker._handleAF = () ->
  Ticker._rafActive = false
  Ticker._setupTick()
  # run if enough time has elapsed, with a little bit of flexibility to be early, because RAF seems to run a little faster than 60hz:
  if (Ticker._getTime() - Ticker._lastTime >= (Ticker._interval-1)*0.97)
    Ticker._tick()

Ticker._tick = () ->
  time = Ticker._getTime()
  Ticker._ticks++

  if Ticker.world? and Ticker.world.tick?
    Ticker.world.tick()
  Ticker._lastTime = time
  
  Ticker._tickTimes.unshift(Ticker._getTime()-time)
  while Ticker._tickTimes.length > 100
    Ticker._tickTimes.pop()

  Ticker._times.unshift(time)
  while Ticker._times.length > 100
    Ticker._times.pop()

now = window.performance and (window.performance.now or window.performance.mozNow or window.performance.msNow or window.performance.oNow or window.performance.webkitNow)
Ticker._getTime = () ->
  (now and now.call(window.performance)) or (new Date().getTime())

module.exports = Ticker