Config = Config or {}
local inRange = false
local requiredItemsShowed = false
local closestBank = nil
local cartsUp = false
--ch_prop_ch_vaultdoor01x

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload",function() 
    isLoggedIn = false 
end)

CreateThread(function()
    local hash = "casHeistVaultDoor1"
    if not IsDoorRegisteredWithSystem(hash) then
        local door = GetClosestObjectOfType(Config.VaultDoors[1].x, Config.VaultDoors[1].y, Config.VaultDoors[1].z, 1, GetHashKey("ch_prop_ch_vaultdoor01x"), false, false, false)
        SetEntityHeading(door, 90)
        print(1)
        AddDoorToSystem(hash, GetHashKey("ch_prop_ch_vaultdoor01x"), Config.VaultDoors[1].x, Config.VaultDoors[1].y, Config.VaultDoors[1].z, false, false, false)
    else
        print(2)
    end
    while true do
        Wait(100)
        if not Config.VaultDoors[1].isOpen then
            DoorSystemSetDoorState(hash, 4, false, false) DoorSystemSetDoorState(hash, 1, false, false)
        else
            DoorSystemSetDoorState(hash, 0, false, false) DoorSystemSetDoorState(hash, 5, false, false)
        end
    end
end)

function SpawnCarts()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local model = "hei_prop_hei_cash_trolly_01"
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model) Citizen.Wait(100) end
    for i = 1, 3 do
        if GetClosestObjectOfType(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, 1, GetHashKey(model), true, true, false) ~= nil then
            local obj = GetClosestObjectOfType(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, 1, GetHashKey(model), true, true, false)
            if DoesEntityExist(obj) then
                DeleteEntity(obj) -- SHOULD DELETE CARTS
            end
        else
            local cart = CreateObject(model, Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, true, true, false) 
        end
    end
end

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i = 1, 4 do
            local dist = #(pos - vector3(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z))
            if dist < 1 then
            DrawText3Ds(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z + 0.3, 'press e or some shit idk.')
            DrawMarker(2, Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i = 1, 2 do
            local dist = #(pos - vector3(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z))
            if dist < 1 then
            DrawText3Ds(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z + 0.3, 'DRILLLLLLLLLLLLLLLL.')
            DrawMarker(2, Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
            end
        end
    end
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
CreateThread(function()
    -- Wait(2000)
    local requiredItems = {
        [1] = {name = QBCore.Shared.Items["security_card_02"]["name"], image = QBCore.Shared.Items["security_card_02"]["image"]}
    }
    while true do
        -- Wait(100)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for i = 1, 4 do
            local dist = #(pos - vector3(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z))
            if dist < 1 then
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('security_card_02:Usesecurity_card_02')
                    break
                end
                if not requiredItemsShowed then
                    requiredItemsShowed = true
                    TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                end
                break
            else
                if requiredItemsShowed then
                    requiredItemsShowed = false
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
            end
        end
        Wait(1)
    end
end)

CreateThread(function()
    -- Wait(2000)
    local requiredItems2 = {
        [1] = {name = QBCore.Shared.Items["drill"]["name"], image = QBCore.Shared.Items["drill"]["image"]}
    }
    while true do
        -- Wait(100)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for k = 1, 2 do
            local dist = #(pos - vector3(Config.DrillSpots[k].x, Config.DrillSpots[k].y, Config.DrillSpots[k].z))
            if dist < 1 then
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('drill:Usedrill')
                    break
                end
                if not requiredItemsShowed then
                    requiredItemsShowed = true
                    TriggerEvent('inventory:client:requiredItems', requiredItems2, true)
                end
                break
            else
                if requiredItemsShowed then
                    requiredItemsShowed = false
                    TriggerEvent('inventory:client:requiredItems', requiredItems2, false)
                end
            end
        end
        Wait(1)
    end
end)

RegisterNetEvent('security_card_02:Usesecurity_card_02')
AddEventHandler('security_card_02:Usesecurity_card_02', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
            QBCore.Functions.Progressbar("hack_gate", "Starting Hack...", math.random(5000, 10000), false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = true,
                disableCombat = true,
            }, {
                animDict = "anim@gangops@facility@servers@",
                anim = "hotwire",
                flags = 16,
            }, {}, {}, function() -- Done
                StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                TriggerEvent("mhacking:show")
                TriggerEvent("mhacking:start", math.random(6, 7), math.random(60, 120), OnHackDone)
            end)
        end
    end, "security_card_02")
end)

RegisterNetEvent('drill:Usedrill')
AddEventHandler('drill:Usedrill', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
            QBCore.Functions.Progressbar("drill_lock", "Drilling", math.random(5000, 10000), false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@gangops@facility@servers@",
                anim = "hotwire",
                flags = 16,
            }, {}, {}, function() -- Done
                StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
            end)
        end
    end, "drill")
end)

function OnHackDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
    else
		TriggerEvent('mhacking:hide')
	end
end