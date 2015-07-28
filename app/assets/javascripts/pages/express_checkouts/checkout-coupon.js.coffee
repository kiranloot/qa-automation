LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages.CheckoutCoupon = ->

  init: ->
    @setupValidateCouponCode()
    @showCoupon()

  showCoupon: ->
    $('.showCoupon').on 'click', ->
      if $(this).hasClass('active')
        $('.checkImOff').show()
        $('.checkImOn').hide()
        $('.showCoupon').removeClass 'active'
        $('.checkout_coupon_code').closest('.row').addClass('hide')
        if $('#coupon-status').attr('data-valid')=='false'
          $('#coupon-status').text('')
          $('#checkout_coupon_code').val('')
          $('#coupon-status').attr('data-valid', '')
      else
        $('.checkImOn').show()
        $('.checkImOff').hide()
        $('.showCoupon').addClass 'active'
        $('#checkout_coupon_code').removeClass('error')
        $('.checkout_coupon_code').closest('.row').removeClass('hide')

  setupValidateCouponCode: ->
    $("#validate-coupon").click (e) =>
      e.preventDefault()
      @validateCouponCode()

    $('#checkout_shipping_address_zip').on 'change', =>
      @validateCouponCode()

  validateCouponCode: ->
    planName = $("#validate-coupon").data('plan')
    couponCode = encodeURIComponent $("#checkout_coupon_code").val()
    zipCode = $("#checkout_shipping_address_zip").val()
    data  = {coupon_code: couponCode, plan: planName, zip: zipCode}
    url   = "/#{planName}/checkouts/update_summary.js"

    $.ajax
      url: url,
      type: 'PUT',
      data: data,
      beforeSend: ->
        if ($("#checkout_coupon_code").val() != "")
          $("#coupon-status").html("")
          $("#coupon-spinner").show()

