###
   cybercrate contest scope
###

LootCrate = window.LootCrate = window.LootCrate or {}
LootCrate.monthly = LootCrate.monthly or {}

LootCrate.monthly['monthly-cybercrate'] = ->

  loot = 
    isFire: ->
        return (navigator.userAgent.toLowerCase().indexOf('firefox') > -1)
    init: ->
      @stylings()
    stylings: ->

  $ ->
    loot.init()