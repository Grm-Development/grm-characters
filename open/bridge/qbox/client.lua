
---@param character table
---@return void
local function qbx_scripts_backwords(character)
    if GetResourceState('qbx_apartments'):find('start') then
        TriggerEvent('apartments:client:setupSpawnUI', character.citizenid)
    elseif GetResourceState('qbx_spawn'):find('start') then
        TriggerEvent('qb-spawn:client:setupSpawns', character.citizenid)
        TriggerEvent('qb-spawn:client:openUI', true)
    else
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
    end
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
    player_loaded_init({ name = name, coords = data.position, new = isNew })
    qbx_scripts_backwords(data)
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