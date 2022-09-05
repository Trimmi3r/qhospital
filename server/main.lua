local ox_inventory = exports.ox_inventory
GlobalState.hospitalState = true

lib.callback.register("qhospital:server:treatment", function(source)
	local player = Ox.GetPlayer(source)
	if not player then return end

	if not GlobalState.hospitalState then return end

	local entityId = source
	local playerState = CState:get(entityId, "isBleeding")

	if not playerState then
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "error",
			title = "Medical Center",
			position = "top",
			description = "You do not need medical attention at the moment",
		})
		print(entityId, playerState)

		return
	end

	local src = source
	local cache = nil

	if ox_inventory:GetItem(src, config.treatment.item).count >= config.treatment.price then
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "success",
			title = "Medical Center",
			position = "top",
			description = "You were billed by the Medical Center.",
		})
		ox_inventory:RemoveItem(src, config.treatment.item, config.treatment.price)
		cache = true
	else
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "error",
			title = "Medical Center",
			position = "top",
			description = "You do not have enough cash, please visit the local bank.",
		})
		cache = false
	end

	while cache == nil do
		Wait(50)
	end

	return cache
end)

lib.callback.register("qhospital:server:bandage", function(source)
	local player = Ox.GetPlayer(source)
	if not player then return end

	if not GlobalState.hospitalState then return end

	local src = source
	local cache = nil

	if ox_inventory:GetItem(src, config.treatment.item).count >= 300 then
		ox_inventory:RemoveItem(src, config.treatment.item, config.bandage.price)
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "success",
			title = "Medical Center",
			position = "top",
			description = "You have successfully purchased a bandage.",
		})
		ox_inventory:AddItem(src, config.bandage.item, 1)
		cache = true
	else
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "error",
			title = "Medical Center",
			position = "top",
			description = "You do not have enough cash, please visit the local bank.",
		})
		cache = false
	end

	while cache == nil do
		Wait(50)
	end

	return cache
end)

lib.addCommand("group.admin", "toggle:hospital", function(args, source)
	local player = Ox.GetPlayer(source)
	if not player then return end

	GlobalState.hospitalState = not GlobalState.hospitalState

	local hospitalState = GlobalState.hospitalState and "open" or "closed"

	TriggerClientEvent("chat:addMessage", -1, {
		template = '<div class="chat-message text-system"><span class="text-white">[SYSTEM]: Local Medical Center is now {0}.</span></div>',
		args = { hospitalState },
	})
end)