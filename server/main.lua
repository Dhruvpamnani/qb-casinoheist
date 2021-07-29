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
