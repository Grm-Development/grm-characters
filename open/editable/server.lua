
---Some appearance system's use a different method to store the player skin (instead of skin column in users table)
---@param character table
---@return table|nil
function utils.getAppearance(identifier)
    if config.appearance == "bl_appearance" then 
        return exports.bl_appearance:GetPlayerAppearance(identifier)
    elseif config.framework == "qb" then 
        return bridge.getPlayerSkin(identifier)
    end
end