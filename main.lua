--[[
    🎮 DELTA DARK PREMIUM HUB - VERSION 9.0 (SUPERHERO & ULTIMATE VFX) 🎮
    - Mới: Chế độ Siêu Nhân (Áo choàng năng lượng, Hào quang cơ thể).
    - Mới: Mắt bắn Laser hủy diệt + Hoạt ảnh gồng lực + VFX nổ điểm chạm.
    - Mới: Năng lực nhấc bổng & điều khiển người chơi bằng tia liên kết vật lý.
    - Nâng cấp: Nâng tầm VFX cho Bay (Wind Ring), Air Walk (Hex Shield), Water Walk (Splash).
--]]

-- Reset kết nối cũ tránh trùng lặp
if _G.DeltaHubConnections then
    for name, connection in pairs(_G.DeltaHubConnections) do
        if connection then pcall(function() connection:Disconnect() end) end
    end
end
_G.DeltaHubConnections = {}

-- Load Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Khởi tạo Shader
local function getOrCreateShader(className, name)
    local shader = Lighting:FindFirstChild(name)
    if not shader then
        shader = Instance.new(className)
        shader.Name = name
        shader.Parent = Lighting
    end
    return shader
end

local CustomBlur = getOrCreateShader("BlurEffect", "Delta_Blur")
local CustomColorCorr = getOrCreateShader("ColorCorrectionEffect", "Delta_ColorCorr")
CustomBlur.Size = 0
CustomColorCorr.Contrast = 0
CustomColorCorr.Saturation = 0
CustomColorCorr.Brightness = 0

local function cleanShaders()
    if CustomBlur then pcall(function() CustomBlur:Destroy() end) end
    if CustomColorCorr then pcall(function() CustomColorCorr:Destroy() end) end
end

-- Tạo folder chứa VFX tránh rác Workspace
local vfxFolder = Workspace:FindFirstChild("Delta_VFX_Storage")
if not vfxFolder then 
    vfxFolder = Instance.new("Folder", Workspace)
    vfxFolder.Name = "Delta_VFX_Storage" 
end

----------------------------------------------------
-- 🌀 HIỆU ỨNG LOADING SCREEN (VFX & ANIMATION) 🌀
----------------------------------------------------
local LoadingGui = Instance.new("ScreenGui")
local coreGuiSuccess, coreGuiParent = pcall(function() return game:GetService("CoreGui") end)
LoadingGui.Parent = coreGuiSuccess and coreGuiParent or LocalPlayer:FindFirstChildOfClass("PlayerGui")
LoadingGui.Name = "DeltaLoading_" .. tostring(math.random(1000, 9999))

local LoadFrame = Instance.new("Frame", LoadingGui)
LoadFrame.Size = UDim2.new(0, 300, 0, 150)
LoadFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 12)

local LoadStroke = Instance.new("UIStroke", LoadFrame)
LoadStroke.Thickness = 2
LoadStroke.Color = Color3.fromRGB(230, 30, 30)

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Size = UDim2.new(1, 0, 0, 40)
LoadTitle.Position = UDim2.new(0, 0, 0, 15)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "DELTA DARK ULTIMATE v9.0"
LoadTitle.Font = Enum.Font.SourceSansBold
LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadTitle.TextSize = 20

local LoadStatus = Instance.new("TextLabel", LoadFrame)
LoadStatus.Size = UDim2.new(1, 0, 0, 20)
LoadStatus.Position = UDim2.new(0, 0, 0, 55)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Đang nạp hệ thống VFX..."
LoadStatus.Font = Enum.Font.SourceSansItalic
LoadStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
LoadStatus.TextSize = 13

local ProgressBg = Instance.new("Frame", LoadFrame)
ProgressBg.Size = UDim2.new(0.8, 0, 0, 6)
ProgressBg.Position = UDim2.new(0.1, 0, 0, 95)
ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(1, 0)

local ProgressBar = Instance.new("Frame", ProgressBg)
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(230, 30, 30)
Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(1, 0)

