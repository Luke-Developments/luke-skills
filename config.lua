--- LUKE DEVELOPMENTS -- LUKE-SKILLS
--- 
Config  = Config or {}
-- BASE OPTIONS

Config.UpdateFrequency = 300 -- The update frequency in seconds between changing values to the database recommeneded is 300 however you can increase it to reduce hitch time if becoming a problem
Config.Notify = 'okok' -- Notification type can be 'qb', 'okok', 'ox', 'brutal', or 'wasabi'
Config.Notifications = true -- Display notificaions when a skills is added/removed (set to false to disable)
Config.BasicSkill = false -- Set to true to enable driving, stamina etc


-- SKILL MENU OPTIONS
Config.Title = "Luke Skills"
Config.XPMenuLocation = 'top-left' -- Change the position of your XP menu ('top-left' or 'top-right' or 'bottom-left' or 'bottom-right')
Config.Command = true --  Set to "false" to disable the "/skill" command 
Config.Skillmenu = "skill" -- the command to open the skill menu (check readme.md to see how to add to the radial menu)
Config.OxMenu = true -- Uses qb-menu or ox_lib
Config.MaxLevel = 100
Config.SkillLevelXPRate = 'standard' -- 'standard' (100*level*2), 'double' (100*level*4), 'gtao' (Gta Levels), 'custom' (set in Config.CustomXPRate)
Config.CustomXPRate = 1000 -- Amount each level requires as a base eg. if 1000 then level 1 = 1000, 2 = 2000 




-- TARGET OPTIONS 
-- If you want the player to hed to a ped/location to check their skills
Config.EnableTarget = false -- Set to true  if you would like to use a target for players to check their skills
Config.Target = 'ox' -- Can be 'ox' for ox_target, 'qtarget', 'qb-target', or 'textui'
Config.TargetLocation = vector3(0, 0, 0)  -- Default is at City Central
Config.EnablePed = false -- set to true if you want their to be a ped
Config.TargetPed = `a_m_y_smartcaspat_01` -- Set to anything in https://docs.fivem.net/docs/game-references/ped-models/
Config.Scenario = 'WORLD_HUMAN_CLIPBOARD' -- Set to anything in https://github.com/DioneB/gtav-scenarios
Config.Heading = 90

------------------------------------------------------------------------------------------------------
---ROLEPLAY SKILLS -- YOU  CAN ADD MORE USING THE FORMAT BELOW -- COMMENT OUT TO DISABLE THE SKILL ---
------------------------------------------------------------------------------------------------------

Config.LukeSkills = {

    ["Searching"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = 'BINDIVE_ABILITY',
        ['Icon'] = 'fas fa-trash'
    },
    ["Hacking"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "HACK_ABILITY",
        ['icon'] = 'fas fa-laptop-code',
    },
    ["Heist Reputation"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "HEIST_ABILITY",
        ['icon'] = 'fa-solid fa-user-secret',
    },
    ["Scraping"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "SCRAP_ABILITY",
        ['icon'] = 'fas fa-screwdriver', 
    },
    ["Street Reputation"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "DRUGREP_ABILITY",
        ['icon'] = 'fas fa-cannabis',
    },
    ["Metal Detecting"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "HUNTING_ABILITY",
        ['icon'] = 'fas fa-paw',
    },
    ["Drug Manufacture"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "DRUGMAKE_ABILITY",
        ['icon'] = 'fas fa-pills',
    }, 
    ["Delivery Runner"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "RUNNER_ABILITY",
        ['icon'] = 'fas fa-car',
    },
    ["Hitman"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "HITMAN_ABILITY",
        ['icon'] = 'fas fa-skull',
    },
    ["Sprint Driving"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "DRIVER_ABILITY",
        ['icon'] = 'fas fa-car-alt',
    }, 
    ["Lumberjack"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "TREE_ABILITY",
        ['icon'] = 'fas fa-tree',
    },
    ["Diving"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "DIVING_ABILITY",
        ['icon'] = 'fas fa-water',
    },
    ["Electrical"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "ELECTRICAL_ABILITY",
        ['icon'] = 'fas fa-bolt',
    },
    ["Hunting"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "HUNTING_ABILITY",
        ['icon'] = 'fas fa-paw',
    },
    ["Fishing"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "FISHING_ABILITY",
        ['icon'] = 'fas fa-fish',
    }, 
    ["Windfarms"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "WINDFARMS_ABILITY",
        ['icon'] = 'fas fa-wind',
    },
    ["Farming"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "FARMING_ABILITY",
        ['icon'] = 'fas fa-wheat',
    },
    ["Mining"] = {
        ["Current"] = 0,
        ["Depreciation"] = 0,
        ["DepreciationRate"] = nil,
        ["Stat"] = "MINING_ABILITY",
        ['icon'] = 'fas fa-pickaxe',
    }
}


