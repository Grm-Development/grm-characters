
assert(
    GetResourceState("esx_multicharcater") == "missing", 
    "esx_multicharacter can broke this resource, please remove."
)

local ESX = exports.es_extended:getSharedObject()

--------------------------------------------------------------------------------------
-------------| Events
--------------------------------------------------------------------------------------

local RegisterEvent = ESX.SecureNetEvent or RegisterNetEvent

RegisterEvent("esx:onPlayerLogout", function()
    player_logout_init() -- internal function
end)

RegisterEvent("esx:playerLoaded", function(data, isNew, skin)
    player_loaded_init({ gender = data.gender, name = data.name, coords = data.coords, new = isNew })
end)

--------------------------------------------------------------------------------------
-------------| Functions
--------------------------------------------------------------------------------------

---@param message string
---@param notifyType string
---@return void
function bridge.notify(message, notifyType)
    ESX.ShowNotification(message, notifyType, 5000)
end

---@param characters table
---@param limit number
function bridge.generateCharId(characters, limit)
    local list = {}

    for i = 1, #characters do 
        local character = characters[i]

        list[tostring(character.identifier:match("char(%d)"))] = true
    end

    for i = 1, limit do
        if not list[tostring(i)] then 
            return i 
        end
    end
end
