fx_version 'bodacious'
game 'gta5'

files{
	"frames.txt",
} 

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/server.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/client.lua'
}
