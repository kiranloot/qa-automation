# ###### #
# SOCIAL
# ###### #

LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Social = ->
  Social =
    init: ->
      @twitter()
      # this function needs to be global
      window.publish_to_wal = @publish_to_wall
      @bindings()

    twitter: ->
      #TWITTER
      !((d, s, id) ->
        js = undefined
        fjs = d.getElementsByTagName(s)[0]
        if !d.getElementById(id)
          js = d.createElement(s)
          js.id = id
          js.async = true
          js.src = '//platform.twitter.com/widgets.js'
          fjs.parentNode.insertBefore js, fjs
        return
      )(document, 'script', 'twitter-wjs')

    publish_to_wall: (link, picture, name, caption, description) ->
      FB.ui
        method: 'feed'
        link: link
        picture: picture
        name: name
        caption: caption
        description: description

    bindings: ->
      $('.close').click ->
        $(this).parents('.alert-bg').hide()

  $ ->
    Social.init()
