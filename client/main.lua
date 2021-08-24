Config = Config or {}
local inRange = false
local isLoggedIn = false
local Busy = false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    --MissionNotification()
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload",function()
    isLoggedIn = false
end)

RegisterCommand("uir", function()
    isLoggedIn = true
end)

function SpawnCarts()
    local model = "hei_prop_hei_cash_trolly_01"
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model) Wait(100) end
    ClearAreaOfObjects(989.14, 50.54, 59.65, 10, 0)
    for i = 1, 3 do
        local obj = GetClosestObjectOfType(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, 3.0, `hei_prop_hei_cash_trolly_01`, false, false, false)
        if obj ~= 0 then
            DeleteObject(obj)
            Wait(1)
        end
        local cart = CreateObject(model, Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, true, true, false)
    end
end
function SpawnGoldCarts()
    local model = "ch_prop_gold_trolly_01a"
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model) Wait(100) end
    ClearAreaOfObjects(989.14, 50.54, 59.65, 10, 0)
    for i = 1, 1 do
        local obj = GetClosestObjectOfType(Config.GoldTrolleys[i].x, Config.GoldTrolleys[i].y, Config.GoldTrolleys[i].z, 3.0, `ch_prop_gold_trolly_01a`, false, false, false)
        if obj ~= 0 then
            DeleteObject(obj)
            Wait(1)
        end
        local cart = CreateObject(model, Config.GoldTrolleys[i].x, Config.GoldTrolleys[i].y, Config.GoldTrolleys[i].z, true, true, false)
    end
end
function SpawnBrokenVault()
    local model = "ch_des_heist3_vault_end"
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model) Wait(100) end
    local BrokenDoor = CreateObject(model, Config.VaultDoors[1].x + 0.2, Config.VaultDoors[1].y + 0.66, Config.VaultDoors[1].z - 1.6, true, true, false)
    SetEntityHeading(BrokenDoor, 325.00)
end

CreateThread(function()
    TriggerServerEvent('qb-casinoheist:server:spawnvault')
    TriggerServerEvent('aj:sync', true)
    SpawnPeds()  -- Not Ready for Use
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
    while true do
        Wait(1)
        if isLoggedIn then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            for i = 1, 3 do 
                local dist = #(pos - vector3(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z))
                if dist < 1 and not Config.KeycardDoors[i].isOpen then
                    DrawText3Ds(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z + 0.3, '[~b~E~s~] Hack')
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('security_card_02:Usesecurity_card_02')
                    end
                end
            end
            local dist2 = #(pos - vector3(Config.VaultBomb[1].x, Config.VaultBomb[1].y, Config.VaultBomb[1].z))
            if dist2 < 1 and Config.VaultBomb[1].hit == false then
                inRange = true
                DrawText3Ds(Config.VaultBomb[1].x, Config.VaultBomb[1].y, Config.VaultBomb[1].z + 1, '[~b~E~s~] Hit')
                if IsControlJustPressed(0, 38) then
                    Wait(500)
                    TriggerEvent('bomb:Usebomb')
                end
            end
            for i = 1, 4 do
                local dist3 = #(pos - vector3(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z))
                if dist3 < 1 and closestDrill ~= nil and not Busy and not Config.DrillSpots[i].hit and Config.VaultBomb[1].hit then
                    inRange = true
                    DrawText3Ds(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z + 0.2, '[~b~E~s~] Drill')
                    print(closestDrill)
                    if IsControlJustPressed(0, 38) then
                        Wait(500)
                        TriggerEvent('drill:Usedrill')
                    end
                end
            end
            for i = 1, 3 do
                local dist4 = #(pos - vector3(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z))
                if dist4 < 1.5 and Config.VaultBomb[1].hit and not Config.Trolleys[i].hit then
                    inRange = true
                    DrawText3Ds(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z + 1, '[~b~E~s~] Take')
                    if IsControlJustPressed(0, 38) then
                        StartGrab()
                    end
                end
            end
            local dist5 = #(pos - vector3(Config.GoldTrolleys[1].x, Config.GoldTrolleys[1].y, Config.GoldTrolleys[1].z))
            if dist5 < 1.5 and Config.VaultBomb[1].hit and not Config.GoldTrolleys[1].hit then
                inRange = true
                DrawText3Ds(Config.GoldTrolleys[1].x, Config.GoldTrolleys[1].y, Config.GoldTrolleys[1].z + 1, '[~b~E~s~] Take')
                if IsControlJustPressed(0, 38) then
                    StartGrabgold()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist
        if QBCore ~= nil then
            inRange = false
            for k, v in pairs(Config.DrillSpots) do
                dist = #(pos - vector3(Config.DrillSpots[k]["x"], Config.DrillSpots[k]["y"], Config.DrillSpots[k]["z"]))
                if dist < 1.5 and Config.DrillSpots[k].hit == false then
                    closestDrill = k
                    inRange = true
                end
            end
            if not inRange then
                Wait(2000)
                closestDrill = nil
            end
            for k, v in pairs(Config.Trolleys) do
                dist = #(pos - vector3(Config.Trolleys[k]["x"], Config.Trolleys[k]["y"], Config.Trolleys[k]["z"]))
                if dist < 1.5 and Config.Trolleys[k].hit == false then
                    closestTrolly = k
                    inRange = true
                end
            end
            if not inRange then
                Wait(2000)
                closestTrolly = nil
            end
            for k, v in pairs(Config.KeycardDoors) do
                dist = #(pos - vector3(Config.KeycardDoors[k]["x"], Config.KeycardDoors[k]["y"], Config.KeycardDoors[k]["z"]))
                if dist < 1 then
                    closestKeypad = k
                    inRange = true
                end
            end
            if not inRange then
                Wait(2000)
                closestKeypad = nil
            end
        end
        Wait(5)
    end
end)

