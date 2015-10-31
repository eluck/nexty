Meteor.publish 'presentation', (selector) ->
  query = selector.presentationId if selector.presentationId
  query = pinCode: selector.pinCode if selector.pinCode
  throw new Meteor.Error 'presentation selector is not valid' unless query?
  Presentations.find query



Meteor.publish 'control', (selector) ->
  query = presentationId: selector.presentationId if selector.presentationId
  query = pinCode: selector.pinCode if selector.pinCode
  throw new Meteor.Error 'control selector is not valid' unless query?
  ControlPublicationHelpers.insertControl selector unless Control.findOne query
  cursor = ControlPublicationHelpers.publishCollection @, Control, query, 'control'
  @onStop -> cursor.stop()
  @ready()



ControlPublicationHelpers =
  insertControl: (selector) ->
    presentationQuery = selector.presentationId if selector.presentationId
    presentationQuery = pinCode: selector.pinCode if selector.pinCode
    throw new Meteor.Error 'presentation selector is not valid' unless presentationQuery?
    presentation = Presentations.findOne presentationQuery
    throw new Meteor.Error 'unable to find presentation' unless presentation
    Control.insert presentationId: presentation._id, pinCode: presentation.pinCode


  publishCollection: (publication, collection, query, handle) ->
    return collection.find(query).observeChanges
      added: (id, fields) -> publication.added handle, id, fields
      changed: (id, fields) -> publication.changed handle, id, fields
      removed: (id) -> publication.removed handle, id
