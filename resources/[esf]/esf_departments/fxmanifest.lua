-- fxmanifest.lua for [resource name] (e.g., esf_core)
fx_version 'cerulean'
game 'gta5'

author '[Your Name]'
description 'ESF Framework Resource: [Resource Description]'
version '0.0.1'  -- Phase 0

-- Dependencies (for future)
dependencies {
    '/server:5848',  -- OneSync Infinity
    'ox_lib',
    'oxmysql'
}

-- Files (empty for now)
client_scripts {}
server_scripts {}
shared_scripts {}

lua54 'yes'