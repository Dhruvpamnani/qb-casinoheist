Config = Config or {}
local inRange = false
local isLoggedIn = false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload",function() 
    isLoggedIn = false 
end)

function SpawnCarts()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local model = "hei_prop_hei_cash_trolly_01"
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model) Citizen.Wait(100) end
    ClearAreaOfObjects(989.14, 50.54, 59.65, 10, 0)
    for i = 1, 3 do
        local obj = GetClosestObjectOfType(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, 3.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)
        if obj ~= 0 then
            DeleteObject(obj)
            Wait(1)
        end
        local cart = CreateObject(model, Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, true, true, false)
    end
end

CreateThread(function()
    CloseVault()
    SpawnPeds()
end)

RegisterCommand("OpenVault", function()
    OpenVault()
end)
RegisterCommand("CloseVault", function()
    CloseVault()
end)
RegisterCommand("carty", function()
    SpawnCarts()
end)
RegisterCommand("strezsucks", function()
    lol()
end)

function OpenVault()
    local door = GetClosestObjectOfType(Config.VaultDoors[1].x, Config.VaultDoors[1].y, Config.VaultDoors[1].z, 3.0, GetHashKey("ch_prop_ch_vaultdoor01x"), false, false, false)
    FreezeEntityPosition(door, true)
    for i = 58, 190, 1 do
        i = i + 0.0
        SetEntityHeading(door, i)
        Wait(i / 3.3) --3.3
    end
end

function CloseVault()
    local door = GetClosestObjectOfType(Config.VaultDoors[1].x, Config.VaultDoors[1].y, Config.VaultDoors[1].z, 3.0, GetHashKey("ch_prop_ch_vaultdoor01x"), false, false, false)
    FreezeEntityPosition(door, true)
    for i = 190, 302, 1 do
        i = i + 0.0
        print(-i)
        SetEntityHeading(door, -i)
        Wait(-i / 3.3) --3.3
    end
end

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
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i = 1, 3 do
            local dist = #(pos - vector3(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z))
            if dist < 1.5 then
                local check = GetClosestObjectOfType(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, 1.5, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)
                local check2 = IsAnyObjectNearPoint(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, 1.0, true)
                inRange = true
                if check ~= 0 then
                    DrawText3Ds(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z + 1, '[~b~E~s~] Take')
                    if IsControlJustPressed(0, 38) then
                        StartGrab()
                    else
                        if check2 then
                            DrawText3Ds(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z + 1, '~r~ Empty')
                        end
                    end
                end
            end
        end
    end
end)

--[[CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i = 1, 3 do
            local dist = #(pos - vector3(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z))
            if dist < 2 then
                inRange = true
                DrawText3Ds(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z + 1, '[~b~E~s~] Take')
                if IsControlJustPressed(0, 38) then
                    Wait(500)
                    StartGrab()
                end
            end
        end
    end
end)]]

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - vector3(Config.VaultBomb[1].x, Config.VaultBomb[1].y, Config.VaultBomb[1].z))
        if dist < 1 then
            inRange = true
            DrawText3Ds(Config.VaultBomb[1].x, Config.VaultBomb[1].y, Config.VaultBomb[1].z + 1, '[~b~E~s~] Hit')
            if IsControlJustPressed(0, 38) then
                Wait(500) -- Needed or closestDrill = nil aka big error
                TriggerEvent('bomb:Usebomb')
            end
        elseif dist < 1 then
            DrawText3Ds(Config.DrillSpots[1].x, Config.DrillSpots[1].y, Config.DrillSpots[1].z + 1, '~r~ Empty')
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i = 1, 4 do
            local dist = #(pos - vector3(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z))
            if dist < 1 and not Config.DrillSpots[i].hit then
                inRange = true
                DrawText3Ds(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z + 0.2, '[~b~E~s~] Drill')
                if IsControlJustPressed(0, 38) then
                    Wait(500) -- Needed or closestDrill = nil aka big error
                    TriggerEvent('drill:Usedrill')
                end
            elseif dist < 1 and Config.DrillSpots[i].hit then
                DrawText3Ds(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z + 0.2, '~r~ Empty')
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i = 1, 4 do  --Note: see if we can remove all the for loops and replace with the [closestDoor] see line 278 for what im talking about
            local dist = #(pos - vector3(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z))
            if dist < 1 and not Config.KeycardDoors[i].isOpen then
                DrawText3Ds(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z + 0.3, '[~b~E~s~] Hack')
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('security_card_02:Usesecurity_card_02')
                    SpawnCarts()
                end
            elseif dist < 1 and Config.KeycardDoors[i].isOpen then
                DrawText3Ds(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z + 0.3, '~g~ Unlocked')
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

            for k, v in pairs(Config.Trolleys) do
                dist = #(pos - vector3(Config.Trolleys[k].x, Config.Trolleys[k].y, Config.Trolleys[k].z))
                if dist < 3 and Config.Trolleys[k].hit == false then
                    closestTrolley = k
                    inRange = true
                end
            end

            if not inRange then
                Citizen.Wait(100)
                closestTrolley = nil
            end
        end

        Citizen.Wait(3)
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
                if dist < 1 and Config.DrillSpots[k].hit == false then
                    closestDrill = k
                    inRange = true
                end
            end

            if not inRange then
                Citizen.Wait(1000)
                closestDrill = nil
            end
        end

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist

        if QBCore ~= nil then
            inRange = false

            for k, v in pairs(Config.KeycardDoors) do
                dist = #(pos - vector3(Config.KeycardDoors[k]["x"], Config.KeycardDoors[k]["y"], Config.KeycardDoors[k]["z"]))
                if dist < 2 then
                    closestDoor = k
                    inRange = true
                end
            end

            if not inRange then
                Citizen.Wait(2000)
                closestDoor = nil
            end
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('security_card_02:Usesecurity_card_02')
AddEventHandler('security_card_02:Usesecurity_card_02', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
            Wait(2000)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["security_card_02"], "remove")
            --TriggerServerEvent("QBCore:Server:RemoveItem", "security_card_02", 1)
            SetEntityHeading(ped, Config.KeycardDoors[closestDoor].h)
            StartHackAnim(Config)
        else
            QBCore.Functions.Notify('You do not have the required items!', "error")
        end
    end, "security_card_02")
