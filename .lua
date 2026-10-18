-- ══════════════════════════════════════
--   RAIS_hab | Steal The Egg
--   Full Featured Cheat GUI
-- ══════════════════════════════════════

local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local HttpService   = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse  = player:GetMouse()
local char, hrp, hum

local function refreshChar()
    char = player.Character or player.CharacterAdded:Wait()
    hrp  = char:WaitForChild("HumanoidRootPart")
    hum  = char:WaitForChild("Humanoid")
end
refreshChar()
player.CharacterAdded:Connect(refreshChar)

-- ══ CONFIG ══
local CFG = {
    AutoCollect = false,
    ESP         = false,
    Fly         = false,
    Invincible  = false,
    AutoFarm    = false,
    Speed       = 28,
    JumpPower   = 60,
    FlySpeed    = 50,
    Radius      = 55,
    Delay       = 0.05,
    EggNames    = {"Egg","egg","EggModel","Collectible","Pickup","Item","Steal","egg_"},
}

-- ══ COLORS ══
local C = {
    bg        = Color3.fromRGB(8,   8,  16),
    panel     = Color3.fromRGB(13,  13, 26),
    card      = Color3.fromRGB(18,  18, 36),
    accent    = Color3.fromRGB(120, 80, 255),
    accent2   = Color3.fromRGB(80, 180, 255),
    green     = Color3.fromRGB(60, 210, 100),
    red       = Color3.fromRGB(220, 60,  60),
    yellow    = Color3.fromRGB(255,210,  50),
    text      = Color3.fromRGB(230,230,245),
    subtext   = Color3.fromRGB(130,130,160),
    white     = Color3.fromRGB(255,255,255),
}

-- ══ GUI ROOT ══
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name         = "RAIS_hab"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent       = player.PlayerGui

-- ══ MAIN FRAME ══
local Main = Instance.new("Frame")
Main.Name              = "Main"
Main.Size              = UDim2.new(0, 340, 0, 460)
Main.Position          = UDim2.new(0.5, -170, 0.5, -230)
Main.BackgroundColor3  = C.bg
Main.BorderSizePixel   = 0
Main.ClipsDescendants  = true
Main.Parent            = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

-- Gradient border glow
local stroke = Instance.new("UIStroke", Main)
stroke.Color     = C.accent
stroke.Thickness = 1.5
stroke.Transparency = 0.4

-- ══ TOPBAR ══
local TopBar = Instance.new("Frame")
TopBar.Size              = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3  = C.panel
TopBar.BorderSizePixel   = 0
TopBar.Parent            = Main

Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

-- fix bottom corners of topbar
local topFix = Instance.new("Frame")
topFix.Size             = UDim2.new(1,0,0,14)
topFix.Position         = UDim2.new(0,0,1,-14)
topFix.BackgroundColor3 = C.panel
topFix.BorderSizePixel  = 0
topFix.Parent           = TopBar

-- Logo dot
local dot = Instance.new("Frame")
dot.Size              = UDim2.new(0, 10, 0, 10)
dot.Position          = UDim2.new(0, 14, 0.5, -5)
dot.BackgroundColor3  = C.accent
dot.BorderSizePixel   = 0
dot.Parent            = TopBar
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

-- Title
local Title = Instance.new("TextLabel")
Title.Size              = UDim2.new(0, 160, 1, 0)
Title.Position          = UDim2.new(0, 30, 0, 0)
Title.BackgroundTransparency = 1
Title.Text              = "RAIS_hab"
Title.TextColor3        = C.white
Title.Font              = Enum.Font.GothamBold
Title.TextSize          = 17
Title.TextXAlignment    = Enum.TextXAlignment.Left
Title.Parent            = TopBar

