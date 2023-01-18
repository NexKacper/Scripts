repeat task.wait() until game:IsLoaded()
local TeleportService = game:GetService("TeleportService")
local data = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Dsc&limit=100")).data
local c = 0
for i = 1, #data do
    local server = data[i-c]
    if not server.playing then
        table.remove(data, i-c)
        c += 1
    end
end
local function fyshuffle( tInput )
    local tReturn = {}
    for i = #tInput, 1, -1 do
        local j = math.random(i)
        tInput[i], tInput[j] = tInput[j], tInput[i]
        table.insert(tReturn, tInput[i])
    end
    return tReturn
end
data = fyshuffle(data)
local function randomhop(data, failed)
    failed = failed or {}
    for _, s in pairs(data) do
        local id = s.id
        if not failed[id] and id ~= game.JobId then
            if s.playing < s.maxPlayers then
                local connection
                connection = TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
                    connection:Disconnect()
                    failed[id] = true
                    randomhop(data, failed)
                end)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, id)
                break
            end
        end
    end
end

task.spawn(function()randomhop(data)end)
local player = game.Players.LocalPlayer.Character
while wait(2) do
 player.HumanoidRootPart.CFrame = game.Workspace.ChinaDetector.CFrame
   local teleportservice = game:GetService("TeleportService")
teleportservice:Teleport(game.PlaceId)   
 end
syn.queue_on_teleport(
    [[
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NexKacper/Scripts/main/4tg34gefg43egrwe.lua"))()
    ]]
)
