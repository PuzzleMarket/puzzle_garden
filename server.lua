local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
gaR = {}
Tunnel.bindInterface("puzzle_garden",gaR)

config = module("puzzle_garden","config")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAGAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
function gaR.PayJob()
	local user_id = vRP.getUserId(source)
	if user_id then
		if config.isCreative then
			vRP.generateItem(user_id,"dollars",config.reward,true)
		else
			vRP.giveMoney(user_id,config.reward)
		end
		TriggerClientEvent("vrp_sound:source",source,'coins',0.3)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu: <b>"..config.reward.."$ </b>")
		return true
	end
end
