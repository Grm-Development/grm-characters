
local QbxConfig = require '@qbx_core.config.client'
local QbxSpawn = GetResourceState('qbx_spawn'):find("start")

assert(
    QbxConfig.characters.useExternalCharacters, 
    "to use this script, you need to enabled useExternalCharacters in qbx_core."
)

local function qbx_core_grmspawn(playerData, playerName, isNew)
    player_loaded_init({
        name = playerName, 
        coords = playerData.position, 
        new = isNew,
        gender = playerData.charinfo.gender
    })
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    TriggerEvent('qb-weathersync:client:EnableSync')
end

--------------------------------------------------------------------------------------
-------------| Events
--------------------------------------------------------------------------------------

RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
    player_logout_init() -- internal function
end)

RegisterNetEvent("grm-characters_qbx:spawn", function(isNew)
    local data = exports.qbx_core:GetPlayerData()
    local name = ("%s %s"):format(data.charinfo.firstname, data.charinfo.lastname)

    -- *QBX Core Logic of spawn*

    if not QbxSpawn then
        return qbx_core_grmspawn(data, name, isNew)
    else
        if not QbxConfig.characters.startingApartment then
            return qbx_core_grmspawn(data, name, isNew)
        else
            local apartments = {
                firstname = data.charinfo.firstname,
                lastname = data.charinfo.lastname,
                gender = data.charinfo.gender,
                nationality = data.charinfo.nationality,
                birthdate = data.charinfo.birthdate,
                cid = data.cid
            }

            player_spawn_init({name = name })
            TriggerEvent('apartments:client:setupSpawnUI', apartments)
        end
    end
end)

--------------------------------------------------------------------------------------
-------------| Functions
--------------------------------------------------------------------------------------

---@param message string
---@param notifyType string
---@return void
function bridge.notify(message, notifyType)
    exports.qbx_core:Notify(message, notifyType, 5000)
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