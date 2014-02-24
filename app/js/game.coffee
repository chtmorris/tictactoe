$ ->
  isX = true

  clearBoard = ->
    $('.board-cell').text('')
    isX = true

  resetBoard = ->
    clearBoard()
    $('#gameboard').hide()
    $('#start-game').fadeIn(500)

  checkForWin = () ->
    board = ($('.board-cell').map (idx, el) ->
      $(el).text()
    ).get()

    win = if board[0] == board[1] == board[2] != ''
      board[0]
    else if board[3] == board[4] == board[5] != ''
      board[3]
    else if board[6] == board[7] == board[8] != ''
      board[6]
    else if board[0] == board[3] == board[6] != ''
      board[0]
    else if board[1] == board[4] == board[7] != ''
      board[1]
    else if board[2] == board[5] == board[8] != ''
      board[2]
    else if board[0] == board[4] == board[8] != ''
      board[0]
    else if board[2] == board[4] == board[6] != ''
      board[2]
    else
      ''

    if win != ''
      alert win + ' won!'
      resetBoard()

  $('#start-game').on 'click', (e) ->
    clearBoard()
    $(@).hide()
    $('#gameboard').fadeIn(500)

  $('.board-cell').on 'click', (e)->
    mark = if isX then 'x' else 'o'
    if ( $(@).text().replace /^\s+|\s+$/g, "" ) == ''
      $(@).text mark
      $(@).addClass mark
      isX = !isX
    checkForWin()