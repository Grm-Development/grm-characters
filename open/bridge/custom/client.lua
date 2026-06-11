
-- This is just an example to how to use this script with a custom framework

RegisterNetEvent("core:playerLogout", function()
    player_logout_init() -- internal function
end)

RegisterNetEvent("core:playerLoaded", function(player)
    player_loaded_init({ name = player.name, coords = player.coords, new = player.isNew }) -- internal function
end)

--------------------------------------------------------------------------------------
-------------| Functions
--------------------------------------------------------------------------------------

---@param message string
---@param _type string
---@return void
function bridge.notify(message, _type)
    exports.core:notify(message, _type, 5000)
end

---@param characters table
---@param limit number
---@return void
function bridge.generateCharId(characters, limit)
    -- we don't need to generate a charId
    return false
end