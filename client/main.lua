Config = Config or {}
local inRange = false
local requiredItemsShowed = false
local requiredItemsShowed2 = false
local closestBank = nil
local cartsUp = false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload",function() 
    isLoggedIn = false 
end)
CreateThread(function()
    local hash = "axhahsahah"
    if not IsDoorRegisteredWithSystem(hash) then
        AddDoorToSystem(hash, GetHashKey("ch_prop_ch_vaultdoor01x"), Config.VaultDoors[1].x, Config.VaultDoors[1].y, Config.VaultDoors[1].z, false, false, false)
    end
    DoorSystemSetAutomaticDistance(hash, 0.0, false, false)
    while true do
        Wait(100)
        if not Config.VaultDoors[1].isOpen then
            DoorSystemSetDoorState(hash, 1, false, false)
        else
            DoorSystemSetDoorState(hash, 0, false, false)
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
            DrawText3Ds(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z + 0.3, '[~b~E~s~] to Hack')
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
            DrawText3Ds(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z + 0.3, '[~b~E~s~] to Drill')
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

CreateThread(function()  -- needs to be fixed causing required items to now show up
    -- Wait(2000)
    local requiredItems2 = {
        [1] = {name = QBCore.Shared.Items["drill"]["name"], image = QBCore.Shared.Items["drill"]["image"]}
    }
    while true do
        -- Wait(100)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for i = 1, 2 do
            local dist = #(pos - vector3(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z))
            if dist < 1 then
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('drill:Usedrill')
                    break
                end
                if not requiredItemsShowed2 then
                    requiredItemsShowed2 = true
                    TriggerEvent('inventory:client:requiredItems', requiredItems2, true)
                end
                break
            else
                if requiredItemsShowed2 then
                    requiredItemsShowed2 = false
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
            SetEntityHeading(ped, 53.35)
            StartHack(Config)
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
                --StartHack()
                --TriggerEvent("mhacking:show")
                --TriggerEvent("mhacking:start", math.random(6, 7), math.random(60, 120), OnHackDone)
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
            loadAnimDict("anim@heists@fleeca_bank@drilling")
            TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
            local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
            AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
            QBCore.Functions.Progressbar("drill_lock", "Drilling", math.random(5000, 10000), false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@heists@fleeca_bank@drilling",
                anim = "drill_straight_idle",
                flags = 16,
            }, {}, {}, function() -- Done
                DetachEntity(DrillObject, true, true)
                DeleteObject(DrillObject)
                StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_end_idle", 1.0)
                QBCore.Functions.Notify('you got blank blank', "success")
            end)
        end
    end, "drill")
end)

function OnHackDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        QBCore.Functions.Notify('yes', "success")
    else
		TriggerEvent('mhacking:hide')
        QBCore.Functions.Notify('no', "error")
	end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function StartHack(Config)
    local animDict = "anim@heists@ornate_bank@hack"

    RequestAnimDict(animDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestModel("hei_prop_heist_card_hack_02")

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("hei_prop_hst_laptop")
        or not HasModelLoaded("hei_p_m_bag_var22_arm_s")
        or not HasModelLoaded("hei_prop_heist_card_hack_02") do
        Citizen.Wait(100)
    end
    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", Config.KeycardDoors[1].x + 0, Config.KeycardDoors[1].y + 1.3, Config.KeycardDoors[1].z + 0.85) -- Animasyon kordinatları, buradan lokasyonu değiştirin // These are fixed locations so if you want to change animation location change here
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", Config.KeycardDoors[1].x + 0, Config.KeycardDoors[1].y + 1.3, Config.KeycardDoors[1].z + 0.85)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", Config.KeycardDoors[1].x + 0, Config.KeycardDoors[1].y + 1.3, Config.KeycardDoors[1].z + 0.85)
    -- part1
    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 0, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
    local laptop = CreateObject(GetHashKey("hei_prop_hst_laptop"), targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
    local card = CreateObject(GetHashKey("hei_prop_heist_card_hack_02"), targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(card, netScene, animDict, "hack_enter_card", 4.0, -8.0, 1)
    -- part2
    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene2, animDict, "hack_loop_card", 4.0, -8.0, 1)
    -- part3
    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, "hack_exit_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene3, animDict, "hack_exit_card", 4.0, -8.0, 1)
    --event başlangıç
    SetPedComponentVariation(ped, 5, 0, 0, 0) -- çantayı yok ediyoruz eğer varsa // removes bag from ped so no 2 bags
    SetEntityHeading(ped, 63.60) -- Animasyon düzgün oturması için yön // for proper animation direction

    NetworkStartSynchronisedScene(netScene)
    Citizen.Wait(4500) -- Burayı deneyerek daha iyi hale getirebilirsiniz // You can try editing this to make transitions perfect
    NetworkStopSynchronisedScene(netScene)

    NetworkStartSynchronisedScene(netScene2)
    Citizen.Wait(4500)
    NetworkStopSynchronisedScene(netScene2)

    NetworkStartSynchronisedScene(netScene3)
    Citizen.Wait(4500)
    NetworkStopSynchronisedScene(netScene3)

    DeleteObject(bag)
    DeleteObject(laptop)
    DeleteObject(card)
    FreezeEntityPosition(ped, false)
    SetPedComponentVariation(ped, 5, 45, 0, 0) -- çantayı pede geri veriyor // gives bag back to ped
end