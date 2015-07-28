LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages['level_up-checkouts-new'] = ->

  CheckoutsNew =
    init: ->
      @setup()
      @onPageLoad()
      @onCheckboxChange()
      @countrySelectorArrow()
      @notMyCountryLink()
      @disabledBtn()
      @removeErrorClass()
      @creditcardRules()
      @setupValidateCouponCode()
      @countryChange()
      @loadStates()
      @setupTshirtPopover()
      @setupCVVPopover()

    setup: ->
      LootCrate.FormValidator()

    onPageLoad: ->
      if $('#billing').attr('checked')
        $('.billToggle').hide()
      else
        $('.billToggle').show()

      #isLevelup = true

      #if isLevelup == true
        #$('.checkout_shirt_size').remove();

    onCheckboxChange: ->
      $('#billing').on 'change', (ev) ->
        if $(this).attr('checked')
          $(this).removeAttr 'checked'
          $('.billToggle').show()
        else
          $(this).attr 'checked', true
          $('.billToggle').hide()

    countryChange: ->
      $('#checkout_shipping_address_country').change (e) =>
        @populateStates $('#checkout_shipping_address_country'), $("#checkout_shipping_address_state")

      $('#checkout_billing_address_country').change (e) =>
        @populateStates $('#checkout_billing_address_country'), $("#checkout_billing_address_state")

    loadStates: ->
      @populateStates $('#checkout_shipping_address_country'), $("#checkout_shipping_address_state")
      @populateStates $('#checkout_billing_address_country'), $("#checkout_billing_address_state")

    # country seletor shared methods
    # @see common/country_selection
    countrySelectorArrow: LootCrate.common['country_select'].countrySelectorArrow
    notMyCountryLink: LootCrate.common['country_select'].notMyCountryLink
    toggleArrow: LootCrate.common['country_select'].toggleArrow

    disabledBtn: ->
      $('.disabled').click (e) ->
        e.preventDefault()
        false

    populateStates: ($target, $stateContent) ->
      stateContent = $stateContent
      target = $target
      originalValue = stateContent.val()
      $.ajax
        url: "/address/states.js"
        type: "GET"
        data:
          country: target.val()
        beforeSend: ->
          stateContent.attr("disabled", "disabled")
        success: (data) ->
          stateContent.empty() # remove old options
          $.each data, (key, value) ->
            stateContent.append($("<option></option>").attr("value", value[1]).text(value[0]))
          stateContent.removeAttr("disabled")
          unless originalValue == ""
            stateContent.val originalValue

    removeErrorClass: ->
      $('#new_checkout input.required').on 'focus, change', ->
        $(this).removeClass 'error'
        $(this).siblings('.help-inline').html ''
        $(this).parents('.control-group').removeClass 'error'

    creditcardRules: ->
      $('#checkout_credit_card_number').numeric()
      $('#checkout_credit_card_cvv').numeric()

    validateCouponCode: ->
      planName = $("#plan").val()
      couponCode = ''
      zipCode = $("#checkout_shipping_address_zip").val()
      data  = {coupon_code: couponCode, plan: planName, zip: zipCode}
      url   = "/#{planName}/level_up/checkouts/update_summary.js"

      $.ajax
        url: url,
        type: 'PUT',
        data: data

    setupValidateCouponCode: ->
      $("#validate-coupon").click (e)->
        e.preventDefault()
        CheckoutsNew.validateCouponCode()

      $('#checkout_shipping_address_zip').on 'change', ->
        CheckoutsNew.validateCouponCode()

    setupTshirtPopover: ->
      options = 
        container: 'body'
        html: true
        content: ->
          return $('#tshirt-popover-content').html()
        placement: (context, source) ->
          position = $(source).position()
          if position.left > 680
            return 'left'
          'top'
        trigger: 'click hover',
        delay:
          show: 50,
          hide: 400

      $("#tshirt-popover").popover(options).click (e) ->
        e.preventDefault()


    setupCVVPopover: ->
      $('#cvv-popover').click (e) ->
        e.preventDefault()

      $('#cvv-popover').popover
        container: 'body'
        html: true
        content: ->
          return $('#cvv-popover-content').html()
        title: ->
          return $('#cvv-popover-title').html()
        placement: 'top',
        trigger: 'click hover',
        delay:
          show: 50,
          hide: 400

  $ ->
    CheckoutsNew.init()
