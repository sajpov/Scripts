repeat wait(1) until game:IsLoaded()

if not getgenv().Settings.LeaveTimer then
getgenv().Settings.LeaveTimer = 300
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plr = Players.LocalPlayer

repeat wait() until Plr.Character
local Char = Plr.Character
local Head = Char.Head
local Root = Char.HumanoidRootPart
local Humanoid = Char.Humanoid

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
local args = {...}
if getnamecallmethod() == 'InvokeServer' and args[1] == "Slash" then
args[3] = "Nape"
end
return old(self, unpack(args))
end)

function getClosestTitan()
local nearestPlayer, nearestDistance
for _, player in pairs(workspace.Titans:GetChildren()) do
local character = player.Hitboxes.Player.Nape
if character then
local nroot = player:FindFirstChild('Main')
local health = player.Head:FindFirstChild('Party')
if nroot and health then
local distance = Plr:DistanceFromCharacter(nroot.Position)
if (nearestDistance and distance >= nearestDistance) then continue end
nearestDistance = distance
nearestPlayer = character
selectt = player
end
end
end
return nearestPlayer, selectt
end

function getClosestRefill()
local nearestPlayer, nearestDistance
for _, player in pairs(game:GetService("Workspace").Map.Props.Refills:GetChildren()) do
local character = player.Hitbox
if character then
local distance = Plr:DistanceFromCharacter(character.Position)
if (nearestDistance and distance >= nearestDistance) then continue end
nearestDistance = distance
nearestPlayer = character
end
end
return nearestPlayer
end

local VirtualInputManager = game:GetService('VirtualInputManager')
function useSkill(key, bool)
VirtualInputManager:SendKeyEvent(bool, key, false, game)
end

function lookAt(chr,target)
if chr.PrimaryPart then
local chrPos=chr.PrimaryPart.Position
local tPos=target.Position
local newCF=CFrame.new(chrPos,tPos)
chr:SetPrimaryPartCFrame(newCF)
end
end

function bladesFull()
local Status = 0
for _,v in pairs(Plr.Character.HumanoidRootPart.Board.Display.Blade.Segments:GetDescendants()) do
if v.Name == "Inner" and v.ImageTransparency == 1 then
Status = Status + 1
end
end
return Status == 7
end

function refillBlades()
    wait(1)
    local args = {true, "Effect", "Refill"}
    game:GetService("ReplicatedStorage").Assets.Remotes:GetChildren()[1]:FireServer(unpack(args))
    wait(1.5)
    if bladesFull() then
        local refill = getClosestRefill()
        local Time = (refill.Position - Plr.Character.HumanoidRootPart.Position).Magnitude / 400
        function refill()
            while task.wait() do
                if not refilling and bladesLessThan(1) then
                    local refill = getRefill()
                    if not refill then return end
                    local Time = (refill.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / 50
                    local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
                    local Tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, Info, {CFrame = CFrame.new(refill.Position) + Vector3.new(0, 4, 0)})
                    Tween:Play()
                    Tween.Completed:Wait()
                    refilling = true
                    wait(1)
                    useSkill('R', true)
                    wait(7)
                    local Time = (refill.Position + Vector3.new(30, 4, 30) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / 400
                    local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
                    local Tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, Info, {CFrame = CFrame.new(refill.Position) + Vector3.new(15, 4, 15)})
                    Tween:Play()
                    Tween.Completed:Wait()
                    refilling = false
                    wait(1)
                end
            end
        end
    end
end


-- looks at the titan and moves towards it
function okTitan()
while task.wait() do
if not titan then return end
pcall(function()
lookAt(Char, titan)
end)
end
end

local virtualUser = game:GetService('VirtualUser')
virtualUser:CaptureController()
skilln = 0

-- kills the closest titan
function killClosestTitan()
wait(0.3)
if bladesFull() == true then
useSkill('E', false)
refillBlades()
return
end
titan, titanparrt = getClosestTitan()
if not titan then return end
if Plr:DistanceFromCharacter(titan.Position) <= 50 then
getgenv().Speed = getgenv().Settings.Speed2
else
getgenv().Speed = getgenv().Settings.Speed
end
local Time = (titan.CFrame.p + Vector3.new(0, 7, 4) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / getgenv().Speed
local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
local Tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, Info, {CFrame = CFrame.new(titan.CFrame.p) + Vector3.new(0, 7, 4)})
Tween:Play()
Tween.Completed:Wait()
wait()
local Time = (titan.CFrame.p + Vector3.new(0, 3, 1) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / getgenv().Speed
local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
local Tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, Info, {CFrame = CFrame.new(titan.CFrame.p) + Vector3.new(0, 7, 4)})
Tween:Play()
repeat wait() until Tween.Completed or Plr:DistanceFromCharacter(titan.Position) <= 20
if not titan then return end

while true do
if bladesFull() then
break
end
Root.CFrame = CFrame.new(titan.CFrame.p) + Vector3.new(0, 1,1)
lookAt(Char, titan)
mousemoveabs(600,800)
useSkill('E', true)
mouse1click()
end

repeat task.wait() until not titanparrt.Head:FindFirstChild('Party') or bladesFull()

local function getName()
return game.ReplicatedStorage.Assets.Remotes:GetChildren()[1].Name
end

local function selectMap(map, difficulty)
for _,v in pairs(Plr.PlayerGui.Interface.PvE.Main:GetChildren()) do
if v:IsA('ImageButton') and v.Title.Text == map then
repeat wait() until v.Title.Text ~= "???"
local Signals = {'MouseButton1Down', 'MouseButton1Click', 'Activated'}
for _,a in pairs(Signals) do
firesignal(v[a])
end
break
end
end
for _,v in pairs(Plr.PlayerGui.Interface.PvE.Difficulties:GetChildren()) do
    if v:IsA('TextButton') and v.Name == difficulty and v.Lock.Visible == false then
        repeat wait() until v.Name ~= "???"
        local Signals = {'MouseButton1Down', 'MouseButton1Click', 'Activated'}
        for _,a in pairs(Signals) do
            firesignal(v[a])
        end
        break
    end
end
end

local iflobby = game.Workspace.Map.Props.Missions.Pad.Main
if iflobby then
wait(1)
Root.CFrame = CFrame.new(iflobby.Position)
repeat wait() until Plr.PlayerGui.Interface.PvE.Main['1'].Visible == true
wait()
selectMap(getgenv().Settings.Map, getgenv().Settings.Difficulty)
log('Selected maps', "DEBUG")
return
end

task.spawn(function()
wait(getgenv().Settings.LeaveTimer)
game:GetService("TeleportService"):Teleport(7229033818, game.Players.LocalPlayer)
log('Teleporting to main screen', 'DEBUG')
end)

getgenv().rejoin = game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
game:GetService("TeleportService"):Teleport(7229033818)
end
end)

local function killTouch()
while true do
pcall(function()
game.Players.LocalPlayer.Character.HumanoidRootPart.TouchInterest:Destroy()
end)
task.wait()
end
end

local function killTouchh()
while true do
time = time + 1
task.wait(1)
end
end

task.spawn(killTouch)
task.spawn(killTouchh)
log('Script loaded', "DEBUG")

local Time = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(200, 0, 200) -
game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / 100
local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
local Tweena =
game:GetService("TweenService"):Create(
    game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(200, 0, 200) -
        game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / 100, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position) + Vector3.new(200, 0, 200)}
    )
):Play():WaitForChild('Completed')

while wait() and not refilling do
    killClosestTitan()
end
end
