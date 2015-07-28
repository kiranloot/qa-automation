# ############## #
# FLASH MESSAGE
# ############## #

LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Flash = (msg, type) ->

  Flash =
    init: ->
      @setup()
      @bindings()

    setup: ->
      container = $('body').children('.alert-bg')
      if container.length is not 0
        $('.alert-bg').append(
          "<div class='alert alert-" + type + "'>" +
          "<a class='close' data-dismiss='alert'>&#215;</a>" +
          "<div id='flash_" + type + "'>" + msg + "</div>" +
          "</div>"
        )
      else
        $('body').append(
          "<div class='alert-bg'>" +
          "<div class='container'>" +
          "<div class='row'>" +
          "<div class='alert alert-" + type + "'>" +
          "<a class='close' data-dismiss='alert'>&#215;</a>" +
          "<div id='flash_" + type + "'>" + msg + "</div>" +
          "</div>" +
          "</div>" +
          "</div>" +
          "</div>"
        )
      @show()

    bindings: ->
      $('.close').click ->
        $(this).parents('.alert-bg').hide()

    closeAlerts: ->
      # Automatically close alerts
      window.setTimeout (->
        $('.alert.alert-success, .alert.alert-error').fadeOut 'fast', ->
          $(this).alert('close')
      ), 5000

    show: ->
      $('.alert-bg').show()
      @closeAlerts()

  $ ->
    Flash.init()
