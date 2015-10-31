getRandomPinCode = ->
  (Random.choice '0123456789' for [1..6]).join ''



Meteor.methods
  addPresentation: (url) ->
    check url, String
    console.log 'addPresentation url:', url
    pinCode = getRandomPinCode() while Presentations.findOne pinCode: pinCode
    presentationId = Presentations.insert url: url, pinCode: pinCode
    Control.insert pinCode: pinCode, presentationId: presentationId
    return presentationId



  go: (pinCode, action) ->
    check pinCode, String
    check action, Object
    console.log 'go pinCode:', pinCode, 'action:', action
    control = Control.findOne pinCode: pinCode
    throw new Meteor.Error 'Control not found' unless control
    if action.name in ['next', 'prev', 'zoomIn', 'zoomOut']
      return Control.update control._id, $set: pendingAction: action.name



  clearPendingAction: (pinCode) ->
    check pinCode, String
    console.log 'clearPendingAction pinCode:', pinCode
    Control.update {pinCode: pinCode}, $set: pendingAction: ''
