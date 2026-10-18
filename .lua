-- RAIS_hab | Steal The Egg | Delta
-- Простая надёжная версия

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

plr.CharacterAdded:Connect(function(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    hum = c:WaitForChild("Humanoid")
end)

-- СОСТОЯНИЯ
local State = {
    speed     = false,
    fly       = false,
    god       = false,
    collect   = false,
    esp       = false,
    noclip    = false,
    infjump   = false,
}

local speedVal  = 50
local flyVal    = 60
local jumpVal   = 80

-- ESP папка
local espF = Instance.new("Folder", workspace)
espF.Name = "RAIS_ESP"

local EGG_TAGS = {"egg","Egg","EggModel","Collectible","Pickup","steal","Steal","item"}

local function isEgg(name)
    local n = name:lower()
    for _,t in ipairs(EGG_TAGS) do
        if n:find(t:lower()) then return true end
    end
    return false
end

local function getPos(obj)
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart.Position end
        local p = obj:FindFirstChildWhichIsA("BasePart")
        if p then return p.Position end
    end
end

-- ══ GUI ══
local sg = Instance.new("ScreenGui")
sg.Name = "RAIS_hab"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = plr.PlayerGui

-- Main frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 420)
main.Position = UDim2.new(0, 20, 0, 60)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
main.BorderSizePixel = 0
main.Active = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(100, 60, 220)
stroke.Thickness = 1.5

-- Topbar
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(18, 10, 40)
top.BorderSizePixel = 0
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local fix = Instance.new("Frame")
fix.Size = UDim2.new(1, 0, 0, 12)
fix.Position = UDim2.new(0, 0, 1, -12)
fix.BackgroundColor3 = Color3.fromRGB(18, 10, 40)
fix.BorderSizePixel = 0
fix.Parent = top

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -80, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "⚡ RAIS_hab"
titleLbl.TextColor3 = Color3.fromRGB(180, 120, 255)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = top

-- Min/Close
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -60, 0.5, -13)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 13
minBtn.Text = "─"
minBtn.BorderSizePixel = 0
minBtn.Parent = top
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -30, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.Text = "✕"
closeBtn.BorderSizePixel = 0
closeBtn.Parent = top
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Scroll content
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -50)
scroll.Position = UDim2.new(0, 8, 0, 44)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 60, 220)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local pad = Instance.new("UIPadding", scroll)
pad.PaddingTop = UDim.new(0, 6)
pad.PaddingBottom = UDim.new(0, 10)

-- ══ КОМПОНЕНТЫ ══

local order = 0
local function nextOrder() order += 1 return order end

local function section(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "  " .. text
    l.TextColor3 = Color3.fromRGB(100, 80, 180)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = nextOrder()
    l.Parent = scroll
end

-- Кнопка-переключатель
local function toggle(label, icon, onToggle)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
    row.BorderSizePixel = 0
    row.LayoutOrder = nextOrder()
    row.Parent = scroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon .. "  " .. label
    lbl.TextColor3 = Color3.fromRGB(210, 210, 230)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 40, 0, 20)
    pill.Position = UDim2.new(1, -48, 0.5, -10)
    pill.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    pill.BorderSizePixel = 0
    pill.Parent = row
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = pill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local on = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = row

    btn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(pill, TweenInfo.new(0.15), {
            BackgroundColor3 = on
                and Color3.fromRGB(60, 200, 80)
                or  Color3.fromRGB(180, 40, 40)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = on
                and UDim2.new(1, -17, 0.5, -7)
                or  UDim2.new(0,   3, 0.5, -7)
        }):Play()
        onToggle(on)
    end)

    return row
end

-- Кнопка действия
local function action(label, icon, color, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 40, 120)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Text = icon .. "  " .. label
    btn.BorderSizePixel = 0
    btn.LayoutOrder = nextOrder()
    btn.Parent = scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(cb)
    return btn
end

