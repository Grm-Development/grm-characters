-- Last update (20.06.2026)

math.randomseed(GetGameTimer())

local __config = {
    language = config.language,
    theme = config.theme,
    storeUrl = require 'open.config.multicharacter.settings'.storeUrl,
    blacklist = { words = require 'open.config.identity.blacklist' }
}

--------------------------------------------------------------------------------------------------------------------------
-------------| NUI Callbacks
--------------------------------------------------------------------------------------------------------------------------

register_nui_callback("init", function(data, cb) 
    return { config = __config, identity = require 'open.config.identity.settings' }
end)

register_nui_callback("notify", function(data)
    lib.notify({ title = grm_locale("server_name"), description = grm_locale(data.code), type = data.type })
end)

register_nui_callback("identity:openCustom", function()
    utils.openCustomIdentity()
end)

register_nui_callback("identity:setCamera", function(data) 
    ({switch_cam_to_multichar, switch_cam_to_identity})[data.status and 2 or 1]()
end)

register_nui_callback("identity:createCharacter", function(data) 
    TriggerServerEvent("grm-characters:login", bridge.generateCharId(main.characters, main.availableSlots), data)
end)

register_nui_callback("multicharacter:loadCharacter", function(data) 
    TriggerServerEvent("grm-characters:login", data.identifier)
end)

register_nui_callback('multicharacter:loadSkin', function(data)
    ClearPedTasksImmediately(cache.ped)
    
    if main.scenario then delete_scenario_props() end

    main.scenario = nil

    if data.purchase then return set_purchase_skin() end

    if data.creation then return set_creation_skin() end
    
    data.gender = data.gender or "m"
    
    set_owned_skin(data.skin, data.gender)

    if not main.config.anims then return end

    assert(table.type(main.config.anims) == "hash", "the anims template need to be an hash.")

    assert(main.config.anims[data.gender], ("no animations for this gender! `%s`"):format(data.gender))

    if table.type(main.config.anims) == "empty" then return grm_debug("no animations founded.") end

    local anim = main.config.anims[data.gender][math.random(1, #main.config.anims[data.gender])]
    
    if not anim.dict and not anim.clip then return play_scenario(anim) end

    lib.playAnim(cache.ped, anim.dict, anim.clip, -8.0, 8.0, -1, 1, 0.0, true, true, true)
end)
