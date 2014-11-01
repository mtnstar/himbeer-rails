Himbeer.IndexRoute = Ember.Route.extend
  beforeModel:->
    @transitionTo('devices');
