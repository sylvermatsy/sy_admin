ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('SY_ADMIN:getgroup', function(source, cb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    cb(xPlayer.getGroup())
end)

RegisterNetEvent('SY_ADMIN:kick')
AddEventHandler('SY_ADMIN:kick', function(id, reason)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.kick(("Kick par : %s \nRaison: %s"):format(xPlayer.getName(), reason))
end)

RegisterNetEvent('SY_ADMIN:setjob')
AddEventHandler('SY_ADMIN:setjob', function(id, job, grade)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.setJob(job, grade)
end)

RegisterNetEvent('SY_ADMIN:setjob2')
AddEventHandler('SY_ADMIN:setjob2', function(id, job, grade)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.setJob2(job, grade)
end)

RegisterNetEvent('SY_ADMIN:givecargarage')
AddEventHandler('SY_ADMIN:givecargarage', function(vehicleProps, id)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
        ['@owner']   = tPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps)
    }, function(rowsChange)
        TriggerClientEvent('esx:showNotification', tPlayer, "~g~Tu as reçu un véhicule dans ton garage !~s~")
    end)
end)

local resultItemS = {}
RegisterNetEvent('SY_ADMIN:getItem')
AddEventHandler('SY_ADMIN:getItem', function()
    local source = source
    MySQL.Async.fetchAll("SELECT name, label FROM items", {}, function(result)
        if (result) then
            for k,v in pairs(result) do
                resultItemS = result
                TriggerClientEvent('SY_ADMIN:resultItem', source, resultItemS)
            end
        end
    end)
end)

RegisterNetEvent('SY_ADMIN:giveitem')
AddEventHandler('SY_ADMIN:giveitem', function(id, name, qtty)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.addInventoryItem(name, qtty)
end)

RegisterNetEvent('SY_ADMIN:autogiveitem')
AddEventHandler('SY_ADMIN:autogiveitem', function(name, qtty)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    xPlayer.addInventoryItem(name, qtty)
end)

ESX.RegisterServerCallback('SY_ADMIN:getOtherPlayerData', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
        }

        cb(data)
    end
end)



RegisterNetEvent('SY_ADMIN:crash')
AddEventHandler('SY_ADMIN:crash', function(id) 
    local source = source if source ~= nil then TriggerClientEvent('SY_ADMIN:crashplayer', id) end 
end)

RegisterNetEvent('SY_ADMIN:reviveS')
AddEventHandler('SY_ADMIN:reviveS', function(id) 
    local source = source if source ~= nil then TriggerClientEvent('SY_ADMIN:revive', id) end 
end)

RegisterNetEvent('SY_ADMIN:reviveall')
AddEventHandler('SY_ADMIN:reviveall', function()
    local source = source if source ~= nil then TriggerClientEvent('SY_ADMIN:revive', -1) end
end)

RegisterNetEvent('SY_ADMIN:prendre_report')
AddEventHandler('SY_ADMIN:prendre_report', function(nom)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end

    local xPlayers = ESX.GetPlayers()
    local staff = xPlayer.getName()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        for _,v in pairs(Admin.Acces.General) do
            if (xPlayer.getGroup()) == v then
                TriggerClientEvent('SY_ADMIN:reportpris', xPlayers[i], nom, staff)
            end
        end
    end
end)

RegisterNetEvent('SY_ADMIN:givemoneybank')
AddEventHandler('SY_ADMIN:givemoneybank', function(id, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)
    amount = tonumber(amount)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.addAccountMoney('bank', amount)
end)

RegisterNetEvent('SY_ADMIN:givemoneycash')
AddEventHandler('SY_ADMIN:givemoneycash', function(id, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)
    amount = tonumber(amount)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.addMoney(amount)
end)

RegisterNetEvent('SY_ADMIN:givemoneysale')
AddEventHandler('SY_ADMIN:givemoneysale', function(id, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)
    amount = tonumber(amount)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.addAccountMoney('black_money', amount)
end)

RegisterNetEvent('SY_ADMIN:freezeS')
AddEventHandler('SY_ADMIN:freezeS', function(id, number) TriggerClientEvent('SY_ADMIN:freeze', id, number) end)
RegisterNetEvent('SY_ADMIN:slapS')
AddEventHandler('SY_ADMIN:slapS', function(id) TriggerClientEvent('SY_ADMIN:slap', id) end)
RegisterNetEvent('SY_ADMIN:healS')
AddEventHandler('SY_ADMIN:healS', function(id) TriggerClientEvent('SY_ADMIN:heal', id) end)

RegisterNetEvent('SY_ADMIN:spawncar')
AddEventHandler('SY_ADMIN:spawncar', function(type)
    TriggerClientEvent('SY_ADMIN:spwan', source, type)
end)

RegisterNetEvent('SY_ADMIN:tpS')
AddEventHandler('SY_ADMIN:tpS', function(id, pos)
    TriggerClientEvent('SY_ADMIN:tp', id, pos)
end)

RegisterNetEvent('SY_ADMIN:removeinventory')
AddEventHandler('SY_ADMIN:removeinventory', function(id, name, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)
    amount = tonumber(amount)

    if (not xPlayer) then return end if (not tPlayer) then return end
    if (tPlayer.getInventoryItem(name).count) >= amount then
        tPlayer.removeInventoryItem(name, amount)
        xPlayer.addInventoryItem(name, amount)
        TriggerClientEvent('esx:showNotification', source, 'Remove effectué avec ~g~succès~s~.')
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Le joueur n\'a pas autant !')
    end
end)