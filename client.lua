---------------------------------------------
-- Nosso Discord
-- https://discord.gg/UajwX4a
---------------------------------------------

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
gaR = Tunnel.getInterface("puzzle_garden") 
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
config = module("puzzle_garden","config")

local blips = false
local servico = false
local selecionado = 0
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIAR TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if not servico then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local distancia = #(coords - config.startLoc)
	
			if distancia > 50  then idle = 3  * 1000 end
			if distancia > 100 then idle = 10 * 1000 end
			if distancia <= 20 then idle = 5

				DrawMarker(21,config.startLoc[1],config.startLoc[2],config.startLoc[3]-0.5,0,0,0,0,180.0,130.0,0.5,0.5,0.4,250,100,50,150,1,0,0,1)
				if distancia <= 1.1 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA ~y~INICIAR O TRABALHO",4,0.5,0.90,0.50,255,255,255,200)
					if IsControlJustPressed(0,38) then
						servico = true
						if config.isRandom then selecionado = math.random(#config.locs) else selecionado = 1 end
						CriandoBlip(config.locs,selecionado)
						PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
						TriggerEvent("Notify","sucesso","Deixe a cidade mais bonita.")
					end
				end
			end
		end
		Citizen.Wait(idle)
  end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JARDINS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 500
		if servico and not processo then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))

			if Vdist(config.locs[selecionado].x,config.locs[selecionado].y,config.locs[selecionado].z,x,y,z)  > 21 then idle = 3 * 1000 end
			if Vdist(config.locs[selecionado].x,config.locs[selecionado].y,config.locs[selecionado].z,x,y,z) <= 20 then idle = 5

				DrawMarker(21,config.locs[selecionado].x,config.locs[selecionado].y,config.locs[selecionado].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,250,100,50,150,1,0,0,1)
				if Vdist(config.locs[selecionado].x,config.locs[selecionado].y,config.locs[selecionado].z,x,y,z) <= 1 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA ~y~PLANTAR AS FLORES",4,0.5,0.90,0.50,255,255,255,200)
					if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
						RemoveBlip(blips)
						TriggerEvent("countDown",10)
						TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
						FreezeEntityPosition(ped,true)
						segundos = config.animTime
						processo = true

						Wait(segundos * 1000)
						object = CreateObject(GetHashKey("prop_plant_fern_01a"),config.locs[selecionado].x,config.locs[selecionado].y,config.locs[selecionado].z-1.3, true, true, true)

						if config.isRandom then
							random = math.random(#config.locs)
							if random == selecionado then random = selecionado + 1 end
							selecionado = random
						else
							selecionado = selecionado + 1
						end

						TriggerEvent("delObject",object)

						PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						gaR.PayJob()
						CriandoBlip(config.locs,selecionado)
					end
				end
			end
		end
	Citizen.Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("StopGardenService","Sair Serviço Jardineiro","keyboard","f7")
RegisterCommand("StopGardenService",function(source,args)
	if servico then
		servico = false
		RemoveBlip(blips)
		PlaySoundFrontend(-1, "ERROR", "HUD_AMMO_SHOP_SOUNDSET", 1)
		TriggerEvent("Notify","aviso","Você saiu de serviço.")
	end
end)

RegisterNetEvent('countDown')
AddEventHandler('countDown',function(segundos)
	repeat
		Citizen.Wait(1000)
		segundos = segundos - 1
		if segundos == 0 then
			ClearPedTasks(PlayerPedId())
			Wait(4000)
			FreezeEntityPosition(PlayerPedId(),false)
			TriggerEvent('cancelando',false)
			processo = false
		end
	until segundos == 0
end)

RegisterNetEvent("delObject")
AddEventHandler("delObject",function(object)
	Citizen.Wait( 30 * 1000 )
	DeleteObject(object)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entregar Drogas")
	EndTextCommandSetBlipName(blips)
end