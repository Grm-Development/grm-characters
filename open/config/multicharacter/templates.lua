
-- Here you can create new backgrounds for your multicharacter
-- Remember to enable 'randomTemplate' in open/config/multicharacter/settings.lua if you want them to be random.

return {
    {
        anims = {
            ["m"] = { 
                "WORLD_HUMAN_GUARD_STAND" 
            },
            ["f"] = { 
                "WORLD_HUMAN_GUARD_STAND" 
            }
        },
        vehicles = {
            {
                model = "infernus2",
                coords = vec4(106.2997, -1938.9742, 20.3316, 196.3271),
                properties = {
                    modLivery = -1,
                    livery = -1,
                    paintType2 = 0,
                    pearlescentColor = 18,
                    color1 = 145,
                    paintType1 = 0,
                    interiorColor = 93,
                    color2 = 0
                }
            },
            {
                model = "chino2",
                coords = vec4(106.9714, -1943.6384, 20.1659, 66.7154),
                properties = {
                    modLivery = 8,
                    livery = 8,
                    paintType2 = 7,
                    pearlescentColor = 120,
                    color1 = 148,
                    paintType1 = 7,
                    modAPlate = 2,
                    color2 = 25
                }
            }
        },
        peds = {
            {
                anim = {
                    dict = 'switch@michael@sitting',
                    clip = 'idle'
                },
                model = "g_m_y_ballasout_01",
                coords = vec4(104.1352, -1942.3535, 19.9, 60.1880)
            },
            {
                model = "g_f_y_ballas_01",
                coords = vec4(105.0594, -1939.1801, 19.8037, 113.2471),
                weapon = "WEAPON_ASSAULTRIFLE"
            }
        },
        hours = 16,
        coords = vec4(102.2119, -1941.1785, 20.8037, 90.6320)
    },
    {
        anims = {
            ["m"] = { 
                "WORLD_HUMAN_AA_COFFEE" 
            },
            ["f"] = { 
                "WORLD_HUMAN_AA_COFFEE" 
            }
        },
        vehicles = {
            {
                model = "elegy",
                coords = vec4(750.5705, -1850.2637, 28.6174, 319.8478),
                properties = {
                    color2 = 4,
                    pearlescentColor = 61,
                    livery = 3,
                    xenonColor = 255,
                    modLivery = 3,
                    modSpoilers = 15,
                    neonEnabled = {true, true, true, true},
                    modFrontBumper = 3,
                    modFender = 3,
                    paintType2 = 7,
                    paintType1 = 7,
                    neonColor = {43, 120, 236},
                    color1 = 4,
                    windowTint = 1
                }
            },
            {
                model = "jester3",
                coords = vec4(748.0201, -1847.5879, 28.5857, 54.2045),
                properties = {
                    xenonColor = 255,
                    color1 = 38,
                    windowTint = 1,
                    livery = 9,
                    paintType1 = 7,
                    neonColor = {255, 165, 0},
                    modSpoilers = 7,
                    neonEnabled = {true, true, true, true},
                    dashboardColor = 89,
                    modLivery = 9,
                    paintType2 = 7
                }
            }
        },
        peds = {
            {
                scenario = "WORLD_HUMAN_AA_SMOKE",
                coords = vec4(746.9528, -1848.2917, 28.2916, 145.7043),
                model = "csb_hao"
            },
            {
                anim = {
                    dict = 'switch@michael@sitting',
                    clip = 'idle'
                },
                coords = vec4(748.9625, -1851.1210, 28.6, 51.5804),
                model = "g_m_y_salvaboss_01"
            }
        },
        hours = 20,
        fov = 70.0,
        coords = vec4(746.1202, -1850.8092, 29.2915, 125.9577),
    },
    {
        anims = {
            ["m"] = { 
                "WORLD_HUMAN_COP_IDLES" 
            },
            ["f"] = { 
                "WORLD_HUMAN_COP_IDLES" 
            }
        },
        vehicles = {
            {
                coords = vec4(418.0245, -965.3451, 29.0370, 138.4592),
                model = "police",
                passengers = {
                    { seat = 2, model = "s_m_y_prismuscl_01" }
                }
            },
            {
                coords = vec4(411.6668, -969.3179, 28.9144, 338.0446),
                model = "police3",
                passengers = {
                    { seat = -1, model = "s_f_y_cop_01" },
                    { seat = 0, model = "s_m_y_cop_01" },
                }
            },
            {
                coords = vec4(418.9569, -979.9131, 35.9238, 324.7247),
                model = "polmav",
                properties = {
                    livery = 0
                },
                passengers = {
                    { seat = -1, model = "s_m_y_swat_01" },
                    { seat = 1, model = "s_m_y_swat_01" },
                }
            }
        },
        peds = {
            {
                coords = vec4(416.0359, -965.3861, 28.4580, 60.7170),
                model = "s_m_y_cop_01",
                weapon = "WEAPON_SMG"
            }
        },
        hours = 16,
        fov = 70.0,
        coords = vec4(411.5561, -963.7628, 29.4711, 41.9318)
    },
    {
        anims = {
            ["m"] = { 
                "WORLD_HUMAN_AA_COFFEE" 
            },
            ["f"] = { 
                "WORLD_HUMAN_AA_COFFEE" 
            }
        },
        vehicles = {
            {
                coords = vec4(572.4503, -750.9528, 11.7179, 129.0033),
                model = "insurgent",
                properties = {
                    plate = "GRM",
                    color1 = {0, 0, 0}
                },
                passengers = {
                    { model = "s_m_y_blackops_02", seat = -1 },
                    { model = "s_m_y_blackops_02", seat = 4 },
                    { model = "s_m_y_blackops_02", seat = 5 },
                    { model = "s_m_y_blackops_02", seat = 6 },
                }
            },
            {
                coords = vec4(580.1200, -770.3291, 19.2318, 351.9702),
                rotation = vec3(-16.0, -30.0, 20.0),
                model = "lazer",
                properties = {
                    color1 = {0, 0, 0}
                },
                passengers = {
                    { model = "s_m_m_movspace_01", seat = -1 },
                }
            },
            {
                coords = vec4(565.1200, -770.3291, 19.2318, 351.9702),
                rotation = vec3(0.0, 0.0, -90.0),
                model = "cargobob2",
                properties = {
                    color1 = {255, 255, 255}
                },
                passengers = {
                    { model = "s_m_m_movspace_01", seat = -1 },
                }
            },
            {
                coords = vec4(563.5200, -754.3291, 11.2318, 351.9702),
                rotation = vec3(0.0, 0.0, -10.0),
                model = "rhino",
                properties = {
                    color1 = {0, 0, 0}
                },
                passengers = {
                    { model = "s_m_m_movspace_01", seat = -1 },
                }
            },
        },
        peds = {
            { 
                coords = vec4(570.0955, -748.8397, 10.8230, 35.8224), 
                model = "s_m_y_blackops_02", 
                weapon = "WEAPON_CARBINERIFLE",
            },
        },
        offsets = vec3(0.5, 1.5, 0.29),
        fov = 55.0,
        hours = 13,
        coords = vec4(565.7594, -743.9868, 11.9, 22.3051)  
    },
    { 
        anims = {
            ["f"] = {
                {
                    dict = "rcmfanatic1maryann_stretchidle_b",
                    clip = "idle_e"
                },
                {
                    dict = "mini@triathlon",
                    clip = "idle_e"
                }
            },
            ["m"] = {
                {
                    dict = "amb@world_human_muscle_flex@arms_in_front@idle_a",
                    clip = "idle_b"
                },
                {
                    dict = "mini@triathlon",
                    clip = "idle_d"
                }
            }
        },
        offsets = vec3(0.5, 1.5, 0.29),
        fov = 55.0,
        coords = vec4(-1203.4027, -1569.4591, 4.6080, 193.667)     
    }
}