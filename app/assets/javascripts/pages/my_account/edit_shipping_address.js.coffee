###
# shipping_address-edit
###

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['shipping_address-edit'] = ->
  LootCrate.FormValidator()
  LootCrate.Address()
  LootCrate.Utag()
