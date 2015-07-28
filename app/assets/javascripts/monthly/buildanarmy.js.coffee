###
   Build anarmy contest scope
###

LootCrate = window.LootCrate = window.LootCrate or {}
LootCrate.monthly = LootCrate.monthly or {}

LootCrate.monthly['monthly-buildanarmy'] = ->

  moo = (txt) ->
    #console.log(txt)

  loot =
    vars:
      judgeText: ''
      judgeImages: 'risa': window.tempJudgeImagePath

    isFire: ->
      navigator.userAgent.toLowerCase().indexOf('firefox') > -1

    init: ->
      @bindings()
      @waypoints()
      @banBindings()

    bindings: ->
      @navBindings()
      $('.banBtnEnter').on 'click', ->
        $(window).scrollTo $('.' + 'pane5'), 1000, offset: top: -50
      $('.banBtnPrizes').on 'click', ->
        $(window).scrollTo $('.' + 'pane3'), 1000, offset: top: -50
      $('.lBg, .jSplat').on 'click', (ev) ->
        $('.lBg, .jBox, .tc').css 'display': 'none'
      $('.theTC').on 'click', (ev) ->
        $('.lBg, .tc').css 'display': 'block'
      $('.jLogo').on 'click', (ev) ->
        ev.stopPropagation()
        jayz = $(this).data('judge')
        loot.vars.lImage = $(this).find('img').attr('src')
        loot.vars.lTitle = $(this).next('.jName').html()
        loot.judgePop jayz

      $('.lootLogo').on 'click', (ev) ->
        window.location.href = '//lootcrate.com'

      $('.gCat').on 'click', (ev) ->
        loot.vars.expanded = true
        if $(window).width() <= 768
          #$('.pane5').css({height:' auto'});
          $('.pane5').css 'height': 'auto'
        else
          $('.pane5').css height: '1600px'
        if $(window).width() <= 480
          #$('.pane5').css({height:' auto'});
          $('.pane5').css 'height': 'auto'
        targ = $(this).data('target')
        $('.gleamGal').css 'display': 'none'
        $('.gCat').removeClass 'active'
        $(this).addClass 'active'
        $(window).scrollTo $('.gleamCats'), 1000, offset: top: +50
        loot.markerText targ

    navBindings: ->
      $('.munNav li').on 'click', (ev) ->
        ev.stopPropagation()
        #moo($(this).data('target'))
        if $(window).width() <= 768
          $('.navbar .navbar-toggle').click()
        targ = $(this).data('target')
        if targ
          $(window).scrollTo $('.' + targ), 1000, offset: top: -50

    banBindings: ->
      $('.banFlag').mouseenter((ev) ->
        ev.stopPropagation()
        curFlag = $(this)
        flagHit = new TimelineMax
        flagHit.to curFlag, 2,
          marginBottom: '2em'
          ease: Power0.easeInOut
      ).mouseleave (ev) ->
        curFlag = $(this)
        flagHit = new TimelineMax
        flagHit.to curFlag, 2,
          marginBottom: '0'
          ease: Power0.easeInOut
      @banAnim()
      @banAnimB()

    banAnim: ->
      banSpark = new TimelineMax
      banSpark.to $('.mainSpark'), 5, opacity: 1
      banSpark.from $('.mainSpark'), 5, {
        rotation: '-=8'
        transformOrigin: 'center bottom'
        scale: 0.5
        bottom: '-4em'
        ease: Power0.easeInOut
      }, '-=5'
      banSpark.to $('.mainSpark'), 2, {
        opacity: 0
        onComplete: loot.banAnim
      }, '-=2'

    banAnimB: ->
      banSpark = new TimelineMax
      banSpark.to $('.mainSparkB'), 5,
        opacity: 1
        delay: 1
      banSpark.from $('.mainSparkB'), 5, {
        rotation: '-=6'
        transformOrigin: 'center bottom'
        scale: 0.3
        bottom: '-4em'
        ease: Power0.easeInOut
      }, '-=4'
      banSpark.to $('.mainSparkB'), 2, {
        opacity: 0
        onComplete: loot.banAnimB
      }, '-=2'

    covertAnim: ->
      TweenMax.to $('.coCross img'), 2, {
        rotation: '+=90'
        transformOrigin: 'center 50%'
        ease: Power0.easeNone
        repeat: -1
      }, '-=0.2'
      TweenMax.to $('.coCross.sm img'), 2,
        rotation: '-=90'
        transformOrigin: 'center 50%'
        ease: Power0.easeNone
        repeat: -1
      TweenMax.to $('.lazer_01'), 3, {
        rotation: '-18'
        transformOrigin: 'left 50%'
        ease: Power0.easeInOut
        repeat: -1
        yoyo: true
      }, '+=0.4'
      TweenMax.to $('.lazer_02'), 4, {
        rotation: '18'
        transformOrigin: 'right 50%'
        ease: Power0.easeInOut
        repeat: -1
        yoyo: true
      }, '+=0.84'
      TweenMax.to $('.lazer_03'), 6, {
        rotation: '-10'
        transformOrigin: 'left 50%'
        ease: Power0.easeInOut
        repeat: -1
        yoyo: true
      }, '+=0.4'
      TweenMax.to $('.lazer_04'), 6, {
        rotation: '10'
        transformOrigin: 'right 50%'
        ease: Power0.easeInOut
        repeat: -1
        yoyo: true
      }, '+=0.84'

    markerText: (target) ->
      moo $('[data-gallery-embed=' + target + ']').data('gallery')
      name = $('[data-gallery-embed=' + target + ']').data('gallery')
      targ =
        'Most Votes': 'The Munny design that receives the most votes on the contest page.'
        'Judges’ Pick': 'Judges from the other categories will vote on their favorite overall Munny design.'
        'Best Basic': '<div class=\'mTuck\'>The best Munny design created with pen, paint or markers only.<br> No modifications or additions.</div>'
        'Best Kid Design': 'The best design submitted by anyone who is 13 years old or younger.'
        'Best Hero/Villain': 'The best design based on an existing superhero or villain.'
        'Best Lookalike': '<div class=\'mTuck\'>The best design based on a real person. Please submit side-by-side pics <br> of the Munny and the person it’s supposed to look like.</div>'
        'Most Fashionable': '<div class=\'mTuck\'>The best design that includes clothes and accessories <br> (hats, shoes, jewelry, etc.) placed on the Munny.</div>'
        'Best Video Game': '<div class=\'mTuck\'>The best design based on a video game, a video game <br>character or a game system.</div>'
        'Best Modified': '<div class=\'mTuck\'>The best design that includes additions, subtractions or other modifications <br>to the physical shape and/or look of the Munny.</div> '
        'Most Resourceful': 'The best design created using only stuff from inside any Loot Crate&trade;.'
      # $('.mText').html(targ[name])
      big = targ[name]
      g = new TimelineMax
      g.to $('.mText'), 1,
        opacity: 0
        text: ''

      ### g.from($('.mText'), 1,{opacity:0})###

      g.to $('.mText'), 0.2,
        text: big
        opacity: 1
        ease: Linear.easeOut
      $('[data-gallery-embed=' + target + ']').css
        'display': 'block'
        'opacity': 1

    judgePop: (judge) ->
      loot.vars.judge = judge
      risa = 'A former Renaissance Faire Pirate Battle re-enactor and member of the geek-comedy troupe The Damsels of Dorkington,                    Dani now lives in Los Angeles where she has interned for Stan Lee and assisted the CEO of Stan Lee’s Comikaze Expo.                    She works at Loot Crate&trade; as Community Coordinator, and spends her free time watching every British show on Netflix.                    She considers both being retweeted by Cinnabon, and getting six friend requests on Venmo as the ultimate landmarks                    of her professional social media skills. <br><br>                   Originally from snowy, deep dish pizza-filled Chicago, Marissa does all things marketing and PR for Loot Crate&trade; in sunny                    Los Angeles. Before that, she was the online voice for musicians and YouTubers. A huge gamer, reader of books, and                    lover of all things science (she once studied biochemistry), her positive energy is 100% fueled by cookies and glitter.'
      iam8bit = 'Founded in 2005, iam8bit is a creative production company that approaches things with a unique moxie.                    We are consummate collaborators, having worked with countless companies to breathe new perspective and flavor into                     their brands, from HBO and Nintendo to Interscope and Disney. It’s our utmost prerogative to pursue everything with                     an authentic gusto, dedicating ourselves exclusively to projects that we have a personal passion for. It’s from this                     genuine, emotional investment that we derive our success. The company is co-owned by Jon M. Gibson and Amanda White,                     and is headquartered in Los Angeles, CA. iam8bit.com'
      Zack = 'Zack Finfrock and Peter Weidman are the main forces behind Loot Crate\'s&trade; Monthly theme videos, as well as ' + ' the production team behind Looter News. When they\'re not creating content for LC, they\'re working on their own                     original work, as well as saving the world every other week against the forces of evil. No gross giant spiders                     though. They\'re heroes, not miracle workers.'
      IGN = 'We\'re IGN Entertainment, a leading online media & services company obsessed with gaming, entertainment and                    everything guys enjoy.  Our premium gaming & entertainment content attracts the largest concentration of 18-34                    year old men online, which means that 1 in 4 US men online visit IGN each month. Worldwide, our reach is over 40                    million unique visitors, including our sites in the U.K., Australia and Germany. Advertisers and agencies may find                    a lot more to like over at our media site.'
      Eve = 'Eve Beauregard is best described as a Professional Nerd. Known for her love of                    cosplay, video games, comics and all things nerdery, Eve is Australian born but spends her time travelling between                     gaming and pop culture events the world over. She can most likley be found arguing with her Dungeon Master over                     the hydraulics of the Batmobile. '
      tab = 'Tabitha Lyons is an accomplished cosplayer and prop maker hailing from the UK. The face of family-run                     business Artyfakes, Tabitha has worked in the prop industry for over 15 years is known for her elaborate suits of                     armour, and impressive cosplay and LARP weaponry!'
      Meltdown = 'Meltdown Comics, located in the heart of Hollywood, Calif. on Sunset Blvd, opened in 1993 and has                    since become one the most respected comic book stores in the world. Taking a sophisticated approach to                    merchandise and operations, the 10,000sq/ft giant has garnered a reputation for hosting successful gallery openings,                     award winning comedy including the @meltdown_show on @ComedyCentral and live shows as well as podcasting events                     in their collaborative space with @NerdistDotCom, the @NerdMelt Showroom.                    Meltdown Comics recently made news by being the first brick and mortar comic book store to start accepting both                    BITCOIN and DOGECOIN in Los Angeles and in 2015 will be the brick and mortar location for Cards Against Humanity.'
      Nerdist = ' Chris Hardwick is a stand-up comedian, chart-topping podcaster, television personality, contributor                     for Wired magazine, and creative head of the multi-platform media behemoth known as Nerdist Industries.                    Chris is the CEO of Nerdist Industries, which has grown to include the Nerdist.com website; a premium YouTube                     channel with over 850K subscribers; 2.1M Twitter fans; and a podcast network including the flagship Nerdist Podcast                    that averages 4.8M monthly downloads. '
      Kidrobot = 'Founded in 2002, Kidrobot is acknowledged worldwide as the premier creator and dealer of limited                    edition art toys, signature apparel and lifestyle accessories. An innovative cross between sculpture and                    conceptual art, Kidrobot offers not only a powerful medium for today\'s international fashion designers,                    illustrators and graffiti artists, but also the creative canvas for emerging street trends and pop art.                    Frank Kozik, artist extraordinaire, industry icon and Kidrobot’s Creative Director will be judging.'
      Dani = 'A former Renaissance Faire Pirate Battle re-enactor and member of the geek-comedy troupe The Damsels                     of Dorkington, Dani now lives in Los Angeles where she has interned for Stan Lee and assisted the CEO of Stan                     Lee’s Comikaze Expo. She works at Loot Crate&trade; as Community Coordinator, and spends her free time watching every                      British show on Netflix. She considers both being retweeted by Cinnabon, and getting six friend requests on                       Venmo as the ultimate landmarks of her professional social media skills. '
      marissa = 'Originally from snowy, deep dish pizza-filled Chicago, Marissa does all things marketing and                    PR for Loot Crate&trade; in sunny Los Angeles. Before that, she was the online voice for musicians and YouTubers.                    A huge gamer, reader of books, and lover of all things science (she once studied biochemistry), her positive ' + 'energy is 100% fueled by cookies and glitter.'
      switch judge
        when 'Kidrobot'
          loot.vars.judgeText = Kidrobot
          loot.goJbox()
        when 'iam8bit'
          loot.vars.judgeText = iam8bit
          loot.goJbox()
        when 'Eve'
          loot.vars.judgeText = Eve + '<br><br>' + tab
          loot.goJbox()
        when 'IGN'
          loot.vars.judgeText = IGN
          loot.goJbox()
        when 'Meltdown'
          loot.vars.judgeText = Meltdown
          loot.goJbox()
        when 'Zack'
          loot.vars.judgeText = Zack
          loot.goJbox()
        when 'Nerdist'
          loot.vars.judgeText = Nerdist
          loot.goJbox()
        when 'marissa'
          loot.vars.judgeText = risa
          loot.goJbox()

    goJbox: (ev) ->
      $('.jBox .jImage').html '<img src="' + loot.vars.lImage + '" />'
      $('.jBox .jTitle').html '<div class="lT">' + loot.vars.lTitle + '</div>'
      $('.jBox .jBio').html '<div class="lC">' + loot.vars.judgeText + '</div>'
      $('.lBg, .jBox').css 'display': 'block'
      moo loot.vars.judgeText

    waypoints: (ev) ->
      $('.banZone').waypoint ((direction) ->
        if direction == 'down'
          $('.navbar').css background: 'rgba(0,0,0,0.8)'
        else if direction == 'up'
          $('.navbar').css background: 'rgba(0,0,0,0)'
      ), offset: 150

    resize: (ev) ->
      mvp = '<%= image_path(\'most-votes.png\') %>'
      jp = '<%= image_path(\'judges-pick.png\') %>'
      if loot.vars.expanded
        if $(window).width() <= 761
          $('.pane5').css height: 'auto'
        else
          $('.pane5').css height: '1600px'
        if $(window).width() <= 480
          $('.pane5').css height: 'auto'
      if $(window).width() <= 761
        moo 'mobile'
        $('.mostVotes').attr 'src', jp
        $('.judgePick').attr 'src', mvp
      else
        $('.mostVotes').attr 'src', mvp
        $('.judgePick').attr 'src', jp
      if loot.isFire()
        if $(window).width() >= 761
          $('.mainNav .lootCrate').css padding: '0'
        else
          $('.mainNav .lootCrate').css padding: '1em'
        if $(window).width() <= 961 and $(window).width() >= 680
          $('.munnyContainer .pane6 .p6Big, .munnyContainer .pane6 .p6BigFg').css top: '-28em'

  $ ->
    loot.init()
    $(window).resize(->
      loot.resize()
      return
    ).resize()
    return
