-- Last update (13.11.2025)

local relog = require 'open.config.multicharacter.relog'

if relog?.enabled then
    if (type(relog.command) == "string") and relog.command:len() > 0 then
        RegisterCommand(
            relog.command,
            function()
                if not main.loaded and not config.debug then
                    return grm_debug("player not loaded!")
                end

                if not main.relog and not config.debug then 
                    return grm_debug("relog not available now!")
                end

                if type(relog.conditions) == "function" and not relog.conditions() then
                    return bridge.notify(grm_locale("relog_error"), "error")
                end

                local success = true
                
                if relog.alert then
                    success = utils.showAlert(grm_locale("relog_alert_header"), grm_locale("relog_alert_content"))
                end

                if success then
                    TriggerServerEvent("grm-characters:relog")
                end
            end
        )
    end
end