
-- These skins will be applied on the multicharacter.
-- Replace the owned skin when u slide on locked slot, on purchase slot, on create new one char slot or if the skin will not be founded.
-- You can find the appearance's formats here: 

return {
    -- (Skin fallback) When the character skin is not found
    -- These skin (by gender) will be set
    fallback = { 
        appearance = {
        ["m"] = { model = "mp_m_freemode_01" },
        ["f"] = { model = "mp_f_freemode_01" }
    }},

    -- When you switch on a purchasable character
    -- These settings will be setted
    purchase = { 
        scenario = "WORLD_HUMAN_BUM_FREEWAY",
        appearance = {
            model = "mp_m_freemode_01"
        }
    },
    
    -- When you switch on a available character
    -- These settings will be setted
    create = { 
        scenario = "WORLD_HUMAN_CLIPBOARD",
        appearance = {
            model = "mp_m_freemode_01"
        }
    }
}