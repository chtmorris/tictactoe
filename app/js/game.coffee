$ ->
  cnt = 0

  $('.board-cell').on 'click', (e)->
    mark = if cnt % 2 == 0 then 'x' else 'o'
    if $(@).text() == ''
      $(@).text mark
      $(@).addClass mark
      cnt += 1