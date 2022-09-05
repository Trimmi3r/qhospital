--- Text UI creation
--- Used if you plan on having several hospital locations
--- Create as many locations as you would like
--- Coords where the text ui will display. Ignore if you are using ox_target, just create npcs.
locations = {
	vector3(295.52, -1447.12, 29.96),
	--[[
	vector3(0, 0, 0),
	vector3(0, 0, 0),
	--]]
}

--- NPC creation
--- Used if you plan on having several hospital locations
--- Create as many npcs as you would like
--- Change to your liking. don't touch anything else if you don't know what you are doing.
local npc = {}
local ped = {
	{
		name = "hospital-1",
		model = config.npc.model,
		coords = vector3(294.64, -1448.2, 28.96),
		heading = 320.2867,
		gender = "male",
	},
	--[[
	{
	{
		name = "hospital-2",
		model = config.npc.model,
		coords = vector3(0, 0, 0),
		heading = 0,
		gender = "male",
	},
	{
	{
		name = "hospital-3",
		model = config.npc.model,
		coords = vector3(0, 0, 0),
		heading = 0,
		gender = "male",
	},
	--]]
}

for i = 1, #ped do
	local pedZones = lib.points.new(ped[i].coords, 30, { zone = k, data = ped[i] })

	function pedZones:onEnter()
		lib.requestModel(self.data.model)
		if self.data.gender == "male" then
			gender = 4
		elseif self.data.gender == "female" then
			gender = 5
		end

		npc[i] = CreatePed(
			gender,
			self.data.model,
			self.data.coords.x,
			self.data.coords.y,
			self.data.coords.z,
			self.data.heading,
			false,
			false
		)
		FreezeEntityPosition(npc[i], true)
		SetEntityInvincible(npc[i], true)
		SetBlockingOfNonTemporaryEvents(npc[i], true)
	end

	function pedZones:onExit()
		DeletePed(npc[i])
	end
end

--- Blip creation
--- Used if you plan on having several hospital locations
--- Create as many map blips as you would like
--- Change to your liking. reference: https://docs.fivem.net/docs/game-references/blips/
local blips = {
	{ title = "Medical Center", color = 23, id = 61, size = 0.7, x = 295.48, y = -1447.24, z = 29.96 },
	--[[
	{ title = "Pillbox Hospital", color = 0, id = 0, size = 0, x = 0, y = 0, z = 0 },
	{ title = "Ocean Medical Center", color = 0, id = 0, size = 0, x = 0, y = 0, z = 0 },
	--]]
}

CreateThread(function()
	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, info.size)
		SetBlipColour(info.blip, info.color)
		SetBlipAsShortRange(info.blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)
