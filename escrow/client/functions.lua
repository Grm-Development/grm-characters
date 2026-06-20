-- Last update (20.06.2026)

local scenarios = require 'open.config.multicharacter.scenarios'
local skins = require 'open.config.multicharacter.skins'
local settings = require 'open.config.multicharacter.settings'
local identity = require 'open.config.identity.settings'

function register_nui_callback(event, fn)
   RegisterNUICallback(event, function(data, cb) cb(fn(data) or {}) end) 
end

function send_react_message(action, data)
    SendNUIMessage({ action = action, data = data })
end

function sync_configuration(target, data)
    send_react_message("syncConfiguration", { [target] = data })
end

function set_nui_focus(state)
    SetNuiFocus(state, state)
    SetNuiFocusKeepInput(false)
end

function set_nui_state(target, state)
    set_nui_focus(state)
    send_react_message("setVisible", { target = target, status = state })
end

function open_personalization_menu(gender)
    utils.setCurrentActivity(grm_locale("activity_skinmenu")) 
    utils.openPersonalizationMenu(gender)
end

function play_scenario(scenario)
    main.scenario = scenario 
    TaskStartScenarioInPlace(cache.ped, main.scenario, 0, false)
end

function set_weather_type(weather)
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
end

function set_owned_skin(appearance)
    utils.asyncFadeOutEntity(cache.ped)
    set_ped_appearance(appearance)
    utils.asyncFadeInEntity(cache.ped, 1)
end

function switch_cam_to_multichar()
    stage_set_alpha(255)
    SetCamActiveWithInterp(main.stage.cams.multicharacter, main.stage.cams.identity, 1000, 1, 1)
    Wait(1000)
    utils.setCurrentActivity(grm_locale("activity_multicharacter"))
end

function switch_cam_to_identity()
    create_camera("identity", false, 5.0)
    stage_set_alpha(200)
    utils.setCurrentActivity(grm_locale("activity_creating_new"))
    SetCamActiveWithInterp(main.stage.cams.identity, main.stage.cams.multicharacter, 1000, 1, 1)
end

function set_player_coords(pos)
    RequestCollisionAtCoord(pos.x, pos.y, pos.z)
    while not HasCollisionLoadedAroundEntity(cache.ped) do Wait(0) end
    SetEntityCoordsNoOffset(cache.ped, pos.x, pos.y, pos.z, true, true, false)
    SetEntityHeading(cache.ped, pos.w or pos.heading)
end

function set_freemode_model()
    lib.requestModel("mp_m_freemode_01")
    SetPlayerModel(cache.playerId, `mp_m_freemode_01`)
    SetModelAsNoLongerNeeded(`mp_m_freemode_01`)
    cache.ped = PlayerPedId()
    SetPedDefaultComponentVariation(cache.ped)
    SetPedHeadBlendData(cache.ped, 0, 0, 0, 0, 0, 0, 0, 0, 0, false)
end

function set_creation_skin()
    utils.asyncFadeOutEntity(cache.ped, false, true)
    Wait(100)
    set_ped_appearance(skins.create.appearance)
    play_scenario(skins.create.scenario)
    Wait(100)
    utils.asyncFadeInEntity(cache.ped)
end

function set_purchase_skin()
    utils.asyncFadeOutEntity(cache.ped, false, true)
    Wait(100)
    set_ped_appearance(skins.purchase.appearance)
    play_scenario(skins.purchase.scenario)
    Wait(100)
    utils.asyncFadeInEntity(cache.ped)
end

function set_ped_appearance(appearance)
    utils.setPlayerAppearance(appearance)
    cache.ped = PlayerPedId()
end

function create_camera(typo, active, fov)
    local off = main.config?.offsets or vec3(0.0, 1.0, 0.38)
    local rgt = (typo == "multicharacter") and 0.0 or -0.05
    local pos = GetOffsetFromEntityInWorldCoords(cache.ped, rgt, off.y, off.z)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", active)
    main.stage.cams[typo] = cam
    SetCamCoord(cam, pos.x, pos.y, pos.z)
    SetCamFov(cam, ((main.config?.fov or 60.0) + (fov or 0.0)))
    pos = GetOffsetFromEntityInWorldCoords(cache.ped, rgt, off.y - 0.2, off.z)
    PointCamAtCoord(cam, pos.x, pos.y, pos.z)
end

function player_logout_init()
    main.characters = nil
    main.availableSlots = nil

    SetPlayerInvincible(cache.playerId, true)
    FreezeEntityPosition(cache.ped, true)
    utils.setCurrentActivity(grm_locale("activity_relog"))
    switch_to_part("first")
    set_player_coords(main.config.coords)
    prepare_character_selection()
    if not settings.gtaoTransitions then 
        start_character_selection()
    end
    switch_to_part("last")
    if settings.gtaoTransitions then 
        start_character_selection()
    end
    grm_debug("logout logic finished.")
