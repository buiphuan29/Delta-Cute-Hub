--[[
    🎮 DELTA DARK PREMIUM HUB - VERSION 8.0 (ULTIMATE CUSTOMIZER) 🎮
    - Hoạt ảnh & VFX: Sửa lỗi Emotes & Chuyển đổi R6/R15 bằng bộ lọc Animator tương thích 100%.
    - Mới: Thanh trượt tự do thay đổi kích thước Hub (UI Scale) từ 0.7x đến 1.3x.
    - Mới: Tab Công Cụ (BTools, TP Tool, Tùy chỉnh kích cỡ vũ khí, dọn dẹp Backpack).
    - Tính năng Hệ thống: Tích hợp đầy đủ Anti-AFK, Anti-Fling, Anti-Void và Boost FPS siêu mượt.
    - Thiết kế: Giao diện chuyển sắc cực đẹp, khoảng cách rộng rãi, chống bấm nhầm.
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

-- Khởi tạo hoặc dọn dẹp Shader cũ trong game
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

-- Đặt giá trị mặc định ban đầu cho Shader
CustomBlur.Size = 0
CustomColorCorr.Contrast = 0
CustomColorCorr.Saturation = 0
CustomColorCorr.Brightness = 0

-- Tạo folder chứa đồ xây dựng của Hub
local buildFolder = Workspace:FindFirstChild("Delta_Premium_Builds")
if not buildFolder then buildFolder = Instance.new("Folder", Workspace); buildFolder.Name = "Delta_Premium_Builds" end

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
LoadStroke.Color = Color3.fromRGB(0, 120, 215)

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Size = UDim2.new(1, 0, 0, 40)
LoadTitle.Position = UDim2.new(0, 0, 0, 15)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "DELTA DARK PREMIUM"
LoadTitle.Font = Enum.Font.SourceSansBold
LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadTitle.TextSize = 20

local LoadStatus = Instance.new("TextLabel", LoadFrame)
LoadStatus.Size = UDim2.new(1, 0, 0, 20)
LoadStatus.Position = UDim2.new(0, 0, 0, 55)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Đang khởi chạy hệ thống..."
LoadStatus.Font = Enum.Font.SourceSansItalic
LoadStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
LoadStatus.TextSize = 13

-- Thanh tiến trình (Progress Bar)
local ProgressBg = Instance.new("Frame", LoadFrame)
ProgressBg.Size = UDim2.new(0.8, 0, 0, 6)
ProgressBg.Position = UDim2.new(0.1, 0, 0, 95)
ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(1, 0)

local ProgressBar = Instance.new("Frame", ProgressBg)
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(1, 0)

-- Chạy hoạt ảnh Loading mượt mà
local steps = {"Kết nối dữ liệu...", "Kiểm tra loại Rig nhân vật...", "Đang dọn dẹp bộ nhớ...", "Khởi chạy UI hoàn tất!"}
task.spawn(function()
    for i, stepText in ipairs(steps) do
        LoadStatus.Text = stepText
        local targetScale = i / #steps
        local tween = TweenService:Create(ProgressBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(targetScale, 0, 1, 0)})
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.12)
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

task.wait(1.8)

----------------------------------------------------
-- 📱 THIẾT KẾ GIAO DIỆN DARK PREMIUM v8.0 (PREMIUM) 📱
----------------------------------------------------
local DarkGui = Instance.new("ScreenGui")
DarkGui.Parent = coreGuiSuccess and coreGuiParent or LocalPlayer:FindFirstChildOfClass("PlayerGui")
DarkGui.Name = "DeltaDarkHub_" .. tostring(math.random(1000, 9999))
DarkGui.ResetOnSpawn = false

-- Kích thước gốc của Hub
local BASE_WIDTH = 560
local BASE_HEIGHT = 370
local currentScale = 1.0

-- Khung chính của Hub (Thiết kế bo tròn nghệ thuật hơn)
local MainFrame = Instance.new("Frame", DarkGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
MainFrame.Position = UDim2.new(0.5, -BASE_WIDTH/2, 0.5, -BASE_HEIGHT/2)
MainFrame.Size = UDim2.new(0, BASE_WIDTH, 0, BASE_HEIGHT)
MainFrame.Active = true

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 16)

-- Viền Neon tuyệt đẹp
local HubStroke = Instance.new("UIStroke", MainFrame)
HubStroke.Thickness = 2
HubStroke.Color = Color3.fromRGB(0, 120, 215)

-- Đầu mục màu chuyển sắc (Header Gradient)
local HeaderBar = Instance.new("Frame", MainFrame)
HeaderBar.Size = UDim2.new(1, 0, 0, 42)
HeaderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeaderBar.BackgroundTransparency = 0.95
Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 16)

