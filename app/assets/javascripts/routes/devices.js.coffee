Himbeer.DevicesRoute = Ember.Route.extend
  model:->
    @get('store').find 'device'

