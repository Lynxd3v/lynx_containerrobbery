function SuspiciusActivity(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local text ="Name:" .. xPlayer.getName() .. "\n" ..
                "Identifier:" .. xPlayer.identifier .. "\n"

    xPlayer.kick('LYNX CONTAINER ROBBERY [SECURITY]\n Suspicius Activity')
end