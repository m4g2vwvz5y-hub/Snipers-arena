--[[
    Skript: MATYX OWNED [ADVANCED EDITION]
    Hra: Snipers Arena (Roblox)
    Popis: UI, Customizable ESP (Boxes + Skeletons), Aimbot (Target Bone Selection), Silent Aim, Auto Strafe + Auto-Reexecute.
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
        Boxes = true,
        Skeletons = false,
        BoxColor = Color3.fromRGB(255, 0, 0),
        SkeletonColor = Color3.fromRGB(255, 255, 255),
    },
    Aimbot = {
        Enabled = false,
        Key = Enum.UserInputType.MouseButton2,
        FOV = 150,
        Smoothness = 3,
        TargetMode = 1 -- 1 = Head, 2 = UpperTorso, 3 = Closest Bone
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

-- Odstranění starého GUI
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
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 480)
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

-- Vytvoření prvků v uživatelském rozhraní
CreateToggle("ESP Boxes", getgenv().MatyxSettings.ESP.Boxes, function(state) getgenv().MatyxSettings.ESP.Boxes = state end)
CreateToggle("ESP Skeletons (Kosti)", getgenv().MatyxSettings.ESP.Skeletons, function(state) getgenv().MatyxSettings.ESP.Skeletons = state end)

CreateToggle("Aimbot (Hold RMB)", getgenv().MatyxSettings.Aimbot.Enabled, function(state) getgenv().MatyxSettings.Aimbot.Enabled = state end)
CreateValueAdjuster("Aimbot FOV", getgenv().MatyxSettings.Aimbot.FOV, 50, 500, 25, function(v) getgenv().MatyxSettings.Aimbot.FOV = v end)
CreateValueAdjuster("Aimbot Smooth", getgenv().MatyxSettings.Aimbot.Smoothness, 1, 10, 1, function(v) getgenv().MatyxSettings.Aimbot.Smoothness = v end)

-- Výběr části těla pro Aimbot (1: Head, 2: UpperTorso, 3: Closest Bone)
local boneNames = {"Head", "UpperTorso", "Closest Bone"}
CreateValueAdjuster("Aim Target", 1, 1, 3, 1, function(v) 
    getgenv().MatyxSettings.Aimbot.TargetMode = v
    -- Aktualizace textu pro přehled (přepíše popisek v kontejneru dynamicky)
end)

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

-- ================= ESP (Boxes & Skeletons) ================= --
local espCache = {}

local function createESP(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = getgenv().MatyxSettings.ESP.BoxColor
    box.Thickness = 1.5
    box.Filled = false

    -- Definice linek pro skeleton (kosti)
    local skeletonLines = {
        Drawing.new("Line"), -- Head to UpperTorso
        Drawing.new("Line"), -- UpperTorso to LowerTorso
        Drawing.new("Line"), -- UpperTorso to LeftUpperArm
        Drawing.new("Line"), -- LeftUpperArm to LeftLowerArm
        Drawing.new("Line"), -- UpperTorso to RightUpperArm
        Drawing.new("Line"), -- RightUpperArm to RightLowerArm
        Drawing.new("Line"), -- LowerTorso to LeftUpperLeg
        Drawing.new("Line"), -- LeftUpperLeg to LeftLowerLeg
        Drawing.new("Line"), -- LowerTorso to RightUpperLeg
        Drawing.new("Line"), -- RightUpperLeg to RightLowerLeg
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
        for _, line in ipairs(espCache[player].Skeletons) do line:Remove() end
        espCache[player] = nil
    end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createESP(p) end
end

RunService.RenderStepped:Connect(function()
    for player, cache in pairs(espCache) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")

        if rootPart and humanoid and humanoid.Health > 0 then
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            -- Box ESP
            if cache.Box then
                if getgenv().MatyxSettings.ESP.Boxes and onScreen then
                    local size = Vector2.new(1800 / vector.Z, 2600 / vector.Z)
                    cache.Box.Size = size
                    cache.Box.Position = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
                    cache.Box.Visible = true
                else
                    cache.Box.Visible = false
                end
            end

            -- Skeleton ESP
            local skeletons = cache.Skeletons
            if getgenv().MatyxSettings.ESP.Skeletons and onScreen then
                local head = character:FindFirstChild("Head")
                local upperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
                local lowerTorso = character:FindFirstChild("LowerTorso") or upperTorso
                local lUpperArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
                local lLowerArm = character:FindFirstChild("LeftLowerArm") or lUpperArm
                local rUpperArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
                local rLowerArm = character:FindFirstChild("RightLowerArm") or rUpperArm
                local lUpperLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
                local lLowerLeg = character:FindFirstChild("LeftLowerLeg") or lUpperLeg
                local rUpperLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")
                local rLowerLeg = character:FindFirstChild("RightLowerLeg") or rLowerLeg

                local function connectParts(lineIndex, part1, part2)
                    if part1 and part2 and skeletons[lineIndex] then
                        local p1, on1 = Camera:WorldToViewportPoint(part1.Position)
                        local p2, on2 = Camera:WorldToViewportPoint(part2.Position)
                        if on1 or on2 then
                            skeletons[lineIndex].From = Vector2.new(p1.X, p1.Y)
                            skeletons[lineIndex].To = Vector2.new(p2.X, p2.Y)
                            skeletons[lineIndex].Visible = true
                        else
                            skeletons[lineIndex].Visible = false
                        end
                    elseif skeletons[lineIndex] then
                        skeletons[lineIndex].Visible = false
                    end
                end

                connectParts(1, head, upperTorso)
                connectParts(2, upperTorso, lowerTorso)
                connectParts(3, upperTorso, lUpperArm)
                connectParts(4, lUpperArm, lLowerArm)
                connectParts(5, upperTorso, rUpperArm)
                connectParts(6, rUpperArm, rLowerArm)
                connectParts(7, lowerTorso, lUpperLeg)
                connectParts(8, lUpperLeg, lLowerLeg)
                connectParts(9, lowerTorso, rUpperLeg)
                connectParts(10, rUpperLeg, rLowerLeg)
            else
                for _, line in ipairs(skeletons) do line.Visible = false end
            end
        else
            if cache.Box then cache.Box.Visible = false end
            for _, line in ipairs(cache.Skeletons) do line.Visible = false end
        end
    end
end)

-- ================= ADVANCED AIMBOT (Head, Torso, Closest Bone) ================= --
local function getTargetPart(character)
    local mode = getgenv().MatyxSettings.Aimbot.TargetMode
    if mode == 1 then
        return character:FindFirstChild("Head")
    elseif mode == 2 then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    else
        -- Closest Bone (hledá nejbližší kost vůči pozici kamery/myši)
        local parts = {"Head", "UpperTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
        local closestPart = nil
        local shortestDist = 99999
        local mousePos = UserInputService:GetMouseLocation()

        for _, partName in ipairs(parts) do
            local p = character:FindFirstChild(partName)
            if p then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(p.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestPart = p
                    end
                end
            end
        end
        return closestPart or character:FindFirstChild("Head")
    end
end

local function getClosestPlayer()
    local closestPlayer = nil
    local closestPart = nil
    local shortestDistance = getgenv().MatyxSettings.Aimbot.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = getTargetPart(player.Character)
            if part then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
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
        local target, targetPart = getClosestPlayer()
        if target and targetPart then
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
        local target, targetPart = getClosestPlayer()
        if target and targetPart then
            if method == "Raycast" then
                local origin = args[1]
                local direction = (targetPart.Position - origin).Unit * 5000
                args[2] = direction
                return oldNamecall(self, unpack(args))
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
            local timeVal = tick() * (1 / getgenv().MatyxSettings.AutoStrafe.Speed)
            local direction = math.sin(timeVal) > 0 and 1 or -1
            humanoid:Move(Camera.CFrame.RightVector * direction, false)
        end
    end
end)

print("MATYX OWNED [ADVANCED SKELETON EDITION] - Úspěšně načteno!")