end

function delete_scenario_props(prop)
    if not main.scenario then return end 

    local props = scenarios[main.scenario]
    
    if not props then return end
    
    if not prop then lib.array.forEach(props, delete_scenario_props) end

    local pos = GetEntityCoords(cache.ped)
    local obj = GetClosestObjectOfType(pos.x, pos.y, pos.z, 5.0, prop, false, true ,true)

    if not DoesEntityExist(obj) then return end 

    SetEntityAsMissionEntity(obj, false, false)
    DeleteObject(obj)
    grm_debug(("deleting scenario obj `%s`"):format(obj))
end

---If you doesn't want use our spawn system, you can use your
---Delete the stage, cams and nui focus with this
function player_spawn_init(data)
    set_nui_focus(false)
    DestroyAllCams(true)
    RenderScriptCams(false, false, 0, false, false)
    ClearPedTasksImmediately(cache.ped)
    delete_scenario_props()

    TriggerServerEvent("grm-characters:session", false)
    grm_debug("session switch (private => public)")
    ClearTimecycleModifier()
    stage_delete_all()

    main.override = false 
    Wait(1000)

    FreezeEntityPosition(cache.ped, false)
    SetPlayerControl(cache.playerId, true, 0)
    SetPlayerInvincible(cache.playerId, false)

    main.stage.cams = {}
    main.characters = nil
    main.availableSlots = nil
    main.relog = true
    
    utils.setCurrentActivity(grm_locale("activity_playing", data.name))
end

function player_loaded_init(data)
    set_nui_focus(false)
    stage_set_alpha(255)

    ClearPedTasksImmediately(cache.ped)
    delete_scenario_props()

    if data.new then 
        open_personalization_menu(data.gender) 
    end

    utils.setCurrentActivity(grm_locale("activity_spawning"))

    if not settings.gtaoTransitions then 
        switch_to_part("first")
    end

    DestroyAllCams(true)
    RenderScriptCams(false, false, 0, false, false)

    if settings.gtaoTransitions then 
        switch_to_part("first")
    end
    
    set_player_coords(data.coords)
    TriggerServerEvent("grm-characters:session", false)
    grm_debug("session switch (private => public)")
    ClearTimecycleModifier()
    stage_delete_all()
    main.override = false 
    Wait(1000)
    FreezeEntityPosition(cache.ped, false)
    SetPlayerControl(cache.playerId, true, 0)
    SetPlayerInvincible(cache.playerId, false)
    switch_to_part("last")

    main.stage.cams = {}
    main.characters = nil
    main.availableSlots = nil
    main.relog = true
    
    TriggerEvent("playerSpawned")
    utils.setCurrentActivity(grm_locale("activity_playing", data.name))
end

function prepare_character_selection()
    TriggerServerEvent("grm-characters:session", true)
    grm_debug("session switch (public => private)")
    FreezeEntityPosition(cache.ped, true)
    SetPlayerControl(cache.playerId, false, 0)
    SetPlayerInvincible(cache.playerId, true)
    ClearTimecycleModifier()
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    main.override = true
    CreateThread(override_game)
    if main.config.timecycle then
        SetTimecycleModifier(main.config.timecycle)
    end
    if main.config.weather then
        set_weather_type(main.config.weather)
    end
    set_player_coords(main.config.coords)
    set_freemode_model()
    stage_spawn_vehs(main.config.vehicles)
    stage_spawn_peds(main.config.peds)
end

