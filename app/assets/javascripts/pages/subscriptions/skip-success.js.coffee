LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['subscriptions-skip_a_month_success'] = ->

  SkipSuccess =

    init: ->
      @initRedirect()

    initRedirect: ->
      setTimeout (->
        window.location.href = '/user_accounts/subscriptions'
        return
      ), 10000

  $ ->

    SkipSuccess.init()