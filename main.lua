--[[
    🌸 DELTA PREMIUM CUTE HUB - ULTIMATE OMEGA V5.1 🌸
    - Thiết kế: Sweet Pink Pastel (Siêu dễ thương, bo góc mềm mại)
    - SỬA LỖI: Hiển thị đầy đủ các nút tính năng khi chuyển đổi giữa các Tab!
--]]

-- Reset kết nối cũ để tránh lag game
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
local ContextActionService = game:GetService("ContextActionService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Tạo folder chứa đồ xây dựng
local buildFolder = Workspace:FindFirstChild("Delta_Premium_Builds")
if not buildFolder then buildFolder = Instance.new("Folder", Workspace); buildFolder.Name = "Delta_Premium_Builds" end

----------------------------------------------------
-- ÂM THANH & HIỆU ỨNG HỒNG CUTE
----------------------------------------------------
local function playCuteSound(soundId)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. tostring(soundId)
        sound.Volume = 1.5
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end)
end

local function spawnHeartVFX(position)
    pcall(function()
        local att = Instance.new("Attachment", Workspace.Terrain)
        att.WorldPosition = position
        local pe = Instance.new("ParticleEmitter", att)
        pe.Texture = "rbxassetid://15444146746" -- Heart decal cute
        pe.Color = ColorSequence.new(Color3.fromRGB(255, 182, 193), Color3.fromRGB(255, 105, 180))
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.2), NumberSequenceKeypoint.new(1, 0)})
        pe.Lifetime = NumberRange.new(0.5, 1)
        pe.Rate = 40
        pe.Speed = NumberRange.new(5, 10)
        task.delay(0.8, function() pe.Enabled = false; task.wait(1); att:Destroy() end)
    end)
end

----------------------------------------------------
-- 🎀 MÀN HÌNH LOADING SIÊU CUTE 🎀
----------------------------------------------------
local CuteGui = Instance.new("ScreenGui")
local success, parent = pcall(function() return game:GetService("CoreGui") end)
CuteGui.Parent = success and parent or LocalPlayer:FindFirstChildOfClass("PlayerGui")
CuteGui.Name = "DeltaCuteHub_" .. tostring(math.random(1000, 9999))
CuteGui.ResetOnSpawn = false

local LoadingFrame = Instance.new("Frame", CuteGui)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245) -- Lavender Blush
LoadingFrame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local LoadingHeart = Instance.new("TextLabel", LoadingFrame)
LoadingHeart.Size = UDim2.new(0, 100, 0, 100)
LoadingHeart.Position = UDim2.new(0.5, -50, 0.4, -50)
LoadingHeart.BackgroundTransparency = 1
LoadingHeart.Font = Enum.Font.FredokaOne
LoadingHeart.Text = "🌸"
LoadingHeart.TextSize = 80
LoadingHeart.TextColor3 = Color3.fromRGB(255, 105, 180)

