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
    for i = 1, 3 do
        local obj = GetClosestObjectOfType(Config.Trolleys[i].x, Config.Trolleys[i].y, Config.Trolleys[i].z, 1, GetHashKey(model), true, true, false)
        print(obj)
        if DoesEntityExist(obj) then
            print(1)
            DeleteEntity(obj) -- SHOULD DELETE CARTS
        end
    end
    local trolley1 = CreateObject(model, Config.Trolleys[1].x, Config.Trolleys[1].y, Config.Trolleys[1].z, true, true, false)
    local trolley2 = CreateObject(model, Config.Trolleys[2].x, Config.Trolleys[2].y, Config.Trolleys[2].z, true, true, false)
    local trolley3 = CreateObject(model, Config.Trolleys[3].x, Config.Trolleys[3].y, Config.Trolleys[3].z, true, true, false)
end)

Citizen.CreateThread(function() -- Blows Up the main vault door i guess maybe idk
    Citizen.Wait(2000)
    local requiredItems = {
        [1] = {name = QBCore.Shared.Items["electronickit"]["name"], image = QBCore.Shared.Items["electronickit"]["image"]},
        [2] = {name = QBCore.Shared.Items["trojan_usb"]["name"], image = QBCore.Shared.Items["trojan_usb"]["image"]},
    }
    local requiredItems2 = {
        [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
    }
end)

Citizen.CreateThread(function()
    while true do
        DrawMarker(2, Config.KeycardDoors[1].x, Config.KeycardDoors[1].z, Config.KeycardDoors[1].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
    end
end)