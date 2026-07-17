--[[
    🎮 DELTA DARK ULTIMATE HUB - VERSION 10.0 (GOD EDITION) 🎮
    - Tự động duy trì hiệu ứng Siêu Nhân sau khi hồi sinh (Respawn Proof).
    - Mắt Laser liên tục (Hold to Shoot) + Hào quang rực lửa + Áo choàng động lực học.
    - Nhấc người chơi bằng lực hút trọng trường mượt mà (Physics Lerped Grab).
    - Tích hợp Widget thông tin cá nhân dành riêng cho An (7B) và Bộ đếm FPS/Ping thực tế.
    - Bổ sung Noclip, Infinite Jump, Chams/Box ESP, và các tính năng cốt lõi.
--]]

-- Ngắt kết nối cũ để tránh xung đột hệ thống
if _G.DeltaHubConnections then
    for name, connection in pairs(_G.DeltaHubConnections) do
        if connection then pcall(function() connection:Disconnect() end) end
    end
end
_G.DeltaHubConnections = {}

-- Load Core Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Dọn dẹp VFX cũ
local vfxFolder = Workspace:FindFirstChild("Delta_VFX_Storage")
if vfxFolder then pcall(function() vfxFolder:Destroy() end) end
vfxFolder = Instance.new("Folder", Workspace)
vfxFolder.Name = "Delta_VFX_Storage"

-- Biến toàn cục kiểm soát tính năng
local superheroActive = false
local laserActive = false
local grabActive = false
local noclipActive = false
local infJumpActive = false

local grabbedPlayer = nil
local grabConnection = nil
local grabLaserBeam = nil
local grabAttA, grabAttB = nil, nil

----------------------------------------------------
-- 📈 BỘ ĐẾM HIỆU NĂNG (FPS & PING ENGINE)
----------------------------------------------------
local fpsVal, pingVal = 60, 0
local fpsTable = {}
task.spawn(function()
    while task.wait(1) do
        pingVal = math.round(stats().Network.ServerToClientPing:GetValue() * 1000)
    end
end)
_G.DeltaHubConnections["FPS_Tracker"] = RunService.RenderStepped:Connect(function(dt)
    table.insert(fpsTable, dt)
    while #fpsTable > 0 and fpsTable[1] < os.clock() - 1 do
        table.remove(fpsTable, 1)
    end
    fpsVal = #fpsTable
end)

----------------------------------------------------
-- ⚡ ĐỊNH NGHĨA VFX SIÊU ANH HÙNG (CỰC KỲ ỔN ĐỊNH)
----------------------------------------------------
local function applySuperheroVFX(char)
    if not char then return end
    local torso = char:WaitForChild("Torso", 5) or char:WaitForChild("UpperTorso", 5)
    if not torso then return end

    -- Dọn dẹp VFX cũ bám trên nhân vật trước khi tạo mới
    for _, obj in ipairs(char:GetDescendants()) do
        if obj.Name == "HeroCape" or obj.Name == "CapeTop" or obj.Name == "CapeBottom" or obj.Name == "HeroAura" then
            pcall(function() obj:Destroy() end)
        end
    end

    -- Áo Choàng Năng Lượng (Chống rách, co giãn tự nhiên)
    local attTop = Instance.new("Attachment", torso)
    attTop.Name = "CapeTop"
    attTop.Position = Vector3.new(0, 0.8, 0.55)

    local attBottom = Instance.new("Attachment", torso)
    attBottom.Name = "CapeBottom"
    attBottom.Position = Vector3.new(0, -2.4, 1.5)

    local cape = Instance.new("Beam", torso)
    cape.Name = "HeroCape"
    cape.Attachment0 = attTop
    cape.Attachment1 = attBottom
    cape.Width0 = 1.3
    cape.Width1 = 2.5
    cape.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 0, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    cape.Texture = "rbxassetid://1084991219"
    cape.TextureSpeed = 2.5
    cape.LightEmission = 0.8
    cape.LightInfluence = 0

    -- Luồng bụi sao đỏ rực tỏa ra sau lưng
    local spark = Instance.new("ParticleEmitter", attTop)
    spark.Name = "HeroSparks"
    spark.Texture = "rbxassetid://244222064"
    spark.Color = ColorSequence.new(Color3.fromRGB(255, 30, 30))
    spark.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 0)})
    spark.Lifetime = NumberRange.new(0.8, 1.4)
    spark.Speed = NumberRange.new(3, 6)
    spark.SpreadAngle = Vector2.new(20, 20)
    spark.Acceleration = Vector3.new(0, -5, -3)

    -- Hào quang đỏ bao bọc cơ thể
    local aura = Instance.new("ParticleEmitter", torso)
    aura.Name = "HeroAura"
    aura.Texture = "rbxassetid://607157592"
    aura.Color = ColorSequence.new(Color3.fromRGB(255, 10, 50))
    aura.Size = NumberSequence.new(2, 4)
    aura.Lifetime = NumberRange.new(0.6, 1.2)
    aura.Rate = 18
    aura.Speed = NumberRange.new(0.5, 2)
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
            pcall(function() obj:Destroy() end)
        end
    end
