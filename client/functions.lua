
ActiveMission = nil
MissionCar = nil
function ShowAlert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ShowNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end
function CreateNewCar(Car, Location)
    -- Variables
    local Heading = Location.h
    local CarHash = GetHashKey(Car)
    RequestModel(CarHash)
    MissionCar = CreateVehicle(CarHash, Location.x, Location.y, Location.z, Heading, 1, 0)
    SetNewWaypoint(Location.x, Location.y)
end
function CreateBlip(location,sprite,color,title)
    -- Create the blip
    blip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite(blip, sprite)
    SetBlipScale(blip,1.0)
    SetBlipColour(blip,color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(title)
    EndTextCommandSetBlipName(blip)

end
function CreateBlip2(location, sprite, color, title)
    -- Create the blip
    blip2 = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite(blip2, sprite)
    SetBlipScale(blip2, 1.0)
    SetBlipColour(blip2, color)
    SetBlipAsShortRange(blip2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(title)
    EndTextCommandSetBlipName(blip2)
end


function FollowBlip()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(PlayerPedId())
    if IsPedInVehicle(ped, MissionCar, true) then
        RemoveBlip(blip)
        CreateBlip(pedCoords, Config.Blip.Car.sprite,Config.Blip.Car.color,Config.Blip.Car.title)
    end

end
function GiveMissionMenu()
    ESX.UI.Menu.CloseAll()
    for i = 1, #Missions, 1 do
        RequestModel(GetHashKey(Missions[i].carname))
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'chopshopmenu', {
            title = 'Chop Shop',
            align = 'top-left',
            elements = Missions
        },
        function(data, menu)
            for i = 1, #Missions, 1 do
                if data.current.value == Missions[i].value then
                    menu.close()
                    ActiveMission=Missions[i]
                    CreateNewCar(Missions[i].carname, Missions[i].carlocation)
                    CreateBlip(Missions[i].carlocation, Config.Blip.Car.sprite, Config.Blip.Car.color,
                        Config.Blip.Car.title)
                    onMission = true
                end
                
            end
            menu.close()
        end, function(data, menu) menu.close() end)
end
function CreateNPC(type, model, anim, dict, pos, help, key, range, start, finish)
    Citizen.CreateThread(function()
        -- Define variables
        local hash = GetHashKey(model)
        local talking = false

        -- Loads model
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(1)
        end

        -- Loads animation
        RequestAnimDict(anim)
        while not HasAnimDictLoaded(anim) do
            Wait(1)
        end

        -- Creates ped when everything is loaded
        local ped = CreatePed(type, hash, pos.x, pos.y, pos.z, pos.h, false, true)
        SetEntityHeading(ped, pos.h)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskPlayAnim(ped, anim, dict, 8.0, 0.0, -1, 1, 0, 0, 0, 0)

        -- Process NPC interaction
        while true do
            Citizen.Wait(0)
            local your = GetEntityCoords(GetPlayerPed(-1), false)
            if (Vdist(pos.x, pos.y, pos.z, your.x, your.y, your.z) < range) then
                SetTextComponentFormat("STRING")
                AddTextComponentString(help)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if (IsControlJustReleased(key[1], key[2])) then
                    if not talking then
                        talking = true
                        start()
                    else
                        talking = false
                        finish()
                    end
                end
            end
        end
    end)
end

function DeleteMissionCar()
    local Ped = GetPlayerPed(-1)
    --Delete Current Car
    local CarHash = GetHashKey(MissionCar)
    RequestModel(CarHash)
    local LastCarPedIsIn = GetVehiclePedIsIn(Ped, false)
    if LastCarPedIsIn then
        DeleteVehicle(LastCarPedIsIn)
    end
    for i = 1, #Missions, 1 do
        if ActiveMission==Missions[i] then
            TriggerServerEvent("noelchopshop:givemoney", GetPlayerServerId(PlayerId()), Missions[i].price)
            ShowNotification('Car sold and you got '..Missions[i].price..'$')
            ActiveMission = nil
            MissionCar= nil
            RemoveBlip(blip)
        end
    end
end
