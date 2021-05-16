ESX = nil
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local ShopOpen = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    ESX.TriggerServerCallback('esx_weaponshop:getShop', function(shopItems)
        for k,v in pairs(shopItems) do
            Config.Zones[k].Items = v
        end
    end)
end)

RegisterNetEvent('esx_weaponshop:sendShop')
AddEventHandler('esx_weaponshop:sendShop', function(shopItems)
    for k,v in pairs(shopItems) do
        Config.Zones[k].Items = v
    end
end)

function OpenBuyLicenseMenu(zone)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_license', {
        title = _U('buy_license'),
        align = 'top-left',
        elements = {
            { label = _U('no'), value = 'no' },
            { label = _U('yes', ('<span style="color: green;">%s</span>'):format((_U('shop_menu_item', ESX.Math.GroupDigits(Config.LicensePrice))))), value = 'yes' },
        }
    }, function(data, menu)
        if data.current.value == 'yes' then
            ESX.TriggerServerCallback('esx_weaponshop:buyLicense', function(bought)
                if bought then
                    menu.close()
                    OpenShopMenu(zone)
                end
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenShopMenu(zone)
    local elements = {}
    ShopOpen = true

    if Config.Blur then
    SetTimecycleModifier('hud_def_blur') -- blur
    end

    SendNUIMessage({
        display = true,
        clear = true
    })

    SetNuiFocus(true, true)

    for i=1, #Config.Zones[zone].Items, 1 do
        local item = Config.Zones[zone].Items[i]
        
        SendNUIMessage({
            itemLabel = item.label,
            item = item.item,
            price = item.price,
            desc = item.desc,
            imglink = item.imglink,
            zone = zone
        })
    end

    ESX.UI.Menu.CloseAll()
   -- PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.25, 0.25)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function DisplayBoughtScaleform(weaponName, price)
    local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
    local sec = 4

    BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')

    PushScaleformMovieMethodParameterString(_U('weapon_bought', ESX.Math.GroupDigits(price)))
    PushScaleformMovieMethodParameterString(ESX.GetWeaponLabel(weaponName))
    PushScaleformMovieMethodParameterInt(GetHashKey(weaponName))
    PushScaleformMovieMethodParameterString('')
    PushScaleformMovieMethodParameterInt(100)

    EndScaleformMovieMethod()

   -- PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)

    Citizen.CreateThread(function()
        while sec > 0 do
            Citizen.Wait(0)
            sec = sec - 0.01
    
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        end
    end)
end

AddEventHandler('esx_weaponshop:hasEnteredMarker', function(zone)
    if zone == 'GunShop' or zone == 'BlackWeashop' then
        CurrentAction     = 'shop_menu'
        CurrentActionMsg  = _U('shop_menu_prompt')
        CurrentActionData = { zone = zone }
    end
end)

AddEventHandler('esx_weaponshop:hasExitedMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if ShopOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

-- Create Blips
Citizen.CreateThread(function()
    for k,v in pairs(Config.Zones) do
        if v.Legal then
            for i = 1, #v.Locations, 1 do
                local blip = AddBlipForCoord(v.Locations[i])

                SetBlipSprite (blip, 110)
                SetBlipDisplay(blip, 4)
                SetBlipScale  (blip, 0.6)
                SetBlipColour (blip, 4)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(_U('map_blip'))
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local coords = GetEntityCoords(PlayerPedId())

        for k,v in pairs(Config.Zones) do
            for i = 1, #v.Locations, 1 do
                if (Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Locations[i], true) < Config.DrawDistance) then
                    DrawMarker(-1, v.Locations[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
                    DrawText3Ds(v.Locations[i].x, v.Locations[i].y, v.Locations[i].z + 1.0, '~g~E~w~ - Open Weapon Shop')
                end
            end
        end
    end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local isInMarker, currentZone = false, nil

        for k,v in pairs(Config.Zones) do
            for i=1, #v.Locations, 1 do
                if GetDistanceBetweenCoords(coords, v.Locations[i], true) < Config.Size.x then
                    isInMarker, ShopItems, currentZone, LastZone = true, v.Items, k, k
                end
            end
        end
        if isInMarker and not HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = true
            TriggerEvent('esx_weaponshop:hasEnteredMarker', currentZone)
        end
        
        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('esx_weaponshop:hasExitedMarker', LastZone)
        end
    end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction ~= nil then
            -- ESX.ShowHelpNotification(CurrentActionMsg)

            if IsControlJustReleased(0, 38) then

                if CurrentAction == 'shop_menu' then
                    if Config.LicenseEnable and Config.Zones[CurrentActionData.zone].Legal then
                        ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
                            if hasWeaponLicense then
                                OpenShopMenu(CurrentActionData.zone)
                            else
                                exports['mythic_notify']:SendAlert('inform', 'You dont have a license!', 2500, { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' })
                            end
                        end, GetPlayerServerId(PlayerId()), 'weapon')
                    else
                        OpenShopMenu(CurrentActionData.zone)
                    end
                end

                CurrentAction = nil
            end
        end
    end
end)

RegisterNUICallback('buyItem', function(data, cb)
    ESX.TriggerServerCallback('esx_weaponshop:buyWeapon', 1, data.item, data.zone)
end)

RegisterNUICallback('focusOff', function(data, cb)
    SetNuiFocus(false, false)
    FreezeEntityPosition(PlayerPedId(), false)
    if Config.Blur then 
        SetTimecycleModifier('default') -- remove blur
    end
end)       