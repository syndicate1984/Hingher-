local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_hinghier")
vRPChinghier = Tunnel.getInterface("vRP_hinghier","vRP_hinghier")

vRPhinghier = {}
Tunnel.bindInterface("vRP_hinghier",vRPhinghier)
Proxy.addInterface("vRP_hinghier",vRPhinghier)


function vRPhinghier.vinde()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    local bani = math.random(200,300)
    vRP.giveMoney({user_id,bani})
    vRPclient.notify({user_id,"Ai primit "..bani.." LEI"})
end

local function build_confisca(source)
	local user_id = vRP.getUserId({source})
    if user_id ~= nil then
		vRPclient.setNamedBlip(source, {"vRP:hingheroi:hinghier", 413.099609375,6539.55859375,27.730381011963, 385, 71, "[~p~Thor~w~] ~w~Job Hinghier"})
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
    build_confisca(source)
  end
end)