
assert(GetResourceState("qb-multicharacter") == "missing", "qb-multicharacter can broke this resource, please remove.")
assert(GetResourceState("qb-loading") == "missing", "qb-loading can broke this resource, please remove.")

local QBCore = exports['qb-core']:GetCoreObject()

--------------------------------------------------------------------------------------
-------------| Events
--------------------------------------------------------------------------------------

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    player_logout_init() -- internal function
end)

RegisterNetEvent("grm-characters_qb:spawn", function(isNew)
    local data = QBCore.Functions.GetPlayerData()
    local name = ("%s %s"):format(data.charinfo.firstname, data.charinfo.lastname)
    player_loaded_init({ name = name, coords = data.position, new = isNew })
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
end)

--------------------------------------------------------------------------------------
-------------| Functions
--------------------------------------------------------------------------------------

---@param message string
---@param notifyType string
---@return void
function bridge.notify(message, notifyType)
    QBCore.Functions.Notify(message, notifyType, 5000)
end

---@param data table
---@return table
function bridge.formatIdentity(data)
    return { 
        lastname = data.lastname, 
        firstname = data.firstname, 
        gender = data.gender, 
        birthdate = data.dob
    }
end

---@param characters table
---@param limit number
function bridge.generateCharId(characters, limit)
    local list = {}

    for i = 1, #characters do 
        list[characters[i].cid] = true
    end

    for i = 1, limit do
        if not list[i] then
            return i
        end
    end
end