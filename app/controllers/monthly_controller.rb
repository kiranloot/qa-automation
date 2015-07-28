class MonthlyController < ApplicationController
  skip_before_action :verify_authenticity_token

  def covert_questions

    case params[:ques]
    when 'alpha'
      if params[:data] == 'NIGHTWALKER'
        response = {answer: true}
      elsif params[:data] == 'BLUECHEESE'
        response = {answer: true}
      else
        response = {answer: false}
      end
    when 'q1'
      if params[:data] == 'CR2016'
        response = {answer: true}
      elsif params[:data] == 'BLUECHEESE'
        response = {answer: true}
      elsif params[:data] == 'CR 2016'
         response = {answer: true}
      else
        response = {answer: false}
      end
    when 'q2'
      if params[:data] == '04/01/1984' && params[:dataB] == '04/04/1984'
        response = {answer: true}
      elsif params[:data] == 'BLUECHEESE'
        response = {answer: true}
      elsif params[:data] == '04/04/1984' && params[:dataB] == '04/01/1984'
        response = {answer: true}
      else
        response = {answer: false}
      end
    when 'q3'
      if params[:data] == 'NEW YORK'
        response = {answer: true}
      elsif params[:data] == 'BLUECHEESE'
        response = {answer: true}
      else
        response = {answer: false}
      end
    when 'q4'
      if params[:data] == 'BILLY KOENIG'
        response = {answer: true}
      elsif params[:data] == 'BLUECHEESE'
        response = {answer: true}
      end
    when 'q6'
        response = {answer: '1g4Dy76Uo4RO8mT38wzhVJ8HiwzsO_rRP8ZeuSnGTPoA'}
    else
      response = { answer: false }
    end

    respond_to do |format|
      format.json { render json: response }
    end
  end

  def eightbit
    redirect_to 'https://www.surveymonkey.com/s/LPTTCQK'
  end

  def wildfire
    redirect_to 'http://www.facebook.com/LootCrate'
  end

  def holiday2012
    # redirect_to  'http://apps.facebook.com/contestshq/contests/308459'
    redirect_to 'http://www.lootcrate.com'
  end

  def resolution
    redirect_to 'https://www.facebook.com/LootCrate/app_95936962634'
  end

  def contest
    # redirect_to 'http://apps.facebook.com/contestshq/contests/315265' # 2013 February
    # redirect_to 'http://apps.facebook.com/contestshq/contests/319020' # 2013 March
    # redirect_to 'https://apps.facebook.com/contestshq/contests/322496' # 2013 April
    redirect_to 'http://apps.facebook.com/contestshq/contests/324554' # 2103 May
  end

  def battlecrateinstructions
    redirect_to 'http://www.lootcrate.com/'
  end

  def qr
    # redirect_to 'http://www.youtube.com/watch?v=ommlHUu_vrU'	# 2013 February		Harlem Shake video
    # redirect_to 'http://nyanit.com/lootcrate.com'	# 2013 March  Nyan cat version of lootcrate
    # redirect_to 'http://www.youtube.com/watch?v=0QscqTY6AUo' # 2013 May	May's Crate: EQUIP (crate assembly video)
    # redirect_to 'http://www.youtube.com/watch?v=4lUANDzlE4Q' # 2013 June	June's Crate: MASHUP (Geek and Gamer Style. Psy parody)
    # redirect_to 'https://docs.google.com/forms/d/1E-KVymNZGyXSKGWCsecKWEi5isrHKe3ozsdZe2TrwVc/viewform' # 2013 July  Comic-Con Gear contest
    # redirect_to '//youtu.be/BZUt1qulw6k' # 2013 August Portal 1-year Cake Anniversary
    # redirect_to '//youtu.be/Lk0eP-38Nyk' # 2013 September Animate Cover speed drawing
    # redirect_to 'http://www.lcdisastercontrol.org/' # 2013 October Loot Crate Disaster Control
    # redirect_to 'http://youtu.be/r8a7U0l67RI' # 2013 November, Celebrate party
    # redirect_to 'http://www.youtube.com/watch?v=DBA_FSSysXA' # 2013 December, Happy Holidays From Loot Crate!
    # redirect_to 'http://www.youtube.com/watch?v=NY26X9Ht8U8' # 2014 January, Space Crate that never returned.
    # redirect_to 'http://www.youtube.com/watch?v=nCdRLrfG50E' # 2014 February, Catbug casting/audition process.
    # redirect_to 'http://youtu.be/1JvtyYRe4hI' # 2014 March, Behind the scenes: Titan Chat.
    # redirect_to '//www.youtube.com/watch?v=FXjFUpaIfSs' # 2014 April, Game of Thrones Medley.
    # redirect_to '//www.youtube.com/watch?v=uwTQRMTJaSk' # 2014 June, Tranformers, TURN DOWN FOR WHAT!
    # redirect_to 'http://imgur.com/a/8b4Re' # 2014 July, Behind the scenes stills of Villains Theme Video production.
    # redirect_to '//youtu.be/TaOjuDl2_20' # 2014 August, Glactic Loot Crate Vinyl Theatre
    # redirect_to '//www.youtube.com/watch?v=F_WAqw6vrXY' # 2014 September, The Verse gag reel
    # redirect_to '//imgur.com/a/ajel5#0' # 2014 October, Fear: behind the scenes photos
    # redirect_to 'https://www.youtube.com/watch?v=prFGxMCn0fs' # 2014 November, Comikaze Crate Walk video
    # redirect_to 'https://www.youtube.com/watch?v=oIxmb0JWBDk' # 2015 January, Rewind: The Trouble with 10-doh.
    #redirect_to 'https://www.youtube.com/watch?v=2QaeKGGZX1c&feature=youtu.be' # 2015 February, Play: Goldberg outtakes
    #redirect_to 'https://www.youtube.com/watch?v=7wrFQw2c-a8' # 2015 March, Paracord Bracelet Primer
    #redirect_to 'http://play.textadventures.co.uk/Play.aspx?id=rwdhckmv9e25svhxxiohkq' # 2015 April, Loot Quest: A Fantasy Adventure
    #redirect_to 'https://www.youtube.com/user/LootCrate' # 2015 April, because the Loot Quest link doesn't work on mobile.
    redirect_to 'http://loot.cr/experience' # 2015 April, because we don't want to link to our youtube page.

    # this is how we do popups instead of redirects.  Requires a few lines in welcome.html.erb to start the js based on the cookie set here.
    # cookies[:toasty] = { :value => "1", :expires => 1.day.from_now, :path => "/" }
    # cookies[:itsasecrettoeverybody] = { :value => "1", :expires => 1.day.from_now, :path => "/" }
    # index
  end

  # Note that entering the konami code does not always send the user here.
  # Check lib/assets/javascripts/konami_code.js for the destination (usually goes here, or initiates a popup).
  def thirtylives
    # redirect_to 'http://www.youtube.com/watch?v=ommlHUu_vrU'	# 2013 February		Harlem Shake video
    # redirect_to 'http://nyanit.com/lootcrate.com'	#2013 March  Nyan cat version of lootcrate
    qr # 2013 May, June, July, August, September, October, November, December, 2014 January
  end

  def covertloot
    redirect_to 'https://www.youtube.com/watch?v=RQhyxr-52ms' # put up in March 2015
  end

  def survive
    redirect_to '//www.lootcrate.com/?utm_source=video&utm_medium=video&utm_campaign=survivevideo' # put up in October 2013
  end

  def munnycontest
    render layout: 'monthly/layout'
  end

  def cybercrate
    render layout: 'monthly/layout'
  end

  def covert_contest
    render layout: 'monthly/layout'
  end

  def covertops
    render layout: 'monthly/layout'
  end

  def cyber_exp
    render layout: 'monthly/layout'
  end

  def cyber_contest
    render layout: 'monthly/layout'
  end

  # 2015 - April Contest
  def buildanarmy
    render layout: 'monthly/layout'
  end

  # 2015 - 05 - May Contest
  def marvelus
    render layout: 'monthly/layout'
  end

  def experience

  end

  private

  def force_non_ssl
    redirect_to protocol: 'http://', status: 302 if request.ssl?
  end
end
