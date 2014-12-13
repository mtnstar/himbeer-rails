Himbeer.Device = DS.Model.extend
  label: DS.attr('string')
  port: DS.attr('string')
  type: DS.attr('string')
  on: DS.attr('boolean')

  value: (->
  ).property()

  pwm_device: (->
    @get('type') == 'PwmDevice'
  ).property('type')

  show_slider: (->
    @get('pwm_device') && @get('on')
  ).property('on')

  temp_value: null

  observe_value: (->
    that = @
    value = @value
    @temp_value = @value
    setTimeout(->
      if (that.temp_value == value)
        that.set_value(value)
    , 1000)
  ).observes('value')

  _ajax: (url, method, options) ->
    type    = @get 'constructor'
    adapter = @get('store').adapterFor type
    url     = '%@/%@'.fmt adapter.buildURL(type.typeKey), url
    adapter.ajax(url, method, options)

  http_get: (url, options) ->
    @_ajax(url, 'GET', options)

  toggle: ->
    @http_get('%@/toggle'.fmt(@get('id'))).then ( data ) =>
      @set('on',data.on)

  set_value: (value) ->
    @http_get('%@/set_value?value=%@'.fmt(@get('id'), value))
