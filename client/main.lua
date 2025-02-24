local QBCore = exports['qb-core']:GetCoreObject()

-------------------------------------------------------------
-- Utility Functions
-------------------------------------------------------------
function round(num)
    return math.floor(num + 0.5)
end

function round1(num)
    return math.floor(num + 1)
end

-- Make math.round available for menu calculations
math.round = round

-------------------------------------------------------------
-- Notification & MessageBox Functions
-------------------------------------------------------------
local function MessageBox(text, alpha)
    if alpha > 255 then
        alpha = 255
    elseif alpha < 0 then
        alpha = 0
    end
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, math.floor(alpha))
    SetTextEdge(2, 0, 0, 0, math.floor(alpha))
    SetTextDropShadow()
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextScale(0.31, 0.31)
    AddTextComponentString(text)
    local factor = (string.len(text)) / 350
    local x = 0.015
    local y = 0.5
    local width = 0.05 
    local height = 0.025
    DrawText(x + (width / 2.0), y + (height / 2.0) - 0.01)
    DrawRect(x + (width / 2.0), y + (height / 2.0), width, height, 25, 25, 25, math.floor(alpha))
end

local function Notification(message)
    local alpha = 185
    for time = 1, 250 do
        Citizen.Wait(1)
        if time >= 150 then
            alpha = alpha - 2
            if alpha <= 0 then
                alpha = 0
            end
        end
        MessageBox(message, alpha)
    end
end

-------------------------------------------------------------
-- Skill Management Functions
-------------------------------------------------------------
local function RefreshSkills()
    for skill, value in pairs(Config.LukeSkills) do
        if Config.Debug then
            print(skill .. ": " .. value['Current'])
        elseif Config.Debug and not Config.LukeSkills[skill] then
            print("something went wrong")
        end
        if value["Stat"] then
            StatSetInt(value["Stat"], round(value["Current"]), true)
        end
    end
end

FetchSkills = function()
    QBCore.Functions.TriggerCallback("skillsystem:fetchStatus", function(data)
        if data then
            for status, value in pairs(data) do
                if Config.LukeSkills[status] then
                    Config.LukeSkills[status]["Current"] = value["Current"]
                else
                    print("Removing: " .. status)
                end
            end
        end
        RefreshSkills()
    end)
end

GetCurrentSkill = function(skill)
    return Config.LukeSkills[skill]
end


exports('CheckSkill', function(skill, val, hasskill)
    if Config.LukeSkills[skill] then
        if Config.LukeSkills[skill]["Current"] >= tonumber(val) then
            hasskill(true)
        else
            hasskill(false)
        end
    else
        print("Skill " .. skill .. " doesn't exist")
        hasskill(false)
    end
end)


AddSkill = function(skill, amount)
    if not Config.LukeSkills[skill] then
        print("Skill " .. skill .. " does not exist")
        return
    end
    local SkillAmount = Config.LukeSkills[skill]["Current"]
    if SkillAmount + tonumber(amount) < 0 then
        Config.LukeSkills[skill]["Current"] = 0
    elseif SkillAmount + tonumber(amount) > 2500000 then
        Config.LukeSkills[skill]["Current"] = 2500000
    else
        Config.LukeSkills[skill]["Current"] = SkillAmount + tonumber(amount)
    end
    RefreshSkills()
    if Config.Notifications and tonumber(amount) > 0 then
        if Config.Notify == "3d" then
            Notification("~g~+" .. amount .. " XP to ~s~" .. skill)
        elseif Config.Notify == "qb" then
            QBCore.Functions.Notify("+" .. amount .. " XP to " .. skill, "success", 3500)
        elseif Config.Notify == "okok" then
            exports['okokNotify']:Alert("SKILL GAINED", "+" .. amount .. " XP to " .. skill, 3500, 'info')
        elseif Config.Notify == "ox" then
            exports.ox_lib:notify({
                description = "+" .. amount .. " XP to " .. skill,
                type = "success",
                duration = 3500
            })
        elseif Config.Notify == "brutal" then
            exports.brutal_notify:Notify("+" .. amount .. " XP to " .. skill, "success", 3500)
        elseif Config.Notify == "wasabi" then
            exports.wasabi_notify:Notify("+" .. amount .. " XP to " .. skill, "success", 3500)
        end
    end    
    TriggerServerEvent("skillsystem:update", json.encode(Config.LukeSkills))