local Sub = Instance.new("TextLabel")
Sub.Size                = UDim2.new(0, 160, 0, 14)
Sub.Position            = UDim2.new(0, 30, 0, 27)
Sub.BackgroundTransparency = 1
Sub.Text                = "Steal The Egg • v2.0"
Sub.TextColor3          = C.subtext
Sub.Font                = Enum.Font.Gotham
Sub.TextSize            = 10
Sub.TextXAlignment      = Enum.TextXAlignment.Left
Sub.Parent              = TopBar

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size              = UDim2.new(0, 28, 0, 28)
MinBtn.Position          = UDim2.new(1, -72, 0.5, -14)
MinBtn.BackgroundColor3  = C.card
MinBtn.TextColor3        = C.subtext
MinBtn.Font              = Enum.Font.GothamBold
MinBtn.TextSize          = 14
MinBtn.Text              = "─"
MinBtn.BorderSizePixel   = 0
MinBtn.Parent            = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size              = UDim2.new(0, 28, 0, 28)
CloseBtn.Position          = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3  = Color3.fromRGB(180, 30, 30)
CloseBtn.TextColor3        = C.white
CloseBtn.Font              = Enum.Font.GothamBold
CloseBtn.TextSize          = 14
CloseBtn.Text              = "✕"
CloseBtn.BorderSizePixel   = 0
CloseBtn.Parent            = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ══ TABS BAR ══
local TabBar = Instance.new("Frame")
TabBar.Size             = UDim2.new(1, -20, 0, 34)
TabBar.Position         = UDim2.new(0, 10, 0, 54)
TabBar.BackgroundColor3 = C.panel
TabBar.BorderSizePixel  = 0
TabBar.Parent           = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding       = UDim.new(0, 2)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment   = Enum.VerticalAlignment.Center

-- ══ CONTENT AREA ══
local Content = Instance.new("ScrollingFrame")
Content.Size               = UDim2.new(1, -20, 1, -104)
Content.Position           = UDim2.new(0, 10, 0, 96)
Content.BackgroundTransparency = 1
Content.BorderSizePixel    = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = C.accent
Content.CanvasSize         = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent             = Main

local ContentLayout = Instance.new("UIListLayout", Content)
ContentLayout.Padding       = UDim.new(0, 8)
ContentLayout.SortOrder     = Enum.SortOrder.LayoutOrder
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentPad = Instance.new("UIPadding", Content)
ContentPad.PaddingTop    = UDim.new(0, 6)
ContentPad.PaddingBottom = UDim.new(0, 10)

-- ══ HELPERS ══
local pages = {}
local currentTab = nil

local function makePage(name)
    local f = Instance.new("Frame")
    f.Name              = name
    f.Size              = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize     = Enum.AutomaticSize.Y
    f.BackgroundTransparency = 1
    f.Visible           = false
    f.LayoutOrder       = 0
    f.Parent            = Content
    local lay = Instance.new("UIListLayout", f)
    lay.Padding    = UDim.new(0, 8)
    lay.SortOrder  = Enum.SortOrder.LayoutOrder
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pages[name] = f
    return f
end

local function makeTab(name, icon, page)
    local btn = Instance.new("TextButton")
    btn.Size              = UDim2.new(0, 74, 0, 28)
    btn.BackgroundColor3  = C.card
    btn.TextColor3        = C.subtext
    btn.Font              = Enum.Font.GothamBold
    btn.TextSize          = 11
    btn.Text              = icon .. " " .. name
    btn.BorderSizePixel   = 0
    btn.Parent            = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for n, p in pairs(pages) do
            p.Visible = (n == page)
        end
        for _, b in ipairs(TabBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = C.card
                b.TextColor3       = C.subtext
            end
        end
        btn.BackgroundColor3 = C.accent
        btn.TextColor3       = C.white
        currentTab = page
    end)
    return btn
end

