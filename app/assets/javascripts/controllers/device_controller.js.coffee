Himbeer.DevicesController = Ember.ArrayController.extend(
  actions:
    toggle: (device) ->
      device.toggle()
    set_value: (device, value) ->
      device.set_value(value)
)