local LoadingText = Instance.new("TextLabel", LoadingFrame)
LoadingText.Size = UDim2.new(0, 300, 0, 40)
LoadingText.Position = UDim2.new(0.5, -150, 0.55, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.Font = Enum.Font.FredokaOne
LoadingText.Text = "Đang tải Delta Cute Hub v5..."
LoadingText.TextColor3 = Color3.fromRGB(255, 105, 180)
LoadingText.TextSize = 20

local ProgressBarBg = Instance.new("Frame", LoadingFrame)
ProgressBarBg.Size = UDim2.new(0, 250, 0, 10)
ProgressBarBg.Position = UDim2.new(0.5, -125, 0.65, 0)
ProgressBarBg.BackgroundColor3 = Color3.fromRGB(255, 218, 224)
local BarCorner = Instance.new("UICorner", ProgressBarBg)

local ProgressBar = Instance.new("Frame", ProgressBarBg)
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
local ProgressCorner = Instance.new("UICorner", ProgressBar)

-- Xoay trái tim lấp lánh khi load
task.spawn(function()
    while LoadingFrame.Parent do
        LoadingHeart.Rotation = LoadingHeart.Rotation + 4
        task.wait(0.01)
    end
end)

-- Hiệu ứng chạy thanh Loading
playCuteSound(6514115160)
TweenService:Create(ProgressBar, TweenInfo.new(1.5, Enum.EasingStyle.OutQuad), {Size = UDim2.new(1, 0, 1, 0)}):Play()
task.wait(1.7)
TweenService:Create(LoadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
for _, v in ipairs(LoadingFrame:GetChildren()) do
    if v:IsA("TextLabel") or v:IsA("Frame") then
        TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    end
end
task.wait(0.5)
LoadingFrame:Destroy()

----------------------------------------------------
-- 🎀 THIẾT KẾ GIAO DIỆN CHÍNH CUTE 🎀
----------------------------------------------------
local MainFrame = Instance.new("Frame", CuteGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 245, 247) -- Hồng sữa cực ngọt
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 20)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 3
Stroke.Color = Color3.fromRGB(255, 192, 203)

-- Tiêu đề chính dễ thương
local Title = Instance.new("TextLabel", MainFrame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 12)
Title.Size = UDim2.new(1, -100, 0, 30)
Title.Font = Enum.Font.FredokaOne
Title.Text = "🧁 DELTA PREMIUM CUTE HUB 🧁"
Title.TextColor3 = Color3.fromRGB(255, 105, 180)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Container chứa các Tab bên trái
local TabContainer = Instance.new("ScrollingFrame", MainFrame)
TabContainer.BackgroundColor3 = Color3.fromRGB(255, 228, 233)
TabContainer.Position = UDim2.new(0, 15, 0, 55)
TabContainer.Size = UDim2.new(0, 130, 1, -70)
TabContainer.CanvasSize = UDim2.new(0, 0, 1.2, 0)
TabContainer.ScrollBarThickness = 0
Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 12)

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 6)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Container chứa các nút chức năng bên phải
local ContentContainer = Instance.new("ScrollingFrame", MainFrame)
ContentContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ContentContainer.Position = UDim2.new(0, 155, 0, 55)
ContentContainer.Size = UDim2.new(1, -170, 1, -70)
ContentContainer.CanvasSize = UDim2.new(0, 0, 1.5, 0) -- Hỗ trợ cuộn tự động
ContentContainer.ScrollBarThickness = 4
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 182, 193)
Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 12)

local ContentLayout = Instance.new("UIListLayout", ContentContainer)
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Tự động điều chỉnh kích thước cuộn của ContentContainer
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)

-- Nút đóng Hub
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
CloseBtn.Text = "✖"
CloseBtn.Font = Enum.Font.FredokaOne
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() CuteGui:Destroy() end)

----------------------------------------------------
-- BỘ DỰNG UI CUTE ENGINE (Đã sửa lỗi vẽ nút)
----------------------------------------------------
local function clearContent()
    for _, child in ipairs(ContentContainer:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
end

local function addParagraph(text)
    local p = Instance.new("TextLabel")
    p.Size = UDim2.new(0.92, 0, 0, 32)
    p.BackgroundTransparency = 1
    p.Font = Enum.Font.FredokaOne
    p.Text = "🧸 " .. text
    p.TextColor3 = Color3.fromRGB(255, 105, 180)
    p.TextSize = 13
    p.TextXAlignment = Enum.TextXAlignment.Left
    p.Parent = ContentContainer
end

local function addButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
    btn.Text = "⭐ " .. name
    btn.Font = Enum.Font.FredokaOne
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.Parent = ContentContainer
    
    btn.MouseButton1Click:Connect(function()
        playCuteSound(1222212437)
        pcall(callback)
    end)
end

local function addToggle(name, default, callback)
    local active = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 38)
    btn.BackgroundColor3 = active and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(245, 240, 242)
    btn.Text = (active and "💝 " or "🤍 ") .. name
    btn.Font = Enum.Font.FredokaOne
    btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.Parent = ContentContainer
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        playCuteSound(1222220043)
        btn.BackgroundColor3 = active and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(245, 240, 242)
        btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        btn.Text = (active and "💝 " or "🤍 ") .. name
        pcall(callback, active)
    end)
end

local function addSlider(name, min, max, default, callback)
    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.92, 0, 0, 20)
    valLabel.BackgroundTransparency = 1
    valLabel.Font = Enum.Font.FredokaOne
    valLabel.Text = name .. ": " .. tostring(default)
    valLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    valLabel.TextSize = 12
    valLabel.TextXAlignment = Enum.TextXAlignment.Left
    valLabel.Parent = ContentContainer

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(0.92, 0, 0, 12)
    sliderBg.BackgroundColor3 = Color3.fromRGB(255, 218, 224)
    sliderBg.Text = ""
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    sliderBg.Parent = ContentContainer

    local sliderBar = Instance.new("Frame", sliderBg)
    sliderBar.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.round(min + (max - min) * pos)
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
-- LOGIC TÍNH NĂNG ĐÃ ĐƯỢC TỐI ƯU HÓA
----------------------------------------------------

