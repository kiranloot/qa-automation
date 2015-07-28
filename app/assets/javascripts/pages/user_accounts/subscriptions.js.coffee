LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages['user_accounts-subscriptions'] = ->

  userAccounts =

    init: ->
      @cancelSurvey()
      @showHidePanel()
      @showHideForm()
      @upgradeSubscription()
      LootCrate.FormValidator 'ajax',
        success: => @success arguments
        error: => @error arguments
        beforeSend: => @beforeSend arguments

    cancelSurvey: ->
      if window.location.search.match 'survey'
        $('#survey_invite').modal backdrop: 'static'

    showHidePanel: ->
      $('.showhide').click (event) ->
        event.preventDefault()
        hpanel = $(this).closest('div.hpanel')
        icon = $(this).find('i:first')
        body = hpanel.find('div.panel-body')
        footer = hpanel.find('div.panel-footer')
        body.slideToggle 300
        footer.slideToggle 200
        icon.toggleClass('fa-chevron-up').toggleClass 'fa-chevron-down'
        hpanel.toggleClass('').toggleClass 'panel-collapse'
        return

    showHideForm: ->
      if $('[data-pmb-action]')[0]
        $('body').on 'click', '[data-pmb-action]', (e) ->
          e.preventDefault()
          d = $(this).data('pmb-action')
          if d == 'edit'
            $(this).closest('.panel').toggleClass 'toggled'
            if $(this).closest('.panel').hasClass 'toggled'
              LootCrate.Address()
            if !$(this).closest('.panel').find('.panel-collapse').hasClass('in')
              $(this).closest('.panel').find('a.collapsed').click()
          if d == 'reset'
            $(this).closest('.panel').removeClass 'toggled'
          return

      $('.collapse').on 'hidden.bs.collapse', ->
        $('.panel').removeClass 'toggled'
        return
      $('.collapse').on 'show.bs.collapse', ->
        $(this).parents('.panel-group').find('.panel-heading').removeClass 'show'
        $(this).parent().find('.panel-heading').addClass 'show'
        return

    upgradeSubscription: ->
      $('#upgradeable-subscriptions').on 'change', (event) ->
        event.preventDefault()
        id = $(this).select2('val')
        $('#upgrade-promotion #upgrade-link').attr('href', "/subscriptions/#{id}/upgrade/preview")

    beforeSend: (args) ->
      $('form').find('.loader').show()

    success: (args) ->
      $('form').find('.loader').hide()
      $('form').closest('.panel').removeClass 'toggled'

    error: (args) ->
      $('form').find('.loader').hide()
      $('form').closest('.panel').removeClass 'toggled'

  $ ->
    userAccounts.init()