RegisterNetEvent('security_card_02:Usesecurity_card_02')
AddEventHandler('security_card_02:Usesecurity_card_02', function()
    local ped = PlayerPedId()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
            Wait(2000)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["security_card_02"], "remove")
            TriggerServerEvent("QBCore:Server:RemoveItem", "security_card_02", 1)
            SetEntityHeading(ped, Config.KeycardDoors[closestKeypad].h)
            StartHackAnim(Config)
        else
            QBCore.Functions.Notify('You do not have the required items!', "error")
        end
    end, "security_card_02")
end)

RegisterNetEvent('drill:Usedrill')
AddEventHandler('drill:Usedrill', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            Busy = true
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
            Wait(2000)
            StartDrillAnim(Config)
            StartDrillAnim2(Config)
            Config.DrillSpots[closestDrill].hit = true
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["drill"], "remove")
            TriggerServerEvent("QBCore:Server:RemoveItem", "drill", 1)
            TriggerServerEvent('qb-casinoheist:server:recieveLockerItem')
            Busy = false
        else
            QBCore.Functions.Notify('You do not have the required items!', "error")
        end
    end, "drill")
end)

RegisterNetEvent('bomb:Usebomb')
AddEventHandler('bomb:Usebomb', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            SetEntityHeading(ped, 326.34)
            Config.VaultBomb[1].hit = true
            StartBombAnim(Config)
            currentSafe = 1
            local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            local streetLabel = street1
            if street2 ~= nil then 
                streetLabel = streetLabel .. " " .. street2
            end
            TriggerServerEvent("qb-casinoheist:server:callCops", "safe", currentSafe, streetLabel, pos)
        else
            QBCore.Functions.Notify('You do not have the required items!', "error")
        end
    end, "weapon_pipebomb")
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function StartHackAnim(Config)
    local animDict = "anim@heists@ornate_bank@hack"
    RequestAnimDict(animDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("ch_p_m_bag_var03_arm_s")

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("hei_prop_hst_laptop")
        or not HasModelLoaded("ch_p_m_bag_var03_arm_s") do
        Wait(100)
    end
    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", Config.KeycardDoors[closestKeypad].animationx + 0, Config.KeycardDoors[closestKeypad].animationy + 0, Config.KeycardDoors[closestKeypad].animationz + 0.85)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", Config.KeycardDoors[closestKeypad].animationx + 0, Config.KeycardDoors[closestKeypad].animationy + 0, Config.KeycardDoors[closestKeypad].animationz + 0.85)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", Config.KeycardDoors[closestKeypad].animationx + 0, Config.KeycardDoors[closestKeypad].animationy + 0, Config.KeycardDoors[closestKeypad].animationz + 0.85)

    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 0, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "hack_enter", 0, 0, 1, 16, 1148846080, 0)
    local bag = CreateObject(`ch_p_m_bag_var03_arm_s`, targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
    local laptop = CreateObject(`hei_prop_hst_laptop`, targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)

    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "hack_loop", 0, 0, 10, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -80.0, 1)

    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "hack_exit", 0, 0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, "hack_exit_laptop", 4.0, -8.0, 1)

    SetPedComponentVariation(ped, 5, 0, 0, 0)
    SetEntityHeading(ped, 63.60)

    NetworkStartSynchronisedScene(netScene)
    Wait(6000)
    NetworkStopSynchronisedScene(netScene)

    NetworkStartSynchronisedScene(netScene2)
    TriggerEvent("mhacking:show")
    TriggerEvent("mhacking:start", 3, Config.HackTime, OnHackDone)
    Wait(Config.HackTime * 1000)
    NetworkStopSynchronisedScene(netScene2)

    NetworkStartSynchronisedScene(netScene3)
    Wait(4300)
    NetworkStopSynchronisedScene(netScene3)

    DeleteObject(bag)
    DeleteObject(laptop)
    DeleteObject(card)
    FreezeEntityPosition(ped, false)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