end

-- Tự động kích hoạt lại khi nhân vật Respawn (Sửa lỗi phiên bản cũ)
_G.DeltaHubConnections["CharacterWatcher"] = LocalPlayer.CharacterAdded:Connect(function(newChar)
    if superheroActive then
        task.wait(1.5) -- Đợi nhân vật tải xong hoàn toàn
        applySuperheroVFX(newChar)
    end
end)

----------------------------------------------------
-- 🔥 MẮT LASER LIÊN TỤC & ĐIỀU KHIỂN TRỌNG LỰC
----------------------------------------------------
local shootingLaser = false

local function shootLaserStream()
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head or not shootingLaser then return end

    local mouse = LocalPlayer:GetMouse()
    local targetPos = mouse.Hit.p

    -- Điểm bắn từ 2 mắt
    local leftEye = head.CFrame * CFrame.new(-0.25, 0.15, -0.6)
    local rightEye = head.CFrame * CFrame.new(0.25, 0.15, -0.6)

    local function drawSingleLaser(startPos)
        local distance = (startPos.p - targetPos).Magnitude
        local laser = Instance.new("Part", vfxFolder)
        laser.Anchored = true
        laser.CanCollide = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(255, 0, 50)
        laser.Size = Vector3.new(0.18, 0.18, distance)
        laser.CFrame = CFrame.new(startPos.p, targetPos) * CFrame.new(0, 0, -distance/2)
        Debris:AddItem(laser, 0.08)
    end

    drawSingleLaser(leftEye)
    drawSingleLaser(rightEye)

    -- Hiệu ứng bùng nổ bụi lửa đỏ tại điểm chạm
    local impact = Instance.new("Part", vfxFolder)
    impact.Shape = Enum.PartType.Ball
    impact.Material = Enum.Material.Neon
    impact.Color = Color3.fromRGB(255, 50, 0)
    impact.Size = Vector3.new(2, 2, 2)
    impact.Position = targetPos
    impact.Anchored = true
    impact.CanCollide = false
    Debris:AddItem(impact, 0.15)

    -- Lực đẩy đẩy văng các vật thể xung quanh điểm chạm
    local exp = Instance.new("Explosion")
    exp.Position = targetPos
    exp.BlastRadius = 8
    exp.BlastPressure = 150000
    exp.Parent = vfxFolder
end

-- Telekinesis Grab (Nhấc và Giữ đối thủ mượt mà)
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
            -- Liên kết sấm sét đỏ
            grabAttA = Instance.new("Attachment", myHrp)
            grabAttA.Position = Vector3.new(0, 1.5, -1)
            grabAttB = Instance.new("Attachment", targetHrp)

            grabLaserBeam = Instance.new("Beam", vfxFolder)
            grabLaserBeam.Attachment0 = grabAttA
            grabLaserBeam.Attachment1 = grabAttB
            grabLaserBeam.Width0 = 0.4
            grabLaserBeam.Width1 = 0.4
            grabLaserBeam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 50))
            grabLaserBeam.Texture = "rbxassetid://1084991219"
            grabLaserBeam.TextureSpeed = 8
            grabLaserBeam.LightEmission = 1

            -- Cập nhật liên tục bằng vòng lặp mượt mà
            grabConnection = RunService.Heartbeat:Connect(function()
                if grabbedPlayer and grabbedPlayer:Parent() and myHrp:Parent() then
                    -- Lerp mượt mà giúp đối thủ không bị giật lag khi kéo đi
                    local targetGoal = myHrp.CFrame * CFrame.new(0, 4, -15)
                    targetHrp.CFrame = targetHrp.CFrame:Lerp(targetGoal, 0.25)
                    targetHrp.Velocity = Vector3.new(0, 0, 0)
                else
                    stopGrabbing()
                end
            end)
            _G.DeltaHubConnections["GrabSystem"] = grabConnection
        end
    end
