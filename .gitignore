-- ══════════════════════════════════════
--   Steal The Egg | Delta Executor
--   Auto Collect + ESP + Speed
-- ══════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- ── Настройки ──
local CFG = {
    AutoCollect = true,
    ESP         = true,
    Speed       = 32,       -- стандарт 16
    JumpPower   = 60,
    Radius      = 60,
    Delay       = 0.05,
    -- Названия яиц (добавь своё если не работает)
    EggNames    = {"Egg", "egg", "EggModel", "Collectible", "Pickup", "Item", "Steal"}
}

-- ── Переиндексация при respawn ──
player.CharacterAdded:Connect(function(c)
    char = c
    hrp  = c:WaitForChild("HumanoidRootPart")
    hum  = c:WaitForChild("Humanoid")
end)

-- ── Скорость ──
local function applySpeed()
    if hum then
        hum.WalkSpeed  = CFG.Speed
        hum.JumpPower  = CFG.JumpPower
    end
end

RunService.Heartbeat:Connect(applySpeed)

-- ── Проверка яйца ──
local function isEgg(obj)
    if not obj:IsA("BasePart") and not obj:IsA("Model") then return false end
    local n = obj.Name:lower()
    for _, tag in ipairs(CFG.EggNames) do
        if n:find(tag:lower()) then return true end
    end
    return false
end

-- ── Получить позицию объекта ──
local function getPos(obj)
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") and obj.PrimaryPart then return obj.PrimaryPart.Position end
    if obj:IsA("Model") then
        local p = obj:FindFirstChildWhichIsA("BasePart")
        return p and p.Position or nil
    end
    return nil
end

-- ── ESP ──
local espFolder = Instance.new("Folder")
espFolder.Name  = "EggESP"
espFolder.Parent = game.Workspace

local function addESP(obj)
    if not CFG.ESP then return end
    local pos = getPos(obj)
    if not pos then return end
    local bb = Instance.new("BillboardGui")
    bb.Name          = "ESP_" .. obj.Name
    bb.Size          = UDim2.new(0, 80, 0, 30)
    bb.StudsOffset   = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop   = true
    bb.Adornee       = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    bb.Parent        = espFolder
    local lbl = Instance.new("TextLabel")
    lbl.Size            = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text            = "🥚 EGG"
    lbl.TextColor3      = Color3.fromRGB(255, 220, 50)
    lbl.TextStrokeTransparency = 0
    lbl.Font            = Enum.Font.GothamBold
    lbl.TextScaled      = true
    lbl.Parent          = bb
end

local function clearESP()
    espFolder:ClearAllChildren()
end

-- ── GUI ──
local gui = Instance.new("ScreenGui")
gui.Name          = "EggCheat"
gui.ResetOnSpawn  = false
gui.Parent        = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size            = UDim2.new(0, 200, 0, 180)
frame.Position        = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
frame.BorderSizePixel = 0
frame.Parent          = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size   = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
title.Text   = "🥚 Steal The Egg"
title.TextColor3 = Color3.fromRGB(255, 220, 50)
title.Font   = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = frame

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 10)
corner2.Parent = title

local function makeBtn(text, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 60)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Text = text
    btn.BorderSizePixel = 0
    btn.Parent = frame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    return btn
end

local btnCollect = makeBtn("🟢 Auto Collect: ON", 38, Color3.fromRGB(20, 80, 30))
local btnESP     = makeBtn("🟢 ESP: ON",          78, Color3.fromRGB(20, 60, 80))
local btnSpeed   = makeBtn("⚡ Speed: " .. CFG.Speed, 118, Color3.fromRGB(60, 30, 80))
local btnScan    = makeBtn("🔍 Scan Eggs",         150, Color3.fromRGB(80, 40, 10))

-- Кнопки
btnCollect.MouseButton1Click:Connect(function()
    CFG.AutoCollect = not CFG.AutoCollect
    if CFG.AutoCollect then
        btnCollect.Text = "🟢 Auto Collect: ON"
        btnCollect.BackgroundColor3 = Color3.fromRGB(20, 80, 30)
    else
        btnCollect.Text = "🔴 Auto Collect: OFF"
        btnCollect.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    end
end)

btnESP.MouseButton1Click:Connect(function()
    CFG.ESP = not CFG.ESP
    if CFG.ESP then
        btnESP.Text = "🟢 ESP: ON"
        btnESP.BackgroundColor3 = Color3.fromRGB(20, 60, 80)
    else
        btnESP.Text = "🔴 ESP: OFF"
        btnESP.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        clearESP()
    end
end)

btnSpeed.MouseButton1Click:Connect(function()
    local speeds = {16, 32, 50, 100}
    local cur = CFG.Speed
    for i, v in ipairs(speeds) do
        if v == cur then
            CFG.Speed = speeds[i % #speeds + 1]
            break
        end
    end
    btnSpeed.Text = "⚡ Speed: " .. CFG.Speed
end)

-- Сканер: печатает все объекты рядом в output
btnScan.MouseButton1Click:Connect(function()
    print("═══ SCAN START ═══")
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local pos = getPos(obj)
            if pos then
                local dist = (hrp.Position - pos).Magnitude
                if dist < 80 then
                    print(string.format("[%.1f] %s | %s", dist, obj.Name, obj:GetFullName()))
                end
            end
        end
    end
    print("═══ SCAN END ═══")
end)

-- ── Главный цикл ──
task.spawn(function()
    while task.wait(CFG.Delay) do
        if not CFG.AutoCollect then continue end
        char = player.Character
        if not char then continue end
        hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        clearESP()

        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if isEgg(obj) then
                local pos = getPos(obj)
                if pos then
                    local dist = (hrp.Position - pos).Magnitude
                    addESP(obj)
                    if dist < CFG.Radius then
                        -- Телепорт к яйцу
                        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                        task.wait(0.1)
                    end
                end
            end
        end
    end
end)

print("✅ Steal The Egg cheat loaded | Delta")
