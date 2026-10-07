--[[
    Skript: MATYX OWNED [ULTIMATE EDITION v3 - Fixed Executor]
    Hra: Snipers Arena (Roblox)
]]--

if syn and syn.queue_on_teleport then
    syn.queue_on_teleport(script.Source)
elseif queue_on_teleport then
    queue_on_teleport([[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/m4g2vwvz5y-hub/Snipers-arena/main/matyx.lua"))()
    ]])
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().MatyxSettings = getgenv().MatyxSettings or {
    ESP = {
        Boxes = true,
        Skeletons = false,
    },
    Aimbot = {
        Enabled = false,
        Key = Enum.UserInputType.MouseButton2,
        FOV = 150,
        ShowFOV = true,
        TargetMode = 1 -- 1 = Head, 2 = Torso
    },
    Triggerbot = {
        Enabled = false,
        Delay = 0.05
    },
    AutoStrafe = {
        Enabled = false,
        Speed = 0.4
    }
}

if CoreGui:FindFirstChild("MatyxOwnedGUI") then
    CoreGui.MatyxOwnedGUI:Destroy()
end

-- Bezpečné vytvoření FOV kruhu (pokud executor podporuje Drawing)
local FOVCircle = nil
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1.5
    FOVCircle.Color = Color3.fromRGB(0, 255, 255)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.8
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MatyxOwnedGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 480)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.Text = "⚡ MATYX OWNED | Stable v3 ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -90)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = MainFrame

local yOffset = 0

local function CreateToggle(name, initialState, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Position = UDim2.new(0, 0, 0, yOffset)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Button.Text = name .. (initialState and " [ON]" or " [OFF]")
    Button.TextColor3 = initialState and Color3.fromRGB(90, 255, 90) or Color3.fromRGB(255, 90, 90)
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSansBold
    Button.Parent = ScrollingFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    local toggled = initialState
    Button.MouseButton1Click:Connect(function()
        toggled = not toggled
        Button.Text = name .. (toggled and " [ON]" or " [OFF]")
        Button.TextColor3 = toggled and Color3.fromRGB(90, 255, 90) or Color3.fromRGB(255, 100, 100)
        callback(toggled)
    end)
    yOffset = yOffset + 42
end

CreateToggle("ESP Boxes", getgenv().MatyxSettings.ESP.Boxes, function(s) getgenv().MatyxSettings.ESP.Boxes = s end)
CreateToggle("Aimbot (Hold RMB)", getgenv().MatyxSettings.Aimbot.Enabled, function(s) getgenv().MatyxSettings.Aimbot.Enabled = s end)
CreateToggle("Show FOV Circle", getgenv().MatyxSettings.Aimbot.ShowFOV, function(s) getgenv().MatyxSettings.Aimbot.ShowFOV = s end)
CreateToggle("Triggerbot (Auto Shoot)", getgenv().MatyxSettings.Triggerbot.Enabled, function(s) getgenv().MatyxSettings.Triggerbot.Enabled = s end)
CreateToggle("Auto Strafe", getgenv().MatyxSettings.AutoStrafe.Enabled, function(s) getgenv().MatyxSettings.AutoStrafe.Enabled = s end)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 1, -30)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Menu skryješ/zobrazíš klávesou [Insert]"
InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.SourceSansItalic
InfoLabel.Parent = MainFrame

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

RunService.RenderStepped:Connect(function()
    if FOVCircle then
        if getgenv().MatyxSettings.Aimbot.ShowFOV and getgenv().MatyxSettings.Aimbot.Enabled then
            FOVCircle.Visible = true
            FOVCircle.Radius = getgenv().MatyxSettings.Aimbot.FOV
            FOVCircle.Position = UserInputService:GetMouseLocation()
        else
            FOVCircle.Visible = false
        end
    end
end)

-- Aimbot logika
local function getClosestPlayer()
    local closestPlayer = nil
    local closestPart = nil
    local shortestDistance = getgenv().MatyxSettings.Aimbot.FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local part = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and part then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                        closestPart = part
                    end
                end
            end
        end
    end
    return closestPlayer, closestPart
end

local isAiming = false
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == getgenv().MatyxSettings.Aimbot.Key then
        isAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == getgenv().MatyxSettings.Aimbot.Key then
        isAiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().MatyxSettings.Aimbot.Enabled and isAiming then
        local _, targetPart = getClosestPlayer()
        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
end)

-- Triggerbot logika
task.spawn(function()
    while true do
        task.wait(getgenv().MatyxSettings.Triggerbot.Delay)
        if getgenv().MatyxSettings.Triggerbot.Enabled then
            pcall(function()
                local mouse = LocalPlayer:GetMouse()
                local target = mouse.Target
                if target and target.Parent then
                    local character = target.Parent
                    local humanoid = character:FindFirstChild("Humanoid") or (character.Parent and character.Parent:FindFirstChild("Humanoid"))
                    
                    if humanoid and humanoid.Health > 0 then
                        local player = Players:GetPlayerFromCharacter(character) or Players:GetPlayerFromCharacter(character.Parent)
                        if player and player ~= LocalPlayer then
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait(0.01)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Strafe logika
RunService.RenderStepped:Connect(function()
    if getgenv().MatyxSettings.AutoStrafe.Enabled then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            local direction = math.sin(tick() * 3) > 0 and 1 or -1
            humanoid:Move(Camera.CFrame.RightVector * direction, false)
        end
    end
end)

print("MATYX OWNED [Stable v3] - Načteno bez chyb!")
