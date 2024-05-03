---@diagnostic disable: trailing-space
if Config.Framework == 'qbcore' then
    local QBCore = exports['qb-core']:GetCoreObject()
end
if Config.Framework == 'esx' then
    ESX = nil

    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
            PlayerData = ESX.GetPlayerData()
        end
    end)
end

local loopType = nil
local opened = false
local PreviousComponent = {}
local PreviousTexture = {}
local PreviousTorso = {}

TriggerEvent('chat:addSuggestion', '/record', 'Recording options', {
    { name = "type", help = "start/stop/discard" }
})

TriggerEvent('chat:addSuggestion', '/picture', 'Take a picture')
TriggerEvent('chat:addSuggestion', '/rockstareditor', 'Opens rockstar editor')

RegisterCommand('record', function(source, args, rawCommand)
	local type = args[1]
	if type == 'start' then StartRecording(1) end
	if type == 'stop' then StopRecordingAndSaveClip() end
	if type == 'discard' then StopRecordingAndDiscardClip() end
end)

RegisterCommand('rockstareditor', function()
	ActivateRockstarEditor()
end)

RegisterCommand('picture', function()
	BeginTakeHighQualityPhoto()
	SaveHighQualityPhoto(-1)
	FreeMemoryForHighQualityPhoto()
end)

RegisterKeyMapping('record start', '(Rockstar editor) Start Recording', 'keyboard', '')
RegisterKeyMapping('record stop', '(Rockstar editor) Stop Recording', 'keyboard', '')
RegisterKeyMapping('record discard', '(Rockstar editor) Discard Recording', 'keyboard', '')
RegisterKeyMapping('picture', '(Rockstar editor) Take a Picture', 'keyboard', '')


-- Main Loop

-- // Distance rendering and entity handler (need a revision)
CreateThread(function()
    while true do
        if loopType == "ulow" then
            --// Find closest ped and set the alpha
            for ped in GetWorldPeds() do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                SetPedAoBlobRendering(ped, false)
                Wait(1)
            end
            --// Find closest object and set the alpha
            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(obj) ~= 170 then
                        SetEntityAlpha(obj, 170)
                    end
                end
                Wait(1)
            end
            DisableOcclusionThisFrame()
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
        elseif loopType == "low" then
            --// Find closest ped and set the alpha
            for ped in GetWorldPeds() do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                SetPedAoBlobRendering(ped, false)
                Wait(1)
            end
            --// Find closest object and set the alpha
            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                Wait(1)
            end
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
        elseif loopType == "medium" then
            --// Find closest ped and set the alpha
            for ped in GetWorldPeds() do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    end
                end
                SetPedAoBlobRendering(ped, false)
                Wait(1)
            end
            --// Find closest object and set the alpha
            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    end
                end
                Wait(1)
            end
        else
            Wait(500)
        end
        Wait(8)
    end
end)

--// Clear broken thing, disable rain, disable wind and other tiny thing that dont require the frame tick
CreateThread(function()
    while true do
        if loopType == "ulow" or loopType == "low" then
            local ped = PlayerPedId()
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearPedBloodDamage(ped)
            ClearPedWetness(ped)
            ClearPedEnvDirt(ped)
            ResetPedVisibleDamage(ped)
            ClearExtraTimecycleModifier()
            ClearTimecycleModifier()
            ClearOverrideWeather()
            ClearHdArea()
            DisableVehicleDistantlights(false)
            DisableScreenblurFade()
            SetRainLevel(0.0)
            SetWindSpeed(0.0)
            Wait(300)
        elseif loopType == "medium" then
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            SetWindSpeed(0.0)
            Wait(1000)
        else
            Wait(1500)
        end
    end
end)


-- NUI


RegisterCommand(Config.Command, function()
    if not opened then
        opened = true
        SendNUIMessage({
            action = 'show'
        })

        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)

        StartLoopControls()
    end
end, false)


function StartLoopControls()
    CreateThread(function()
        while opened do
            Wait(0)

            DisableControlAction(0, 1, true) -- disable mouse look
            DisableControlAction(0, 2, true) -- disable mouse look
            DisableControlAction(0, 3, true) -- disable mouse look
            DisableControlAction(0, 4, true) -- disable mouse look
            DisableControlAction(0, 5, true) -- disable mouse look
            DisableControlAction(0, 6, true) -- disable mouse look
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 177, true) -- disable escape
            DisableControlAction(0, 200, true) -- disable escape
            DisableControlAction(0, 202, true) -- disable escape
            DisableControlAction(0, 322, true) -- disable escape
            DisableControlAction(0, 245, true) -- disable chat
            DisableControlAction(0, 37, true) -- disable TAB
            DisableControlAction(0, 261, true) -- disable mouse wheel
            DisableControlAction(0, 262, true) -- disable mouse wheel
            HideHudComponentThisFrame(19)
            DisablePlayerFiring(PlayerId(), true) -- disable weapon firing
        end
    end)
