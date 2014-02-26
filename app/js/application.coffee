"use strict"

@ticTacToe = angular.module 'TicTacToe', []

ticTacToe.constant 'Settings',
  WIN_PATTERNS: [
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
  constructor: (@$scope, @Settings) ->
    @$scope.cells = {}
    @$scope.mark = @mark

  getRow: (pattern) =>
    c = @$scope.cells
    c0 = c[pattern[0]] || pattern[0]
    c1 = c[pattern[1]] || pattern[1]
    c2 = c[pattern[2]] || pattern[2]
    "#{c0}#{c1}#{c2}"

  someoneWon: (row) ->
    'xxx' == row || 'ooo' == row

  resetBoard: =>
    @$scope.cells = {}

  numberOfMoves: =>
    Object.keys(@$scope.cells).length

  player: (options) =>
    options ||= whoMovedLast: false
    moves = @numberOfMoves() - (if options.whoMovedLast then 1 else 0)
    if moves % 2 == 0 then 'x' else 'o'

  announceWinner: =>
    winner = @player(whoMovedLast: true)
    alert ("#{winner} wins!")

  parseBoard: =>
    for pattern in @Settings.WIN_PATTERNS
      row = @getRow(pattern)
      @announceWinner() if @someoneWon(row)

  mark: (@$event) =>
    cell = @$event.target.dataset.index
    player = @player()
    @$scope.cells[cell] = @player()
    @parseBoard()


BoardCtrl.$inject = ["$scope", "Settings"]
ticTacToe.controller "BoardCtrl", BoardCtrl