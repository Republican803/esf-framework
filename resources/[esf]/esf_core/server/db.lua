-- server/db.lua: oxmysql wrapper (execute/insert/scalar)
local oxmysql = exports.oxmysql
local Logger = require('logger')

local DB = {}

function DB.Init()
    -- Check connection
    oxmysql:execute('SELECT 1', {}, function(result)
        if result then
            Logger.Info('Database connected successfully')
        else
            Logger.Error('Database connection failed')
        end
    end)
end

-- Execute (async with callback)
function DB.Execute(query, params, cb)
    oxmysql:execute(query, params, function(result)
        if cb then cb(result) end
    end)
end

-- Insert (returns insertId)
function DB.Insert(query, params, cb)
    oxmysql:insert(query, params, function(insertId)
        if cb then cb(insertId) end
    end)
end

-- Scalar (single value)
function DB.Scalar(query, params, cb)
    oxmysql:scalar(query, params, function(value)
        if cb then cb(value) end
    end)
end

-- Transaction (atomic)
function DB.Transaction(queries, cb)
    oxmysql:transaction(queries, {}, function(success)
        if cb then cb(success) end
    end)
end

return DB