LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages['how_it_works-index'] = ->

  hiw = 

    init: ->
      LootCrate.Video()
      @setupPopover()

    setupPopover: ->
      $('#popover-more-info').click (e) ->
        e.preventDefault()

      $('#popover-more-info').popover
        container: 'body'
        html: true
        content: ->
          return $('#megacrate-popover-content').html()
        title: ->
          return $('#megacrate-popover-title').html()
        placement: 'top',
        trigger: 'click hover',
        delay:
          show: 50,
          hide: 400

  $ ->
    hiw.init()