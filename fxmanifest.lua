fx_version 'adamant'
game 'gta5'

lua54 'yes'
shared_script {'@es_extended/imports.lua','@ox_lib/init.lua'}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	's_npcdrugsell.lua',

}

client_scripts {
	'c_npcdrugsell.lua',
}

