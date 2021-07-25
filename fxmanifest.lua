fx_version 'cerulean'
game 'gta5'

description 'QB-CasinoRobbery'
version '0.0.0.0.0.0.0.0.1'

shared_scripts { 
	'@qb-core/import.lua',
    'config.lua'
}

client_scripts {
    'client/*'.
}

server_scripts {
    'server/*',
}