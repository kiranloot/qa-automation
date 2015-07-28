LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}

LootCrate.pages['amiibo-index'] = ->
  register = ($form) ->
    $.ajax
      type: $form.attr('method')
      url: $form.attr('action')
      data: $form.serialize()
      cache: false
      dataType: 'jsonp'
      jsonp: 'c'
      contentType: 'application/json; charset=utf-8'
      error: (err) ->
        show_message 'Could not connect to the registration server. Please try again later.'
        return
      success: (data) ->
        showMessage data
        return
    return

  # we only need to validate the email address
  validate_input = ($form) ->
    email = $form.find('#user_email').val()
    regex = /[^@]+@[^@.]+\.[^@.]+/
    # basic check: looks for '@' and '.' (e.g. something@something.something)
    regex.test email

  # show the result from MailChimp in the popup window.
  showMessage = (data) ->
    if data.result == 'success'
      $('#ajaxmessage').html 'Loot Crate and amiibo™ thank you for registering.<br>Please check your email to confirm your registration.'
      $('#amiibo-lightbox-background').click ->
        window.location.href = '//www.lootcrate.com/'
        return
      #$("#amiibo-lightbox-background").hide(); }); // for testing
      $('#amiibo-alert-button').text 'CONTINUE'
    else
      $('#ajaxmessage').html data.msg
      $('#amiibo-lightbox-background').click ->
        $('#amiibo-lightbox-background').hide()
        return
      $('#amiibo-alert-button').text 'TRY AGAIN'
    $('#amiibo-lightbox-background').show()
    return

  $(document).ready ->
    $form = $('#new_user')
    if $form.length > 0
      #Set form action and method for ajax, instead of standard post to MailChimp page. This way the form still works if js doesn't load.
      $form.attr 'action', '//lootcrate.us5.list-manage.com/subscribe/post-json?u=1f53721d6da415ab862195987&amp;id=d1e489b21b'
      $form.attr 'method', 'get'
      $('form input[type="submit"]').bind 'click', (event) ->
        $('#user_email_label').text ''
        if event
          event.preventDefault()
        if validate_input($form)
          register $form
        else
          $('#user_email_label').text 'Please check your email address and try again.'
        return
    $('#lightbox').click (event) ->
      if 'amiibo-alert-button' != event.target.id
        event.stopPropagation()
      return
    return
