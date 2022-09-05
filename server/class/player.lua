CState = {}
Data = {}

function CState:get(entityId, stateBag)
	local player = Player(entityId)
	return player.state[stateBag]
end

function CState:set(entityId, stateBag, bool, replicated)
	local player = Player(entityId)

	if replicated == nil then
		replicated = false
	end

	player.state:set(stateBag, bool, replicated)
end

Data.playerStates = {
	"isBleeding",
}

for i = 1, #Data.playerStates do
	local state = Data.playerStates[i]
	AddStateBagChangeHandler(state, false, function(bagName, key, value, source, replicated)
		local playerNet = tonumber(bagName:gsub("player:", ""), 10)
		print("bagName: [" .. key .. "] value: [" .. tostring(value) .. "] replicated: [" .. tostring(replicated) .. "]")
		print(playerNet)
	end)
end

--- Todo: finish
lib.callback.register("qhospital:server:fetchStatus", function(source)
	local player = Ox.GetPlayer(source)
	if not player then return end

	print(player, "fetch?")
end)