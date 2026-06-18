
require '@oxmysql.lib.MySQl' 

---@param cid number
---@return table|nil
function bridge.getPlayerSkin(cid)
    return MySQL.query.await("SELECT * FROM playerskins WHERE citizenid = ? AND active = ?", { cid, 1 })
end

---@param source number
---@return string
function bridge.getIdentifier(source)
    return GetPlayerIdentifierByType(source, 'license')
end

---@param source number|string
---@return boolean
function bridge.playerLogout(source)
    exports.qbx_core:Logout(source)
end

---@param data table
---@return table
local function format_identity(data)
    return { lastname = data.lastname, firstname = data.firstname, gender = (data.gender == "m") and 0 or 1, birthdate = data.dob }
end

---@param source number|string
---@param identifier string
---@param identiy table|nil
---@return boolean
function bridge.playerLogin(source, identifier, identity)
    local success
    -- identifier: (charId for registration / citizenid for login)
    
    if identity then
        success = exports.qbx_core:Login(source, false, { cid = identifier, charinfo = format_identity(identity) })
    else
        success = exports.qbx_core:Login(source, identifier)
    end

    assert(success, "[qbx] can't login player.")
    TriggerClientEvent("grm-characters_qbx:spawn", source, identity ~= nil)
end

---@param license string
---@param limit number
---@return table
function bridge.getUserCharacters(license, limit)
    local query = [[
        SELECT 
            `disabled`, 
            `citizenid`, 
            `cid`, 
            DATE_FORMAT(created, '%d/%m/%Y') AS createdAt, 
            `charinfo`
        FROM  
            `players` 
        WHERE 
            `license` = ?
        LIMIT ?
    ]]
    return lib.array.map(
        MySQL.query.await(query, { license, limit }), 
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