local steps = {"Khởi tạo hạt quang phổ...", "Tải cấu trúc Áo Choàng Siêu Nhân...", "Cân chỉnh tọa độ Laser...", "Sẵn sàng chiến đấu!"}
task.spawn(function()
    for i, stepText in ipairs(steps) do
        LoadStatus.Text = stepText
        local targetScale = i / #steps
        local tween = TweenService:Create(ProgressBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(targetScale, 0, 1, 0)})
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.1)
    end
    local fadeTween = TweenService:Create(LoadFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    TweenService:Create(LoadStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    TweenService:Create(LoadTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(LoadStatus, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(ProgressBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(ProgressBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    fadeTween:Play()
    fadeTween.Completed:Wait()
    LoadingGui:Destroy()
end)

task.wait(1.5)

----------------------------------------------------
-- ⚡ CHỨC NĂNG SIÊU ANH HÙNG (SUPERHERO SYSTEM) ⚡
----------------------------------------------------
local superheroActive = false
local laserActive = false
local grabActive = false

local grabbedPlayer = nil
local grabConnection = nil
local grabLaserBeam = nil
local grabAttA, grabAttB = nil, nil

-- 1. TẠO ÁO CHOÀNG & HÀO QUANG SIÊU NHÂN
local function applySuperheroVFX(char)
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not torso then return end

    -- Tạo Áo Choàng Năng Lượng bằng Beams cực đẹp
    local attTop = Instance.new("Attachment", torso)
    attTop.Name = "CapeTop"
    attTop.Position = Vector3.new(0, 0.8, 0.55)

    local attBottom = Instance.new("Attachment", torso)
    attBottom.Name = "CapeBottom"
    attBottom.Position = Vector3.new(0, -2.2, 1.4)

    local cape = Instance.new("Beam", torso)
    cape.Name = "HeroCape"
    cape.Attachment0 = attTop
    cape.Attachment1 = attBottom
    cape.Width0 = 1.4
    cape.Width1 = 2.4
    cape.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    })
    cape.Texture = "rbxassetid://1084991219" -- Texture lượn sóng phản quang
    cape.TextureSpeed = 2
    cape.LightEmission = 0.85
    cape.LightInfluence = 0

    -- Hiệu ứng Bụi Sao (Sparks) rơi từ áo choàng
    local spark = Instance.new("ParticleEmitter", attTop)
    spark.Name = "HeroSparks"
    spark.Texture = "rbxassetid://244222064"
    spark.Color = ColorSequence.new(Color3.fromRGB(255, 50, 50))
    spark.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.25),
        NumberSequenceKeypoint.new(1, 0)
    })
    spark.Lifetime = NumberRange.new(0.6, 1.2)
    spark.Speed = NumberRange.new(2, 4)
    spark.SpreadAngle = Vector2.new(25, 25)
    spark.Acceleration = Vector3.new(0, -6, -2)

    -- Hào quang đỏ rực quanh cơ thể (Body Aura)
    local aura = Instance.new("ParticleEmitter", torso)
    aura.Name = "HeroAura"
    aura.Texture = "rbxassetid://607157592"
    aura.Color = ColorSequence.new(Color3.fromRGB(255, 0, 50))
    aura.Size = NumberSequence.new(2, 3.5)
    aura.Lifetime = NumberRange.new(0.8, 1.4)
    aura.Rate = 15
    aura.Speed = NumberRange.new(0.5, 1.5)
    aura.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0.4),
        NumberSequenceKeypoint.new(1, 1)
    })
end

local function removeSuperheroVFX(char)
    if not char then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj.Name == "HeroCape" or obj.Name == "CapeTop" or obj.Name == "CapeBottom" or obj.Name == "HeroAura" then
            obj:Destroy()
        end
    end
end

