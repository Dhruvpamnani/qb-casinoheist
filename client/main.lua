Config = Config or {}

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload",function() 
    isLoggedIn = false 
end)

Citizen.CreateThread(function()
    local model = "hei_prop_hei_cash_trolly_01"
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model) Citizen.Wait(100) end
    local trolley1 = CreateObject(model, Config.Trolleys[1].x, Config.Trolleys[1].y, Config.Trolleys[1].z, true, true, false)
    local trolley2 = CreateObject(model, Config.Trolleys[2].x, Config.Trolleys[2].y, Config.Trolleys[2].z, true, true, false)
    local trolley3 = CreateObject(model, Config.Trolleys[3].x, Config.Trolleys[3].y, Config.Trolleys[3].z, true, true, false)
    PlaceObjectOnGroundProperly(trolley1)
    PlaceObjectOnGroundProperly(trolley2)
    PlaceObjectOnGroundProperly(trolley3)
end)

Citizen.CreateThread(function() -- Blows Up the main vault door
    Citizen.Wait(2000)
    local requiredItems = {
        [1] = {name = QBCore.Shared.Items["electronickit"]["name"], image = QBCore.Shared.Items["electronickit"]["image"]},
        [2] = {name = QBCore.Shared.Items["trojan_usb"]["name"], image = QBCore.Shared.Items["trojan_usb"]["image"]},
    }
    local requiredItems2 = {
        [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
    }
end)