end)

RegisterNetEvent('drill:Usedrill') -- Drills a full set of lockers
AddEventHandler('drill:Usedrill', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
            Wait(2000)
            local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
            AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
            QBCore.Functions.Progressbar("drill_lock", "Drilling", math.random(5000, 7000), false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim_heist@hs3f@ig9_vault_drill@drill@",
                anim = "drill_straight_fail",
                flags = 1,
            }, {}, {}, function() -- Done
                Config.DrillSpots[closestDrill].hit = true
                GiveLockerItems()
                DetachEntity(DrillObject, true, true)
                DeleteObject(DrillObject)
                StopAnimTask(PlayerPedId(), "anim_heist@hs3f@ig9_vault_drill@drill@", "drill_straight_fail", 1.0)
                Wait(500)
                --TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', "drill_straight_fail", 3.0, -8, -1, 16, 0, 0, 0, 0 )
            end)
        else
            QBCore.Functions.Notify('You do not have the required items!', "error")
        end
    end, "drill")
end)

RegisterNetEvent('bomb:Usebomb') -- Drills a full set of lockers
AddEventHandler('bomb:Usebomb', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            RequestAnimDict('anim@heists@ornate_bank@thermal_charge_heels')
			while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge_heels') do
				Citizen.Wait(50)
			end
            SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
            Wait(2000)
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            prop = CreateObject(GetHashKey('prop_ld_bomb'), x, y, z +0.2,  true,  true, true)
			AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.06, 0.0, 0.06, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"),true)
			--FreezeEntityPosition(PlayerPedId(), true)
			TaskPlayAnim(PlayerPedId(), 'anim@heists@ornate_bank@thermal_charge_heels', "thermal_charge", 3.0, -8, -1, 16, 0, 0, 0, 0 )
			Citizen.Wait(5500)
			ClearPedTasks(PlayerPedId())
			DetachEntity(prop)
            CreateObject(GetHashKey(prop), Config.VaultBomb.x, Config.VaultBomb.y, Config.VaultBomb.z, false, false, false)
            QBCore.Functions.Notify('The load will be detonated in 7 seconds.', "error")
            Wait(7000)
            DeleteEntity(prop)
            AddExplosion(Config.VaultBomb[1].x, Config.VaultBomb[1].y, Config.VaultBomb[1].z, 6, 5.0, true, false, 15.0)
            SpawnCarts()
            OpenVault()
            Wait(500)
            AddExplosion(Config.VaultBomb[1].x - 2, Config.VaultBomb[1].y - 2, Config.VaultBomb[1].z, 3, 5.0, true, false, 0.0)
            Wait(math.random(2000, 4000))
            AddExplosion(Config.VaultBomb[1].x + 1, Config.VaultBomb[1].y + 1, Config.VaultBomb[1].z, 3, 5.0, true, false, 0.0)
            --Wait(1000)
            FreezeEntityPosition(PlayerPedId(), false)
        else
            QBCore.Functions.Notify('You do not have the required items!', "error")
        end
    end, "weapon_pipebomb")
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

--Hacking Laptop Anim

