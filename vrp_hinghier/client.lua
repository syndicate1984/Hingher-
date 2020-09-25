vRPhinghierC = {}
Tunnel.bindInterface("vRP_hinghier",vRPhinghierC)
Proxy.addInterface("vRP_hinghier",vRPhinghierC)
vRP = Proxy.getInterface("vRP")
vRPShinghier = Tunnel.getInterface("vRP_hinghier","vRP_hinghier")

local cautare = false
local hasjob = false
local caine = false
local caineluat = false
local ped
local ion = false
local cainepus = false

local x 
local y
local z

local coordonate = {
    {1589.6999511719,6443.892578125,25.179475784302-1},
    {-286.2822265625,6265.0434570313,31.473449707031-1},
    {-949.38006591797,5426.4990234375,38.424709320068-1},
    {-205.40986633301,6546.3872070313,11.095830917358-1},
    {2350.7390136719,5882.5366210938,47.413101196289-1},
    {2518.1416015625,5475.802734375,44.551372528076-1}
}

function DrawText3D(x,y,z, text, scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function creeazaCainele(x,y,z)
	RequestModel( GetHashKey( "a_c_rottweiler" ) )
		while ( not HasModelLoaded( GetHashKey( "a_c_rottweiler" ) ) ) do
			Citizen.Wait( 1 )
		end
	ped = CreatePed(29, 0x9563221D, x, y, z, 90.0, true, false)
    SetEntityHealth(ped, 200)
    FreezeEntityPosition(ped,true)
end

function CreateCar(x,y,z,heading) -- van
	local hash = GetHashKey("bodhi2")
    local n = 0
    while not HasModelLoaded(hash) and n < 500 do
        RequestModel(hash)
        Citizen.Wait(10)
        n = n+1
    end
    -- spawn car
    if HasModelLoaded(hash) then
        veh = CreateVehicle(hash,x,y,z,heading,true,false)
        SetEntityHeading(veh,heading)
        SetEntityInvincible(veh,false)
        SetModelAsNoLongerNeeded(hash)
        SetVehicleLights(veh,2)
        SetVehicleColours(veh,147,41)
        SetVehicleNumberPlateTextIndex(veh,2)
		SetVehicleNumberPlateText(veh,"Hinghier")
		SetPedIntoVehicle(GetPlayerPed(-1),veh,-1)
		SetEntityAsMissionEntity(veh, true, true)
        for i = 0,24 do
            SetVehicleModKit(veh,0)
            RemoveVehicleMod(veh,i)
        end
    end    
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local carPos = GetEntityCoords(veh, false)
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        if not DoesEntityExist(veh) and hasJob then
            hasJob = false
            cautare = false
            ion = false
        end
        if cautare then
            local newx = x
            local newy = y
            local newz = z
            local metrii2 = math.floor(GetDistanceBetweenCoords(newx,newy,newz, GetEntityCoords(GetPlayerPed(-1))))
            if metrii2 <= 3 then
                while ion == true do
                    Wait(0)
                    DrawText3D(newx,newy,newz+1, "Apasa ~y~[E]~w~ pentru a lua cainele\n(Da-te jos din masina)", 1.2)
                    if IsControlJustPressed(1,51) then
                        RequestAnimDict("anim@heists@box_carry@")
                        TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
                        local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
                        AttachEntityToEntity(ped, GetPlayerPed(-1), bone, 0.08, -0.5, -0.30, 7.0, -4.0, 0.0, true, true, false, true, 1, true)
                        ion = false
                        caineluat = true
                        cautare = false
                    end
                end
            end
        end
        if caineluat then
            if (Vdist(pos.x, pos.y, pos.z, carPos.x , carPos.y, carPos.z) <= 7.0) and DoesEntityExist(veh) then
                DrawText3D(carPos.x,carPos.y,carPos.z+0.5, "Apasa ~y~[G]~w~ pentru a pune cainele in masina", 1.2)
                if IsControlJustPressed(1,58) then
                    AttachEntityToEntity(ped, veh, veh, 0.08, -1.30, 0.10, 0.0, -0.0, 0.0, true, true, false, true, 1, true)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    SetNewWaypoint(413.099609375,6539.55859375,27.730381011963)
                    cainepus = true
                    caineluat = false
                end
            end
        end
        if cainepus then
            DrawText3D(carPos.x,carPos.y,carPos.z+1.5, "~y~Du cainele la baza", 1.2)
        end
        local posplayer = GetEntityCoords(GetPlayerPed(-1))
        local metrii = math.floor(GetDistanceBetweenCoords(413.099609375,6539.55859375,27.730381011963, GetEntityCoords(GetPlayerPed(-1))))
        if metrii <=1 then
            DrawText3D(posplayer.x,posplayer.y,posplayer.z, "Apasa ~y~E~w~ pentru a incepe jobul de ~r~Hinghier\nApasa ~y~Y ~w~pentru a da ~r~cainele", 1.2)          
            if IsControlJustReleased(1,51) then 
                if hasjob == false then
                    hasjob = true
                    local random = math.random(#coordonate)
                     x = coordonate[random][1]
                     y = coordonate[random][2]
                     z = coordonate[random][3]
                    SetNewWaypoint(x,y)
                    vRP.notify({"Ti-am pus marker pe harta unde e cainele pierdut"})
                    vRP.notify({"Cand ajungi la locatie apasa E pentru a lua cainele"})
                    creeazaCainele(x,y,z)
                    CreateCar(434.22625732422,6533.2724609375,27.869470596313,190.0)
                    cautare = true
                    ion = true
                else
                    vRP.notify({"Ai deja jobul inceput"})
                end

            elseif IsControlJustPressed(1,246) then
                if cainepus then
                    caineluat = false
                    hasjob = false
                    cainepus = false
                    DeleteEntity(ped)
                    DeleteEntity(veh)
                    vRPShinghier.vinde()
                else
                    vRP.notify({"Nu fii marlan"})
                end
            end    
        end
    end
end)
