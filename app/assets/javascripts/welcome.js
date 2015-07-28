// Lame hack because this var is only defined when it's needed.
//  what we should do is stop including and evaluating this file on every frickin page load
if (typeof countdowntimer_soldout === 'undefined')
  var countdowntimer_soldout = false;

var monthNumber = 7;
var countdowntimer_thisMonthsTheme = "HEROES 2";
var countdowntimer_thisMonth = "JULY";
var countdowntimer_nextMonth = "AUGUST";
var countdowntimer_quip = "We’re celebrating the return of the good, the great & the gallant with awesome items from The Legend of Zelda, DC Entertainment and more, plus our first hardcover book!";

var countdownHeaderTextBefore = countdowntimer_soldout !== true ? "TIME IS RUNNING OUT!" : "WE'RE SOLD OUT!" ;
var countdownMainTextBefore = "THIS MONTH'S THEME IS <span class='themename'>" + countdowntimer_thisMonthsTheme + "!</span>";

var countdownSubTextBefore = countdowntimer_soldout !== true ?
	 countdowntimer_quip :
	"Missed out? <span style='color:#f06000;'>Join our waitlist</span> and be the first to hear about next month's crate!";

var countdownHeaderTextAfter = "AND THEY'RE OFF!";
var countdownMainTextAfter = countdowntimer_thisMonth + "'S CRATE IS CLOSED.<br /> SIGN UP NOW FOR " + countdowntimer_nextMonth + "!";
var countdownSubTextAfter = countdowntimer_thisMonth + " crates are on their way. Thank you Looters!";

// NOTE FOR DAYLIGHT SAVING TIME!  Remember to shift time zones in March and November to compensate for DST.
/*  Change the items below to create your countdown target date and announcement once the target date and time are reached.  */
var year=2015;        //—>Enter the count down target date YEAR
var month=monthNumber;//—>Enter the count down target date MONTH
var day=19;           //—>Enter the count down target date DAY
var hour=21;          //—>Enter the count down target date HOUR (24 hour clock)
var minute=0;         //—>Enter the count down target date MINUTE
var tz=-7;            //—>Offset for your timezone in hours from UTC (see http://wwp.greenwichmeantime.com/index.htm to find the timezone offset for your location)
