-- Thread to preload commonly used models to reduce loading times
-- This improves initial spawn responsiveness for frequently used NPCs
Citizen.CreateThread(function()
    Wait(2000)  -- Wait for game to stabilize on script start
    
    -- Pre-cache frequently used models
    local commonModels = {}
    local seenModels = {}
    
    -- Identify unique models in the config
    for _, v in pairs(Config.PedList) do
        if not seenModels[v.model] then
            seenModels[v.model] = true
            table.insert(commonModels, v.model)
        end
    end
    
    -- Preload up to 5 most common models to save memory while improving performance
    local modelsToPreload = math.min(5, #commonModels)
    for i = 1, modelsToPreload do
        local modelHash = GetHashKey(commonModels[i])
        RequestModel(modelHash)
    end
end)
