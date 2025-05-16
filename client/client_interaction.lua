-- Thread for handling NPC interactions
-- Detects when player is close to an NPC and shows interaction prompts
Citizen.CreateThread(function()
    while true do
        local playerPosition = GetEntityCoords(PlayerPedId())
        local isNearPed = false
        local waitTime = 500  -- Default wait time when not near any NPC
        local pedList = GetPedList()
        
        for k, v in pairs(pedList) do
            if v.isRendered then
                local dist = #(playerPosition - v.coords)
                if dist <= Config.MarkerDistance then
                    isNearPed = true
                    -- Display help text for interaction
                    BeginTextCommandDisplayHelp('STRING')
                    local text = v.interactionText or Config.InteractionText
                    AddTextComponentSubstringPlayerName(text)
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    
                    -- Detect interaction key press (E key - input_context)
                    if IsControlJustPressed(0, 38) then
                        -- Trigger the main interaction event
                        TriggerEvent(GetCurrentResourceName() .. ":interaction", k)
                    end
                    
                    waitTime = 0  -- Reduce wait time for responsive controls when near an NPC
                end
            end
        end
        
        Citizen.Wait(waitTime)
    end
end)

-- Event handler for NPC interactions
-- This is triggered when a player interacts with an NPC
AddEventHandler(GetCurrentResourceName() .. ":interaction", function(pedId)
    local pedList = GetPedList()
    local ped = pedList[pedId]
    if ped then
        -- Send NUI message to the client
        SendNUIMessage({
            action = "showInteraction",
            title = ped.title,
            description = ped.description,
            image = ped.image,
        })
        SetNuiFocus(true, true)  -- Set NUI focus to true for interaction
    end
end)

RegisterNuiCallbackType("closeInteraction")
AddEventHandler("__cfx_nui:closeInteraction", function(data, cb)
    SetNuiFocus(false, false)  -- Remove NUI focus
    cb('ok')  -- Callback to indicate success
end)
