-- json_validate.lua: Validates JSON files for syntax.
-- Usage: lua json_validate.lua file.json

local json = require('cjson')  -- Assuming cjson available in CI env

local function validate_json(file)
    local f = io.open(file, 'r')
    if not f then
        print('File not found: ' .. file)
        os.exit(1)
    end
    local content = f:read('*all')
    f:close()
    local ok, err = pcall(json.decode, content)
    if not ok then
        print('Invalid JSON in ' .. file .. ': ' .. err)
        os.exit(1)
    end
    print('Valid: ' .. file)
end

if #arg == 0 then
    print('Usage: lua json_validate.lua <file.json>')
    os.exit(1)
end

for _, file in ipairs(arg) do
    validate_json(file)
end