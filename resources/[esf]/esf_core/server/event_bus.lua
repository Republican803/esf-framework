-- server/event_bus.lua: PubSub for cross-resource events
local Logger = require('logger')
local subscribers = {}

local EventBus = {}

function EventBus.Init()
    Logger.Info('EventBus initialized')
end

-- Subscribe to an event
function EventBus.Subscribe(eventName, callback)
    if not subscribers[eventName] then
        subscribers[eventName] = {}
    end
    table.insert(subscribers[eventName], callback)
    Logger.Debug('Subscribed to event: ' .. eventName)
end

-- Publish an event (async, no heavy loops)
function EventBus.Publish(eventName, payload)
    if subscribers[eventName] then
        for _, cb in ipairs(subscribers[eventName]) do
            Citizen.CreateThread(function()
                cb(payload)
            end)
        end
    end
    Logger.Debug('Published event: ' .. eventName)
end

-- Unsubscribe (for cleanup in future modules)
function EventBus.Unsubscribe(eventName, callback)
    if subscribers[eventName] then
        for i, cb in ipairs(subscribers[eventName]) do
            if cb == callback then
                table.remove(subscribers[eventName], i)
                break
            end
        end
    end
end

-- Exports for other modules
exports('SubscribeEvent', EventBus.Subscribe)
exports('PublishEvent', EventBus.Publish)

return EventBus