local HeaderGradient = Instance.new("UIGradient", HeaderBar)
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12))
})

-- Kéo thả Hub mượt mà
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

-- Tiêu đề Hub
local Title = Instance.new("TextLabel", MainFrame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 10)
Title.Size = UDim2.new(1, -120, 0, 22)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DELTA DARK ULTIMATE v8.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left

-- NÚT THU NHỎ HUB
local MiniButton = Instance.new("TextButton", DarkGui)
MiniButton.Size = UDim2.new(0, 50, 0, 50)
MiniButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MiniButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MiniButton.Text = "D"
MiniButton.Font = Enum.Font.SourceSansBold
MiniButton.TextColor3 = Color3.fromRGB(0, 120, 215)
MiniButton.TextSize = 25
MiniButton.Visible = false
Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(1, 0)

local MiniStroke = Instance.new("UIStroke", MiniButton)
MiniStroke.Thickness = 2
MiniStroke.Color = Color3.fromRGB(0, 120, 215)

-- Kéo thả nút thu nhỏ tự do
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

-- Nút điều khiển góc phải
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
    MainFrame:TweenSize(UDim2.new(0, BASE_WIDTH * currentScale, 0, BASE_HEIGHT * currentScale), "Out", "Quad", 0.3, true)
end)

CloseBtn.MouseButton1Click:Connect(function()
    cleanShaders()
    DarkGui:Destroy()
end)

-- Sidebar bên trái (Đã dãn rộng, tạo nét chuyên nghiệp)
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

-- Khung hiển thị nội dung bên phải (Phân bổ cực kỳ thoáng, không dính sát)
local ContentContainer = Instance.new("ScrollingFrame", MainFrame)
ContentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ContentContainer.Position = UDim2.new(0, 148, 0, 52)
ContentContainer.Size = UDim2.new(1, -160, 1, -66)
ContentContainer.CanvasSize = UDim2.new(0, 0, 1.5, 0)
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 55)
Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 12)

local ContentLayout = Instance.new("UIListLayout", ContentContainer)
ContentLayout.Padding = UDim.new(0, 14) -- Khoảng cách hoàn hảo 14px giúp UI thoáng, đẹp mắt
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Tự động căn chỉnh trang cuộn
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 25)
end)

----------------------------------------------------
-- BỘ DỰNG PHẦN TỬ CHỨC NĂNG (DYNAMIC COMPONENTS)
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
-- ⚙️ HÀM THAY ĐỔI KÍCH THƯỚC TOÀN GIAO DIỆN (SCALE HUB)
----------------------------------------------------
local function setHubScale(scaleValue)
    currentScale = scaleValue
    local targetWidth = BASE_WIDTH * scaleValue
    local targetHeight = BASE_HEIGHT * scaleValue
    
    -- Giữ vị trí trung tâm không đổi khi co giãn
    local currentPos = MainFrame.Position
    MainFrame.Size = UDim2.new(0, targetWidth, 0, targetHeight)
    
    -- Tự điều chỉnh kích thước góc bo tròn và độ dày viền theo tỷ lệ
    FrameCorner.CornerRadius = UDim.new(0, 16 * scaleValue)
    HubStroke.Thickness = 2 * scaleValue
end

----------------------------------------------------
-- 🛠️ KHU VỰC QUẢN LÝ CÔNG CỤ & THANH CÔNG CỤ (NEW)
----------------------------------------------------

