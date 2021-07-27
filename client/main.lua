Config = Config or {}
local inRange = false
local closestBank = nil
local cartsUp = false
local isLoggedIn = false

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
        local cart = CreateObject(model, Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, true, true, false) 
    end
end

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i = 1, 4 do  --Note: see if we can remove all the for loops and replace with the [closestDoor] see line 278 for what im talking about
            local dist = #(pos - vector3(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z))
            if dist < 1 and not Config.KeycardDoors[i].isOpen then
                DrawText3Ds(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z + 0.3, '[~b~E~s~] Hack')
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

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i = 1, 3 do
            local dist = #(pos - vector3(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z))
            if dist < 3 then
                inRange = true
                DrawText3Ds(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z + 0.5, '[~b~E~s~] Take')
            elseif dist < 3 then
                DrawText3Ds(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z + 0.5, '~r~ Empty')
            end
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
            elseif dist < 1 and Config.DrillSpots[i].hit then
                DrawText3Ds(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z + 0.2, '~r~ Empty')
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
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for i = 1, 3 do
            local dist = #(pos - vector3(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z))
            if dist < 3 then
                if IsControlJustPressed(0, 38) then
                    StartGrab()
                    print("test")
                end
            end
        end
        Wait(1)
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for i = 1, 4 do
            local dist = #(pos - vector3(Config.KeycardDoors[i].x, Config.KeycardDoors[i].y, Config.KeycardDoors[i].z))
            if dist < 1 and not Config.KeycardDoors[i].isOpen then
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('security_card_02:Usesecurity_card_02')
                    SpawnCarts()
                end
            end
        end
        Wait(1)
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for i = 1, 4 do
            local dist = #(pos - vector3(Config.DrillSpots[i].x, Config.DrillSpots[i].y, Config.DrillSpots[i].z))
            if dist < 1 and not Config.DrillSpots[i].hit then
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('drill:Usedrill')
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
            TriggerServerEvent("QBCore:Server:RemoveItem", "electronickit", 1)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["security_card_02"], "remove")
            --TriggerServerEvent("QBCore:Server:RemoveItem", "security_card_02", 1)
            SetEntityHeading(ped, Config.KeycardDoors[closestDoor].h)
            StartHackAnim(Config)
            QBCore.Functions.Progressbar("open_door", "Connecting...", 3000, false, true, {
                disableMovement = true, 
                disableCarMovement = true, 
                disableMouse = false, 
                disableCombat = true,
            }, {}, {}, {}, function() -- Done]]
                TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
                Citizen.Wait(2000)
                ClearPedTasksImmediately(ped)
                --TriggerEvent("mhacking:show")
                --TriggerEvent("mhacking:start", Config.HackingSquare, Config.HackingTime, OnHackDone)
            end)
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
            local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
            AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
            QBCore.Functions.Progressbar("drill_lock", "Drilling", math.random(10000, 30000), false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@heists@fleeca_bank@drilling",
                anim = "drill_straight_start",
                flags = 1,
            }, {}, {}, function() -- Done
                GiveLockerItems()
                DetachEntity(DrillObject, true, true)
                DeleteObject(DrillObject)
                StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_start", 1.0)
            end)
        else
            QBCore.Functions.Notify('You do not have the required items!', "error")
        end
    end, "drill")
end)

function OnHackDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        QBCore.Functions.Notify('Success, your in!', "success")
        Config.KeycardDoors[closestDoor].isOpen = true
    else
		TriggerEvent('mhacking:hide')
        QBCore.Functions.Notify('Failed!', "error")
	end
end

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
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 0, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
    local laptop = CreateObject(GetHashKey("hei_prop_hst_laptop"), targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
    -- part2
    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "hack_loop", 1.5, -4.0, 10, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -80.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -80.0, 1)
    -- part3
    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
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
    NetworkStopSynchronisedScene(netScene2)

    NetworkStartSynchronisedScene(netScene3)
    Citizen.Wait(4300)
    NetworkStopSynchronisedScene(netScene3)

    DeleteObject(bag)
    DeleteObject(laptop)
    DeleteObject(card)
    FreezeEntityPosition(ped, false)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
end











--Cart Grab Anim

function StartGrab(name)
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
	Citizen.Wait(37000)
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
    PlaceObjectOnGroundProperly(NewTrolley)
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