end

function OnHackDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('nui_doorlock:server:updateState', Config.KeycardDoors[closestKeypad].id, false, false, false, true)
        Config.KeycardDoors[closestKeypad].isOpen = true
    else
		TriggerEvent('mhacking:hide')
	end
end

function StartGrab()
    disableinput = true
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, `hei_prop_hei_cash_trolly_01`, false, false, false)
    local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)

	    FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()

	    Citizen.CreateThread(function()
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, `CASH_APPEAR`) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end
	local trollyobj = Trolley
    local emptyobj = `hei_prop_hei_cash_trolly_03`

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end
    local baghash = `ch_p_m_bag_var03_arm_s`

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Wait(100)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	local bag = CreateObject(`ch_p_m_bag_var03_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Wait(1500)
	CashAppear()
	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Wait(37000)
	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
	while not NetworkHasControlOfEntity(trollyobj) do
		Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	DeleteObject(trollyobj)
    DeleteEntity(trollyobj)
    Wait(100)
    PlaceObjectOnGroundProperly(NewTrolley)
    TriggerServerEvent('qb-casinoheist:server:recieveCartItem')
	Wait(1800)
	DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(`ch_p_m_bag_var03_arm_s`)
    disableinput = false
    Config.Trolleys[closestTrolly].hit = true
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function SpawnPeds()
    RequestModel("mp_m_freemode_01")
    while not HasModelLoaded("mp_m_freemode_01") do
        Wait(5)
    end
    for k, v in pairs(Config.Peds) do
        local Yew = CreatePed(5, 'mp_m_freemode_01', v.x, v.y, v.z, v.h, true)
        SetPedComponentVariation(Yew, 11, 317, 1, 0)
        SetPedComponentVariation(Yew, 3, 12, 0, 0)
        SetPedComponentVariation(Yew, 0, math.random(0,44), 0, 0)
        SetPedComponentVariation(Yew, 2, math.random(2, 15), math.random(1,5), 0)
        SetPedComponentVariation(Yew, 8, 170, 0, 0)
        SetPedComponentVariation(Yew, 4, 10, 0, 0)
        SetPedComponentVariation(Yew, 10, 71, 0, 0)
        SetPedComponentVariation(Yew, 6, 24, 0, 0)
        SetPedComponentVariation(Yew, 13, 71, 0, 0)
        SetPedHelmet(Yew, true)
        SetPedPropIndex(Yew, 0, 144, 0, true)
        SetPedArmour(Yew, 100)
        SetPedShootRate(Yew, 300)
        SetPedCombatAttributes(Yew, 46, true)
        SetPedCombatAttributes(Yew, 0, true)
        SetPedFleeAttributes(Yew, 0, 0)
        SetPedAsEnemy(Yew,true)
        SetPedMaxHealth(Yew, 200)
        SetPedAlertness(Yew, 1)
        SetPedCombatRange(Yew, 0)
        SetPedCombatMovement(Yew, 1)
        TaskCombatPed(Yew, PlayerPedId(), 0,16)
        GiveWeaponToPed(Yew, `WEAPON_CARBINERIFLE_MK2`, 5000, true, true)
        SetPedRelationshipGroupHash( Yew, `HATES_PLAYER`)
        SetPedDropsWeaponsWhenDead(Yew, false)
    end
end

function StartDrillAnim(Config)
    local animDict = "anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_01@male@"

    RequestAnimDict(animDict)
    RequestModel("ch_prop_vault_drill_01a")
    RequestModel("ch_p_m_bag_var03_arm_s")

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("ch_prop_vault_drill_01a")
        or not HasModelLoaded("ch_p_m_bag_var03_arm_s") do
        Wait(100)
    end
    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    local animPos = GetAnimInitialOffsetPosition(animDict, "enter", Config.DrillSpots[closestDrill].animx, Config.DrillSpots[closestDrill].animy, Config.DrillSpots[closestDrill].z - 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "idle", Config.DrillSpots[closestDrill].animx, Config.DrillSpots[closestDrill].animy, Config.DrillSpots[closestDrill].z - 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "exit", Config.DrillSpots[closestDrill].animx, Config.DrillSpots[closestDrill].animy, Config.DrillSpots[closestDrill].z - 2)
    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 0, true, true, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    local bag = CreateObject(`ch_p_m_bag_var03_arm_s`, targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "enter_p_m_bag_var22_arm_s", 4.0, -8.0, 1)
    local drill = CreateObject(`ch_prop_vault_drill_01a`, targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(drill, netScene, animDict, "enter_ch_prop_vault_drill_01a", 4.0, -8.0, 1)
    local netScene2 = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, true, true, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "action", 0, 0, 10, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "action_p_m_bag_var22_arm_s", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(drill, netScene2, animDict, "action_ch_prop_vault_drill_01a", 4.0, -80.0, 1)
    local netScene4 = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, true, true, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, netScene4, animDict, "reward", 0, 0, 10, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene4, animDict, "reward_p_m_bag_var22_arm_s", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(drill, netScene4, animDict, "reward_ch_prop_vault_drill_01a", 4.0, -80.0, 1)

    SetPedComponentVariation(ped, 5, 0, 0, 0)
    SetEntityHeading(ped, 63.60)

    NetworkStartSynchronisedScene(netScene)
    Wait(3500)
    NetworkStopSynchronisedScene(netScene)

    NetworkStartSynchronisedScene(netScene2)
    Wait(7000)
    NetworkStopSynchronisedScene(netScene2)

    NetworkStartSynchronisedScene(netScene4)
    Wait(4500)
    NetworkStopSynchronisedScene(netScene4)

    DeleteObject(bag)
    DeleteObject(drill)
    DeleteObject(card)
    FreezeEntityPosition(ped, false)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
end

function StartDrillAnim2(Config)
    local animDict = "anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_02@male@"

    RequestAnimDict(animDict)
    RequestModel("ch_prop_vault_drill_01a")
    RequestModel("ch_p_m_bag_var03_arm_s")

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("ch_prop_vault_drill_01a")
        or not HasModelLoaded("ch_p_m_bag_var03_arm_s") do
        Wait(100)
    end
    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    local animPos = GetAnimInitialOffsetPosition(animDict, "enter", Config.DrillSpots[closestDrill].animx, Config.DrillSpots[closestDrill].animy, Config.DrillSpots[closestDrill].z - 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "idle", Config.DrillSpots[closestDrill].animx, Config.DrillSpots[closestDrill].animy, Config.DrillSpots[closestDrill].z - 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "exit", Config.DrillSpots[closestDrill].animx, Config.DrillSpots[closestDrill].animy, Config.DrillSpots[closestDrill].z - 2)
    FreezeEntityPosition(ped, true)
    local bag = CreateObject(`ch_p_m_bag_var03_arm_s`, targetPosition, 1, 1, 0)
    local drill = CreateObject(`ch_prop_vault_drill_01a`, targetPosition, 1, 1, 0)
    local netScene2 = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, true, true, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "action", 0, 0, 10, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "action_p_m_bag_var22_arm_s", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(drill, netScene2, animDict, "action_ch_prop_vault_drill_01a", 4.0, -80.0, 1)
    local netScene4 = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, true, true, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, netScene4, animDict, "reward", 0, 0, 10, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene4, animDict, "reward_p_m_bag_var22_arm_s", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(drill, netScene4, animDict, "reward_ch_prop_vault_drill_01a", 4.0, -80.0, 1)
    local netScene3 = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, true, true, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "exit", 0, 0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "exit_p_m_bag_var22_arm_s", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(drill, netScene3, animDict, "exit_ch_prop_vault_drill_01a", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    SetEntityHeading(ped, 63.60)
    NetworkStartSynchronisedScene(netScene2)
    Wait(7000)
    NetworkStopSynchronisedScene(netScene2)
    NetworkStartSynchronisedScene(netScene4)
    Wait(3500)
    NetworkStopSynchronisedScene(netScene4)
    NetworkStartSynchronisedScene(netScene3)
    Wait(3000)
    NetworkStopSynchronisedScene(netScene3)
    DeleteObject(bag)
    DeleteObject(drill)
    DeleteObject(card)
    FreezeEntityPosition(ped, false)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
end

function StartBombAnim(Config)
    local animDict = "anim_heist@hs3f@ig8_vault_explosives@right@male@"
    RequestAnimDict(animDict)
    RequestModel("ch_prop_ch_explosive_01a")
    RequestModel("ch_p_m_bag_var03_arm_s")

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("ch_prop_ch_explosive_01a")
        or not HasModelLoaded("ch_p_m_bag_var03_arm_s") do
        Wait(100)
    end
    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "player_ig8_vault_explosive_plant_a", Config.VaultBomb[1].x + 0.3, Config.VaultBomb[1].y + 0, Config.VaultBomb[1].z + 1.1)
    local animPos4 = GetAnimInitialOffsetPosition(animDict, "player_ig8_vault_explosive_plant_b", Config.VaultBomb[1].x + 0.3, Config.VaultBomb[1].y + 0, Config.VaultBomb[1].z + 1.1)
    local animPos5 = GetAnimInitialOffsetPosition(animDict, "player_ig8_vault_explosive_plant_c", Config.VaultBomb[1].x + 0.3, Config.VaultBomb[1].y + 0, Config.VaultBomb[1].z + 1.1)
    local bag = CreateObject(`ch_p_m_bag_var03_arm_s`, targetPosition, 1, 1, 0)
    local bomb = CreateObject(`ch_prop_ch_explosive_01a`, targetPosition, 1, 1, 0)
    local bomb2 = CreateObject(`ch_prop_ch_explosive_01a`, targetPosition, 1, 1, 0)
    local bomb3 = CreateObject(`ch_prop_ch_explosive_01a`, targetPosition, 1, 1, 0)
    local bomb4 = CreateObject(`ch_prop_ch_explosive_01a`, targetPosition, 1, 1, 0)
    SetEntityVisible(bomb2, false)
    SetEntityVisible(bomb3, false)
    SetEntityVisible(bomb4, false)
    FreezeEntityPosition(ped, true)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, true, false, 1065353216, 0, 0.8)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "player_ig8_vault_explosive_plant_a", 0, 0, 10, 1, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "bag_ig8_vault_explosive_plant_a", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(bomb2, netScene3, animDict, "semtex_a_ig8_vault_explosive_plant_a", 4.0, -80.0, 1)
    local netScene4 = NetworkCreateSynchronisedScene(animPos4, targetRotation, 2, true, false, 1065353216, 0, 0.8)
    NetworkAddPedToSynchronisedScene(ped, netScene4, animDict, "player_ig8_vault_explosive_plant_b", 0, 0, 10, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene4, animDict, "bag_ig8_vault_explosive_plant_b", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(bomb3, netScene4, animDict, "semtex_b_ig8_vault_explosive_plant_b", 4.0, -80.0, 1)
    local netScene5 = NetworkCreateSynchronisedScene(animPos5, targetRotation, 2, true, false, 1065353216, 0, 0.8)
    NetworkAddPedToSynchronisedScene(ped, netScene5, animDict, "player_ig8_vault_explosive_plant_c", 0, 0, 10, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene5, animDict, "bag_ig8_vault_explosive_plant_c", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(bomb4, netScene5, animDict, "semtex_c_ig8_vault_explosive_plant_c", 4.0, -80.0, 1)
    BombCam(true)
    DeleteObject(bomb)
    SetEntityVisible(bomb2, true)
    NetworkStartSynchronisedScene(netScene3)
    Wait(3500)
    SetEntityVisible(bomb3, true)
    NetworkStopSynchronisedScene(netScene3)
    NetworkStartSynchronisedScene(netScene4)
    Wait(3500)
    SetEntityVisible(bomb4, true)
    NetworkStopSynchronisedScene(netScene4)
    NetworkStartSynchronisedScene(netScene5)
    Wait(3500)
    NetworkStopSynchronisedScene(netScene5)
    DeleteObject(bag)
    FreezeEntityPosition(ped, false)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
    BombCam(false)
    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["weapon_pipebomb"], "remove")
    TriggerServerEvent("QBCore:Server:RemoveItem", "weapon_pipebomb", 1)
    QBCore.Functions.Notify('The bomb will go off in ' ..Config.BombTime.. ' seconds.', "error")
    Wait(Config.BombTime * 1000)
    AddExplosion(Config.VaultBomb[1].x, Config.VaultBomb[1].y, Config.VaultBomb[1].z, 82, 5.0, true, false, 15.0)
    TriggerServerEvent('aj:sync', false)
    DeleteObject(bomb)
    DeleteObject(bomb2)
    DeleteObject(bomb3)
    DeleteObject(bomb4)
    loadAnimDict("anim_heist@hs3f@ig8_vault_explosive_react@right@male@")
    TaskPlayAnim(ped, "anim_heist@hs3f@ig8_vault_explosive_react@right@male@", "player_react_explosive_left", 3.0, -8, -1, 16, 0, 0, 0, 0 )
    Wait(100)
    SpawnCarts()
    SpawnGoldCarts()
    SpawnBrokenVault()
end

function StartGrabgold()
    disableinput = true
    local ped = PlayerPedId()
    local model = "ch_prop_gold_bar_01a"
    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, `ch_prop_gold_trolly_01a`, false, false,false)
    local CashAppear = function()
        local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)
        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Wait(100)
        end
        local grabobj = CreateObject(grabmodel, pedCoords, true)
        FreezeEntityPosition(grabobj, true)
        SetEntityInvincible(grabobj, true)
        SetEntityNoCollisionEntity(grabobj, ped)
        SetEntityVisible(grabobj, false, false)
        AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false,
            false, false, 0, true)
        local startedGrabbing = GetGameTimer()
        Citizen.CreateThread(function()
            while GetGameTimer() - startedGrabbing < 37000 do
                Wait(1)
                DisableControlAction(0, 73, true)
                if HasAnimEventFired(ped, `CASH_APPEAR`) then
                    if not IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, true, false)
                    end
                end
                if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
                    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                    end
                end
            end
            DeleteObject(grabobj)
        end)
    end
    local trollyobj = Trolley
    local emptyobj = `hei_prop_hei_cash_trolly_03`
    if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
        return
    end
    local baghash = `ch_p_m_bag_var03_arm_s`
    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and
        not HasModelLoaded(baghash) do
        Wait(100)
    end
    while not NetworkHasControlOfEntity(trollyobj) do
        Wait(1)
        NetworkRequestControlOfEntity(trollyobj)
    end
    local bag = CreateObject(`ch_p_m_bag_var03_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(scene1)
    Wait(1500)
    CashAppear()
    local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene2)
    Wait(37000)
    local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene3)
    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, -0.985), true)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
    while not NetworkHasControlOfEntity(trollyobj) do
        Wait(1)
        NetworkRequestControlOfEntity(trollyobj)
    end
    DeleteObject(trollyobj)
    PlaceObjectOnGroundProperly(NewTrolley)
    TriggerServerEvent('qb-casinoheist:server:recieveGoldItem')
    Wait(1800)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
    RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
    SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(`ch_p_m_bag_var03_arm_s`)
    disableinput = false
    Config.GoldTrolleys[1].hit = true
