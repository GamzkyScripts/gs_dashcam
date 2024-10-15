Config = {}

Config.ToggleDashcamKeybind = 29 		-- Set the keybind to toggle the dashcam (default to B, see https://docs.fivem.net/docs/game-references/controls/ if you want to change this)
Config.ToggleSpeedMeasurement = 26 		-- Set the keybind to toggle the speed measurement (default to C, see https://docs.fivem.net/docs/game-references/controls/ if you want to change this)
Config.RequiredJob = 'police'			-- Change this to the required job name in order to use the dashcam, set to false if anyone should be able to use the dashcam
Config.CoDriver = true					-- If you want to also enable the dashcam for the co-driver set this value to true
Config.TimecycleModifier = 'phone_cam'	-- Change the camera effect if you wish (see https://wiki.rage.mp/index.php?title=Timecycle_Modifiers)
Config.Language = 'en' 					-- Select the language of the text components visible on the UI display. By default only 'en' (English) and 'nl' (Dutch) are available but feel free to add your own language in Config.Locales below.

-- Add vehicles to the list below, to enable the dashcam on this vehicle. The offset is the dashcam location with respect to the center of the vehicle.
Config.Vehicles = {
	[`police`] = { Offset = vector3(0.0, 0.75, 0.85) },
}

-- The text displayed on the UI display is editable below. By default an English and Dutch version have been added.
Config.Locales = {
	['en'] = {
		['own-speed'] = 'Veh speed',
		['text-left-top'] = 'CAM-02',
		['text-left-bottom'] = 'Mode 2',
		['text-right-top'] = 'LSPD',
		['text-right-bottom'] = 'Veh-ID: 2034',
		['brand-name'] = 'HAWK-EYE',
	},
	['nl'] = {
		['own-speed'] = 'Eig snhd',
		['text-left-top'] = 'TP5473',
		['text-left-bottom'] = 'Categorie B',
		['text-right-top'] = 'sn: 244577',
		['text-right-bottom'] = 'Categorie C',
		['brand-name'] = 'MODIFORCE',
	}
}