$ ->
  counter = 0

  WIN_PATTERNS = [
    [0,1,2]
    [3,4,5]
    [6,7,8]
    [0,3,6]
    [1,4,7]
    [2,5,8]
    [0,4,8]
    [2,4,6]
  ]

  isEmpty = (cell) ->
    !cell.text()

  getCellNumber = (cell) ->
    parseInt cell.data('index')

  clearBoard = ->
    $('.board-cell').text('')
    $('.board-cell').removeClass('o')
    $('.board-cell').removeClass('x')
    counter = 0

  resetGame = ->
    clearBoard()
    $('#gameboard').hide()
    $('#start-game').fadeIn(500)

  getBoard = ->
    ( $('.board-cell').map (idx, el) -> $(el).text() ).get()

  isBlocked = (pattern) ->
    board = getBoard()
    a = [board[pattern[0]], board[pattern[1]], board[pattern[2]]]
    'x' in a and 'o' in a

  checkForTie = ->
    openPattern = 8
    for p in WIN_PATTERNS
      if isBlocked(p) then openPattern -=1

    if openPattern < 1
      alert 'Tie game!'
      resetGame()
    else if openPattern == 1
      board = getBoard()
      if board[p[0]] == board[p[1]] == board[p[2]] == ''
        alert 'Tie game!'
        resetGame()

  checkForWin = (cell) ->
    win = ''
    board = ( $('.board-cell').map (idx, el) -> $(el).text() ).get()

    patternsToTest = WIN_PATTERNS.filter (pattern) -> cell in pattern

    for p in patternsToTest
      win = board[p[0]] if '' != board[p[0]] == board[p[1]] == board[p[2]]

    if win != ''
      alert win + ' won!'
      resetGame()
    else if counter > 8
      alert 'Tie game!'
      resetGame()

  markCell = (cell, mark) ->
    cell.text mark
    cell.addClass mark
    counter += 1
    checkForWin( getCellNumber(cell) ) if counter > 4
    checkForTie()

  # Handle start game clicks
  $('#start-game').on 'click', (e) ->
    clearBoard()
    $(@).hide()
    $('#gameboard').fadeIn(500)

  # Handle board cell clicks
  $('.board-cell').on 'click', (e) ->
    cell = $(@)
    mark = if counter % 2 == 0 then 'x' else 'o'
    markCell(cell, mark) if isEmpty(cell)