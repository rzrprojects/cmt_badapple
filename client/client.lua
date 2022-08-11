local lastframe = nil
local carsSpawned = {}
local idleCamDisabled = GetResourceKvpString("idleCam") ~= "on"

RegisterNetEvent("cmt_badapple:plot")
AddEventHandler("cmt_badapple:plot", function()
    local framestring = LoadResourceFile("cmt_badappleb", "frames.txt")
    local frames = Split(framestring, "T")
    local veh = "bmci"
    vehiclehash = GetHashKey(veh)
    controlCars(vehiclehash, frames)
end)

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function pixelhigh(frame, i,j)
    local frame = frame
    local pixel = ((30*i)+j)
    local char = frame:sub(pixel, pixel)
    if char == "#" then
        return true
    else
        return false
    end

end

function controlCars(vehiclehash, frames)
    idleCamDisabled = true
    SetResourceKvp("idleCam", "off")
    for f=1, #frames do
        local frame = optimizeframe(frames[f])
        local x,y,z = -1360, -2838, 13.6797
        if lastframe == nil then
            lastframe = frame
        end
        for i=0, 10 do
            local linefinished = false
            for j=1, 30 do
                local pixel = ((30*i)+j)
                if frame[pixel] == "|" then
                    linefinished = true
                end
                if not linefinished then
                    if pixelhigh(frame, i,j) then
                        local ob = spawnACar(vehiclehash, x, y, z)
                        local subm = {obj=ob, framej=j, framei=i}
                        table.insert(carsSpawned, subm)
                    end
                end
                x = x - 2.5
            end
            x=-1360
            y=y+7
        end
        Citizen.Wait(200)
        local toDelete = GetGamePool("CObject")
			for _,object in pairs(toDelete) do
				if DoesEntityExist(object) then
					if not NetworkHasControlOfEntity(object) then
						local i=0
						repeat 
							NetworkRequestControlOfEntity(object)
							i=i+1
							Wait(10)
						until (NetworkHasControlOfEntity(object) or i==500)
					end
					DetachEntity(object, false, false)
					if IsObjectAPickup(object) then 
						RemovePickup(object)
					end
					SetEntityAsNoLongerNeeded(object)
					DeleteEntity(object)
				end
			end
        lastframe = frame
    end
    Citizen.Wait(30000)
    idleCamDisabled = false
    SetResourceKvp("idleCam", "on")
end


function optimizeframe(frame)
    local frame = frame
    frame = frame:gsub('%-', '')
    frame = frame:gsub('%|', '')
    frame = frame:gsub('\n', '')
    return frame
end

function spawnACar(hash, x, y, z)
    RequestModel(hash)
    local waiting = 0
    while not HasModelLoaded(hash) do
        waiting = waiting + 100
        Citizen.Wait(100)
        if waiting > 5000 then
            Print("~r~Could not load the vehicle model in time, a crash was prevented.")
            break
        end
    end 
    ob = CreateObject(hash, vector3(x,y,z), 150, true, false)
    SetEntityAsMissionEntity(ob)
    return ob
end


Citizen.CreateThread(function()
  while true do
    if idleCamDisabled then
      InvalidateIdleCam()
      InvalidateVehicleIdleCam()
      Citizen.Wait(10000)
    else
      Citizen.Wait(3300)
    end
  end
end)