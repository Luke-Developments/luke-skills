fx_version 'cerulean'

game 'gta5'

lua54 'yes'

author 'Luke Developments'

description 'A customised skill system made by Luke Developments'

version '1.0'

shared_script {
    '@ox_lib/init.lua',
    'config.lua'  
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_script 'client/main.lua'

exports {
    "UpdateSkill",
    "AddSkill",
    "GetCurrentSkill"
}