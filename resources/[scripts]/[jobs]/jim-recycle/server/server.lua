local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	for k in pairs(Config.Prices) do if not QBCore.Shared.Items[k] then print("^5Debug^7: ^6Prices^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6"..k.."^7'") end end
	if not QBCore.Shared.Items["recyclablematerial"] then print("^5Debug^7: ^2Missing Item from ^4QBCore^7.^4Shared^7.^4Items^7: '^6recyclablematerial^7'") end
end)
---ITEM REQUIREMENT CHECKS
QBCore.Functions.CreateCallback('jim-recycle:GetRecyclable', function(source, cb)
	if QBCore.Functions.GetPlayer(source).Functions.GetItemByName("recyclablematerial") then cb(QBCore.Functions.GetPlayer(source).Functions.GetItemByName("recyclablematerial").amount)
	else cb(0) end
end)

QBCore.Functions.CreateCallback('jim-recycle:GetCash', function(source, cb)
	cb(QBCore.Functions.GetPlayer(source).Functions.GetMoney("cash"))
end)
RegisterServerEvent("jim-recycle:DoorCharge", function()
	QBCore.Functions.GetPlayer(source).Functions.RemoveMoney("cash", Config.PayAtDoor, 'Recycling: Door Charge')
end)

--- Event For Getting Recyclable Material----
RegisterServerEvent("jim-recycle:getrecyclablematerial", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = math.random(Config.RecycleAmounts.recycleMin, Config.RecycleAmounts.recycleMax)
    Player.Functions.AddItem("recyclablematerial", amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["recyclablematerial"], 'add', amount)
    Wait(500)
end)

RegisterServerEvent("jim-recycle:TradeItems", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local remAmount, min, max
	if data == 1 then
		remAmount = 1
		itemAmount = 3
		min = Config.RecycleAmounts.oneMin
		max = Config.RecycleAmounts.oneMax
	elseif data == 2 then
		remAmount = 10
		itemAmount = 5
		min = Config.RecycleAmounts.tenMin
		max = Config.RecycleAmounts.tenMax
	elseif data == 3 then
		remAmount = 100
		itemAmount = 7
		min = Config.RecycleAmounts.hundMin
		max = Config.RecycleAmounts.hundMax
	elseif data == 4 then
		remAmount = 1000
		itemAmount = 9
		min = Config.RecycleAmounts.thouMin
		max = Config.RecycleAmounts.thouMax
	end
	Player.Functions.RemoveItem("recyclablematerial", remAmount)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["recyclablematerial"], 'remove', remAmount)
	Wait(1000)
	for i = 1, itemAmount do
		randItem = Config.TradeTable[math.random(1, #Config.TradeTable)]
		local amount = math.random(min, max)
		Player.Functions.AddItem(randItem, amount)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
	end

	local chance = math.random(1, 100)
	if chance < 30 then
		Player.Functions.AddItem("cryptostick", 1, false)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["cryptostick"], "add")
		TriggerClientEvent('QBCore:Notify', src, 'You found a Crypto Stick', 'success')
	end

end)

RegisterNetEvent("jim-recycle:Selling:Mat", function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item) ~= nil then
        local amount = Player.Functions.GetItemByName(item).amount
        local pay = (amount * Config.Prices[item])
        Player.Functions.RemoveItem(item, amount)
        Player.Functions.AddMoney('cash', pay, 'Recycling: Sold Materials')
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove', amount)
        TriggerClientEvent("QBCore:Notify", src, "Payment received. Total: £"..pay, "success")
    end
end)