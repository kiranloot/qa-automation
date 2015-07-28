# ############## #
# NAVBAR
# ############## #

LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Nav = ->

  Nav =
    init: ->
      @setup()
      @animations()
      @resize()
    setup: ->
      @shs_animate()
      @slider()
      @navToggle()
    shs_animate: ->
      item_height = jQuery('#shs_slider_ul .shs_items').outerHeight()
      top_indent = parseInt(jQuery('#shs_slider_ul').css('top')) + item_height
      jQuery('#shs_slider_ul:not(:animated)').animate { 'top': top_indent }, 1000, ->
        jQuery('#shs_slider_ul .shs_items:first').before jQuery('#shs_slider_ul .shs_items:last')
        jQuery('#shs_slider_ul').css 'top': '-100px'
    slider: ->
      that = @
      jQuery('#shs_slider_ul .shs_items:first').before jQuery('#shs_slider_ul .shs_items:last')
      jQuery('#shs_slider_ul').css 'top': '-100px'
      shs = setInterval((->
        that.shs_animate()
      ), 8000)
      jQuery('#shs_slider_cont').hover (->
        clearInterval shs
      ), ->
        shs = setInterval((->
          that.shs_animate()
        ), 8000)
    navToggle: ->
      # Toggle class which opens/closes the Responsive Sidebar.
      $(document).on 'click', '[data-toggle-responsive-menu]', (e) ->
        e.preventDefault()
        $('body').toggleClass('responsive-nav-open')

      $(document).on 'click', '[data-toggle-account-responsive-menu]', (e) ->
        e.preventDefault()
        $('body').toggleClass('responsive-account-nav-open')

        loot_drop = $(this).parent().next('.loot-drop')
        loot_drop_menu = loot_drop.find('.account-drop-menu')

        loot_drop_menu.slideToggle 'fast', ->
          loot_drop_menu.removeAttr('style')
          loot_drop.toggleClass('open')

      # Toggle class which opens/closes a Responsive Sidebar item's dropdown menu.
      $(document).on 'click', '[loot-drop-toggle]', (e) ->
        e.preventDefault()

        loot_drop = $(this).closest('.loot-drop')
        loot_drop_menu = loot_drop.find('.loot-drop-menu')

        loot_drop_menu.slideToggle 'fast', ->
          loot_drop.toggleClass('open')

          # Remove the inline styles given by jQuery in favor of the CSS styles.
          loot_drop_menu.removeAttr('style')
    animations: ->
      $(window).scroll ->
        if $(window).scrollTop() > 40
          $('.logo-navbar, #primary-navbar, #hello-bar').addClass('stuck')

          # This is a hack for firefox to fix transitions on children of parent nodes
          # whose position is changed simultaneously to the transition.
          setTimeout (->
            $('#primary-navbar > .container > ul > li, .main-content').addClass('stuck')
          ), 50
        else
          $('.logo-navbar, #primary-navbar, #hello-bar').removeClass('stuck')

          # Same hack as above, but in reverse.
          setTimeout (->
            $('#primary-navbar > .container > ul > li, .main-content').removeClass('stuck')
          ), 50
    resize: ->
      # Prevent flash of animation on window width change
      $(window).resize ->
        if $('.desktop-only').css('display') == 'none'
          $('#primary-navbar').addClass('no-transition')
        else
          $('#primary-navbar').removeClass('no-transition')
  $ ->
    Nav.init()
