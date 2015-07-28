// Link with a Loot Crate logo (triforce) pops up on the screen
// based on toasty! https://github.com/glenwatson/Toasty

//this is used by /qr, this function has a copy in konami_code.js
function playTriforceCrate()
{
	//image and audio variables
	var triforcecrateimage = $('<img id="triforcecrateimage" style="display: none" src="/assets/triforcecrate_blackbg.png" />');
	var triforcecratesound = $('<audio id="itsasecret" preload="auto"><source src="/assets/triforcecrate_secret.wav" type="audio/wav" /><source src="/assets/triforcecrate_secret.mp3" type="audio/mpeg" /></audio>');

	//set the default style of the image to be out of sight
	$('body').append(triforcecrateimage);
	$('body').append(triforcecratesound);
	var tfimage = $('#triforcecrateimage').css({
		"position" : "fixed",
		"top" : "50%",
		"left" : "50%",
		"margin-top" : "-120px",
		"margin-left" : "-128px",
		"z-index" : "1050",
		"display" : "none"
	})

	//plays the <audio> sound
	document.getElementById('itsasecret').play();

	// pops up the image then hides it again
	tfimage.show(200,
		function() {
			setTimeout(
				function() {
					$('#triforcecrateimage').hide(200, 
					function()
					{
						//clean-up
						triforcecrateimage.remove();
						triforcecratesound.remove();
					})
				},
			2200);
		}
	);
}
