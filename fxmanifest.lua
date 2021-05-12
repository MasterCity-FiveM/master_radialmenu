fx_version "adamant"

game "gta5"

client_script {
	"config.lua",
	"events.lua",
    "client_menu.lua"
}

server_script{
	"server.lua"
}

ui_page "html/ui.html"

files {
	"html/ui.html",
	'html/css/*.css',
	'html/js/*.js',
	'html/webfonts/*',
}