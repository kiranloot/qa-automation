LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.common = LootCrate.common || {}

LootCrate.common['country_select'] =
  countrySelectorArrow: ->
    $('.country-selectbox').prepend '<div class="arrowAlert"><i class="fa fa-arrow-right"></i></div>'
    $('.arrowAlert').addClass 'hide'

  notMyCountryLink: ->
    $('#not_my_country').click (e) ->
      e.preventDefault()
      $('html, body').animate({ scrollTop: $(document).height()}, 1500).promise().done ->
        LootCrate.common['country_select'].toggleArrow true
        setTimeout ->
          LootCrate.common['country_select'].toggleArrow false
        , 6000

  toggleArrow: (show = false) ->
    $arrow = $('.arrowAlert')
    if show
      $arrow.removeClass 'hide'
      $arrow.find('i.fa-arrow-right').addClass('blink-blink')
    else
      $arrow.find('i.fa-arrow-right').removeClass('blink-blink')
      $arrow.addClass 'hide'

