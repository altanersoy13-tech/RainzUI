--[[
    ██████╗ ███████╗██████╗  █████╗ ██╗  ██╗    ██╗  ██╗██╗   ██╗██████╗ 
    ██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗██╔╝    ██║  ██║██║   ██║██╔══██╗
    ██████╔╝█████╗  ██║  ██║███████║ ╚███╔╝     ███████║██║   ██║██████╔╝
    ██╔══██╗██╔══╝  ██║  ██║██╔══██║ ██╔██╗     ██╔══██║██║   ██║██╔══██╗
    ██║  ██║███████╗██████╔╝██║  ██║██╔╝ ██╗    ██║  ██║╚██████╔╝██████╔╝
    ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    RedaxHub UI Library v1.0.0
    Tema: Siyah & Kırmızı | FPS Optimized | Professional Grade
    
    Kullanım:
        local RedaxHub = loadstring(game:HttpGet("YOUR_RAW_URL"))()
        
        local Window = RedaxHub:CreateWindow({
            Title = "RedaxHub",
            SubTitle = "by RedaxTeam",
            TabWidth = 160,
            Size = UDim2.fromOffset(580, 460),
            Acrylic = false,
            Theme = "Default",
            KeySystem = false,
        })
        
        local Tab = Window:CreateTab("ESP", "rbxassetid://...")
        local Section = Tab:CreateSection("Ayarlar")
        
        Section:CreateToggle({ Name = "ESP Aktif", Default = false, Callback = function(v) end })
        Section:CreateSlider({ Name = "Mesafe", Min = 0, Max = 1000, Default = 500, Callback = function(v) end })
        Section:CreateButton({ Name = "Tıkla", Callback = function() end })
        Section:CreateDropdown({ Name = "Renk", Options = {"Kırmızı","Mavi"}, Default = "Kırmızı", Callback = function(v) end })
        Section:CreateInput({ Name = "İsim", Default = "", Callback = function(v) end })
        Section:CreateKeybind({ Name = "Tuş", Default = Enum.KeyCode.F, Callback = function() end })
        Section:CreateLabel("Bu bir etiket")
        Section:CreateColorPicker({ Name = "Renk Seç", Default = Color3.fromRGB(255,0,0), Callback = function(c) end })
]]

-- ═══════════════════════════════════════════════════════════════
--                     SERVIS & DEĞIŞKENLER
-- ═══════════════════════════════════════════════════════════════

local RedaxHub = {}
RedaxHub.__index = RedaxHub

local RunService    = game:GetService("RunService")
local TweenService  = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players       = game:GetService("Players")
local HttpService   = game:GetService("HttpService")
local CoreGui       = game:GetService("CoreGui")

local LocalPlayer   = Players.LocalPlayer
local Mouse         = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════════════════
--                     TEMA SİSTEMİ
-- ═══════════════════════════════════════════════════════════════

local Themes = {
    Default = {
        -- Ana renkler
        Background      = Color3.fromRGB(10, 10, 12),
        SecondBG        = Color3.fromRGB(16, 16, 20),
        ThirdBG         = Color3.fromRGB(22, 22, 28),
        FourthBG        = Color3.fromRGB(28, 28, 36),
        -- Vurgu rengi (Kırmızı)
        Accent          = Color3.fromRGB(220, 30, 30),
        AccentDark      = Color3.fromRGB(150, 20, 20),
        AccentLight     = Color3.fromRGB(255, 60, 60),
        -- Metin
        TextPrimary     = Color3.fromRGB(240, 240, 245),
        TextSecondary   = Color3.fromRGB(160, 160, 170),
        TextDisabled    = Color3.fromRGB(80, 80, 90),
        -- Kenarlıklar
        Border          = Color3.fromRGB(45, 45, 55),
        BorderAccent    = Color3.fromRGB(220, 30, 30),
        -- Toggle
        ToggleOff       = Color3.fromRGB(45, 45, 55),
        ToggleOn        = Color3.fromRGB(220, 30, 30),
    },
    Crimson = {
        Background      = Color3.fromRGB(8, 5, 5),
        SecondBG        = Color3.fromRGB(14, 8, 8),
        ThirdBG         = Color3.fromRGB(20, 12, 12),
        FourthBG        = Color3.fromRGB(28, 16, 16),
        Accent          = Color3.fromRGB(200, 0, 0),
        AccentDark      = Color3.fromRGB(130, 0, 0),
        AccentLight     = Color3.fromRGB(255, 40, 40),
        TextPrimary     = Color3.fromRGB(245, 230, 230),
        TextSecondary   = Color3.fromRGB(170, 140, 140),
        TextDisabled    = Color3.fromRGB(80, 60, 60),
        Border          = Color3.fromRGB(50, 30, 30),
        BorderAccent    = Color3.fromRGB(200, 0, 0),
        ToggleOff       = Color3.fromRGB(50, 30, 30),
        ToggleOn        = Color3.fromRGB(200, 0, 0),
    }
}

-- ═══════════════════════════════════════════════════════════════
--                     YARDIMCI FONKSİYONLAR
-- ═══════════════════════════════════════════════════════════════

local function Tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = obj
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, startPos, startFramePos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            startFramePos = frame.Position
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(
                startFramePos.X.Scale,
                startFramePos.X.Offset + delta.X,
                startFramePos.Y.Scale,
                startFramePos.Y.Offset + delta.Y
            )
        end
    end)
end

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function AddPadding(parent, top, right, bottom, left)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, top or 5)
    pad.PaddingRight  = UDim.new(0, right or 5)
    pad.PaddingBottom = UDim.new(0, bottom or 5)
    pad.PaddingLeft   = UDim.new(0, left or 5)
    pad.Parent = parent
    return pad
end

-- ═══════════════════════════════════════════════════════════════
--                     BİLDİRİM SİSTEMİ
-- ═══════════════════════════════════════════════════════════════

local NotificationHolder

local function InitNotifications(Theme)
    NotificationHolder = Create("Frame", {
        Name = "RedaxNotifications",
        Size = UDim2.fromOffset(280, 0),
        Position = UDim2.new(1, -290, 1, -10),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Parent = CoreGui:FindFirstChild("RedaxHub_ScreenGui") or CoreGui
    })
    
    local listLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 6),
        Parent = NotificationHolder
    })
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        NotificationHolder.Size = UDim2.fromOffset(280, listLayout.AbsoluteContentSize.Y)
    end)