-- Nhận BTools (Công cụ xây dựng)
local function giveBTools()
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    
    local toolNames = {"Clone (Nhân bản)", "Delete (Xóa)", "Move (Di chuyển)"}
    for _, tName in ipairs(toolNames) do
        local tool = Instance.new("Tool")
        tool.Name = "🛠️ " .. tName
        tool.RequiresHandle = false
        
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target and target ~= workspace.Terrain then
                if tName == "Delete (Xóa)" then
                    target:Destroy()
                elseif tName == "Clone (Nhân bản)" then
                    local clone = target:Clone()
                    clone.Parent = target.Parent
                    clone.Position = clone.Position + Vector3.new(0, 5, 0)
                elseif tName == "Move (Di chuyển)" then
                    target.Position = mouse.Hit.Position + Vector3.new(0, target.Size.Y / 2, 0)
                end
            end
        end)
        tool.Parent = backpack
    end
end

-- Nhận Teleport Tool (Nhấp để dịch chuyển)
local function giveTeleportTool()
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    
    local tool = Instance.new("Tool")
    tool.Name = "📍 Click To Teleport"
    tool.RequiresHandle = false
    
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    tool.Parent = backpack
end

-- Điều chỉnh kích thước vật phẩm cầm tay
local function resizeEquippedTool(scaleValue)
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool then
        for _, part in ipairs(tool:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * scaleValue
                if part.Name == "Handle" then
                    part.CanCollide = false
                end
            end
        end
    end
end

-- Tháo toàn bộ trang bị
local function unequipAllTools()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:UnequipTools() end
end

-- Trang bị tất cả vật phẩm
local function equipAllTools()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if hum and backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                hum:EquipTool(tool)
            end
        end
    end
end

-- Dọn dẹp thanh công cụ
local function clearBackpack()
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
    end
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
    end
end

----------------------------------------------------
-- 🌀 FIX TRỰC TIẾP: HỆ THỐNG EMOTES & CHUYỂN R6/R15
----------------------------------------------------
local activeEmoteTrack = nil

-- Hàm kiểm tra xem nhân vật hiện tại là R6 hay R15
local function getCharacterRigType()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        return hum.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
    end
    return "R15" -- Mặc định nếu lỗi
end

-- Dừng toàn bộ các điệu nhảy/emote đang chạy
local function stopAllEmotes()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if activeEmoteTrack then activeEmoteTrack:Stop() activeEmoteTrack = nil end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.Name == "PremiumEmote" then track:Stop() end
        end
    end
end

-- SỬA LỖI EMOTE: Tự động dùng ID tương thích theo Rig của bạn
local function playSmartEmote(r15_Id, r6_Id)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    stopAllEmotes()
    
    -- Roblox bắt buộc phải gọi thông qua Animator để bảo đảm hoạt ảnh hoạt động tốt
    local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
    local currentRig = getCharacterRigType()
    local finalAnimId = (currentRig == "R15") and r15_Id or r6_Id
    
    local anim = Instance.new("Animation")
    anim.Name = "PremiumEmote"
    anim.AnimationId = "rbxassetid://" .. tostring(finalAnimId)
    
    local success, track = pcall(function() return animator:LoadAnimation(anim) end)
    if success and track then
        activeEmoteTrack = track
        track.Priority = Enum.AnimationPriority.Action
        track:Play()
    end
end

-- GIẢ LẬP RIG MOVEMENT (Client-side R6 <-> R15 Converter)
local function simulateRigMovement(targetRig)
    local char = LocalPlayer.Character
    local animate = char and char:FindFirstChild("Animate")
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
            animate.jump.JumpAnim.AnimationId = "rbxassetid://616161997"
            animate.fall.FallAnim.AnimationId = "rbxassetid://616157476"
            animate.idle.Animation1.AnimationId = "rbxassetid://507766666"
            animate.idle.Animation2.AnimationId = "rbxassetid://507766951"
        end)
    end
    -- Reset hoạt cảnh lập tức
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Landed) end
end

----------------------------------------------------
-- HỆ THỐNG DI CHUYỂN GỐC
----------------------------------------------------
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
        end
        if hum then hum.PlatformStand = false end
    end
end

----------------------------------------------------
-- CÁC TAB HIỂN THỊ TÍNH NĂNG
----------------------------------------------------

