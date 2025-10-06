std = "lua51+fivefx"

globals = {
    -- FiveM globals
    "AddEventHandler", "RegisterServerEvent", "RegisterNetEvent", "TriggerClientEvent", "TriggerServerEvent",
    "GetPlayerIdentifiers", "GetPlayerPed", "GetEntityCoords", "vector3", "exports",
    -- OX libs
    "lib", "oxmysql", "ox_inventory",
    -- Custom (for future phases)
    "ESF"
}

ignore = {
    "212/self",  -- Unused self in methods (common in OOP Lua)
    "631"       -- Line too long (allow for comments)
}

max_line_length = 120