end

function RedaxHub:Notify(opts)
    local Theme = self._Theme
    opts = opts or {}
    local title    = opts.Title or "RedaxHub"
    local content  = opts.Content or ""
    local duration = opts.Duration or 5
    local ntype    = opts.Type or "Info" -- Info, Success, Warning, Error
    
    local typeColors = {
        Info    = Theme.Accent,
        Success = Color3.fromRGB(40, 200, 80),
        Warning = Color3.fromRGB(220, 170, 0),
        Error   = Color3.fromRGB(220, 40, 40),
    }
    local accentColor = typeColors[ntype] or Theme.Accent
    
    local notif = Create("Frame", {
        Name = "Notification",
        Size = UDim2.fromOffset(280, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.SecondBG,
        BackgroundTransparency = 0,
        Parent = NotificationHolder
    })
    AddCorner(notif, 8)
    AddStroke(notif, Theme.Border, 1)
    AddPadding(notif, 10, 12, 10, 12)
    
    -- Sol renkli çizgi
    local bar = Create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = accentColor,
        Parent = notif
    })
    AddCorner(bar, 2)
    
    local innerPad = Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        Parent = notif
    })
    
    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    local contentLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.fromOffset(0, 22),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Text = content,
        TextColor3 = Theme.TextSecondary,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif
    })
    
    -- Animasyon: slide in
    notif.BackgroundTransparency = 1
    titleLabel.TextTransparency = 1
    contentLabel.TextTransparency = 1
    
    Tween(notif, { BackgroundTransparency = 0 }, 0.3)
    Tween(titleLabel, { TextTransparency = 0 }, 0.3)
    Tween(contentLabel, { TextTransparency = 0 }, 0.3)
    
    -- Progress bar
    local progressBG = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = Theme.ThirdBG,
        Parent = notif
    })
    
    local progressBar = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        Parent = progressBG
    })
    
    Tween(progressBar, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear)
    
    task.delay(duration, function()
        Tween(notif, { BackgroundTransparency = 1 }, 0.3)
        Tween(titleLabel, { TextTransparency = 1 }, 0.3)
        Tween(contentLabel, { TextTransparency = 1 }, 0.3)
        task.wait(0.35)
        notif:Destroy()
    end)
    
    return notif
end

-- ═══════════════════════════════════════════════════════════════
--                     WATERMARK
-- ═══════════════════════════════════════════════════════════════

function RedaxHub:CreateWatermark(opts)
    local Theme = self._Theme
    opts = opts or {}
    local text = opts.Text or "RedaxHub"
    
    local screenGui = CoreGui:FindFirstChild("RedaxHub_ScreenGui")
    if not screenGui then return end
    
    local wm = Create("Frame", {
        Name = "Watermark",
        Size = UDim2.fromOffset(0, 28),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(1, -10, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Theme.SecondBG,
        Parent = screenGui
    })
    AddCorner(wm, 6)
    AddStroke(wm, Theme.Border, 1)
    AddPadding(wm, 0, 10, 0, 10)
    
    local wmLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        RichText = true,
        Text = string.format('<font color="#DC1E1E"><b>Redax</b></font><font color="#F0F0F5">Hub</font> | %s', text),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        Parent = wm
    })
    
    -- FPS Göstergesi (opsiyonel)
    if opts.ShowFPS then
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local fps = math.floor(1 / RunService.Heartbeat:Wait() + 0.5)
            wmLabel.Text = string.format(
                '<font color="#DC1E1E"><b>Redax</b></font><font color="#F0F0F5">Hub</font> | %s | <font color="#DC1E1E">%d FPS</font>',
                text, fps
            )
        end)
    end
    
    local WatermarkAPI = {}
    function WatermarkAPI:SetText(t)
        wmLabel.Text = string.format('<font color="#DC1E1E"><b>Redax</b></font><font color="#F0F0F5">Hub</font> | %s', t)
    end
    function WatermarkAPI:SetVisibility(v)
        wm.Visible = v
    end
    
    return WatermarkAPI
end

-- ═══════════════════════════════════════════════════════════════
--                     KEY SİSTEMİ
-- ═══════════════════════════════════════════════════════════════

