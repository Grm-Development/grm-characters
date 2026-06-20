
_ENV.config = require 'open.config.config'
_ENV.utils = {}
_ENV.bridge = {}

--------------------------------------------------------------------------------------------------------------------------
-------------| Shared functions
--------------------------------------------------------------------------------------------------------------------------

function grm_debug(...)
    return config.debug and print(("^1[grm-characters]^0 ^5[debug]^0 %s"):format(table.concat({...}, " ")))
end

function grm_locale(key, ...)
    return not config.locales[key] and key or ... and config.locales[key]:format(...) or config.locales[key]
end

--------------------------------------------------------------------------------------------------------------------------
-------------| Locales initialization
--------------------------------------------------------------------------------------------------------------------------

local translations = require 'open.config.locales'
local language = config.language or "en"

assert(translations and translations[language], ("can't find locale `%s` in open/config/locales.lua"):format(language))
config.locales = translations[language]
grm_debug(("started with `%s` locales"):format(language))

--------------------------------------------------------------------------------------------------------------------------
-------------| Compatibility
--------------------------------------------------------------------------------------------------------------------------

local resources = {
    ['appearance'] = {'esx_skin','fivem-appearance','bl_appearance','illenium-appearance'},
    ['frameworks'] = {['es_extended'] = 'esx',['qbx_core'] = 'qbx',['qbx-core'] = 'qbx',['qb_core'] = 'qb',['qb-core'] = 'qb'}
}

local function findStartedResource(list, returnKey)
    for key, value in pairs(list) do
        local name = returnKey and key or value

        if GetResourceState(name):find("start") then
            return returnKey and value or name
        end
    end
end

if config.framework == "auto" then
    local framework = findStartedResource(resources.frameworks, true)
    assert(framework, "can't find a framework! check open/config/settings.lua")
    config.framework = framework
end

if config.appearance == "auto" then
    local appearance = findStartedResource(resources.appearance)
    assert(appearance, "can't find an appearance manager system! check open/config/settings.lua")
    config.appearance = appearance
end

--------------------------------------------------------------------------------------------------------------------------
-------------| Start everything
--------------------------------------------------------------------------------------------------------------------------

require(("open.bridge.%s.%s"):format(config.framework, lib.context))
require(("open.editable.%s"):format(lib.context))

grm_debug(("started with `%s` framework."):format(config.framework))
grm_debug(("started with `%s` appearance system"):format(config.appearance))
