local oxTarget = GetConvar("ox_enableTarget", "false") == "true"

local function hospitalContext()
	local options = {}

	table.insert(options, {
		title = "Medical Treatment",
		description = "A procedure, or regimen, such as a drug, surgery, or exercise, in an attempt to cure or mitigate a disease, condition, or injury.",
		metadata = { "You will feel dizzy, and nauseous for a short period of time after the procedure." },
		event = "qhospital:client:treatment",
	})

	table.insert(options, {
		title = "Need a bandage?",
		description = "Buy a strip of material used to bind a wound or to protect an injured part of the body.",
		metadata = { "This seems like a better idea, yea?" },
		event = "qhospital:client:bandage",
	})

	lib.registerContext({
		id = "hospital_menu",
		title = "Medical Center",
		options = options,
	})

	lib.showContext("hospital_menu")
end

if not oxTarget then
	for i = 1, #locations do
		local location = locations[i]
		local point = lib.points.new(location, 1.5)

		function point:onEnter()
			lib.showTextUI("[E] - Access hospital")
		end

		function point:onExit()
			lib.hideTextUI()
		end

		function point:nearby()
			if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
				hospitalContext()
			end
		end
	end
else
	exports.ox_target:addModel(config.npc.model, {
		{
			name = "target_menu",
			icon = "fas fa-sign-in-alt",
			label = "Access hospital",
			onSelect = function()
				hospitalContext()
			end,
		},
	})
end

function startPlayerTreatment()
	if
		lib.progressCircle({
			duration = 5000,
			position = "bottom",
			label = "Signing in..",
			disable = { move = true },
			anim = { dict = config.treatment.dict, clip = config.treatment.anim },
		})
	then
		SetEntityHealth(cache.ped, 200)
		lib.defaultNotify({
			status = "success",
			title = "Medical Center",
			position = "top",
			description = "You have successfully been treated and can go on your way.",
		})
	end
end

RegisterNetEvent("qhospital:client:treatment", function()
	if config.treatment.costmoney then
		lib.callback("qhospital:server:treatment", false, function(success)
			if success then
				startPlayerTreatment()
			end
		end)
	elseif not config.treatment.costmoney then
		startPlayerTreatment()
	end
end)

RegisterNetEvent("qhospital:client:bandage", function()
	lib.callback("qhospital:server:bandage", false, function(success)
		if success then
			print("bandage purchased")
		elseif not success then
			print("your broke")
		end
	end)
end)

--- Debug
if config.general.debug then
	RegisterCommand("debug:menu", function()
		hospitalContext()
		print("[DEBUG]: context menu loaded")
	end)
end
