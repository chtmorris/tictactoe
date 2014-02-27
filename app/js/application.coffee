"use strict"

@ticTacToe = angular.module 'TicTacToe', []

ticTacToe.constant 'WIN_PATTERNS',
  [
    [0,1,2]
    [3,4,5]
    [6,7,8]
    [0,3,6]
    [1,4,7]
    [2,5,8]
    [0,4,8]
    [2,4,6]
  ]

class BoardCtrl
  constructor: (@$scope, @WIN_PATTERNS) ->
    @resetBoard()
    @$scope.mark = @mark

  getPatterns: =>
    @patternsToTest = @WIN_PATTERNS.filter -> true

  getRow: (pattern) =>
    c = @cells
    c0 = c[pattern[0]] || pattern[0]
    c1 = c[pattern[1]] || pattern[1]
    c2 = c[pattern[2]] || pattern[2]
    "#{c0}#{c1}#{c2}"

  someoneWon: (row) ->
    'xxx' == row || 'ooo' == row

  resetBoard: =>
    @cells = @$scope.cells = {}
    @getPatterns()

  numberOfMoves: =>
    Object.keys(@cells).length

  movesRemaining: (player) =>
    totalMoves = 9 - @numberOfMoves()

    if player == 'x'
      Math.ceil(totalMoves / 2)
    else if player == 'o'
      Math.floor(totalMoves / 2)
    else
      totalMoves

  player: (options) =>
    options ||= whoMovedLast: false
    moves = @numberOfMoves() - (if options.whoMovedLast then 1 else 0)
    if moves % 2 == 0 then 'x' else 'o'

  isMixedRow: (row) ->
    !!row.match(/ox\d|o\dx|\dox|xo\d|x\do|\dxo/i)

  hasOneX: (row) ->
    !!row.match(/x\d\d|\dx\d|\d\dx/i)

  hasTwoXs: (row) ->
    !!row.match(/xx\d|x\dx|\dxx/i)

  hasOneO: (row) ->
    !!row.match(/o\d\d|\do\d|\d\do/i)

  hasTwoOs: (row) ->
    !!row.match(/oo\d|o\do|\doo/i)

  isEmptyRow: (row) ->
    !!row.match(/\d\d\d/i)

  gameUnwinnable: =>
    @patternsToTest.length < 1

  announceWinner: =>
    winner = @player(whoMovedLast: true)
    alert "#{winner} wins!"
    @resetBoard()

  announceTie: =>
    alert "It's a tie!"
    @resetBoard()

  rowStillWinnable: (row) =>
    not (@isMixedRow(row) or
    (@hasOneX(row) and @movesRemaining('x') < 2) or
    (@hasTwoXs(row) and @movesRemaining('x') < 1) or
    (@hasOneO(row) and @movesRemaining('o') < 2) or
    (@hasTwoOs(row) and @movesRemaining('o') < 1) or
    (@isEmptyRow(row) and @movesRemaining() < 5))

  parseBoard: =>
    won = false

    @patternsToTest = @patternsToTest.filter (pattern) =>
      row = @getRow(pattern)
      won ||= @someoneWon(row)
      @rowStillWinnable(row)

    if won
      @announceWinner()
    else if @gameUnwinnable()
      @announceTie()

  mark: (@$event) =>
    cell = @$event.target.dataset.index
    @cells[cell] = @player()
    @parseBoard()


BoardCtrl.$inject = ["$scope", "WIN_PATTERNS"]
ticTacToe.controller "BoardCtrl", BoardCtrl