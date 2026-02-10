ESX = exports.es_extended:getSharedObject()
local ped = nil

CreateThread(function()
    local pm = Config.NPCQuestPed.pedModel
    local pc = Config.NPCQuestPed.pedCoords

    RequestModel(GetHashKey(pm))
    while HasModelLoaded(pm) do Wait(10) end

    ped = CreatePed(4, pm, pc.x, pc.y, pc.z, Config.NPCQuestPed.pedHeading, false, true)
    FreezeEntityPosition(ped, true)

    while true do
        local sleep = 1000
        local mped = PlayerPedId()
        local mc = GetEntityCoords(mped)
        local distance = (mc - pc)

        if distance <= 2.0 then
            if IsControlJustPressed(0, 36) then
                SendNUIMessage({
                    action = 'open',
                    list = Config.Container
                })
            end
        end
        Wait(sleep)
    end
end)

RegisterNUICallback('ClosePanel', function(data, cb)
    SendNUIMessage({
        action = 'close'
    })
    cb()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    if ped ~= nil then
        DeleteEntity(ped)
    end
end)