end

-------------------------------------------------------------
-- Menu Functions for Displaying Skills
-------------------------------------------------------------
local function getSkillLevel(xp)
    if Config.SkillLevelXPRate == "gtao" then
        local level = 1
        local minXP = 0
        local nextXP = 1000  -- Level 2 threshold
        while xp >= nextXP and level < 100 do
            level = level + 1
            minXP = nextXP
            nextXP = minXP + (900 + 100 * level)
        end
        return level, minXP, nextXP
    else
        local multiplier = 2  -- default for "standard"
        if Config.SkillLevelXPRate == "double" then
            multiplier = 4
        end

        for i = 1, 100 do
            local minXP, maxXP
            if Config.SkillLevelXPRate == "custom" then
                -- Assume Config.CustomXPRate is a function that takes a level (or level index)
                minXP = Config.CustomXPRate(i - 1)
                maxXP = Config.CustomXPRate(i)
            else
                minXP = 100 * (i - 1) * multiplier
                maxXP = 100 * i * multiplier
            end

            if xp >= minXP and xp < maxXP then
                return i, minXP, maxXP
            end
        end

        -- If XP exceeds level 100, return level 100 thresholds.
        if Config.SkillLevelXPRate == "custom" then
            return 100, Config.CustomXPRate(99), Config.CustomXPRate(100)
        else
            return 100, 100 * 99 * multiplier, 100 * 100 * multiplier
        end
    end
end


local function getSkillLevelDescription(level)
    local descriptions = {
        'Unskilled', 'Beginner', 'Amateur', 'Intermediate', 'Competent',
        'Skilled', 'Adept', 'Master', 'Proficient', 'Experienced',
        'Advanced Beginner', 'Rising Star', 'Novice', 'Intermediate Master', 'Veteran',
        'Practiced', 'Proficient Novice', 'Apprentice', 'Expert', 'Polished',
        'Advanced Competent', 'Refined', 'Seasoned', 'Elite', 'Skilled Artisan',
        'Proven', 'Skilled Veteran', 'Distinguished', 'Honored', 'Mastered',
        'Grandmaster', 'Legendary', 'Proficient Master', 'Adept Veteran', 'Mature',
        'Skillful', 'Commanding', 'Top-tier', 'Connoisseur', 'Exemplary',
        'Professional', 'Accomplished', 'Artisan', 'Veteran Pro', 'Master Artisan',
        'Virtuoso', 'Savant', 'Pioneer', 'Trailblazer', 'Champion',
        'Leader', 'Pathfinder', 'Peak Performer', 'Pillar', 'Superior',
        'Legend', 'Mastermind', 'Strategist', 'Sage', 'Elite Professional',
        'High-tier', 'Distinguished Master', 'Titan', 'Phenomenal', 'Luminary',
        'Paragon', 'Prodigy', 'Magister', 'Champion Master', 'Iconic',
        'Colossus', 'Ruler', 'Glorious', 'Sovereign', 'Exalted',
        'Visionary', 'Epic', 'Supreme', 'Noble', 'Herculean',
        'Apex', 'Unrivaled', 'Undisputed', 'Prestigious', 'Maverick',
        'Invincible', 'Infallible', 'Unmatched', 'All-Star', 'Immortal',
        'Champion of Champions', 'Mythic', 'Godlike', 'Incomparable', 'Peerless',
        'Invincible Master', 'Divine', 'Omnipotent', 'Transcendent', 'Ultimate Pro'
    }
    return descriptions[level] or 'Unknown'
end

