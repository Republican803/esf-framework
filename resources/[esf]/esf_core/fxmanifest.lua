fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'ESF Framework Core: Shared plumbing for all modules'
version '1.0.0'  -- Phase 1

dependencies {
    '/server:5848',  -- OneSync Infinity
    'ox_lib',
    'oxmysql'
}

server_scripts {
    'server/main.lua',
    'server/event_bus.lua',
    'server/logger.lua',
    'server/db.lua',
    'server/config_loader.lua',
    'server/timekeeper.lua'
}

client_scripts {
    'client/core.lua',
    'client/notify.lua',
    'client/markers.lua'
}

shared_scripts {
    'shared/enums.lua',
    'shared/constants.lua',
    'shared/schema.lua'
}

files {
    'config/permissions.json',
    'config/server_settings.json',
    'config/locales/en-US.json'
}

lua54 'yes'