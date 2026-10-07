--[[
    Skript: MATYX OWNED [ULTIMATE EDITION v2]
    Hra: Snipers Arena (Roblox)
    Funkce: Kruhový FOV, Skeleton & Box ESP, 100% Aimbot (RMB), Triggerbot, Magic Bullet (zapínatelný přes zdi), Auto Strafe + Auto-Reexecute.
]]--

-- Automatické znovuspuštění skriptu při změně serveru/teleportu
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

-- Hlavní konfigurační tabulka
getgenv().MatyxSettings = getgenv().MatyxSettings or {
    ESP = {
        Enabled = false,
        Boxes = true,
        Skeletons = false,
        BoxColor = Color3.fromRGB(255, 0, 0),
        SkeletonColor = Color3.fromRGB(255, 255, 255),
    },
    Aimbot = {
        Enabled = false,
        Key = Enum.UserInputType.MouseButton2,
        FOV = 150,
        ShowFOV = true,
        Smoothness = 1, -- 1 = Instantní 100% snap
        TargetMode = 1 -- 1 = Head, 2 = UpperTorso, 3 = Closest Bone
    },
    Triggerbot = {
        Enabled = false,
        Delay = 0.02 -- Rychlost automatického výstřelu
    },
    MagicBullet = {
        Enabled = false, -- Hitne nepřítele i přes zeď (lze vypnout/zapnout)
    },
    AutoStrafe = {
        Enabled = false,
        Speed = 0.4
    }
}

-- Odstranění starého GUI
if CoreGui:FindFirstChild("MatyxOwnedGUI") then
    CoreGui.MatyxOwnedGUI:Destroy()
end

-- Vytvoření kruhu pro FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8

-- Vytvoření hlavního UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MatyxOwnedGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 540)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Titulek
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.Text = "⚡ MATYX OWNED | Ultimate ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Srolovatelný kontejner pro nastavení
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -100)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 540)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = MainFrame

local yOffset = 0

-- Funkce pro přepínače (Toggle)
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
        if toggled then
            Button.Text = name .. " [ON]"
            Button.TextColor3 = Color3.fromRGB(90, 255, 90)
        else
            Button.Text = name .. " [OFF]"
            Button.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        callback(toggled)
    end)
    
    yOffset = yOffset + 42
end

-- Funkce pro číselné nastavení
local function CreateValueAdjuster(name, currentValue, minVal, maxVal, step, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 35)
    Container.Position = UDim2.new(0, 0, 0, yOffset)
    Container.BackgroundTransparency = 1
    Container.Parent = ScrollingFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "  " .. name .. ": " .. tostring(currentValue)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local val = currentValue

    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Size = UDim2.new(0, 35, 0, 30)
    MinusBtn.Position = UDim2.new(0.65, 0, 0.1, 0)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
    MinusBtn.Text = "-"
    MinusBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    MinusBtn.TextSize = 16
    MinusBtn.Font = Enum.Font.SourceSansBold
    MinusBtn.Parent = Container
    local mCorner = Instance.new("UICorner") mCorner.CornerRadius = UDim.new(0, 4) mCorner.Parent = MinusBtn

    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Size = UDim2.new(0, 35, 0, 30)
    PlusBtn.Position = UDim2.new(0.83, 0, 0.1, 0)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
    PlusBtn.Text = "+"
    PlusBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    PlusBtn.TextSize = 16
    PlusBtn.Font = Enum.Font.SourceSansBold
    PlusBtn.Parent = Container
    local pCorner = Instance.new("UICorner") pCorner.CornerRadius = UDim.new(0, 4) pCorner.Parent = PlusBtn

    MinusBtn.MouseButton1Click:Connect(function()
        if val - step >= minVal then
            val = val - step
            Label.Text = "  " .. name .. ": " .. tostring(val)
            callback(val)
        end
    end)

    PlusBtn.MouseButton1Click:Connect(function()
        if val + step <= maxVal then
            val = val + step
            Label.Text = "  " .. name .. ": " .. tostring(val)
            callback(val)
        end
    end)

    yOffset = yOffset + 42
end

-- Vytvoření UI prvků
CreateToggle("ESP Boxes", getgenv().MatyxSettings.ESP.Boxes, function(state) getgenv().MatyxSettings.ESP.Boxes = state end)
CreateToggle("ESP Skeletons", getgenv().MatyxSettings.ESP.Skeletons, function(state) getgenv().MatyxSettings.ESP.Skeletons = state end)

CreateToggle("Aimbot (Hold RMB 100%)", getgenv().MatyxSettings.Aimbot.Enabled, function(state) getgenv().MatyxSettings.Aimbot.Enabled = state end)
CreateToggle("Show FOV Circle", getgenv().MatyxSettings.Aimbot.ShowFOV, function(state) getgenv().MatyxSettings.Aimbot.ShowFOV = state end)
CreateValueAdjuster("Aimbot FOV", getgenv().MatyxSettings.Aimbot.FOV, 50, 500, 25, function(v) 
    getgenv().MatyxSettings.Aimbot.FOV = v 
    FOVCircle.Radius = v
end)
CreateValueAdjuster("Aim Target (1:Head, 2:Torso, 3:Bone)", getgenv().MatyxSettings.Aimbot.TargetMode, 1, 3, 1, function(v) getgenv().MatyxSettings.Aimbot.TargetMode = v end)

CreateToggle("Triggerbot (Auto Shoot)", getgenv().MatyxSettings.Triggerbot.Enabled, function(state) getgenv().MatyxSettings.Triggerbot.Enabled = state end)
CreateToggle("Magic Bullet (Hit přes zeď)", getgenv().MatyxSettings.MagicBullet.Enabled, function(state) getgenv().MatyxSettings.MagicBullet.Enabled = state end)

CreateToggle("Auto Strafe", getgenv().MatyxSettings.AutoStrafe.Enabled, function(state) getgenv().MatyxSettings.AutoStrafe.Enabled = state end)
CreateValueAdjuster("Strafe Speed", getgenv().MatyxSettings.AutoStrafe.Speed * 10, 1, 10, 1, function(v) getgenv().MatyxSettings.AutoStrafe.Speed = v * 0.1 end)

-- Info label dole
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 35)
InfoLabel.Position = UDim2.new(0, 0, 1, -35)
InfoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
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

-- Vykreslování FOV kruhu
RunService.RenderStepped:Connect(function()
    if getgenv().MatyxSettings.Aimbot.ShowFOV and getgenv().MatyxSettings.Aimbot.Enabled then
        FOVCircle.Visible = true
        FOVCircle.Radius = getgenv().MatyxSettings.Aimbot.FOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
    else
        FOVCircle.Visible = false
    end
end)

-- ================= ESP ================= --
local espCache = {}

local function createESP(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = getgenv().MatyxSettings.ESP.BoxColor
    box.Thickness = 1.5
    box.Filled = false

    local skeletonLines = {
        Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
        Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
    }

    for _, line in ipairs(skeletonLines) do
        line.Visible = false
        line.Color = getgenv().MatyxSettings.ESP.SkeletonColor
        line.Thickness = 1.2
    end

    espCache[player] = {Box = box, Skeletons = skeletonLines}

    player.CharacterRemoving:Connect(function()
        box.Visible = false
        for _, line in ipairs(skeletonLines) do line.Visible = false end
    end)
end

local function removeESP(player)
    if espCache[player] then
        espCache[player].Box:Remove()
        for _, line in ipairs(espCache[player].Skeletons) do line
