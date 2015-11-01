Template.control.onRendered ->
  element = document.getElementById 'pattern-lock'
  control = Control.findOne()

  @hammer = new Hammer.Manager element
  usualSwipe = new Hammer.Swipe event: 'usualSwipe', velocity: 0.2, pointers: 1, direction: Hammer.DIRECTION_HORIZONTAL
  strongSwipe = new Hammer.Swipe event: 'strongSwipe', velocity: 0.2, pointers: 3
  strongPan = new Hammer.Pan event: 'strongPan', pointers: 3
  pinch = new Hammer.Pinch threshold: 0.3
  @hammer.add [strongSwipe, usualSwipe, strongPan, pinch]

  strongSwipe.recognizeWith strongPan
  usualSwipe.requireFailure pinch

  @hammer.on "strongPanstart", (ev) ->
    usualSwipe.set enable: false
    pinch.set enable: false

  @hammer.on "strongPanend", (ev) ->
    setTimeout ->
      usualSwipe.set enable: true
      pinch.set enable: true
    , 50

  @hammer.on "usualSwipeleft", (ev) ->
    window.navigator?.vibrate? [30]
    Meteor.call 'go', control.pinCode, name: 'next'

  @hammer.on "usualSwiperight", (ev) ->
    window.navigator?.vibrate? [30]
    Meteor.call 'go', control.pinCode, name: 'prev'

  @hammer.on "strongSwipeleft", (ev) ->
    window.navigator?.vibrate? [140]
    Meteor.call 'go', control.pinCode, name: 'last'

  @hammer.on "strongSwiperight", (ev) ->
    window.navigator?.vibrate? [140]
    Meteor.call 'go', control.pinCode, name: 'first'

  @hammer.on "strongSwipeup", (ev) ->
#    window.navigator?.vibrate? [140]

  @hammer.on "strongSwipedown", (ev) ->
#    window.navigator?.vibrate? [140]

  @hammer.on "pinchin", (ev) ->
    return unless ev.eventType == Hammer.INPUT_END
    window.navigator?.vibrate? [30]
    Meteor.call 'go', control.pinCode, name: 'zoomOut'

  @hammer.on "pinchout", (ev) ->
    return unless ev.eventType == Hammer.INPUT_END
    window.navigator?.vibrate? [30]
    Meteor.call 'go', control.pinCode, name: 'zoomIn'

  window.navigator?.vibrate? [30]
  window.navigator?.wakeLock?.request "display"
