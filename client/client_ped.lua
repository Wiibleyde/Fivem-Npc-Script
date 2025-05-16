-- Optimized function to create an NPC at the specified location
-- Handles model loading, animation setup, and appearance effects
function nearPed(model, coords, heading, gender, animDict, animName, scenario)
    local genderNum = 0
    local ped = nil
    local modelHash = GetHashKey(model)
    
    -- Request the model with timeout to prevent hanging
    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 20 do
        Citizen.Wait(50)  -- Reduced wait time for faster appearance
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(modelHash) then
        print("Failed to load model: " .. model)
        return nil
    end
    
    -- Convert gender string to the appropriate native parameter
    if gender == 'male' then
        genderNum = 4
    elseif gender == 'female' then 
        genderNum = 5
    else
        print("No gender provided! Check your configuration!")
    end    

    -- Create the NPC at the correct position
    if Config.MinusOne then 
        local x, y, z = table.unpack(coords)
        ped = CreatePed(genderNum, modelHash, x, y, z - 1, heading, false, true)
    else
        ped = CreatePed(genderNum, modelHash, coords, heading, false, true)
    end
    
    -- Set NPC properties and behavior
    SetEntityAlpha(ped, 0, false)  -- Start invisible for fade-in effect
    
    if Config.Frozen then
        FreezeEntityPosition(ped, true)  -- Prevent NPC from moving
    end
    
    if Config.Invincible then
        SetEntityInvincible(ped, true)  -- Make NPC immune to damage
    end

    if Config.Stoic then
        SetBlockingOfNonTemporaryEvents(ped, true)  -- Prevent NPC from reacting to world events
    end
    
    -- Load and play animations with timeout protection
    if animDict and animName then
        RequestAnimDict(animDict)
        local animTimeout = 0
        while not HasAnimDictLoaded(animDict) and animTimeout < 15 do
            Citizen.Wait(50)
            animTimeout = animTimeout + 1
        end
        if HasAnimDictLoaded(animDict) then
            TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
        end
    end

    if scenario then
        TaskStartScenarioInPlace(ped, scenario, 0, true)
    end
    
    -- Gradual appearance effect or instant spawn based on config
    if Config.Fade then
        for i = 0, 255, 85 do  -- Accelerated fade-in
            Citizen.Wait(10)    -- Minimal wait time
            SetEntityAlpha(ped, i, false)
        end
    else
        -- Instant appearance
        SetEntityAlpha(ped, 255, false)
    end

    -- Free memory by marking the model as no longer needed
    SetModelAsNoLongerNeeded(modelHash)
    
    return ped
end