end

function stopGrabbing()
    if grabConnection then grabConnection:Disconnect() grabConnection = nil end
    if grabLaserBeam then grabLaserBeam:Destroy() grabLaserBeam = nil end
    if grabAttA then grabAttA:Destroy() grabAttA = nil end
    if grabAttB then grabAttB:Destroy() grabAttB = nil end
    grabbedPlayer = nil
end

----------------------------------------------------
-- 💎 THIẾT KẾ GUI DELTA DARK V10.0 (GOD LEVEL)
----------------------------------------------------
local DarkGui = Instance.new("ScreenGui")
local coreGuiSuccess, coreGuiParent = pcall(function() return game:GetService("CoreGui") end)
DarkGui.Parent = coreGuiSuccess and coreGuiParent or LocalPlayer:FindFirstChildOfClass("PlayerGui")
DarkGui.Name = "DeltaUltimate_" .. tostring(math.random(1000, 9999))
DarkGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", DarkGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -195)
MainFrame.Size = UDim2.new(0, 580, 0, 390)
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

local HubStroke = Instance.new("UIStroke", MainFrame)
HubStroke.Thickness = 2
HubStroke.Color = Color3.fromRGB(230, 30, 30)

-- Header Bar
local HeaderBar = Instance.new("Frame", MainFrame)
HeaderBar.Size = UDim2.new(1, 0, 0, 45)
HeaderBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
HeaderBar.BackgroundTransparency = 0.5
Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 16)

-- Hệ thống Kéo thả UI mượt mà
local dragToggle, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 11)
Title.Size = UDim2.new(0, 350, 0, 22)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DELTA DARK ULTIMATE v10.0 [GOD EDITION]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 📈 CHỈ SỐ LÀM VIỆC (REAL-TIME HUD)
local PerfHud = Instance.new("TextLabel", MainFrame)
PerfHud.Size = UDim2.new(0, 150, 0, 20)
PerfHud.Position = UDim2.new(1, -230, 0, 12)
PerfHud.BackgroundTransparency = 1
PerfHud.Font = Enum.Font.Code
PerfHud.TextColor3 = Color3.fromRGB(0, 255, 150)
PerfHud.TextSize = 12
PerfHud.TextXAlignment = Enum.TextXAlignment.Right

task.spawn(function()
    while task.wait(0.5) do
        if PerfHud and PerfHud.Parent then
            PerfHud.Text = string.format("FPS: %d | PING: %dms", fpsVal, pingVal)
        end
    end
end)

-- Nút Thu Nhỏ / Đóng
local TopBtnContainer = Instance.new("Frame", MainFrame)
TopBtnContainer.Size = UDim2.new(0, 60, 0, 25)
TopBtnContainer.Position = UDim2.new(1, -75, 0, 10)
TopBtnContainer.BackgroundTransparency = 1

local LayoutTop = Instance.new("UIListLayout", TopBtnContainer)
LayoutTop.FillDirection = Enum.FillDirection.Horizontal
LayoutTop.HorizontalAlignment = Enum.HorizontalAlignment.Right
LayoutTop.Padding = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton", TopBtnContainer)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local ShrinkBtn = Instance.new("TextButton", TopBtnContainer)
ShrinkBtn.Size = UDim2.new(0, 22, 0, 22)
ShrinkBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ShrinkBtn.Text = "-"
ShrinkBtn.Font = Enum.Font.SourceSansBold
ShrinkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShrinkBtn.TextSize = 13
Instance.new("UICorner", ShrinkBtn).CornerRadius = UDim.new(1, 0)

-- Nút Tròn Thu Nhỏ Nổi
local FloatingBtn = Instance.new("TextButton", DarkGui)
FloatingBtn.Size = UDim2.new(0, 55, 0, 55)
FloatingBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingBtn.Text = "🔱"
FloatingBtn.Font = Enum.Font.SourceSansBold
FloatingBtn.TextColor3 = Color3.fromRGB(230, 30, 30)
FloatingBtn.TextSize = 26
FloatingBtn.Visible = false
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(1, 0)
local FloatStroke = Instance.new("UIStroke", FloatingBtn)
FloatStroke.Thickness = 2
FloatStroke.Color = Color3.fromRGB(230, 30, 30)

