LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages['partner-new'] = ->

  PartnerNew =

    init: ->
      @setup()

    setup: ->
      LootCrate.FormValidator()

  $ ->
    PartnerNew.init()