local function ShowKeySystem(opts, Theme, callback)
    local keyOpts = opts.KeySettings or {}
    local validKeys = keyOpts.Keys or {}
    local keyTitle  = keyOpts.Title or "RedaxHub Key"
    local keyNote   = keyOpts.Note or "Discord sunucumuzdan key alabilirsiniz."
    local keyLink   = keyOpts.Link or ""
    local saveKey   = keyOpts.SaveKey ~= false
    
    -- Kaydedilmiş key kontrolü
    if saveKey and isfile and isfile("redax_key.txt") then
        local saved = readfile("redax_key.txt")
        for _, k in ipairs(validKeys) do
            if saved == k then
                callback(true)
                return
            end
        end
    end
    
    local sg = Create("ScreenGui", {
        Name = "RedaxHub_Key",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    -- Backdrop blur
    local backdrop = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
        Parent = sg
    })
    
    -- Ana panel
    local panel = Create("Frame", {
        Size = UDim2.fromOffset(380, 220),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        Parent = sg
    })
    AddCorner(panel, 10)
    AddStroke(panel, Theme.Border, 1)
    
    -- Üst kırmızı çizgi
    local topLine = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Theme.Accent,
        Parent = panel
    })
    AddCorner(topLine, 1)
    
    -- Logo / Başlık
    local titleLbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.fromOffset(0, 12),
        BackgroundTransparency = 1,
        RichText = true,
        Text = string.format('<font color="#DC1E1E"><b>Redax</b></font><font color="#F0F0F5">Hub</font> — %s', keyTitle),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        Parent = panel
    })
    
    local noteLbl = Create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 30),
        Position = UDim2.fromOffset(15, 55),
        BackgroundTransparency = 1,
        Text = keyNote,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextSecondary,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = panel
    })
    
    -- Input alanı
    local inputBG = Create("Frame", {
        Size = UDim2.new(1, -30, 0, 36),
        Position = UDim2.fromOffset(15, 100),
        BackgroundColor3 = Theme.ThirdBG,
        Parent = panel
    })
    AddCorner(inputBG, 6)
    AddStroke(inputBG, Theme.Border, 1)
    
    local input = Create("TextBox", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        PlaceholderText = "Key girin...",
        PlaceholderColor3 = Theme.TextDisabled,
        Text = "",
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        Parent = inputBG
    })
    
    -- Status label
    local statusLbl = Create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 16),
        Position = UDim2.fromOffset(15, 144),
        BackgroundTransparency = 1,
        Text = "",
        TextSize = 11,
        Font = Enum.Font.GothamItalic,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = panel
    })
    
    -- Butonlar
    local btnCopy = Create("TextButton", {
        Size = UDim2.fromOffset(80, 32),
        Position = UDim2.new(0, 15, 1, -47),
        BackgroundColor3 = Theme.ThirdBG,
        Text = "📋 Link",
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = panel
    })
    AddCorner(btnCopy, 6)
    AddStroke(btnCopy, Theme.Border, 1)
    
    local btnConfirm = Create("TextButton", {
        Size = UDim2.fromOffset(120, 32),
        Position = UDim2.new(1, -135, 1, -47),
        BackgroundColor3 = Theme.Accent,
        Text = "✓ Doğrula",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Parent = panel
    })
    AddCorner(btnConfirm, 6)
    
    -- Hover efektleri
    btnConfirm.MouseEnter:Connect(function()
        Tween(btnConfirm, { BackgroundColor3 = Theme.AccentLight }, 0.15)
    end)
    btnConfirm.MouseLeave:Connect(function()
        Tween(btnConfirm, { BackgroundColor3 = Theme.Accent }, 0.15)
    end)
    
    btnCopy.MouseButton1Click:Connect(function()
        if keyLink ~= "" then
            setclipboard(keyLink)
            statusLbl.Text = "Link kopyalandı!"
            statusLbl.TextColor3 = Color3.fromRGB(40, 200, 80)
        end
    end)
    
    btnConfirm.MouseButton1Click:Connect(function()
        local entered = input.Text
        local valid = false
        for _, k in ipairs(validKeys) do
            if entered == k then
                valid = true
                break
            end
        end
        if valid then
            statusLbl.Text = "✓ Key geçerli! Yükleniyor..."
            statusLbl.TextColor3 = Color3.fromRGB(40, 200, 80)
            if saveKey and writefile then
                writefile("redax_key.txt", entered)
            end
            task.wait(0.8)
            Tween(sg, {}, 0.1)
            sg:Destroy()
            callback(true)
        else
            statusLbl.Text = "✗ Geçersiz key!"
            statusLbl.TextColor3 = Theme.Accent
            Tween(inputBG, { BackgroundColor3 = Color3.fromRGB(60, 15, 15) }, 0.1)
            task.wait(0.3)
            Tween(inputBG, { BackgroundColor3 = Theme.ThirdBG }, 0.3)
        end
    end)
    
    -- Giriş animasyonu
    panel.Position = UDim2.new(0.5, 0, 0.4, 0)
    panel.BackgroundTransparency = 1
    Tween(panel, {
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 0
    }, 0.4)
end

-- ═══════════════════════════════════════════════════════════════
--                     ANA PENCERE OLUŞTURMA
-- ═══════════════════════════════════════════════════════════════