local floatDrag, floatStart, floatFramePos
FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDrag = true; floatStart = input.Position; floatFramePos = FloatingBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then floatDrag = false end end)
    end
end)
FloatingBtn.InputChanged:Connect(function(input)
    if floatDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - floatStart
        FloatingBtn.Position = UDim2.new(floatFramePos.X.Scale, floatFramePos.X.Offset + delta.X, floatFramePos.Y.Scale, floatFramePos.Y.Offset + delta.Y)
    end
end)

ShrinkBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true, function()
        MainFrame.Visible = false
        FloatingBtn.Visible = true
    end)
end)

FloatingBtn.MouseButton1Click:Connect(function()
    FloatingBtn.Visible = false
    MainFrame.Visible = true
    MainFrame:TweenSize(UDim2.new(0, 580, 0, 390), "Out", "Quad", 0.3, true)
end)

CloseBtn.MouseButton1Click:Connect(function()
    stopGrabbing()
    removeSuperheroVFX(LocalPlayer.Character)
    pcall(function() vfxFolder:Destroy() end)
    pcall(function() if _G.DeltaHubConnections then for _, c in pairs(_G.DeltaHubConnections) do c:Disconnect() end end end)
    DarkGui:Destroy()
end)

----------------------------------------------------
-- 👤 WIDGET THÔNG TIN TÀI KHOẢN ĐỘC QUYỀN (AN - 7B)
----------------------------------------------------
local SidebarContainer = Instance.new("Frame", MainFrame)
SidebarContainer.Size = UDim2.new(0, 140, 1, -65)
SidebarContainer.Position = UDim2.new(0, 12, 0, 53)
SidebarContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", SidebarContainer).CornerRadius = UDim.new(0, 12)

local ProfileCard = Instance.new("Frame", SidebarContainer)
ProfileCard.Size = UDim2.new(1, 0, 0, 110)
ProfileCard.BackgroundTransparency = 1

local AvatarImg = Instance.new("ImageLabel", ProfileCard)
AvatarImg.Size = UDim2.new(0, 50, 0, 50)
AvatarImg.Position = UDim2.new(0.5, -25, 0, 10)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

-- Lấy ảnh Avatar thật của người chơi
pcall(function()
    local userId = LocalPlayer.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size100x100
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    if isReady then AvatarImg.Image = content end
end)

local UserWelcome = Instance.new("TextLabel", ProfileCard)
UserWelcome.Size = UDim2.new(1, 0, 0, 20)
UserWelcome.Position = UDim2.new(0, 0, 0, 65)
UserWelcome.BackgroundTransparency = 1
UserWelcome.Font = Enum.Font.SourceSansBold
UserWelcome.Text = "Chào An!"
UserWelcome.TextColor3 = Color3.fromRGB(255, 215, 0)
UserWelcome.TextSize = 13

local ClassTag = Instance.new("TextLabel", ProfileCard)
ClassTag.Size = UDim2.new(1, 0, 0, 15)
ClassTag.Position = UDim2.new(0, 0, 0, 82)
ClassTag.BackgroundTransparency = 1
ClassTag.Font = Enum.Font.SourceSansItalic
ClassTag.Text = "Lớp 7B - Quang Hà 2"
ClassTag.TextColor3 = Color3.fromRGB(180, 180, 180)
ClassTag.TextSize = 11

-- Các Tabs di chuyển xuống dưới Profile Card
local TabContainer = Instance.new("ScrollingFrame", SidebarContainer)
TabContainer.Size = UDim2.new(1, 0, 1, -115)
TabContainer.Position = UDim2.new(0, 0, 0, 115)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(0, 0, 1.5, 0)
TabContainer.ScrollBarThickness = 0

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 6)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content Box bên phải
local ContentContainer = Instance.new("ScrollingFrame", MainFrame)
ContentContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
ContentContainer.Position = UDim2.new(0, 162, 0, 53)
ContentContainer.Size = UDim2.new(1, -174, 1, -65)
ContentContainer.CanvasSize = UDim2.new(0, 0, 1.6, 0)
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 12)

