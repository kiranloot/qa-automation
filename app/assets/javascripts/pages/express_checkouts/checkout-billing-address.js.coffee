LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages.BillingAddressToggle = ->

  init: ->
    @onPageLoad()
    @onCheckboxChange()

  isChecked: ->
    $('#billing').attr('checked') == 'checked'

  onPageLoad: ->
    if $('#billing').attr('checked')
      $('.billToggle').hide()
    else
      $('.billToggle').show()

  onCheckboxChange: ->
    $('#billing').on 'change', (e) =>
      if $(e.currentTarget).attr('checked')
        $(e.currentTarget).removeAttr 'checked'
        $('.billToggle').show()
        @clear_billing()
      else
        $(e.currentTarget).attr 'checked', true
        $('.billToggle').hide()
        @set_billing()

  billingInputs: [
    'checkout_shipping_address_line_1',
    'checkout_shipping_address_line_2',
    'checkout_shipping_address_city',
    'checkout_shipping_address_state',
    'checkout_shipping_address_zip'
  ]

  clear_billing: ->
    unless @isChecked()
      @billingInputs.forEach (el)->
        ship_el = el.replace 'shipping', 'billing'
        $("##{ship_el}").removeClass 'error'
        $("##{ship_el}").removeClass 'valid'
        if $("##{ship_el}").hasClass 'select2'
          $("##{ship_el}").select2 'val', ''
        else
          $("##{ship_el}").val ''


  set_billing: ->
    if @isChecked()
      @billingInputs.forEach (el)->
        ship_el = el.replace 'shipping', 'billing'
        if $("##{ship_el}").hasClass 'select2'
          $("##{ship_el}").select2 'val', $("##{el}").val()
        else
          $("##{ship_el}").val $("##{el}").val()

