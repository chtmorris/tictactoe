var app = angular.module("superhero", [])

app.directive("superman", function (){
  return {
    restrict: "E",
    templateUrl: '/partials/board.html'
  }
})