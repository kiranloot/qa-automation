LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['user_accounts-index'] = ->

  UserAccounts =

    init: ->
      @onChangePlan()

    onChangePlan: ->
      $('#upgrade_subscriptions').on 'change', (ev) ->
        plan_name = $(@).val()
        $('#upgrade-link').attr('href', ('/subscriptions/' + plan_name + '/upgrade/preview'))

  $ ->

    UserAccounts.init()