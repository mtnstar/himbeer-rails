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

  _ajax: (url, method, options) ->
    type    = @get 'constructor'
    adapter = @get('store').adapterFor type
    url     = '%@/%@'.fmt adapter.buildURL(type.typeKey), url
    adapter.ajax(url, method, options)

  http_get: (url, options) ->
    @_ajax(url, 'GET', options)

  toggle: ->
    @http_get('%@/toggle'.fmt @get('id')).then ( data ) =>
      @set('on',data.on)

  set_value: ->
    @http_get('%@/set_value'.fmt @get('id')).then ( data ) =>
      @set('value',data.value)
