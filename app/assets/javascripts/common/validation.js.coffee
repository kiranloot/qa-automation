# ############## #
# FORM VALIDATOR
# ############## #
LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.FormValidator = (ajax = false, ajaxOptions = ->) ->
  
  Validations =
    isCheckout: false

    init: ($forms)->
      if $forms.first().attr('id') == 'new_checkout' then @isCheckout = true
      $forms.each (i,form) =>
        @validate $(form)

    validate:  ($form)->
      if $form.length == 1
        $form.on 'submit', (e) =>
          e.preventDefault()
          error_count = 0
          if @isCheckout
            @set_billing($(e.currentTarget))

          $items = @getElements $form
          $coupon_status = $('#coupon-status')
          $coupon_code = $('#checkout_coupon_code')

          removeClass = ($input, classStr)->
            $input.bind 'focus', ->
              $(@).removeClass classStr
              $(@).unbind 'focus'

          $items.each (i, item)->
            if $(item).val() == ''
              $(item).addClass 'error'
              removeClass $(item), 'error'
              error_count++
            else
              $(item).addClass 'valid'
              removeClass $(item), 'valid'

          if($coupon_status.attr('data-valid') == 'false' && $coupon_code.val().length > 0)
            $coupon_code.addClass 'error'
            removeClass $coupon_code, 'error'
            error_count++
          else
            $coupon_code.addClass 'valid'
            removeClass $coupon_code, 'valid'

          $('.alert-error').remove()
          if error_count == 0
            $('#checkout').prop('disabled', true)
            $('#checkout').val('PROCESSING...')
            form = $form
            if ajax == 'ajax'
              @ajaxValidation form, ajaxOptions
            else
              setTimeout ->
                $form.off('submit')
                $form.delay(1000).submit()
              , 1000
          else
            if error_count > 1
              errorTxt = error_count + ' errors'
            else
              errorTxt = error_count + ' error'

            alertMsg = '<div class="alert alert-error js-alert"><a class="close" data-dismiss="alert">×</a>' + errorTxt + ' prevented your checkout from being completed.</div>'
            $('.navbar').before alertMsg
            $('html, body').animate {scrollTop: $form.position().top}, 'slow'

    set_billing: ($_form)->
      inputs = [
        'checkout_shipping_address_line_1',
        'checkout_shipping_address_line_2',
        'checkout_shipping_address_city',
        'checkout_shipping_address_state',
        'checkout_shipping_address_zip'
      ]

      if $('#billing').prop('checked')

        inputs.forEach (el)->
          ship_el = el.replace 'shipping', 'billing'
          if $("##{ship_el}").hasClass 'select2'
            $("##{ship_el}").select2 'val', $("##{el}").val()
          else
            $("##{ship_el}").val $("##{el}").val()

    getElements: ($form) ->
      inputs = $form.find('input.required,select.required').not(':hidden,:checkbox,#checkout_coupon_code,#validate-coupon,#checkout')
      if @isCheckout
        if $form.find('#billing').prop('checked')
          selects = $form.find('select.required').not('#checkout_shipping_address_country,#checkout_billing_address_state')
        else
          selects = $form.find('select.required').not('#checkout_shipping_address_country')
        $.merge(inputs, selects)
      else
        $.merge(inputs, [])

    mergeOptions: (args) ->
      @merge {
        url: $(args[0]).attr('action')
        type: $(args[0]).attr('method').toUpperCase()
        data: $(args[0]).serialize()
        dataType: 'script'
        cache: false
        complete: ->
        success:->
        error: ->
      }, args[1]

    setCallbacks: (args, ops) ->
      if args[1].success?
        ops = @merge ops,
          success: (response)->
            args[1].success(args[0], response)

      if args[1].error?
        ops = @merge ops,
          error: (response)->
            args[1].error(args[0], response)

      if args[1].beforeSend?
        ops = @merge ops,
          beforeSend: (response)->
            args[1].beforeSend(args[0], response)
      ops

    ajaxValidation: (form, _options = {}) ->
      options = @mergeOptions(arguments)
      options = @setCallbacks(arguments, options)
      $.ajax options

    merge: (o1, o2) ->
      nO = {}
      for k, val of o1
        nO[k] = val
      for k2, val2 of o2
        nO[k2] = val2
      nO

  $ ->
    Validations.init $('.form-validate')
