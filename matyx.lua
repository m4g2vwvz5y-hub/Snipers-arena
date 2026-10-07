--[[
    Skript: MATYX OWNED
    Hra: Snipers Arena (Roblox)
    Funkce: UI, ESP, Aimbot, Silent Aim, Auto Strafe
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Nastavení funkcí
getgenv().MatyxSettings = {
    ESP = {
        Enabled = false,
        BoxColor = Color3.fromRGB(0, 255, 255),
    },
    Aimbot = {
        Enabled = false,
        Key = Enum.UserInputType.MouseButton2,
        FOV = 120,
        Smoothness = 4,
        TargetPart = "Head"
    },
    SilentAim = {
        Enabled = false,
        FOV = 90,
        HitChance = 100
    },
    AutoStrafe = {
        Enabled = false,
        Speed = 0.5 -- Rychlost přepínání stran (menší = rychlejší)
    }
}

-- Odstranění předchozího UI, pokud už běží
if CoreGui:FindFirstChild("MatyxOwnedGUI") then
    CoreGui.MatyxOwnedGUI:Destroy()
end

-- Vytvoření UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MatyxOwnedGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Hlavní okno (zvětšeno pro nové tlačítko)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 465)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -232)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Titulek s názvem
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Title.Text = "⚡ MATYX OWNED | Snipers Arena ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Funkce pro přepínače v UI
local function CreateToggle(name, yPos, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 320, 0, 38)
    Button.Position = UDim2.new(0, 20, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Button.Text = name .. " [OFF]"
    Button.TextColor3 = Color3.fromRGB(255, 90, 90)
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSansBold
    Button.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    local toggled = false
    Button.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            Button.Text = name .. " [ON]"
            Button.TextColor3 = Color3.fromRGB(90, 255, 90)
        else
            Button.Text = name .. " [OFF]"
            Button.TextColor3 = Color3.fromRGB(255, 90, 90)
        end
        callback(toggled)
    end)
end

-- Vytvoření tlačítek včetně Auto Strafe
CreateToggle("ESP Boxes (Wallhack)", 65, function(state)
    getgenv().MatyxSettings.ESP.Enabled = state
end)

CreateToggle("Aimbot (Hold RMB)", 120, function(state)
    getgenv().MatyxSettings.Aimbot.Enabled = state
end)

CreateToggle("Silent Aim (Auto Hit)", 175, function(state)
    getgenv().MatyxSettings.SilentAim.Enabled = state
end)

CreateToggle("Auto Strafe (Dodge)", 230, function(state)
    getgenv().MatyxSettings.AutoStrafe.Enabled = state
end)

-- Info label dole
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 1, -35)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Menu skryješ/zobrazíš klávesou [Insert]"
InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.SourceSansItalic
InfoLabel.Parent = MainFrame

-- Klávesa Insert pro skrytí menu
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
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

    espCache[player] = box

    player.CharacterRemoving:Connect(function()
        box.Visible = false
    end)
end

local function removeESP(player)
    if espCache[player] then
        espCache[player]:Remove()
        espCache[player] = nil
    end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createESP(p) end
end

RunService.RenderStepped:Connect(function()
    for player, box in pairs(espCache) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")

        if getgenv().MatyxSettings.ESP.Enabled and rootPart and humanoid and humanoid.Health > 0 then
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                local size = Vector2.new(1800 / vector.Z, 2600 / vector.Z)
                box.Size = size
                box.Position = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end)

-- ================= AIMBOT ================= --
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = getgenv().MatyxSettings.Aimbot.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild(getgenv().MatyxSettings.Aimbot.TargetPart)
            if part then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude

                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == getgenv().MatyxSettings.Aimbot.Key then
        getgenv().IsAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == getgenv().MatyxSettings.Aimbot.Key then
        getgenv().IsAiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().MatyxSettings.Aimbot.Enabled and getgenv().IsAiming then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(getgenv().MatyxSettings.Aimbot.TargetPart) then
            local targetPart = target.Character[getgenv().MatyxSettings.TargetPart or "Head"] -- Pojistka
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), 1 / getgenv().MatyxSettings.Aimbot.Smoothness)
        end
    end
end)

-- ================= SILENT AIM ================= --
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if getgenv().MatyxSettings.SilentAim.Enabled and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast") then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            if math.random(1, 100) <= getgenv().MatyxSettings.SilentAim.HitChance then
                if method == "Raycast" then
                    local origin = args[1]
                    local direction = (target.Character.Head.Position - origin).Unit * 1000
                    args[2] = direction
                    return oldNamecall(self, unpack(args))
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- ================= AUTO STRAFE ================= --
RunService.RenderStepped:Connect(function()
    if getgenv().MatyxSettings.AutoStrafe.Enabled then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        
        if humanoid then
            -- Automaticky simuluje boční pohyb (střídavě vlevo a vpravo)
            local timeVal = tick() * (1 / getgenv().MatyxSettings.AutoStrafe.Speed)
            local direction = math.sin(timeVal) > 0 and 1 or -1
            
            -- Posílá pokyn k pohybu do strany vůči kameře
            humanoid:Move(Camera.CFrame.RightVector * direction, false)
        end
    end
end)

print("MATYX OWNED - Snipers Arena (s Auto Strafe) úspěšně načteno!")
