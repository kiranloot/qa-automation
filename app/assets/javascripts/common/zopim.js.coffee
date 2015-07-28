# ############## #
# ZOPIM
# ############## #

# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate or {}

LootCrate.Zopim = ->

  zoopim =
    init: ->
      @setup()
    setup: ->
      @zopimTimer()
    showZopim: ->
      window.$zopim or ((d, s) ->
        z = $zopim = (c) ->
          z._.push c

        $ = z.s = d.createElement(s)
        e = d.getElementsByTagName(s)[0]

        z.set = (o) ->
          z.set._.push o

        z._ = []
        z.set._ = []
        $.async = !0
        $.setAttribute 'charset', 'utf-8'
        $.src = '//v2.zopim.com/?2DvAQcf57bGVE00t0lUn1yVzMeiNnQyi'
        z.t = +new Date
        $.type = 'text/javascript'
        e.parentNode.insertBefore $, e
      )(document, 'script')
    isMobile: WURFL.is_mobile
    isShown: false
    show: ->
      if !@isMobile and !@isShown
        @isShown = true
        @showZopim()
    time: 60 * 1000
    zopimTimer: ->
      # on minute
      setTimeout ((that)->
        return ->
          that.show())(@), @time
      $(window).scroll =>
        scrollTop = $(window).scrollTop()
        documentHeight = $(document).height()
        windowHeight = $(window).height()
        footerInnerHeight = $('#footer').innerHeight()
        if scrollTop >= documentHeight - windowHeight - footerInnerHeight
          if !@isShown
            clearTimeout @show
            @show()
  $ ->
    zoopim.init()

