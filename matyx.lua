--[[
    Skript: MATYX OWNED [ULTIMATE EDITION - Final Optimized]
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
        Enabled = true,
        Key = Enum.UserInputType.MouseButton2,
        FOV = 200,
        ShowFOV = true,
        TargetMode = 1 -- 1 = Head, 2 = Torso
    },
    Triggerbot = {
        Enabled = true,
        Delay = 0.01
    },
    MagicBullet = {
        Enabled = true,
    },
    AutoStrafe = {
        Enabled = false,
        Speed = 0.4
    }
}

if CoreGui:FindFirstChild("MatyxOwnedGUI") then
    CoreGui.MatyxOwnedGUI:Destroy()
end

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
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
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
Title.Text = "⚡ MATYX OWNED | Ultra ⚡"
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
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 420)
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
CreateToggle("Aimbot (Hold RMB 100%)", getgenv().MatyxSettings.Aimbot.Enabled, function(s) getgenv().MatyxSettings.Aimbot.Enabled = s end)
CreateToggle("Show FOV Circle", getgenv().MatyxSettings.Aimbot.ShowFOV, function(s) getgenv().MatyxSettings.Aimbot.ShowFOV = s end)
CreateToggle("Triggerbot (Auto Shoot)", getgenv().Matyx
