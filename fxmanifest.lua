fx_version 'adamant'
game 'gta5'
author 'Eviate'
description 'A police dashcam script'

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/style.css',
	'html/app.js',
}

shared_script '@es_extended/imports.lua'

client_scripts {
	'config.lua',
	'client/*.lua',
}