function StartHackAnim(Config) -- bro i fucking give up
    local animDict = "anim@heists@ornate_bank@hack"

    RequestAnimDict(animDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("hei_p_m_bag_var22_arm_s")

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("hei_prop_hst_laptop")
        or not HasModelLoaded("hei_p_m_bag_var22_arm_s") do
        Citizen.Wait(100)
    end
    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", Config.KeycardDoors[closestDoor].animationx + 0, Config.KeycardDoors[closestDoor].animationy + 0, Config.KeycardDoors[closestDoor].animationz + 0.85) -- Animasyon kordinatları, buradan lokasyonu değiştirin // These are fixed locations so if you want to change animation location change here
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", Config.KeycardDoors[closestDoor].animationx + 0, Config.KeycardDoors[closestDoor].animationy + 0, Config.KeycardDoors[closestDoor].animationz + 0.85)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", Config.KeycardDoors[closestDoor].animationx + 0, Config.KeycardDoors[closestDoor].animationy + 0, Config.KeycardDoors[closestDoor].animationz + 0.85)
    -- part1
    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 0, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
    local laptop = CreateObject(GetHashKey("hei_prop_hst_laptop"), targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
    -- part2
    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "hack_loop", 1.5, -4.0, 10, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -80.0, 1)
    -- part3
    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, "hack_exit_laptop", 4.0, -8.0, 1)

    SetPedComponentVariation(ped, 5, 0, 0, 0) -- removes bag from ped so no 2 bags
    SetEntityHeading(ped, 63.60)

    NetworkStartSynchronisedScene(netScene)
    Citizen.Wait(5000) -- You can try editing this to make transitions perfect
    NetworkStopSynchronisedScene(netScene)

    NetworkStartSynchronisedScene(netScene2)
    Citizen.Wait(6600)
    exports['hacking']:OpenHackingGame(function(Success)
        NetworkStopSynchronisedScene(netScene2)

        NetworkStartSynchronisedScene(netScene3)
        Citizen.Wait(4300)
        NetworkStopSynchronisedScene(netScene3)

        DeleteObject(bag)
        DeleteObject(laptop)
        DeleteObject(card)
        FreezeEntityPosition(ped, false)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        if Success then
            print("Passed!")
        elseif not Success then
            print("Failed!")
            Config.KeycardDoors[closestDoor].isOpen = true
        end
    end)
end

--Cart Grab Anim

function StartGrab()
    disableinput = true
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)
    local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(100)
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
			    Citizen.Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end
	local trollyobj = Trolley
    local emptyobj = GetHashKey("hei_prop_hei_cash_trolly_03")

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end
    local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Citizen.Wait(100)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Citizen.Wait(1500)
	CashAppear()
	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Citizen.Wait(37000) -- 37000
	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	DeleteObject(trollyobj)
    DeleteEntity(trollyobj)
    Wait(100)
    PlaceObjectOnGroundProperly(NewTrolley)
    GiveCartItems()
	Citizen.Wait(1800)
	DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
    disableinput = false
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
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

function GiveLockerItems()
    TriggerServerEvent('qb-casinoheist:server:recieveLockerItem')
end

function GiveCartItems()
    TriggerServerEvent('qb-casinoheist:server:recieveCartItem')
end

function SpawnPeds()
    RequestModel("mp_m_freemode_01")
    while not HasModelLoaded("mp_m_freemode_01") do
        Wait(5)
    end
    for k, v in pairs(Config.Peds) do
        local Yew = CreatePed(5, 'mp_m_freemode_01', v.x, v.y, v.z, v.h, 1, 1)
        SetPedComponentVariation(Yew, 11, 317, 1, 0)
        --SetPedComponentVariation(Yew, 3, 16, 0, 0)
        SetPedComponentVariation(Yew, 0, math.random(0,44), 0, 0)
        SetPedComponentVariation(Yew, 2, math.random(2, 15), math.random(1,5), 0)
        SetPedComponentVariation(Yew, 8, 15, 0, 0)
        SetPedComponentVariation(Yew, 4, 10, 0, 0)
        SetPedComponentVariation(Yew, 9, 2, 0, 0)
        SetPedComponentVariation(Yew, 6, 25, 0, 0)
        SetPedComponentVariation(Yew, 13, 71, 0, 0)
        SetPedHelmet(Yew, true)
        SetPedPropIndex(Yew, 0, 88, 0, true)
        SetPedArmour(Yew, 100)
        SetPedShootRate(Yew, 500)
        SetPedCombatAttributes(Yew, 46, true)
        SetPedFleeAttributes(Yew, 0, 0)
        SetPedAsEnemy(Yew,true)
        SetPedMaxHealth(Yew, 200)
        SetPedAlertness(Yew, 3)
        SetPedCombatRange(Yew, 0)
        SetPedCombatMovement(Yew, 1)
        TaskCombatPed(Yew, PlayerPedId(), 0,16)
        GiveWeaponToPed(Yew, GetHashKey("WEAPON_CARBINERIFLE_MK2"), 5000, true, true)
        SetPedRelationshipGroupHash( Yew, GetHashKey("HATES_PLAYER"))
        SetPedDropsWeaponsWhenDead(Yew, false)
    end
end

function lol()
    local ped = PlayerPedId()
    veh = GetVehiclePedIsIn(ped, false)
    SetVehicleLivery(veh, 6)
    print(GetVehicleLivery(veh))
end
