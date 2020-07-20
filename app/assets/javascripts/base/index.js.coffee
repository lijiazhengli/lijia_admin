@showOtherRightInfo = (id, item_name) ->
  console.log('showOtherRightInfo start')
  $('.' + item_name + '-left-content').removeClass('current')
  $('.' + item_name + '-left-' + id).addClass('current')

  $('.' + item_name + '-right-content').removeClass('right-current')
  $('.' + item_name + '-right-' + id).addClass('right-current')


@showAppletPop = (title, msg) ->
  $("#show-applet-code").show()
  $("#pop-title").html(title)
  $("#pop-footer-msg").html(msg)

@closeAppletPop = () ->
  $("#show-applet-code").hide()

