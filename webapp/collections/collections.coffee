@Presentations = new Mongo.Collection 'presentations'

Presentations.deny
  insert: -> true
  update: -> true
  remove: -> true



handle = if Meteor.isClient then 'control' else null
@Control = new Mongo.Collection handle

Control.deny
  insert: -> true
  update: -> true
  remove: -> true