-- Слайдер
local function slider(label, icon, minV, maxV, defV, cb)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
    card.BorderSizePixel = 0
    card.LayoutOrder = nextOrder()
    card.Parent = scroll
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 0, 26)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon .. "  " .. label
    lbl.TextColor3 = Color3.fromRGB(210, 210, 230)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 40, 0, 26)
    valLbl.Position = UDim2.new(1, -44, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defV)
    valLbl.TextColor3 = Color3.fromRGB(140, 100, 255)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.Parent = card

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 5)
    track.Position = UDim2.new(0, 10, 0, 38)
    track.BackgroundColor3 = Color3.fromRGB(35, 25, 70)
    track.BorderSizePixel = 0
    track.Parent = card
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defV-minV)/(maxV-minV), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.Position = UDim2.new((defV-minV)/(maxV-minV), 0, 0.5, 0)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    handle.Text = ""
    handle.Parent = track
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

    local dragging = false
    handle.MouseButton1Down:Connect(function() dragging = true end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMove then
            local abs = track.AbsolutePosition.X
            local w   = track.AbsoluteSize.X
            local t   = math.clamp((i.Position.X - abs) / w, 0, 1)
            local val = math.floor(minV + t * (maxV - minV))
            fill.Size = UDim2.new(t, 0, 1, 0)
            handle.Position = UDim2.new(t, 0, 0.5, 0)
            valLbl.Text = tostring(val)
            cb(val)
        end
    end)
end

-- ══ СТРОИМ GUI ══

section("— ДВИЖЕНИЕ —")

toggle("Speed Boost", "⚡", function(on)
    State.speed = on
    if not on and hum then hum.WalkSpeed = 16 end
end)

slider("Walk Speed", "🏃", 16, 300, speedVal, function(v)
    speedVal = v
end)

slider("Jump Power", "🦘", 50, 300, jumpVal, function(v)
    jumpVal = v
end)

section("— ПОЛЁТ —")

toggle("Fly", "🚀", function(on)
    State.fly = on
    if not on then
        local bg = hrp and hrp:FindFirstChild("RAIS_Gyro")
        local bv = hrp and hrp:FindFirstChild("RAIS_Vel")
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        if hum then hum.PlatformStand = false end
    end
end)

slider("Fly Speed", "💨", 10, 200, flyVal, function(v)
    flyVal = v
end)

section("— ФАРМ —")

toggle("Auto Collect Eggs", "🥚", function(on)
    State.collect = on
end)

toggle("ESP (подсветка яиц)", "👁", function(on)
    State.esp = on
    if not on then espF:ClearAllChildren() end
end)

section("— ТЕЛЕПОРТ —")

action("ТП к яйцу", "🥚", Color3.fromRGB(120, 60, 20), function()
    if not hrp then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isEgg(obj.Name) then
            local pos = getPos(obj)
            if pos then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
                return
            end
        end
    end
end)

action("ТП к концу карты", "🏁", Color3.fromRGB(30, 120, 60), function()
    if not hrp then return end
    local tags = {"End","Finish","Goal","Win","Exit","Flag","Nest","Base"}
    for _, obj in ipairs(workspace:GetDescendants()) do
        for _, t in ipairs(tags) do
            if obj.Name:lower():find(t:lower()) and obj:IsA("BasePart") then
                hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 5, 0))
                return
            end
        end
    end
    hrp.CFrame = CFrame.new(Vector3.new(500, 80, 500))
end)

action("ТП домой (Spawn)", "🏠", Color3.fromRGB(40, 60, 160), function()
    if not hrp then return end
    local sp = workspace:FindFirstChildWhichIsA("SpawnLocation")
    if sp then
        hrp.CFrame = sp.CFrame + Vector3.new(0, 5, 0)
    else
        plr:LoadCharacter()
    end
end)

action("ТП к игроку", "👤", Color3.fromRGB(100, 30, 140), function()
    if not hrp then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(3, 2, 0)
            return
        end
    end
end)

action("Сохранить позицию", "📍", Color3.fromRGB(30, 30, 60), function()
    if hrp then _G.RAIS_Pos = hrp.CFrame end
end)

action("Вернуться к позиции", "↩️", Color3.fromRGB(30, 30, 60), function()
    if hrp and _G.RAIS_Pos then hrp.CFrame = _G.RAIS_Pos end
end)

section("— ПРОЧЕЕ —")

toggle("Godmode (бессмертие)", "🛡", function(on)
    State.god = on
end)

toggle("NoClip (сквозь стены)", "👻", function(on)
    State.noclip = on
end)

toggle("Infinite Jump", "☁️", function(on)
    State.infjump = on
end)

action("Fullbright", "☀️", Color3.fromRGB(60, 50, 10), function()
    game.Lighting.Brightness = 10
    game.Lighting.ClockTime  = 14
    game.Lighting.FogEnd     = 1e6
end)

