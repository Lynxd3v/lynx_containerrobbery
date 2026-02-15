Config = {}

Config.NPCQuestPed = {
    pedModel = '',
    pedCoords = vector3(0,0,0),
    pedHeading = 0
}

Config.PoliceJob = {
    'police'
}

Config.Webhook = '' -- Webhook for Security Logs, you can use this to log possible exploits or cheaters

Config.Container = {
    [1] = {
        name = 'Kezdő Container',
        xp = 50, -- XP Level to Start Quest
        xpadd = 10, -- XP to Add on Quest Complete
        container = {
            [1] = {
                coords = vector3(0,0,0),
                heading = 0,
                model = 'prop_container_01a',
                difficulty = {'Easy','medium','medium'}, -- For minigame
                loot = {
                    {item = 'bread', count = 5},
                    {item = 'water', count = 3},
                    {item = 'phone', count = 1}
                }
            }
        }
    },
}