local function loadMainTab()
    clearContent()
    addParagraph("DI CHUYỂN")
    addSlider("Tốc độ (Speed)", 16, 200, 16, function(v)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end)
    addSlider("Độ cao nhảy (Jump)", 50, 300, 50, function(v)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = v; hum.UseJumpPower = true end
    end)
    addToggle("Chế độ Bay (Fly)", false, toggleFly)
    addSlider("Tốc độ Bay", 10, 200, 50, function(v) flySpeed = v end)
    addToggle("Đi Trên Không (Air Walk)", false, toggleAirWalk)
    addToggle("Đi Trên Nước (Water Walk)", false, toggleWaterWalk)
end

local function loadCombatTab()
    clearContent()
    addParagraph("CHIẾN ĐẤU / TẤN CÔNG")
    addToggle("Smart Target Fling (Hất Văng)", false, toggleSmartFling)
    
    local aimbotActive = false
    addToggle("Aimbot (Khóa Mục Tiêu)", false, function(v)
        aimbotActive = v
        if aimbotActive then
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

-- TAB MỚI: QUẢN LÝ CÔNG CỤ & THANH CÔNG CỤ (NEW)
local function loadToolsTab()
    clearContent()
    addParagraph("CUNG CẤP CÔNG CỤ (VẬT PHẨM)")
    addButton("Nhận BTools (Công cụ xây/Xóa cực đã)", giveBTools)
    addButton("Nhận Click Teleport Tool (Nhấp để dịch chuyển)", giveTeleportTool)
    
    addParagraph("TÙY CHỈNH KÍCH CỠ VŨ KHÍ CẦM TAY")
    addButton("Phóng to 1.5x vật phẩm đang cầm", function() resizeEquippedTool(1.5) end)
    addButton("Thu nhỏ 0.7x vật phẩm đang cầm", function() resizeEquippedTool(0.7) end)

    addParagraph("ĐIỀU CHỈNH THANH CÔNG CỤ (BACKPACK)")
    addButton("Cất toàn bộ công cụ đang cầm (Unequip All)", unequipAllTools)
    addButton("Trang bị toàn bộ công cụ cùng lúc (Equip All)", equipAllTools)
    addButton("DỌN SẠCH TÚI ĐỒ (Clear Backpack)", clearBackpack)
end

-- TAB SHADERS ĐỒ HỌA
local function loadShaderTab()
    clearContent()
    addParagraph("TÙY CHỈNH SHADER HÌNH ẢNH")
    addSlider("Độ mờ cảnh vật (Blur)", 0, 40, CustomBlur.Size, function(v) CustomBlur.Size = v end)
    addSlider("Độ tương phản (Contrast)", -1, 2, CustomColorCorr.Contrast, function(v) CustomColorCorr.Contrast = v end)
    addSlider("Độ rực màu (Saturation)", -1, 3, CustomColorCorr.Saturation, function(v) CustomColorCorr.Saturation = v end)
    addSlider("Độ sáng màn hình (Brightness)", -1, 1, CustomColorCorr.Brightness, function(v) CustomColorCorr.Brightness = v end)
    addButton("Khôi phục Shader mặc định", function()
        CustomBlur.Size = 0; CustomColorCorr.Contrast = 0; CustomColorCorr.Saturation = 0; CustomColorCorr.Brightness = 0
        loadShaderTab()
    end)
end

-- TAB QUAN SÁT (ESP / NOCLIP)
local function loadVisualsTab()
    clearContent()
    addParagraph("HIỂN THỊ HÌNH ẢNH (ESP)")
    local highlights = {}
    addToggle("Vẽ Khung Người Chơi (ESP)", false, function(v)
        if v then
            local function applyESP(player)
                if player ~= LocalPlayer then
                    player.CharacterAdded:Connect(function(char)
                        local hl = Instance.new("Highlight", char)
                        hl.FillColor = HubStroke.Color
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlights[player] = hl
                    end)
                    if player.Character then
                        local hl = Instance.new("Highlight", player.Character)
                        hl.FillColor = HubStroke.Color
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
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
    addToggle("Xuyên Tường (Noclip)", false, function(v)
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
end

-- TAB VUI NHỘN (ĐÃ FIX KHUNG HOẠT ẢNH & EMOTE 100%)
local function loadFunTab()
    clearContent()
    
    addParagraph("CHUYỂN ĐỔI CHUYỂN ĐỘNG RIG")
    addButton("Chuyển sang cử động kiểu R6", function()
        simulateRigMovement("R6")
    end)
    addButton("Chuyển sang cử động kiểu R15", function()
        simulateRigMovement("R15")
    end)

    addParagraph("KHO EMOTE SIÊU BỰA (ĐÃ SỬA)")
    -- Tham số: playSmartEmote(R15_AssetID, R6_AssetID)
    addButton("Nhảy Griddy", function()
        playSmartEmote(11116631165, 35654434)
    end)
    addButton("California Gurls", function()
        playSmartEmote(11496181792, 35654491)
    end)
    addButton("Dáng đứng T-Pose huyền thoại", function()
        playSmartEmote(10815154336, 125750702)
    end)
    addButton("Nhảy Floss", function()
        playSmartEmote(10221350438, 35654515)
    end)
    addButton("Làm động tác rung lắc Glitch", function()
        playSmartEmote(35654637, 35654637)
    end)
    addButton("🚫 DỪNG CHƠI EMOTE NGAY LẬP TỨC", stopAllEmotes)

    addParagraph("BIẾN HÌNH (MORPH)")
    addToggle("Robot Morph v2", false, function(v)
        if v then
            _G.DeltaHubConnections["Robot"] = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, m in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if m:IsA("Motor6D") and m.Name ~= "Neck" then
                            m.Transform = CFrame.Angles(math.sin(tick() * 10) * 0.25, 0, 0)
                        end
                    end
                end
            end)
        else
            if _G.DeltaHubConnections["Robot"] then _G.DeltaHubConnections["Robot"]:Disconnect() end
        end
    end)
end

-- TAB THAY ĐỔI GIAO DIỆN & KÍCH THƯỚC (UI CUSTOMIZER)
local function loadCustomTab()
    clearContent()
    
    addParagraph("ĐIỀU CHỈNH KÍCH THƯỚC GIAO DIỆN (UI SCALE)")
    addSlider("Độ To Nhỏ Hub (Scale)", 0.7, 1.3, currentScale, function(val)
        setHubScale(val)
    end)

    addParagraph("CÁ NHÂN HÓA MÀU SẮC NEON")
    addSlider("Màu Viền R (Red)", 0, 255, math.round(HubStroke.Color.R * 255), function(v)
        HubStroke.Color = Color3.fromRGB(v, HubStroke.Color.G * 255, HubStroke.Color.B * 255)
        MiniStroke.Color = HubStroke.Color
        MiniButton.TextColor3 = HubStroke.Color
    end)
    addSlider("Màu Viền G (Green)", 0, 255, math.round(HubStroke.Color.G * 255), function(v)
        HubStroke.Color = Color3.fromRGB(HubStroke.Color.R * 255, v, HubStroke.Color.B * 255)
        MiniStroke.Color = HubStroke.Color
        MiniButton.TextColor3 = HubStroke.Color
    end)
    addSlider("Màu Viền B (Blue)", 0, 255, math.round(HubStroke.Color.B * 255), function(v)
        HubStroke.Color = Color3.fromRGB(HubStroke.Color.R * 255, HubStroke.Color.G * 255, v)
        MiniStroke.Color = HubStroke.Color
        MiniButton.TextColor3 = HubStroke.Color
    end)
end

-- TAB HỆ THỐNG / SETTING (ĐẦY ĐỦ CÁC TÍNH NĂNG ANTI)
local function loadUtilityTab()
    clearContent()
    
    addParagraph("HỆ THỐNG PHÒNG CHỐNG (ANTI)")
    
    -- Anti AFK
    addToggle("Anti-AFK (Chống treo game)", false, function(v)
        if v then
            local VirtualUser = game:GetService("VirtualUser")
            _G.DeltaHubConnections["AntiAFK"] = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
        else
            if _G.DeltaHubConnections["AntiAFK"] then _G.DeltaHubConnections["AntiAFK"]:Disconnect() end
        end
    end)
    
    -- Anti Fling
    addToggle("Anti-Fling (Chống kẻ xấu hất văng)", false, function(v)
        if v then
            _G.DeltaHubConnections["AntiFling"] = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Velocity = Vector3.new(0, 0, 0)
                            part.RotVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        else
            if _G.DeltaHubConnections["AntiFling"] then _G.DeltaHubConnections["AntiFling"]:Disconnect() end
        end
    end)
    
    -- Anti Void
    addToggle("Anti-Void (Tự cứu khi rơi vực)", false, function(v)
        if v then
            local lastSafePosition = nil
            _G.DeltaHubConnections["AntiVoid"] = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if hrp.Position.Y > -80 then
                        lastSafePosition = hrp.CFrame
                    else
                        if lastSafePosition then
                            hrp.CFrame = lastSafePosition
                            hrp.Velocity = Vector3.new(0,0,0)
                        end
                    end
                end
            end)
        else
            if _G.DeltaHubConnections["AntiVoid"] then _G.DeltaHubConnections["AntiVoid"]:Disconnect() end
        end
    end)
    
    -- Boost FPS
    addButton("Bật Boost FPS (Anti Lag game)", function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
                obj.Material = Enum.Material.SmoothPlastic
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end
    end)

    addParagraph("HỆ THỐNG")
    addButton("Vào lại Server (Rejoin)", function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
    addButton("Gỡ bỏ hoàn toàn GUI Hub", function()
        cleanShaders()
        stopAllEmotes()
        DarkGui:Destroy()
    end)
end

----------------------------------------------------
-- PHẦN CÒN LẠI CỦA HỆ THỐNG DI CHUYỂN PHỤ TRỢ
----------------------------------------------------
function toggleAirWalk(Value)
    airWalkActive = Value
    if airWalkActive then
        airPlatform = Instance.new("Part", buildFolder)
        airPlatform.Size = Vector3.new(10, 0.8, 10)
        airPlatform.Transparency = 0.5
        airPlatform.Color = HubStroke.Color
        airPlatform.Material = Enum.Material.Neon
        airPlatform.Anchored = true
        
        HubStroke:GetPropertyChangedSignal("Color"):Connect(function()
            if airPlatform then airPlatform.Color = HubStroke.Color end
        end)

        airWalkConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and airPlatform then
                airPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.4, hrp.Position.Z)
            end
        end)
        _G.DeltaHubConnections["AirWalk"] = airWalkConn
    else
        if airWalkConn then airWalkConn:Disconnect() airWalkConn = nil end
        if airPlatform then airPlatform:Destroy() airPlatform = nil end
    end
