-- server/timekeeper.lua: Server time, tick budgets
local Logger = require('logger')

local Timekeeper = {}

local tickBudgets = {}  -- {resource = {totalTicks = 0, lastReset = os.time()}}

function Timekeeper.Init()
    Logger.Info('Timekeeper initialized')
    -- Reset budgets every minute
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(60000)
            Timekeeper.ResetBudgets()
        end
    end)
end

-- Sync server time (e.g., for timestamps)
function Timekeeper.SyncServerTime()
    TriggerClientEvent('esf:core:syncTime', -1, os.time())
end

-- Track tick usage (called from resources)
function Timekeeper.TrackTick(resource, tickTime)
    if not tickBudgets[resource] then
        tickBudgets[resource] = {totalTicks = 0, lastReset = os.time()}
    end
    tickBudgets[resource].totalTicks = tickBudgets[resource].totalTicks + tickTime
    if tickBudgets[resource].totalTicks > 100 then  -- Example budget threshold (ms/min)
        Logger.Warn('Tick budget exceeded for ' .. resource)
    end
end

function Timekeeper.ResetBudgets()
    for resource, data in pairs(tickBudgets) do
        data.totalTicks = 0
        data.lastReset = os.time()
    end
end

-- Export for other resources to report ticks
exports('TrackTick', Timekeeper.TrackTick)

return Timekeeper