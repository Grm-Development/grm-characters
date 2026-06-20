
if config.richpresence.enabled and config.richpresence.appId then 
    SetDiscordAppId(config.richpresence.appId)
    SetDiscordRichPresenceAsset(config.richpresence.asset)
    SetDiscordRichPresenceAssetText("Grm Characters")
end

---@param text string
---@return void
function utils.setCurrentActivity(text)
    return config.richpresence.enabled and SetRichPresence(text)
end

---@param header string
---@param content string
---@return boolean
function utils.showAlert(header, content)
    return lib.alertDialog({ header = header, content = content, centered = true, cancel = true }) == "confirm"
end

---@param entity string|number
---@param normal boolean
---@param slow boolean
---@return void
function utils.asyncFadeOutEntity(entity, normal, slow)
    NetworkFadeOutEntity(entity, normal, slow)
    while NetworkIsEntityFading(entity) do Wait(0) end
end

---@param entity string|number
---@param bNetwork number
---@return void
function utils.asyncFadeInEntity(entity, bNetwork)
    NetworkFadeInEntity(entity, bNetwork)
    while NetworkIsEntityFading(entity) do Wait(0) end
end

---@return void
function utils.openCustomIdentity()
    return grm_debug("openCustomIdentity") -- put here the event of your custom identity
end

---@param apperance table
---@return void
function utils.setPlayerAppearance(appearance)
    if config.appearance == "fivem-appearance" then 
        exports['fivem-appearance']:setPlayerAppearance(appearance)
    elseif config.appearance == "illenium-appearance" then 
        exports['illenium-appearance']:setPlayerAppearance(appearance)
    elseif config.appearance == "bl_appearance" then 
        exports.bl_appearance:SetPlayerPedAppearance(appearance)
    elseif config.appearance == "esx_skin" then
        local p = promise.new()
        TriggerEvent("skinchanger:loadSkin", appearance, function() 
            p:resolve() 
        end)
        Citizen.Await(p)
    end
end

---@return void
function utils.openPersonalizationMenu(gender)
    local p = promise.new()

    if config.appearance == "fivem-appearance" then 
        exports['fivem-appearance']:startPlayerCustomization(function(appearance)
            if (appearance) then 
                TriggerServerEvent("fivem-appearance:save", appearance)
            end
            p:resolve()
        end, {
            ped = false,
            headBlend = true,
            faceFeatures = true,
            headOverlays = true,
            enableExit = false,
            components = true,
            props = true,
            tattoos = true
        })
    elseif config.appearance == "illenium-appearance" then 
        exports['illenium-appearance']:createCharacter(gender, function()
            -- modified illenium appearance, check our docs/Discord
            p:resolve()
        end)
    elseif config.appearance == "bl_appearance" then 
        exports.bl_appearance:InitialCreation(function()
            p:resolve()
        end)
    elseif config.appearance == "esx_skin" then 
        TriggerEvent("esx_skin:openSaveableMenu", function()
            p:resolve()
        end, function()
            p:resolve()
        end)
    end
    Citizen.Await(p)
end