-- ══ SECTION LABEL ══
local function makeSection(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size                = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text                = "  " .. text
    lbl.TextColor3          = C.subtext
    lbl.Font                = Enum.Font.GothamBold
    lbl.TextSize            = 10
    lbl.TextXAlignment      = Enum.TextXAlignment.Left
    lbl.LayoutOrder         = order or 0
    lbl.Parent              = parent
    return lbl
end

-- ══ TOGGLE BUTTON ══
local function makeToggle(parent, label, icon, order, callback)
    local card = Instance.new("Frame")
    card.Size              = UDim2.new(1, 0, 0, 46)
    card.BackgroundColor3  = C.card
    card.BorderSizePixel   = 0
    card.LayoutOrder       = order
    card.Parent            = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local ico = Instance.new("TextLabel")
    ico.Size               = UDim2.new(0, 36, 1, 0)
    ico.BackgroundTransparency = 1
    ico.Text               = icon
    ico.TextSize           = 18
    ico.Font               = Enum.Font.GothamBold
    ico.Parent             = card

    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(1, -90, 1, 0)
    lbl.Position           = UDim2.new(0, 38, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = label
    lbl.TextColor3         = C.text
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextSize           = 13
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Parent             = card

    -- Toggle pill
    local pill = Instance.new("Frame")
    pill.Size              = UDim2.new(0, 44, 0, 22)
    pill.Position          = UDim2.new(1, -52, 0.5, -11)
    pill.BackgroundColor3  = C.red
    pill.BorderSizePixel   = 0
    pill.Parent            = card
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size              = UDim2.new(0, 16, 0, 16)
    knob.Position          = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3  = C.white
    knob.BorderSizePixel   = 0
    knob.Parent            = pill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = false
    local function toggle()
        state = not state
        TweenService:Create(pill, TweenInfo.new(0.2), {
            BackgroundColor3 = state and C.green or C.red
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state
                and UDim2.new(1, -19, 0.5, -8)
                or  UDim2.new(0,   3, 0.5, -8)
        }):Play()
        if callback then callback(state) end
    end

    local btn = Instance.new("TextButton")
    btn.Size               = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text               = ""
    btn.Parent             = card
    btn.MouseButton1Click:Connect(toggle)

    return card, function() return state end, toggle
end

-- ══ SLIDER ══
local function makeSlider(parent, label, icon, min, max, default, order, callback)
    local card = Instance.new("Frame")
    card.Size              = UDim2.new(1, 0, 0, 60)
    card.BackgroundColor3  = C.card
    card.BorderSizePixel   = 0
    card.LayoutOrder       = order
    card.Parent            = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local ico = Instance.new("TextLabel")
    ico.Size               = UDim2.new(0, 36, 0, 28)
    ico.Position           = UDim2.new(0, 0, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text               = icon
    ico.TextSize           = 16
    ico.Font               = Enum.Font.GothamBold
    ico.Parent             = card

    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(1, -80, 0, 28)
    lbl.Position           = UDim2.new(0, 36, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = label
    lbl.TextColor3         = C.text
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextSize           = 12
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Parent             = card

    local valLbl = Instance.new("TextLabel")
    valLbl.Size             = UDim2.new(0, 44, 0, 28)
    valLbl.Position         = UDim2.new(1, -48, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text             = tostring(default)
    valLbl.TextColor3       = C.accent2
    valLbl.Font             = Enum.Font.GothamBold
    valLbl.TextSize         = 13
    valLbl.Parent           = card

    local track = Instance.new("Frame")
    track.Size              = UDim2.new(1, -20, 0, 6)
    track.Position          = UDim2.new(0, 10, 0, 40)
    track.BackgroundColor3  = Color3.fromRGB(30, 30, 60)
    track.BorderSizePixel   = 0
    track.Parent            = card
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size               = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3   = C.accent
    fill.BorderSizePixel    = 0
    fill.Parent             = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local handle = Instance.new("Frame")
    handle.Size             = UDim2.new(0, 14, 0, 14)
    handle.AnchorPoint      = Vector2.new(0.5, 0.5)
    handle.Position         = UDim2.new((default-min)/(max-min), 0, 0.5, 0)
    handle.BackgroundColor3 = C.white
    handle.BorderSizePixel  = 0
    handle.Parent           = track
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(x)
        local abs = track.AbsolutePosition.X
        local w   = track.AbsoluteSize.X
        local t   = math.clamp((x - abs) / w, 0, 1)
        local val = math.floor(min + t*(max-min))
        fill.Size     = UDim2.new(t, 0, 1, 0)
        handle.Position = UDim2.new(t, 0, 0.5, 0)
        valLbl.Text   = tostring(val)
        if callback then callback(val) end
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; update(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMove then
            update(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    return card
end

-- ══ ACTION BUTTON ══
local function makeAction(parent, label, icon, color, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size              = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3  = color or C.accent
    btn.TextColor3        = C.white
    btn.Font              = Enum.Font.GothamBold
    btn.TextSize          = 13
    btn.Text              = icon .. "  " .. label
    btn.BorderSizePixel   = 0
    btn.LayoutOrder       = order
    btn.Parent            = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
        task.delay(0.15, function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
        end)
        if callback then callback() end
    end)
    return btn
end

-- ══ STATUS BAR ══
local StatusBar = Instance.new("Frame")
StatusBar.Size             = UDim2.new(1, -20, 0, 24)
StatusBar.Position         = UDim2.new(0, 10, 1, -30)
StatusBar.BackgroundColor3 = C.panel
StatusBar.BorderSizePixel  = 0
StatusBar.Parent           = Main
Instance.new("UICorner", StatusBar).CornerRadius = UDim.new(0, 6)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size             = UDim2.new(1, -10, 1, 0)
StatusLbl.Position         = UDim2.new(0, 8, 0, 0)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text             = "⬛  Ready"
StatusLbl.TextColor3       = C.subtext
StatusLbl.Font             = Enum.Font.Gotham
StatusLbl.TextSize         = 10
StatusLbl.TextXAlignment   = Enum.TextXAlignment.Left
StatusLbl.Parent           = StatusBar

local function setStatus(txt, col)
    StatusLbl.Text       = txt
    StatusLbl.TextColor3 = col or C.subtext
end

-- ══ BUILD PAGES ══
local pageMain  = makePage("Main")
local pageFarm  = makePage("Farm")
local pageTele  = makePage("Tele")
local pageMisc  = makePage("Misc")

-- Tabs
local t1 = makeTab("Main",  "🏠", "Main")
local t2 = makeTab("Farm",  "🥚", "Farm")
local t3 = makeTab("Tele",  "🌀", "Tele")
local t4 = makeTab("Misc",  "⚙️",  "Misc")

-- ── PAGE: MAIN ──
makeSection(pageMain, "ДВИЖЕНИЕ", 1)

local _, getSpeed = makeToggle(pageMain, "Speed Boost", "⚡", 2, function(on)
    if on then
        setStatus("⚡  Speed активен", C.yellow)
    else
        if hum then hum.WalkSpeed = 16 end
        setStatus("⬛  Ready", C.subtext)
    end
end)

makeSlider(pageMain, "Walk Speed", "🏃", 16, 300, CFG.Speed, 3, function(v)
    CFG.Speed = v
end)

makeSlider(pageMain, "Jump Power", "🦘", 50, 400, CFG.JumpPower, 4, function(v)
    CFG.JumpPower = v
end)

makeSection(pageMain, "ПОЛЁТ", 5)

local _, getFly, toggleFly = makeToggle(pageMain, "Fly Mode", "🚀", 6, function(on)
    CFG.Fly = on
    setStatus(on and "🚀  Fly активен" or "⬛  Ready", on and C.accent2 or C.subtext)
end)

makeSlider(pageMain, "Fly Speed", "💨", 10, 200, CFG.FlySpeed, 7, function(v)
    CFG.FlySpeed = v
end)

makeSection(pageMain, "ЗАЩИТА", 8)

makeToggle(pageMain, "Godmode (Invincible)", "🛡️", 9, function(on)
    CFG.Invincible = on
    setStatus(on and "🛡️  Godmode ON" or "⬛  Ready", on and C.green or C.subtext)
end)

-- ── PAGE: FARM ──
makeSection(pageFarm, "АВТО ФАРМ", 1)

makeToggle(pageFarm, "Auto Collect Eggs", "🥚", 2, function(on)
    CFG.AutoCollect = on
    setStatus(on and "🥚  Фармим яйца..." or "⬛  Ready", on and C.yellow or C.subtext)
end)

makeToggle(pageFarm, "Auto Farm Loop", "🔄", 3, function(on)
    CFG.AutoFarm = on
    setStatus(on and "🔄  Auto Farm ON" or "⬛  Ready", on and C.green or C.subtext)
end)

makeToggle(pageFarm, "ESP (Яйца на экране)", "👁️", 4, function(on)
    CFG.ESP = on
end)

makeSlider(pageFarm, "Collect Radius", "📡", 20, 200, CFG.Radius, 5, function(v)
    CFG.Radius = v
end)

makeSection(pageFarm, "ИНСТРУМЕНТЫ", 6)

makeAction(pageFarm, "Scan Eggs (Console)", "🔍", C.accent, 7, function()
    print("═══ RAIS_hab SCAN ═══")
    local found = 0
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) then
            local pos
            if obj:IsA("BasePart") then pos = obj.Position
            elseif obj.PrimaryPart then pos = obj.PrimaryPart.Position end
            if pos and hrp then
                local dist = (hrp.Position - pos).Magnitude
                if dist < 100 then
                    print(string.format("[%.1f studs] %s → %s", dist, obj.Name, obj:GetFullName()))
                    found += 1
                end
            end
        end
    end
    print("Найдено объектов: " .. found)
    setStatus("🔍  Scan: " .. found .. " объектов", C.accent2)
end)

-- ── PAGE: TELE ──
makeSection(pageTele, "ТЕЛЕПОРТ", 1)

makeAction(pageTele, "ТП к яйцу", "🥚", C.accent, 2, function()
    if not hrp then return end
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        local function chk(n)
            for _, tag in ipairs(CFG.EggNames) do
                if n:lower():find(tag:lower()) then return true end
            end
        end
        if (obj:IsA("BasePart") or obj:IsA("Model")) and chk(obj.Name) then
            local pos
            if obj:IsA("BasePart") then pos = obj.Position
            elseif obj.PrimaryPart then pos = obj.PrimaryPart.Position
            elseif obj:FindFirstChildWhichIsA("BasePart") then
                pos = obj:FindFirstChildWhichIsA("BasePart").Position
            end
            if pos then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0,4,0))
                setStatus("🌀  ТП к яйцу", C.yellow)
                return
            end
        end
    end
    setStatus("❌  Яйцо не найдено", C.red)
end)

makeAction(pageTele, "ТП к концу карты", "🏁", Color3.fromRGB(50,180,100), 3, function()
    if not hrp then return end
    -- Ищем финишные зоны
    local targets = {"End","Finish","Goal","Win","Finish","Exit","Base","Home","EndZone","Flag"}
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        local n = obj.Name
        for _, tag in ipairs(targets) do
            if n:lower():find(tag:lower()) and obj:IsA("BasePart") then
                hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0,5,0))
                setStatus("🏁  ТП к финишу", C.green)
                return
            end
        end
    end
    -- Если не нашли — телепорт в дальний угол карты
    hrp.CFrame = CFrame.new(Vector3.new(500, 100, 500))
    setStatus("🏁  ТП (авто позиция)", C.green)
end)

makeAction(pageTele, "ТП домой / SpawnPoint", "🏠", Color3.fromRGB(80,80,200), 4, function()
    if not hrp then return end
    local spawn = game.Workspace:FindFirstChild("SpawnLocation")
        or game.Workspace:FindFirstChildWhichIsA("SpawnLocation")
    if spawn then
        hrp.CFrame = spawn.CFrame + Vector3.new(0,5,0)
        setStatus("🏠  ТП домой", C.accent2)
    else
        -- fallback: respawn
        player:LoadCharacter()
        setStatus("🏠  Respawn", C.accent2)
    end
end)

makeAction(pageTele, "ТП к игроку", "👤", Color3.fromRGB(160,80,200), 5, function()
    if not hrp then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(3,2,0)
            setStatus("👤  ТП к " .. p.Name, C.accent)
            return
        end
    end
    setStatus("❌  Нет других игроков", C.red)
end)

makeSection(pageTele, "ПОЗИЦИЯ", 6)

makeAction(pageTele, "Сохранить позицию", "📍", C.card, 7, function()
    if hrp then
        _G.SavedPos = hrp.CFrame
        setStatus("📍  Позиция сохранена", C.green)
    end
end)

makeAction(pageTele, "Вернуться к позиции", "↩️", C.card, 8, function()
    if hrp and _G.SavedPos then
        hrp.CFrame = _G.SavedPos
        setStatus("↩️  Позиция восстановлена", C.accent2)
    else
        setStatus("❌  Нет сохранённой позиции", C.red)
    end
end)

-- ── PAGE: MISC ──
makeSection(pageMisc, "ИГРОК", 1)

makeToggle(pageMisc, "No Clip (сквозь стены)", "👻", 2, function(on)
    _G.NoClip = on
    setStatus(on and "👻  NoClip ON" or "⬛  Ready", on and C.accent or C.subtext)
end)

makeToggle(pageMisc, "Infinite Jump", "☁️", 3, function(on)
    _G.InfJump = on
end)

makeSection(pageMisc, "ВИЗУАЛ", 4)

makeToggle(pageMisc, "Fullbright", "☀️", 5, function(on)
    game.Lighting.Brightness    = on and 10  or 1
    game.Lighting.ClockTime     = on and 14  or game.Lighting.ClockTime
    game.Lighting.FogEnd        = on and 1e6 or 100000
    setStatus(on and "☀️  Fullbright ON" or "⬛  Ready", on and C.yellow or C.subtext)
end)

makeSection(pageMisc, "СЕССИЯ", 6)

makeAction(pageMisc, "Rejoin", "🔃", C.card, 7, function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:Teleport(game.PlaceId, player)
end)

makeAction(pageMisc, "Respawn", "💀", C.card, 8, function()
    player:LoadCharacter()
end)

-- ══ OPEN FIRST TAB ══
t1:MouseButton1Click()

-- ══ MINIMIZE / CLOSE ══
local minimized = false
local fullH     = UDim2.new(0, 340, 0, 460)
local miniH     = UDim2.new(0, 340, 0, 48)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
        Size = minimized and miniH or fullH
    }):Play()
    MinBtn.Text = minimized and "□" or "─"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ══ DRAG ══
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging  = true
        dragStart = i.Position
        startPos  = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMove then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- ══ LOGIC LOOPS ══

