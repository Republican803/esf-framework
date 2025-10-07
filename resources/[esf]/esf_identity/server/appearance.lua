-- server/appearance.lua: Optional skin/outfit integration hooks
local DB = require('esf_core/db')
local defaultAppearance = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config/default_appearance.json')) or {model = 'mp_m_freemode_01', components = {}}

local function GetAppearance(charId, cb)
    DB.Execute('SELECT appearance FROM appearance WHERE char_id = ?', {charId}, function(result)
        cb(result and #result > 0 and json.decode(result[1].appearance) or defaultAppearance)
    end)
end

local function SetAppearance(charId, appearance, cb)
    local appJson = json.encode(appearance)
    DB.Execute('REPLACE INTO appearance (char_id, appearance) VALUES (?, ?)', {charId, appJson}, function(affected)
        cb(affected > 0)
    end)
end

-- Hook to character creation/selection
EventBus.Subscribe('esf:identity:characterSelected', function(payload)
    GetAppearance(payload.charId, function(app)
        TriggerClientEvent('esf:identity:applyAppearance', payload.source, app)
    end)
end)

exports('GetAppearance', GetAppearance)
exports('SetAppearance', SetAppearance)