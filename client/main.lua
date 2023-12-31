ESX = nil
TriggerEvent(Config.ESX, function(obj) ESX = obj end)
onMission = false
Missions = {}
for i = 1, #Config.Missions, 1 do
    Missions[i] = {
        label = Config.Missions[i].Label,
        value = Config.Missions[i].Name,
        price = Config.Missions[i].Price,
        carname = Config.Missions[i].Car.Name,
        carlocation = Config.Missions[i].Car.Location
    }
end

Citizen.CreateThread(function()
    CreateBlip(Config.Ped.location, Config.Blip.Home.sprite, Config.Blip.Home.color, Config.Blip.Home.title)
    CreateBlip2(Config.Marker.location, Config.Blip.Steal.sprite, Config.Blip.Steal.color, Config.Blip.Steal
        .title)
    CreateNPC(Config.Ped.type, Config.Ped.model, Config.Ped.anim, Config.Ped.dict,Config.Ped.location,
        "Press ~INPUT_CONTEXT~ to interact with ~y~NPC", { 1, 38 }, 3,
        function()
            Citizen.Wait(500)
            
            if not onMission then
                GiveMissionMenu()
                
            else
                ShowNotification('You already have a mission')
            end
        end,
        function()
        end
    )
end)
Citizen.CreateThread(function()
    while true do
        DrawMarker(Config.Marker.type, Config.Marker.location.x, Config.Marker.location.y, Config.Marker.location.z, 0.0,
            0.0, 0.0,
            0.0, 0.0, 0.0,
            4.0, 4.0, 0.5, Config.Marker.r, Config.Marker.g, Config.Marker.b, 255, false, true, 2, nil, nil, false)
        local pedCoords = GetEntityCoords(PlayerPedId())
        local distance = Vdist(pedCoords.x, pedCoords.y, pedCoords.z, Config.Marker.location.x, Config.Marker.location.y,
            Config.Marker.location.z)
        if (distance <= 2.5) then
            ShowAlert("~b~Press ~INPUT_PICKUP~ For Sell Car")
            if (distance <= 2.5) and IsControlJustReleased(0, Config.Key) then
                local ped = PlayerPedId()
                if IsPedInVehicle(ped, MissionCar, true) then
                    DeleteMissionCar(MissionCar)
                    onMission=false
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedInVehicle(ped, MissionCar, true) then
            SetNewWaypoint(Config.Marker.location.x, Config.Marker.location.y)
            break
        end
        Citizen.Wait(0)
    end
    while true do
        FollowBlip()
        
        Citizen.Wait(0)
    end
end)