-- 2. BẮN LASER MẮT + HOẠT ẢNH + VFX BÙNG NỔ
local function fireEyeLasers()
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end

    local mouse = LocalPlayer:GetMouse()
    local targetPos = mouse.Hit.p

    -- Hoạt ảnh gồng mình (Procedural Head-tilt & Arms Raise)
    local anim = Instance.new("Animation")
    anim.AnimationId = getCharacterRigType() == "R15" and "rbxassetid://507770677" or "rbxassetid://125750702"
    local hum = char:FindFirstChildOfClass("Humanoid")
    local loadAnim = hum and hum:FindFirstChildOfClass("Animator"):LoadAnimation(anim)
    if loadAnim then
        loadAnim:Play()
        loadAnim.AdjustSpeed(loadAnim, 2)
    end

    -- Tính toán điểm phát laser từ 2 mắt
    local leftEyeOffset = head.CFrame * CFrame.new(-0.25, 0.15, -0.55)
    local rightEyeOffset = head.CFrame * CFrame.new(0.25, 0.15, -0.55)

    -- Hàm dựng đường tia laser phát sáng hình Cylinder
    local function createLaserBeam(startCFrame)
        local distance = (startCFrame.p - targetPos).Magnitude
        local laser = Instance.new("Part", vfxFolder)
        laser.Anchored = true
        laser.CanCollide = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(255, 0, 0)
        laser.Size = Vector3.new(0.25, 0.25, distance)
        laser.CFrame = CFrame.new(startCFrame.p, targetPos) * CFrame.new(0, 0, -distance/2)
        
        -- Hiệu ứng co rút biến mất mượt mà
        TweenService:Create(laser, TweenInfo.new(0.25), {
            Size = Vector3.new(0, 0, distance),
            Color = Color3.fromRGB(255, 150, 0)
        }):Play()
        task.delay(0.25, function() laser:Destroy() end)
    end

    createLaserBeam(leftEyeOffset)
    createLaserBeam(rightEyeOffset)

    -- VFX Điểm Chạm (Impact Explosion)
    local impact = Instance.new("Part", vfxFolder)
    impact.Shape = Enum.PartType.Ball
    impact.Material = Enum.Material.Neon
    impact.Color = Color3.fromRGB(255, 50, 0)
    impact.Size = Vector3.new(1, 1, 1)
    impact.Position = targetPos
    impact.Anchored = true
    impact.CanCollide = false

    local impactAura = Instance.new("ParticleEmitter", impact)
    impactAura.Texture = "rbxassetid://244222064"
    impactAura.Size = NumberSequence.new(1, 0)
    impactAura.Speed = NumberRange.new(10, 25)
    impactAura.Lifetime = NumberRange.new(0.3, 0.7)
    impactAura.Rate = 120

    TweenService:Create(impact, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(6, 6, 6),
        Transparency = 1
    }):Play()

    task.delay(0.3, function() impact:Destroy() end)

    -- Sức mạnh hất văng vật phẩm hoặc người chơi gần điểm chạm
    task.spawn(function()
        local exp = Instance.new("Explosion")
        exp.Position = targetPos
        exp.BlastRadius = 10
        exp.BlastPressure = 200000 -- Đẩy văng cực mạnh nhưng không làm chết nhân vật
        exp.Parent = vfxFolder
    end)
end

-- 3. ĐIỀU KHIỂN & NHẤC NGƯỜI CHƠI (TELEKINESIS GRAB)
local function startGrabbing()
    local mouse = LocalPlayer:GetMouse()
    local target = mouse.Target
    if not target then return end

    local charModel = target:FindFirstAncestorOfClass("Model")
    if charModel and charModel:FindFirstChildOfClass("Humanoid") and charModel ~= LocalPlayer.Character then
        grabbedPlayer = charModel
        local targetHrp = grabbedPlayer:FindFirstChild("HumanoidRootPart")
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetHrp and myHrp then
            -- Tạo tia sét năng lượng kết nối vật lý bằng Beam
            grabAttA = Instance.new("Attachment", myHrp)
            grabAttA.Name = "GrabAttA"
            grabAttA.Position = Vector3.new(0, 1.5, -1)

            grabAttB = Instance.new("Attachment", targetHrp)
            grabAttB.Name = "GrabAttB"

            grabLaserBeam = Instance.new("Beam", vfxFolder)
            grabLaserBeam.Attachment0 = grabAttA
            grabLaserBeam.Attachment1 = grabAttB
            grabLaserBeam.Width0 = 0.5
            grabLaserBeam.Width1 = 0.5
            grabLaserBeam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 50))
            grabLaserBeam.Texture = "rbxassetid://1084991219"
            grabLaserBeam.TextureSpeed = 6
            grabLaserBeam.LightEmission = 1

            -- Cập nhật liên tục kéo người chơi bay lơ lửng trước mặt
            grabConnection = RunService.Heartbeat:Connect(function()
                if grabbedPlayer and grabbedPlayer:Parent() and myHrp:Parent() then
                    targetHrp.CFrame = myHrp.CFrame * CFrame.new(0, 3, -12)
                    targetHrp.Velocity = Vector3.new(0, 0, 0)
                else
                    stopGrabbing()
                end
            end)
            _G.DeltaHubConnections["GrabSystem"] = grabConnection
        end
    end
end

local function stopGrabbing()
    if grabConnection then grabConnection:Disconnect() grabConnection = nil end
    if grabLaserBeam then grabLaserBeam:Destroy() grabLaserBeam = nil end
    if grabAttA then grabAttA:Destroy() grabAttA = nil end
    if grabAttB then grabAttB:Destroy() grabAttB = nil end
    grabbedPlayer = nil