end

RegisterNUICallback('select', function(data)
    local playerPed = PlayerPedId()
    local item = data.item

    if PreviousComponent[item] == nil then
        if Config.Notify == "origen" then
            if item == 'grabar' then
                ExecuteCommand('record start')
                exports[Config.OrigenNotification]:ShowOrigenNotification("Se empezó una grabación.", "success") 
            elseif item == 'parar' then
                ExecuteCommand('record stop')
                exports[Config.OrigenNotification]:ShowOrigenNotification("Se acabó una grabación.", "success") 
            elseif item == 'borrar' then
                exports[Config.OrigenNotification]:ShowOrigenNotification("Se borró la última grabación en progreso.", "success") 
                ExecuteCommand('record discard')
            elseif item == 'foto' then
                exports[Config.OrigenNotification]:ShowOrigenNotification("Se realizó una fotografía.", "success") 
                ExecuteCommand('picture')
            elseif item == 'menu' then
                exports[Config.OrigenNotification]:ShowOrigenNotification("Se abrió el menú de Rockstar Editor.", "success") 
                ExecuteCommand('rockstareditor')
            end
        end
        if Config.Notify == "default" and Config.Framework == "qbcore" then
            if item == 'grabar' then
                ExecuteCommand('record start')
                --exports[Config.OrigenNotification]:ShowOrigenNotification("Se empezó una grabación.", "success") 
                QBCore.Functions.Notify("Se empezó una grabación.", success)
            elseif item == 'parar' then
                ExecuteCommand('record stop')
                --exports[Config.OrigenNotification]:ShowOrigenNotification("Se acabó una grabación.", "success") 
                QBCore.Functions.Notify("Se acabó una grabación.", success)
            elseif item == 'borrar' then
                --exports[Config.OrigenNotification]:ShowOrigenNotification("Se borró la última grabación en progreso.", "success") 
                QBCore.Functions.Notify("Se borró la última grabación en progreso.", success)
                ExecuteCommand('record discard')
            elseif item == 'foto' then
                --exports[Config.OrigenNotification]:ShowOrigenNotification("Se realizó una fotografía.", "success") 
                QBCore.Functions.Notify("Se realizó una fotografía.", success)
                ExecuteCommand('picture')
            elseif item == 'menu' then
                --exports[Config.OrigenNotification]:ShowOrigenNotification("Se abrió el menú de Rockstar Editor.", "success") 
                QBCore.Functions.Notify("Se abrió el menú de Rockstar Editor.", success)
                ExecuteCommand('rockstareditor')
            end
        end
        if Config.Notify == "default" and Config.Framework == "esx" then
            if item == 'grabar' then
                ExecuteCommand('record start')
                ESX.ShowNotification("Se empezó una grabación.")
            elseif item == 'parar' then
                ExecuteCommand('record stop')
                ESX.ShowNotification("Se acabó una grabación.")
            elseif item == 'borrar' then
                ESX.ShowNotification("Se borró la última grabación en progreso.")
                ExecuteCommand('record discard')
            elseif item == 'foto' then
                ESX.ShowNotification("Se realizó una fotografía.")
                ExecuteCommand('picture')
            elseif item == 'menu' then
                ESX.ShowNotification("Se abrió el menú de Rockstar Editor.")
                ExecuteCommand('rockstareditor')
            end
        end
        if Config.Framework == "standalone" then
            if item == 'grabar' then
                ExecuteCommand('record start')
                Framework.ShowNotification("Se empezó una grabación.")
            elseif item == 'parar' then
                ExecuteCommand('record stop')
                Framework.ShowNotification("Se acabó una grabación.")
            elseif item == 'borrar' then
                Framework.ShowNotification("Se borró la última grabación en progreso.")
                ExecuteCommand('record discard')
            elseif item == 'foto' then
                Framework.ShowNotification("Se realizó una fotografía.")
                ExecuteCommand('picture')
            elseif item == 'menu' then
                Framework.ShowNotification("Se abrió el menú de Rockstar Editor.")
                ExecuteCommand('rockstareditor')
            end
        end
    end
end)

--RegisterKeyMapping('fpsmenu', 'FPS MENU', 'keyboard', 'U')
RegisterKeyMapping(Config.Command, 'ROCKSTAR EDITOR MENU', 'keyboard', Config.KeyToOpen)

RegisterNUICallback('close', function()
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)
    opened = false
end)
