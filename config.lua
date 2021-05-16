Config               = {}

Config.DrawDistance  = 5
Config.Size          = { x = 1.5, y = 1.5, z = 0.5 }
Config.Color         = { r = 0, g = 155, b = 253 }
Config.Type          = 27

Config.Locale        = 'en'

Config.Blur					 = true

Config.Loading			 = true

Config.LicenseEnable = false -- only turn this on if you are using esx_license
Config.LicensePrice  = 5000

Config.Zones = {

	GunShop = {
		Legal = true,
		Items = {},
		Locations = {
			vector3(22.0, -1107.2, 28.8)
		}
	},

	BlackWeashop = {
		Legal = false,
		Items = {},
		Locations = {
			vector3(728.92, 4188.70, 39.75)
		}
	}
}
