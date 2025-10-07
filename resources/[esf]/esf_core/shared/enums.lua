-- shared/enums.lua: Enums (incident types, statuses)
return {
    IncidentTypes = {
        TRAFFIC_STOP = 1,
        FIRE = 2,
        EMS = 3,
        -- Expand in future
    },
    Statuses = {
        ACTIVE = 'active',
        RESOLVED = 'resolved',
        -- Expand
    }
}