---@return void
function start_character_selection()
    local fetch = lib.callback.await("grm-characters:fetch", false) 
    local state = (#fetch.characters == 0) and "identity" or "multicharacter"
    utils.setCurrentActivity(grm_locale(("activity_%s"):format(state)))

    create_camera(state, true)
    RenderScriptCams(true, true, 0, true, false)

    if state == "identity" then 
        set_creation_skin() 
        stage_set_alpha(200)
    end

    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    DoScreenFadeIn(1300)
    
    main.availableSlots = fetch.availableSlots 
    main.characters = fetch.characters 

    sync_configuration(state, {
        availableSlots = (fetch.availableSlots - #fetch.characters),
        characters = fetch.characters
    })
   
    set_nui_state(state, true)
end

function spawn_vehicle(data)
    assert(
        not data.properties or type(data.properties) == "table", 
        "`properties` param need to be a table!"
    ) 
    assert(
        not data.rotation or type(data.rotation) == "vector3", 
        "`rotation` param need to be a vector3!"
    ) 
    assert(
        type(data.coords) == "vector4", 
        "`coords` param need to be a vector4!"
    ) 
    local uno = lib.requestModel(data.model)
    local due = data.properties or { plate = "GRM" }
    local rot = data.rotation
    local pos = data.coords
    local veh = CreateVehicle(uno, pos.x, pos.y, pos.z, pos.w, false, true)

    repeat 
        Wait(0)
    until 
        DoesEntityExist(veh)

    if rot then 
        SetEntityRotation(veh, rot.xyz, 2)
    end

    table.insert(main.stage.vehs, veh)
    lib.setVehicleProperties(veh, due) 
    FreezeEntityPosition(veh, true)
    SetEntityInvincible(veh, true)
    SetVehicleEngineOn(veh, true, true, false)
    
    return veh
end

function spawn_ped(data)
    local uno = joaat(data.model)
    local pos = data.coords
    local ped   

    assert(
        IsModelInCdimage(uno), 
        ("model `%s` does not exist."):format(data.model)
    )

    RequestModel(uno)

    repeat 
        Wait(0) 
    until 
        HasModelLoaded(uno)

    if data.vehicle then 
        ped = CreatePedInsideVehicle(data.vehicle, 0, uno, data.seat, false, true)
    else
        ped = CreatePed(0, uno, pos.x, pos.y, pos.z, pos.w, false, true)
    end

    repeat 
        Wait(0)
    until 
        DoesEntityExist(ped)

    table.insert(main.stage.peds, ped)

    if data.scenario then
        TaskStartScenarioInPlace(ped, data.scenario)
    elseif data.anim then 
        lib.playAnim(ped, data.anim.dict, data.anim.clip, -8.0, 8.0, -1, 1, 0.0, true, true, true)
    elseif data.weapon then 
        GiveWeaponToPed(ped, data.weapon, 200, true, true)
    end

    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    return ped
end

function stage_set_alpha(alpha)
    if type(alpha) == "number" then
        for key, data in pairs(main.stage) do 
            if key == "vehs" or key == "peds" then 
                for i = 1, #data do
                    SetEntityAlpha(data[i], alpha)
                end
            end
        end
    end
end

function stage_delete_all()
    for key, data in pairs(main.stage) do 
        if key == "vehs" or key == "peds" then 
            for i = 1, #data do
                if key == "vehs" then
                    grm_debug(("deleting stage vehicle `%s`"):format(data[i]))
                    DeleteVehicle(data[i])
                    main.stage.vehs[i] = nil
                elseif key == "peds" then 
                    grm_debug(("deleting stage ped `%s`"):format(data[i]))
                    DeleteEntity(data[i])
                    main.stage.peds[i] = nil
                end
            end
        end
    end
end

function override_game()
    repeat
        local set_h = (main.config?.hours or 13)
        local set_m = (main.config?.minutes or 00)

        local now_h = GetClockHours()
        local now_m = GetClockMinutes()

        if now_h ~= set_h or now_m ~= set_m then
            NetworkOverrideClockTime(set_h, set_m, 00) 
        end
        
        HideHudAndRadarThisFrame()
        DisableAllControlActions(0)
        Wait(0)
    until not main.override
end

function stage_spawn_peds(npcs)
    if type(npcs) == "table" then 
        for i = 1, #npcs do 
            spawn_ped(npcs[i])
        end
    end
end

function stage_spawn_vehs(vehicles)
    if type(vehicles) == "table" then 
        for i = 1, #vehicles do 
            local uno = vehicles[i]
            local veh = spawn_vehicle(uno)

            if uno.passengers and #uno.passengers > 0 then 
                for j = 1, #uno.passengers do 
                    local this = uno.passengers[j]
                    local seat = GetVehicleModelNumberOfSeats(uno.model)
                    
                    if this.seat > seat then
                        warn(("model `%s` have only %s seats!"):format(uno.model, seat))
                    end

                    if not IsVehicleSeatFree(veh, this.seat) then 
                        warn(("seat: %s of vehicle: %s (%s) is already occupied!"):format(seat, veh, uno.model))
                    end 
                    
                    if this.scenario then 
                        warn("ped can't execute scenario in vehicles.")
                    end

                    spawn_ped({
                        vehicle = veh,
                        seat = this.seat,
                        weapon = this.weapon,
                        model = this.model
                    })
                end
            end
        end
    end
end

function switch_to_part(part)
    if part == "first" then 
        if settings.gtaoTransitions then 
            SwitchToMultiFirstpart(cache.ped, 0, 1)
            while GetPlayerSwitchState() ~= 5 do 
                Wait(0) 
            end
            grm_debug("switch first phase is done.")
        else
            DoScreenFadeOut(300)
            while not IsScreenFadedOut() do 
                Wait(0) 
            end 
            Wait(1000)
            grm_debug("transition first phase is done.")
        end
    elseif part == "last" then 
        if settings.gtaoTransitions then 
            SwitchToMultiSecondpart(cache.ped)
            SetGameplayCamRelativeHeading(0)
            while GetPlayerSwitchState() ~= 10 do 
                Wait(0) 
            end
            grm_debug("switch last phase is done.")
        else
            DoScreenFadeIn(300)
            Wait(1000)
            grm_debug("transition last phase is done.")
        end
    end
end
