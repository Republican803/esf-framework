-- server/characters.lua: Create/select/delete; last position, dept
local DB = require('esf_core/db')
local Logger = require('esf_core/logger')
local EventBus = require('esf_core/event_bus')
local Config = require('esf_core/config_loader')
local limits = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config/character_limits.json')) or {max_slots = 4, delete_cooldown_hours = 24}
local departments = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config/departments.json')) or {}

local function GetCharacters(accountId, cb)
    DB.Execute('SELECT slot, char_name, age, dept, rank, last_pos FROM characters WHERE account_id = ?', {accountId}, function(result)
        cb(result)
    end)
end

local function CreateCharacter(accountId, slot, name, age, bio, dept, rank, outfit, cb)
    if not departments[dept] then return cb(false, 'Invalid department') end
    if not departments[dept].eup_outfits[outfit] then return cb(false, 'Invalid outfit') end
    DB.Execute('SELECT COUNT(*) as count FROM characters WHERE account_id = ?', {accountId}, function(countRes)
        if countRes[1].count >= limits.max_slots then return cb(false, 'Max slots reached') end
        DB.Insert('INSERT INTO characters (account_id, slot, char_name, age, bio, dept, rank, last_pos) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', 
            {accountId, slot, name, age, bio, dept, rank or 'recruit', json.encode(departments[dept].spawn_coords)}, function(insertId)
            Logger.Info('Created character', {id = insertId, dept = dept, name = name})
            -- Set initial appearance with selected EUP
            local app = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config/default_appearance.json'))
            app.components = departments[dept].eup_outfits[outfit].components
            exports.esf_identity:SetAppearance(insertId, app)
            cb(true, insertId)
        end)
    end)
end

local function SelectCharacter(accountId, slot, cb)
    DB.Execute('SELECT id, char_name, age, dept, rank, last_pos FROM characters WHERE account_id = ? AND slot = ?', {accountId, slot}, function(result)
        if result and #result > 0 then
            local char = result[1]
            EventBus.Publish('esf:identity:characterSelected', {source = source, charId = char.id, dept = char.dept})
            cb(true, char)
        else
            cb(false, 'Character not found')
        end
    end)
end

local function DeleteCharacter(accountId, slot, cb)
    DB.Execute('SELECT deleted_at FROM characters WHERE account_id = ? AND slot = ?', {accountId, slot}, function(result)
        if result and #result > 0 and result[1].deleted_at then
            local cooldownEnd = result[1].deleted_at + (limits.delete_cooldown_hours * 3600)
            if os.time() < cooldownEnd then return cb(false, 'Delete cooldown active') end
        end
        DB.Execute('DELETE FROM characters WHERE account_id = ? AND slot = ?', {accountId, slot}, function(affected)
            cb(affected > 0)
        end)
    end)
end

-- Net events (updated for create with new fields)
RegisterNetEvent('esf:identity:getCharacters')
AddEventHandler('esf:identity:getCharacters', function(accountId)
    GetCharacters(accountId, function(chars) TriggerClientEvent('esf:identity:charactersList', source, chars) end)
end)

RegisterNetEvent('esf:identity:createCharacter')
AddEventHandler('esf:identity:createCharacter', function(accountId, slot, name, age, bio, dept, rank, outfit)
    CreateCharacter(accountId, slot, name, age, bio, dept, rank, outfit, function(success, data) TriggerClientEvent('esf:identity:createResponse', source, success, data) end)
end)

RegisterNetEvent('esf:identity:selectCharacter')
AddEventHandler('esf:identity:selectCharacter', function(accountId, slot)
    SelectCharacter(accountId, slot, function(success, char) TriggerClientEvent('esf:identity:selectResponse', source, success, char) end)
end)

RegisterNetEvent('esf:identity:deleteCharacter')
AddEventHandler('esf:identity:deleteCharacter', function(accountId, slot)
    DeleteCharacter(accountId, slot, function(success) TriggerClientEvent('esf:identity:deleteResponse', source, success) end)
end)

exports('GetDepartments', function() return departments end)