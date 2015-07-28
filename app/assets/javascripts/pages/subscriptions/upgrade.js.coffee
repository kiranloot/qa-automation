LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages['subscriptions-upgrade_preview'] = ->

  SubscriptionsUpgrade =

      init: ->
        LootCrate.twelveMonths()
        @upgradePreview()
        @preventMultipleClicks()

      upgradePreview: ->
        # Upgrade preview
        $('#upgrade_plan_name').change ->
          plan_name   = $(@).val()
          current_url = window.location.pathname
          
          if plan_name == '12-month-subscription' then LootCrate.month12.showUpgrade() else LootCrate.month12.hideUpgrade()

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

      preventMultipleClicks: ->
        # Prevent user from checking upgrades multiple times.
        $("#upgrade-button").click (e) ->
          e.preventDefault

          upgrade_submit_button = $('#upgrade-subscription')

          $(@).attr("disabled", true)
          $(@).attr("value", "UPGRADING...")

          upgrade_submit_button.submit()

  $ ->

    SubscriptionsUpgrade.init()
    return
