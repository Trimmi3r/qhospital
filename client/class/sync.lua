local CState = {}
local playerLoaded = false

function CState:set(state, bool, replicated)
	LocalPlayer.state:set(state, bool, replicated)
end

--- Todo: finish
RegisterNetEvent("ox:playerLoaded", function()
	playerLoaded = true
	lib.callback("qhospital:server:fetchStatus", false, function(data)
		if data then
			for k, v in pairs(data) do
				CState:fetch(k, v)
			end
		end
	end)
end)

AddEventHandler("ox:playerLogout", function()
	playerLoaded = false
	for k, v in pairs(player.Status) do
		local status = player(k)
		CState:store()
	end
end)
--- end

function CState:bleeding()
	local health = GetEntityHealth(cache.ped)
	local ped = cache.ped

	if health <= 150 then
		CState:set("isBleeding", true, true)
		SetEntityHealth(ped, health - 1)

		lib.defaultNotify({
			status = "error",
			title = "",
			position = "top",
			description = "You need medical attention, visit the Medical Center.",
		})

		lib.requestAnimSet(config.bleeding.anim)
		SetPedMovementClipset(ped, config.bleeding.anim, true)
		ShakeGameplayCam(config.bleeding.effect, config.bleeding.intensity)

		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(100)
		end
		DoScreenFadeIn(500)

	elseif health >= 175 then
		CState:set("isBleeding", false, true)
		ResetPedMovementClipset(ped, 0)
		ResetPedStrafeClipset(ped, 0)
		StopAllScreenEffects(ped)
	end
end

if config.bleeding.set then
	SetInterval(function()
		CState:bleeding()
		Wait(2600)
	end)
end

--- Debug
if config.general.debug then
	RegisterCommand("debug:bleed", function()
		SetEntityHealth(cache.ped, 130)
		print("[DEBUG]: health set: 130")
	end)

	RegisterCommand("debug:heal", function()
		SetEntityHealth(cache.ped, 200)
		print("[DEBUG]: health set: 200")
	end)
end
