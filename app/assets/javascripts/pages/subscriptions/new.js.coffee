LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['subscriptions-new'] = ->

  SubscriptionsNew = 

    init: ->
      @billingAddress()
      @disabledBtn()
      @submitBtn()
      @countrySelectorArrow()
      @notMyCountryLink()
      @countryChange()
      @upgradePreview()
      @preventMultipleClicks()
      @creditcardNumeric()

    billingAddress: ->
      $('#billing').click ->
            $('#subscription_billing_address_attributes_line_1').val($('#subscription_shipping_address_attributes_line_1').val())
            $('#subscription_billing_address_attributes_line_2').val($('#subscription_shipping_address_attributes_line_2').val())
            $('#subscription_billing_address_attributes_city').val($('#subscription_shipping_address_attributes_city').val())
            $('#subscription_billing_address_attributes_zip').val($('#subscription_shipping_address_attributes_zip').val())
            $('#subscription_billing_address_attributes_country').val($('#subscription_shipping_address_attributes_country').val())
            $('#subscription_billing_address_attributes_state').val($('#subscription_shipping_address_attributes_state').val())
            #$('#subscription_billing_address_attributes_full_name').val($('#subscription_shipping_address_attributes_first_name').val() + " " + $('#subscription_shipping_address_attributes_last_name').val())


    disabledBtn: ->
      $('.disabled').click (e) ->
        e.preventDefault()
        return false

    submitBtn: ->
      $("form#new_subscription").submit ->
        submit_button = $(this).find("input:submit")
        if submit_button.attr("disabled") == "true"
          false
        else
          submit_button.attr("disabled", true)
          submit_button.attr("value", "PROCESSING...")
          true  

    # country seletor shared methods
    # @see common/country_selection
    countrySelectorArrow: LootCrate.common['country_select'].countrySelectorArrow
    notMyCountryLink: LootCrate.common['country_select'].notMyCountryLink
    toggleArrow: LootCrate.common['country_select'].toggleArrow

    countryChange: ->
      $('#subscription_shipping_address_attributes_country').change (e) ->
        target = $("#subscription_shipping_address_attriubtes_state")
        $.ajax(
          url: "/address/states.js"
          type: "GET"
          data:
            country: $(this).val()
          beforeSend: ->
            target = $("#subscription_shipping_address_attributes_state")
            target.attr("disabled", "disabled")
          success: (data) ->
            target = $("#subscription_shipping_address_attributes_state")
            target.empty() # remove old options
            $.each data, (key, value) ->
              target.append($("<option></option>").attr("value", value[1]).text(value[0]))
            target.removeAttr("disabled")
        )

      $('#subscription_billing_address_attributes_country').change (e) ->
        target = $("#subscription_billing_address_attriubtes_state")
        $.ajax(
          url: "/address/states.js"
          type: "GET"
          data:
            country: $(this).val()
          beforeSend: ->
            target = $("#subscription_billing_address_attributes_state")
            target.attr("disabled", "disabled")
          success: (data) ->
            target = $("#subscription_billing_address_attributes_state")
            target.empty() # remove old options
            $.each data, (key, value) ->
              target.append($("<option></option>").attr("value", value[1]).text(value[0]))
            target.removeAttr("disabled")
        )

        if ($('#subscription_shipping_address_attributes_country').val() != "") and ($("#subscription_shipping_address_attributes_state").val() == "")
          $('#subscription_shipping_address_attributes_country').trigger('change')

        if ( $('#subscription_billing_address_attributes_country').val() != "" ) and ($("#subscription_billing_address_attributes_state").val() == "")
          $('#subscription_billing_address_attributes_country').trigger('change')

    upgradePreview: ->
      $('#upgrade_plan_name').change ->
        plan_name   = $(@).val()
        current_url = window.location.pathname

        if plan_name == '12-month-subscription' then lootFun.showUpgrade() else lootFun.hideUpgrade()

        $.ajax
          url: current_url
          data: selected_product: plan_name
          dataType: 'script'
          beforeSend: ->
            $('#upgrade_plan_name').addClass('hide-bg')
            $('#upgrade_plan_name').before('<i class="fa fa-spinner fa-pulse"></i>')
            $('#upgrade-button').prop('disabled', true)
          complete: ->
            $('#upgrade_plan_name').siblings('i').remove()
            $('#upgrade_plan_name').removeClass('hide-bg')
            $('#upgrade_plan_name').blur()
            $('#upgrade-button').prop('disabled', false)

        $('#upgrade_plan_name').show ->
          plan_name = $(@).val()

        if plan_name == '12-month-subscription' then lootFun.showUpgrade() else lootFun.hideUpgrade()

      preventMultipleClicks: ->
        # Prevent user from checking upgrades multiple times.
        $("#upgrade-button").click (e) ->
          e.preventDefault

          upgrade_submit_button = $('form#upgrade-subscription')

          $(@).attr("disabled", true)
          $(@).attr("value", "UPGRADING...")

          upgrade_submit_button.submit()

      creditcardNumeric ->
        $('#subscription_credit_card_number').numeric()
        $('#subscription_credit_card_cvv').numeric()


  $ ->

    SubscriptionsNew.init()
    return
