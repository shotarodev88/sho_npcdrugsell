local sell = {}

exports.qtarget:Ped({
    options = {
        {
            action = function(entity)
                drugsellmenu()
                sell[entity] = true
            end,
			icon = "fas fa-box-circle-check",
            label = "Sell Drugs",
            canInteract = function(entity)
                if IsPedDeadOrDying(entity, true) or IsPedAPlayer(entity) or IsEntityPositionFrozen(entity) or FreezeEntityPosition(ped,true)  or  sell[entity] then return false end
                return true
            end, 
        },
    },
    distance = 2.0
})

CreateThread(function() --if you want the table to be emptied after a certain time
     while true do 
         Wait(20000)
         if sell then 
             for k in pairs(sell) do 
                 sell[k] = nil
             end
         end
     end
end)



function drugsellmenu()
    ESX.TriggerServerCallback('drugitem', function(amountprice) 
    lib.registerContext({
        id = 'drugdealerfunction',
        title = 'Sell Packaged Drugs',
        options = {
            {
                title = 'Sell Meth',
                event = 'selldrugs',
                args = 'drug_meth_pack',
                metadata = {
                    {label = 'Amount', value = amountprice.drug_meth_pack},
                }
            },
            {
                title = 'Sell Opium',
                event = 'selldrugs',
                args = "drug_opium_pack",
                metadata = {
                    {label = 'Amount', value = amountprice.drug_opium_pack},
                }
            },
            {
                title = 'Sell Cocaine',
                event = 'selldrugs',
                args = "drug_cocaine_pack",
                metadata = {
                    {label = 'Amount', value = amountprice.drug_cocaine_pack},
                }
            },
        },
    })
    lib.showContext('drugdealerfunction')
end)
end



AddEventHandler('selldrugs', function(args)
    local i = args
    local pid = PlayerPedId()
    if i then
        lib.defaultNotify({
            title = '',
            description = 'Selling packaged drugs...',
            status = 'info'
        })
        lib.progressCircle(
            {
            duration = "3000",
            position = "bottom",
            useWhileDead = false,
            disable = {
                move = true,
                combat = true,
                car = true
            },
            anim = {
                dict = 'amb@prop_human_bum_bin@idle_b', 
                clip = 'idle_d'
            }
            }
        )
        TriggerServerEvent('initialprice', i)
    end
end)



RegisterNetEvent("sho_npcdrugsell:PoliceAlert")
AddEventHandler("sho_npcdrugsell:PoliceAlert", function(coords)
    lib.showTextUI('Selling drugs inprogress..', {
        position = "top-center",
        icon = 'drug_opium_pack',
        style = {
            borderRadius = 0,
            backgroundColor = 'red',
            color = 'white',
            
        }
    })
    Wait(5000)
    lib.hideTextUI()
    TriggerEvent('sho_npcdrugsell:PoliceAlert:blipPolice', coords)
end)


RegisterNetEvent("sho_npcdrugsell:PoliceAlert:blipPolice")
AddEventHandler("sho_npcdrugsell:PoliceAlert:blipPolice", function(coords)
    local alertblip = AddBlipForCoord(coords.x,coords.y,coords.z)
    SetBlipSprite(alertblip, 161)
    SetBlipScale(alertblip, 2.0)
    SetBlipColour(alertblip, 5)
    PulseBlip(alertblip)
    Wait(50000)
    RemoveBlip(alertblip)
end)