FlowRouter.route '/',
  action: ->
    BlazeLayout.render 'loginPage'



FlowRouter.route '/presentation/:presentationId',
  subscriptions: (params) ->
    @register 'presentation', Meteor.subscribe 'presentation', presentationId: params.presentationId
    @register 'control', Meteor.subscribe 'control', presentationId: params.presentationId


  action: (params) ->
    @waitComputation = Tracker.autorun ->
      entries = [Presentations.findOne(params.presentationId), Control.findOne(presentationId: params.presentationId)]
      return BlazeLayout.render 'wait' unless entries.every (entry) -> entry
      BlazeLayout.render 'presentation'


  triggersExit: [
    (data) -> data.route.waitComputation.stop()
    (data) -> $('.modal-backdrop').remove()
  ]



FlowRouter.route '/control/:pinCode',
  subscriptions: (params) ->
    @register 'control', Meteor.subscribe 'control', pinCode: params.pinCode


  action: (params) ->
    @waitComputation = Tracker.autorun ->
      return BlazeLayout.render 'wait' unless Control.findOne pinCode: params.pinCode
      BlazeLayout.render 'control'


  triggersExit: [
    (data) -> data.route.waitComputation.stop()
  ]
