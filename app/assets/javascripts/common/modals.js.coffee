# ############## #
# MODALS VALIDATOR
# ############## #

# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Modals = ->

  Modals =
    init: ->
      @setup()

    setup: ->
      @bindings()
      @loginModalValidations()
      @registerValidations()

    bindings: ->
      $('.login_bar').on 'click', 'a', (e) ->
        if $(e.currentTarget).children().hasClass('login')
          $('#signin_modal').modal()
        if $(e.currentTarget).hasClass('register')
          $('#register_modal').modal()

      $('#navbar-user .signin-mobile').on 'click', ->
        $('#signin_modal').modal()

      $('#primary-navbar .signup-mobile').on 'click', ->
        $('#register_modal').modal()

    loginModalValidations: ->
      $('#login-modal-form').on 'submit', (e) =>
        @loginValidation(e)

    processing: (form, label, disabled = false)->
      $submit = $(form).find('input:submit')
      $submit.prop('disabled', disabled)
      if disabled
        $submit.find('.messages').html('')
        $submit.val('PROCESSING...')
      else
        $submit.val label

    setErrorMsg: (item) ->
      itemId = item.attr('id')

      if item.hasClass 'error'
        if itemId is 'new_user_password_modal' or itemId is 'user_password_modal'
          item.parents('form').find('.messages').html('Password must be at least 6 characters long')
        else if itemId is 'new_user_email_modal' or itemId is 'user_email_modal'
          item.parents('form').find('.emessages').html('Please use a valid email')
      else
        if itemId is 'new_user_password_modal' or itemId is 'user_password_modal'
          item.parents('form').find('.messages').html('')
        else if itemId is 'new_user_email_modal' or itemId is 'user_email_modal'
          item.parents('form').find('.emessages').html('')

    loginValidation: (e) ->
      e.preventDefault()
      $form = $(e.currentTarget)
      label = $form.find('input:submit').val()
      $elements = $form.find('input.required')
      @processing $form, label, true
      error = 0
      $elements.each (i,el) =>
        if $(el).val() == ""
          $(el).removeClass('valid')
          $(el).addClass('error')
          @setErrorMsg $(el)
          error++
        else if $(el).attr('type') == "password" and $(el).val().length < 6
          $(el).removeClass('valid')
          $(el).addClass('error')
          @setErrorMsg $(el)
          error++
        else
          $(el).removeClass('error')
          $(el).addClass('valid')
          @setErrorMsg $(el)

        $(el).bind 'change', ->
          $(@).removeClass('error')
          $(@).removeClass('valid')
          $(@).unbind 'change'
      if error == 0
        $form.off('submit')
        $form.submit()
      else
        @processing $form, label, false

    validateStep: (step = 0, $el) ->
      if step == 1
        if $el.valid()
          $el.addClass 'valid'
          $el.removeClass 'error'
          $('#register_step_one').addClass 'hide'
          $('#register_step_two').removeClass 'hide'
          $('#back').parent().removeClass 'hide'
          $el.parents('form').find('.emessages').html('')
        else
          $el.addClass 'error'
          $el.removeClass 'valid'
          @setErrorMsg $el
      else if step == 2
        if $el.val() is '' || $el.val().length < 6
          $el.addClass 'error'
          $el.removeClass 'valid'
          @setErrorMsg $el
        else
          $el.addClass 'valid'
          $el.removeClass 'error'
          $form = $('#register-modal-form')
          @setErrorMsg $el
          @processing $form, $('#create_account_modal').val(), true
          $form.off 'submit'
          $form.submit()

    registerValidations: ->
      $form = $('#register-modal-form')
      # prevent submit register form
      $form.on 'submit', (e) ->
        e.preventDefault()

      $('#back').on 'click', (e) ->
        e.preventDefault()
        $('#register_step_one').removeClass 'hide'
        $('#register_step_two').addClass 'hide'
        $('#back').parent().addClass 'hide'
      $email = $form.find('#new_user_email_modal')
      $email.on 'keypress', (e) =>
        if e.key == "Enter"
          e.preventDefault()
          @validateStep 1, $email
      $form.find('#finish_step_one').on 'click',(e) =>
        e.preventDefault()
        @validateStep 1, $email
      $password = $form.find('#new_user_password_modal')
      $password.on 'keypress', (e) =>
        if e.key == "Enter"
          e.preventDefault()
          @validateStep 2, $password
      $form.find('#create_account_modal').on 'click',(e) =>
        e.preventDefault()
        @validateStep 2, $password
  $ ->
    Modals.init()
