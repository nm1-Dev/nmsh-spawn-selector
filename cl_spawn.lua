----------------------------------------------------------------
--  _      _    _             _   _               _         _ --
-- | |    / \  | |__   ___   | \ | |_ __ ___  ___| |__     | |--
-- | |   / _ \ | '_ \ / _ \  |  \| | '_ ` _ \/ __| '_ \    | |--
-- |_|_ / ___ \| |_) | (_) | | |\  | | | | | \__ \ | | |_ _|_|--
-- (_|_)_/   \_\_.__/ \___/  |_| \_|_| |_| |_|___/_| |_(_|_|_)--
-- https://discord.gg/rfEs2VvaSd                              --
----------------------------------------------------------------

local QBCore = exports['qb-core']:GetCoreObject()
local LoginSafe, Cam = nil, false

local spawns = {
	[1] = {coords = vector3(1852.95, 2585.95, 45.67), label = "السجن"},
	[2] = {coords = vector3(1811.14, 3677.75, 34.27), label = "ساندي شور"},
    [3] = {coords = vector3(-1833.96, -1223.5, 13.02), label = "Santa Monica Pier"},
    [4] = {coords = vector3(949.94, 117.59, 80.75), label = "Diamond Casino"},
    [5] = {coords = vector3(145.61, 6563.32, 32.99), label = "Paleto Gas Station"},
    [6] = {coords = vector3(427.85, -985.42, 31.71), label = "Mission Row PD"},
	[7] = {coords = vector3(-104.77, -1093.01, 26.12), label = "Gallery & Filmed"},
	[8] = {coords = vector3(280.17, -590.73, 44.72), label = "المستشفى"},
	[9] = {coords = vector3(-270.89, -957.81, 31.22), label = "الشقق الحكوميه"},
}


local Jail = {
	[1] = {coords = vector3(1729.36, 2563.59, 45.56), label = "السجن"},
}


RegisterNetEvent("nmsh-spawn:openNui")
AddEventHandler("nmsh-spawn:openNui", function(pos)
	QBCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] > 0 then
			print(PlayerData.metadata["injail"])
			SendNUIMessage({
				data = Jail,
				lastpos = pos,
				InJail = true
			})
			openCam()
			SetNuiFocus(true, true)
		else
			SendNUIMessage({ 
				data = spawns,
				lastpos = pos,
				InJail = false
			})
			openCam()
			SetNuiFocus(true, true)
		end

	end)
end)

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
    Cam = false
	DoScreenFadeOut(1000)
end)

RegisterNUICallback("spawn", function(data)
    DoScreenFadeOut(1000)
    SetNuiFocus(false, false)
    TriggerEvent("nmsh-spawn:client:loadplayer", data.coords)
end)

RegisterNUICallback('loadplayer', function(data, cb)
    DoScreenFadeOut(500)
    SetNuiFocus(false, false)
    QBCore.Functions.GetPlayerData(function(PlayerData) 
        TriggerEvent("nmsh-spawn:client:loadplayer", PlayerData.position)
    end)
end)

RegisterNetEvent("nmsh-spawn:client:loadplayer")
AddEventHandler("nmsh-spawn:client:loadplayer", function(coords)
	local ped = PlayerPedId()
    delCam()
    doCamera(coords.x,coords.y,coords.z)
    DoScreenFadeOut(2)
	delCam()
	FreezeEntityPosition(ped, false)
    SetEntityCoords(PlayerPedId(),coords.x,coords.y,coords.z)
    SetEntityHeading(PlayerPedId(),coords.w)
    SetEntityVisible(PlayerPedId(), true)
    Wait(200)
    DoScreenFadeIn(2500)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
end)

function delCam()
    ClearFocus()
	DestroyAllCams(true)
	RenderScriptCams(false, true, 1, true, true)
end

function openCam()
    local ped = PlayerPedId()
    local coords = vector4(-3966.0, 2014.9, 500.91, 81.52)
	SetEntityCoords(ped,coords.x,coords.y,coords.z)
	SetEntityHeading(ped,coords.w)
	SetEntityVisible(ped, true)
	SetEntityCollision(ped, true, true)
	DoScreenFadeIn(1000)
	TriggerScreenblurFadeIn(1000)
	LoginSafe = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	local camCoords = {-3968.85, 2015.93, 502.22}
	SetCamRot(LoginSafe, -90.0, 0.0, 250.0, 2)
	SetCamCoord(LoginSafe, camCoords[1], camCoords[2], camCoords[3])
	StopCamShaking(LoginSafe, true)
	SetCamFov(LoginSafe, 50.0)
	SetCamActive(LoginSafe, true)
	RenderScriptCams(true, false, 0, true, true)
	FreezeEntityPosition(ped, true)
	Wait(700)
	TriggerScreenblurFadeOut(1000.0)
end

cam = 0
function doCamera(x,y,z)
	DoScreenFadeOut(1)
	if(not DoesCamExist(cam)) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	local camAngle = -90.0
	while i > 1 do
		local factor = i / 50
		if i < 1 then i = 1 end
		i = i - factor
		SetCamCoord(cam, x,y,z+i)
		if i < 1200 then
			DoScreenFadeIn(600)
		end
		if i < 90.0 then
			camAngle = i - i - i
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
		Citizen.Wait(2/i)
	end
end

RegisterNetEvent('nmsh-spawn:client:setupSpawns', function(cData, new, apps)
    if not new then
        SetNuiFocus(false, false)
        TriggerEvent("nmsh-spawn:openNui")
        Wait(500)
	else
		SetEntityCoordsNoOffset(PlayerPedId(), vector3(-230.5, -1003.44, 46.11), false, false, false, false)
		FreezeEntityPosition(ped, true)
		SetEntityVisible(PlayerPedId(), false, 0)
		SetEntityHeading(ped, 51.71)
		DoScreenFadeIn(500)
		camm = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		local camCoords = {-230.5, -1003.44, 46.11}
		SetCamRot(camm, -14.0, 0.0, 45.0, 2)
		SetCamCoord(camm, camCoords[1], camCoords[2], camCoords[3])
		StopCamShaking(camm, true)
		SetCamFov(camm, 50.0)
		SetCamActive(camm, true)
		RenderScriptCams(true, false, 0, true, true)
		-- DoScreenFadeIn(500)
		Wait(5000)
		TriggerServerEvent("apartments:server:CreateApartment", 'apartment1', 'City Motel')
		TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
		TriggerEvent('QBCore:Client:OnPlayerLoaded')
		RenderScriptCams(false, true, 500, true, true)
		SetCamActive(cam, false)
		DestroyCam(cam, true)
		SetCamActive(cam2, false)
		DestroyCam(cam2, true)
		SetEntityVisible(ped, true)
		SetEntityCoords(ped, vector3(-270.22, -958.98, 31.23))
		SetEntityHeading(ped, 300.77)
		FreezeEntityPosition(ped, false)
    end
end)

----------------------------------------------------------------
--  _      _    _             _   _               _         _ --
-- | |    / \  | |__   ___   | \ | |_ __ ___  ___| |__     | |--
-- | |   / _ \ | '_ \ / _ \  |  \| | '_ ` _ \/ __| '_ \    | |--
-- |_|_ / ___ \| |_) | (_) | | |\  | | | | | \__ \ | | |_ _|_|--
-- (_|_)_/   \_\_.__/ \___/  |_| \_|_| |_| |_|___/_| |_(_|_|_)--
-- https://discord.gg/rfEs2VvaSd                              --
----------------------------------------------------------------