local function createSkillMenu()
    local skillMenu = {}
    skillMenu[#skillMenu + 1] = {
        isHeader = true,
        header = 'Skills',
        isMenuHeader = true,
        icon = 'fas fa-chart-simple'
    }

    for k, v in pairs(Config.LukeSkills) do
        local xp = v['Current']
        local level, minXP, maxXP = getSkillLevel(xp)
        local skillLevelText = 'Level ' .. level .. ' (' .. getSkillLevelDescription(level) .. ')'
        
        skillMenu[#skillMenu + 1] = {
            header = k,
            txt = '( ' .. skillLevelText .. ' ) Total XP ( ' .. round1(v['Current']) .. ' )',
            icon = v['icon'],
            params = {
                args = { v }
            }
        }
    end

    exports['qb-menu']:openMenu(skillMenu)
end

local function createSkillMenuOX()
    local sortedSkills = {}
    for k, v in pairs(Config.LukeSkills) do
        v.name = k
        table.insert(sortedSkills, v)
    end
    table.sort(sortedSkills, function(a, b)
        return a.Current < b.Current
    end)

    local options = {}
    for _, v in ipairs(sortedSkills) do
        local level, minXP, maxXP = getSkillLevel(v['Current'])
        local skillLevelText = 'Level ' .. level .. ' - XP: ' .. math.round(v['Current'])
        
        options[#options + 1] = {
            label = v.name .. ' (' .. skillLevelText .. ')',
            description = '( ' .. skillLevelText .. ' ) Total XP ( ' .. math.round(v['Current']) .. ' )',
            icon = v['icon'],
            args = { v },
            progress = math.floor((v['Current'] - minXP) / (maxXP - minXP) * 100),
            colorScheme = Config.XPBarColour,
        }
    end

    lib.registerMenu({
        id = 'skill_menu',
        title = Config.Title,
        position = Config.XPMenuLocation,
        options = options
    }, function(selected)
        print('Selected: ' .. selected)
    end)

    lib.showMenu('skill_menu')
end

for skill, value in pairs(Config.LukeSkills) do
    if value.DepreciationRate ~= nil then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(value.DepreciationRate * 1000) -- Wait for the specified interval in milliseconds
                AddSkill(skill, -value.Depreciation)         -- Reduce the skill by the depreciation amount
            end
        end)
    end
end

-------------------------------------------------------------
-- Command & Event for Skill Menu
-------------------------------------------------------------
RegisterCommand(Config.Skillmenu, function()
    if Config.Command and Config.OxMenu then
        createSkillMenuOX()
    elseif Config.Command then
        createSkillMenu()
    else 
        Wait(10)
    end
end)
        
RegisterNetEvent("luke-skills:client:CheckSkills", function()
    if Config.OxMenu then
        createSkillMenuOX()
    elseif not Config.Command then
        createSkillMenu()
    else 
        Wait(10)
    end
end)


-------------------------------------------------------------
-- Event Handlers for Player Load/Unload and Resource Start
-------------------------------------------------------------
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Citizen.CreateThread(function()
        FetchSkills()
        while true do
            local seconds = Config.UpdateFrequency * 1000
            Citizen.Wait(seconds)
            for skill, value in pairs(Config.LukeSkills) do
                AddSkill(skill, value["Depreciation"])
            end
            TriggerServerEvent("skillsystem:update", json.encode(Config.LukeSkills))
        end
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        for skill, value in pairs(Config.LukeSkills) do
            Config.LukeSkills[skill]["Current"] = 0
        end
    end)

    if Config.BasicSkill then
        Citizen.CreateThread(function() 
            while true do
                Citizen.Wait(25000)
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsUsing(ped)
                local isDead = QBCore.Functions.GetPlayerData().metadata["isdead"]
                local islaststand = QBCore.Functions.GetPlayerData().metadata["islaststand"]
                if Config.B1Natives then 
                    if LocalPlayer.state.isLoggedIn and not isDead and not islaststand then
                        if IsPedRunning(ped) then
                            AddSkill("Stamina", 0.1)
                        elseif IsPedInMeleeCombat(ped) then
                            local isTargetting, targetEntity = GetPlayerTargetEntity(PlayerId())
                            if isTargetting and not IsEntityDead(targetEntity) and GetMeleeTargetForPed(ped) ~= 0 then
                                AddSkill("Strength", 0.2)
                            end
                        elseif IsPedSwimmingUnderWater(ped) then
                            AddSkill("Lung Capacity", 0.5)
                        elseif IsPedShooting(ped) then
                            AddSkill("Shooting", 0.1)
                        elseif DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped then
                            local speed = GetEntitySpeed(vehicle) * 3.6
                            if (GetVehicleClass(vehicle) == 8 or GetVehicleClass(vehicle) == 13) and speed >= 5 then
                                local rotation = GetEntityRotation(vehicle)
                                if IsControlPressed(0, 210) then
                                    if rotation.x >= 25.0 then
                                        AddSkill("Wheelie", 0.2)
                                    end 
                                end
                            end
                            if speed >= 80 then
                                AddSkill("Driving", 0.1)
                            end
                        end
                    end
                end 
            end
        end)
    end
