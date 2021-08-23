CreateThread(function()
    ajvault = CreateObject(`ch_prop_ch_vaultdoor01x`, Config.VaultDoors[1].x - 0.05, Config.VaultDoors[1].y + 1, Config.VaultDoors[1].z - 2.03, true, true, true)
    SetEntityHeading(ajvault, 58.00)
    FreezeEntityPosition(ajvault, true)
end)

RegisterServerEvent('qb-casinoheist:server:spawnvault')
AddEventHandler('qb-casinoheist:server:spawnvault', function(type)
    ajvault = CreateObject(`ch_prop_ch_vaultdoor01x`, Config.VaultDoors[1].x - 0.05, Config.VaultDoors[1].y + 1, Config.VaultDoors[1].z - 2.03, true, true, true)
    SetEntityHeading(ajvault, 58.00)
    FreezeEntityPosition(ajvault, true)
end)

RegisterServerEvent('qb-casinoheist:server:recieveLockerItem')
AddEventHandler('qb-casinoheist:server:recieveLockerItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    ply.Functions.AddItem('10kgoldchain', math.random(1,8))
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['10kgoldchain'], "add")
    chance = math.random(1, 10)
    print(chance)
    if chance == 2 then
        ply.Functions.AddItem('diamond_ring', math.random(1,5))
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['diamond_ring'], "add")
    end
end)

RegisterServerEvent('qb-casinoheist:server:recieveCartItem')
AddEventHandler('qb-casinoheist:server:recieveCartItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local info = {
        worth = math.random(Config.MarkedMin, Config.MarkedMax)
    }
    ply.Functions.AddItem('markedbills', math.random(Config.MarkedBagMin,Config.MarkedBagMax), false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
end)

RegisterServerEvent('qb-casinoheist:server:recieveGoldItem')
AddEventHandler('qb-casinoheist:server:recieveGoldItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    ply.Functions.AddItem('goldbar', math.random(1,5), false)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], "add")
end)

RegisterServerEvent('qb-casinoheist:server:callCops')
AddEventHandler('qb-casinoheist:server:callCops', function(type, safe, streetLabel, coords)
    local data = {displayCode = '10-67', description = 'Possible Casino Robbery', isImportant = 0, recipientList = {'police'}, length = '15000', infoM = 'fa-info-circle', info = 'Caller reports gunshots and loud explosions in the area'}
    local dispatchData = {dispatchData = data, caller = 'Local', coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
        }
    }

    local alertData = {
        title = "10-67 | Possible Store Robbery",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Suspect acticing suspicious at: "..streetLabel..")"
    }
    TriggerClientEvent("qb-casinoheist:client:robberyCall", -1, type, safe, streetLabel, coords)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
    TriggerEvent('wf-alerts:svNotify', dispatchData)
end)

RegisterServerEvent('aj:sync')
AddEventHandler('aj:sync', function(status)
    print(status)
    if status == true then
        SetEntityHeading(ajvault, 58.00)
        FreezeEntityPosition(ajvault, true)
        print(ajvault)
    elseif status == false then
        print(ajvault)
        FreezeEntityPosition(ajvault, false)
    end
end)