# ############## #
# COMMON
# ############## #
# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.resizeTip = ->
  resizeTip =
    init: ->
      @setup()
    setup: ->
      $(window).resize((ev) =>
        ev.stopPropagation()
        @resize()
      ).resize()
    isIe: ->
      ua = window.navigator.userAgent
      msie = ua.indexOf('MSIE ')
      trident = ua.indexOf('Trident/')
      if msie > 0
        # IE 10 or older => return version number
        parseInt ua.substring(msie + 5, ua.indexOf('.', msie)), 10
      if trident > 0
        # IE 11 (or newer) => return version number
        rv = ua.indexOf('rv:')
        parseInt ua.substring(rv + 3, ua.indexOf('.', rv)), 12
      # other browser
      false
    resize: (ev) ->
      # Correct IE 9 Issues
      if @isIe() == 9
        $('.aDownz').css 'right': '0.8em'

        if $(window).width() <= 979
          $('.line_item_quantity').css 'margin-left': '36px'
          $('#cart_modal table#line-items tr td input[type="number"], #cart table#line-items tr td input[type="number"]').css 'width': '50px'
        else
          $('.line_item_quantity').css 'margin-left': 'inherit'
  $ ->
    resizeTip.init()