end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
      Wait(100)
      FetchSkills()
   end
end)

-------------------------------------------------------------
-- PED Spawning and menu
-------------------------------------------------------------
if Config.EnableTarget then 
    function DrawText3D(x, y, z, text)
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end

    local skillPed = nil

    local function spawnSkillPed()
        if not Config.EnablePed then return end
        local model = GetHashKey(Config.TargetPed)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
        skillPed = CreatePed(4, model, Config.TargetLocation.x, Config.TargetLocation.y, Config.TargetLocation.z, Config.Heading, false, true)
        SetBlockingOfNonTemporaryEvents(skillPed, true)
        SetPedFleeAttributes(skillPed, 0, 0)
        TaskStartScenarioInPlace(skillPed, Config.Scenario, 0, true)
        SetEntityInvincible(skillPed, true)
    end

    local function registerSkillPedTarget()
        if not Config.EnableTarget or not skillPed then return end

        if Config.Target == 'ox' then
            exports.ox_target:addEntityZone(skillPed, {
                name = "skill_ped",
                debugPoly = false,
                useZ = true,
                options = {
                {
                    name = "open_skill_menu",
                    icon = "fas fa-chart-simple",
                    label = "Check Skills",
                    action = function(entity)
                        if Config.OxMenu then
                        createSkillMenuOX()
                    else
                        createSkillMenu()
                    end
                    end
                }
                },
                distance = 2.5
            })
        elseif Config.Target == 'qtarget' then
            exports.qtarget:AddTargetEntity(skillPed, {
                options = {
                {
                    icon = "fas fa-chart-simple",
                    label = "Check Skills",
                    action = function(entity)
                    if Config.OxMenu then
                        createSkillMenuOX()
                    else
                        createSkillMenu()
                        end
                    end,
                }
                },
                distance = 2.5
            })
        elseif Config.Target == 'qb-target' then
            exports['qb-target']:AddTargetEntity(skillPed, {
                options = {
                {
                    icon = "fas fa-chart-simple",
                    label = "Check Skills",
                    action = function(entity)
                    if Config.OxMenu then
                        createSkillMenuOX()
                    else
                        createSkillMenu()
                    end
                    end,
                }
                },
                distance = 2.5
            })
        elseif Config.Target == 'textui' then
            Citizen.CreateThread(function()
                while true do
                    Citizen.Wait(0)
                    local pedCoords = GetEntityCoords(skillPed)
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local distance = #(playerCoords - pedCoords)
                    if distance < 2.5 then
                        DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, "Press [E] to check skills")
                        if IsControlJustReleased(0, 38) then -- E key
                            if Config.OxMenu then
                                createSkillMenuOX()
                            else
                                createSkillMenu()
                            end
                        end
                    end
                end
            end)
        end
    end

    AddEventHandler('onResourceStart', function(resource)
        if resource == GetCurrentResourceName() then
            if Config.EnablePed then
                spawnSkillPed()
                Citizen.Wait(500)  -- Wait briefly to ensure the ped is spawned
                if Config.EnableTarget then
                    registerSkillPedTarget()
                end
            end
        end
    end)
end
