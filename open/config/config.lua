return {        
    -- [SCRIPT LANGUAGE]
    -- Determines the language used for the script’s NUI (UI) and text.
    -- It pulls the value from the convar "ox:locale", defaulting to "en" (English).
    language = GetConvar("ox:locale", "en"),

    -- [APPEARANCE SYSTEM]
    -- Select which appearance/skin creator system the script should use.
    -- "auto" = automatically detect the system.
    -- Supported systems: esx_skin, fivem-appearance, bl_apperance, illenium-appearance.
    -- If using a custom system, modify utility.setPlayerAppearance in open/client.lua.
    appearance = "auto",

    -- [FRAMEWORK]
    -- Choose which framework the script should use.
    -- "auto" = automatically detect the framework.
    -- For custom frameworks, create a folder inside open/bridge with your framework name.
    framework = "auto", -- Options: auto / esx / qb / qbx / custom 

    -- [DEBUG]
    -- Enable or disable debug prints in the console.
    -- Useful for troubleshooting or checking script operations.
    debug = true,

    -- [NUI'S]
    -- UI color theme configuration.
    -- Colors support hex, rgb, and rgba formats.
    theme = {
        primary = "#ff1043",   -- Primary UI color
        secondary = "#a51030"  -- Secondary UI color
    },

    -- [RICH PRESENCE]
    -- Enables integration with Discord Rich Presence.
    -- Shows player actions such as selecting or spawning a character.
    richpresence = {
        enabled = true,        -- Enable/disable Discord Rich Presence
        appId = 12345678901234567890, -- Discord application ID
        asset = "logo"         -- Image/asset name used in the rich presence
    }
}