-- client/spawn_client.lua: Spawn preview & apply selection
AddEventHandler('esf:identity:spawnCharacter', function(char)
    local spawnCoords = json.decode(char.last_pos) or departments[char.dept].spawn_coords  -- Vector3 table
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Citizen.Wait(10) end

    RequestCollisionAtCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z)
    local ped = PlayerPedId()
    SetEntityCoordsNoOffset(ped, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, true, false)
    ClearPlayerWantedLevel(PlayerId())
    SetPlayerInvincible(PlayerId(), false)
    ClearPedBloodDamage(ped)

    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do Citizen.Wait(10) end

    -- Apply appearance (from event)
end)

RegisterNetEvent('esf:identity:applyAppearance')
AddEventHandler('esf:identity:applyAppearance', function(app)
    local ped = PlayerPedId()
    RequestModel(GetHashKey(app.model))
    while not HasModelLoaded(GetHashKey(app.model)) do Citizen.Wait(0) end
    SetPlayerModel(PlayerId(), GetHashKey(app.model))
    ped = PlayerPedId()  -- Update ped
    for comp, var in pairs(app.components) do
        SetPedComponentVariation(ped, comp, var.drawable, var.texture, var.palette)
    end
end)

-- Periodic pos save
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)  -- 1 min
        local coords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('esf:identity:saveLastPos', coords)
    end
end)