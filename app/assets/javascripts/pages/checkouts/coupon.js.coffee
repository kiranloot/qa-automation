LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.common = LootCrate.common || {}

LootCrate.common['checkouts-coupon'] =
  start: (@options = {}) ->
    @getElements()
    @updateCalculatedCost()
    @updateSummary()

  getElements: ->
    @$todaysTotal = $('#todays-total-subscribe')
    @$couponSpiner = $('#coupon-spinner')
    @$couponStatus = $('#coupon-status')
    @$checkoutCouponCode = $('#checkout_coupon_code')

  updateSummary: ->
    if @isValid()
      @setValidMessage()
    else
      @setInvalid()

  isValid: ->
    @options.valid && @options.discount

  setValidMessage: ->
    @$couponStatus.attr('data-valid', 'true')
    @$couponStatus.text "Coupon valid: save #{@options.discount}"
    @switchClass @$couponStatus, 'green', 'red'
    @switchClass @$checkoutCouponCode, '', 'error'

  setInvalid: ->
    if @$checkoutCouponCode.val().length > 0
      @$couponStatus.attr('data-valid', 'false')
      @setErrors()

  setErrors: ->
    @invalidMessage()
    @switchClass @$couponStatus, 'red', 'green'

  invalidMessage: ->
    @$couponStatus.text 'Coupon invalid.'

  switchClass: ($input, newClass, oldClass) ->
    $input.addClass(newClass).removeClass(oldClass)

  updateCalculatedCost: ->
    @updateTotal()
    @updateCoupon()
    @updateTax()

  updateCoupon: ->
    @$couponSpiner.hide()
    discount = @options.discount

    if @currencyAmountToNumber(discount) > 0
      $('#coupon-discount-amount').text discount
      $('.subscription-coupon').removeClass 'hide'
    
  updateTotal: ->
    todayTotal = @options.total
    @$todaysTotal.text todayTotal
    $('#subscription-today-total').text todayTotal

  updateTax: ->
    taxRate   = @options.taxRate
    taxCharge = @options.taxCharge
    taxRegion = @options.taxRegion

    if taxRate > 0
      $('.subscription-tax').removeClass 'hide'
      $('#subscription-sales-tax').text "Sales Tax #{taxRegion} (#{@floatToPercentage(taxRate)}%) #{taxCharge}"
    else
      $('.subscription-tax').addClass 'hide'

  currencyAmountToNumber: (amount) ->
    Number amount.replace(/[^0-9.]+/g, ''), ''

  floatToPercentage: (float) ->
    float * 100
