fx_version 'cerulean'
game 'gta5' 

author 'Wiibleyde & Noxelya'
description 'Script to add a treasure hunt quest to your server.'
version '0.1.0'

lua54 'yes'

client_scripts {
	'config.lua',
	'client/client_ped.lua',
	'client/client_preload.lua',
	'client/client_main.lua',
	'client/client_interaction.lua'
}

ui_page 'nui/index.html'

files {
	'nui/index.html',
	'nui/css/*.css',
	'nui/js/*.js',
	'nui/img/*.png',
	'nui/img/*.jpg',
}
