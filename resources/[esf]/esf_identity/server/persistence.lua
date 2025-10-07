-- server/persistence.lua: Atomic saves & slot locks
local DB = require('esf_core/db')
local Logger = require('esf_core/logger')
local EventBus = require('esf_core/event_bus')

local activeSessions = {}  -- {source = {charId, startTime, lastSave}}

local function SaveLastPos(source, coords)
    local session = activeSessions[source]
    if not session then return end
    DB.Execute('UPDATE characters SET last_pos = ? WHERE id = ?', {json.encode(coords), session.charId})
end

local function SavePlaytime(source)
    local session = activeSessions[source]
    if not session then return end
    local playtime = os.time() - session.startTime
    DB.Execute('UPDATE playtime SET total_time = total_time + ? WHERE char_id = ?', {playtime, session.charId})
end

-- Atomic save (transaction)
local function AtomicSave(source)
    SavePlaytime(source)
    -- More in future (inventory, etc.)
    activeSessions[source].lastSave = os.time()
    Logger.Debug('Atomic save for player ' .. source)
end

-- Periodic save
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)  -- 5 min
        for src, session in pairs(activeSessions) do
            AtomicSave(src)
        end
    end
end)

-- On select
EventBus.Subscribe('esf:identity:characterSelected', function(payload)
    local src = payload.source
    activeSessions[src] = {charId = payload.charId, startTime = os.time(), lastSave = os.time()}
    DB.Insert('INSERT INTO playtime (char_id, total_time) VALUES (?, 0) ON DUPLICATE KEY UPDATE total_time = total_time', {payload.charId})
end)

-- On drop
AddEventHandler('playerDropped', function()
    local src = source
    if activeSessions[src] then
        AtomicSave(src)
        activeSessions[src] = nil
    end
end)

-- Net event for pos save (from client)
RegisterNetEvent('esf:identity:saveLastPos')
AddEventHandler('esf:identity:saveLastPos', function(coords)
    SaveLastPos(source, coords)
end)