-- server/identity.lua: Account resolution (license/steam/discord)
local DB = require('esf_core/db')
local Logger = require('esf_core/logger')
local EventBus = require('esf_core/event_bus')

local function GetIdentifiers(source)
    local ids = {}
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.find(id, 'license:') then ids.license = string.sub(id, 9) end
        if string.find(id, 'steam:') then ids.steam = string.sub(id, 7) end
        if string.find(id, 'discord:') then ids.discord = string.sub(id, 9) end
    end
    return ids
end

local function ResolveAccount(source, cb)
    local ids = GetIdentifiers(source)
    DB.Execute('SELECT id FROM accounts WHERE license = ? OR steam = ? OR discord = ?', {ids.license, ids.steam, ids.discord}, function(result)
        if result and #result > 0 then
            cb(result[1].id)
        else
            -- Create new account
            DB.Insert('INSERT INTO accounts (license, steam, discord) VALUES (?, ?, ?)', {ids.license, ids.steam, ids.discord}, function(insertId)
                Logger.Info('Created new account for player ' .. source, {accountId = insertId})
                cb(insertId)
            end)
        end
    end)
end

-- Hook to core player joining
EventBus.Subscribe('esf:core:playerJoining', function(payload)
    local src = payload.source
    ResolveAccount(src, function(accountId)
        TriggerClientEvent('esf:identity:accountResolved', src, accountId)
    end)
end)

exports('ResolveAccount', ResolveAccount)