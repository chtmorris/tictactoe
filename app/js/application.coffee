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

  mark: (cell) =>
    player = if Object.keys(@$scope.cells).length % 2 == 0 then 'x' else 'o'
    @$scope.cells[cell] = player

BoardCtrl.$inject = ["$scope", "Settings"]
ticTacToe.controller "BoardCtrl", BoardCtrl