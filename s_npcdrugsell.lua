ESX.RegisterServerCallback('drugitem', function(source, cb)
	local items = exports.ox_inventory:Search(source, 'count', {'drug_opium_pack', 'drug_cocaine_pack', 'drug_meth_pack'})
	cb(items)
end)

function confirmsell()
    local amount = math.random(1,2)
    if amount == 1 then 
        return true 
    else
        return false
    end
end

local drugname = {
    ['drug_meth_pack'] = 450,
    ['drug_opium_pack'] = 250,
    ['drug_cocaine_pack'] = 470,
}

RegisterServerEvent('initialprice', function(i, deal)
    local x = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    local coords = x.getCoords(true)
    if drugname[i] then
        if confirmsell() then
            if exports.ox_inventory:Search(source, 'count', i) >= 1 then 
                exports.ox_inventory:RemoveItem(source, i, 10)
                exports.ox_inventory:AddItem(source, 'black_money', drugname[i])
            else 
                TriggerClientEvent('ox_lib:defaultNotify',source, {title = 'Drug Selling', description = 'You don\'t have enough' .. i .. ' on me', status = 'error'})

            end
        else
            for j=1, #xPlayers, 1 do
                local xPlayerx = xPlayers[j]
                TriggerClientEvent('sho_npcdrugsell:PoliceAlert', xPlayerx.source, coords)
            end
            TriggerClientEvent('ox_lib:defaultNotify',source, {title = 'Police', description = 'Police are alerted!', status = 'info'})
        end
    end
end)
