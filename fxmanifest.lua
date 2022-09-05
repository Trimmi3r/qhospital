-- FX Information
fx_version "cerulean"
lua54 "yes"
game "gta5"

-- Resource Information
name "qhospital"
author "Qpr"
repository "https://github.com/arlofonseca/qhospital"
description ''

-- Manifest
shared_scripts {
	"@ox_lib/init.lua",
	"modules/init.lua",
}

client_scripts {
	"client/class/sync.lua",
	"modules/data.lua",
	"client/main.lua",
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"@ox_core/imports/server.lua",
	"server/class/player.lua",
	"server/main.lua",
}

files {
	"modules/config.json",
}

dependencies {
	"ox_core",
	"oxmysql",
	"ox_lib",
	"ox_inventory",
}