-- client/core.lua: Client boot; ESX/QBC neutral
local EventBus = exports.esf_core:SubscribeEvent  -- Assuming client-side event bus in future; for now, use natives

-- Global ESF client table
ESF = ESF or {}

Citizen.CreateThread(function()
    -- Boot sequence
    TriggerServerEvent('esf:core:playerLoaded', GetPlayerServerId(PlayerId()))

    -- Sync time on join
    RegisterNetEvent('esf:core:syncTime')
    AddEventHandler('esf:core:syncTime', function(serverTime)
        -- Use for client-side timestamps if needed
    end)

    -- Neutral player load (no ESX/QBCore dep)
    while true do
        Citizen.Wait(1000)
        -- Example: Check player ped, etc.
    end
end)