-- 1. SIÊU NHÂN BẮN LAZER FLING (Đã tối ưu Fling cực mạnh)
local laserHeroActive = false
local laserConn = nil
local heroVFX = nil

local function toggleLaserHero(Value)
    laserHeroActive = Value
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if laserHeroActive then
        if not hrp then return end
        playCuteSound(6514115160)
        spawnHeartVFX(hrp.Position)
        
        -- Cánh/Vòng tròn thiên thần phát sáng cute
        heroVFX = Instance.new("Part", char)
        heroVFX.Size = Vector3.new(3, 0.2, 3)
        heroVFX.Shape = Enum.PartType.Cylinder
        heroVFX.Orientation = Vector3.new(0, 0, 90)
        heroVFX.Color = Color3.fromRGB(255, 105, 180)
        heroVFX.Material = Enum.Material.Neon
        heroVFX.CanCollide = false
        
        local weld = Instance.new("Weld", heroVFX)
        weld.Part0 = hrp
        weld.Part1 = heroVFX
        weld.C0 = CFrame.new(0, 4, 0)
        
        -- Click chuột/Chạm màn hình để Fling mục tiêu dính đạn
        laserConn = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local mousePos = UserInputService:GetMouseLocation()
                local unitRay = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
                
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.FilterDescendantsInstances = {char}
                
                local rayResult = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
                if rayResult and rayResult.Instance then
                    local targetChar = rayResult.Instance.Parent
                    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                    
                    -- Vẽ tia Laser Neon hồng
                    local beam = Instance.new("Part", Workspace)
                    beam.CanCollide = false
                    beam.Anchored = true
                    beam.Color = Color3.fromRGB(255, 20, 147)
                    beam.Material = Enum.Material.Neon
                    
                    local origin = hrp.Position + Vector3.new(0, 1.5, 0)
                    local target = rayResult.Position
                    local distance = (target - origin).Magnitude
                    beam.Size = Vector3.new(0.5, 0.5, distance)
                    beam.CFrame = CFrame.new(origin, target) * CFrame.new(0, 0, -distance/2)
                    
                    playCuteSound(5561118335)
                    TweenService:Create(beam, TweenInfo.new(0.2), {Transparency = 1, Size = Vector3.new(0, 0, distance)}):Play()
                    task.delay(0.2, function() beam:Destroy() end)
                    
                    -- CƠ CHẾ SPIN FLING 100% HOẠT ĐỘNG
                    if targetHrp and targetChar ~= char then
                        spawnHeartVFX(targetHrp.Position)
                        
                        task.spawn(function()
                            local oldCFrame = hrp.CFrame
                            local oldVelocity = hrp.Velocity
                            
                            -- Tạo lực xoay cực nhanh trên thân người mình
                            local bAV = Instance.new("BodyAngularVelocity", hrp)
                            bAV.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                            bAV.AngularVelocity = Vector3.new(0, 99999, 0)
                            
                            -- Dịch chuyển siêu nhanh đến đối thủ và hất văng
                            for i = 1, 8 do
                                if targetHrp and hrp then
                                    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0.5, 0)
                                    task.wait(0.01)
                                end
                            end
                            
                            bAV:Destroy()
                            hrp.CFrame = oldCFrame
                            hrp.Velocity = oldVelocity
                        end)
                    end
                end
            end
        end)
        _G.DeltaHubConnections["LaserHero"] = laserConn
    else
        if laserConn then laserConn:Disconnect() laserConn = nil end
        if heroVFX then heroVFX:Destroy() heroVFX = nil end
    end
end

-- 2. ĐI TRÊN KHÔNG & ĐI TRÊN NƯỚC
local airWalkActive = false
local airPlatform = nil
local airWalkConn = nil
local function toggleAirWalk(Value)
    airWalkActive = Value
    if airWalkActive then
        airPlatform = Instance.new("Part", buildFolder)
        airPlatform.Size = Vector3.new(8, 1, 8)
        airPlatform.Transparency = 0.6
        airPlatform.Color = Color3.fromRGB(255, 105, 180)
        airPlatform.Material = Enum.Material.Neon
        airPlatform.Anchored = true
        
        airWalkConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and airPlatform then
                airPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
            end
        end)
        _G.DeltaHubConnections["AirWalk"] = airWalkConn
    else
        if airWalkConn then airWalkConn:Disconnect() airWalkConn = nil end
        if airPlatform then airPlatform:Destroy() airPlatform = nil end
    end
end

