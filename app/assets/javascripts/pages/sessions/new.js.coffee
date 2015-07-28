###
# sessions-new
###

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['sessions-new'] = ->
  NewSession =
    init: ->
      @setup()
    setup: ->
      LootCrate.Registration()
      LootCrate.flip()

  $ ->
    NewSession.init()
