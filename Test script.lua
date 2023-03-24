getgenv().Settings = {
    Map = "PLAINS", -- map must be in all caps
    Difficulty = "Abnormal", -- proper case, Easy, Medium, Hard, Extreme, Abnormal
    Speed = 600, -- tween speed to use to get to nearest titan
    Speed2 = 400, -- tween speed to use if <50 studs within titan (prevents kicking at times)
    LeaveTimer = 200 -- in seconds, in case if u get stuck or wtv (put it to 9999999 if u dont want it to leave lol)
}

repeat wait(1) until game:IsLoaded()

if getgenv().Settings.LeaveTimer == nil then
    getgenv().Settings.LeaveTimer = 300
end

function log(message, type)
    if type == "WARN" then
        print('WARN:', message)
    elseif type == "DEBUG" then
        print('DEBUG:', message)
    end
end

if game.PlaceId == 7127407851 then
    --log('Joining VIP', "DEBUG")
    local args = {
        [1] = "VIP",
        [2] = "Join",
        [3] = "Code"
    }

    --game:GetService("ReplicatedStorage").Assets.Remotes:GetChildren()[2]:InvokeServer(unpack(args))
    --return
end

local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Plr = Players.LocalPlayer;
repeat wait() pcall(function() Char = Plr.Character end) until Char
local Head = Char:WaitForChild("Head", 1337);
local Root = Char:WaitForChild("HumanoidRootPart", 1337);
local Humanoid = Char:WaitForChild("Humanoid", 1337);

-- find this off v3rm and modified it cuz idk metatables

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt,false)
mt.__namecall = newcclosure(function(self, ...)
  local args = {...}
  if getnamecallmethod() == 'InvokeServer' and args[1] == "Slash" then
    args[3] = "Nape"
  end
  return old(self, unpack(args))
end)


function getClosestTitan()
    local nearestPlayer, nearestDistance
    pcall(function()
        for _, player in pairs(workspace.Titans:GetChildren()) do
            local character = player.Hitboxes.Player.Nape
            if character then
                local plr = Game:GetService("Players").LocalPlayer
                local nroot = player:FindFirstChild('Main')
                local health = player.Head:FindFirstChild('Party')
                if nroot and health then
                    local distance = plr:DistanceFromCharacter(nroot.Position)
                    if (nearestDistance and distance >= nearestDistance) then continue end
                    nearestDistance = distance
                    nearestPlayer = character
                    selectt = player
                end
            end
        end
    end)
    return nearestPlayer, selectt
end

function getClosestRefill()
    local nearestPlayer, nearestDistance
    for _, player in pairs(game:GetService("Workspace").Map.Props.Refills:GetChildren()) do
        local character = player.Hitbox
        if character then
            local plr = Game:GetService("Players").LocalPlayer
            local distance = plr:DistanceFromCharacter(character.Position)
            if (nearestDistance and distance >= nearestDistance) then continue end
            nearestDistance = distance
            nearestPlayer = character
        end
    end
    return nearestPlayer
end