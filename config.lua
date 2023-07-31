Config = {}
Config.Client = {}
Config.Server = {}


Config.Client.ScreenFadeOnChange = true       --   Do a screen fade animation when the user joins another sector
Config.Client.OpenCooldown = 0                 --   The user can't reopen the sector menu for this many miliseconds





Config.Server.ServerSectors = {
    --[[
        SectorId = Identifier for the sector - KEEP IT UNIQUE
        DisplayName = The name that will show in the sector menu
        PlayerLimit = Maximum player limit, set it to -1 for unlimited
        BucketId = The bucketId to use (maximum 64)
        EnableNpcs = Defines whether NPCs should spawn
        EnablePvP = Defines whether player PvP should be enabled
    ]]


    {SectorId = "lobby",  DisplayName="Lobby",                       PlayerLimit=-1,   BucketId=2,   EnableNpcs=false,    EnablePvP=false},
    {SectorId = "test",   DisplayName="Test",                        PlayerLimit=16,   BucketId=3,   EnableNpcs=true,     EnablePvP=true},
    {SectorId = "full",   DisplayName="Full Server Presentation",    PlayerLimit=0,   BucketId=4,   EnableNpcs=true,     EnablePvP=true}
}

-- This is where the players will go by default after joining the server
Config.Server.StarterSector = "lobby"
