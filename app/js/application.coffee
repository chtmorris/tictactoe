"use strict"

@ticTacToe = angular.module 'TicTacToe', ["firebase"]

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
  constructor: (@$scope, @WIN_PATTERNS, @$firebase) ->
    @resetBoard()
    @$scope.mark = @mark
    @$scope.startGame = @startGame
    @$scope.gameOn = false
    @dbRef = new Firebase "https://tictactoe-morris.firebaseio.com/"
    @db = @$firebase(@dbRef)

  startGame: =>
    @db.$add name: "Charlie", iq: 200
    @$scope.gameOn = true
    @$scope.currentPlayer = @player()
    @resetBoard()

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
    @$scope.theWinnerIs = false
    @$scope.cats = false
    @cells = @$scope.cells = {}
    @$scope.currentPlayer = @player()
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
    !!row.match(/o+\d?x+|x+\d?o+/i)

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

  announceWinner: (winningPattern) =>
    winner = @player(whoMovedLast: true)
    @$scope.winCell = {}
    winners = []
    for cell in winners
      @$scope.winCell[cell] = if cell in winners then 'win' else 'unwin'
    @$scope.theWinnerIs = winner
    @$scope.gameOn = false

  announceTie: =>
    @$scope.cats = true
    @$scope.gameOn = false

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
      won ||= pattern if @someoneWon(row)
      @rowStillWinnable(row)

    if won
      @announceWinner()
    else if @gameUnwinnable()
      @announceTie()

  mark: (@$event) =>
    cell = @$event.target.dataset.index
    if @$scope.gameOn
      @cells[cell] = @player()
      @parseBoard()
      @$scope.currentPlayer = @player()


BoardCtrl.$inject = ["$scope", "WIN_PATTERNS", "$firebase"]
ticTacToe.controller "BoardCtrl", BoardCtrl