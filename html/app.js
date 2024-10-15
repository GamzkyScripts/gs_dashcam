$(document).ready(function () {
	window.addEventListener('message', function (event) {
		let item = event.data;
		
		if (item.action == 'showMenu') {
			$('#actionmenu').fadeIn(100);
		} else if (item.action == 'hideMenu') {
			$('#actionmenu').fadeOut(10);
		} else if (item.action == 'update') {
			const locale = item.locale; 
			let d = new Date();
			let date = d.toLocaleDateString('en-GB');
			let time = d.toLocaleTimeString('en-GB');
			$('#date').text(date);
			$('#time').text(time);
			$('#own-speed').text(locale['own-speed'] + ': ' + item.speed + 'km/h');
			$('#distance').text('d: ' + item.distance + 'm.');
			$('#currentTime').text('t: ' + item.time + 's.');
		} else if (item.action == 'sendSpeed') {
			$('#average-speed').text('s: ' + item.finalSpeed + 'km/h');
		} else if (item.action == 'initializeLanguage') {
			const locale = item.locale;
			$('#own-speed').text(locale['own-speed'] + ': 0km/h');
			$('#text-left-bottom').text(locale['text-left-bottom']);
			$('#text-right-bottom').text(locale['text-right-bottom']);
			$('#text-left-top').text(locale['text-left-top']);
			$('#text-right-top').text(locale['text-right-top']);
			$('#brand-name').text(locale['brand-name']);
		}
	});

	document.onkeyup = function (data) {
		if (data.key == 'Escape' || data.key == 'Backspace') {
			CloseNUI();
		}
	};
});

function CloseNUI() {
	$.post('http://as_dashcam/CloseNUI', JSON.stringify({}));
}