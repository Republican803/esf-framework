-- server/logger.lua: Structured logging helpers
local levels = { debug = 1, info = 2, warn = 3, error = 4 }
local currentLevel = levels.info

local Logger = {}

function Logger.Init(level)
    currentLevel = levels[level] or levels.info
    print('[ESF] Logger initialized at level: ' .. level)
end

local function shouldLog(level)
    return levels[level] >= currentLevel
end

function Logger.Log(level, msg, data)
    if not shouldLog(level) then return end
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    local output = string.format('[%s] [%s] %s', timestamp, level:upper(), msg)
    if data then
        output = output .. ' ' .. json.encode(data)
    end
    print(output)
end

function Logger.Debug(msg, data) Logger.Log('debug', msg, data) end
function Logger.Info(msg, data) Logger.Log('info', msg, data) end
function Logger.Warn(msg, data) Logger.Log('warn', msg, data) end
function Logger.Error(msg, data) Logger.Log('error', msg, data) end

return Logger