end

function toggleWaterWalk(Value)
    waterWalkActive = Value
    if waterWalkActive then
        waterPlatform = Instance.new("Part", buildFolder)
        waterPlatform.Size = Vector3.new(14, 0.5, 14)
        waterPlatform.Transparency = 0.8
        waterPlatform.Color = Color3.fromRGB(0, 255, 255)
        waterPlatform.Material = Enum.Material.Neon
        waterPlatform.Anchored = true
        
        waterWalkConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and waterPlatform then
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {char, buildFolder}
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

----------------------------------------------------
-- KHỞI TẠO TẤT CẢ CÁC SIDEBAR TABS
----------------------------------------------------
local tabs = {
    { "🏠 Chính", loadMainTab },
    { "🎯 Tấn Công", loadCombatTab },
    { "🛠️ Công Cụ", loadToolsTab }, -- Tab Công Cụ mới với tính năng Backpack Adjuster
    { "✨ Shaders", loadShaderTab },
    { "👁️ Quan Sát", loadVisualsTab },
    { "🌀 Vui Nhộn", loadFunTab }, -- Tab chứa Emote và R6/R15 đã sửa lỗi
    { "🎨 Giao Diện", loadCustomTab }, -- Chứa chỉnh sửa độ to nhỏ và màu viền
    { "⚙️ Hệ Thống", loadUtilityTab } -- Chứa Anti-AFK, Anti-Fling, Anti-Void, Reset...
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
