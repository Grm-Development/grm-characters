-- Last update (21.11.2025)

local template = require 'open.config.multicharacter.templates'
local settings = require 'open.config.multicharacter.settings'

_ENV.main = {
    stage = {
        cams = {},
        vehs = {},
        peds = {},
    },
    override = false,
    loaded = LocalPlayer.state.grm_characters_loaded,
    relog = LocalPlayer.state.grm_characters_relog,
}

if not settings.randomBackground then 
    main.config = template[1]
else
    main.config = template[math.random(1, #template)]
end

AddStateBagChangeHandler("grm_characters_loaded", nil, function(_, _, result)
    main.loaded = result
    grm_debug(("loaded => %s"):format(result))
end)

AddStateBagChangeHandler("grm_characters_relog", nil, function(_, _, result)
    main.relog = result
    grm_debug(("relog => %s"):format(result))
end)

AddEventHandler("onResourceStop", function(resource)
    if cache.resource ~= resource then return end
    DestroyAllCams(true)
    RenderScriptCams(false, false, 0, false, false)
    main.stage.cams = {}
    delete_scenario_props()
    stage_delete_all()
end)

CreateThread(function()
    if main.loaded then main.relog = true return end
    StopPlayerSwitch()
    DoScreenFadeOut(0)
    repeat Wait(0) until IsScreenFadedOut()
    grm_debug("streaming requests start.")
    repeat Wait(0) until HaveAllStreamingRequestsCompleted(cache.ped)
    grm_debug("streaming requests completed.")
    Wait(2500)
    TriggerEvent("qb-weathersync:client:DisableSync")
    prepare_character_selection()
    start_character_selection()
    print(("^1[GRM]^0 Hi %s, welcome in 'Characters'"):format(GetPlayerName(cache.playerId)))
end)