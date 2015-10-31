setupIframeSizing = ($iframe) ->
  $iframe.height(window.innerHeight)
  $(window).off('resize').on 'resize', => $iframe.height window.innerHeight


showPresentationInfoPopup = ->
  $popup = $ '#presentationInfoPopup'
  return $popup.modal 'show' if $popup.length
  Blaze.renderWithData Template.presentationInfoPopup, Presentations.findOne(), document.getElementById 'presentation'
  $popup = $ '#presentationInfoPopup'
  $popup.modal().modal 'show'



class PresentationControl
  constructor: (@iframe, @control) ->


  go: (action) =>
    return unless action in ['next', 'prev', 'zoomIn', 'zoomOut']
    @iframe.contentWindow.postMessage "shower-#{action}", '*'
    Meteor.call 'clearPendingAction', @control.pinCode



Template.presentation.onRendered ->
  $iframe = @$ 'iframe'
  setupIframeSizing $iframe
  $iframe.load =>
    showPresentationInfoPopup()
    presentationControl = new PresentationControl $iframe.get(0), Control.findOne()
    Control.find({}, {pendingAction: 1}).observeChanges
      changed: (id, fields) ->
        return unless fields.pendingAction
        presentationControl.go fields.pendingAction



Template.presentation.helpers
  url: -> Presentations.findOne({}, {url: 1}).url



Template.presentationInfoPopup.onRendered ->
  $text = @$("input:text").get(0)
  length = $text.value.length
  $text.selectionStart = 0
  $text.selectionEnd = length
  $text.focus()



Template.presentationInfoPopup.helpers
  baseUrl: -> Meteor.absoluteUrl()



window.addEventListener 'message', (event) -> console.log 'event:', event
