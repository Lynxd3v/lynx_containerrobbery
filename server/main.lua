local MySQL = exports.oxmysql
local QuestActive = {}

function LynxAntiCheatSecurity(source, message)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    xPlayer.kick(
        'LYNX ANTI CHEAT\nYou have been kicked for suspected cheating. If you believe this is a mistake, please contact support.')
    LynxLogSecurity(message)

    --Set Ban system here if you have one, you can use the identifier to ban the player from your server
end

function LynxLogSecurity(message)
    if not Config.Webhook then return end
    local text = {
        {
            ["color"] = "16711680",
            ["title"] = "**LYNX CONTAINER ROBBERY [SECURITY LOG]**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Lynx Container Robbery | " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST',
        json.encode({ username = "Lynx Container Robbery", embeds = text }), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('Lynx_Containerrobbery:PoliceJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local IsNotPolice = true

    for _, v in ipairs(Config.PoliceJob) do
        if xPlayer.getJob().name == v then
            IsNotPolice = false
        end
    end

    cb(IsNotPolice)
end)

ESX.RegisterServerCallback('Lynx_Containerrobbery:GetXpLevel', function(src, cb, param1, param2)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    cb(MySQL.Sync.fetchScalar('SELECT xp FROM lynx_containerrobbery WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier()
    }))
end)

RegisterNetEvent('Lynx_Containerrobbery:StartQuest',function (id)
    local src = source
    QuestActive[src] = id
end)

RegisterNetEvent('Lynx_Containerrobbery:StartContainerRobberyBlip', function(id,cid)
    for _, players in pairs(ESX.GetPlayers()) do
        local xPlayers = ESX.GetPlayerFromId(players)
        for _, v in ipairs(Config.PoliceJob) do
            if xPlayers.getJob().name == v then
                TriggerClientEvent('Lynx_Containerrobbery:AddRobberyBlip', players,id,cid)
            end
        end
    end
end)

RegisterNetEvent('Lynx_Containerrobbery:Giveloot', function(cid, id, loot)
    local xPlayer = ESX.GetPlayerFromId(source)
    local addItem = true
    if not xPlayer then return end
    if not QuestActive then
        print('Lynx_Containerrobbery: Possible Exploit Attempt - Player: ' .. xPlayer.identifier)
        LynxAntiCheatSecurity(source)
        return
    end

    for _, v in ipairs(loot) do
        for _, lv in ipairs(Config.Container[id].container[cid].loot) do
            if v.item ~= lv.item and v.count ~= lv.count then
                addItem = false
            else
                addItem = true
            end
        end
    end

    local item = ''

    if addItem then
        for _, v in ipairs(loot) do
            item = item .. v.item .. ' [' .. v.count .. '], '
            xPlayer.addInventoryItem(v.item, v.count)
        end
    else
        print('Lynx_Containerrobbery: Possible Exploit Attempt - Player: ' .. xPlayer.identifier)
        LynxAntiCheatSecurity(source)
    end

    LynxLogSecurity('Name: ' ..
    GetPlayerName(source) ..
    '\nIdentifier:' .. xPlayer.identifier .. '\nAction: Completed Container Quest\nItem: ' .. item .. '')
end)

AddEventHandler('esx:playerLoaded', function(xPlayer)
    if not xPlayer then return end

    MySQL.Async.fetchScalar('SELECT identifier FROM lynx_containerrobbery WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if not result then
            MySQL.Async.execute('INSERT INTO Lynx_Containerrobbery (identifier, xp) VALUES (@identifier, @xp)', {
                ['@identifier'] = xPlayer.identifier,
                ['@xp'] = 0
            })
        end
    end)
end)

RegisterNetEvent('Lynx_Containerrobbery:AddXp', function(id, xp)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xpAdd = Config.Container[id]
    if not xPlayer then return end
    if not QuestActive then
        print('Lynx_Containerrobbery: Possible Exploit Attempt - Player: ' .. xPlayer.identifier)
        LynxAntiCheatSecurity(source)
        return
    end

    if xpAdd ~= xp then
        return
    end

    MySQL.Async.execute('UPDATE Lynx_Containerrobbery SET xp = xp + @xp WHERE identifier = @identifier', {
        ['@xp'] = xp,
        ['@identifier'] = xPlayer.identifier()
    })

    local currentxp = MySQL.Sync.fetchScalar('SELECT xp FROM lynx_containerrobbery WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier()
    })

    QuestActive[source] = nil
    LynxLogSecurity('Name: ' ..
    GetPlayerName(source) ..
    '\nIdentifier:' .. xPlayer.identifier .. '\nAction: Gained XP\nCurrent XP: ' .. currentxp .. '\nXP Added: ' .. xp ..
    '')
end)