end

function BombCam(bool)
    local pos = GetEntityCoords(PlayerPedId())
    if bool then
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos[1] - 1.5, pos[2] + 1.5, pos[3], 0.0 ,0.0, 174.5, 60.00, false, 0)
        PointCamAtEntity(cam, PlayerPedId(), 0.0, 0.0, 0.0, true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
    end
end

------------------------WIP-------------------------------------

-- RegisterNetEvent('aj:spawnped')
-- AddEventHandler('aj:spawnped', function()
--     local Kekw = CreatePed(5, 'mp_m_freemode_01', 975.05, -84.59, 74.35, 140.56, true)  -- mp_m_freemode_01
--     SetPedComponentVariation(Kekw, 11, 317, 1, 0)
--     SetPedComponentVariation(Kekw, 3, 12, 0, 0)
--     SetPedComponentVariation(Kekw, 0, math.random(0,44), 0, 0)
--     SetPedComponentVariation(Kekw, 2, math.random(2, 15), math.random(1,5), 0)
--     SetPedComponentVariation(Kekw, 8, 170, 0, 0)
--     SetPedComponentVariation(Kekw, 4, 10, 0, 0)
--     SetPedComponentVariation(Kekw, 10, 71, 0, 0)
--     SetPedComponentVariation(Kekw, 6, 24, 0, 0)
--     SetPedComponentVariation(Kekw, 13, 71, 0, 0)
-- end)


-- RegisterCommand("fuckaj2", function()
--     --TriggerServerEvent('qb-casinoheist:server:spawnvault')
--     --StartThermAnim(Config)
--     MissionNotification()
-- end)

-- RegisterCommand("fuckaj3", function()
--     TriggerEvent('aj:spawnped')
-- end)

-- function StartThermAnim(Config)
--     pos = GetEntityCoords(PlayerPedId())
--     local animDict = "anim_heist@hs3f@ig13_thermal_charge@thermal_charge@male@"

--     RequestAnimDict(animDict)
--     RequestModel("hei_prop_heist_thermite_flash")
--     RequestModel("ch_p_m_bag_var03_arm_s")

--     while not HasAnimDictLoaded(animDict)
--         or not HasModelLoaded("hei_prop_heist_thermite_flash")
--         or not HasModelLoaded("ch_p_m_bag_var03_arm_s") do
--         Wait(100)
--     end
--     local ped = PlayerPedId()
--     local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
--     local animPos2 = GetAnimInitialOffsetPosition(animDict, "thermal_charge_male_male", pos[1] + 1, pos[2] + 1, pos[3] + 0.7)

--     -- part1
--     FreezeEntityPosition(ped, true)
--     local bag = CreateObject(GetHashKey("ch_p_m_bag_var03_arm_s"), targetPosition, 1, 1, 0)
--     local bomb = CreateObject(GetHashKey("hei_prop_heist_thermite_flash"), targetPosition, 1, 1, 0)
--     -- part2
--     local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, true, false, 1065353216, 0, 0.9)
--     NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "thermal_charge_male_male", 0, 0, 10, 16, 1148846080, 0)
--     NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "thermal_charge_male_p_m_bag_var22_arm_s", 4.0, -80.0, 1)
--     NetworkAddEntityToSynchronisedScene(bomb, netScene2, animDict, "thermal_charge_male_hei_prop_heist_thermite", 4.0, -80.0, 1)

