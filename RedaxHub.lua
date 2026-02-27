--[[
╔══════════════════════════════════════════════════════════════╗
║        RedaxHub UI Library  v2.0  —  Black & Red            ║
║        discord.gg/TEKctkta                                  ║
╠══════════════════════════════════════════════════════════════╣
║  KULLANIM:                                                   ║
║  local RH = loadstring(game:HttpGet("RAW_URL"))()           ║
║                                                              ║
║  local W = RH:CreateWindow({                                 ║
║      Title    = "Benim Hub",                                 ║
║      SubTitle = "v1.0",                                      ║
║      KeySystem = true,                                       ║
║      KeySettings = {                                         ║
║          Title = "Key Doğrulama",                            ║
║          Note  = "discord.gg/TEKctkta",                      ║
║          Keys  = { "REDAX-2025", "VIP-KEY" },                ║
║          SaveKey = true,                                     ║
║      }                                                       ║
║  })                                                          ║
║                                                              ║
║  local Tab  = W:CreateTab("Sekme", 0)                        ║
║  local Sect = Tab:CreateSection("Bölüm")                     ║
║                                                              ║
║  Sect:CreateToggle({ Name="Ad", Default=false,               ║
║      Callback=function(v) end })                             ║
║  Sect:CreateSlider({ Name="Ad", Min=0, Max=100,              ║
║      Default=50, Callback=function(v) end })                 ║
║  Sect:CreateButton({ Name="Ad",                              ║
║      Callback=function() end })                              ║
║  Sect:CreateDropdown({ Name="Ad",                            ║
║      Options={"A","B"}, Default="A",                         ║
║      Callback=function(v) end })                             ║
║  Sect:CreateInput({ Name="Ad",                               ║
║      Callback=function(v,e) end })                           ║
║  Sect:CreateKeybind({ Name="Ad",                             ║
║      Default=Enum.KeyCode.F,                                 ║
║      Callback=function() end })                              ║
║  Sect:CreateColorPicker({ Name="Ad",                         ║
║      Default=Color3.fromRGB(220,30,30),                      ║
║      Callback=function(c) end })                             ║
║  Sect:CreateLabel("Metin")                                   ║
║  Sect:CreateSeparator()                                      ║
║                                                              ║
║  W:Notify({ Title="Başlık", Content="İçerik",                ║
║      Type="Success", Duration=5 })                           ║
╚══════════════════════════════════════════════════════════════╝
]]

-- ════════════════════════════════════════════
--  SERVİSLER
-- ════════════════════════════════════════════
local TS  = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS  = game:GetService("RunService")
local CG  = game:GetService("CoreGui")

-- ════════════════════════════════════════════
--  YARDIMCILAR
-- ════════════════════════════════════════════
local function New(class, props)
    local ok, obj = pcall(Instance.new, class)
    if not ok then return nil end
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then pcall(function() obj[k] = v end) end
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Tween(obj, t, props, sty, dir)
    if not obj or not props then return end
    local tw = TS:Create(obj,
        TweenInfo.new(t or .2, sty or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props)
    tw:Play(); return tw
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p
    return c
end

local function Stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.new()
    s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function Pad(p, t, r, b, l)
    local pd = Instance.new("UIPadding")
    pd.PaddingTop    = UDim.new(0, t or 6)
    pd.PaddingRight  = UDim.new(0, r or 6)
    pd.PaddingBottom = UDim.new(0, b or 6)
    pd.PaddingLeft   = UDim.new(0, l or 6)
    pd.Parent = p
    return pd
end

local function List(p, gap)
    local ll = Instance.new("UIListLayout")
    ll.SortOrder   = Enum.SortOrder.LayoutOrder
    ll.Padding     = UDim.new(0, gap or 4)
    ll.Parent      = p
    return ll
end

-- ════════════════════════════════════════════
--  RENKLER
-- ════════════════════════════════════════════
local K = {
    BG1   = Color3.fromRGB(10,  10,  13),
    BG2   = Color3.fromRGB(16,  16,  21),
    BG3   = Color3.fromRGB(23,  23,  30),
    BG4   = Color3.fromRGB(32,  32,  41),
    BG5   = Color3.fromRGB(42,  42,  54),
    R     = Color3.fromRGB(220, 30,  30),
    RB    = Color3.fromRGB(255, 65,  65),
    RD    = Color3.fromRGB(130, 14,  14),
    RDIM  = Color3.fromRGB(70,  10,  10),
    BRD   = Color3.fromRGB(42,  42,  55),
    BRD2  = Color3.fromRGB(58,  58,  75),
    T1    = Color3.fromRGB(238, 238, 245),
    T2    = Color3.fromRGB(155, 155, 172),
    T3    = Color3.fromRGB(85,  85,  105),
    W     = Color3.fromRGB(255, 255, 255),
    BLK   = Color3.fromRGB(0,   0,   0),
    GRN   = Color3.fromRGB(48,  200, 85),
    YLW   = Color3.fromRGB(220, 170, 0),
    MAT   = Color3.fromRGB(0,   220, 55),
}

-- ════════════════════════════════════════════
--  KÜTÜPHANENİN KENDİSİ
-- ════════════════════════════════════════════
local Redax = { Flags = {} }

-- ─────────────────────────────────────────────
--  BİLDİRİM SİSTEMİ
-- ─────────────────────────────────────────────
local _NH -- notif holder

local function initNotif(parentSG)
    if _NH and _NH.Parent then return end
    local holder = New("Frame", {
        Name = "RedaxNotifHolder",
        Size = UDim2.fromOffset(300, 0),
        Position = UDim2.new(1, -308, 1, -8),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        ZIndex = 50,
        Parent = parentSG
    })
    local ll = List(holder, 6)
    ll.VerticalAlignment = Enum.VerticalAlignment.Bottom
    ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        holder.Size = UDim2.fromOffset(300, ll.AbsoluteContentSize.Y)
    end)
    _NH = holder
end

