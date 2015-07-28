LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages['media_inquiries-new'] = ->

  MediaInquiriesNew =

    init: ->
      @setup()

    setup: ->
      LootCrate.FormValidator()

  $ ->
    MediaInquiriesNew.init()