local ContentLayout = Instance.new("UIListLayout", ContentContainer)
ContentLayout.Padding = UDim.new(0, 12)
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
    local frame = Instance.new("Frame", ContentContainer)
    frame.Size = UDim2.new(0.94, 0, 0, 24)
    frame.BackgroundTransparency = 1
    local p = Instance.new("TextLabel", frame)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Font = Enum.Font.SourceSansBold
    p.Text = "⚡  " .. text:upper()
    p.TextColor3 = HubStroke.Color
    p.TextSize = 13
    p.TextXAlignment = Enum.TextXAlignment.Left
end

local function addButton(name, callback)
    local btn = Instance.new("TextButton", ContentContainer)
    btn.Size = UDim2.new(0.94, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1; stroke.Color = Color3.fromRGB(45, 45, 45)
    
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end)
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

local function addToggle(name, default, callback)
    local active = default
    local btn = Instance.new("TextButton", ContentContainer)
    btn.Size = UDim2.new(0.94, 0, 0, 36)
    btn.BackgroundColor3 = active and HubStroke.Color or Color3.fromRGB(30, 30, 30)
    btn.Text = name .. (active and " [BẬT]" or " [TẮT]")
    btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1; stroke.Color = active and HubStroke.Color or Color3.fromRGB(45, 45, 45)

    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and HubStroke.Color or Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        stroke.Color = active and HubStroke.Color or Color3.fromRGB(45, 45, 45)
        btn.Text = name .. (active and " [BẬT]" or " [TẮT]")
        pcall(callback, active)
    end)
end

local function addSlider(name, min, max, default, callback)
    local container = Instance.new("Frame", ContentContainer)
    container.Size = UDim2.new(0.94, 0, 0, 48)
    container.BackgroundTransparency = 1

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

    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * pos
        val = math.round(val)
        sliderBar.Size = UDim2.new(pos, 0, 1, 0)
        valLabel.Text = name .. ": " .. tostring(val)
        pcall(callback, val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; updateSlider(input)
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
-- CÁC TAB CHỨC NĂNG CHÍNH ĐÃ ĐƯỢC TỐI ƯU HÓA
----------------------------------------------------

-- 1. TAB SIÊU NHÂN (CựC KỲ HOÀN THIỆN)
local function loadSuperheroTab()
    clearContent()
    addParagraph("CHẾ ĐỘ SIÊU ANH HÙNG (RESPAWN PROOF)")
    addToggle("Kích Hoạt Siêu Nhân (Áo choàng + Aura)", superheroActive, function(v)
        superheroActive = v
        local char = LocalPlayer.Character
        if v then
            if char then applySuperheroVFX(char) end
        else
            if char then removeSuperheroVFX(char) end
        end
    end)

    addParagraph("SIÊU NĂNG LỰC TẤN CÔNG")
    addToggle("Mắt Bắn Laser (Nhấn giữ chuột trái)", laserActive, function(v)
        laserActive = v
        if v then
            -- Bắt sự kiện Nhấn và Giữ chuột trái để phun laser liên tục không giới hạn
            _G.DeltaHubConnections["LaserMouseDown"] = UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    shootingLaser = true
                    task.spawn(function()
                        while shootingLaser and laserActive do
                            shootLaserStream()
                            task.wait(0.05) -- Tốc độ nháy tia hạt cực cao
                        end
                    end)
                end
            end)
            _G.DeltaHubConnections["LaserMouseUp"] = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    shootingLaser = false
                end
            end)
        else
            shootingLaser = false
            if _G.DeltaHubConnections["LaserMouseDown"] then _G.DeltaHubConnections["LaserMouseDown"]:Disconnect() end
            if _G.DeltaHubConnections["LaserMouseUp"] then _G.DeltaHubConnections["LaserMouseUp"]:Disconnect() end
        end
    end)

    addToggle("Nhấc Người Chơi (Click chọn mục tiêu)", grabActive, function(v)
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
            if _G.DeltaHubConnections["GrabClick"] then _G.DeltaHubConnections["GrabClick"]:Disconnect() end
        end
    end)
    addButton("Thả người chơi đang nhấc bổng", stopGrabbing)
end

