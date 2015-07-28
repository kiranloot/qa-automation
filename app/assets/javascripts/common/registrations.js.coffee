# ############## #
# REGISTRATION VALIDATOR
# ############## #

# LootCrate Global closure
LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Registration = ->

  Registration =
    init: ->
      @setup()
    setup: ->
      @login()
      @register()
    login: ->
      # Login validations
      that = @
      $('#login-form input[type=submit]').on 'click', (e) ->
        e.preventDefault()
        if that.validation('#login-form', this) == 0
          $('#login-form').off('submit')
          $('#login-form').submit()
    register: ->
      # Register validations
      that = @
      $('#register-form button[type=submit]').on 'click', (e) ->
        e.preventDefault()

        if that.validation('#register-form', this) == 0
          $('#register-form').off('submit')
          $('#register-form').submit()
    processing: ($button) ->
      if $button.prop('disabled') == 'true'
        false
      else
        $button.prop('disabled', true)
        $button.prop("value", "PROCESSING...")
        true
    validation: (form, button) ->
      $form = $(form)
      $button = $(button)
      $button_name = $button.val()
      Registration.processing($button)
      $items = $form.find('input.required, select.required')
      error_count = 0

      removeClass = ($input, classStr) ->
        $input.removeClass classStr

      focusEvent = ($input) ->
        $input.bind 'focusin', ->
          removeClass $input, 'error'
          removeClass $input, 'valid'

      focusOutEvent = ($input) ->
        $input.bind 'focusout', ->
          validElements $items

      validElement = ($item) ->
        setError = (item, count) ->
          item.addClass 'error'
          item.removeClass 'valid'
          error_count++

        setErrorMsg = (item) ->
          itemId = item.attr('id')

          if item.hasClass 'error'
            if itemId is 'new_user_password' or itemId is 'user_password'
              item.parents('form').find('.messages').html('Password must be at least 6 characters long')
            else if itemId is 'new_user_email' or itemId is 'user_email'
              item.parents('form').find('.emessage').html('Please use a valid email')
          else
            if itemId is 'new_user_password' or itemId is 'user_password'
              item.parents('form').find('.messages').html('')
            else if itemId is 'new_user_email' or itemId is 'user_email'
              item.parents('form').find('.emessage').html('')

        if $item.val() == ''
          setError $item
          setErrorMsg $item
        else if $item.attr('type') == 'password' and $item.val().length < 6
          setError $item
          setErrorMsg $item
        else
          $item.addClass 'valid'
          removeClass $item, 'error'
          setErrorMsg $item

      activeButton = ->
        $button.val($button_name)
        $button.prop('disabled', false)

      validElements = (items) ->
        $items.each (i, item) ->
          focusEvent $(item)
          focusOutEvent $(item)
          validElement $(item)

      validElements $items

      activeButton()

      error_count
  # Start Registration
  $ ->
    Registration.init()
