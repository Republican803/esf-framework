-- server/config_loader.lua: JSON loader + overrides
local ox_lib = exports.ox_lib
local Logger = require('logger')
local configs = {}

local Config = {}

function Config.LoadAll()
    -- Load permissions
    configs.permissions = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config/permissions.json')) or {}
    -- Load server_settings
    configs.server_settings = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config/server_settings.json')) or {}
    -- Load locales (default en-US)
    configs.locales = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config/locales/en-US.json')) or {}

    -- Apply overrides if any (e.g., from server.cfg or env)
    -- Example: if GetConvar('esf_log_level', '') then configs.server_settings.log_level = ... end

    Logger.Info('Configs loaded')
end

function Config.Get(key)
    local parts = ox_lib.string.split(key, '.')
    local current = configs
    for _, part in ipairs(parts) do
        current = current[part]
        if current == nil then return nil end
    end
    return current
end

return Config