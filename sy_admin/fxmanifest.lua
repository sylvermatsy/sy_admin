fx_version 'cerulean'
game 'gta5'

author 'Sylver Reworked de Xed#1188'

shared_scripts {
	"config.lua"
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
}

client_scripts{
    "config.lua",
    "libs/RMenu.lua",
    "libs/menu/RageUI.lua",
    "libs/menu/Menu.lua",
    "libs/menu/MenuController.lua",
    "libs/components/*.lua",
    "libs/menu/elements/*.lua",
    "libs/menu/items/*.lua",
    "libs/menu/panels/*.lua",
    "libs/menu/windows/*.lua",
    "client/coords.lua",
    "client/cl_function.lua",
    "client/cl_main.lua",
}

server_scripts{
    "config.lua",
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
}
