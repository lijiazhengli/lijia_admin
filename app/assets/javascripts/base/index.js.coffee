@showOtherRightInfo = (id, item_name) ->
  console.log('showOtherRightInfo start')
  $('.' + item_name + '-left-content').removeClass('current')
  $('.' + item_name + '-left-' + id).addClass('current')

  $('.' + item_name + '-right-content').removeClass('right-current')
  $('.' + item_name + '-right-' + id).addClass('right-current')

