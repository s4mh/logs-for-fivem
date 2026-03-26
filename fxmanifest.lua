
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Shoen'

client_scripts {
	'all/cl/*.lua',
}

server_scripts {
	"shared/config.lua",
	'all/sv/*.lua',
	'ox/sv/*.lua'
}
escrow_ignore {
	"shared/config.lua"
}