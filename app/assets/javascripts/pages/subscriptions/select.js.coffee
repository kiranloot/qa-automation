LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.selectPlan = ->
  # disable plan select and subscribe buttons on click
  $('.select-plan, .btn-subscribe').on 'click', (e) ->
    e.preventDefault()
    loc = $(this).attr('href')
    if loc
      $('.select-plan, .btn-subscribe').addClass('disabled')
      window.location.href = loc

