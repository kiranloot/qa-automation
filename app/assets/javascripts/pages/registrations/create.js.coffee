###
# registrations-create
###

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['registrations-create'] = ->
  Registration =
    init: ->
      @setup()
    setup: ->
      LootCrate.Registration()
      LootCrate.flip()

  $ ->
    Registration.init()
