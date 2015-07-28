# ############## #
# BINDINGS
# ############## #

# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Bindings = ->

  Bindings =
    init: ->
      @setup()
      @select2()
      @countrySelector()
    setup: ->
      @isMobile()
      @closeAlerts()
    isMobile: ->
      # If mobile, add a body class
      if WURFL.is_mobile
        $('body').addClass('is-mobile')
    closeAlerts: ->
      # Automatically close alerts
      window.setTimeout (->
        $('.alert.alert-success, .alert.alert-error').fadeOut 'fast', ->
          $(this).alert('close')
      ), 5000
    select2: ->
      # sets select2 to all select inputs
      $('.select2').select2
        minimumResultsForSearch: 4
      # Hide the initial select 2 error tag
      $('.select2-arrow b').remove()
      $('#footer').find('.select2-arrow b').show()
      $('.select2-arrow').append '<i class="icon-arrow-down aDownz"></i>'
      # select 2 valid error bidings
      $('.select2').on 'change', (ev) ->
        if $(this).val() != '' or $(this).val() != 0
          $(this).siblings('.errorZone').html ''
          $(this).removeClass('error').addClass('valid')
          $(this).parent().find('.subContainer').find('.select2-chosen').addClass('valid').removeClass('error')
        else
          $(this).removeClass('valid').addClass('error')
          $(this).parent().find('.subContainer').find('.select2-chosen').removeClass('valid').addClass('error')
          error_messages.run $(this).siblings('.select-plan'), error_messages.subscription.empty
    countrySelector: ->
      $('#footer .country-selectbox li.dropdown').addClass('dropup')

  $ ->
    Bindings.init()
