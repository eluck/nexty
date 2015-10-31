@Helpers =
  blink: ($element, options = {}) ->
    options = _.defaults options, delay: 100, times: 3, hide: false
    $element = $element.fadeOut(options.delay).fadeIn(options.delay) for [1...options.times]
    return $element.fadeOut options.delay  if options.hide
    return $element
