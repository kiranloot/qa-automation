###
  community-index page -> community
###
#
LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

# page scope
LootCrate.pages['community-index'] = ->
  server = "//postano-embed.s3.amazonaws.com/prod";
  ((id)->
    if document.getElementById(id) then return
    js = document.createElement('script')
    js.id = id
    js.async = true
    js.src = server + '/scripts/embed.js'
    document.body.appendChild(js)
  )('postano-embed')
