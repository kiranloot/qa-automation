# ############## #
# VIDEO
# ############## #

# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Video = ->

  Video =
    init: ->
      @setup()
    setup: ->
      # Feature Video
      params = allowScriptAccess: 'always'
      swfobject.embedSWF 'http://www.youtube.com/apiplayer?enablejsapi=1&playerapiid=featuredVideo', 'featuredVideo', '100%', '100%', '8', null, null, params

      # Video Banner Animation
      animationSpeed = 350

      mainContentOriginalMargin = $('.main-content').css('margin-top')
      fvOriginalHeight = $('#featured-video-banner').css('height')
      fvOverlays = $('#featured-video-banner .featured-video-overlay, #featured-video-banner .overlay-content')
      videoID = $('#featuredVideo').data('video-id')
      blackOverlay = $('#featured-video-banner .black-overlay')

      # Play the Video
      $('[data-featured-video-play]').one 'click', ->
        featuredVideo.loadVideoById videoID

      # Handle the expanding video player banner
      $('[data-featured-video-play]').on 'click', (e) ->
        e.preventDefault()

        fvOverlays.fadeOut animationSpeed, ->
          featuredVideo.playVideo()
          windowHeight = $(window).height()

          # Add Class to Change z-index
          $('#featured-video-banner').addClass('playing')
          # Add Class to disable transitions
          $('.main-content').addClass('no-transition')
          # Scroll to the top of the page if not already there
          $('html, body').animate
            scrollTop: 0
          , animationSpeed
          # Animate the Margin-top of the Main Content
          $('.main-content').animate
            marginTop: 0
          , animationSpeed
          # Animate the height of the Featured Video
          $(this).closest('#featured-video-banner').animate
            height: windowHeight + 'px'
          , animationSpeed, ->
            blackOverlay.fadeOut animationSpeed

      # Close the Video
      $('[data-featured-video-close]').click ->
        featuredVideo.pauseVideo()

        blackOverlay.fadeIn animationSpeed, ->
          fvOverlays.fadeIn animationSpeed
          # Animate the Margin-top of the Main Content
          $('.main-content').animate
            marginTop: mainContentOriginalMargin
          , animationSpeed
          # Animate the height of the Featured Video
          $(this).closest('#featured-video-banner').animate
            height: fvOriginalHeight
          , animationSpeed, ->
            # Remove Class to Change z-index
            $('#featured-video-banner').removeClass('playing').removeAttr('style')
            # Remove Class to disable transitions
            $('.main-content').removeClass('no-transition').removeAttr('style')
  $ ->
    Video.init()

  
