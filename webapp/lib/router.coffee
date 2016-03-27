FlowRouter.route '/',
  action: ->
    BlazeLayout.render 'layout', main: "loginPage", analytics: "analytics"



FlowRouter.route '/presentation/:presentationId',
  subscriptions: (params) ->
    @register 'presentation', Meteor.subscribe 'presentation', presentationId: params.presentationId
    @register 'control', Meteor.subscribe 'control', presentationId: params.presentationId


  action: (params) ->
    @waitComputation = Tracker.autorun ->
      entries = [Presentations.findOne(params.presentationId), Control.findOne(presentationId: params.presentationId)]
      return BlazeLayout.render 'layout', main: 'wait', analytics: 'analytics' unless entries.every (entry) -> entry
      BlazeLayout.render 'layout', main: 'presentation', analytics: 'analytics'


  triggersExit: [
    (data) -> data.route.waitComputation.stop()
    (data) -> $('.modal-backdrop').remove()
  ]



FlowRouter.route '/control/:pinCode',
  subscriptions: (params) ->
    @register 'control', Meteor.subscribe 'control', pinCode: params.pinCode


  action: (params) ->
    @waitComputation = Tracker.autorun ->
      return BlazeLayout.render 'layout', main: 'wait', analytics: 'analytics' unless Control.findOne pinCode: params.pinCode
      BlazeLayout.render 'layout', main: 'control', analytics: 'analytics'


  triggersExit: [
    (data) -> data.route.waitComputation.stop()
  ]