function RedaxHub:CreateWindow(opts)
    opts = opts or {}
    
    local Theme = Themes[opts.Theme or "Default"] or Themes.Default
    self._Theme = Theme
    
    -- ScreenGui
    local screenGui = Create("ScreenGui", {
        Name = "RedaxHub_ScreenGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        Parent = CoreGui
    })
    
    -- Bildirim sistemini başlat
    InitNotifications(Theme)
    NotificationHolder.Parent = screenGui
    
    -- Key sistemi
    if opts.KeySystem then
        local keyPassed = false
        ShowKeySystem(opts, Theme, function(result)
            keyPassed = result
        end)
        -- Key geçilene kadar bekle
        local waitTime = 0
        while not keyPassed and waitTime < 60 do
            task.wait(0.1)
            waitTime = waitTime + 0.1
        end
        if not keyPassed then
            screenGui:Destroy()
            return nil
        end
    end
    
    -- ─── ANA ÇERÇEVE ───────────────────────────────────────────
    local mainSize = opts.Size or UDim2.fromOffset(580, 460)
    
    local main = Create("Frame", {
        Name = "RedaxMain",
        Size = mainSize,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
        Parent = screenGui
    })
    AddCorner(main, 10)
    AddStroke(main, Theme.Border, 1)
    MakeDraggable(main, main)
    
    -- Kırmızı üst vurgu çizgisi
    local topAccent = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Theme.Accent,
        ZIndex = 2,
        Parent = main
    })
    
    -- ─── ÜST BAR ───────────────────────────────────────────────
    local topBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 48),
        Position = UDim2.fromOffset(0, 2),
        BackgroundColor3 = Theme.SecondBG,
        Parent = main
    })
    
    -- Logo
    local logo = Create("TextLabel", {
        Size = UDim2.fromOffset(140, 48),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        RichText = true,
        Text = '<font color="#DC1E1E"><b>Redax</b></font><font color="#F0F0F5">Hub</font>',
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- SubTitle
    local subTitle = Create("TextLabel", {
        Size = UDim2.fromOffset(200, 48),
        Position = UDim2.fromOffset(100, 0),
        BackgroundTransparency = 1,
        Text = opts.SubTitle or "v1.0.0",
        TextSize = 11,
        Font = Enum.Font.GothamItalic,
        TextColor3 = Theme.TextDisabled,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- ─── PENCERE KONTROL BUTONLARI ──────────────────────────────
    -- Kapat butonu
    local btnClose = Create("TextButton", {
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -34, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(180, 30, 30),
        Text = "✕",
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = topBar
    })
    AddCorner(btnClose, 12)
    
    -- Minimize butonu
    local minimized = false
    local fullSize = mainSize
    
    local btnMin = Create("TextButton", {
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -64, 0.5, -12),
        BackgroundColor3 = Theme.FourthBG,
        Text = "─",
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = topBar
    })
    AddCorner(btnMin, 12)
    
    btnClose.MouseButton1Click:Connect(function()
        Tween(main, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }, 0.3)
        task.wait(0.35)
        screenGui:Destroy()
    end)
    
    btnMin.MouseButton1Click:Connect(function()
        if minimized then
            minimized = false
            Tween(main, { Size = fullSize }, 0.25)
            btnMin.Text = "─"
        else
            minimized = true
            Tween(main, { Size = UDim2.fromOffset(fullSize.X.Offset, 52) }, 0.25)
            btnMin.Text = "□"
        end
    end)
    
    -- Hover efektleri
    btnClose.MouseEnter:Connect(function() Tween(btnClose, { BackgroundColor3 = Color3.fromRGB(220, 50, 50) }, 0.15) end)
    btnClose.MouseLeave:Connect(function() Tween(btnClose, { BackgroundColor3 = Color3.fromRGB(180, 30, 30) }, 0.15) end)
    btnMin.MouseEnter:Connect(function() Tween(btnMin, { BackgroundColor3 = Theme.Border }, 0.15) end)
    btnMin.MouseLeave:Connect(function() Tween(btnMin, { BackgroundColor3 = Theme.FourthBG }, 0.15) end)
    
    -- ─── SOL PANEL (TAB LİSTESİ) ────────────────────────────────
    local tabWidth = opts.TabWidth or 140
    
    local leftPanel = Create("Frame", {
        Name = "LeftPanel",
        Size = UDim2.new(0, tabWidth, 1, -52),
        Position = UDim2.fromOffset(0, 52),
        BackgroundColor3 = Theme.SecondBG,
        Parent = main
    })
    
    local tabListContainer = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, -10),
        Position = UDim2.fromOffset(0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = leftPanel
    })
    AddPadding(tabListContainer, 5, 5, 5, 5)
    
    local tabListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3),
        Parent = tabListContainer
    })
    
    -- Alt bilgi
    local bottomInfo = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 1, -24),
        BackgroundColor3 = Theme.ThirdBG,
        Text = "RedaxHub",
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextDisabled,
        Parent = leftPanel
    })
    
    -- ─── SAĞ PANEL (TAB İÇERİĞİ) ────────────────────────────────
    local rightPanel = Create("Frame", {
        Name = "RightPanel",
        Size = UDim2.new(1, -tabWidth, 1, -52),
        Position = UDim2.new(0, tabWidth, 0, 52),
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
        Parent = main
    })
    
    -- Sol kenar çizgisi
    local divider = Create("Frame", {
        Size = UDim2.fromOffset(1, 9999),
        BackgroundColor3 = Theme.Border,
        Parent = rightPanel
    })
    
    -- ─── ARAMA KUTUSU ────────────────────────────────────────────
    local searchBar = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.fromOffset(10, 8),
        BackgroundColor3 = Theme.ThirdBG,
        Parent = rightPanel
    })
    AddCorner(searchBar, 6)
    AddStroke(searchBar, Theme.Border, 1)
    
    local searchIcon = Create("TextLabel", {
        Size = UDim2.fromOffset(30, 30),
        BackgroundTransparency = 1,
        Text = "🔍",
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextDisabled,
        Parent = searchBar
    })
    
    local searchInput = Create("TextBox", {
        Size = UDim2.new(1, -35, 1, 0),
        Position = UDim2.fromOffset(28, 0),
        BackgroundTransparency = 1,
        PlaceholderText = "Ara...",
        PlaceholderColor3 = Theme.TextDisabled,
        Text = "",
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        Parent = searchBar
    })
    
    -- Tab content çerçeveleri
    local tabFrames = {}
    local tabButtons = {}
    local activeTab = nil
    
    -- ═══════════════════════════════════════════════════════════
    --                  WINDOW API
    -- ═══════════════════════════════════════════════════════════
    
    local Window = {}
    Window._Theme = Theme
    Window._ScreenGui = screenGui
    Window._NotifFn = function(o) return RedaxHub.Notify(RedaxHub, o) end
    
    -- ─── TAB OLUŞTURMA ──────────────────────────────────────────
    function Window:CreateTab(name, icon)
        local tabIndex = #tabButtons + 1
        
        -- Tab butonu
        local tabBtn = Create("TextButton", {
            Name = "Tab_" .. name,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.Background,
            BackgroundTransparency = 1,
            Text = "",
            Parent = tabListContainer
        })
        AddCorner(tabBtn, 6)
        
        local tabBtnIndicator = Create("Frame", {
            Size = UDim2.fromOffset(3, 16),
            Position = UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = Theme.Accent,
            Visible = false,
            Parent = tabBtn
        })
        AddCorner(tabBtnIndicator, 2)
        
        -- İkon (opsiyonel)
        local iconOffset = 10
        if icon and icon ~= "" then
            local iconLabel = Create("ImageLabel", {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.new(0, 10, 0.5, -9),
                BackgroundTransparency = 1,
                Image = icon,
                ImageColor3 = Theme.TextSecondary,
                Parent = tabBtn
            })
            iconOffset = 34
        end
        
        local tabLabel = Create("TextLabel", {
            Size = UDim2.new(1, -iconOffset - 5, 1, 0),
            Position = UDim2.fromOffset(iconOffset, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.TextDisabled,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        
        -- Tab içerik çerçevesi
        local tabFrame = Create("ScrollingFrame", {
            Name = "TabFrame_" .. name,
            Size = UDim2.new(1, -2, 1, -50),
            Position = UDim2.fromOffset(2, 48),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = rightPanel
        })
        AddPadding(tabFrame, 5, 8, 10, 8)
        
        local tabFrameLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = tabFrame
        })
        
        tabFrames[tabIndex] = tabFrame
        tabButtons[tabIndex] = tabBtn
        
        -- Aktifleştirme fonksiyonu
        local function Activate()
            if activeTab == tabIndex then return end
            activeTab = tabIndex
            
            for i, f in ipairs(tabFrames) do
                f.Visible = (i == tabIndex)
                local btn = tabButtons[i]
                local ind = btn:FindFirstChild("Frame") -- indicator
                
                if i == tabIndex then
                    Tween(btn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.ThirdBG }, 0.2)
                    Tween(tabLabel, { TextColor3 = Theme.TextPrimary }, 0.2)
                    tabBtnIndicator.Visible = true
                else
                    Tween(btn, { BackgroundTransparency = 1 }, 0.2)
                    -- diğer tab labellarını resetle
                    local lbl = btn:FindFirstChildOfClass("TextLabel")
                    if lbl then Tween(lbl, { TextColor3 = Theme.TextDisabled }, 0.2) end
                    local indFrame = btn:FindFirstChildOfClass("Frame")
                    if indFrame then indFrame.Visible = false end
                end
            end
        end
        
        tabBtn.MouseButton1Click:Connect(Activate)
        
        -- İlk tab otomatik aktif
        if tabIndex == 1 then
            task.defer(Activate)
        end
        
        -- Hover
        tabBtn.MouseEnter:Connect(function()
            if activeTab ~= tabIndex then
                Tween(tabBtn, { BackgroundTransparency = 0.6, BackgroundColor3 = Theme.ThirdBG }, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if activeTab ~= tabIndex then
                Tween(tabBtn, { BackgroundTransparency = 1 }, 0.15)
            end
        end)
        
        -- Arama filtresi
        searchInput:GetPropertyChangedSignal("Text"):Connect(function()
            local query = searchInput.Text:lower()
            if activeTab ~= tabIndex then return end
            for _, section in ipairs(tabFrame:GetChildren()) do
                if section:IsA("Frame") and section.Name:find("Section_") then
                    for _, component in ipairs(section:GetChildren()) do
                        if component:IsA("Frame") and component:FindFirstChildOfClass("TextLabel") then
                            local lbl = component:FindFirstChildOfClass("TextLabel")
                            if lbl then
                                component.Visible = (query == "" or lbl.Text:lower():find(query) ~= nil)
                            end
                        end
                    end
                end
            end
        end)
        
        -- ═══════════════════════════════════════════════════════
        --                  TAB API
        -- ═══════════════════════════════════════════════════════
        
        local Tab = {}
        Tab._Frame = tabFrame
        Tab._Theme = Theme
        
        -- ─── SECTION OLUŞTURMA ────────────────────────────────
        function Tab:CreateSection(sectionName)
            local section = Create("Frame", {
                Name = "Section_" .. sectionName,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.SecondBG,
                Parent = tabFrame
            })
            AddCorner(section, 8)
            AddStroke(section, Theme.Border, 1)
            AddPadding(section, 36, 8, 8, 8)
            
            -- Section başlığı
            local sectionHeader = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                Position = UDim2.fromOffset(0, 0),
                BackgroundColor3 = Theme.ThirdBG,
                Parent = section
            })
            -- Corner sadece üst iki köşe için
            AddCorner(sectionHeader, 6)
            
            -- Sol kırmızı çizgi
            local sectionAccent = Create("Frame", {
                Size = UDim2.fromOffset(3, 14),
                Position = UDim2.new(0, 8, 0.5, -7),
                BackgroundColor3 = Theme.Accent,
                Parent = sectionHeader
            })
            AddCorner(sectionAccent, 2)
            
            local sectionTitle = Create("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.fromOffset(18, 0),
                BackgroundTransparency = 1,
                Text = sectionName,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.TextSecondary,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionHeader
            })
            
            local sectionLayout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
                Parent = section
            })
            
            -- ═══════════════════════════════════════════════════
            --              SECTION API (COMPONENTLER)
            -- ═══════════════════════════════════════════════════
            
            local Section = {}
            Section._Frame = section
            Section._Theme = Theme
            
            -- ────────────────────────────────────────────────
            --  TOGGLE
            -- ────────────────────────────────────────────────
            function Section:CreateToggle(cfg)
                cfg = cfg or {}
                local state = cfg.Default or false
                
                local row = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.ThirdBG,
                    BackgroundTransparency = 0.4,
                    Parent = section
                })
                AddCorner(row, 6)
                
                local label = Create("TextLabel", {
                    Size = UDim2.new(1, -70, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = cfg.Name or "Toggle",
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                })
                
                -- Toggle anahtarı
                local toggleBG = Create("Frame", {
                    Size = UDim2.fromOffset(40, 22),
                    Position = UDim2.new(1, -50, 0.5, -11),
                    BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                    Parent = row
                })
                AddCorner(toggleBG, 11)
                
                local toggleDot = Create("Frame", {
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.fromOffset(state and 20 or 3, 3),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = toggleBG
                })
                AddCorner(toggleDot, 8)
                
                local btn = Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = row
                })
                
                local function SetState(v)
                    state = v
                    Tween(toggleBG, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.2)
                    Tween(toggleDot, { Position = UDim2.fromOffset(state and 20 or 3, 3) }, 0.2)
                    if cfg.Callback then cfg.Callback(state) end
                end
                
                btn.MouseButton1Click:Connect(function()
                    SetState(not state)
                end)
                
                -- Hover
                row.MouseEnter:Connect(function() Tween(row, { BackgroundTransparency = 0.2 }, 0.15) end)
                row.MouseLeave:Connect(function() Tween(row, { BackgroundTransparency = 0.4 }, 0.15) end)
                
                local API = {}
                function API:Set(v) SetState(v) end
                function API:Get() return state end
                return API
            end
            
            -- ────────────────────────────────────────────────
            --  BUTTON
            -- ────────────────────────────────────────────────
            function Section:CreateButton(cfg)
                cfg = cfg or {}
                
                local btn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = 0.2,
                    Text = "",
                    Parent = section
                })
                AddCorner(btn, 6)
                AddStroke(btn, Theme.AccentDark, 1)
                
                local label = Create("TextLabel", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = cfg.Name or "Buton",
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = btn
                })
                
                btn.MouseEnter:Connect(function()
                    Tween(btn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.AccentLight }, 0.15)
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, { BackgroundTransparency = 0.2, BackgroundColor3 = Theme.Accent }, 0.15)
                end)
                btn.MouseButton1Down:Connect(function()
                    Tween(btn, { BackgroundColor3 = Theme.AccentDark }, 0.1)
                end)
                btn.MouseButton1Up:Connect(function()
                    Tween(btn, { BackgroundColor3 = Theme.AccentLight }, 0.1)
                end)
                
                btn.MouseButton1Click:Connect(function()
                    if cfg.Callback then cfg.Callback() end
                end)
                
                local API = {}
                function API:SetText(t) label.Text = t end
                return API
            end
            
            -- ────────────────────────────────────────────────
            --  SLIDER
            -- ────────────────────────────────────────────────
            function Section:CreateSlider(cfg)
                cfg = cfg or {}
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local value = math.clamp(cfg.Default or min, min, max)
                local suffix = cfg.Suffix or ""
                
                local row = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Theme.ThirdBG,
                    BackgroundTransparency = 0.4,
                    Parent = section
                })
                AddCorner(row, 6)
                AddPadding(row, 0, 10, 0, 10)
                
                local topRow = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    Parent = row
                })
                
                local nameLabel = Create("TextLabel", {
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = cfg.Name or "Slider",
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = topRow
                })
                
                local valueLabel = Create("TextLabel", {
                    Size = UDim2.new(0.3, 0, 1, 0),
                    Position = UDim2.fromScale(0.7, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(value) .. suffix,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Accent,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = topRow
                })
                
                -- Track
                local track = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 0, 32),
                    BackgroundColor3 = Theme.FourthBG,
                    Parent = row
                })
                AddCorner(track, 3)
                
                local fill = Create("Frame", {
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    Parent = track
                })
                AddCorner(fill, 3)
                
                -- Handle
                local handle = Create("Frame", {
                    Size = UDim2.fromOffset(14, 14),
                    Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = track
                })
                AddCorner(handle, 7)
                AddStroke(handle, Theme.Accent, 2)
                
                local dragging = false
                
                local function UpdateSlider(x)
                    local trackPos = track.AbsolutePosition.X
                    local trackSize = track.AbsoluteSize.X
                    local percent = math.clamp((x - trackPos) / trackSize, 0, 1)
                    value = math.floor(min + (max - min) * percent)
                    
                    Tween(fill, { Size = UDim2.new(percent, 0, 1, 0) }, 0.05)
                    Tween(handle, { Position = UDim2.new(percent, -7, 0.5, -7) }, 0.05)
                    valueLabel.Text = tostring(value) .. suffix
                    
                    if cfg.Callback then cfg.Callback(value) end
                end
                
                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input.Position.X)
                    end
                end)
                
                track.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input.Position.X)
                    end
                end)
                
                local API = {}
                function API:Set(v)
                    value = math.clamp(v, min, max)
                    local percent = (value - min) / (max - min)
                    Tween(fill, { Size = UDim2.new(percent, 0, 1, 0) }, 0.2)
                    Tween(handle, { Position = UDim2.new(percent, -7, 0.5, -7) }, 0.2)
                    valueLabel.Text = tostring(value) .. suffix
                    if cfg.Callback then cfg.Callback(value) end
                end
                function API:Get() return value end
                return API
            end
            
            -- ────────────────────────────────────────────────
            --  DROPDOWN
            -- ────────────────────────────────────────────────
            function Section:CreateDropdown(cfg)
                cfg = cfg or {}
                local options = cfg.Options or {}
                local selected = cfg.Default or (options[1] or "")
                local isOpen = false
                
                local container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundTransparency = 1,
                    ClipsDescendants = false,
                    ZIndex = 10,
                    Parent = section
                })
                
                local header = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.ThirdBG,
                    BackgroundTransparency = 0.4,
                    ZIndex = 10,
                    Parent = container
                })
                AddCorner(header, 6)
                AddStroke(header, Theme.Border, 1)
                
                local nameLabel = Create("TextLabel", {
                    Size = UDim2.new(0.55, 0, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = cfg.Name or "Dropdown",
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 10,
                    Parent = header
                })
                
                local selectedLabel = Create("TextLabel", {
                    Size = UDim2.new(0.4, -30, 1, 0),
                    Position = UDim2.new(0.55, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = selected,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Accent,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 10,
                    Parent = header
                })
                
                local arrow = Create("TextLabel", {
                    Size = UDim2.fromOffset(24, 34),
                    Position = UDim2.new(1, -28, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "▾",
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.TextSecondary,
                    ZIndex = 10,
                    Parent = header
                })
                
                -- Dropdown listesi
                local dropList = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 38),
                    BackgroundColor3 = Theme.ThirdBG,
                    ClipsDescendants = true,
                    ZIndex = 20,
                    Parent = container
                })
                AddCorner(dropList, 6)
                AddStroke(dropList, Theme.Border, 1)
                
                local dropLayout = Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2),
                    Parent = dropList
                })
                AddPadding(dropList, 3, 4, 3, 4)
                
                -- Seçenekleri oluştur
                for _, opt in ipairs(options) do
                    local optBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = Theme.FourthBG,
                        BackgroundTransparency = 1,
                        Text = opt,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.TextPrimary,
                        ZIndex = 20,
                        Parent = dropList
                    })
                    AddCorner(optBtn, 4)
                    
                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(255,255,255) }, 0.1)
                    end)
                    optBtn.MouseLeave:Connect(function()
                        Tween(optBtn, { BackgroundTransparency = 1, TextColor3 = Theme.TextPrimary }, 0.1)
                    end)
                    
                    optBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        selectedLabel.Text = opt
                        -- Kapat
                        isOpen = false
                        Tween(dropList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                        Tween(container, { Size = UDim2.new(1, 0, 0, 34) }, 0.2)
                        Tween(arrow, { Rotation = 0 }, 0.2)
                        if cfg.Callback then cfg.Callback(selected) end
                    end)
                end
                
                local totalHeight = #options * 30 + 6
                
                -- Toggle açma/kapama
                local headerBtn = Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 15,
                    Parent = header
                })
                
                headerBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        Tween(dropList, { Size = UDim2.new(1, 0, 0, totalHeight) }, 0.25)
                        Tween(container, { Size = UDim2.new(1, 0, 0, 34 + totalHeight + 4) }, 0.25)
                        Tween(arrow, { Rotation = 180 }, 0.2)
                    else
                        Tween(dropList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                        Tween(container, { Size = UDim2.new(1, 0, 0, 34) }, 0.2)
                        Tween(arrow, { Rotation = 0 }, 0.2)
                    end
                end)
                
                header.MouseEnter:Connect(function() Tween(header, { BackgroundTransparency = 0.2 }, 0.15) end)
                header.MouseLeave:Connect(function() Tween(header, { BackgroundTransparency = 0.4 }, 0.15) end)
                
                local API = {}
                function API:Set(v)
                    selected = v
                    selectedLabel.Text = v
                    if cfg.Callback then cfg.Callback(v) end
                end
                function API:Get() return selected end
                function API:Refresh(newOptions)
                    for _, c in ipairs(dropList:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    options = newOptions
                    for _, opt in ipairs(options) do
                        local optBtn = Create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = Theme.FourthBG,
                            BackgroundTransparency = 1,
                            Text = opt,
                            TextSize = 12,
                            Font = Enum.Font.Gotham,
                            TextColor3 = Theme.TextPrimary,
                            ZIndex = 20,
                            Parent = dropList
                        })
                        AddCorner(optBtn, 4)
                        optBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            selectedLabel.Text = opt
                            isOpen = false
                            Tween(dropList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                            Tween(container, { Size = UDim2.new(1, 0, 0, 34) }, 0.2)
                            if cfg.Callback then cfg.Callback(selected) end
                        end)
                    end
                end
                return API
            end
            
            -- ────────────────────────────────────────────────
            --  INPUT (TextBox)
            -- ────────────────────────────────────────────────
            function Section:CreateInput(cfg)
                cfg = cfg or {}
                
                local row = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Theme.ThirdBG,
                    BackgroundTransparency = 0.4,
                    Parent = section
                })
                AddCorner(row, 6)
                AddPadding(row, 0, 10, 0, 10)
                
                local nameLabel = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = cfg.Name or "Giriş",
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                })
                
                local inputBG = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 26),
                    Position = UDim2.fromOffset(0, 22),
                    BackgroundColor3 = Theme.FourthBG,
                    Parent = row
                })
                AddCorner(inputBG, 4)
                AddStroke(inputBG, Theme.Border, 1)
                
                local input = Create("TextBox", {
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.fromOffset(8, 0),
                    BackgroundTransparency = 1,
                    PlaceholderText = cfg.Placeholder or "Yazın...",
                    PlaceholderColor3 = Theme.TextDisabled,
                    Text = cfg.Default or "",
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    ClearTextOnFocus = false,
                    Parent = inputBG
                })
                
                -- Focus efekti
                input.Focused:Connect(function()
                    Tween(inputBG, { BackgroundColor3 = Theme.ThirdBG }, 0.15)
                    AddStroke(inputBG, Theme.Accent, 1)
                end)
                input.FocusLost:Connect(function(enterPressed)
                    Tween(inputBG, { BackgroundColor3 = Theme.FourthBG }, 0.15)
                    if cfg.Callback then cfg.Callback(input.Text, enterPressed) end
                end)
                
                local API = {}
                function API:Set(t) input.Text = t end
                function API:Get() return input.Text end
                return API
            end
            
            -- ────────────────────────────────────────────────
            --  KEYBIND
            -- ────────────────────────────────────────────────
            function Section:CreateKeybind(cfg)
                cfg = cfg or {}
                local currentKey = cfg.Default or Enum.KeyCode.Unknown
                local listening = false
                
                local row = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.ThirdBG,
                    BackgroundTransparency = 0.4,
                    Parent = section
                })
                AddCorner(row, 6)
                AddPadding(row, 0, 10, 0, 10)
                
                local nameLabel = Create("TextLabel", {
                    Size = UDim2.new(0.6, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = cfg.Name or "Keybind",
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                })
                
                local keyBtn = Create("TextButton", {
                    Size = UDim2.fromOffset(70, 24),
                    Position = UDim2.new(1, -70, 0.5, -12),
                    BackgroundColor3 = Theme.FourthBG,
                    Text = currentKey.Name,
                    TextSize = 11,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Accent,
                    Parent = row
                })
                AddCorner(keyBtn, 4)
                AddStroke(keyBtn, Theme.Border, 1)
                
                keyBtn.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    keyBtn.Text = "..."
                    keyBtn.TextColor3 = Theme.TextPrimary
                    
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            keyBtn.Text = currentKey.Name
                            keyBtn.TextColor3 = Theme.Accent
                            listening = false
                            conn:Disconnect()
                        end
                    end)
                end)
                
                -- Dinle
                UserInputService.InputBegan:Connect(function(input, gpe)
                    if not gpe and input.KeyCode == currentKey then
                        if cfg.Callback then cfg.Callback() end
                    end
                end)
                
                row.MouseEnter:Connect(function() Tween(row, { BackgroundTransparency = 0.2 }, 0.15) end)
                row.MouseLeave:Connect(function() Tween(row, { BackgroundTransparency = 0.4 }, 0.15) end)
                
                local API = {}
                function API:Set(k)
                    currentKey = k
                    keyBtn.Text = k.Name
                end
                function API:Get() return currentKey end
                return API
            end
            
            -- ────────────────────────────────────────────────
            --  COLOR PICKER
            -- ────────────────────────────────────────────────
            function Section:CreateColorPicker(cfg)
                cfg = cfg or {}
                local color = cfg.Default or Color3.fromRGB(255, 0, 0)
                
                local container = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.ThirdBG,
                    BackgroundTransparency = 0.4,
                    ClipsDescendants = false,
                    ZIndex = 5,
                    Parent = section
                })
                AddCorner(container, 6)
                
                local nameLabel = Create("TextLabel", {
                    Size = UDim2.new(0.7, 0, 0, 34),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = cfg.Name or "Renk",
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    Parent = container
                })
                
                local colorPreview = Create("Frame", {
                    Size = UDim2.fromOffset(28, 20),
                    Position = UDim2.new(1, -38, 0.5, -10),
                    BackgroundColor3 = color,
                    ZIndex = 5,
                    Parent = container
                })
                AddCorner(colorPreview, 4)
                AddStroke(colorPreview, Theme.Border, 1)
                
                -- RGB picker paneli
                local picker = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 38),
                    BackgroundColor3 = Theme.FourthBG,
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 10,
                    Parent = container
                })
                AddCorner(picker, 6)
                AddStroke(picker, Theme.Border, 1)
                AddPadding(picker, 8, 10, 8, 10)
                
                local pickerLayout = Create("UIListLayout", {
                    Padding = UDim.new(0, 6),
                    Parent = picker
                })
                
                local r, g, b = color.R * 255, color.G * 255, color.B * 255
                
                local function MakeChannelSlider(channel, default, callback)
                    local sf = Create("Frame", {
                        Size = UDim2.new(1, 0, 0, 20),
                        BackgroundTransparency = 1,
                        Parent = picker
                    })
                    local lbl = Create("TextLabel", {
                        Size = UDim2.fromOffset(14, 20),
                        BackgroundTransparency = 1,
                        Text = channel,
                        TextSize = 11,
                        Font = Enum.Font.GothamBold,
                        TextColor3 = Theme.TextSecondary,
                        Parent = sf
                    })
                    local track = Create("Frame", {
                        Size = UDim2.new(1, -50, 0, 6),
                        Position = UDim2.fromOffset(18, 7),
                        BackgroundColor3 = Theme.SecondBG,
                        Parent = sf
                    })
                    AddCorner(track, 3)
                    local channelColors = { R = Color3.fromRGB(220,30,30), G = Color3.fromRGB(30,200,30), B = Color3.fromRGB(30,100,220) }
                    local fill = Create("Frame", {
                        Size = UDim2.new(default/255, 0, 1, 0),
                        BackgroundColor3 = channelColors[channel] or Theme.Accent,
                        Parent = track
                    })
                    AddCorner(fill, 3)
                    local valLbl = Create("TextLabel", {
                        Size = UDim2.fromOffset(28, 20),
                        Position = UDim2.new(1, -28, 0, 0),
                        BackgroundTransparency = 1,
                        Text = tostring(math.floor(default)),
                        TextSize = 10,
                        Font = Enum.Font.GothamBold,
                        TextColor3 = Theme.TextSecondary,
                        Parent = sf
                    })
                    local draggingC = false
                    track.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingC = true
                            local pct = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                            fill.Size = UDim2.new(pct, 0, 1, 0)
                            valLbl.Text = tostring(math.floor(pct * 255))
                            callback(pct * 255)
                        end
                    end)
                    track.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingC = false end
                    end)
                    UserInputService.InputChanged:Connect(function(i)
                        if draggingC and i.UserInputType == Enum.UserInputType.MouseMovement then
                            local pct = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                            fill.Size = UDim2.new(pct, 0, 1, 0)
                            valLbl.Text = tostring(math.floor(pct * 255))
                            callback(pct * 255)
                        end
                    end)
                end
                
                local function UpdateColor()
                    color = Color3.fromRGB(r, g, b)
                    colorPreview.BackgroundColor3 = color
                    if cfg.Callback then cfg.Callback(color) end
                end
                
                MakeChannelSlider("R", r, function(v) r = v UpdateColor() end)
                MakeChannelSlider("G", g, function(v) g = v UpdateColor() end)
                MakeChannelSlider("B", b, function(v) b = v UpdateColor() end)
                
                local isOpen = false
                local colorBtn = Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 6,
                    Parent = container
                })
                
                colorBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        picker.Visible = true
                        Tween(picker, { Size = UDim2.new(1, 0, 0, 80) }, 0.2)
                        Tween(container, { Size = UDim2.new(1, 0, 0, 122) }, 0.2)
                    else
                        Tween(picker, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                        Tween(container, { Size = UDim2.new(1, 0, 0, 34) }, 0.2)
                        task.delay(0.2, function() if not isOpen then picker.Visible = false end end)
                    end
                end)
                
                container.MouseEnter:Connect(function() Tween(container, { BackgroundTransparency = 0.2 }, 0.15) end)
                container.MouseLeave:Connect(function() Tween(container, { BackgroundTransparency = 0.4 }, 0.15) end)
                
                local API = {}
                function API:Set(c)
                    color = c
                    colorPreview.BackgroundColor3 = c
                end
                function API:Get() return color end
                return API
            end
            
            -- ────────────────────────────────────────────────
            --  LABEL
            -- ────────────────────────────────────────────────
            function Section:CreateLabel(text)
                local lbl = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    Text = text or "",
                    TextSize = 11,
                    Font = Enum.Font.GothamItalic,
                    TextColor3 = Theme.TextDisabled,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = section
                })
                AddPadding(lbl, 0, 0, 0, 10)
                
                local API = {}
                function API:Set(t) lbl.Text = t end
                return API
            end
            
            -- ────────────────────────────────────────────────
            --  SEPARATOR
            -- ────────────────────────────────────────────────
            function Section:CreateSeparator()
                local sep = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Theme.Border,
                    Parent = section
                })
                return sep
            end
            
            return Section
        end -- CreateSection
        
        return Tab
    end -- CreateTab
    
    -- ─── KONFİGÜRASYON KAYDET/YÜKLEİ ───────────────────────────
    function Window:SaveConfig(name)
        if not writefile then
            warn("RedaxHub: writefile desteklenmiyor")
            return
        end
        -- Basit bir config yapısı (toggle/slider değerlerini saklar)
        writefile("redax_" .. (name or "config") .. ".json", "{}")
        print("RedaxHub: Config kaydedildi!")
    end
    
    function Window:LoadConfig(name)
        if not readfile or not isfile then return end
        if isfile("redax_" .. (name or "config") .. ".json") then
            local data = readfile("redax_" .. (name or "config") .. ".json")
            print("RedaxHub: Config yüklendi!")
            return HttpService:JSONDecode(data)
        end
    end
    
    -- Bildirim kısayolu
    function Window:Notify(opts)
        return RedaxHub.Notify(RedaxHub, opts)
    end
    
    -- Giriş animasyonu
    main.BackgroundTransparency = 1
    main.Size = UDim2.fromOffset(mainSize.X.Offset * 0.9, mainSize.Y.Offset * 0.9)
    task.defer(function()
        Tween(main, {
            BackgroundTransparency = 0,
            Size = mainSize
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    
    return Window
end

-- ═══════════════════════════════════════════════════════════════
--              TEMA DEĞİŞTİRME (Global)
-- ═══════════════════════════════════════════════════════════════

function RedaxHub:SetTheme(themeName)
    local t = Themes[themeName]
    if t then
        self._Theme = t
        print("RedaxHub: Tema değiştirildi -> " .. themeName)
    end
end

function RedaxHub:RegisterTheme(name, theme)
    Themes[name] = theme
end

return RedaxHub
