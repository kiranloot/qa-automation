###
# passwords-new
###
LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['passwords-new'] = ->

  PasswordNew =

    init: ->
      @binding()

    alertSend: ($form) ->
      success = $('.successPass')
      success.removeClass 'hide'
      TweenMax.to success, 1,
        opacity: 1
        display: 'block'
      setTimeout ->
        $form.off('submit')
        $form.submit()
      , 2000

    binding: ->
      $form = $('#new_user')
      $form.on 'submit', (e) =>
        e.preventDefault()
        $email = $('#user_email')
        if $email.val()
          $email.removeClass 'error'
          $email.addClass 'valid'
          @alertSend $(e.currentTarget)
        else
          $('.successPass').addClass 'hide'
          $email.removeClass 'valid'
          $email.addClass 'error'

  $ ->
    PasswordNew.init()
