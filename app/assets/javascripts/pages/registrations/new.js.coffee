###
# registrations-new
###

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['registrations-new'] = ->
  Registration =
    init: ->
      @setup()
    setup: ->
      LootCrate.Registration()
      LootCrate.flip()

  $ ->
    Registration.init()
