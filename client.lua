local FirstSpawnDetected = false 
local SectorData = {}
local CanOpen = true

-- Command handler function
function OpenUI()
    if CanOpen then
        NUISwitch(true)
    end
end

local allowedToUse = false
Citizen.CreateThread(function()
    TriggerServerEvent("sectors.getIsAllowed")
end)

RegisterNetEvent("sectors.returnIsAllowed")
AddEventHandler("sectors.returnIsAllowed", function(isAllowed)
    allowedToUse = isAllowed
end)

-- Register the command "/sectors" to open the UI
RegisterCommand("sectors", function()
    if allowedToUse then
        OpenUI()
    end
end)

function NUISwitch(b)
    SendNUIMessage({
        show = b
    })
    SetNuiFocus(b, b)

    if not b then
        CanOpen = false
        Citizen.CreateThread(function()
            Wait(Config.Client.OpenCooldown)
            CanOpen = true
        end)
    end
end


-- NET EVENTS --
AddEventHandler("playerSpawned",function()
    if not FirstSpawnDetected then 
        FirstSpawnDetected = true 
        TriggerServerEvent("server_sectors:moveToSector",-1)
    end
end)

RegisterNetEvent("server_sector:updateData",function(newData)
    SectorData = newData
    SendNUIMessage({
        loadUi = SectorData,
        selfName = GetPlayerName(PlayerId())
    })
end)

RegisterNetEvent("###core:server_sector:changedSector",function(newSector, pvp)
    NetworkSetFriendlyFireOption(pvp)
    SetCanAttackFriendly(PlayerPedId(), pvp, pvp)

    if Config.Client.ScreenFadeOnChange then 
        DoScreenFadeOut(150)
        while not IsScreenFadedOut() do Wait(0) end 
        TriggerEvent("server_sector:changedSector",newSector)
        Wait(1200)
        DoScreenFadeIn(150)
    elseif not Config.Client.ScreenFadeOnChange then
        TriggerEvent("server_sector:changedSector",newSector)
    end
end)    

-- NUI CALLBACKS --
RegisterNUICallback("search",function(data,cb)
    local returning = nil 
    
    for _, subData in pairs(SectorData) do 
        for __, playerName in pairs(subData.PlayerNames) do 
            if playerName == data.input then 
                returning = subData.Id
            end
        end
        for __, playerId in pairs(subData.PlayerIds) do 
            if playerId == data.input then 
                returning = subData.Id
            end
        end
    end

    cb(returning)
end)

RegisterNUICallback("close",function(data,cb)
    NUISwitch(false)
    cb("ok")
end)

RegisterNUICallback("changedSector",function(data,cb)
    TriggerServerEvent("server_sectors:moveToSector",data.id)
    NUISwitch(false)
    cb("ok")
end)
