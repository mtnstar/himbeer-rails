Himbeer.Device = DS.Model.extend
  label: DS.attr('string')
  port: DS.attr('string')
  on: DS.attr('boolean')

  _ajax: (url, method, options) ->
    type    = @get 'constructor'
    adapter = @get('store').adapterFor type
    url     = '%@/%@'.fmt adapter.buildURL(type.typeKey), url
    adapter.ajax(url, method, options)

  post: (url, options) ->
    @_ajax(url, 'POST', options)

  http_get: (url, options) ->
    @_ajax(url, 'GET', options)

  toggle: ->
    @http_get('%@/toggle'.fmt @get('id')).then ( data ) =>
      @set('on',data.on)
