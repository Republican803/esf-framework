-- server/main.lua: Core init & boot sequence
local Config = require('config_loader')
local Logger = require('logger')
local DB = require('db')
local Timekeeper = require('timekeeper')
local EventBus = require('event_bus')

-- Global ESF table for exports
ESF = ESF or {}

-- Boot sequence
Citizen.CreateThread(function()
    -- Load configs
    Config.LoadAll()

    -- Init DB
    DB.Init()

    -- Init logger
    Logger.Init(Config.Get('server_settings').log_level or 'info')

    -- Init timekeeper (performance monitoring)
    Timekeeper.Init()

    -- Init event bus
    EventBus.Init()

    -- Export core functions
    exports('GetConfig', function(key) return Config.Get(key) end)
    exports('Log', function(level, msg, data) Logger.Log(level, msg, data) end)
    exports('ExecuteSQL', function(query, params, cb) DB.Execute(query, params, cb) end)

    -- Trigger boot event for other modules
    EventBus.Publish('esf:core:booted')

    Logger.Info('ESF Core booted successfully')
end)

-- Player load hook (neutral to ESX/QBCore)
AddEventHandler('playerJoining', function()
    local src = source
    EventBus.Publish('esf:core:playerJoining', { source = src })
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    EventBus.Publish('esf:core:playerDropped', { source = src, reason = reason })
end)

-- Example: Periodic time sync (performance-optimized, every 60s)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        Timekeeper.SyncServerTime()
    end
end)