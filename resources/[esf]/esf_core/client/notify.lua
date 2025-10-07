-- client/notify.lua: Toasts/notifications
-- Uses ox_lib for notify if available, fallback to native

local function Notify(msg, type, duration)
    if exports.ox_lib then
        exports.ox_lib:notify({
            title = 'ESF',
            description = msg,
            type = type or 'info',
            duration = duration or 5000
        })
    else
        -- Fallback native
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(false, false)
    end
end

-- Export
exports('Notify', Notify)

-- Example usage: Notify('Welcome to ESF', 'success')