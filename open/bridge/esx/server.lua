
assert(GetResourceState("esx_multicharcater") == "missing", "esx_multicharacter can broke this resource, please remove.")

local ESX = exports.es_extended:getSharedObject()

require '@oxmysql.lib.MySQl' 

---@param source number
---@return string
function bridge.getIdentifier(source)
    return ESX.GetIdentifier(source)
end

---@param source number|string
---@return boolean
function bridge.playerLogout(source)
    TriggerEvent("esx:playerLogout", source)
end

---@param data table
---@return table
local function format_identity(data)
    return data and { lastname = data.lastname, firstname = data.firstname, sex = data.gender, dateofbirth = data.dob }
end

---@param source number|string
---@param identifier string
---@param identity table
---@return boolean
function bridge.playerLogin(source, identifier, identity)
    local id = not identity and identifier:match("^(.-):") or ("char" .. identifier)
    TriggerEvent("esx:onPlayerJoined", source, id, format_identity(identity))
end

---@param license string
---@param limit number
---@return table
function bridge.getUserCharacters(license, limit)
    local query = [[
        SELECT 
            `disabled`, 
            `identifier`, 
            `skin`, 
            DATE_FORMAT(created, '%d/%m/%Y') AS createdAt, 
            `firstname`, 
            `lastname`, 
            `sex` AS gender 
        FROM 
            `users` 
        WHERE 
            `identifier` LIKE ?
        LIMIT ?
    ]]
    return MySQL.query.await(query, { "char%:" .. license, limit })
end

--------------------------------------------------------------------------------------------------------------------------
-------------| Initialization
--------------------------------------------------------------------------------------------------------------------------

MySQL.ready(
    function()
        local columns = MySQL.query.await("SHOW COLUMNS FROM `users`")
        local search = { ["disabled"] = true, ["created"] = true }

        lib.array.find(columns, function(col)
            search[col.Field] = (search[col.Field] and nil)
        end)
        
        if search.disabled then 
            MySQL.query.await("ALTER TABLE `users` ADD COLUMN `disabled` INT(11) NOT NULL DEFAULT 0")
            grm_debug("refreshed database, altered table `users`, added `disabled` column.")
        end

        if search.created then 
            MySQL.query.await("ALTER TABLE `users` ADD COLUMN `created` TIMESTAMP NOT NULL DEFAULT current_timestamp()")
            grm_debug("refreshed database, altered table `users`, added `created` column.")
        end
    end
)
