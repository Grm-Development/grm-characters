-- Last update (21.11.2025)

local uno <const> = require 'open.config.multicharacter.settings'
local due <const> = require 'open.config.loadscreen.settings'
local tre <const> = require 'open.config.loadscreen.suggestions'

lib.versionCheck('Grm-Development/grm-characters')

assert(tre[config.language], ("no loadscreen suggestions founded for langugage %s"):format(config.language))

local __loadscreen <const> = {
    theme = config.theme, 
    playlist = require 'open.config.loadscreen.playlist', 
    logoSrc = due?.logo, 
    backgroundSrc = due?.background, 
    socialUrls = require 'open.config.loadscreen.socials',
    suggestions = tre[config.language] 
}

--------------------------------------------------------------------------------------------------------------------------
-------------| Functions
--------------------------------------------------------------------------------------------------------------------------

---@param identifier string
---@return void
local function delete_player_slots(identifier)
    DeleteResourceKvp(("grm-characters:kvp:slots"):format(identifier)) 
end

---@param identifier string
---@param slots number|boolean
---@return void
local function set_player_slots(identifier, slots)
    SetResourceKvpInt(("grm-characters:kvp:slots"):format(identifier), slots)
end

---@param identifier string
---@return number
local function get_player_slots(identifier)
    local slots = GetResourceKvpInt(("grm-characters:kvp:slots"):format(identifier))
    return (slots > 0) and slots or (uno.defaultSlots or 2) 
end

--------------------------------------------------------------------------------------------------------------------------
-------------| Handlers
--------------------------------------------------------------------------------------------------------------------------

AddEventHandler("playerConnecting", function(_, __, def) 
    def.handover(__loadscreen)
end)

RegisterServerEvent("grm-characters:session", function(state)
    local playerId = source
    SetPlayerRoutingBucket(playerId, state and playerId or 0)
end)

RegisterServerEvent("grm-characters:relog", function()
    local playerId = source
    bridge.playerLogout(playerId)
    Player(playerId).state:set("grm_characters_loaded", false, true)
    Player(playerId).state:set("grm_characters_relog", false, true)
end)

RegisterServerEvent("grm-characters:login", function(identifier, identity)
    local playerId = source
    bridge.playerLogin(playerId, identifier, identity)
    Player(playerId).state:set("grm_characters_loaded", true, true)
end)

lib.callback.register("grm-characters:fetch", function(source)
    local license = bridge.getIdentifier(source)
    
    if not license then 
        return DropPlayer(source, grm_locale("cant_find_identifier")) 
    end

    local slots = get_player_slots(license)
    local chars = bridge.getUserCharacters(license, slots) or {}

    for k, v in pairs(chars) do
        chars[k].skin = utils.getAppearance(v.identifier) or json.decode(v.skin or "[]") or {}
        chars[k].status = "created"
    end
    
    return { characters = chars, availableSlots = slots }
end)