end

----------------------------------------------------
-- ⚙️ THIẾT KẾ GIAO DIỆN DARK PREMIUM v9.0
----------------------------------------------------
local DarkGui = Instance.new("ScreenGui")
DarkGui.Parent = coreGuiSuccess and coreGuiParent or LocalPlayer:FindFirstChildOfClass("PlayerGui")
DarkGui.Name = "DeltaDarkHub_" .. tostring(math.random(1000, 9999))
DarkGui.ResetOnSpawn = false

local BASE_WIDTH = 560
local BASE_HEIGHT = 370
local currentScale = 1.0

local MainFrame = Instance.new("Frame", DarkGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
MainFrame.Position = UDim2.new(0.5, -BASE_WIDTH/2, 0.5, -BASE_HEIGHT/2)
MainFrame.Size = UDim2.new(0, BASE_WIDTH, 0, BASE_HEIGHT)
MainFrame.Active = true

local HubScale = Instance.new("UIScale", MainFrame)
HubScale.Scale = 1.0

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
local HubStroke = Instance.new("UIStroke", MainFrame)
HubStroke.Thickness = 2
HubStroke.Color = Color3.fromRGB(230, 30, 30) -- Đỏ rực rỡ phong cách Siêu Nhân

local HeaderBar = Instance.new("Frame", MainFrame)
HeaderBar.Size = UDim2.new(1, 0, 0, 42)
HeaderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeaderBar.BackgroundTransparency = 0.95
Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 16)

local HeaderGradient = Instance.new("UIGradient", HeaderBar)
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 10, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12))
})

-- Kéo thả UI
local dragToggle, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 10)
Title.Size = UDim2.new(1, -120, 0, 22)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DELTA DARK ULTIMATE v9.0 (SUPERHERO)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút thu nhỏ
local MiniButton = Instance.new("TextButton", DarkGui)
MiniButton.Size = UDim2.new(0, 50, 0, 50)
MiniButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MiniButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MiniButton.Text = "⚡"
MiniButton.Font = Enum.Font.SourceSansBold
MiniButton.TextColor3 = Color3.fromRGB(230, 30, 30)
MiniButton.TextSize = 25
MiniButton.Visible = false
Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(1, 0)

local MiniStroke = Instance.new("UIStroke", MiniButton)
MiniStroke.Thickness = 2
MiniStroke.Color = Color3.fromRGB(230, 30, 30)

local miniDrag, miniStart, miniFramePos
MiniButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDrag = true
        miniStart = input.Position
        miniFramePos = MiniButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then miniDrag = false end
        end)
    end
end)
MiniButton.InputChanged:Connect(function(input)
    if miniDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - miniStart
        MiniButton.Position = UDim2.new(
            miniFramePos.X.Scale, miniFramePos.X.Offset + delta.X,
            miniFramePos.Y.Scale, miniFramePos.Y.Offset + delta.Y
        )
    end
end)

local TopBarBtnContainer = Instance.new("Frame", MainFrame)
TopBarBtnContainer.Size = UDim2.new(0, 60, 0, 25)
TopBarBtnContainer.Position = UDim2.new(1, -75, 0, 10)
TopBarBtnContainer.BackgroundTransparency = 1

local LayoutTopBar = Instance.new("UIListLayout", TopBarBtnContainer)
LayoutTopBar.FillDirection = Enum.FillDirection.Horizontal
LayoutTopBar.HorizontalAlignment = Enum.HorizontalAlignment.Right
LayoutTopBar.Padding = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton", TopBarBtnContainer)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local ShrinkBtn = Instance.new("TextButton", TopBarBtnContainer)
ShrinkBtn.Size = UDim2.new(0, 22, 0, 22)
ShrinkBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ShrinkBtn.Text = "-"
ShrinkBtn.Font = Enum.Font.SourceSansBold
ShrinkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShrinkBtn.TextSize = 14
Instance.new("UICorner", ShrinkBtn).CornerRadius = UDim.new(1, 0)

ShrinkBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true, function()
        MainFrame.Visible = false
        MiniButton.Visible = true
    end)
end)

MiniButton.MouseButton1Click:Connect(function()
    MiniButton.Visible = false
    MainFrame.Visible = true
    MainFrame:TweenSize(UDim2.new(0, BASE_WIDTH, 0, BASE_HEIGHT), "Out", "Quad", 0.3, true)
end)