-- Speed & Jump loop
RunService.Heartbeat:Connect(function()
    if not char or not hum then return end

    -- Speed
    if getSpeed and getSpeed() then
        hum.WalkSpeed = CFG.Speed
        hum.JumpPower = CFG.JumpPower
    end

    -- Godmode
    if CFG.Invincible then
        hum.Health    = hum.MaxHealth
    end

    -- NoClip
    if _G.NoClip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ══ FLY ══
local flyConn
local function startFly()
    if not hrp then return end
    local bg = Instance.new("BodyGyro", hrp)
    bg.Name = "FlyGyro"; bg.MaxTorque = Vector3.new(1e9,1e9,1e9); bg.D = 100

    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "FlyVel"; bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Velocity = Vector3.zero

    flyConn = RunService.Heartbeat:Connect(function()
        if not CFG.Fly then
            bg:Destroy(); bv:Destroy()
            if flyConn then flyConn:Disconnect() end
            return
        end
        local cam = workspace.CurrentCamera
        local mv  = Vector3.zero
        local spd = CFG.FlySpeed
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv = mv + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv = mv - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv = mv - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv = mv + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mv = mv - Vector3.new(0,1,0) end
        if mv.Magnitude > 0 then mv = mv.Unit * spd end
        bv.Velocity = mv
        bg.CFrame   = cam.CFrame
    end)
end

-- Watch CFG.Fly
task.spawn(function()
    local was = false
    while task.wait(0.1) do
        if CFG.Fly and not was then
            was = true; startFly()
        elseif not CFG.Fly then
            was = false
        end
    end
end)

-- ══ ESP ══
local espFolder = Instance.new("Folder", workspace)
espFolder.Name  = "RAIS_ESP"

local function clearESP() espFolder:ClearAllChildren() end

local function addESP(obj)
    if not CFG.ESP then return end
    local part = obj:IsA("BasePart") and obj
        or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
    if not part then return end
    local bb  = Instance.new("BillboardGui", espFolder)
    bb.Size         = UDim2.new(0, 90, 0, 34)
    bb.StudsOffset  = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop  = true
    bb.Adornee      = part
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size        = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text        = "🥚 EGG"
    lbl.TextColor3  = C.yellow
    lbl.TextStrokeTransparency = 0
    lbl.Font        = Enum.Font.GothamBold
    lbl.TextScaled  = true
end

-- ══ AUTO COLLECT / FARM LOOP ══
local function isEgg(obj)
    local n = obj.Name:lower()
    for _, tag in ipairs(CFG.EggNames) do
        if n:find(tag:lower()) then return true end
    end
    return false
end

local function getPos(obj)
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart.Position end
        local p = obj:FindFirstChildWhichIsA("BasePart")
        return p and p.Position or nil
    end
end

task.spawn(function()
    while task.wait(CFG.Delay) do
        if not CFG.AutoCollect and not CFG.AutoFarm then continue end
        char = player.Character
        if not char then continue end
        hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        clearESP()

        local eggs = {}
        for _, obj in ipairs(game.Workspace:GetDescendants()) do
            if isEgg(obj) then
                local pos = getPos(obj)
                if pos then
                    table.insert(eggs, {obj=obj, pos=pos, dist=(hrp.Position-pos).Magnitude})
                    addESP(obj)
                end
            end
        end

        -- Сортировка по дистанции
        table.sort(eggs, function(a,b) return a.dist < b.dist end)

        for _, e in ipairs(eggs) do
            if not CFG.AutoCollect and not CFG.AutoFarm then break end
            char = player.Character
            hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then break end
            if e.dist < CFG.Radius or CFG.AutoFarm then
                hrp.CFrame = CFrame.new(e.pos + Vector3.new(0, 3, 0))
                task.wait(0.08)
            end
        end
    end
end)

print("✅ RAIS_hab loaded | Steal The Egg")
setStatus("✅  RAIS_hab готов", C.green)