--     SetPedComponentVariation(ped, 5, 0, 0, 0) -- removes bag from ped so no 2 bags

--     NetworkStartSynchronisedScene(netScene2)
--     Wait(5000)
--     NetworkStopSynchronisedScene(netScene2)


--     DeleteObject(bag)
--     FreezeEntityPosition(ped, false)
--     SetPedComponentVariation(ped, 5, 82, 3, 0)
--     Wait(10000)
--     DeleteObject(bomb)
-- end

-- function LoadCutscene(cut, flag1, flag2)
-- 	if (not flag1) then
-- 		RequestCutscene(cut, 8)
-- 	else
-- 		RequestCutsceneWithPlaybackList(cut, flag1, flag2)
-- 	end
-- 	while (not HasThisCutsceneLoaded(cut)) do Wait(0) end
-- 	return
-- end

-- function BeginCutsceneWithPlayer()
--     pos = GetEntityCoords(PlayerPedId())
-- 	local plyrId = PlayerPedId()
-- 	local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1)

--     SetBlockingOfNonTemporaryEvents(playerClone, true)
-- 	SetEntityVisible(playerClone, false, false)
-- 	SetEntityInvincible(playerClone, true)
-- 	SetEntityCollision(playerClone, false, false)
-- 	FreezeEntityPosition(playerClone, true)
-- 	SetPedHelmet(playerClone, false)
-- 	RemovePedHelmet(playerClone, true)