CloseBtn.MouseButton1Click:Connect(function()
    cleanShaders()
    stopGrabbing()
    if LocalPlayer.Character then removeSuperheroVFX(LocalPlayer.Character) end
    pcall(function() vfxFolder:Destroy() end)
    DarkGui:Destroy()
end)

-- Sidebar
local TabContainer = Instance.new("ScrollingFrame", MainFrame)
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabContainer.Position = UDim2.new(0, 12, 0, 52)
TabContainer.Size = UDim2.new(0, 125, 1, -66)
TabContainer.CanvasSize = UDim2.new(0, 0, 1.4, 0)
TabContainer.ScrollBarThickness = 0
Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 12)

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 7)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Nội dung bên phải
local ContentContainer = Instance.new("ScrollingFrame", MainFrame)
ContentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ContentContainer.Position = UDim2.new(0, 148, 0, 52)
ContentContainer.Size = UDim2.new(1, -160, 1, -66)
ContentContainer.CanvasSize = UDim2.new(0, 0, 1.5, 0)
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 55)
Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 12)

local ContentLayout = Instance.new("UIListLayout", ContentContainer)
ContentLayout.Padding = UDim.new(0, 14)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 25)
end)

----------------------------------------------------
-- DYNAMIC COMPONENTS BUILDER
----------------------------------------------------
local function clearContent()
    for _, child in ipairs(ContentContainer:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
end

local function addParagraph(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.94, 0, 0, 24)
    frame.BackgroundTransparency = 1
    frame.Parent = ContentContainer

    local p = Instance.new("TextLabel", frame)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Font = Enum.Font.SourceSansBold
    p.Text = "★  " .. text:upper()
    p.TextColor3 = HubStroke.Color
    p.TextSize = 13
    p.TextXAlignment = Enum.TextXAlignment.Left
    
    HubStroke:GetPropertyChangedSignal("Color"):Connect(function()
        p.TextColor3 = HubStroke.Color
    end)
end

local function addButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.94, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.Parent = ContentContainer
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(50, 50, 50)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(44, 44, 44)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(32, 32, 32)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

local function addToggle(name, default, callback)
    local active = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.94, 0, 0, 36)
    btn.BackgroundColor3 = active and HubStroke.Color or Color3.fromRGB(32, 32, 32)
    btn.Text = name .. (active and " [BẬT]" or " [TẮT]")
    btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.Parent = ContentContainer
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1
    stroke.Color = active and HubStroke.Color or Color3.fromRGB(50, 50, 50)

    HubStroke:GetPropertyChangedSignal("Color"):Connect(function()
        if active then
            btn.BackgroundColor3 = HubStroke.Color
            stroke.Color = HubStroke.Color
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        local targetColor = active and HubStroke.Color or Color3.fromRGB(32, 32, 32)
        local targetTextCol = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = targetColor, TextColor3 = targetTextCol}):Play()
        stroke.Color = active and HubStroke.Color or Color3.fromRGB(50, 50, 50)
        btn.Text = name .. (active and " [BẬT]" or " [TẮT]")
        pcall(callback, active)
    end)
end

