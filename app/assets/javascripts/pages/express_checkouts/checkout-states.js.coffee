LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages.CheckoutStates = ->

  init: ->
    @populateStates _.getElement('#checkout_shipping_address_country'), _.getElement("#checkout_shipping_address_state")
    @populateStates _.getElement('#checkout_billing_address_country'), _.getElement("#checkout_billing_address_state")

  countryChange: ->
    $shipping = _.getElement('#checkout_shipping_address_country')
    $shipping.change (e) =>
      @populateStates _.getElement('#checkout_shipping_address_country'), _.getElement("#checkout_shipping_address_state")

    $billing = _.getElement('#checkout_billing_address_country')
    $billing.change (e) =>
      @populateStates _.getElement('#checkout_billing_address_country'), _.getElement("#checkout_billing_address_state")

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

