LootCrate = window.LootCrate = window.LootCrate || {}
LootCrate.pages = LootCrate.pages || {}
LootCrate.pages['level_up-index'] = ->

  lvl = 

    init: ->
      @scrollToPlans()
      @initShirtSelect()
      @setupBetaMsg()
      @stickyNoticeSection()
      @formatPrice()
      @buildURL()
      @setupTshirtPopover()
      @initImageLoader()
      @fetchPlanData()
      @changeVariant()
      @validateVariantSelected()

    # scroll to plan boxes #
    scrollToPlans: ->
      formFactor = WURFL.form_factor
      $('.scroll-to-lvl-plan a').on 'click.levelup', (e) ->
        e.preventDefault()
        offset = if formFactor == 'Smartphone' then 170 else 205
        $('html,body').animate { scrollTop: $('#plan-boxes').offset().top - offset }, 'slow'

    initShirtSelect: ->
      #$('.variant-options').select2 minimumResultsForSearch: Infinity

      $('.variant-options').select2
        minimumResultsForSearch: Infinity
        $('.select2-arrow b').remove()
        $('.select2-arrow').append '<i class="icon-arrow-down aDownz"></i>'
        $('.variant-options').on 'change', (ev) ->
          if $(this).val() != '' or $(this).val() != 0
            $(this).siblings('.errorZone').html ''
            $(this).removeClass('error').addClass('valid')
            $(this).parent().find('.subContainer').find('.select2-chosen').addClass('valid').removeClass('error')
          else
            $(this).removeClass('valid').addClass('error')
            $(this).parent().find('.subContainer').find('.select2-chosen').removeClass('valid').addClass('error')
            error_messages.run $(this).siblings('.select-plan'), error_messages.subscription.empty

    setupBetaMsg: ->
      $('.showMsg').hover (->
        $('.lvlBetaMsg').show()
        return
      ), ->
        $('.lvlBetaMsg').hide()
        return

    # fix notice section
    stickyNoticeSection: ->
      @fixIt()
      $(window).scroll => @fixIt()

    wTop: -> $(window).scrollTop()

    fixIt: ->
      $mainContent = $('.main-content')
      formFactor = WURFL.form_factor
      if formFactor == 'Smartphone'
        if @wTop() > 504
          $mainContent.addClass 'fix-it'
        else
          $mainContent.removeClass 'fix-it'
      else
        if @wTop() > 652
          $mainContent.addClass 'fix-it'
        else
          $mainContent.removeClass 'fix-it'

    formatPrice: ->
      $('.cost').wrap ->
        parts = $(this).text().split(/([.|$])/)
        $(this).html '<span class=\'dollarsign\'>' + parts[1] + '</span>' + parts[2] + '<span class=\'cents\'>' + parts[4] + '</span>'
        return

    buildURL: ->
      $('#wearable-btn').click (e)->
        e.preventDefault()
        selected = $('#shirt').val();
        error_zone = $(this).parents('.container').find('.error-zone');
        if selected==''
          error_zone.html('Please select a shirt size')
        else
          error_zone.html('')

    setupTshirtPopover: ->
      options = 
        container: 'body'
        html: true
        content: ->
          return $('#tshirt-popover-content').html()
        placement: (context, source) ->
          position = $(source).position()
          if position.left > 208
            return 'top'
          'left'
        trigger: 'click hover',
        delay:
          show: 50,
          hide: 400

      $("#tshirt-popover").popover(options).click (e) ->
        e.preventDefault()

    initImageLoader: ->

      initAnimation = ->
        # Animate - Init
        $('.cr-animate-gen').each ->
          #$curr = $(this)
          #$curr.css 'opacity', '0'
          $(@).css 'opacity', '0'
          
          return
        # Animate - Bind
        $('.cr-animate-gen').each ->
          #$curr = $(this)
          #$curr.bind 'cr-animate', ->
            #$curr.css 'opacity', ''
            #$curr.addClass 'animated ' + $curr.data('gen')
            #animationDelay = $curr.data('gen-delay')
            #$curr.css('animation-delay', animationDelay)

          $(@).bind 'cr-animate', ->
            $(@).css 'opacity', ''
            $(@).addClass 'animated ' + $(@).data('gen')
            animationDelay = $(@).data('gen-delay')
            $(@).css('animation-delay', animationDelay)
            
            return
          return
        # Animate
        #$('.cr-animate-gen').each ->
          #$curr = $(this)
          #$curr.waypoint (->
            #$curr.trigger 'cr-animate'
            #return
          #),
            #triggerOnce: true
            #offset: '90%'

        $('.cr-animate-gen').each ->
          $(@).waypoint (->
            $(@).trigger 'cr-animate'
            return
          ),
            triggerOnce: true
            offset: '90%'
          return

      removeFacebookLogin = ->
        fbRemove = $('.social-signin-links').first().parent().remove()
        newOrRemove = $('.newOr').remove()
        return

      $window = $(window)
      $slide = $('.homeSlide')
      $body = $('body')
      $body.addClass('loading')
      $body.imagesLoaded ->
        setTimeout (->
          initAnimation()
          removeFacebookLogin()
          $body.removeClass('loading').addClass 'loaded'
          return
        ), 800
        return
      return

    changeVariant: ->
      $('.variant-options').change ->
        productBox  = $(@).parents('.product-box')
        planName    = productBox.find('.subSelect').select2('data').id
        variantId   = $(@).select2('data').id
        variantName = $(@).select2('data').text
        variantParams = "variant_id=#{variantId}&variant_name=#{variantName}"
        newUrl = "#{planName}/level_up/checkouts/new?#{variantParams}"
        productBox.find('.select-plan').attr('href', newUrl)

    fetchPlanData: ->
      $('.subSelect').change ->
        planName = $(@).val()

        $.ajax
          url: "/plans/#{planName}"
          type: "GET"
          success: (data) =>
            load_data($(@), data)
            changeUrl($(@), planName)

        changeUrl = (element, planName) ->
          variantId   = productBox(element).find('.variant-options').select2('data').id
          variantName = productBox(element).find('.variant-options').select2('data').text
          variantParams = "variant_id=#{variantId}&variant_name=#{variantName}"
          newUrl = "#{planName}/level_up/checkouts/new?#{variantParams}"
          productBox(element).find('.select-plan').attr('href', newUrl)

        load_data = (element, data) ->
          monthlyCost = data.monthly_cost
          totalCost   = data.cost
          element.parents('.product-box').find('.month-cost').html("<span class='cost'>$#{monthlyCost}</span>")
          element.parents('.product-box').find('.total-cost').html("Total Price: $#{totalCost}")
          priceContainer = element.parents('.product-box').find('.cost')
          priceText = priceContainer.html()
          parts = priceText.split(/([.|$])/)
          priceContainer.html('<span class="dollarsign">' + parts[1] + '</span>' + parts[2] + '<span class=\'cents\'>' + parts[4] + '</span>' + '<span class="per-month"> /mo S&amp;H included!</span>')

        productBox = (element) ->
          element.parents('.product-box')

    validateVariantSelected: ->
      $('.select-plan').click (e) ->
        e.preventDefault()
        variantId = $(@).parents('.product-box').find('.variant-options').select2('data').id

        if isNaN parseInt(variantId)
          error_zone = $(@).parents('.product-box').find('.error-zone')
          error_zone.html('Please select a shirt size')
        else
          window.location.href = $(@).attr('href')

  $ ->
    lvl.init()