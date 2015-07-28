###
# billing_address-edit
###

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['billing_address-edit'] = ->

  EditBillingAddress = 

    init: ->
      EditBillingAddress.setup()
      EditBillingAddress.countryChange()
      return

    setup: ->
      LootCrate.Utag()
      LootCrate.FormValidator()
      return

    countryChange: ->
      $('#billing_address_country').change (e) ->
        target = $("#billing_address_state")
        $.ajax(
          url: "/address/states.js"
          type: "GET"
          data:
            country: $(this).val()
          beforeSend: ->
            target = $("#billing_address_state")
            target.attr("disabled", "disabled")
          success: (data) ->
            target = $("#billing_address_state")
            target.empty() # remove old options
            $.each data, (key, value) ->
              target.append($("<option></option>").attr("value", value[1]).text(value[0]))
            target.removeAttr("disabled")
        )

        if ($('#billing_address_country').val() != "" ) and ($("#billing_address_state").val() == "")
          $('#billing_address_country').trigger('change')

  $ ->

    EditBillingAddress.init()
    return









