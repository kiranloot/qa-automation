LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages.CheckoutSteps = ->

  # @see ./checkout-validations
  CheckoutValidator = LootCrate.pages.CheckoutValidator
  # @see ./checkout-billing-address
  BillingAddressToggle = LootCrate.pages.BillingAddressToggle

  init: ->
    @billingAddressToggle = new BillingAddressToggle()
    @billingAddressToggle.init()
    @step1()
    @step2()
    @step3()
    @setNavigation()
    @setStepOnLoad()
    @setStacked()
    @onWindowResize()

  isMobile: ->
    $('.checkout-app').hasClass('stacked')

  setStepOnLoad: ->
    # Unlock step 1
    # locks 2 and 3
    # this is for mobile navigation
    @unlockStep()
    @lockStep [1,2]
    dataErr = $('#three-step-region').attr('data-error')
    if dataErr == 'billing-region'
      @unlockStep 1
      setTimeout ->
        if $('.checkout-app').hasClass('stacked')
          $('#three-step-region').scrollTo $('.'+dataErr), 1000
      , 500
    else if dataErr == 'review-region'
      @unlockStep 2
      setTimeout ->
        if $('.checkout-app').hasClass('stacked')
          $('#three-step-region').scrollTo $('.'+dataErr), 1000
      , 500
    else
      @unlockStep 0

  setNavigation: ->
    @setTab $('.checkout_shirt_size'), (e) =>
      e.preventDefault()
      @_step1.response()

    @setTab $('#checkout_billing_address_full_name'), (e) =>
      e.preventDefault()
      $('#billing').focus()

    @setTab $('#billing'), (e) =>
      e.preventDefault()
      if @billingAddressToggle.isChecked()
        @_step2.response()
      else
        $('#checkout_billing_address_line_1').focus()

    @setTab $('.checkout_billing_address_country'), (e) =>
      e.preventDefault()
      @_step2.response()

  setTab: (el, _callback = ->) ->
    $(el).on 'keydown', (e) ->
      if e.keyCode == 9 && !e.shiftKey
        _callback e

  step1: ->
    @_step1 = new CheckoutValidator _.elementIsUnique('.shipping-region'),
      success: (form)=>
        @unlockStep 1
        @lockStep [0,2]
        @scrollToStep _.elementIsUnique('.billing-region')

      error: (form) =>
        @lockStep [1,2]

      active: (e) =>
        if @_step1.isValid false
          @unlockStep 0
          @lockStep [1,2]

  step2: ->
    @_step2 = new CheckoutValidator _.elementIsUnique('.billing-region'),
      success: (form)=>
        @unlockStep 2
        @lockStep [0,1]
        @scrollToStep  _.elementIsUnique('.review-region')

      error: (form) =>
        @lockStep [2]

      beforeEach: =>
        @billingAddressToggle.set_billing()

      active: (e) =>
        @billingAddressToggle.set_billing()
        if @_step1.isValid()
          @unlockStep 1
          @lockStep [0,2]

      backClick: (e) =>
        @unlockStep 0
        @lockStep [1,2]
        @scrollToStep  _.elementIsUnique('.shipping-region')

  step3: ->
    @_step3 = new CheckoutValidator _.elementIsUnique('.review-region'),

      success: (form)=>
        if $('.showCoupon').hasClass 'active'
          if($('#coupon-status').attr('data-valid') == 'false' && $('#checkout_coupon_code').val().length > 0)
            $('#checkout_coupon_code').addClass 'error'
          else
            $('#checkout_coupon_code').removeClass 'error'
            @postCheckout()
        else
          @postCheckout()

      active: (e) =>
        @billingAddressToggle.set_billing()
        if @_step1.isValid()
          if @_step2.isValid()
            @unlockStep 2
            @lockStep [0,1]

      backClick: (e) =>
        e.preventDefault()
        @unlockStep 1
        @lockStep [0,2]
        @scrollToStep  _.elementIsUnique('.billing-region')


  postCheckout: ->
    $('#checkout').prop('disabled', true)
    $('#checkout').prop("value", "PROCESSING...")
    $('#new_checkout').submit()

  unlockStep: (step)->
    $steps = _.getElement('.checkout-step')
    if $steps.length != 3
      throw new Error 'checkout steps are not correct'
    if @isMobile()
      $steps.eq(step).removeClass('hide')
    $steps.eq(step).find('div').first().addClass('active')
    $steps.eq(step).find('.click-guard').addClass('hide')

  lockStep: (steps) ->
    $steps = _.getElement('.checkout-step')
    if $steps.length != 3
      throw new Error 'checkout steps are not correct'
    for i in steps
      if @isMobile()
        $steps.eq(i).addClass('hide')
      $steps.eq(i).find('div').first().removeClass('active')
      $steps.eq(i).find('.click-guard').removeClass('hide')

  enforceSingleStepTabbing: (step) ->
    return step.on('keydown', 'button.btn-step', @preventForwardTabbing)

  preventForwardTabbing: (step) ->
    return 9 != step.keyCode || step.shiftKey ? 0 : step.preventDefault()

  scrollToStep: (el)->
    if $('.checkout-app').hasClass('stacked')
      $('#three-step-region').scrollTo $(el), 1000,
        onAfter: ->
          $(el).find('input:first').focus()
    else
      $(el).find('input:first').focus()

  onWindowResize: ->
    $(window).on 'resize', (e) => @setStacked()

  setStacked: ->
    $('.checkout-app').toggleClass("stacked", $(window).width() < 1000)
    $steps = _.getElement('.checkout-step')
    $steps.each (i, el) =>
      if $(el).find('div').first().hasClass('active')
        @unlockStep i
      else
        @lockStep [i]

