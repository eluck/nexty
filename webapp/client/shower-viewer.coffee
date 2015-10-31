Template.registerHelper 'loggedIn', ->
  Boolean Meteor.userId()


Template.loginPage.onCreated -> @data.urlSpinner = new ReactiveVar false


Template.loginPage.events
  'click .js-btn-url': (event, template) ->
    $input = template.$ '.url-input'
    url = $input.val()
    return Helpers.blink $input unless url
    template.data.urlSpinner.set true
    Meteor.call 'addPresentation', url, (error, result) ->
      template.data.urlSpinner.set false
      if error
        console.error error
        return $.growl.error({ message: "Something went wrong" });
      FlowRouter.go '/presentation/' + result



  'click .js-btn-pin-code': (event, template) ->
    $input = template.$ '.pin-code-input'
    pinCode = $input.val()
    return Helpers.blink $input unless pinCode
    FlowRouter.go '/control/' + pinCode



Template.loginPage.helpers
  urlSpinner: -> @urlSpinner.get()