action("Scan Eggs (F9)", "🔍", Color3.fromRGB(20, 20, 50), function()
    print("=== RAIS_hab SCAN ===")
    local n = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isEgg(obj.Name) then
            local pos = getPos(obj)
            if pos and hrp then
                local d = (hrp.Position - pos).Magnitude
                print(("[%.1f] %s → %s"):format(d, obj.Name, obj:GetFullName()))
                n += 1
            end
        end
    end
    print("Итого: " .. n)
end)

action("Rejoin", "🔃", Color3.fromRGB(20, 20, 50), function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
end)

-- ══ DRAG ══
local draggingWin, dragStart, winStart
top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingWin = true
        dragStart = i.Position
        winStart  = main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if draggingWin and i.UserInputType == Enum.UserInputType.MouseMove then
        local d = i.Position - dragStart
        main.Position = UDim2.new(
            winStart.X.Scale, winStart.X.Offset + d.X,
            winStart.Y.Scale, winStart.Y.Offset + d.Y
        )
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingWin = false
    end
end)

-- ══ MINIMIZE ══
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
        Size = minimized
            and UDim2.new(0, 300, 0, 40)
            or  UDim2.new(0, 300, 0, 420)
    }):Play()
    scroll.Visible = not minimized
    minBtn.Text    = minimized and "□" or "─"
end)

closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- ══ HEARTBEAT LOOP ══
RunService.Heartbeat:Connect(function()
    char = plr.Character
    if not char then return end
    hrp  = char:FindFirstChild("HumanoidRootPart")
    hum  = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    -- Speed
    if State.speed then
        hum.WalkSpeed = speedVal
        hum.JumpPower = jumpVal
    end

    -- Godmode
    if State.god then
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end

    -- NoClip
    if State.noclip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end

    -- Fly
    if State.fly then
        hum.PlatformStand = true
        local bg = hrp:FindFirstChild("RAIS_Gyro") or Instance.new("BodyGyro", hrp)
        bg.Name     = "RAIS_Gyro"
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.D        = 200
        bg.CFrame   = workspace.CurrentCamera.CFrame

        local bv = hrp:FindFirstChild("RAIS_Vel") or Instance.new("BodyVelocity", hrp)
        bv.Name     = "RAIS_Vel"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)

        local dir = Vector3.zero
        local cam = workspace.CurrentCamera
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

        bv.Velocity = dir.Magnitude > 0 and dir.Unit * flyVal or Vector3.zero
    else
        local bg = hrp:FindFirstChild("RAIS_Gyro")
        local bv = hrp:FindFirstChild("RAIS_Vel")
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        if hum.PlatformStand then hum.PlatformStand = false end
    end
end)

-- Infinite jump
UIS.JumpRequest:Connect(function()
    if State.infjump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Auto Collect loop
task.spawn(function()
    while task.wait(0.1) do
        if not State.collect then
            if State.esp then else espF:ClearAllChildren() end
            continue
        end
        char = plr.Character
        if not char then continue end
        hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        espF:ClearAllChildren()

        local eggs = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if isEgg(obj.Name) then
                local pos = getPos(obj)
                if pos then
                    local dist = (hrp.Position - pos).Magnitude
                    table.insert(eggs, {pos=pos, dist=dist, obj=obj})

                    if State.esp then
                        local part = obj:IsA("BasePart") and obj
                            or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if part then
                            local bb = Instance.new("BillboardGui", espF)
                            bb.Size = UDim2.new(0, 80, 0, 30)
                            bb.StudsOffset = Vector3.new(0, 4, 0)
                            bb.AlwaysOnTop = true
                            bb.Adornee = part
                            local tl = Instance.new("TextLabel", bb)
                            tl.Size = UDim2.new(1,0,1,0)
                            tl.BackgroundTransparency = 1
                            tl.Text = "🥚 EGG"
                            tl.TextColor3 = Color3.fromRGB(255, 210, 50)
                            tl.TextStrokeTransparency = 0
                            tl.Font = Enum.Font.GothamBold
                            tl.TextScaled = true
                        end
                    end
                end
            end
        end

        table.sort(eggs, function(a,b) return a.dist < b.dist end)

        for _, e in ipairs(eggs) do
            if not State.collect then break end
            char = plr.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then break end
            hrp.CFrame = CFrame.new(e.pos + Vector3.new(0, 3, 0))
            task.wait(0.1)
        end
    end
end)

print("✅ RAIS_hab запущен")
