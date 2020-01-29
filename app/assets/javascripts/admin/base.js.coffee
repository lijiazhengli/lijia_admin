@dragEnterHandler = (event) ->
  internalDNDType = 'text/x-example';
  if event.target instanceof HTMLTableRowElement
    $element = $(event.target)
    @element = $element
    $("tr[data-id=#{$element.data('id')}]").addClass 'moving'
    event.dataTransfer.setData(internalDNDType, event.target.dataset.value)
    event.effectAllowed = 'move'
  else
    event.preventDefault();

@dragOverHandler = (event) ->
  if event.target instanceof HTMLTableCellElement
    $element = $(event.target)
    $tr = $element.parent()
    middle_line = $tr.height() / 2
    position = event.offsetY
    @destination = $tr unless $tr.data('id') == @element.data('id')
    if middle_line > position
      $tr.before(@element)
      @direction = 'before'
    else
      $tr.after(@element)
      @direction = 'after'
  else
    event.preventDefault();

@dragEndHandler = (event) ->
  @element.removeClass('moving')
  if @direction == 'before'
    url = @element.data('up_url')
  else
    url = @element.data('down_url')
  spinner = new Spinner({position: 'fixed', top: '50%', left: '50%'}).spin()
  @destination.append(spinner.el)
  console.log(1)
  $.ajax({
    url: url
    method: 'PUT'
    async: true
    dataType: 'text'
    data: {target_id: @destination.data('id')}
    success: (data)->
      spinner.stop()
      eval(data)
      true
    error: (a, b, c)->
      console.error(a)
      console.error(b)
      console.error(c)
      alert('未知错误')
  })