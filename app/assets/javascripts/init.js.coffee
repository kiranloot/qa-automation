# ############## #
# INIT
# ############## #

# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.init = ->
  @Modals()
  @resizeTip()
  @Bindings()
  @Nav()
  @Footer()
  @Zopim()
  @Social()
  @konamiCode()
  # Runs js file for the current page
  @pages[$('body').attr('id')]?()

$ ->
  LootCrate.init()
