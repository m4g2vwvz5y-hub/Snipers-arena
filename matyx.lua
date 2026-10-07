--[[
    Skript: MATYX OWNED [PERSISTENT EDITION]
    Hra: Snipers Arena (Roblox)
    Popis: Kompletní UI, nastavení, ESP, Aimbot, Silent Aim, Auto Strafe 
           + Automatické znovuspuštění při připojení do nové hry/serveru.
]]--

-- Automatické znovuspuštění skriptu při změně serveru/teleportu
if syn and syn.queue_on_teleport then
    syn.queue_on_teleport(script.Source)
elseif queue_on_teleport then
    queue_on_teleport([[
        loadstring(game:HttpGet("SEM_VLOZ_ODKAZ_NA_TVUJ_SKRIPT"))()
    ]])
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Hlavní konfigurační tabulka
getgenv().MatyxSettings = getgenv().MatyxSettings or {
    ESP = {
        Enabled = false,
        BoxColor = Color3.fromRGB(255, 0, 0),
    },
    Aimbot = {
        Enabled = false,
        Key = Enum.UserInputType.MouseButton2,
        FOV = 150,
        Smoothness = 3,
        TargetPart = "Head"
    },
    SilentAim = {
        Enabled = false,
        FOV = 120,
        HitChance = 100
    },
    AutoStrafe = {
        Enabled = false,
        Speed = 0.4
    }
}

-- Odstranění starého GUI pokud už existuje, aby nedocházelo k duplikaci
if CoreGui:FindFirstChild("MatyxOwnedGUI") then
    CoreGui.MatyxOwnedGUI:Destroy()
end

-- Vytvoření hlavního UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MatyxOwnedGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
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
Title.Text = "⚡ MATYX OWNED | Snipers Arena ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Srolovatelný kontejner pro položky nastavení
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -100)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 420)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = MainFrame

local yOffset = 0

-- Funkce pro vytvoření zapínacího tlačítka (Toggle)
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

-- Funkce pro vytvoření číselného nastavení
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

-- Vytvoření prvků v uživatelském rozhraní
CreateToggle("ESP Boxes", getgenv().MatyxSettings.ESP.Enabled, function(state) getgenv().MatyxSettings.ESP.Enabled = state end)
CreateToggle("Aimbot (Hold RMB)", getgenv().MatyxSettings.Aimbot.Enabled, function(state) getgenv().MatyxSettings.Aimbot.Enabled = state end)
CreateValueAdjuster("Aimbot FOV", getgenv().MatyxSettings.Aimbot.FOV, 50, 500, 25, function(v) getgenv().MatyxSettings.Aimbot.FOV = v end)
CreateValueAdjuster("Aimbot Smooth", getgenv().MatyxSettings.Aimbot.Smoothness, 1, 10, 1, function(v) getgenv().MatyxSettings.Aimbot.Smoothness = v end)

CreateToggle("Silent Aim", getgenv().MatyxSettings.SilentAim.Enabled, function(state) getgenv().MatyxSettings.SilentAim.Enabled = state end)
CreateValueAdjuster("Silent Aim FOV", getgenv().MatyxSettings.SilentAim.FOV, 50, 400, 25, function(v) getgenv().MatyxSettings.SilentAim.FOV = v end)

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

-- Klávesa Insert pro schování/zobrazení menu
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
            local targetPart = target.Character[getgenv().MatyxSettings.Aimbot.TargetPart]
            
            if getgenv().MatyxSettings.Aimbot.Smoothness <= 1 then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            else
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), 1 / getgenv().MatyxSettings.Aimbot.Smoothness)
            end
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
            if method == "Raycast" then
                local origin = args[1]
                local direction = (target.Character.Head.Position - origin).Unit * 5000
                args[2] = direction
                return oldNamecall(self, unpack(args))
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- ================= AUTO STRAFE ================= --
RunService.RenderStepped:Count -- opraveno níže
RunService.RenderStepped:Connect(function()
    if getgenv().MatyxSettings.AutoStrafe.Enabled then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        
        if humanoid then
            local timeVal = tick() * (1 / getgenv().MatyxSettings.AutoStrafe.Speed)
            local direction = math.sin(timeVal) > 0 and 1 or -1
            humanoid:Move(Camera.CFrame.RightVector * direction, false)
        end
    end
end)

print("MATYX OWNED [PERSISTENT] - Načteno a připraveno na automatické přenášení!")