local function addSlider(name, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.94, 0, 0, 48)
    container.BackgroundTransparency = 1
    container.Parent = ContentContainer

    local valLabel = Instance.new("TextLabel", container)
    valLabel.Size = UDim2.new(1, 0, 0, 18)
    valLabel.BackgroundTransparency = 1
    valLabel.Font = Enum.Font.SourceSansSemibold
    valLabel.Text = name .. ": " .. tostring(default)
    valLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    valLabel.TextSize = 12
    valLabel.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("TextButton", container)
    sliderBg.Size = UDim2.new(1, 0, 0, 8)
    sliderBg.Position = UDim2.new(0, 0, 0, 24)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    sliderBg.Text = ""
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderBar = Instance.new("Frame", sliderBg)
    sliderBar.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderBar.BackgroundColor3 = HubStroke.Color
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

    HubStroke:GetPropertyChangedSignal("Color"):Connect(function()
        sliderBar.BackgroundColor3 = HubStroke.Color
    end)

    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * pos
        if max - min <= 5 then
            val = math.round(val * 100) / 100
        else
            val = math.round(val)
        end
        sliderBar.Size = UDim2.new(pos, 0, 1, 0)
        valLabel.Text = name .. ": " .. tostring(val)
        pcall(callback, val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

----------------------------------------------------
-- CÁC PHÂN VÙNG HOẠT ĐỘNG HOÀN TOÀN MỚI
----------------------------------------------------

-- 1. TAB SIÊU NHÂN (SUPERHERO TAB)
local function loadSuperheroTab()
    clearContent()
    addParagraph("BIẾN HÌNH SIÊU ANH HÙNG")
    addToggle("Chế Độ Siêu Nhân", false, function(v)
        superheroActive = v
        local char = LocalPlayer.Character
        if v then
            if char then applySuperheroVFX(char) end
        else
            if char then removeSuperheroVFX(char) end
        end
    end)

    addParagraph("SIÊU NĂNG LỰC TẤN CÔNG")
    addToggle("Kích Hoạt Mắt Laser", false, function(v)
        laserActive = v
        if v then
            _G.DeltaHubConnections["LaserClick"] = UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.UserInputType == Enum.UserInputType.MouseButton1 and laserActive then
                    fireEyeLasers()
                end
            end)
        else
            if _G.DeltaHubConnections["LaserClick"] then 
                _G.DeltaHubConnections["LaserClick"]:Disconnect() 
            end
        end
    end)

    addToggle("Bắt Giữ Người Chơi (Click)", false, function(v)
        grabActive = v
        if v then
            _G.DeltaHubConnections["GrabClick"] = UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.UserInputType == Enum.UserInputType.MouseButton1 and grabActive then
                    if not grabbedPlayer then
                        startGrabbing()
                    else
                        stopGrabbing()
                    end
                end
            end)
        else
            stopGrabbing()
            if _G.DeltaHubConnections["GrabClick"] then 
                _G.DeltaHubConnections["GrabClick"]:Disconnect() 
            end
        end
    end)
    addButton("Thả nạn nhân rơi tự do", stopGrabbing)
end

-- 2. TỐI ƯU HÓA DI CHUYỂN + HÌNH ẢNH (UPGRADED VFX)
local flyActive = false
local flySpeed = 50
local flyConn = nil
local function toggleFly(Value)
    flyActive = Value
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    if flyActive then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "DarkFlyBV"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9); bv.Velocity = Vector3.new(0,0,0)
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "DarkFlyBG"; bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9); bg.CFrame = hrp.CFrame
        hum.PlatformStand = true
        
        -- VFX: Đuôi luồng gió khí động học khi bay nhanh
        local flyTrail = Instance.new("ParticleEmitter", hrp)
        flyTrail.Name = "FlyWindVFX"
        flyTrail.Texture = "rbxassetid://312301912" -- Ring mờ dần
        flyTrail.Color = ColorSequence.new(Color3.fromRGB(240, 240, 255))
        flyTrail.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.5),
            NumberSequenceKeypoint.new(1, 4)
        })
        flyTrail.Lifetime = NumberRange.new(0.4, 0.7)
        flyTrail.Speed = NumberRange.new(2, 5)
        flyTrail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        flyTrail.Rate = 22

        flyConn = RunService.RenderStepped:Connect(function()
            local currentHrp = char:FindFirstChild("HumanoidRootPart")
            local curBV = currentHrp and currentHrp:FindFirstChild("DarkFlyBV")
            local curBG = currentHrp and currentHrp:FindFirstChild("DarkFlyBG")
            if not curBV or not curBG then return end
            
            local moveDir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            if hum.MoveDirection.Magnitude > 0 then moveDir = moveDir + hum.MoveDirection end
            curBG.CFrame = Camera.CFrame
            curBV.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.new(0,0,0)
        end)
        _G.DeltaHubConnections["Fly"] = flyConn
    else
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if hrp then
            local bv = hrp:FindFirstChild("DarkFlyBV") if bv then bv:Destroy() end
            local bg = hrp:FindFirstChild("DarkFlyBG") if bg then bg:Destroy() end
            local trail = hrp:FindFirstChild("FlyWindVFX") if trail then trail:Destroy() end
        end
        if hum then hum.PlatformStand = false end
    end
end