function Redax:Notify(cfg)
    if not _NH then return end
    cfg = cfg or {}
    local title    = cfg.Title    or "RedaxHub"
    local content  = cfg.Content  or ""
    local duration = cfg.Duration or 5
    local ntype    = cfg.Type     or "Info"
    local tCol = ({Info=K.R,Success=K.GRN,Warning=K.YLW,Error=K.R})[ntype] or K.R

    local card = New("Frame", {
        Name = "Card",
        Size = UDim2.fromOffset(300, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = K.BG2,
        ZIndex = 51,
        Parent = _NH
    })
    Corner(card, 8); Stroke(card, K.BRD, 1)

    -- sol bar
    New("Frame", { Size=UDim2.fromOffset(3,1000), BackgroundColor3=tCol, ZIndex=52, Parent=card })

    local inner = New("Frame", {
        Size=UDim2.new(1,-3,0,0), AutomaticSize=Enum.AutomaticSize.Y,
        Position=UDim2.fromOffset(3,0), BackgroundTransparency=1, ZIndex=52, Parent=card
    })
    Pad(inner, 10, 12, 10, 12)

    New("TextLabel", {
        Size=UDim2.new(1,0,0,18), BackgroundTransparency=1,
        Text=title, TextColor3=K.T1, Font=Enum.Font.GothamBold,
        TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=53, Parent=inner
    })
    New("TextLabel", {
        Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
        Position=UDim2.fromOffset(0,22),
        BackgroundTransparency=1, Text=content,
        TextColor3=K.T2, Font=Enum.Font.Gotham, TextSize=11,
        TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=53, Parent=inner
    })

    -- progress bar
    local pbg = New("Frame", { Size=UDim2.new(1,0,0,2), BackgroundColor3=K.BG4, ZIndex=52, Parent=card })
    Corner(pbg, 1)
    local pfill = New("Frame", { Size=UDim2.new(1,0,1,0), BackgroundColor3=tCol, ZIndex=53, Parent=pbg })
    Corner(pfill, 1)

    -- animasyon
    card.Position = UDim2.fromOffset(320, 0)
    Tween(card, .35, {Position=UDim2.fromOffset(0,0)}, Enum.EasingStyle.Back)
    Tween(pfill, duration, {Size=UDim2.new(0,0,1,0)}, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        Tween(card, .3, {Position=UDim2.fromOffset(320,0)})
        task.wait(.35); card:Destroy()
    end)
end

-- ─────────────────────────────────────────────
--  KEY SİSTEMİ  (Matrix / Glitch)
-- ─────────────────────────────────────────────
local function RunKeyScreen(ks, done)
    ks = ks or {}
    local keys    = ks.Keys    or {}
    local save    = ks.SaveKey ~= false
    local discURL = "https://discord.gg/TEKctkta"
    local ttl     = ks.Title  or "Key Doğrulama"
    local note    = ks.Note   or "discord.gg/TEKctkta"

    -- Kayıtlı key var mı?
    if save then
        local ok, sv = pcall(readfile, "redax_key.txt")
        if ok and sv then
            sv = sv:match("^%s*(.-)%s*$")
            for _, k in ipairs(keys) do
                if sv == k then done(true); return end
            end
        end
    end

    local sg = New("ScreenGui", {
        Name="RedaxKeyGui", ResetOnSpawn=false,
        DisplayOrder=200, ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
        Parent=CG
    })

    -- arka karartma
    local overlay = New("Frame", {
        Size=UDim2.fromScale(1,1), BackgroundColor3=K.BLK,
        BackgroundTransparency=1, ZIndex=1, Parent=sg
    })
    Tween(overlay, .5, {BackgroundTransparency=.6})

    -- ── MATRİS YAĞMURU
    local chars   = "01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホ"
    local cols    = {}
    local matOn   = true
    for i = 1, 30 do
        local lbl = New("TextLabel", {
            Size=UDim2.fromOffset(18,2000),
            Position=UDim2.fromOffset((i-1)*36-40, -800),
            BackgroundTransparency=1, Text="",
            TextColor3=K.MAT, Font=Enum.Font.Code, TextSize=12,
            TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top,
            ZIndex=2, Parent=sg
        })
        table.insert(cols, lbl)
    end
    task.spawn(function()
        while matOn do
            for _, c in ipairs(cols) do
                local s = ""
                for _ = 1, math.random(10,28) do
                    local i = math.random(1, #chars)
                    s = s .. chars:sub(i,i) .. "\n"
                end
                c.Text = s
                c.TextTransparency = math.random(2,8)/10
                c.TextColor3 = (math.random()>.85) and K.W or K.MAT
            end
            task.wait(.08)
        end
    end)

    -- ── ANA PANEL
    local panel = New("Frame", {
        Size=UDim2.fromOffset(0,0),
        AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.5,.5),
        BackgroundColor3=K.BG1,
        BackgroundTransparency=1,
        ZIndex=10, Parent=sg
    })
    Corner(panel, 12)
    Stroke(panel, K.R, 1)

    -- kırmızı üst çizgi (sıfırdan genişler)
    local topLine = New("Frame", {
        Size=UDim2.fromOffset(0,2),
        BackgroundColor3=K.R, ZIndex=11, Parent=panel
    })
    Corner(topLine,1)

    -- Panel büyüme animasyonu
    task.wait(.25)
    Tween(panel, .55, {Size=UDim2.fromOffset(420,290), BackgroundTransparency=0}, Enum.EasingStyle.Back)
    Tween(topLine, .55, {Size=UDim2.fromOffset(420,2)}, Enum.EasingStyle.Quart)

    -- LOGO (type-write)
    local logoLbl = New("TextLabel", {
        Size=UDim2.new(1,0,0,46), Position=UDim2.fromOffset(0,6),
        BackgroundTransparency=1, Text="",
        Font=Enum.Font.GothamBold, TextSize=21,
        TextColor3=K.T1, ZIndex=11, Parent=panel
    })

    task.spawn(function()
        task.wait(.55)
        local full = "  REDAX HUB  \\  "..ttl
        for i = 1, #full do
            logoLbl.Text = full:sub(1,i)..(i<#full and "_" or "")
            task.wait(math.random(2,7)/100)
        end
    end)

    -- Note
    local noteLbl = New("TextLabel", {
        Size=UDim2.new(1,-24,0,20), Position=UDim2.fromOffset(12,56),
        BackgroundTransparency=1, Text=note,
        Font=Enum.Font.Gotham, TextSize=11,
        TextColor3=K.T3, TextXAlignment=Enum.TextXAlignment.Left,
        TextWrapped=true, ZIndex=11, Parent=panel
    })

    -- ayırıcı
    New("Frame", {
        Size=UDim2.new(1,-24,0,1), Position=UDim2.fromOffset(12,82),
        BackgroundColor3=K.BRD, ZIndex=11, Parent=panel
    })

    -- INPUT ALANI
    local iBG = New("Frame", {
        Size=UDim2.new(1,-24,0,42), Position=UDim2.fromOffset(12,96),
        BackgroundColor3=K.BG3, ZIndex=11, Parent=panel
    })
    Corner(iBG, 8)
    local iStroke = Stroke(iBG, K.BRD, 1)

    -- cursor ibaresi
    New("TextLabel", {
        Size=UDim2.fromOffset(26,42), BackgroundTransparency=1,
        Text="›", Font=Enum.Font.GothamBold, TextSize=20,
        TextColor3=K.R, ZIndex=12, Parent=iBG
    })

    local iBox = New("TextBox", {
        Size=UDim2.new(1,-34,1,0), Position=UDim2.fromOffset(30,0),
        BackgroundTransparency=1,
        PlaceholderText="Key'inizi buraya girin...",
        PlaceholderColor3=K.T3, Text="",
        Font=Enum.Font.Code, TextSize=13,
        TextColor3=K.MAT, ClearTextOnFocus=false,
        ZIndex=12, Parent=iBG
    })

    iBox.Focused:Connect(function()
        Tween(iBG,.15,{BackgroundColor3=K.BG4})
        iStroke.Color=K.R; iStroke.Thickness=1.5
    end)
    iBox.FocusLost:Connect(function()
        Tween(iBG,.15,{BackgroundColor3=K.BG3})
        iStroke.Color=K.BRD; iStroke.Thickness=1
    end)

    -- status
    local stLbl = New("TextLabel", {
        Size=UDim2.new(1,-24,0,18), Position=UDim2.fromOffset(12,146),
        BackgroundTransparency=1, Text="",
        Font=Enum.Font.GothamItalic, TextSize=11,
        TextColor3=K.T3, TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=11, Parent=panel
    })

    -- ── BUTONLAR
    local bRow = New("Frame", {
        Size=UDim2.new(1,-24,0,40), Position=UDim2.new(0,12,1,-52),
        BackgroundTransparency=1, ZIndex=11, Parent=panel
    })

    -- Discord
    local bDisc = New("TextButton", {
        Size=UDim2.fromOffset(136,40), BackgroundColor3=K.BG3,
        Text="", ZIndex=12, Parent=bRow
    })
    Corner(bDisc, 8); Stroke(bDisc, K.BRD, 1)
    New("TextLabel", {
        Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
        Text="💬  Discord", Font=Enum.Font.GothamBold, TextSize=13,
        TextColor3=K.T2, ZIndex=13, Parent=bDisc
    })

    -- Doğrula
    local bVerify = New("TextButton", {
        Size=UDim2.fromOffset(148,40), AnchorPoint=Vector2.new(1,0),
        Position=UDim2.new(1,0,0,0),
        BackgroundColor3=K.R, Text="", ZIndex=12, Parent=bRow
    })
    Corner(bVerify, 8)
    New("TextLabel", {
        Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
        Text="✔  Doğrula", Font=Enum.Font.GothamBold, TextSize=14,
        TextColor3=K.W, ZIndex=13, Parent=bVerify
    })

    bDisc.MouseEnter:Connect(function()   Tween(bDisc,.1,{BackgroundColor3=K.BG4}) end)
    bDisc.MouseLeave:Connect(function()   Tween(bDisc,.1,{BackgroundColor3=K.BG3}) end)
    bVerify.MouseEnter:Connect(function() Tween(bVerify,.1,{BackgroundColor3=K.RB}) end)
    bVerify.MouseLeave:Connect(function() Tween(bVerify,.1,{BackgroundColor3=K.R}) end)

    -- Discord tıklama
    bDisc.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(discURL)
            stLbl.Text = "✔  Link panoya kopyalandı!"
            stLbl.TextColor3 = K.GRN
        end
    end)

    -- GLITCH efekti
    local function glitch()
        for _ = 1, 7 do
            panel.Position = UDim2.new(.5, math.random(-7,7), .5, math.random(-5,5))
            task.wait(.035)
        end
        panel.Position = UDim2.fromScale(.5,.5)
    end

    -- Doğrulama
    local function verify()
        local entered = iBox.Text:match("^%s*(.-)%s*$")
        if entered == "" then
            stLbl.Text = "⚠  Lütfen bir key girin."
            stLbl.TextColor3 = K.YLW; return
        end
        local valid = false
        for _, k in ipairs(keys) do
            if entered == k then valid=true; break end
        end
        if valid then
            stLbl.Text = "✔  Geçerli key — yükleniyor..."
            stLbl.TextColor3 = K.GRN
            iStroke.Color = K.GRN
            if save then pcall(writefile,"redax_key.txt",entered) end
            task.wait(.9)
            matOn = false
            Tween(panel,.4,{BackgroundTransparency=1,Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back,Enum.EasingDirection.In)
            Tween(overlay,.35,{BackgroundTransparency=1})
            task.wait(.45); sg:Destroy(); done(true)
        else
            stLbl.Text = "✖  Geçersiz key!"; stLbl.TextColor3 = K.R
            Tween(iBG,.08,{BackgroundColor3=K.RDIM})
            task.wait(.1); Tween(iBG,.3,{BackgroundColor3=K.BG3})
            task.spawn(glitch)
        end
    end

    bVerify.MouseButton1Click:Connect(verify)
    iBox.FocusLost:Connect(function(e) if e then verify() end end)
end

-- ════════════════════════════════════════════
--  ANA PENCERE
-- ════════════════════════════════════════════
function Redax:CreateWindow(cfg)
    cfg = cfg or {}

    -- KEY SİSTEMİ
    if cfg.KeySystem then
        local passed = false
        RunKeyScreen(cfg.KeySettings or {}, function() passed=true end)
        local t = 0
        repeat task.wait(.05); t=t+.05 until passed or t>120
        if not passed then return nil end
    end

    -- SCREEN GUI
    local sg = New("ScreenGui", {
        Name="RedaxHub", ResetOnSpawn=false,
        DisplayOrder=100, ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
        Parent=CG
    })
    initNotif(sg)

    local W  = cfg.Size and cfg.Size.X.Offset or 590
    local H  = cfg.Size and cfg.Size.Y.Offset or 475
    local TW = cfg.TabWidth or 150

    -- ── ANA ÇERÇEVE
    local main = New("Frame", {
        Name="Main", Size=UDim2.fromOffset(W,H),
        Position=UDim2.fromScale(.5,.5), AnchorPoint=Vector2.new(.5,.5),
        BackgroundColor3=K.BG1, ClipsDescendants=false,
        ZIndex=5, Parent=sg
    })
    Corner(main, 10)
    Stroke(main, K.BRD, 1)

    -- gölge (image slice trick — FPS dostu)
    New("ImageLabel", {
        Size=UDim2.new(1,40,1,40), Position=UDim2.fromOffset(-20,-20),
        BackgroundTransparency=1,
        Image="rbxassetid://6014261993",
        ImageColor3=K.BLK, ImageTransparency=.65,
        ScaleType=Enum.ScaleType.Slice, SliceCenter=Rect.new(49,49,450,450),
        ZIndex=4, Parent=main
    })

    -- kırmızı üst çizgi
    New("Frame", { Size=UDim2.new(1,0,0,2), BackgroundColor3=K.R, ZIndex=6, Parent=main })

    -- ── TOPBAR
    local topbar = New("Frame", {
        Size=UDim2.new(1,0,0,46), Position=UDim2.fromOffset(0,2),
        BackgroundColor3=K.BG2, ZIndex=6, Parent=main
    })

    -- Logo RichText
    New("TextLabel", {
        Size=UDim2.fromOffset(190,46), Position=UDim2.fromOffset(14,0),
        BackgroundTransparency=1, RichText=true,
        Text='<font color="#DC1E1E"><b>Redax</b></font><font color="#F0F0F5">Hub</font>',
        Font=Enum.Font.GothamBold, TextSize=19, TextColor3=K.T1,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7, Parent=topbar
    })
    New("TextLabel", {
        Size=UDim2.fromOffset(220,46), Position=UDim2.fromOffset(108,0),
        BackgroundTransparency=1, Text=cfg.SubTitle or "v2.0",
        Font=Enum.Font.GothamItalic, TextSize=11, TextColor3=K.T3,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7, Parent=topbar
    })

    -- Kontrol butonları
    local function ctrlBtn(xOff, bgCol, lbl)
        local b = New("TextButton", {
            Size=UDim2.fromOffset(22,22), AnchorPoint=Vector2.new(0,.5),
            Position=UDim2.new(1,xOff,.5,0),
            BackgroundColor3=bgCol, Text=lbl,
            TextColor3=K.W, Font=Enum.Font.GothamBold, TextSize=11,
            ZIndex=8, Parent=topbar
        })
        Corner(b,11); return b
    end

    local btnClose = ctrlBtn(-30, Color3.fromRGB(175,28,28), "✕")
    local btnMin   = ctrlBtn(-56, K.BG4, "─")

    btnClose.MouseEnter:Connect(function() Tween(btnClose,.1,{BackgroundColor3=K.RB}) end)
    btnClose.MouseLeave:Connect(function() Tween(btnClose,.1,{BackgroundColor3=Color3.fromRGB(175,28,28)}) end)
    btnMin.MouseEnter:Connect(function()   Tween(btnMin,.1,{BackgroundColor3=K.BG5}) end)
    btnMin.MouseLeave:Connect(function()   Tween(btnMin,.1,{BackgroundColor3=K.BG4}) end)

    local minimized = false
    btnClose.MouseButton1Click:Connect(function()
        Tween(main,.3,{Size=UDim2.fromOffset(W,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.wait(.35); sg:Destroy()
    end)
    btnMin.MouseButton1Click:Connect(function()
        minimized = not minimized
        Tween(main,.28,{Size=UDim2.fromOffset(W, minimized and 50 or H)})
        btnMin.Text = minimized and "□" or "─"
    end)

    -- DRAGGABLE
    local drag, dStart, dOrig = false, nil, nil
    topbar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; dStart=i.Position; dOrig=main.Position
        end
    end)
    topbar.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d = i.Position-dStart
            main.Position = UDim2.new(dOrig.X.Scale,dOrig.X.Offset+d.X,dOrig.Y.Scale,dOrig.Y.Offset+d.Y)
        end
    end)

    -- ── SOL PANEL
    local leftPanel = New("Frame", {
        Size=UDim2.new(0,TW,1,-50), Position=UDim2.fromOffset(0,50),
        BackgroundColor3=K.BG2, ClipsDescendants=true, ZIndex=6, Parent=main
    })

    local tabScroll = New("ScrollingFrame", {
        Size=UDim2.new(1,0,1,-8), Position=UDim2.fromOffset(0,4),
        BackgroundTransparency=1, ScrollBarThickness=0,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Parent=leftPanel
    })
    Pad(tabScroll,4,4,4,4)
    List(tabScroll,3)

    New("TextLabel", {
        Size=UDim2.new(1,0,0,22), Position=UDim2.new(0,0,1,-22),
        BackgroundColor3=K.BG1, BackgroundTransparency=0,
        Text="discord.gg/TEKctkta", Font=Enum.Font.Gotham, TextSize=9,
        TextColor3=K.T3, ZIndex=7, Parent=leftPanel
    })

    -- ayırıcı
    New("Frame", {
        Size=UDim2.fromOffset(1,9999), Position=UDim2.new(0,TW,0,0),
        BackgroundColor3=K.BRD, ZIndex=6, Parent=main
    })

    -- ── SAĞ PANEL
    local rightPanel = New("Frame", {
        Size=UDim2.new(1,-TW-1,1,-50), Position=UDim2.new(0,TW+1,0,50),
        BackgroundColor3=K.BG1, ClipsDescendants=true, ZIndex=6, Parent=main
    })

    -- ── GİRİŞ ANİMASYONU
    main.Size = UDim2.fromOffset(W*.8, H*.8)
    main.BackgroundTransparency = 1
    task.defer(function()
        Tween(main,.5,{Size=UDim2.fromOffset(W,H),BackgroundTransparency=0},Enum.EasingStyle.Back)
    end)

    -- ══════════════════════════════════════════
    --  WINDOW OBJESİ
    -- ══════════════════════════════════════════
    local Window = {}
    local tabList = {}
    local activeIdx = nil

    local function activate(idx)
        if activeIdx==idx then return end
        activeIdx = idx
        for i, t in ipairs(tabList) do
            local on = (i==idx)
            t.frame.Visible = on
            if on then
                Tween(t.btn,.18,{BackgroundColor3=K.BG4,BackgroundTransparency=0})
                Tween(t.lbl,.18,{TextColor3=K.T1})
                t.ind.Visible = true
            else
                Tween(t.btn,.18,{BackgroundTransparency=1})
                Tween(t.lbl,.18,{TextColor3=K.T3})
                t.ind.Visible = false
            end
        end
    end

    -- ── TAB OLUŞTURMA
    function Window:CreateTab(name, iconId)
        local idx = #tabList+1

        -- buton
        local btn = New("TextButton", {
            Size=UDim2.new(1,0,0,34), BackgroundColor3=K.BG4,
            BackgroundTransparency=1, Text="", ZIndex=7, Parent=tabScroll
        })
        Corner(btn,6)

        local ind = New("Frame", {
            Size=UDim2.fromOffset(3,16), AnchorPoint=Vector2.new(0,.5),
            Position=UDim2.new(0,3,.5,0),
            BackgroundColor3=K.R, Visible=false, ZIndex=8, Parent=btn
        })
        Corner(ind,2)

        local iconOff = 22
        if iconId and iconId~=0 then
            New("ImageLabel", {
                Size=UDim2.fromOffset(16,16), AnchorPoint=Vector2.new(0,.5),
                Position=UDim2.new(0,10,.5,0),
                BackgroundTransparency=1, Image="rbxassetid://"..tostring(iconId),
                ImageColor3=K.T3, ZIndex=8, Parent=btn
            })
            iconOff=32
        end

        local lbl = New("TextLabel", {
            Size=UDim2.new(1,-iconOff-4,1,0), Position=UDim2.fromOffset(iconOff,0),
            BackgroundTransparency=1, Text=name,
            Font=Enum.Font.GothamBold, TextSize=12,
            TextColor3=K.T3, TextXAlignment=Enum.TextXAlignment.Left,
            ZIndex=8, Parent=btn
        })

        -- içerik frame
        local frame = New("ScrollingFrame", {
            Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
            ScrollBarThickness=3, ScrollBarImageColor3=K.R,
            CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
            Visible=false, ZIndex=7, Parent=rightPanel
        })
        Pad(frame,6,8,10,8)
        List(frame,6)

        local entry = {btn=btn,lbl=lbl,ind=ind,frame=frame}
        table.insert(tabList,entry)

        btn.MouseEnter:Connect(function()
            if activeIdx~=idx then Tween(btn,.12,{BackgroundTransparency=.6,BackgroundColor3=K.BG4}) end
        end)
        btn.MouseLeave:Connect(function()
            if activeIdx~=idx then Tween(btn,.12,{BackgroundTransparency=1}) end
        end)
        btn.MouseButton1Click:Connect(function() activate(idx) end)
        if idx==1 then task.defer(function() activate(1) end) end

        -- ── TAB OBJESİ
        local Tab = {}

        function Tab:CreateSection(sName)
            -- section frame
            local sec = New("Frame", {
                Name=sName, Size=UDim2.new(1,0,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=K.BG2, ZIndex=8, Parent=frame
            })
            Corner(sec,8); Stroke(sec,K.BRD,1)
            Pad(sec,34,8,8,8)

            -- başlık
            local hdr = New("Frame", {
                Size=UDim2.new(1,0,0,26), BackgroundColor3=K.BG3,
                ZIndex=9, Parent=sec
            })
            Corner(hdr,6)
            New("Frame", {
                Size=UDim2.fromOffset(3,13), AnchorPoint=Vector2.new(0,.5),
                Position=UDim2.new(0,8,.5,0), BackgroundColor3=K.R, ZIndex=10, Parent=hdr
            })
            New("TextLabel", {
                Size=UDim2.new(1,-26,1,0), Position=UDim2.fromOffset(18,0),
                BackgroundTransparency=1, Text=sName,
                Font=Enum.Font.GothamBold, TextSize=12,
                TextColor3=K.T2, TextXAlignment=Enum.TextXAlignment.Left,
                ZIndex=10, Parent=hdr
            })

            List(sec,4)

            local Section = {}

            -- ── TOGGLE
            function Section:CreateToggle(c)
                c=c or {}
                local state = c.Default==true
                local flag  = c.Flag

                local row = New("Frame", {
                    Size=UDim2.new(1,0,0,36), BackgroundColor3=K.BG3,
                    BackgroundTransparency=.5, ZIndex=9, Parent=sec
                })
                Corner(row,6)

                New("TextLabel", {
                    Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0),
                    BackgroundTransparency=1, Text=c.Name or "Toggle",
                    Font=Enum.Font.Gotham, TextSize=12, TextColor3=K.T1,
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=10, Parent=row
                })

                local sw = New("Frame", {
                    Size=UDim2.fromOffset(42,24), AnchorPoint=Vector2.new(1,.5),
                    Position=UDim2.new(1,-10,.5,0),
                    BackgroundColor3=state and K.R or K.BG5,
                    ZIndex=10, Parent=row
                })
                Corner(sw,12)
                local swStroke = Stroke(sw, state and K.RD or K.BRD, 1)

                local dot = New("Frame", {
                    Size=UDim2.fromOffset(18,18), AnchorPoint=Vector2.new(0,.5),
                    Position=UDim2.new(0, state and 21 or 3, .5, 0),
                    BackgroundColor3=K.W, ZIndex=11, Parent=sw
                })
                Corner(dot,9)

                local hb = New("TextButton", {
                    Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
                    Text="", ZIndex=12, Parent=row
                })

                local function setState(v)
                    state=v
                    Tween(sw,.18,{BackgroundColor3=v and K.R or K.BG5})
                    Tween(dot,.18,{Position=UDim2.new(0, v and 21 or 3, .5, 0)})
                    swStroke.Color = v and K.RD or K.BRD
                    if flag then Redax.Flags[flag]=v end
                    if c.Callback then pcall(c.Callback,v) end
                end

                hb.MouseButton1Click:Connect(function() setState(not state) end)
                row.MouseEnter:Connect(function() Tween(row,.12,{BackgroundTransparency=.3}) end)
                row.MouseLeave:Connect(function()  Tween(row,.12,{BackgroundTransparency=.5}) end)
                if flag then Redax.Flags[flag]=state end

                local A={}
                function A:Set(v) setState(v) end
                function A:Get() return state end
                return A
            end

            -- ── BUTTON
            function Section:CreateButton(c)
                c=c or {}
                local btn2 = New("TextButton", {
                    Size=UDim2.new(1,0,0,36), BackgroundColor3=K.R,
                    BackgroundTransparency=.15, Text="", ZIndex=9, Parent=sec
                })
                Corner(btn2,6); Stroke(btn2,K.RD,1)

                local bl = New("TextLabel", {
                    Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
                    Text=c.Name or "Buton", Font=Enum.Font.GothamBold,
                    TextSize=13, TextColor3=K.W, ZIndex=10, Parent=btn2
                })

                btn2.MouseEnter:Connect(function() Tween(btn2,.12,{BackgroundTransparency=0,BackgroundColor3=K.RB}) end)
                btn2.MouseLeave:Connect(function()  Tween(btn2,.12,{BackgroundTransparency=.15,BackgroundColor3=K.R}) end)
                btn2.MouseButton1Down:Connect(function()  Tween(btn2,.07,{BackgroundColor3=K.RD}) end)
                btn2.MouseButton1Up:Connect(function()    Tween(btn2,.07,{BackgroundColor3=K.RB}) end)
                btn2.MouseButton1Click:Connect(function() if c.Callback then pcall(c.Callback) end end)

                local A={}
                function A:SetText(t) bl.Text=t end
                return A
            end

            -- ── SLIDER
            function Section:CreateSlider(c)
                c=c or {}
                local mn,mx = c.Min or 0, c.Max or 100
                local suf   = c.Suffix or ""
                local val   = math.clamp(c.Default or mn, mn, mx)
                local flag  = c.Flag

                local row = New("Frame", {
                    Size=UDim2.new(1,0,0,52), BackgroundColor3=K.BG3,
                    BackgroundTransparency=.5, ZIndex=9, Parent=sec
                })
                Corner(row,6); Pad(row,0,10,0,10)

                local top = New("Frame", {
                    Size=UDim2.new(1,0,0,26), BackgroundTransparency=1, ZIndex=10, Parent=row
                })
                New("TextLabel", {
                    Size=UDim2.new(.65,0,1,0), BackgroundTransparency=1,
                    Text=c.Name or "Slider", Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=K.T1, TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=11, Parent=top
                })
                local vLbl = New("TextLabel", {
                    Size=UDim2.new(.35,0,1,0), Position=UDim2.fromScale(.65,0),
                    BackgroundTransparency=1, Text=tostring(val)..suf,
                    Font=Enum.Font.GothamBold, TextSize=12,
                    TextColor3=K.R, TextXAlignment=Enum.TextXAlignment.Right,
                    ZIndex=11, Parent=top
                })

                local track = New("Frame", {
                    Size=UDim2.new(1,0,0,6), Position=UDim2.fromOffset(0,34),
                    BackgroundColor3=K.BG5, ZIndex=10, Parent=row
                })
                Corner(track,3)

                local p0 = (val-mn)/(mx-mn)
                local fill = New("Frame", {
                    Size=UDim2.new(p0,0,1,0), BackgroundColor3=K.R, ZIndex=11, Parent=track
                })
                Corner(fill,3)

                local handle = New("Frame", {
                    Size=UDim2.fromOffset(14,14), AnchorPoint=Vector2.new(.5,.5),
                    Position=UDim2.new(p0,0,.5,0), BackgroundColor3=K.W,
                    ZIndex=12, Parent=track
                })
                Corner(handle,7); Stroke(handle,K.R,2)

                local sl_drag=false
                local function upd(xAbs)
                    local p=math.clamp((xAbs-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                    val=math.round(mn+(mx-mn)*p)
                    vLbl.Text=tostring(val)..suf
                    Tween(fill,.04,{Size=UDim2.new(p,0,1,0)})
                    Tween(handle,.04,{Position=UDim2.new(p,0,.5,0)})
                    if flag then Redax.Flags[flag]=val end
                    if c.Callback then pcall(c.Callback,val) end
                end

                track.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then sl_drag=true; upd(i.Position.X) end
                end)
                track.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then sl_drag=false end
                end)
                UIS.InputChanged:Connect(function(i)
                    if sl_drag and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i.Position.X) end
                end)
                row.MouseEnter:Connect(function() Tween(row,.12,{BackgroundTransparency=.3}) end)
                row.MouseLeave:Connect(function()  Tween(row,.12,{BackgroundTransparency=.5}) end)

                if flag then Redax.Flags[flag]=val end
                local A={}
                function A:Set(v)
                    val=math.clamp(v,mn,mx)
                    local p=(val-mn)/(mx-mn)
                    vLbl.Text=tostring(val)..suf
                    Tween(fill,.15,{Size=UDim2.new(p,0,1,0)})
                    Tween(handle,.15,{Position=UDim2.new(p,0,.5,0)})
                    if flag then Redax.Flags[flag]=val end
                    if c.Callback then pcall(c.Callback,val) end
                end
                function A:Get() return val end
                return A
            end

            -- ── DROPDOWN
            function Section:CreateDropdown(c)
                c=c or {}
                local opts  = c.Options or {}
                local sel   = c.Default or (opts[1] or "Seç...")
                local open  = false
                local flag  = c.Flag

                local wrap = New("Frame", {
                    Size=UDim2.new(1,0,0,36),
                    BackgroundTransparency=1, ClipsDescendants=false,
                    ZIndex=9, Parent=sec
                })

                local hdr = New("Frame", {
                    Size=UDim2.new(1,0,0,36), BackgroundColor3=K.BG3,
                    BackgroundTransparency=.5, ZIndex=9, Parent=wrap
                })
                Corner(hdr,6); Stroke(hdr,K.BRD,1)

                New("TextLabel", {
                    Size=UDim2.new(.55,0,1,0), Position=UDim2.fromOffset(10,0),
                    BackgroundTransparency=1, Text=c.Name or "Dropdown",
                    Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=K.T1, TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=10, Parent=hdr
                })
                local selLbl = New("TextLabel", {
                    Size=UDim2.new(.38,0,1,0), Position=UDim2.new(.55,0,0,0),
                    BackgroundTransparency=1, Text=sel,
                    Font=Enum.Font.GothamBold, TextSize=12,
                    TextColor3=K.R, TextXAlignment=Enum.TextXAlignment.Right,
                    ZIndex=10, Parent=hdr
                })
                local arrow = New("TextLabel", {
                    Size=UDim2.fromOffset(24,36), AnchorPoint=Vector2.new(1,0),
                    Position=UDim2.new(1,0,0,0),
                    BackgroundTransparency=1, Text="▾",
                    Font=Enum.Font.GothamBold, TextSize=14,
                    TextColor3=K.T3, ZIndex=10, Parent=hdr
                })

                local list = New("Frame", {
                    Size=UDim2.new(1,0,0,0), Position=UDim2.fromOffset(0,40),
                    BackgroundColor3=K.BG3, ClipsDescendants=true,
                    ZIndex=14, Parent=wrap
                })
                Corner(list,6); Stroke(list,K.BRD,1)
                Pad(list,3,4,3,4); List(list,2)

                local listH=0
                local function buildList()
                    for _, ch in ipairs(list:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end
                    listH = #opts*30+8
                    for _, o in ipairs(opts) do
                        local ob = New("TextButton", {
                            Size=UDim2.new(1,0,0,28), BackgroundColor3=K.BG4,
                            BackgroundTransparency=1, Text=o,
                            Font=Enum.Font.Gotham, TextSize=12,
                            TextColor3=K.T2, ZIndex=15, Parent=list
                        })
                        Corner(ob,4)
                        ob.MouseEnter:Connect(function()
                            Tween(ob,.1,{BackgroundTransparency=0,BackgroundColor3=K.R,TextColor3=K.W})
                        end)
                        ob.MouseLeave:Connect(function()
                            Tween(ob,.1,{BackgroundTransparency=1,TextColor3=K.T2})
                        end)
                        ob.MouseButton1Click:Connect(function()
                            sel=o; selLbl.Text=o
                            open=false
                            Tween(list,.2,{Size=UDim2.new(1,0,0,0)})
                            Tween(wrap,.2,{Size=UDim2.new(1,0,0,36)})
                            Tween(arrow,.15,{Rotation=0})
                            if flag then Redax.Flags[flag]=sel end
                            if c.Callback then pcall(c.Callback,sel) end
                        end)
                    end
                end
                buildList()

                local hb = New("TextButton", {
                    Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=11, Parent=hdr
                })
                hb.MouseButton1Click:Connect(function()
                    open=not open
                    if open then
                        Tween(list,.25,{Size=UDim2.new(1,0,0,listH)},Enum.EasingStyle.Back)
                        Tween(wrap,.25,{Size=UDim2.new(1,0,0,36+listH+4)})
                        Tween(arrow,.2,{Rotation=180})
                    else
                        Tween(list,.2,{Size=UDim2.new(1,0,0,0)})
                        Tween(wrap,.2,{Size=UDim2.new(1,0,0,36)})
                        Tween(arrow,.15,{Rotation=0})
                    end
                end)
                hdr.MouseEnter:Connect(function() Tween(hdr,.12,{BackgroundTransparency=.3}) end)
                hdr.MouseLeave:Connect(function()  Tween(hdr,.12,{BackgroundTransparency=.5}) end)

                if flag then Redax.Flags[flag]=sel end
                local A={}
                function A:Set(v) sel=v; selLbl.Text=v; if flag then Redax.Flags[flag]=v end; if c.Callback then pcall(c.Callback,v) end end
                function A:Get() return sel end
                function A:Refresh(newOpts) opts=newOpts; buildList() end
                return A
            end

            -- ── INPUT
            function Section:CreateInput(c)
                c=c or {}
                local flag=c.Flag

                local row = New("Frame", {
                    Size=UDim2.new(1,0,0,54), BackgroundColor3=K.BG3,
                    BackgroundTransparency=.5, ZIndex=9, Parent=sec
                })
                Corner(row,6); Pad(row,0,10,0,10)

                New("TextLabel", {
                    Size=UDim2.new(1,0,0,22), BackgroundTransparency=1,
                    Text=c.Name or "Input", Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=K.T1, TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=10, Parent=row
                })

                local iBG = New("Frame", {
                    Size=UDim2.new(1,0,0,28), Position=UDim2.fromOffset(0,24),
                    BackgroundColor3=K.BG5, ZIndex=10, Parent=row
                })
                Corner(iBG,5)
                local iSt = Stroke(iBG,K.BRD,1)

                local iBox = New("TextBox", {
                    Size=UDim2.new(1,-16,1,0), Position=UDim2.fromOffset(8,0),
                    BackgroundTransparency=1,
                    PlaceholderText=c.PlaceholderText or "Yazın...",
                    PlaceholderColor3=K.T3, Text=c.Default or "",
                    Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=K.T1, ClearTextOnFocus=false, ZIndex=11, Parent=iBG
                })

                iBox.Focused:Connect(function()
                    Tween(iBG,.15,{BackgroundColor3=K.BG4})
                    iSt.Color=K.R; iSt.Thickness=1.5
                end)
                iBox.FocusLost:Connect(function(e)
                    Tween(iBG,.15,{BackgroundColor3=K.BG5})
                    iSt.Color=K.BRD; iSt.Thickness=1
                    if flag then Redax.Flags[flag]=iBox.Text end
                    if c.Callback then pcall(c.Callback,iBox.Text,e) end
                end)
                row.MouseEnter:Connect(function() Tween(row,.12,{BackgroundTransparency=.3}) end)
                row.MouseLeave:Connect(function()  Tween(row,.12,{BackgroundTransparency=.5}) end)
                if flag then Redax.Flags[flag]=iBox.Text end

                local A={}
                function A:Set(t) iBox.Text=t; if flag then Redax.Flags[flag]=t end end
                function A:Get() return iBox.Text end
                return A
            end

            -- ── KEYBIND
            function Section:CreateKeybind(c)
                c=c or {}
                local key  = c.Default or Enum.KeyCode.Unknown
                local flag = c.Flag
                local list_mode = false

                local row = New("Frame", {
                    Size=UDim2.new(1,0,0,36), BackgroundColor3=K.BG3,
                    BackgroundTransparency=.5, ZIndex=9, Parent=sec
                })
                Corner(row,6)

                New("TextLabel", {
                    Size=UDim2.new(1,-90,1,0), Position=UDim2.fromOffset(10,0),
                    BackgroundTransparency=1, Text=c.Name or "Keybind",
                    Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=K.T1, TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=10, Parent=row
                })

                local kBtn = New("TextButton", {
                    Size=UDim2.fromOffset(74,26), AnchorPoint=Vector2.new(1,.5),
                    Position=UDim2.new(1,-8,.5,0),
                    BackgroundColor3=K.BG5,
                    Text="[ "..key.Name.." ]",
                    Font=Enum.Font.Code, TextSize=11,
                    TextColor3=K.R, ZIndex=10, Parent=row
                })
                Corner(kBtn,5); Stroke(kBtn,K.BRD,1)

                kBtn.MouseButton1Click:Connect(function()
                    if list_mode then return end
                    list_mode=true
                    kBtn.Text="[ ... ]"; kBtn.TextColor3=K.YLW
                    local conn; conn=UIS.InputBegan:Connect(function(i,gpe)
                        if i.UserInputType==Enum.UserInputType.Keyboard then
                            key=i.KeyCode
                            kBtn.Text="[ "..key.Name.." ]"
                            kBtn.TextColor3=K.R
                            list_mode=false; conn:Disconnect()
                            if flag then Redax.Flags[flag]=key end
                        end
                    end)
                end)

                UIS.InputBegan:Connect(function(i,gpe)
                    if not gpe and not list_mode and i.KeyCode==key then
                        if c.Callback then pcall(c.Callback) end
                    end
                end)

                row.MouseEnter:Connect(function() Tween(row,.12,{BackgroundTransparency=.3}) end)
                row.MouseLeave:Connect(function()  Tween(row,.12,{BackgroundTransparency=.5}) end)
                if flag then Redax.Flags[flag]=key end

                local A={}
                function A:Set(k) key=k; kBtn.Text="[ "..k.Name.." ]"; if flag then Redax.Flags[flag]=k end end
                function A:Get() return key end
                return A
            end

            -- ── COLOR PICKER
            function Section:CreateColorPicker(c)
                c=c or {}
                local col  = c.Default or Color3.fromRGB(220,30,30)
                local flag = c.Flag
                local r,g,b = col.R*255, col.G*255, col.B*255
                local open2=false

                local wrap = New("Frame", {
                    Size=UDim2.new(1,0,0,36), BackgroundTransparency=1,
                    ClipsDescendants=false, ZIndex=9, Parent=sec
                })

                local hdr = New("Frame", {
                    Size=UDim2.new(1,0,0,36), BackgroundColor3=K.BG3,
                    BackgroundTransparency=.5, ZIndex=9, Parent=wrap
                })
                Corner(hdr,6)

                New("TextLabel", {
                    Size=UDim2.new(.65,0,1,0), Position=UDim2.fromOffset(10,0),
                    BackgroundTransparency=1, Text=c.Name or "Renk",
                    Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=K.T1, TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=10, Parent=hdr
                })

                local prev = New("Frame", {
                    Size=UDim2.fromOffset(30,20), AnchorPoint=Vector2.new(1,.5),
                    Position=UDim2.new(1,-8,.5,0), BackgroundColor3=col,
                    ZIndex=10, Parent=hdr
                })
                Corner(prev,4); Stroke(prev,K.BRD,1)

                local picker = New("Frame", {
                    Size=UDim2.new(1,0,0,0), Position=UDim2.fromOffset(0,40),
                    BackgroundColor3=K.BG4, ClipsDescendants=true,
                    ZIndex=12, Parent=wrap
                })
                Corner(picker,6); Stroke(picker,K.BRD,1)
                Pad(picker,8,10,8,10); List(picker,7)

                local function updCol()
                    col=Color3.fromRGB(r,g,b)
                    prev.BackgroundColor3=col
                    if flag then Redax.Flags[flag]=col end
                    if c.Callback then pcall(c.Callback,col) end
                end

                local chs={
                    {n="R",v=r,col=Color3.fromRGB(220,50,50),  set=function(v) r=v end},
                    {n="G",v=g,col=Color3.fromRGB(50,200,80),  set=function(v) g=v end},
                    {n="B",v=b,col=Color3.fromRGB(60,130,255), set=function(v) b=v end},
                }
                for _, ch in ipairs(chs) do
                    local r2 = New("Frame", {
                        Size=UDim2.new(1,0,0,18), BackgroundTransparency=1, ZIndex=13, Parent=picker
                    })
                    New("TextLabel", {
                        Size=UDim2.fromOffset(14,18), BackgroundTransparency=1,
                        Text=ch.n, Font=Enum.Font.GothamBold, TextSize=11,
                        TextColor3=ch.col, ZIndex=14, Parent=r2
                    })
                    local tr = New("Frame", {
                        Size=UDim2.new(1,-50,0,5), AnchorPoint=Vector2.new(0,.5),
                        Position=UDim2.new(0,18,.5,0), BackgroundColor3=K.BG2,
                        ZIndex=13, Parent=r2
                    })
                    Corner(tr,3)
                    local ip = ch.v/255
                    local fi = New("Frame", {
                        Size=UDim2.new(ip,0,1,0), BackgroundColor3=ch.col, ZIndex=14, Parent=tr
                    })
                    Corner(fi,3)
                    local vl = New("TextLabel", {
                        Size=UDim2.fromOffset(28,18), AnchorPoint=Vector2.new(1,0),
                        Position=UDim2.new(1,0,0,0), BackgroundTransparency=1,
                        Text=tostring(math.floor(ch.v)), Font=Enum.Font.GothamBold,
                        TextSize=10, TextColor3=K.T3, ZIndex=14, Parent=r2
                    })
                    local cd=false
                    tr.InputBegan:Connect(function(i)
                        if i.UserInputType==Enum.UserInputType.MouseButton1 then
                            cd=true
                            local p=math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
                            fi.Size=UDim2.new(p,0,1,0); vl.Text=tostring(math.floor(p*255)); ch.set(p*255); updCol()
                        end
                    end)
                    tr.InputEnded:Connect(function(i)
                        if i.UserInputType==Enum.UserInputType.MouseButton1 then cd=false end
                    end)
                    UIS.InputChanged:Connect(function(i)
                        if cd and i.UserInputType==Enum.UserInputType.MouseMovement then
                            local p=math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
                            fi.Size=UDim2.new(p,0,1,0); vl.Text=tostring(math.floor(p*255)); ch.set(p*255); updCol()
                        end
                    end)
                end

                local pH = 3*22+20
                local hb = New("TextButton", {
                    Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=11, Parent=hdr
                })
                hb.MouseButton1Click:Connect(function()
                    open2=not open2
                    if open2 then
                        Tween(picker,.25,{Size=UDim2.new(1,0,0,pH)},Enum.EasingStyle.Back)
                        Tween(wrap,.25,{Size=UDim2.new(1,0,0,36+pH+4)})
                    else
                        Tween(picker,.2,{Size=UDim2.new(1,0,0,0)})
                        Tween(wrap,.2,{Size=UDim2.new(1,0,0,36)})
                    end
                end)
                hdr.MouseEnter:Connect(function() Tween(hdr,.12,{BackgroundTransparency=.3}) end)
                hdr.MouseLeave:Connect(function()  Tween(hdr,.12,{BackgroundTransparency=.5}) end)

                if flag then Redax.Flags[flag]=col end
                local A={}
                function A:Set(nc) col=nc; prev.BackgroundColor3=nc; if flag then Redax.Flags[flag]=nc end end
                function A:Get() return col end
                return A
            end

            -- ── LABEL
            function Section:CreateLabel(txt, rich)
                local lbl = New("TextLabel", {
                    Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
                    BackgroundTransparency=1, Text=txt or "",
                    RichText=rich or false, Font=Enum.Font.GothamItalic,
                    TextSize=11, TextColor3=K.T3,
                    TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=9, Parent=sec
                })
                Pad(lbl,0,0,0,10)
                local A={}; function A:Set(t) lbl.Text=t end; return A
            end

            -- ── SEPARATOR
            function Section:CreateSeparator()
                New("Frame", {
                    Size=UDim2.new(1,0,0,1), BackgroundColor3=K.BRD,
                    BackgroundTransparency=.4, ZIndex=9, Parent=sec
                })
            end

            return Section
        end -- CreateSection

        return Tab
    end -- CreateTab

    function Window:Notify(cfg2) Redax:Notify(cfg2) end

    return Window
end -- CreateWindow

return Redax
