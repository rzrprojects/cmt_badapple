RegisterCommand('baa', function(source, args, rawCommand)
    local frames = {}
    for i=0, 6500 do
        PerformHttpRequest("https://ba.julian-horn.net/frame?frame=44" , function (errorCode, resultData, resultHeaders)
            local frame = optimizeframe(tostring(resultData))
            print(frame)
            print("Frame " .. i .. " sent to client")
            table.insert( frames, frame )
        end)
    end
    print("done")
    TriggerClientEvent("cmt_badapple:plot", source, frames, currentFrame)
end, true)

RegisterCommand('ba', function(source, args, rawCommand)
    TriggerClientEvent("cmt_badapple:plot", source)
end, true)


function optimizeframe(frame)
    local frame = frame
    frame = frame:gsub('%-', '')
    frame = frame:gsub('%|', '')
    frame = frame:gsub('\n', '')
    return frame
end