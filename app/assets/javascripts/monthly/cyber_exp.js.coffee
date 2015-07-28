###
   cyber_exp contest scope
###

LootCrate = window.LootCrate = window.LootCrate or {}
LootCrate.monthly = LootCrate.monthly or {}

LootCrate.monthly['monthly-cyber_exp'] = ->

  loot = 
    isFire: ->
      return (navigator.userAgent.toLowerCase().indexOf('firefox') > -1)
    init: ->
      @loadSign()
      @bindings()
      @camSetup()
      @fb()
      @ff()
    tempText: ['Thank you for coming. Would you mind taking a seat over there? The interviewer will be with you shortly…',
     'Thank you for coming. Please have a seat. Relax, the interviewer will arrive shortly. In the mean time, have you ever given any thought to your retirement?',
      'It seems you’ve arrived a bit too soon. Very efficient of you. Say, have you ever thought about retiring?']
    bindings: ->
      $('.startScan').on 'click', ->
          #@goTempText()
          loot.goLight()
      $('.iBegin').on 'click', ->
        TweenMax.to($('.iBegin'), 1, {opacity:0, display:'none'})
        loot.askThem()
      $('.iShare .fbP').on 'click', ->
        resu = $('.iShare').data('result')
        loot.fbPost(resu)
      ###$('.iShare .twtP').on 'click', ->
        resu = $('.iShare').data('result')
        loot.twtPost(resu)###
    loadSign:->
      $.getScript( "https://s3-us-west-2.amazonaws.com/lootcrate-store/public/cyber/sine-waves.min.js", ( data, textStatus, jqxhr )->
        if textStatus = 'success'
          loot.setWaves()

      )
    setWaves: ->
      waves = new SineWaves(
        # Canvas Element
        el: document.getElementById('waves'),

        # General speed of entire wave system
        speed: 12,

        # How many degress should we rotate all of the waves
        rotate: 0,

        # Ease function from left to right
        ###ease: 'Linear',###
        ease: 'SineInOut',

        # Specific how much the width of the canvas the waves should be
        # This can either be a number or a percent
        waveWidth: '55%'

        # An array of wave options
        waves: [
          {
            timeModifier: 1,   # This is multiplied againse `speed`
            lineWidth: 1,      # Stroke width
            amplitude: 40,    # How tall is the wave
            wavelength: 30,   # How long is the wave
            segmentLength: 10, # How smooth should the line be
            strokeStyle: 'rgba(255, 255, 255, 0.5)', # Stroke color and opacity
            type: 'sine'       # Wave type
          },
          {
            timeModifier: 1.2,   # This is multiplied againse `speed`
            lineWidth: 1,      # Stroke width
            amplitude: 40,    # How tall is the wave
            wavelength: 30,   # How long is the wave
            segmentLength: 10, # How smooth should the line be
            strokeStyle: 'rgba(255, 255, 255, 0.5)', # Stroke color and opacity
            type: 'sine'  
          }
       ],

        # Perform any additional initializations here
        initialize:  () ->

        # This function is called whenver the window is resized
        resizeEvent: () -> 

          # Here is an example on how to create a gradient stroke
          gradient = this.ctx.createLinearGradient(0, 0, this.width, 0);
          gradient.addColorStop(0,"rgba(72, 72, 72, 0.5)");
          gradient.addColorStop(0.5,"rgba(255, 255, 255, 0.5)");
          gradient.addColorStop(1,"rgba(72, 72, 72, 0.5)");

          index = -1;
          length = this.waves.length;
          while ++index < length
              this.waves[index].strokeStyle = gradient;
      );
    ff:->
    fb: ->
      updateStatusCallback = (thang)->
      $.ajaxSetup({ cache: true });
      $.getScript('//connect.facebook.net/en_US/sdk.js', ->
        FB.init({
          appId: '881481778593157',
          version: 'v2.3' # or v2.0, v2.1, v2.0
        });     
        $('#loginbutton,#feedbutton').removeAttr('disabled')
        FB.getLoginStatus(updateStatusCallback)
      )
    camSetup: ->
      ##loot.resetReplicant
      #$(window).scrollTop(0)
      #window.scrollTo(0, 0);
      #window.scrollTo(0, 0);
      TweenMax.set($('#monthly-cyber_exp'), {overflowY:'hidden'})  
      setTimeout ( ->
        window.scrollTo(0, 0);

        ), 2000
      
      
      wHeight = $(window).height()
      wHem = wHeight/18
      TweenMax.set($('.repScan'), {marginTop:wHem+'em'})
      ###TweenMax.to($('.iCamGate1'), 3, {rotationZ: 26, transformOrigin: '20% 60%'})###
      ###TweenMax.set($('.iCamGate2'), {rotationZ: 16, transformOrigin: '80% 10%'})###
      TweenMax.set($('.iCamGate1'), {rotationZ: 26, transformOrigin: '30% 80%'})
      TweenMax.set($('.iCamGate2'), {rotationZ: 26, transformOrigin: '40% 30%'})
      TweenMax.set($('.iCamGate3'), {rotationZ: 26, transformOrigin: '80% 60%'})
    replicantScore: false
    currentAnswerValue: false
    getRandom:(max) ->
      return Math.floor((Math.random() * max) + 1);
    goTempText:->
      rMax = loot.tempText.length
      rand = loot.getRandom(rMax)-1;
      daText = loot.tempText[rand]
      @goText(daText)
    goText: (text) ->
      textFun = new TimelineMax();
      textFun.to($('.cyberTempText'), 5, {text:text, ease:Linear.easeNone})
    goLight: ->
      gLight = new TimelineMax()
      gLight.to($('.iCamLight'), 0.41, {opacity:1})
      gLight.to($('.iCamLight'), 0.41, {opacity:0})
      gLight.to($('.iCamLight'), 0.41, {opacity:1})
      gLight.to($('.iCamLight'), 0.41, {opacity:0})
      gLight.to($('.iCamLight'), 0.41, {opacity:1, onComplete:loot.goCamera})
    goCamera: ->
      TweenMax.to($('.iCamGate1'),1 , {rotationZ: 0 })
      TweenMax.to($('.iCamGate2'), 1 ,{rotationZ: 0 })
      TweenMax.to($('.iCamGate3'),1 , {rotationZ: 0, onComplete: loot.goFlow})
    goFlow:->
      TweenMax.set($('#monthly-cyber_exp'), {overflowY:'auto'})
      loot.goDevice()
    goBegin: ->
      showBegin = ->
        TweenMax.to($('.iBegin'), 1, {opacity:1})
      starT = 'Welcome to the Flynn-Adama test. Reaction time is a factor so please pay attention. This test has been specifically designed to provoke an emotional response. You must answer honestly. Shall we begin?'
      textFun = new TimelineMax();
      textFun.to($('.iQuestion'), 3, {text:starT, ease:Linear.easeNone, onComplete:showBegin})
    goDevice: ->
      wHeight = $(window).height()
      goQuest= ->
        loot.curQuestion = 'first'
        loot.goBegin()
      #$(window).scrollTo $('.' + 'repScan'), 3000, offset: top: 150
      blue = $('.repScan').offset().top
      $('html, body').animate({
          scrollTop: (blue+200)
      }, 3000)
      #TweenLite.to(window, 5, {scrollTo:{y:wHeight}, ease:Power2.easeOut});
      ###TweenLite.to(window, 2, {scrollTo:{y:800}, ease:Power2.easeOut});###
      TweenMax.to($('.iPump'), 3, {rotationZ: -10, transformOrigin: '90% 90%', yoyo:true, repeat:-1})
      TweenMax.to($('.iCamBar'), 5, {rotationZ: 36, transformOrigin: '20% 80%'})
      TweenMax.to($('.iCam'), 7, {rotationZ: 96, transformOrigin: '40% 90%', onComplete:goQuest}, 2)
      loot.goEye()
    goEye: ->
      diz = new TimelineMax()
      randTime = (loot.getRandom(4)*1000);
      eyePause = ->
        setTimeout ( ->
          loot.goEye()
        ), randTime
      diz.to($('.iEye'), 0.8, {right: '-0.35em'})
      diz.to($('.iEye'), 0.4, {right: '0.6em'})
      diz.to($('.iEye'), 0.52, {right: '-0.15em'})
      diz.to($('.iEye'), 0.74, {right: '0.2em', onComplete: eyePause})
    askThem: ->
      
      curQuestion = loot.curQuestion;
      #if curQuestion == 'first'
      loot.bindEnter()
      deQ = loot.themeQuestions[curQuestion].question
      anList = loot.themeQuestions[curQuestion].answer
      

      goAnswer = ->
        ###console.log curQuestion
        console.log loot.themeQuestions[curQuestion].score[1]###
        $('.iOList').html('')
        #$('.iQuestion').html('')
        $.each anList, (ind, val) => 
          #console.log(anList)
          $('.iOList').append('<li data-val="'+loot.themeQuestions[curQuestion].score[ind]+'">[<span class="xZone">X</span>] '+val+'</li>')
          if ind == (anList.length - 1)
            TweenMax.to($('.iOptions, .iEnter'), 1, {opacity:1})
            loot.bindAnswers()
            first = $('.iOList li')[0]
            $(first).addClass('active')
            loot.currentAnswerValue = -2
            
            
      textFun = new TimelineMax();
      textFun.to($('.iQuestion'), 0.3, {text:''})
      textFun.to($('.iQuestion'), 3, {text:deQ, ease:Linear.easeNone, onComplete:goAnswer})
      #console.log(@themeQuestions)
    themeQuestions:
      first:
        question: 'You wake up late and speed to school, running a red light. A police officer pulls you over and gives you a ticket. When you arrive at the empty classroom, you realize it’s Saturday. How do you react?'
        answer: ['I need to start checking my calendar when I wake up', 
        'I’m not worried because I wasn’t late.', 
        'I’m incredibly frustrated! Not only did I have to wake up early on a Saturday, I also got a ticket for no reason!',
        'Well getting the ticket sucks but at least I’m not in trouble for being late.']
        score:[-2, -1, 2, 1]
        response: 'null'
      second:
        question: 'Your birthday is coming up next week. While wandering around the house, you catch a glimpse of a neatly wrapped gift hidden in your parents’ room. What do you do? '
        answer: ['I don’t really care about my birthday.', 'It’s just a week, I can wait.',
         'Well there’s no way I can wait a whole week, but I can wait until my parents leave for the grocery store and then take a peek!',
         ' I pester my parents for hints about what it could be. ']
        score:[-2, -1, 2, 1]
        response: 'null'
      third:
        question: 'You’re sitting in a park. Suddenly, an apple falls out of the sky down onto you but there is no apple tree above you. You bite into it.'
        answer: ['Free nutrients are the best nutrients.', 'I don’t know that I would. It would depend what kind of apple it is.',
         'What?! No way! I wouldn’t bite into an apple that came out of nowhere! ',
         'Before I eat it, I try to find out where the apple came from.']
        score:[-2, -1, 2, 1]
        response: 'null'
      fourth:
        question: 'You have a child. One day he shows you his Loot Crate button collection, but he is missing several important buttons and seems unconcerned about their whereabouts. What do you do?'
        answer: ['Ground the child until those buttons are found.', 'Take the child to the doctor. ',
         '“That’s nice, but why don’t you go look for those buttons?”',
         'Take the buttons for “safe keeping." ']
        score:[-2, -1, 2, 1]
        response: 'null'
      fifth:
        question: 'You’re walking through a desert. You look at the ground and see a Loot Crate. You reach down and flip it over onto its back. The Loot Crate can’t flip itself over, but you’re not helping. Why is that?'
        answer: ['What do you mean I\'m not helping?', 'Why would I flip the Loot Crate? ',
         'I’ll help by picking up the Loot Crate and giving it a nice home. Mine. ',
         'Open it to see if there’s anything I want inside. ']
        score:[-2, -1, 2, 1]
        response: 'null'
      sixth:
        question: 'You have been waiting all week to watch one of your favorite things on television. Your significant other arrives and will not stop talking over the television, even though they know this is supposed to be your time to relax. Do you:'
        answer: ['Hit “pause” long enough to calmly remind my significant other this is my time, and make an appointment date for a future chat.',
         'Hit “pause” and talk to my significant other. I can relax later. ',
         'Turn the volume up and up and up until my significant other gets the hint and stops talking. Switch to headphones if they still won’t stop talking.',
         'Hit “pause” and reluctantly talk to my significant other, anger welling up until I snap at them out of nowhere and they leave the room in a huff.']
        score:[-2, -1, 2, 1]
        response: 'null'
      seventh:
        question: 'You’re at a friend’s house and are trading off turns in a single-player video game. Your friend keeps making choices in the game that you see as obviously incorrect and it is taking them a long time to beat the level. You begin to get frustrated. What do you do?'
        answer: ['You point out your friend’s mistakes and instruct them how to beat the level',
         'You calmly wait your turn ',
         'You get frustrated leading to an argument with your friend',
         'You excuse yourself to get yourself a glass of water and calm down ']
        score:[-2, -1, 2, 1]
        response: 'null'
      eigth:
        question: 'You are bored at work one day and decide to take a personality test online.  As you are taking it, you see that none of the answers are right for you, and once you finish the results don’t seem like you at all.  Do you…'
        answer: ['Get upset and wonder when computers will finally start to understand people like yourself.',
         'Post your results to your timeline saying how wrong this test is.',
         'Close the tab and keep browsing your favorite social network until you find something that keeps your attention.',
         'Think “it’s just a silly test, no big deal.”']
        score:[-2, -1, 2, 1]
        response: 'null'
      ninth:
        question: 'The power mysteriously goes out and there\'s no light. What do you do?'
        answer: ['Find the circuit breaker and fix the power. ',
         ' Pull out your flashlight and wait for it to come back on.',
         'Cry…?',
         'Hide somewhere safe, the dark is scary.']
        score:[-2, -1, 2, 1]
        response: 'null'
    bindEnter:->
      $('.iEnter').off('click')
      $('.iEnter').on 'click', (ev) ->
        ev.stopPropagation()
        
        TweenMax.to($('.iOptions'), 1, {opacity:0})
        TweenMax.to($('.iEnter'), 1, {opacity:0})

        #alert 'click'
        loot.replicantScore = loot.replicantScore + loot.currentAnswerValue;
        que = loot.curQuestion
        curQ = loot.themeQuestions[que];
        #if(curQ.response == "null")
        curQ.response = loot.currentAnswerValue;
        #checks = ->
        if que == 'first'
          $('.iQuestion').attr('data-question','second') 
          loot.curQuestion = 'second'
          loot.askThem()
        else if que == 'second'
          if curQ.response != "null"
            $('.iQuestion').attr('data-question','third') 
            loot.curQuestion = 'third'
            loot.askThem()
        else if que == 'third'
          if curQ.response != "null"
            $('.iQuestion').attr('data-question','fourth') 
            loot.curQuestion = 'fourth'
            loot.askThem()
        else if que == 'fourth'
          if curQ.response != "null"
            $('.iQuestion').attr('data-question','fifth') 
            loot.curQuestion = 'fifth'
            loot.askThem()
        else if que == 'fifth'
          if curQ.response != "null"
            $('.iQuestion').attr('data-question','sixth')
            loot.curQuestion = 'sixth' 
            loot.askThem()
        else if que == 'sixth'
          if curQ.response != "null"
            $('.iQuestion').attr('data-question','seventh') 
            loot.curQuestion = 'seventh'
            loot.askThem()
        else if que == 'seventh'
          if curQ.response != "null"
            $('.iQuestion').attr('data-question','eigth') 
            loot.curQuestion = 'eigth'
            loot.askThem()
        else if que == 'eigth'
          if curQ.response != "null"
            $('.iQuestion').attr('data-question','ninth') 
            loot.curQuestion = 'ninth'
            loot.askThem()
        else if que == 'ninth'
          loot.goResults()
        #loot.curQuestion = $('.iQuestion').attr('data-question')
        #checks()
    bindAnswers: ->
      #$('.iOList li').off();
      $('.iOList li').on 'click', (ev)->
        ev.stopPropagation()
        $('.iOList li.active').removeClass('active')
        $(this).addClass('active')
        loot.currentAnswerValue = parseInt($(this).attr('data-val'))
    goResults: ->
      repScore = 0
      textFun = new TimelineMax();
      textFun.to($('.iQuestion'), 0.3, {text:''})
      $.each loot.themeQuestions, (ind, val) => 
        repScore = repScore + val.response
        if ind == 'ninth'
          gLight = new TimelineMax()
          gLight.to($('.printLights'), 0.41, {opacity:1})
          gLight.to($('.printLights'), 0.41, {opacity:0})
          gLight.to($('.printLights'), 0.41, {opacity:1})
          gLight.to($('.printLights'), 0.41, {opacity:0})
          gLight.to($('.printLights'), 0.41, {opacity:1, onComplete: loot.printResult(repScore)})
         
    printResult: (repScore)->
      textFun = new TimelineMax();
      
      printPaper =(rez) ->
        $('.iShare').attr('data-result', rez)
        showShare = ->
          TweenMax.to($('.iShare'), 1, {opacity:1, display:'block'})
        TweenMax.to($('.pSheet'), 3, {top:0, onComplete:showShare})
      if repScore <= -1
        $('.pPrintResult').html('REPLICANT')
        textFun.to($('.iQuestion'), 3, {text:'You are a Replicant, the pinnacle of robot evolution. You have likely seen things a normal person could never even imagine. But all those things will be lost. Like Loot in… an improbable downpour of more Loot. Please stand by, someone will be along to “retire” you shortly.'})
        printPaper('replicant')
      if repScore >= 1
        $('.pPrintResult').html('HUMAN')
        textFun.to($('.iQuestion'), 3, {text:'You’re Human. Of course you are. What did you expect? These tests are just a formality, really. You’re free to go. '})
        printPaper('human')
      if repScore == 0
        $('.pPrintResult').html('REPLICANT')
        textFun.to($('.iQuestion'), 3, {text:'Please remain calm. I hate to tell you this, but you are a Replicant who thinks they’re human. This is rare. Perhaps you are a new prototype. You could have the shortened lifespan of a normal Replicant or you could live much longer. Only time will tell.'})
        printPaper('replicant')
    twtPost: (dna) ->
      if dna == "human"
        message = 'Surprise! You are Human! - IRIS Test by lootcrate'
        window.open('https://twitter.com/intent/tweet?text=' + encodeURIComponent(message), 'Tweet');
      else
        message = 'You Are A Replicant! - IRIS Test by lootcrate'
        window.open('https://twitter.com/intent/tweet?text=' + encodeURIComponent(message), 'Tweet');
    fbPost: (dna)->
      if dna == "human" 
        FB.ui({
          method: 'feed',
          picture: 'https://s3-us-west-2.amazonaws.com/lootcrate-store/public/cyber/iris_share_image_b.jpg',
          href: 'https://www.lootcrate.com/exp/cyber',
          caption:'IRIS Test - Powered by Loot Crate ',
          name:'Surprise! You are Human!',
          link:'https://www.lootcrate.com/exp/cyber'
        }, (response) ->
            {});
      else
        FB.ui({
          method: 'feed',
          picture: 'https://s3-us-west-2.amazonaws.com/lootcrate-store/public/cyber/iris_share_image_b.jpg',
          href: 'https://www.lootcrate.com/exp/cyber',
          caption:'IRIS Test - Powered by Loot Crate',
          name:'You Are A Replicant!',
          link:'https://www.lootcrate.com/exp/cyber'
        }, (response) -> {});
          
          
  $ ->
    loot.init()