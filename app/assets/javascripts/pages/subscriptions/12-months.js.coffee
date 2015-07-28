# ############## #
# !2 months bindings
# welcome page
# and upgrade subscription
# ############## #

LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.twelveMonths = ->
  lootCheck = []
  twelveMonths =
    init: ->
      twelveMonths.events()
      @isUpgrade()
      setTimeout ((ev) ->
        twelveMonths.sheen()
        if twelveMonths.mobilecheck()
        else
          twelveMonths.goShirt()
        twelveMonths.sheenInterval()
        return
      ), 2000
      return
    vars: sheen: $('.fSheen')
    mobilecheck: -> WURFL.is_mobile 
    events: ->
      $('.subscription .lYear').mouseover (ev) ->
        if twelveMonths.mobilecheck()
        else
          twelveMonths.goShirt()
        return
      $('.lYear').on 'mouseout', (ev) ->
        twelveMonths.byeShirt()
        return
      $('.giftBanner').click (ev) ->
        planTarget = $('.planBoxTarget').offset().top
        $(window).scrollTop planTarget - 105
        return
      return
    sheen: ->
      sheen = $('.fSheen')
      sh1 = new TimelineMax
      sh1.to sheen, 0.63,
        opacity: 0.9
        left: '10em'
      sh1.to sheen, 0.3, {
        opacity: 0
        left: '21em'
      }, '-=0.3'
      sh1.set sheen, left: '-10em'
      return
    expandBar: ->
      fBar = $('.flagContent')
      fB1 = new TimelineMax
      return
    resetBar: ->
      fBar = $('.flagContent')
      fB1 = new TimelineMax
      fB1.to fBar, 0.5, padding: '0px'
      return
    goShirt: ->
      shirT = $('.shirtCtrl')
      shirtT = new TimelineMax
      shirtT.to shirT, 0.7,
        opacity: '1'
        ease: Expo.easeInOut
      return
    byeShirt: ->
      shirT = $('.shirtCtrl')
      shirtT = new TimelineMax
      shirtT.to shirT, 0.5,
        opacity: '0'
        ease: Expo.easeInOut
      return
    sheenInterval: ->
      gapTime = twelveMonths.ranGap()
      setTimeout ((ev) ->
        twelveMonths.sheen()
        twelveMonths.sheenInterval()
        return
      ), gapTime
      return
    bounceGift: ->
      gapTime = Math.floor(Math.random() * 3)
      gapTime = 5000
      gSkipz = new TimelineMax
      gIcon = $('.incFree .fa-gift')
      gSkipz.to gIcon, 0.4, {
        top: '-15px'
        repeat: 1
        yoyo: true
        onComplete: twelveMonths.bounceGift
      }, 5
      return
    latentShirtHide: ->
      setTimeout (->
        twelveMonths.byeShirt()
        return
      ), 6000
      return
    isUpgrade: ->
      if $('#upgrade_plan_name').val() == '12-month-subscription'
        @showUpgrade()
    showUpgrade: ->
      upNow = $('.upNow')
      selz = $('#upgrade_plan_name')
      incz = $('.incFree')
      gIcon = $('.incFree .fa')
      gBounce = new TimelineMax
      upz = new TimelineMax
      upz.set gIcon, position: 'relative'
      upz.to upNow, 1,
        opacity: 1
        display: 'block'
      upz.to selz, 0.7, 'text-indent': '5%'
      if navigator.userAgent.toLowerCase().indexOf('firefox') > -1
        upz.to selz, 0.7, 'text-indent': '0'
      upz.to incz, 1, opacity: 1
      upz.to gIcon, 0.4, top: '-15px'
      upz.to gIcon, 0.4,
        top: '0'
        onComplete: twelveMonths.bounceGift
      return
    hideUpgrade: ->
      upNow = $('.upNow')
      selz = $('#upgrade_plan_name')
      incz = $('.incFree')
      downz = new TimelineMax
      #downz.to(upNow, 1, {opacity:0, display:'none'})
      downz.to incz, 0.4, { opacity: 0 }, '-=0.8'
      downz.to selz, 0.4, 'text-indent': '29%'
      if navigator.userAgent.toLowerCase().indexOf('firefox') > -1
        downz.to selz, 0.4, 'text-indent': '0'
      return
    ranGap: ->
      times = [
        2000
        3000
        2500
      ]
      randTime = Math.floor(Math.random() * 3)
      times[randTime]

  $ ->
    twelveMonths.init()
    window.LootCrate.month12 = twelveMonths

  
  