local waterWalkActive = false
local waterPlatform = nil
local waterWalkConn = nil
local function toggleWaterWalk(Value)
    waterWalkActive = Value
    if waterWalkActive then
        waterPlatform = Instance.new("Part", buildFolder)
        waterPlatform.Size = Vector3.new(12, 1, 12)
        waterPlatform.Transparency = 1
        waterPlatform.Anchored = true
        
        waterWalkConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and waterPlatform then
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {char, buildFolder}
                local ray = Workspace:Raycast(hrp.Position, Vector3.new(0, -10, 0), rayParams)
                if ray and ray.Material == Enum.Material.Water then
                    waterPlatform.CFrame = CFrame.new(hrp.Position.X, ray.Position.Y + 0.4, hrp.Position.Z)
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

-- 3. CÁC BIẾN CHẠY & FLY CŨ TRẢ LẠI
local flyActive = false
local flySpeed = 50
local flyConn = nil
local mobileUp, mobileDown = false, false

local function handleFlyAction(actionName, state)
    if state == Enum.UserInputState.Begin then
        if actionName == "FlyUp" then mobileUp = true elseif actionName == "FlyDown" then mobileDown = true end
    elseif state == Enum.UserInputState.End then
        if actionName == "FlyUp" then mobileUp = false elseif actionName == "FlyDown" then mobileDown = false end
    end
end

local function toggleFly(Value)
    flyActive = Value
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    if flyActive then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "CuteFlyBV"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9); bv.Velocity = Vector3.new(0,0,0)
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "CuteFlyBG"; bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9); bg.CFrame = hrp.CFrame
        hum.PlatformStand = true
        
        if UserInputService.TouchEnabled then
            ContextActionService:BindAction("FlyUp", handleFlyAction, true, Enum.KeyCode.ButtonR2)
            ContextActionService:BindAction("FlyDown", handleFlyAction, true, Enum.KeyCode.ButtonL2)
            ContextActionService:SetTitle("FlyUp", "▲ Bay Lên")
            ContextActionService:SetTitle("FlyDown", "▼ Hạ Xuống")
        end
        
        flyConn = RunService.RenderStepped:Connect(function()
            local currentHrp = char:FindFirstChild("HumanoidRootPart")
            local curBV = currentHrp and currentHrp:FindFirstChild("CuteFlyBV")
            local curBG = currentHrp and currentHrp:FindFirstChild("CuteFlyBG")
            if not curBV or not curBG then return end
            
            local moveDir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or mobileUp then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or mobileDown then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            if hum.MoveDirection.Magnitude > 0 then moveDir = moveDir + hum.MoveDirection end
            curBG.CFrame = Camera.CFrame
            curBV.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.new(0,0,0)
        end)
        _G.DeltaHubConnections["Fly"] = flyConn
    else
        if flyConn then flyConn:Disconnect() flyConn = nil end
        pcall(function() ContextActionService:UnbindAction("FlyUp") ContextActionService:UnbindAction("FlyDown") end)
        if hrp then
            local bv = hrp:FindFirstChild("CuteFlyBV") if bv then bv:Destroy() end
            local bg = hrp:FindFirstChild("CuteFlyBG") if bg then bg:Destroy() end
        end
        if hum then hum.PlatformStand = false end
    end
end

----------------------------------------------------
-- THIẾT LẬP CÁC TABS CHỨC NĂNG CỤ THỂ
----------------------------------------------------

local function loadMainTab()
    clearContent()
    addParagraph("TỐC ĐỘ & BAY LƯỢN")
    addSlider("Tốc độ chạy (WalkSpeed)", 16, 250, 16, function(v)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end)
    addToggle("Bay Lượn (Fly)", false, toggleFly)
    addSlider("Tốc độ bay", 10, 300, 50, function(v) flySpeed = v end)
    addToggle("Đi Xuyên Tường (Noclip)", false, function(v)
        if v then
            _G.DeltaHubConnections["Noclip"] = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
        else
            if _G.DeltaHubConnections["Noclip"] then _G.DeltaHubConnections["Noclip"]:Disconnect() end
        end
    end)
    addToggle("Nhảy Vô Hạn (Inf Jump)", false, function(v)
        if v then
            _G.DeltaHubConnections["InfJump"] = UserInputService.JumpRequest:Connect(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            if _G.DeltaHubConnections["InfJump"] then _G.DeltaHubConnections["InfJump"]:Disconnect() end
        end
    end)
end

local function loadCutePowersTab()
    clearContent()
    addParagraph("SỨC MẠNH SIÊU NHÂN CUTE")
    addToggle("Đi Trên Không (Air Walk)", false, toggleAirWalk)
    addToggle("Đi Trên Nước (Water Walk)", false, toggleWaterWalk)
    addToggle("Siêu Nhân Lazer Fling", false, toggleLaserHero)
end

local function loadCombatTab()
    clearContent()
    addParagraph("TỰ ĐỘNG NGẮM BẮN (AIMBOT)")
    local aimbotActive = false
    local aimbotPart = "Head"
    addToggle("Bật Aimbot", false, function(v)
        aimbotActive = v
        if aimbotActive then
            _G.DeltaHubConnections["Aimbot"] = RunService.RenderStepped:Connect(function()
                local target, minDist = nil, math.huge
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimbotPart) then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character[aimbotPart].Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            if dist < minDist and dist < 200 then minDist = dist; target = player end
                        end
                    end
                end
                if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[aimbotPart].Position) end
            end)
        else
            if _G.DeltaHubConnections["Aimbot"] then _G.DeltaHubConnections["Aimbot"]:Disconnect() end
        end
    end)
