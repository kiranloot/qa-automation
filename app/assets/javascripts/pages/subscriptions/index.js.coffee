# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['subscriptions-index'] = ->
  LootCrate.selectPlan()
  LootCrate.twelveMonths()
