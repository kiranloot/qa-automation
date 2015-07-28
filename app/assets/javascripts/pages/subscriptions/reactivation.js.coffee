###
# Reactivation
###

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['subscriptions-reactivation'] = ->

  subscriptionReactivation =
    init: ->
      @setEvents()

    setEvents: ->
      $('.react_coupon_code').on 'keypress', (ev) ->
        code = ev.keyCode || ev.which
        if (code == 13)
          ev.preventDefault()
          $('#validate-reactivation-coupon').click()

      $('#validate-reactivation-coupon').click (ev) =>
        ev.preventDefault()
        @validateCoupon()

    validateCoupon: ->
      form        = $('#reactivate_subscription')
      url         = $('#coupon_code').data('url')
      validCoupon = false

      $('.reactLoadSpin').removeClass 'hide'
      $.ajax
        type: 'PUT'
        dataType: 'JSON'
        url: url
        data: form.serialize()
      .success((data) =>
        $('.reactLoadSpin').addClass 'hide'

        if data.valid_coupon == true
          @handleValidateSuccess(data)
        else
          @handleValidateError()
      )

    handleValidateSuccess: (data)->
      totalPayment = @numberToCurrency(data.total_payment)

      $('.reactSaved').show()
      @updateCouponStatus('Coupon Processed', 'green')
      $('#reactivation-total-payment').text(totalPayment)

    handleValidateError: ->
      @updateCouponStatus('Invalid Coupon', 'red')

    updateCouponStatus: (text, color) ->
      $('#coupon-status').text(text)
      $('#coupon-status').css('color', color)

    numberToCurrency: (amount) ->
      "$#{Number(amount).toFixed 2}"
  $ ->
    subscriptionReactivation.init()
