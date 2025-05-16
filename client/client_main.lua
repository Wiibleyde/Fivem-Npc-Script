-- Local variables to improve performance
local pedList = {}
local playerPed = nil
local playerCoords = nil
local checkFrequency = 500 -- milliseconds between each check

-- Initialize the NPC list with additional tracking information
Citizen.CreateThread(function()
    for k, v in pairs(Config.PedList) do
        pedList[k] = v
        pedList[k].isRendered = false       -- Tracks if the NPC is currently spawned in the world
        pedList[k].ped = nil                -- Will store the ped entity when spawned
        pedList[k].checkTime = 0            -- Used for progressive distance checking to reduce script load
    end
end)

-- Main optimization thread: handles NPC spawning and despawning based on player distance
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(checkFrequency)
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        
        local currentTime = GetGameTimer()
        for k = 1, #pedList do
            local v = pedList[k]
            
            -- Progressive distance checking system to reduce CPU usage
            -- Only checks NPCs when their individual timer has expired
            if currentTime >= v.checkTime then
                local dist = #(playerCoords - v.coords)
                
                -- Adjust check frequency dynamically based on distance
                -- Closer NPCs are checked more frequently for a responsive experience
                if dist < Config.Distance then
                    v.checkTime = currentTime + 250  -- Check every 250ms when player is close
                elseif dist < Config.Distance * 2 then
                    v.checkTime = currentTime + 500  -- Check every 500ms when at medium distance
                else
                    v.checkTime = currentTime + 1000 -- Check every 1000ms when far away
                end
                
                -- Preload models when player approaches to reduce pop-in effect
                -- This starts loading the model before the player gets close enough for spawn
                if dist < Config.Distance * 1.5 and not v.isRendered and not v.isLoading then
                    v.isLoading = true
                    Citizen.CreateThread(function()
                        local modelHash = GetHashKey(v.model)
                        RequestModel(modelHash)  -- Start loading the model
                        if v.animDict then
                            RequestAnimDict(v.animDict)  -- Also preload any animations
                        end
                    end)
                end
                
                -- Spawn logic: Create the NPC when player is within spawn distance
                if dist < Config.Distance and not v.isRendered then
                    local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
                    v.ped = ped
                    v.isRendered = true
                    v.isLoading = false
                end
                
                -- Despawn logic: Remove NPC when player moves away to save resources
                if dist >= Config.Distance and v.isRendered then
                    if Config.Fade then
                        for i = 255, 0, -85 do  -- Accelerated fade out animation
                            Citizen.Wait(10)     -- Minimal wait time
                            SetEntityAlpha(v.ped, i, false)
                        end
                    end
                    DeletePed(v.ped)
                    v.ped = nil
                    v.isRendered = false
                end
            end
        end
    end
end)

-- Expose the pedList to other files
function GetPedList()
    return pedList
end
