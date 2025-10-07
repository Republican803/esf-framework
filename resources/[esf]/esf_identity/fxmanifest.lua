fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'ESF Framework Identity: Landing + Character system'
version '2.0.0'  -- Phase 2

dependencies {
    'esf_core',
    'ox_lib',
    'oxmysql'
}

server_scripts {
    'server/identity.lua',
    'server/characters.lua',
    'server/appearance.lua',
    'server/persistence.lua'
}

client_scripts {
    'client/landing.lua',
    'client/spawn_client.lua'
}

ui_page 'nui/landing.html'

files {
    'nui/landing.html',
    'nui/landing.js',
    'nui/styles.css',
    'config/character_limits.json',
    'config/default_appearance.json',
    'config/departments.json'
}

lua54 'yes'