local inDashcam = false
local gettingSpeed = false
local createdCam = nil
local lastLocation = nil
local distance = 0
local timeStarted = 0
local currentTime = 0
local language = 'en'

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end

	CreateThread(function()
		Wait(100)
		language = Config.Language;
		if Config.Locales[language] == nil then
			print("gs_dashcam: The initialized language does not exist, selecting English language instead!")
			language = 'en'
		end

		SendNUIMessage({
			action = 'initializeLanguage',
			locale = Config.Locales[language]
		})
	end)
end)

function OpenDashcamOverlay()
	SendNUIMessage({
		action = 'showMenu',
	})
end

function CloseDashcamOverlay()
	SendNUIMessage({
		action = 'hideMenu'
	})
end

RegisterNUICallback('CloseNUI', function(data, cb)
	CloseDashcamOverlay()
end)

CreateThread(function()
	while true do
		Wait(0)

		-- Ensure the player has the required job. If you are using a different framework, change the line below to the corresponding framework.
		if ESX ~= nil and (ESX.PlayerData.job == nil or (Config.RequiredJob and ESX.PlayerData.job.name ~= Config.RequiredJob)) then
			if inDashcam then CloseDashcam() end
			Wait(1000)
			goto skip_loop
		end

		-- Check if the ped is in a vehicle in order to operate the dashcam
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)
		if vehicle == nil then
			if inDashcam then CloseDashcam() end
			Wait(1000)
			goto skip_loop
		end

		-- Check if the player is driving the vehicle, or he is the co-driver (if enabled in the config)
		if GetPedInVehicleSeat(vehicle, -1) ~= ped and (Config.CoDriver and GetPedInVehicleSeat(vehicle, 0) ~= ped) then
			if inDashcam then CloseDashcam() end
			Wait(1000)
			goto skip_loop
		end

		-- Check if the vehicle has a dashcam enabled in the config
		local vehicleHasDashCam = Config.Vehicles[GetEntityModel(vehicle)]
		if not vehicleHasDashCam then
			if inDashcam then CloseDashcam() end
			Wait(1000)
			goto skip_loop
		end

		-- Disable the dashcam on keyrelease
		if inDashcam then
			if IsControlJustReleased(0, Config.ToggleDashcamKeybind) then
				CloseDashcam()
			end

			-- Enable the dashcam on keyrelease
		elseif IsControlJustReleased(0, Config.ToggleDashcamKeybind) then
			OpenDashcam(vehicle, Config.Vehicles[GetEntityModel(vehicle)].Offset)
		end

		::skip_loop::
	end
end)

function OpenDashcam(vehicle, offset)
	-- Destroy a previous camera if it still exists
	if createdCam ~= nil then
		DestroyCam(createdCam, 0)
	end

	-- Create the camera
	createdCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 1)
	AttachCamToVehicleBone(createdCam, vehicle, GetEntityBoneIndexByName(vehicle, 'chassis'), true, 0.0, 0.0, 0.0, offset,
		true)
	SetCamRot(createdCam, GetEntityRotation(vehicle), 2)
	SetTimecycleModifier(Config.TimecycleModifier)
	RenderScriptCams(1, 0, 0, 1, 1)

	-- Enable the ui overlay
	inDashcam = true
	DisplayRadar(false)
	OpenDashcamOverlay()

	-- Create a thread to handle keypress initiating a speed reading
	CreateThread(function()
		while inDashcam do
			Wait(0)
			local ped = PlayerPedId()
			if IsControlJustReleased(0, Config.ToggleSpeedMeasurement) then
				if not gettingSpeed then
					distance = 0
					time = 0
					lastLocation = GetEntityCoords(ped, true)
					timeStarted = GetGameTimer()
				else
					local time = math.floor((GetGameTimer() - timeStarted) / 10) / 100
					local finalSpeed = math.floor((distance / time) * 3.6)
					if time < 1 then finalSpeed = 0 end
					SendNUIMessage({
						action = 'sendSpeed',
						finalSpeed = finalSpeed
					})
				end
				gettingSpeed = not gettingSpeed
			end
		end
	end)

	-- Create a thread to update the dashcam values
	CreateThread(function()
		while inDashcam do
			Wait(50)
			local speed = math.floor(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) * 3.6)
			if gettingSpeed then
				local currentPosition = GetEntityCoords(PlayerPedId())
				distance = distance + #(lastLocation - currentPosition)
				lastLocation = currentPosition
				currentTime = math.floor((GetGameTimer() - timeStarted) / 10) / 100
			end

			SendNUIMessage({
				action = 'update',
				speed = speed or 0,
				distance = math.floor(distance) or 0,
				time = currentTime or 0,
				locale = Config.Locales[language]
			})
		end
	end)
end

function CloseDashcam()
	CloseDashcamOverlay()
	DestroyCam(createdCam, 0)
	RenderScriptCams(0, 0, 1, 1, 1)
	ClearTimecycleModifier()
	DisplayRadar(true)
	createdCam = nil
	inDashcam = false
end
