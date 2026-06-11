
-- Relog command (back to character selection)

return {
    enabled = true, -- Enable/disable relog
    command = "relog", -- Command name
    alert = true, -- Show an alert for the relog ( ask the player if he is really sure to relog )
    conditions = function() -- Player can relog?
        return not IsPlayerSwitchInProgress() 
        and not IsPedFatallyInjured(cache.ped)
        and not IsPedFalling(cache.ped)
    end
}