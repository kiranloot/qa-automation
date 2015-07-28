###
# Count Down Timer
###

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.countDownTimer = ->
  countDownTimer =
    init: ->
      if showTimer == true
        countdown year, month, day, hour, minute

  $ ->
    countDownTimer.init()


  
