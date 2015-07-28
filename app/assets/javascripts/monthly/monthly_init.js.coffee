#= require_tree .

###
# Monthly contests init
###
LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.monthly = LootCrate.monthly || {}

$ ->
  LootCrate.monthly[$('body').attr('id')]?()
