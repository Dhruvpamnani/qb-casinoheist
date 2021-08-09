RegisterServerEvent('qb-casinoheist:server:recieveLockerItem')
AddEventHandler('qb-casinoheist:server:recieveLockerItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
   -- ply.Functions.AddItem('casinochips', math.random(100,800))
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['casinochips'], "add")
end)

RegisterServerEvent('qb-casinoheist:server:recieveCartItem')
AddEventHandler('qb-casinoheist:server:recieveCartItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
   -- local info = {
   --     worth = math.random(4000, 6000)
   -- }
   -- ply.Functions.AddItem('markedbills', math.random(1,4), false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
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