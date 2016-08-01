ko.bindingHandlers.checkbox =
  init: (element, valueAccessor, allBindings, data, context) ->
    observable = valueAccessor()
    if !ko.isWriteableObservable(observable)
      throw 'You must pass an observable or writeable computed'
    $element = $(element)
    $element.on 'click', ->
      observable !observable()
      return
    ko.computed
      disposeWhenNodeIsRemoved: element
      read: ->
        $element.toggleClass 'active', observable()
        return
    return

ko.bindingHandlers.modal =
  init: (element, valueAccessor) ->
    $(element).modal show: false
    value = valueAccessor()
    if typeof value == 'function'
      $(element).on 'hide.bs.modal', ->
        value false
        return
    ko.utils.domNodeDisposal.addDisposeCallback element, ->
      $(element).modal 'destroy'
      return
    return
  update: (element, valueAccessor) ->
    value = valueAccessor()
    if ko.utils.unwrapObservable(value)
      $(element).modal 'show'
    else
      $(element).modal 'hide'
    return