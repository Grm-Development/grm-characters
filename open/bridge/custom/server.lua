
-- This is just an example to how to use this script with a custom framework

---@param source number
---@return string
function bridge.getIdentifier(source)
    return exports.core:getIdentifier(source)
end

---@param source number|string
---@return boolean
function bridge.playerLogout(source)
    return exports.core:logoutPlayer(source)
end

---@param source number|string
---@param identifier string
---@param identity table
---@return boolean
function bridge.playerLogin(source, identifier, identity)
    -- when you register a new character the identifier is nil
    return exports.core:loginPlayer(source, identifier, identity)
end

---@param license string
---@param limit number
---@return table
function bridge.getUserCharacters(license, limit)
    return exports.core:fetchUserCharacters(license, limit)
end

--[[
    ---@CharacterData
    ---Provide the following data in "bridge.getUserCharacters"
    {
        {
            disabled: boolean,
            identifier: string, -- used for the player login    
            skin: table|nil,
            createdAt: string, -- %d/%m/%Y
            firstname: string,
            lastname: string,
            gender: string -- m/f
        }
    }

    ---A little example to how handle the playerLogin in your framework

    exports(
        "playerLogin", 
        function(source, identifier, identity) -- we provide this data in bridge.playerLogin
            local id = identifier or MySQL.insert.await("INSERT INTO ...", { identity... })
            local data = MySQL.query.await("SELECT * FROM users WHERE id = ?", { id })

            if data then
                core.players[source] = createPlayerClass({
                    id = id,
                    name = data.name,
                    dob = data.dob,
                    gender = data.gender
                })
                return true
            end
        end
    )
]]