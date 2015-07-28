LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages['express_checkouts-new'] = ->

  # @see ./checkout-steps
  CheckoutSteps = LootCrate.pages.CheckoutSteps
  # @see ./checkout-states
  CheckoutStates = LootCrate.pages.CheckoutStates
  # @see ./checkout-coupon
  CheckoutCoupon = LootCrate.pages.CheckoutCoupon

  CheckoutsNew =
    init: ->
      @setSteps()
      @loadStates()
      @showCoupon()

    showCoupon: ->
      checkoutCoupon = new CheckoutCoupon()
      checkoutCoupon.init()

    loadStates: ->
      checkoutStates = new CheckoutStates()
      checkoutStates.init()

    billingAddresToggle: ->
      billingAddressToggle = new BillingAddressToggle()
      billingAddressToggle.init()

    setSteps: ->
      steps = new CheckoutSteps()
      steps.init()

  $ ->
    CheckoutsNew.init()
