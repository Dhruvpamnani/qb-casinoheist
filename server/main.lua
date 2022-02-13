--------------------------------------------------------------------------------------------------------------------------------------------------------

local QBCore = exports['qb-core']:GetCoreObject()
local VaultSpawned = false

--------------------------------------------------------------------------------------------------------------------------------------------------------

QBCore.Functions.CreateCallback('qb-casinoheist:server:getCops', function(source, cb)
	local cops = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                cops = cops + 1
            end
        end
	end
	cb(cops)
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('qb-casinoheist:server:spawnvault', function(type)
    print('Vault Spawned?', VaultSpawned)
    if not VaultSpawned then
        ajvault = CreateObject(`ch_prop_ch_vaultdoor01x`, Config.VaultDoorSpawn[1].x - 0.05, Config.VaultDoorSpawn[1].y + 1, Config.VaultDoorSpawn[1].z - 2.03, true, true, true)
        SetEntityHeading(ajvault, 58.00)
        FreezeEntityPosition(ajvault, true)
        VaultSpawned = true
        print('Vault Spawned?', VaultSpawned)
    end
end)

RegisterNetEvent('qb-casinoheist:server:recieveLockerItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    ply.Functions.AddItem('10kgoldchain', math.random(1,5))
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['10kgoldchain'], "add")
    chance = math.random(1, 10)
    if chance == 2 then
        ply.Functions.AddItem('diamond_ring', math.random(1,3))
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['diamond_ring'], "add")
    end
end)

RegisterNetEvent('qb-casinoheist:server:recieveCartItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local info = {
        worth = math.random(Config.MarkedMin, Config.MarkedMax)
    }
    ply.Functions.AddItem('markedbills', math.random(Config.MarkedBagMin,Config.MarkedBagMax), false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
end)

RegisterNetEvent('qb-casinoheist:server:recieveGoldItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    ply.Functions.AddItem('goldbar', math.random(1,5), false)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], "add")
end)

RegisterNetEvent('qb-casinoheist:server:callCops', function(streetLabel, coords)
    local data = {displayCode = '99-99', description = 'Diamomd Casino Robbery', isImportant = 1, recipientList = {'police'}, length = '20000', infoM = 'fa-info-circle', info = 'Alarm at the Diamomd Casino has gone off'}
    local dispatchData = {dispatchData = data, caller = 'Alarm', coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
        }
    }
    TriggerEvent('sv_Dispatch', dispatchData)
end)

RegisterNetEvent('aj:sync', function(status)
    if status == true then
        print('Casino Vault Spawned')
        SetEntityHeading(ajvault, 58.00)
        FreezeEntityPosition(ajvault, true)
    elseif status == false then
        print('Casino Vault Deleted')
        -- TriggerClientEvent('qb-casinoheist:client:sync', -1) -- Crashes Server
        TriggerClientEvent('qb-casinoheist:client:ExplodeAnim' , -1)
        FreezeEntityPosition(ajvault, false)
        DeleteEntity(ajvault)
    end
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------

QBCore.Functions.CreateUseableItem("security_card_02", function(source)
	local src = source
	TriggerClientEvent("security_card_02:Usesecurity_card_02", src)
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------