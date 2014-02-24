$ ->
  isX = true

  clearBoard = ->
    $('.board-cell').text('')
    isX = true

  $('#start-button').on 'click', (e) ->
    clearBoard()
    $(@).hide()
    $('#gameboard').fadeIn(500)

  $('.board-cell').on 'click', (e)->
    mark = if isX then 'x' else 'o'
    if ( $(@).text().replace /^\s+|\s+$/g, "" ) == ''
      $(@).text mark
      $(@).addClass mark
      isX = !isX