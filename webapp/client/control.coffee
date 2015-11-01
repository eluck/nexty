Template.control.onRendered ->
  element = document.getElementById 'pattern-lock'
  control = Control.findOne()

  @hammer = new Hammer.Manager element
  @hammer.add new Hammer.Swipe velocity: 0.2
  @hammer.add new Hammer.Pinch()

  @hammer.on "swipeleft", (ev) ->
    window.navigator?.vibrate? [30]
    Meteor.call 'go', control.pinCode, name: 'next'

  @hammer.on "swiperight", (ev) ->
    window.navigator?.vibrate? [30, 10, 30]
    Meteor.call 'go', control.pinCode, name: 'prev'

  @hammer.on "pinchin", (ev) ->
    return unless ev.eventType == 4
    window.navigator?.vibrate? [30, 10, 30]
    Meteor.call 'go', control.pinCode, name: 'zoomOut'

  @hammer.on "pinchout", (ev) ->
    return unless ev.eventType == 4
    window.navigator?.vibrate? [30]
    Meteor.call 'go', control.pinCode, name: 'zoomIn'

  window.navigator?.vibrate? [30]
  window.navigator?.wakeLock?.request "display"
