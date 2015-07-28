# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['welcome-index'] = ->

  welcome = 

    init: ->
      @setup()
      @carousels()
      @autoSlide()
      @heroCarousel()
      @pressCarousel()
      @press()
      @newsletterModal()

    setup: ->
      LootCrate.selectPlan()
      LootCrate.twelveMonths()
      LootCrate.countDownTimer()

    # Carousels
    carousels: ->
      $('.carousel-indicators li:first').trigger 'click'

      $('.carousel').swipe

        swipe: (event, direction) ->
          if direction is 'left'
            $(this).carousel 'next'

          if direction is 'right'
            $(this).carousel 'prev'

        # Distance to swipe (in pixels)
        threshold: 0

        # Allow vertical scrolling by ignoring vertical swipes
        allowPageScroll: 'vertical'


    # Class to prevent autosliding the carousel
    autoSlide: ->
      $('.no-autoslide').carousel
        pause: true
        interval: false    


    # Hero Carousel
    heroCarousel: ->
      $('#main-banner-carousel').carousel()

      checkClass = (item) ->
        if item.hasClass('light')
          $('#primary-navbar, .slide-arrows-container').removeClass('dark').addClass('light')

        if item.hasClass('dark')
          $('#primary-navbar, .slide-arrows-container').removeClass('light').addClass('dark')

      firstSlide = $('#main-banner-carousel .item:first').find('.main-banner-textbox')
      checkClass(firstSlide)
      $('#main-banner-carousel').on 'slide.bs.carousel', ->
        activeSlide = $('#main-banner-carousel').find('.item.active').find('.main-banner-textbox')
        checkClass(activeSlide)

    # Press Carousel
    pressCarousel: ->
      $('#press-carousel').on 'slide.bs.carousel', (e) ->
        slideNum = $(e.relatedTarget).index()

        # Crossfade Press Quote
        $('.press-quote[data-press-slide]:visible').fadeOut 300, ->
          $(this).removeClass('active')
          $('.press-quote[data-press-slide="' + slideNum + '"]').fadeIn 300, ->
            $('.press-quote[data-press-slide="' + slideNum + '"]').addClass('active')

        # Change Active Icon
        $('ol.logo-list li[data-press-slide].active').removeClass('active')
        $('ol.logo-list li[data-press-slide="' + slideNum + '"]').addClass('active')

    #Press
    press: ->
      $('#contentWrap div').hide()
      $('#contentWrap div:first').show()
      $('#thumbs .press-bar-logo:first').addClass 'active'
      $('#thumbs .press-bar-logo').mouseenter ->
        if $(this).hasClass('active') == true
          false
        else
          $('.press-bar-logo.active').removeClass 'active'
          $(this).addClass 'active'
          $('#contentWrap div').fadeOut()
          $(document.getElementById($(this).attr('id') + '-quote')).fadeIn()
          false

    newsletterModal: ->
      setupWFNewsletter = (->
        options = {
          "backdrop" : "static"
        }
        if (!$.cookie('wf-newsletter'))
          $.cookie('wf-newsletter', 1);
          $('#wf-newsletter-modal').modal(options);
      )()

  $ ->
    welcome.init()