local airWalkActive, airWalkConn, airPlatform
local function toggleAirWalk(Value)
    airWalkActive = Value
    if airWalkActive then
        -- THAY THẾ BẰNG KHIÊN NĂNG LƯỢNG XOAY TRÒN (UPGRADED HEXAGON SHIELD)
        airPlatform = Instance.new("Part", vfxFolder)
        airPlatform.Size = Vector3.new(12, 0.6, 12)
        airPlatform.Transparency = 0.5
        airPlatform.Color = HubStroke.Color
        airPlatform.Material = Enum.Material.ForceField
        airPlatform.Anchored = true
        
        local rotation = 0
        airWalkConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and airPlatform then
                rotation = rotation + 2
                airPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.4, hrp.Position.Z) * CFrame.Angles(0, math.rad(rotation), 0)
            end
        end)
        _G.DeltaHubConnections["AirWalk"] = airWalkConn
    else
        if airWalkConn then airWalkConn:Disconnect() airWalkConn = nil end
        if airPlatform then airPlatform:Destroy() airPlatform = nil end
    end
end

local waterWalkActive, waterWalkConn, waterPlatform
local function toggleWaterWalk(Value)
    waterWalkActive = Value
    if waterWalkActive then
        waterPlatform = Instance.new("Part", vfxFolder)
        waterPlatform.Size = Vector3.new(14, 0.5, 14)
        waterPlatform.Transparency = 0.8
        waterPlatform.Color = Color3.fromRGB(0, 255, 255)
        waterPlatform.Material = Enum.Material.Neon
        waterPlatform.Anchored = true
        
        -- Tạo hạt bọt nước bắn tung tóe tại chân
        local waterSplash = Instance.new("ParticleEmitter", waterPlatform)
        waterSplash.Texture = "rbxassetid://244222064"
        waterSplash.Color = ColorSequence.new(Color3.fromRGB(200, 255, 255))
        waterSplash.Size = NumberSequence.new(0.5, 1.5)
        waterSplash.Speed = NumberRange.new(5, 12)
        waterSplash.Lifetime = NumberRange.new(0.4, 0.8)
        waterSplash.Rate = 50
        waterSplash.SpreadAngle = Vector2.new(45, 45)
        waterSplash.VelocityInheritance = 0.5
        
        waterWalkConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and waterPlatform then
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {char, vfxFolder}
                local ray = Workspace:Raycast(hrp.Position, Vector3.new(0, -12, 0), rayParams)
                if ray and ray.Material == Enum.Material.Water then
                    waterPlatform.CFrame = CFrame.new(hrp.Position.X, ray.Position.Y + 0.35, hrp.Position.Z)
                else
                    waterPlatform.CFrame = CFrame.new(hrp.Position.X, -9999, hrp.Position.Z)
                end
            end
        end)
        _G.DeltaHubConnections["WaterWalk"] = waterWalkConn
    else
        if waterWalkConn then waterWalkConn:Disconnect() waterWalkConn = nil end
        if waterPlatform then waterPlatform:Destroy() waterPlatform = nil end
    end
end

-- 3. CÁC PHƯƠNG THỨC COMPONENT KHÁC GỐC
function getCharacterRigType()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        return hum.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
    end
    return "R15"
end

local function simulateRigMovement(targetRig)
    local char = LocalPlayer.Character
    local animate = char and char:FindFirst("Animate")
    if not animate then return end
    
    if targetRig == "R6" then
        pcall(function()
            animate.run.RunAnim.AnimationId = "rbxassetid://180426354"
            animate.walk.WalkAnim.AnimationId = "rbxassetid://180426354"
            animate.jump.JumpAnim.AnimationId = "rbxassetid://125750702"
            animate.fall.FallAnim.AnimationId = "rbxassetid://180436148"
            animate.idle.Animation1.AnimationId = "rbxassetid://180435571"
            animate.idle.Animation2.AnimationId = "rbxassetid://180435792"
        end)
    else
        pcall(function()
            animate.run.RunAnim.AnimationId = "rbxassetid://616163673"
            animate.walk.WalkAnim.AnimationId = "rbxassetid://616168032"
            animate.jump.JumpAnim.AnimationId = "rbxassetid://616157476"
            animate.fall.FallAnim.AnimationId = "rbxassetid://616157476"
            animate.idle.Animation1.AnimationId = "rbxassetid://507766666"
            animate.idle.Animation2.AnimationId = "rbxassetid://507766951"
        end)
    end
end