end

local function loadVisualsTab()
    clearContent()
    addParagraph("HIỂN THỊ HÌNH ẢNH")
    local highlights = {}
    addToggle("Vẽ Khung Phát Sáng (ESP)", false, function(v)
        if v then
            local function applyESP(player)
                if player ~= LocalPlayer then
                    player.CharacterAdded:Connect(function(char)
                        local hl = Instance.new("Highlight", char)
                        hl.FillColor = Color3.fromRGB(255, 105, 180)
                        highlights[player] = hl
                    end)
                    if player.Character then
                        local hl = Instance.new("Highlight", player.Character)
                        hl.FillColor = Color3.fromRGB(255, 105, 180)
                        highlights[player] = hl
                    end
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end
            _G.DeltaHubConnections["ESPAdded"] = Players.PlayerAdded:Connect(applyESP)
        else
            if _G.DeltaHubConnections["ESPAdded"] then _G.DeltaHubConnections["ESPAdded"]:Disconnect() end
            for _, hl in pairs(highlights) do pcall(function() hl:Destroy() end) end
            highlights = {}
        end
    end)
    
    addToggle("Điện Ảnh Shaders (Cinematic)", false, function(v)
        if v then
            Lighting.Brightness = 2.4
            Lighting.ClockTime = 12
        else
            Lighting.Brightness = 2
        end
    end)
end

local function loadFunTab()
    clearContent()
    addParagraph("TÍNH NĂNG VUI NHỘN")
    addToggle("Robot Morph", false, function(v)
        if v then
            _G.DeltaHubConnections["Robot"] = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, m in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if m:IsA("Motor6D") and m.Name ~= "Neck" then
                            m.Transform = CFrame.Angles(math.sin(tick()*12)*0.3, 0, 0)
                        end
                    end
                end
            end)
        else
            if _G.DeltaHubConnections["Robot"] then _G.DeltaHubConnections["Robot"]:Disconnect() end
        end
    end)
    addToggle("Body Glitch", false, function(v)
        if v then
            _G.DeltaHubConnections["Glitch"] = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, m in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if m:IsA("Motor6D") then
                            m.Transform = CFrame.new(math.random(-5,5)/50, 0, 0) * CFrame.Angles(math.random(-15,15)/10, 0, 0)
                        end
                    end
                end
            end)
        else
            if _G.DeltaHubConnections["Glitch"] then _G.DeltaHubConnections["Glitch"]:Disconnect() end
        end
    end)
end

----------------------------------------------------
-- TẠO CÁC NÚT TAB CHUYỂN TRANG BÊN TRÁI
----------------------------------------------------
local tabs = {
    { "🏠 Chính", loadMainTab },
    { "👼 Siêu Nhân", loadCutePowersTab },
    { "🎯 Chiến Đấu", loadCombatTab },
    { "👁️ Hiển Thị", loadVisualsTab },
    { "🌀 Vui Nhộn", loadFunTab }
}

for _, tabData in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.9, 0, 0, 36)
    tabBtn.BackgroundColor3 = Color3.fromRGB(255, 205, 215)
    tabBtn.Text = tabData[1]
    tabBtn.Font = Enum.Font.FredokaOne
    tabBtn.TextColor3 = Color3.fromRGB(130, 80, 90)
    tabBtn.TextSize = 13
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
    tabBtn.Parent = TabContainer
    
    tabBtn.MouseButton1Click:Connect(function()
        playCuteSound(1222220043)
        tabData[2]()
    end)
end

-- Tự động mở Tab Chính đầu tiên sau khi load
loadMainTab()
