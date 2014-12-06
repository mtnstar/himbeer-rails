Himbeer.DevicesController = Ember.ArrayController.extend(
  actions:
    toggle: (device) ->
      device.toggle()
)
