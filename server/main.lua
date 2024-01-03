ESX = nil
TriggerEvent(Config.ESX, function(obj) ESX = obj end)

RegisterServerEvent('noelchopshop:givemoney')
AddEventHandler('noelchopshop:givemoney', function(target, amount)
    local _source = target
    local xPlayer = ESX.GetPlayerFromId(_source)
    amount = tonumber(amount)
    if not tonumber(amount) then return end
    amount = ESX.Math.Round(amount)
    if Config.Money.Cash == true then
        xPlayer.addAccountMoney('cash', amount)
    elseif Config.Money.Bank == true then
        xPlayer.addAccountMoney('bank', amount)
    elseif Config.Money.Black == true then
        xPlayer.addAccountMoney('black_money', amount)
    else
        TriggerClientEvent('esx:showNotification', source, 'Set cashout way in Config.')
    end
end)