--     local model1 = GetHashKey("s_m_y_dealer_01")
--     RequestModel(model1)
--     while not HasModelLoaded(model1) do
--         RequestModel(model1)
--         Citizen.Wait(0)
--     end
--     local ped1 = CreatePed(7, model1, x, y ,z, 0.0, true, true)

--     local model2 = GetHashKey("s_m_y_dealer_01")
--     RequestModel(model2)
--     while not HasModelLoaded(model2) do
--         RequestModel(model2)
--         Citizen.Wait(0)
--     end
--     local ped2 = CreatePed(7, model2, x, y ,z, 0.0, true, true)

--     local model3 = GetHashKey("s_m_y_dealer_01")
--     RequestModel(model3)
--     while not HasModelLoaded(model3) do
--         RequestModel(model3)
--         Citizen.Wait(0)
--     end
--     local ped3 = CreatePed(7, model3, x, y ,z, 0.0, true, true)
	
-- 	SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
-- 	RegisterEntityForCutscene(plyrId, 'MP_1', 0, 0, 64)

-- 	SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
-- 	RegisterEntityForCutscene(ped1, 'MP_2', 0, 0, 64)

-- 	SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
-- 	RegisterEntityForCutscene(ped2, 'MP_3', 3, 0, 64)  -- 0 = enabled / 3 = false?

