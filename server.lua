RegisterServerEvent("sectors.getIsAllowed")
AddEventHandler("sectors.getIsAllowed", function()
local isAllowed = IsPlayerAceAllowed(source, "command.sectors")
TriggerClientEvent("sectors.returnIsAllowed", source, isAllowed )
end)

AddEventHandler("playerDropped",function()
    UpdateSectorData()
end)

RegisterNetEvent("server_sectors:moveToSector",function(sectorName)
    local source = source
    local sourceName = GetPlayerName(source)

    if sectorName == -1 then 
        sectorName = Config.Server.StarterSector
    end
    local sectorData = GetSectorById(sectorName)

    if sectorData ~= nil then 
        TriggerClientEvent("###core:server_sector:changedSector",source,sectorName, sectorData.EnablePvP)
        Wait(150)
        SetPlayerRoutingBucket(source,sectorData.BucketId)
        SetRoutingBucketPopulationEnabled(sectorData.BucketId, sectorData.EnableNpcs)

        UpdateSectorData()
    end
end)

function GetSectorById(id)
    for _,data in pairs(Config.Server.ServerSectors) do 
        if data.SectorId == id then 
            return data 
        end
    end 
    return nil
end

function UpdateSectorData()
    local PlayerNames = {}
    local PlayerIds = {}
    for _, playerId in ipairs(GetPlayers()) do
        local playerBucket = GetPlayerRoutingBucket(playerId)
        local playerName = GetPlayerName(playerId)

        if PlayerNames[playerBucket] == nil then 
            PlayerNames[playerBucket] = {}
        end
        if PlayerIds[playerBucket] == nil then 
            PlayerIds[playerBucket] = {}
        end

        table.insert(PlayerNames[playerBucket],playerName)
        table.insert(PlayerIds[playerBucket],playerId)
    end

    local SendingData = {}
    for _,data in ipairs(Config.Server.ServerSectors) do 
        table.insert(SendingData,
        {
            Id = data.SectorId,
            Name = data.DisplayName,
            MaxPlayer = data.PlayerLimit,
            PlayerNames = PlayerNames[data.BucketId] or {},
            PlayerIds = PlayerIds[data.BucketId] or {}
        })
    end 

    TriggerClientEvent("server_sector:updateData",-1,SendingData)
end
