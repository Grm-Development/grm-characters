
assert(
    GetResourceState("qb-multicharacter") == "missing", 
    "qb-multicharacter can broke this resource, please remove."
)

assert(
    GetResourceState("qb-loading") == "missing",
    "qb-loading can broke this resource, please remove."
)

local QBCore = exports['qb-core']:GetCoreObject()

require '@oxmysql.lib.MySQL' 

local FETCH_USER_CHARACTERS = [[
    SELECT `disabled`, `citizenid`, `cid`, DATE_FORMAT(created, '%d/%m/%Y') AS createdAt, `charinfo` FROM `players` WHERE `license` = ? LIMIT ?
]]

---Sync our player loaded status with the framework one
---@param source number
AddEventHandler("QBCore:Server:OnPlayerUnload", function(source)
    Player(source).state:set("grm_characters_loaded", false, true)
    Player(source).state:set("grm_characters_relog", false, true)
end)

---@param cid number
---@return table|nil
function bridge.getPlayerSkin(cid)
    return MySQL.scalar.await("SELECT `skin` FROM playerskins WHERE citizenid = ? AND active = ?", { cid, 1 })
end

---@param source number|string
---@return boolean
function bridge.playerLogout(source)
    QBCore.Player.Logout(source)
end

---@param data table
---@return table
local function format_identity(data)
    return { lastname = data.lastname, firstname = data.firstname, gender = data.gender, birthdate = data.dob }
end

---@param source number|string
---@param identifier string
---@param identiy table|nil
---@return boolean
function bridge.playerLogin(source, identifier, identity)
    local success
    -- identifier: (charId for registration / citizenid for login)
    
    if identity then
        success = QBCore.Player.Login(source, false, { cid = identifier, charinfo = format_identity(identity) })
    else
        success = QBCore.Player.Login(source, identifier)
    end

    assert(success, "[qb] can't login player.")
    QBCore.Commands.Refresh(source)
    TriggerClientEvent("grm-characters_qb:spawn", source, identity ~= nil)
end

---@param source number
---@param limit number
---@return table
function bridge.getUserCharacters(source, limit)
    return lib.array.map(
        MySQL.query.await(FETCH_USER_CHARACTERS, { 
            QBCore.Functions.GetIdentifier(source, 'license'), 
            limit 
        }), 
        function(element, index)
            local charinfo = json.decode(element.charinfo)

            return {
                cid = element.cid,
                identifier = element.citizenid,
                createdAt = element.createdAt,
                disabled = element.disabled,
                firstname = charinfo.firstname,
                lastname = charinfo.lastname,
                gender = charinfo.gender
            }
        end
    )
end

--------------------------------------------------------------------------------------------------------------------------
-------------| Initialization
--------------------------------------------------------------------------------------------------------------------------

MySQL.ready(
    function()
        local columns = MySQL.query.await("SHOW COLUMNS FROM `players`")
        local search = { ["disabled"] = true, ["created"] = true }

        lib.array.find(columns, function(col)
            search[col.Field] = (search[col.Field] and nil)
        end)

        if search.disabled then 
            MySQL.query.await("ALTER TABLE `players` ADD COLUMN `disabled` INT(11) NOT NULL DEFAULT 0")
            grm_debug("refreshed database, altered table `players`, added `disabled` column.")
        end
        
        if search.created then 
            MySQL.query.await("ALTER TABLE `players` ADD COLUMN `created` TIMESTAMP NOT NULL DEFAULT current_timestamp()")
            grm_debug("refreshed database, altered table `players`, added `created` column.")
        end
    end
)
