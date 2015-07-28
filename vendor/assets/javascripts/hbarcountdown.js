/*
* Basic Count Down to Date and Time
* Author: @mrwigster / trulycode.com
*/
(function (e) {
	e.fn.countdown = function (t, n) {

		function i() {
			eventDate = Date.parse(r.date) / 1e3;
			currentDate = Math.floor(e.now() / 1e3);
			if (eventDate <= currentDate) {
                if (e.isFunction(n))  // This script is copied from somewhere - not sure what n is supposed to be or do.
    				n.call(this);
                if (typeof interval != "undefined")
    				clearInterval(interval); // I think this statement might only work if the page is loaded before the timer expires.
			}
			seconds = eventDate - currentDate;
			days = Math.floor(seconds / 86400);
			seconds -= days * 60 * 60 * 24;
			hours = Math.floor(seconds / 3600);
			seconds -= hours * 60 * 60;
			minutes = Math.floor(seconds / 60);
			seconds -= minutes * 60;
			
			daysText = days == 1 ? "day" : "days";
			//days == 1 ? thisEl.find(".timeRefDays").text("day") : thisEl.find(".timeRefDays").text("days");
			//hours == 1 ? thisEl.find(".timeRefHours").text("hour") : thisEl.find(".timeRefHours").text("hours");
			//minutes == 1 ? thisEl.find(".timeRefMinutes").text("minute") : thisEl.find(".timeRefMinutes").text("minutes");
			//seconds == 1 ? thisEl.find(".timeRefSeconds").text("second") : thisEl.find(".timeRefSeconds").text("seconds");
			if (r["format"] == "on") {
				days = String(days).length >= 2 ? days : "0" + days;
				hours = String(hours).length >= 2 ? hours : "0" + hours;
				minutes = String(minutes).length >= 2 ? minutes : "0" + minutes;
				seconds = String(seconds).length >= 2 ? seconds : "0" + seconds;
			}
			if (!isNaN(eventDate)) {
				if (0 == days)
					thisEl.html('<span class="orderby">today</span>');
				else if (0 < days)
					thisEl.html('in <span class="days orderby">' + days + '</span> <span class="timeRefDays">' + daysText + '</span>');
				//thisEl.find(".days").text(days);
				//thisEl.find(".hours").text(hours);
				//thisEl.find(".minutes").text(minutes);
				//thisEl.find(".seconds").text(seconds);
			} else {
				//alert("Invalid date: " + r.date + "\nExample date: 30 Tuesday 2013 15:50:00");
				clearInterval(interval);
			}
		}

		thisEl = e(this);
		var r = {
			date: null,
			format: null
		};
		t && e.extend(r, t);
		i();
		interval = setInterval(i, 1e3);
	};
})(jQuery);

$(document).ready(function () {
	function e() {
		var e = new Date;
		e.setDate(e.getDate() + 60);
		dd = e.getDate();
		mm = e.getMonth() + 1;
		y = e.getFullYear();
		futureFormattedDate = mm + "/" + dd + "/" + y;
		return futureFormattedDate;
	}
	$("#countdown").countdown({
		date: "20 July 2015 04:00:00 GMT", // 05:00 GMT is 9pm Pacific, should be 04:00 for DST
		format: "on"
	});
});
