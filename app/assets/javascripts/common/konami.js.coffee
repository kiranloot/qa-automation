LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.konamiCode = ->
  konamiCode =
    init: ->
      @konami = new Konami()
      @konami.load('/thirtylives')
  $ ->
    konamiCode.init()