local function loadMainTab()
    clearContent()
    addParagraph("DI CHUYỂN CAO CẤP")
    addSlider("Tốc độ chạy", 16, 200, 16, function(v)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end)
    addSlider("Độ cao nhảy", 50, 300, 50, function(v)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = v; hum.UseJumpPower = true end
    end)
    addToggle("Chế độ Bay (VFX)", false, toggleFly)
    addSlider("Tốc độ Bay", 10, 200, 50, function(v) flySpeed = v end)
    addToggle("Đi Trên Không (VFX Hex)", false, toggleAirWalk)
    addToggle("Đi Trên Nước (VFX Splash)", false, toggleWaterWalk)
end

local function loadCombatTab()
    clearContent()
    addParagraph("CHIẾN ĐẤU CAO CẤP")
    addToggle("Aimbot khóa mục tiêu", false, function(v)
        if v then
            _G.DeltaHubConnections["Aimbot"] = RunService.RenderStepped:Connect(function()
                local target, minDist = nil, math.huge
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            if dist < minDist and dist < 250 then minDist = dist; target = player end
                        end
                    end
                end
                if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
            end)
        else
            if _G.DeltaHubConnections["Aimbot"] then _G.DeltaHubConnections["Aimbot"]:Disconnect() end
        end
    end)
end

local function loadToolsTab()
    clearContent()
    addParagraph("HỘP CÔNG CỤ")
    addButton("Nhận BTools", function()
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not backpack then return end
        for _, tName in ipairs({"Clone", "Delete", "Move"}) do
            local tool = Instance.new("Tool", backpack)
            tool.Name = "🛠️ " .. tName
            tool.RequiresHandle = false
            tool.Activated:Connect(function()
                local mouse = LocalPlayer:GetMouse()
                if mouse.Target and mouse.Target ~= workspace.Terrain then
                    if tName == "Delete" then mouse.Target:Destroy()
                    elseif tName == "Clone" then local c = mouse.Target:Clone() c.Parent = mouse.Target.Parent c.Position += Vector3.new(0,5,0) end
                end
            end)
        end
    end)
end

local function loadShaderTab()
    clearContent()
    addParagraph("TÙY CHỈNH SHADERS")
    addSlider("Độ mờ cảnh (Blur)", 0, 40, CustomBlur.Size, function(v) CustomBlur.Size = v end)
    addSlider("Độ tương phản (Contrast)", -1, 2, CustomColorCorr.Contrast, function(v) CustomColorCorr.Contrast = v end)
    addSlider("Độ rực màu (Saturation)", -1, 3, CustomColorCorr.Saturation, function(v) CustomColorCorr.Saturation = v end)
end

local function loadVisualsTab()
    clearContent()
    addParagraph("HỆ THỐNG ESP XUYÊN TƯỜNG")
    local highlights = {}
    addToggle("Vẽ viền ESP", false, function(v)
        if v then
            local function applyESP(player)
                if player ~= LocalPlayer and player.Character then
                    local hl = Instance.new("Highlight", player.Character)
                    hl.FillColor = HubStroke.Color
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlights[player] = hl
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end
        else
            for _, hl in pairs(highlights) do pcall(function() hl:Destroy() end) end
            highlights = {}
        end
    end)
end

local function loadCustomTab()
    clearContent()
    addParagraph("TỶ LỆ HUB (UI SCALE)")
    addSlider("Độ phóng to UI", 0.7, 1.3, currentScale, function(val)
        currentScale = val
        HubScale.Scale = val
    end)
end

----------------------------------------------------
-- KHỞI TẠO TẤT CẢ CÁC SIDEBAR TABS
----------------------------------------------------
local tabs = {
    { "🏠 Chính", loadMainTab },
    { "⚡ Siêu Nhân", loadSuperheroTab },
    { "🎯 Tấn Công", loadCombatTab },
    { "🛠️ Công Cụ", loadToolsTab },
    { "✨ Shaders", loadShaderTab },
    { "👁️ Quan Sát", loadVisualsTab },
    { "🎨 Giao Diện", loadCustomTab }
}

for _, tabData in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.9, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabBtn.Text = tabData[1]
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.TextSize = 12
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
    tabBtn.Parent = TabContainer
    
    local stroke = Instance.new("UIStroke", tabBtn)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(48, 48, 48)

    tabBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(TabContainer:GetChildren()) do
            if child:IsA("TextButton") then 
                child.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                child.TextColor3 = Color3.fromRGB(180, 180, 180)
                child:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(48, 48, 48)
            end
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        stroke.Color = HubStroke.Color
        pcall(tabData[2])
    end)
end

-- Mặc định tải trang đầu tiên
pcall(loadMainTab)
