###
# subscriptions-edit
###

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['subscriptions-edit'] = ->
  LootCrate.FormValidator()
  LootCrate.Address()
