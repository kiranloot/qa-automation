//COUNTDOWN TIMER

/*
 Count down until any date script-
 By JavaScript Kit (www.javascriptkit.com)
 Over 200+ free scripts here!
 Modified by Robert M. Kuhnhenn, D.O.
 on 5/30/2006 to count down to a specific date AND time,
 and on 1/10/2010 to include time zone offset.
 */

//—>    DO NOT CHANGE THE CODE BELOW!    <—
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");

function countdown(yr,m,d,hr,min){
  if (null != document.getElementById('countdown-clock') || null != document.getElementById('countdowntimer-mini')) /* don't run when timer is not rendered */
  {
    theyear=yr;themonth=m;theday=d;thehour=hr;theminute=min;
    var today=new Date();
    var todayy=today.getYear();
    if (todayy < 1000) {
      todayy+=1900; }
    var todaym=today.getMonth();
    var todayd=today.getDate();
    var todayh=today.getHours();
    var todaymin=today.getMinutes();
    var todaysec=today.getSeconds();
    var todaystring1=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec;
    var todaystring=Date.parse(todaystring1)+(tz*1000*60*60);
    var futurestring1=(montharray[m-1]+" "+d+", "+yr+" "+hr+":"+min);
    var futurestring=Date.parse(futurestring1)-(today.getTimezoneOffset()*(1000*60));
    var dd=futurestring-todaystring;
    var dday=Math.floor(dd/(60*60*1000*24)*1);
    var dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1);
    var dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
    var dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);
    if ( null != document.getElementById('countdown-clock') )
    {
      if(dday>=0 || dhour>=0 || dmin>=0 || dsec>=0){
        document.getElementById('dday').innerHTML= countdowntimer_soldout !== true ? dday : "SOL";
        document.getElementById('dhour').innerHTML= countdowntimer_soldout !== true ? dhour : "D&nbspO";
        document.getElementById('dmin').innerHTML=countdowntimer_soldout !== true ? dmin : "UT!";
        //document.getElementById('dsec').innerHTML=dsec;
        document.getElementById('countdown-header-text').innerHTML = countdownHeaderTextBefore;
        document.getElementById('countdown-main-text').innerHTML = countdownMainTextBefore;
        document.getElementById('countdown-sub-text').innerHTML = countdownSubTextBefore;
        setTimeout("countdown(theyear,themonth,theday,thehour,theminute)",1000);
      }
      else {
        document.getElementById('dday').innerHTML="SHI";
        document.getElementById('dhour').innerHTML="PPI";
        document.getElementById('dmin').innerHTML="NG!";
        //document.getElementById('dsec').style.display="none";
        document.getElementById('countdown-header-text').innerHTML = countdownHeaderTextAfter;
        document.getElementById('countdown-main-text').innerHTML = countdownMainTextAfter;
        document.getElementById('countdown-sub-text').innerHTML = countdownSubTextAfter;
      }
    }
    if ( null != document.getElementById('countdowntimer-mini') )
    {
      if(dday>=0 || dhour>=0 || dmin>=0 || dsec>=0){
        document.getElementById('dday-mini').innerHTML=dday;
        document.getElementById('dhour-mini').innerHTML=dhour;
        document.getElementById('dmin-mini').innerHTML=dmin;
        setTimeout("countdown(theyear,themonth,theday,thehour,theminute)",1000);
      }
      else {
        document.getElementById('dday-mini').innerHTML="SHI";
        document.getElementById('dhour-mini').innerHTML="PPI";
        document.getElementById('dmin-mini').innerHTML="NG!";
      }
    }
  }
}

