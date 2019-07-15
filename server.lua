ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_scrap:checkVeh')
AddEventHandler('esx_scrap:checkVeh', function(source, playerVeh)
    local identifier = GetPlayerIdentifiers(source)[1]
    MySQL.Async.fetchAll("SELECT * FROM `esx_scrap` WHERE `vehicle` = @playerVeh", {
		['@playerVeh'] = playerVeh
	}, function(result)

        if result[1] ~= nil then
            local data = {
                vehicle = result[1].vehicle,
                multiplier = result[1].multiplier
                
            }
            TriggerEvent('esx_scrap:processVehicle', source, data)

        else
            local data = {
                vehicle = '',
                multiplier = ''
                
            }
		end
	end)
end)

RegisterServerEvent('esx_scrap:processVehicle')
AddEventHandler('esx_scrap:processVehicle', function(source, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local divider = math.random(50,100)
    local mOne = (100 * data.multiplier) / divider
    local randomizer = math.random(0,2)
    if randomizer == 0 then
        xPlayer.addInventoryItem('steel', round(mOne))
    elseif randomizer == 1 then
        xPlayer.addInventoryItem('plastic', round(mOne))
    elseif randomizer == 2 then
        xPlayer.addInventoryItem('electronics', round(mOne))
    end

    TriggerClientEvent('esx_scrap:handleVehicle', source)

end)

function round(mOne)
    return math.floor((math.floor(mOne*2) + 1)/2)
  end