# ###### #
# FOOTER
# ###### #
LootCrate = window.LootCrate = window.LootCrate || {}

LootCrate.Footer = ->

  Footer =
    init: ->
      @wf()
      @setupNewsletter()

    wf: ->

      WF = WF or {}
      WF.exp =
        loo_fe_4_1_global: ->
          flags = jQuery('ul.nav li img')
          flags.css 'width', '25px'
          flags.css 'height', '25px'
          flags.css 'border-radius', '25px'
          jQuery('.footer .footer-column:eq(1) li:eq(2) a').html 'FAQ and Help Center'
          jQuery('head').append '<style>.nav-collapse .nav > li > a { color: #fff !important; } .nav-collapse .nav > li > a:hover { color: #999 !important; }</style>'
        init: ->
          @loo_fe_4_1_global()
      WF.exp.init()

    signupNewsletter: ->
      emailAddress = encodeURIComponent $("#footer-mce-email").val()
      $.ajax(
        url: '/newsletter_signup/'
        type: 'POST'
        data: "email=#{emailAddress}"
        beforeSend: ->
          options = {
            "backdrop" : "static"
          }
          $("#newsletter-signup-result").modal(options)
          $("#newsletter-signup-result-message").empty()
          $("#newsletter-signup-result-message").before('<i class="fa fa-spinner fa-pulse"></i>')
        complete: ->
          $("#newsletter-signup-result-message").siblings('i').remove()
        success: (data) ->
          $("#newsletter-signup-result-message").append("<h4>Congrats!  You are now on the mailing list!</h4>")
          $("#footer-mce-email").val('')
        error: (data) ->
          $("#newsletter-signup-result-message").
            append("<h4>Oh Noes!! Couldn't sign up to mailing list: #{data.responseJSON['errormsg']}</h4>")
      )

    setupNewsletter: ->
      $("#mc-embedded-subscribe-form").submit (e) ->
        e.preventDefault()
        Footer.signupNewsletter()

  $ ->
    Footer.init()
