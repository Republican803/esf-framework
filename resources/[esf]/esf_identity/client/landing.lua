-- client/landing.lua: Join lock, camera, input capture, NUI boot
local previewCam
local previewCoords = vector3(402.9, -996.5, -99.0)  -- Standard interior for char preview

RegisterNetEvent('esf:identity:accountResolved')
AddEventHandler('esf:identity:accountResolved', function(accountId)
    -- Lock input, set camera
    DisableAllControlActions(0)
    previewCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(previewCam, previewCoords.x, previewCoords.y, previewCoords.z + 1.0)
    PointCamAtCoord(previewCam, previewCoords.x, previewCoords.y, previewCoords.z)
    SetCamActive(previewCam, true)
    RenderScriptCams(true, false, 0, true, true)

    -- Boot NUI
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'open', accountId = accountId, departments = exports.esf_identity:GetDepartments()})
end)

-- NUI callbacks (unchanged, but JS handles more)
RegisterNUICallback('getCharacters', function(data, cb)
    TriggerServerEvent('esf:identity:getCharacters', data.accountId)
    cb('ok')
end)

RegisterNetEvent('esf:identity:charactersList')
AddEventHandler('esf:identity:charactersList', function(chars)
    SendNUIMessage({action = 'updateCharacters', characters = chars})
end)

RegisterNUICallback('createCharacter', function(data, cb)
    TriggerServerEvent('esf:identity:createCharacter', data.accountId, data.slot, data.name, data.age, data.bio, data.dept, data.rank, data.outfit)
    cb('ok')
end)

RegisterNetEvent('esf:identity:createResponse')
AddEventHandler('esf:identity:createResponse', function(success, data)
    SendNUIMessage({action = 'createResponse', success = success, data = data})
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    TriggerServerEvent('esf:identity:selectCharacter', data.accountId, data.slot)
    cb('ok')
end)

RegisterNetEvent('esf:identity:selectResponse')
AddEventHandler('esf:identity:selectResponse', function(success, char)
    if success then
        SendNUIMessage({action = 'close'})
        SetNuiFocus(false, false)
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(previewCam, false)
        EnableAllControlActions(0)
        -- Proceed to spawn
        TriggerEvent('esf:identity:spawnCharacter', char)
    else
        SendNUIMessage({action = 'error', message = char})
    end
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    TriggerServerEvent('esf:identity:deleteCharacter', data.accountId, data.slot)
    cb('ok')
end)

RegisterNetEvent('esf:identity:deleteResponse')
AddEventHandler('esf:identity:deleteResponse', function(success)
    SendNUIMessage({action = 'deleteResponse', success = success})
end)

RegisterNUICallback('closeNui', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)