-- 2. TAB DI CHUYỂN CAO CẤP (Bao gồm Noclip & Inf Jump)
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
        
        -- Hiệu ứng vòng tròn gió khí động học khi bay
        local flyTrail = Instance.new("ParticleEmitter", hrp)
        flyTrail.Name = "FlyWindVFX"
        flyTrail.Texture = "rbxassetid://312301912"
        flyTrail.Color = ColorSequence.new(Color3.fromRGB(240, 240, 255))
        flyTrail.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 4)})
        flyTrail.Lifetime = NumberRange.new(0.4, 0.7)
        flyTrail.Speed = NumberRange.new(2, 5)
        flyTrail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1)})
        flyTrail.Rate = 25

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

-- NOCLIP (Đi xuyên tường cực mượt)
task.spawn(function()
    _G.DeltaHubConnections["NoclipLoop"] = RunService.Stepped:Connect(function()
        if noclipActive and LocalPlayer.Character then
            for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
                if child:IsA("BasePart") then child.CanCollide = false end
            end
        end
    end)
end)

-- INFINITE JUMP (Nhảy vô hạn trên không)
_G.DeltaHubConnections["InfJump"] = UserInputService.JumpRequest:Connect(function()
    if infJumpActive and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local function loadMovementTab()
    clearContent()
    addParagraph("TẬP TRUNG TỐC ĐỘ & ĐỘ CAO")
    addSlider("Tốc độ chạy", 16, 250, 16, function(v)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end)
    addSlider("Lực nhảy", 50, 350, 50, function(v)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = v; hum.UseJumpPower = true end
    end)

    addParagraph("HACK DI CHUYỂN CAO CẤP")
    addToggle("Noclip (Xuyên tường)", noclipActive, function(v) noclipActive = v end)
    addToggle("Infinite Jump (Nhảy vô tận)", infJumpActive, function(v) infJumpActive = v end)
    addToggle("Chế độ Bay tự do (VFX)", flyActive, toggleFly)
    addSlider("Tốc độ Bay", 10, 200, flySpeed, function(v) flySpeed = v end)
end

-- 3. TAB QUAN SÁT (ESP TOÀN DIỆN CHỐNG LAG)
local espHighlights = {}
local espConnections = {}

local function applyESP(player)
    if player ~= LocalPlayer and player.Character then
        local hl = player.Character:FindFirstChild("DeltaESP")
        if not hl then
            hl = Instance.new("Highlight", player.Character)
            hl.Name = "DeltaESP"
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            espHighlights[player] = hl
        end
    end
end

local function loadVisualsTab()
    clearContent()
    addParagraph("HỆ THỐNG ĐỊNH VỊ (ESP)")
    addToggle("Bật vẽ khung viền (Chams)", #espConnections > 0, function(v)
        if v then
            for _, player in ipairs(Players:GetPlayers()) do applyESP(player) end
            espConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    task.wait(1)
                    if #espConnections > 0 then applyESP(player) end
                end)
            end)
        else
            if espConnections["PlayerAdded"] then espConnections["PlayerAdded"]:Disconnect() end
            for player, hl in pairs(espHighlights) do
                pcall(function() hl:Destroy() end)
            end
            espHighlights = {}
            espConnections = {}
        end
    end)
end

-- 4. TAB TRẬN ĐẤU (AIMBOT & FLING)
local function loadCombatTab()
    clearContent()
    addParagraph("HỆ THỐNG CHIẾN ĐẤU")
    addToggle("Aimbot khóa mục tiêu", false, function(v)
        if v then
            _G.DeltaHubConnections["CombatAimbot"] = RunService.RenderStepped:Connect(function()
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
            if _G.DeltaHubConnections["CombatAimbot"] then _G.DeltaHubConnections["CombatAimbot"]:Disconnect() end
        end
    end)
end

----------------------------------------------------
-- THIẾT LẬP MENU TABS CHÍNH
----------------------------------------------------
local tabs = {
    { "⚡ Siêu Nhân", loadSuperheroTab },
    { "🏃 Di Chuyển", loadMovementTab },
    { "🎯 Chiến Đấu", loadCombatTab },
    { "👁️ Quan Sát", loadVisualsTab }
}

for _, tabData in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton", TabContainer)
    tabBtn.Size = UDim2.new(0.9, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabBtn.Text = tabData[1]
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.TextSize = 12
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", tabBtn)
    stroke.Thickness = 1; stroke.Color = Color3.fromRGB(48, 48, 48)

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

-- Tải Tab Mặc Định
pcall(loadSuperheroTab)

