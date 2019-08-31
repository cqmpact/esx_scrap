ESX = nil
local playerID = GetPlayerServerId(PlayerId())
local CurrentAction, CurrentActionMsg, hasAlreadyEnteredMarker, lastZone, currentZone

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_scrap:handleVehicle')
AddEventHandler('esx_scrap:handleVehicle', function()
    vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId()), false)
    ESX.Game.DeleteVehicle(vehicle)
end)

AddEventHandler('esx_scrap:hasEnteredMarker', function(zone)
	CurrentAction     = 'scrap_vehicle'
	CurrentActionMsg  = 'Press ~INPUT_PICKUP~ to scrap vehicle.'
end)

AddEventHandler('esx_scrap:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, isInMarker, letSleep, currentZone = GetEntityCoords(PlayerPedId()), false, true
            -- Calculating the distance between the user and the location
            local distance = #(playerCoords - vector3(1117.34, 55.55, 80.76))

			if distance < 15 then
                letSleep = false
                -- Marker for location
				DrawMarker(20, 1117.34, 55.55, 80.76, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 204, 204, 0, 100, false, true, 2, false, nil, nil, false)

				if distance < 3 then
					isInMarker = true
				end
            end

		if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
			hasAlreadyEnteredMarker, lastZone = true, currentZone
			TriggerEvent('esx_scrap:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_scrap:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(1, 38) then
				if CurrentAction == 'scrap_vehicle' then
				    vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId()), false)
				    model = GetEntityModel(vehicle)
				    playerVeh = GetDisplayNameFromVehicleModel(model)
				    if playerVeh ~= 'CARNOTFOUND' and GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(GetPlayerFromServerId()) then
					TriggerServerEvent('esx_scrap:checkVeh', playerID, playerVeh)
				    else
					ESX.ShowNotification('You need to be inside a vehicle!')
				    end
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
