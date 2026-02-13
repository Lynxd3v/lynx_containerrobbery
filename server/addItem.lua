RegisterNetEvent('lynx_containerrobbery:addItem',function (item, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not item or not amount then return end

    xPlayer.addInventoryItem(item, amount)
end)