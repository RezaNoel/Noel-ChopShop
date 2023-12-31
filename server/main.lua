ESX = nil
TriggerEvent(Config.ESX, function(obj) ESX = obj end)

RegisterServerEvent('noelchopshop:givemoney')
AddEventHandler('noelchopshop:givemoney', function(target, amount)
    local _source = target
    local xPlayer = ESX.GetPlayerFromId(_source)
    amount = tonumber(amount)
    if not tonumber(amount) then return end
    amount = ESX.Math.Round(amount)
    xPlayer.addMoney(amount)
end)