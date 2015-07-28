# ############## #
# UTAG
# ############## #

# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Utag = ->

  Utag = 
    init: ->
      @setup()
    setup: ->
      $('.btn-utag').click (e)->
        try
          utag.link
            "event_name" : $(this).data('utagEvent')
            "customer_id": $(this).data('utagUser')
            "customer_email": $(this).data('utagEmail')
        catch e
          console.log e
  $ ->
    Utag.init()
