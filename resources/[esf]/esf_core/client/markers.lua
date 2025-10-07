-- client/markers.lua: Draw markers / prompts
local activeMarkers = {}

-- Add a marker (event-driven, no loop)
function AddMarker(id, coords, type, scale, color, prompt)
    activeMarkers[id] = {coords = coords, type = type or 1, scale = scale or 1.0, color = color or {r=255,g=255,b=255,a=200}, prompt = prompt}
end

-- Remove marker
function RemoveMarker(id)
    activeMarkers[id] = nil
end

-- Draw loop (optimized, only if markers exist)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if next(activeMarkers) ~= nil then
            for id, marker in pairs(activeMarkers) do
                DrawMarker(marker.type, marker.coords.x, marker.coords.y, marker.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, marker.scale, marker.scale, marker.scale, marker.color.r, marker.color.g, marker.color.b, marker.color.a, false, true, 2, nil, nil, false)
                
                -- Prompt if close
                local playerCoords = GetEntityCoords(PlayerPedId())
                if #(playerCoords - marker.coords) < marker.scale then
                    DisplayHelpText(marker.prompt or 'Press ~INPUT_CONTEXT~ to interact')
                end
            end
        else
            Citizen.Wait(500)  -- Sleep if no markers
        end
    end
end)

-- Helper
function DisplayHelpText(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Exports
exports('AddMarker', AddMarker)
exports('RemoveMarker', RemoveMarker)