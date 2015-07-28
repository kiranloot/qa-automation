###
# registrations-new
###

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.flip = ->

  flip =
    init: ->
      @events()

    flip: new TimelineMax()
    flipClear: true
    flipForms: (current, flipTo)->
      that = @
      if @flipClear
        @flip.clear()
        @flipClear = false
        @flip.to $(current), 0.25,
          rotationY: '90deg'
          perspective: 500
          onComplete: ->
            $(current).addClass 'hide'
            $(flipTo).removeClass 'hide'
            that.flip.from $(flipTo), 0.51,
              rotationY: '90deg'
              perspective: 500
              onComplete: ->
                that.flipClear = true
            that.flip.set $(current),
              rotationY: '0deg'
              opacity: 1 

    events: ->
      if WURFL.is_mobile
        @mobile_animation()
      else
        @desktop_animation()

    desktop_animation: ->
      $('.loginRegister').on 'click', (e)=>
        e.preventDefault()
        target = $(e.currentTarget).data('target')
        if target == '.oldFriend'
          @flipForms $('.newFriend'), $('.oldFriend')
        else
          @flipForms $('.oldFriend'), $('.newFriend')

    mobile_animation: ->
      $('#existing-customer-container').addClass 'front'
      $('#existing-customer-container').removeClass 'hide'
      $('#new-customer-container').addClass 'back'
      $flip = $('#login_or_registration').flip
        trigger: 'manual'
      $flip.css 'height', 500
      $('.newTrigger').on 'click', (e) ->
        e.preventDefault()
        $flip.flip true
      $('.loginTrigger').on 'click', (e) ->
        e.preventDefault()
        $flip.flip false

  $ ->
    flip.init()