-- 	SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
-- 	RegisterEntityForCutscene(ped3, 'MP_4', 3, 0, 64)

-- 	Wait(10)
-- 	StartCutscene(0)
--     --StartCutsceneAtCoords(pos[1], pos[2], pos[3] - 0.5, 0)
-- 	Wait(10)
-- 	ClonePedToTarget(playerClone, plyrId)
-- 	Wait(10)
-- 	DeleteEntity(playerClone)
--     Wait(15000)
--     DeleteEntity(ped1)
--     DeleteEntity(ped2)
--     DeleteEntity(ped3)
  
-- 	return playerClone
-- end

-- CreateThread(function()
--     while true do
--         Wait(5)
--         if isLoggedIn and not Config.KeycardDoors[1].isOpen then
--             local ped = PlayerPedId()
--             local pos = GetEntityCoords(ped)
--             local dist = #(pos - vector3(1047.69, -727.03, 57.26))
--             if dist < 1.5 then
--                 --LoadCutscene('hs3_int', 0x105, 8)
--                 LoadCutscene('hs3_int')
--                 BeginCutsceneWithPlayer()
--                 RemoveCutscene()
--             end
--         end
--     end
-- end)

-- function MissionNotification()
-- 	Citizen.Wait(2000)
-- 	TriggerServerEvent('qb-phone:server:sendNewMail', {
-- 	sender = "Lester",
-- 	subject = "Something Interesting",
-- 	message = "We need to talk... meet me by the tables at mirror park lake ASAP.",
-- 	})
-- 	Citizen.Wait(3000)
-- end

-- CreateThread(function()
--     while true do
--         Wait(0)
--         local ped = PlayerPedId()
--         local pos = GetEntityCoords(ped)
--         local dist
--         dist = #(pos - vector3(980.87, 12.43, 71.84))
--         dict = "anim@scripted@player@mission@tunf_bunk_ig3_nas_upload@"
--         if dist < 1 then
--             if IsControlJustPressed(0, 38) then
--                 loadAnimDict(dict)
--                 TaskPlayAnim(ped, dict, "05_dialogue_upload_speed", 3.0, -8, -1, 32, 0, 0, 0, 0 )
--                 Wait(20000)
--                 TaskPlayAnim(ped, dict, "12_outro_renumeration", 3.0, -8, -1, 32, 0, 0, 0, 0 )
--                 print("disabled cams")
--             end
--         end
--     end
-- end)