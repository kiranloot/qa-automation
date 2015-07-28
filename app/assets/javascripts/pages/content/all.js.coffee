LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.contentPayment = ->
  url = $('.mainblockouterwhite').data('url')
  title = $('.mainblockouterwhite').data('title')

  fbs_click = ->
    u = url
    t = title
    window.open 'http://www.facebook.com/sharer.php?u=' + encodeURIComponent(u) + '&t=' + encodeURIComponent(t), 'sharer', 'toolbar=0,status=0,width=626,height=436'
    false
