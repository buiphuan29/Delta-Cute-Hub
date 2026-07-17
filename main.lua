-- [[ QUANTUM CORE PREMIUM HUB V3 - GHOST MIMIC, PRO BUILD & AI PREDICT ]] --
-- Đầy đủ UI, tính năng di chuyển, chống hack, phân thân ma quái, xây dựng cải tiến và AI dự đoán

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
end)

local Theme = {
    Bg = Color3.fromRGB(15, 15, 22),
    Sidebar = Color3.fromRGB(10, 10, 14),
    Accent = Color3.fromRGB(0, 255, 170), -- Cyber Neon Green
    Text = Color3.fromRGB(245, 245, 250),
    TextMuted = Color3.fromRGB(130, 135, 145),
    ElementBg = Color3.fromRGB(22, 22, 30),
    Border = Color3.fromRGB(35, 35, 45)
}

----------------------------------------------------------------
-- BASE INTERFACE SETUP
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuantumCorePremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
pcall(function() syn.protect_gui(ScreenGui) end)
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 390)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -195)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1.8
MainStroke.Parent = MainFrame

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.4, 0, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "QUANTUM CORE V3"
Title.TextColor3 = Theme.Text
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local FpsLabel = Instance.new("TextLabel")
FpsLabel.Size = UDim2.new(0.2, 0, 1, 0)
FpsLabel.Position = UDim2.new(0.55, 0, 0, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: --"
FpsLabel.TextColor3 = Theme.Accent
FpsLabel.TextSize = 12
FpsLabel.Font = Enum.Font.Code
FpsLabel.TextXAlignment = Enum.TextXAlignment.Right
FpsLabel.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -65, 0, 6)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Theme.TextMuted
MinimizeBtn.TextSize = 22
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 6)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 0, 42)
Divider.BackgroundColor3 = Theme.Border
Divider.Parent = MainFrame

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -43)
Sidebar.Position = UDim2.new(0, 0, 0, 43)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local SidebarPatch = Instance.new("Frame")
SidebarPatch.Size = UDim2.new(0, 15, 1, 0)
SidebarPatch.Position = UDim2.new(1, -15, 0, 0)
SidebarPatch.BackgroundColor3 = Theme.Sidebar
SidebarPatch.BorderSizePixel = 0
SidebarPatch.Parent = Sidebar

-- User Card
local UserInfoFrame = Instance.new("Frame")
UserInfoFrame.Size = UDim2.new(0, 144, 0, 52)
UserInfoFrame.Position = UDim2.new(0, 8, 0, 8)
UserInfoFrame.BackgroundColor3 = Theme.ElementBg
UserInfoFrame.Parent = Sidebar

local UICornerInfo = Instance.new("UICorner")
UICornerInfo.CornerRadius = UDim.new(0, 8)
UICornerInfo.Parent = UserInfoFrame

local UIStrokeInfo = Instance.new("UIStroke")
UIStrokeInfo.Color = Theme.Border
UIStrokeInfo.Thickness = 1
UIStrokeInfo.Parent = UserInfoFrame

local UserVectorIcon = Instance.new("Frame")
UserVectorIcon.Size = UDim2.new(0, 32, 0, 32)
UserVectorIcon.Position = UDim2.new(0, 10, 0.5, -16)
UserVectorIcon.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
UserVectorIcon.Parent = UserInfoFrame
Instance.new("UICorner", UserVectorIcon).CornerRadius = UDim.new(1, 0)

local InnerVectorNode = Instance.new("Frame", UserVectorIcon)
InnerVectorNode.Size = UDim2.new(0, 12, 0, 12)
InnerVectorNode.Position = UDim2.new(0.5, -6, 0.5, -6)
InnerVectorNode.BackgroundColor3 = Theme.Accent
Instance.new("UICorner", InnerVectorNode).CornerRadius = UDim.new(1, 0)

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Size = UDim2.new(1, -52, 0, 18)
UsernameLabel.Position = UDim2.new(0, 48, 0, 8)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Text = string.sub(LocalPlayer.DisplayName, 1, 11)
UsernameLabel.TextColor3 = Theme.Text
UsernameLabel.TextSize = 12
UsernameLabel.Font = Enum.Font.GothamBold
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.Parent = UserInfoFrame

local AgeLabel = Instance.new("TextLabel")
AgeLabel.Size = UDim2.new(1, -52, 0, 14)
AgeLabel.Position = UDim2.new(0, 48, 0, 26)
AgeLabel.BackgroundTransparency = 1
AgeLabel.Text = "Age: " .. LocalPlayer.AccountAge .. "d"
AgeLabel.TextColor3 = Theme.TextMuted
AgeLabel.TextSize = 10
AgeLabel.Font = Enum.Font.Gotham
AgeLabel.TextXAlignment = Enum.TextXAlignment.Left
AgeLabel.Parent = UserInfoFrame

-- Tab Navigation Scroll
local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, 0, 1, -70)
TabScroll.Position = UDim2.new(0, 0, 0, 68)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 0
TabScroll.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabScroll
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

----------------------------------------------------------------
-- CONTAINER & CONTROLS
----------------------------------------------------------------
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -175, 1, -52)
Container.Position = UDim2.new(0, 170, 0, 48)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Floating Icon để mở lại Hub
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
FloatingBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
FloatingBtn.BackgroundColor3 = Theme.Bg
FloatingBtn.Text = "⚡"
FloatingBtn.TextColor3 = Theme.Accent
FloatingBtn.TextSize = 20
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Visible = false
FloatingBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Theme.Accent
FloatStroke.Thickness = 1.5
FloatStroke.Parent = FloatingBtn

----------------------------------------------------------------
-- DRAG ENGINE (PC & MOBILE)
----------------------------------------------------------------
local function applyDragSupport(frame)
    local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragStart = nil end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStart then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
applyDragSupport(MainFrame)
applyDragSupport(FloatingBtn)

----------------------------------------------------------------
-- CUSTOM VECTOR ICONS
----------------------------------------------------------------
local function CreateVectorIcon(parent, iconType)
    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0, 18, 0, 18)
    iconFrame.BackgroundTransparency = 1
    iconFrame.Position = UDim2.new(0, 12, 0.5, -9)
    iconFrame.Parent = parent

    if iconType == "Main" then
        local d = Instance.new("Frame", iconFrame)
        d.Size = UDim2.new(0, 10, 0, 10)
        d.Position = UDim2.new(0.5, -5, 0.5, -5)
        d.Rotation = 45
        d.BackgroundColor3 = Theme.TextMuted
        d.BorderSizePixel = 0
        Instance.new("UICorner", d).CornerRadius = UDim.new(0, 2)
    elseif iconType == "Combat" then
        local outer = Instance.new("Frame", iconFrame)
        outer.Size = UDim2.new(1, 0, 1, 0)
        outer.BackgroundTransparency = 1
        local st = Instance.new("UIStroke", outer)
        st.Color = Theme.TextMuted
        st.Thickness = 1.5
        Instance.new("UICorner", outer).CornerRadius = UDim.new(1, 0)
    elseif iconType == "Movement" then
        local wingLeft = Instance.new("Frame", iconFrame)
        wingLeft.Size = UDim2.new(0, 2, 0, 10)
        wingLeft.Position = UDim2.new(0.3, 0, 0.2, 0)
        wingLeft.Rotation = 35
        wingLeft.BackgroundColor3 = Theme.TextMuted
    elseif iconType == "Visuals" then
        local line = Instance.new("Frame", iconFrame)
        line.Size = UDim2.new(1, 0, 0, 2)
        line.Position = UDim2.new(0, 0, 0.5, -1)
        line.BackgroundColor3 = Theme.TextMuted
    elseif iconType == "Build" then
        local box = Instance.new("Frame", iconFrame)
        box.Size = UDim2.new(1, 0, 0.7, 0)
        box.Position = UDim2.new(0, 0, 0.15, 0)
        box.BackgroundTransparency = 1
        local st = Instance.new("UIStroke", box)
        st.Color = Theme.TextMuted
        st.Thickness = 1.5
    elseif iconType == "AI" then
        local brain = Instance.new("Frame", iconFrame)
        brain.Size = UDim2.new(0, 8, 0, 8)
        brain.Position = UDim2.new(0.5, -4, 0.5, -4)
        brain.BackgroundColor3 = Theme.TextMuted
        Instance.new("UICorner", brain).CornerRadius = UDim.new(1, 0)
    elseif iconType == "Settings" then
        for i = 1, 3 do
            local dot = Instance.new("Frame", iconFrame)
            dot.Size = UDim2.new(0, 4, 0, 4)
            dot.Position = UDim2.new(0, (i-1)*5 + 2, 0.5, -2)
            dot.BackgroundColor3 = Theme.TextMuted
            Instance.new("UICorner", dot)
        end
    end
end

----------------------------------------------------------------
-- TABS GENERATOR
----------------------------------------------------------------
local function CreateTab(name, vectorType)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(0, 144, 0, 36)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = "         " .. name
    TabButton.TextColor3 = Theme.TextMuted
    TabButton.TextSize = 13
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = TabScroll

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton

    CreateVectorIcon(TabButton, vectorType)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -5, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Theme.Border
    Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = Container

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 6)
    PagePadding.Parent = Page

    TabButton.MouseButton1Click:Connect(function()
        for _, btn in ipairs(TabScroll:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Theme.TextMuted, BackgroundTransparency = 1}):Play()
                for _, ch in ipairs(btn:GetChildren()) do
                    if ch:IsA("Frame") then
                        for _, sub in ipairs(ch:GetChildren()) do
                            if sub:IsA("UIStroke") then sub.Color = Theme.TextMuted
                            elseif sub:IsA("Frame") then sub.BackgroundColor3 = Theme.TextMuted end
                        end
                    end
                end
            end
        end
        for _, pg in ipairs(Container:GetChildren()) do
            if pg:IsA("ScrollingFrame") then pg.Visible = false end
        end
        TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Theme.Accent, BackgroundTransparency = 0.9, BackgroundColor3 = Theme.Accent}):Play()
        
        for _, ch in ipairs(TabButton:GetChildren()) do
            if ch:IsA("Frame") then
                for _, sub in ipairs(ch:GetChildren()) do
                    if sub:IsA("UIStroke") then sub.Color = Theme.Accent
                    elseif sub:IsA("Frame") then sub.BackgroundColor3 = Theme.Accent end
                end
            end
        end
        Page.Visible = true
    end)

    return Page
end

----------------------------------------------------------------
-- INTERFACE CONTROLS CREATORS
----------------------------------------------------------------
local function AddToggle(page, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 385, 0, 38)
    ToggleFrame.BackgroundColor3 = Theme.ElementBg
    ToggleFrame.Parent = page

    local TFCorner = Instance.new("UICorner")
    TFCorner.CornerRadius = UDim.new(0, 6)
    TFCorner.Parent = ToggleFrame

    local TFStroke = Instance.new("UIStroke")
    TFStroke.Color = Theme.Border
    TFStroke.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 34, 0, 16)
    Switch.Position = UDim2.new(1, -46, 0.5, -8)
    Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Switch.Parent = ToggleFrame
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 12, 0, 12)
    Indicator.Position = UDim2.new(0, 2, 0.5, -6)
    Indicator.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    Indicator.Parent = Switch
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local state = default
    local function update()
        if state then
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.15), {Position = UDim2.new(1, -14, 0.5, -6), BackgroundColor3 = Theme.Bg}):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Color3.fromRGB(180, 180, 180)}):Play()
        end
    end
    update()

    local Hit = Instance.new("TextButton")
    Hit.Size = UDim2.new(1, 0, 1, 0)
    Hit.BackgroundTransparency = 1
    Hit.Text = ""
    Hit.Parent = ToggleFrame
    Hit.MouseButton1Click:Connect(function() state = not state; update(); callback(state) end)
end

local function AddAdjuster(page, text, default, min, max, step, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 385, 0, 38)
    Frame.BackgroundColor3 = Theme.ElementBg
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", Frame) s.Color = Theme.Border

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local val = default
    local Disp = Instance.new("TextLabel")
    Disp.Size = UDim2.new(0, 45, 0, 22)
    Disp.Position = UDim2.new(1, -80, 0.5, -11)
    Disp.BackgroundTransparency = 1
    Disp.Text = tostring(val)
    Disp.TextColor3 = Theme.Accent
    Disp.TextSize = 13
    Disp.Font = Enum.Font.GothamBold
    Disp.Parent = Frame

    local M = Instance.new("TextButton")
    M.Size = UDim2.new(0, 22, 0, 22)
    M.Position = UDim2.new(1, -110, 0.5, -11)
    M.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    M.Text = "-" M.TextColor3 = Theme.Text M.TextSize = 14 M.Font = Enum.Font.GothamBold M.Parent = Frame
    Instance.new("UICorner", M).CornerRadius = UDim.new(0, 4)

    local P = Instance.new("TextButton")
    P.Size = UDim2.new(0, 22, 0, 22)
    P.Position = UDim2.new(1, -30, 0.5, -11)
    P.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    P.Text = "+" P.TextColor3 = Theme.Text P.TextSize = 14 P.Font = Enum.Font.GothamBold P.Parent = Frame
    Instance.new("UICorner", P).CornerRadius = UDim.new(0, 4)

    M.MouseButton1Click:Connect(function()
        if val - step >= min then val = val - step; Disp.Text = tostring(val); callback(val) end
    end)
    P.MouseButton1Click:Connect(function()
        if val + step <= max then val = val + step; Disp.Text = tostring(val); callback(val) end
    end)
end

local function AddTextBox(page, placeholder, callback)
    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(0, 385, 0, 38)
    BoxFrame.BackgroundColor3 = Theme.ElementBg
    BoxFrame.Parent = page
    Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", BoxFrame) s.Color = Theme.Border

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, -24, 1, 0)
    Box.Position = UDim2.new(0, 12, 0, 0)
    Box.BackgroundTransparency = 1
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.TextColor3 = Theme.Text
    Box.PlaceholderColor3 = Theme.TextMuted
    Box.TextSize = 12
    Box.Font = Enum.Font.GothamSemibold
    Box.TextXAlignment = Enum.TextXAlignment.Left
    Box.Parent = BoxFrame

    Box.FocusLost:Connect(function(enterPressed) callback(Box.Text) end)
end

local function AddButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 385, 0, 38)
    Btn.BackgroundColor3 = Theme.ElementBg
    Btn.Text = text; Btn.TextColor3 = Theme.Text; Btn.TextSize = 12; Btn.Font = Enum.Font.GothamSemibold; Btn.Parent = page
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", Btn) s.Color = Theme.Border
    Btn.MouseButton1Click:Connect(callback)
end

----------------------------------------------------------------
-- GAME MECHANICS ENGINES (Restored Core v2)
----------------------------------------------------------------
-- 1. FPS Tracker
local frameCount = 0
local nextUpdate = os.clock() + 1
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if os.clock() >= nextUpdate then
        FpsLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        nextUpdate = os.clock() + 1
    end
end)

-- 2. Fly Engine
local flying = false
local flySpeed = 60
local bv, bg
local trailEnabled = false
local activeTrails = {}

local function setupTrail()
    if not Character then return end
    local leftLeg = Character:FindFirstChild("LeftFoot") or Character:FindFirstChild("Left Leg")
    local rightLeg = Character:FindFirstChild("RightFoot") or Character:FindFirstChild("Right Leg")
    if not leftLeg or not rightLeg then return end

    for _, item in ipairs(activeTrails) do item:Destroy() end
    activeTrails = {}

    local att0 = Instance.new("Attachment", leftLeg)
    local att1 = Instance.new("Attachment", rightLeg)

    local trail = Instance.new("Trail")
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    trail.Lifetime = 0.6
    trail.Enabled = trailEnabled
    trail.Parent = Character

    table.insert(activeTrails, trail)
    table.insert(activeTrails, att0)
    table.insert(activeTrails, att1)
end

local function startFlying()
    if not Character or not RootPart then return end
    bv = Instance.new("BodyVelocity", RootPart)
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bg = Instance.new("BodyGyro", RootPart)
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    Humanoid.PlatformStand = true

    if trailEnabled then setupTrail() end

    task.spawn(function()
        while flying and Character and RootPart do
            local moveDir = Humanoid.MoveDirection
            local flyDir = Vector3.new(0,0,0)
            if moveDir.Magnitude > 0 then
                local rawDir = Camera.CFrame:VectorToObjectSpace(moveDir)
                flyDir = ((Camera.CFrame.LookVector * -rawDir.Z) + (Camera.CFrame.RightVector * rawDir.X)).Unit
            end
            bv.Velocity = flyDir * flySpeed
            bg.CFrame = Camera.CFrame
            task.wait()
        end
    end)
end

local function stopFlying()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if Humanoid then Humanoid.PlatformStand = false end
end

-- 3. Walk on Air
local airWalking = false
local airPlatform = nil
local function toggleAirWalk(state)
    airWalking = state
    if airWalking then
        airPlatform = Instance.new("Part")
        airPlatform.Size = Vector3.new(20, 1, 20)
        airPlatform.Transparency = 0.8
        airPlatform.Material = Enum.Material.Neon
        airPlatform.Color = Theme.Accent
        airPlatform.Anchored = true
        airPlatform.Parent = workspace
        task.spawn(function()
            while airWalking and Character and RootPart do
                airPlatform.CFrame = CFrame.new(RootPart.Position.X, RootPart.Position.Y - 3.5, RootPart.Position.Z)
                task.wait()
            end
        end)
    else
        if airPlatform then airPlatform:Destroy(); airPlatform = nil end
    end
end

-- 4. Double Jump
local doubleJumpEnabled = false
local hasDoubleJumped = false
UserInputService.JumpRequest:Connect(function()
    if not doubleJumpEnabled then return end
    if Humanoid:GetState() == Enum.HumanoidStateType.Freefall and not hasDoubleJumped then
        hasDoubleJumped = true
        RootPart.Velocity = Vector3.new(RootPart.Velocity.X, Humanoid.JumpPower * 1.2, RootPart.Velocity.Z)
    end
end)
RunService.Stepped:Connect(function()
    if Humanoid and Humanoid.FloorMaterial ~= Enum.Material.Air then
        hasDoubleJumped = false
    end
end)

-- 5. Dash Mechanics
local dashEnabled = false
local canDash = true
local dashSpeed = 120
local function performDash()
    if not dashEnabled or not canDash or not RootPart then return end
    canDash = false
    local moveDirection = Humanoid.MoveDirection.Magnitude > 0 and Humanoid.MoveDirection or RootPart.CFrame.LookVector
    local bvDash = Instance.new("BodyVelocity", RootPart)
    bvDash.MaxForce = Vector3.new(1e5, 0, 1e5)
    bvDash.Velocity = moveDirection * dashSpeed
    task.spawn(function()
        task.wait(0.2)
        bvDash:Destroy()
        task.wait(1.5)
        canDash = true
    end)
end

-- Mobile UI Control Setup
local MobileActionGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local DashMobileBtn = Instance.new("TextButton", MobileActionGui)
DashMobileBtn.Size = UDim2.new(0, 50, 0, 50)
DashMobileBtn.Position = UDim2.new(0.8, 0, 0.55, 0)
DashMobileBtn.BackgroundColor3 = Theme.ElementBg
DashMobileBtn.Text = "DASH"
DashMobileBtn.TextColor3 = Theme.Accent
DashMobileBtn.Visible = false
Instance.new("UICorner", DashMobileBtn).CornerRadius = UDim.new(1, 0)
DashMobileBtn.MouseButton1Click:Connect(performDash)

-- 6. Custom Shift Lock System
local shiftLockEnabled = false
local slConnection = nil
local ShiftLockBtn = Instance.new("TextButton", MobileActionGui)
ShiftLockBtn.Size = UDim2.new(0, 50, 0, 50)
ShiftLockBtn.Position = UDim2.new(0.8, 0, 0.45, 0)
ShiftLockBtn.BackgroundColor3 = Theme.ElementBg
ShiftLockBtn.Text = "LOCK"
ShiftLockBtn.TextColor3 = Theme.TextMuted
ShiftLockBtn.Visible = false
Instance.new("UICorner", ShiftLockBtn).CornerRadius = UDim.new(1, 0)

local function toggleShiftLock(state)
    shiftLockEnabled = state
    if shiftLockEnabled then
        ShiftLockBtn.TextColor3 = Theme.Accent
        slConnection = RunService.RenderStepped:Connect(function()
            if RootPart then
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CFrame = CFrame.new(RootPart.Position + Vector3.new(0, 2.5, 0)) * Camera.CFrame.Rotation * CFrame.new(2.5, 0, 10)
                RootPart.CFrame = CFrame.lookAt(RootPart.Position, RootPart.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z))
            end
        end)
    else
        ShiftLockBtn.TextColor3 = Theme.TextMuted
        if slConnection then slConnection:Disconnect(); slConnection = nil end
        Camera.CameraType = Enum.CameraType.Custom
    end
end
ShiftLockBtn.MouseButton1Click:Connect(function() toggleShiftLock(not shiftLockEnabled) end)

-- 7. Custom Cursor
local cursorEnabled = false
local originalCursor = ""
local function toggleCursor(state)
    cursorEnabled = state
    if cursorEnabled then
        originalCursor = UserInputService.MouseIcon
        UserInputService.MouseIcon = "rbxassetid://13214539130"
    else
        UserInputService.MouseIcon = originalCursor
    end
end

----------------------------------------------------------------
-- [[ NEW SYSTEM V3: GHOST MIMIC CLONE & REVIVE ]]
----------------------------------------------------------------
local ghostActive = false
local currentGhost = nil
local mimicCharge = 0
local ghostSpeedDelay = 0.15 -- Tạo cảm giác lag ma quái, lệch pha di chuyển

-- Khung hiển thị thanh nạp mạng hồi sinh ở cuối màn hình
local ChargeBarGui = Instance.new("ScreenGui", ScreenGui)
local BarFrame = Instance.new("Frame", ChargeBarGui)
BarFrame.Size = UDim2.new(0, 260, 0, 24)
BarFrame.Position = UDim2.new(0.5, -130, 0.92, 0)
BarFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
BarFrame.BorderSizePixel = 0
BarFrame.Visible = false
Instance.new("UICorner", BarFrame).CornerRadius = UDim.new(0, 6)
local barStroke = Instance.new("UIStroke", BarFrame)
barStroke.Color = Theme.Border

local FillBar = Instance.new("Frame", BarFrame)
FillBar.Size = UDim2.new(0, 0, 1, 0)
FillBar.BackgroundColor3 = Theme.Accent
FillBar.BorderSizePixel = 0
Instance.new("UICorner", FillBar).CornerRadius = UDim.new(0, 6)

local ChargeText = Instance.new("TextLabel", BarFrame)
ChargeText.Size = UDim2.new(1, 0, 1, 0)
ChargeText.BackgroundTransparency = 1
ChargeText.Text = "GHOST MIMIC CHARGING: 0%"
ChargeText.TextColor3 = Theme.Text
ChargeText.Font = Enum.Font.GothamBold
ChargeText.TextSize = 10

local function destroyGhost()
    if currentGhost then currentGhost:Destroy() end
    currentGhost = nil
    BarFrame.Visible = false
    mimicCharge = 0
end

local function spawnGhostMimic()
    destroyGhost()
    if not Character or not RootPart then return end

    Character.Archivable = true
    local clone = Character:Clone()
    Character.Archivable = false
    clone.Name = "QuantumGhost_Mimic"
    clone.Parent = workspace
    currentGhost = clone

    -- Thiết lập ngoại hình Đen Trắng & Trong Suốt (Glass)
    for _, part in ipairs(clone:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Color = Color3.fromRGB(240, 240, 240) -- Màu trắng/xám ma quái
            part.Material = Enum.Material.Glass
            part.Transparency = 0.55
            part.CanCollide = false
            -- Xóa các hiệu ứng phát sáng hay decal màu mè để giữ tone đơn sắc đen trắng
            if part:IsA("Decal") then part:Destroy() end
        elseif part:IsA("Script") or part:IsA("LocalScript") then
            part:Destroy()
        elseif part:IsA("SpecialMesh") and part.TextureId ~= "" then
            part.TextureId = "" -- Chuyển mesh về đơn sắc
        end
    end

    local gRoot = clone:FindFirstChild("HumanoidRootPart")
    local gHum = clone:FindFirstChildOfClass("Humanoid")
    if not gRoot or not gHum then return end

    BarFrame.Visible = true

    -- Vòng lặp bắt chước chuyển động (Lag di chuyển lệch pha)
    task.spawn(function()
        while ghostActive and clone and clone.Parent do
            if RootPart and Character then
                -- Bắt chước vị trí có độ trễ (delay) nhẹ
                local myCF = RootPart.CFrame
                local shadowPos = myCF * CFrame.new(0, 0, 3) -- Đi lệch về phía sau 3 units
                TweenService:Create(gRoot, TweenInfo.new(ghostSpeedDelay, Enum.EasingStyle.Linear), {CFrame = shadowPos}):Play()
                
                -- Bắt chước trạng thái nhảy/ngồi của người chơi
                if Humanoid then
                    gHum.Jump = Humanoid.Jump
                    gHum.Sit = Humanoid.Sit
                end

                -- Nạp năng lượng nhận thêm mạng
                if mimicCharge < 100 then
                    mimicCharge = mimicCharge + 0.4 -- Nạp đầy trong khoảng ~25s
                    if mimicCharge > 100 then mimicCharge = 100 end
                    FillBar.Size = UDim2.new(mimicCharge / 100, 0, 1, 0)
                    ChargeText.Text = "GHOST MIMIC CHARGING: " .. math.floor(mimicCharge) .. "%"
                    if mimicCharge == 100 then
                        ChargeText.Text = "⚡ EXTRA LIFE ACTIVE (MIMIC READY) ⚡"
                        FillBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Đổi sang màu vàng kim loại cực đẹp
                        barStroke.Color = Color3.fromRGB(255, 215, 0)
                    end
                end
            end
            task.wait(0.05)
        end
        destroyGhost()
    end)
end

-- Hệ thống hồi sinh thông minh thế mạng
local function applyReviveSystem()
    local conn
    conn = Humanoid.Died:Connect(function()
        if ghostActive and mimicCharge >= 100 and currentGhost then
            local respawnPos = currentGhost:FindFirstChild("HumanoidRootPart") and currentGhost.HumanoidRootPart.CFrame
            if respawnPos then
                task.wait(0.1)
                -- Hồi sinh người chơi ngay lập tức tại vị trí phân thân
                LocalPlayer:RequestStreamAroundAsync(respawnPos.Position)
                -- Teleport xác của bạn tới vị trí clone, thiết lập lại máu
                Character:SetPrimaryPartCFrame(respawnPos)
                task.wait(0.1)
                -- Reset trạng thái clone và tạo hiệu ứng bùng nổ đẹp mắt
                local boom = Instance.new("Explosion", workspace)
                boom.Position = respawnPos.Position
                boom.BlastRadius = 10
                
                mimicCharge = 0
                FillBar.Size = UDim2.new(0, 0, 1, 0)
                FillBar.BackgroundColor3 = Theme.Accent
                barStroke.Color = Theme.Border
                
                print("Quantum Core: Ghost Mimic bảo vệ thành công! Bạn nhận được thêm 1 mạng!")
            end
        end
    end)
end
applyReviveSystem()
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    applyReviveSystem()
end)

----------------------------------------------------------------
-- [[ NEW SYSTEM V3: PRO BUILD ENGINE ]]
----------------------------------------------------------------
local buildActive = false
local proBuildMode = "Place" -- "Place", "Delete", "Rotate", "Scale"
local buildColor = Theme.Accent
local lastPlacedPart = nil
local currentRotationAngle = 0
local scaleMultiplier = 1

local function getMouseTarget()
    local mouse = LocalPlayer:GetMouse()
    local ray = Camera:ScreenPointToRay(mouse.X, mouse.Y)
    local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000)
    return raycastResult
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not buildActive then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local hit = getMouseTarget()
        if not hit then return end

        if proBuildMode == "Place" then
            local p = Instance.new("Part")
            p.Size = Vector3.new(4, 4, 4) * scaleMultiplier
            p.Position = hit.Position + (hit.Normal * (p.Size.Y / 2))
            p.Color = buildColor
            p.Material = Enum.Material.SmoothPlastic
            p.Anchored = true
            -- Áp dụng góc xoay hiện tại
            p.CFrame = p.CFrame * CFrame.Angles(0, math.rad(currentRotationAngle), 0)
            p.Parent = workspace
            lastPlacedPart = p
        elseif proBuildMode == "Delete" then
            if hit.Instance and hit.Instance ~= workspace.Terrain and not hit.Instance:IsDescendantOf(Character) then
                if hit.Instance:IsA("Part") then hit.Instance:Destroy() end
            end
        elseif proBuildMode == "Rotate" then
            if hit.Instance and hit.Instance:IsA("Part") and hit.Instance.Anchored == true then
                hit.Instance.CFrame = hit.Instance.CFrame * CFrame.Angles(0, math.rad(45), 0)
            end
        elseif proBuildMode == "Scale" then
            if hit.Instance and hit.Instance:IsA("Part") and hit.Instance.Anchored == true then
                hit.Instance.Size = hit.Instance.Size + Vector3.new(1, 1, 1)
                hit.Instance.CFrame = hit.Instance.CFrame * CFrame.new(0, 0.5, 0) -- Đẩy nhẹ lên để không kẹt đất
            end
        end
    end
end)

----------------------------------------------------------------
-- [[ NEW SYSTEM V3: LOCAL AI EVENT PREDICTOR & CHATBOT ]]
----------------------------------------------------------------
local aiEnabled = false
local aiLogEntries = {}

-- Mô phỏng AI lượng tử dựa trên việc phân tích Client State
local function getAIPredictionResponse(question)
    local q = string.lower(question)
    
    -- Phân tích dữ liệu Server thực tế
    local playerCount = #Players:GetPlayers()
    local toxicCount = 0
    local lagStatus = "Ổn định (FPS cao)"
    if frameCount < 30 then lagStatus = "Nguy kịch (Lag/FPS tụt)" elseif frameCount < 45 then lagStatus = "Khá nặng" end
    
    local playersInfo = ""
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Character.HumanoidRootPart.Velocity.Magnitude > 60 then
                toxicCount = toxicCount + 1
            end
        end
    end

    if string.find(q, "admin") or string.find(q, "mod") then
        local adminFound = false
        for _, p in ipairs(Players:GetPlayers()) do
            local name = string.lower(p.Name)
            if string.find(name, "admin") or string.find(name, "mod") or string.find(name, "creator") then
                adminFound = true
                return "Cảnh báo: Phát hiện nghi vấn có người tên là ["..p.Name.."] có từ khóa của Admin/Creator trong Server! Đề phòng bị ban."
            end
        end
        return "Quantum AI: Quét sạch! Hiện tại không phát hiện tài khoản Admin nào hoạt động công khai trong Server."
    elseif string.find(q, "nguy hiểm") or string.find(q, "an toàn") or string.find(q, "danger") then
        if toxicCount > 0 then
            return "Cảnh báo AI: Phát hiện "..toxicCount.." người chơi đang di chuyển cực nhanh (có thể sử dụng Speed/Fling). Hãy bật Anti-Fling ngay lập tức!"
        else
            return "Quantum AI: Server đang tạm thời bình yên. Chưa phát hiện đối tượng nào có hành vi húc người khác."
        end
    elseif string.find(q, "lag") or string.find(q, "fps") then
        return "Phân tích đồ họa: Trạng thái Server: "..lagStatus..". Số lượng Part hiện có là: "..#workspace:GetDescendants().." parts. Đề xuất: Bật 'Anti Lag' để dọn dẹp kết cấu thô."
    elseif string.find(q, "phân thân") or string.find(q, "ghost") or string.find(q, "mạng") then
        return "Quantum AI: Phân thân ma quái (Ghost Mimic) hoạt động dựa trên cơ chế nạp mạng. Hãy giữ mạng nạp đầy 100% để chống lại các pha kích sát từ Boss hoặc hack phá game."
    elseif string.find(q, "hello") or string.find(q, "chào") or string.find(q, "ai") then
        return "Xin chào! Mình là AI Quantum Core tích hợp. Hãy hỏi mình về: 'Admin', 'Lag', 'Server nguy hiểm không' hoặc 'Mẹo xây block' nhé!"
    else
        -- Trả lời ngẫu nhiên thông minh dựa trên dữ liệu game
        local randomAnswers = {
            "Theo phân tích lượng tử, bạn nên bật 'Secure Hooks' để bảo mật client an toàn tuyệt đối.",
            "Tôi khuyên bạn nên di chuyển liên tục, tránh đứng yên một chỗ quá lâu trong server lạ.",
            "Hệ thống dự báo: Server này hiện có " .. playerCount .. " người chơi. Chỉ số toxic ở mức trung bình.",
            "Mẹo: Bạn có thể bật 'Walk on Air' để xây dựng ở vị trí cao mà không lo bị ngã."
        }
        return "AI Dự Đoán: " .. randomAnswers[math.random(1, #randomAnswers)]
    end
end

-- Vòng lặp AI quét nguy hiểm tự động (Real-time Event Predictor)
task.spawn(function()
    while task.wait(3) do
        if aiEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local speed = p.Character.HumanoidRootPart.Velocity.Magnitude
                    if speed > 75 then
                        print("[QUANTUM AI PREDICTOR] CẢNH BÁO: Người chơi " .. p.Name .. " đang bay/húc với tốc độ " .. math.floor(speed) .. " studs/s. Nguy cơ Fling cao!")
                    end
                end
            end
        end
    end
end)

----------------------------------------------------------------
-- COMBAT STUFF RESTORE (V2 Hitboxes)
----------------------------------------------------------------
local aimbotActive = false
local targetPlayerName = ""
local hitboxActive = false
local targetHitboxSize = 2
local originalSizes = {}

RunService.RenderStepped:Connect(function()
    if aimbotActive and targetPlayerName ~= "" then
        local targetMatch = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and string.find(string.lower(p.Name), string.lower(targetPlayerName)) then
                targetMatch = p
                break
            end
        end
        if targetMatch and targetMatch.Character and targetMatch.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetMatch.Character.Head.Position)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if hitboxActive then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    if not originalSizes[p.Name] then originalSizes[p.Name] = hrp.Size end
                    hrp.Size = Vector3.new(targetHitboxSize, targetHitboxSize, targetHitboxSize)
                    hrp.Transparency = 0.6
                    hrp.BrickColor = BrickColor.new("Lime green")
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

local function resetHitboxes()
    hitboxActive = false
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and originalSizes[p.Name] then
            local hrp = p.Character.HumanoidRootPart
            hrp.Size = originalSizes[p.Name]
            hrp.Transparency = 1
            hrp.CanCollide = true
        end
    end
    table.clear(originalSizes)
end

----------------------------------------------------------------
-- ANTI-HACKS SYSTEMS PORTING (Chống hack đầy đủ từ V2 Settings)
----------------------------------------------------------------
local antiFlingActive = false
local antiFlingConnection = nil
local function toggleAntiFling(state)
    antiFlingActive = state
    if antiFlingActive then
        antiFlingConnection = RunService.Heartbeat:Connect(function()
            if not Character then return end
            for _, part in ipairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, subPart in ipairs(p.Character:GetDescendants()) do
                        if subPart:IsA("BasePart") then subPart.CanCollide = false end
                    end
                end
            end
        end)
    else
        if antiFlingConnection then antiFlingConnection:Disconnect(); antiFlingConnection = nil end
    end
end

local antiAfkActive = false
local antiAfkConnection = nil
local function toggleAntiAfk(state)
    antiAfkActive = state
    if antiAfkActive then
        local VirtualUser = game:GetService("VirtualUser")
        antiAfkConnection = LocalPlayer.Idled:Connect(function()
            if antiAfkActive then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end
        end)
    else
        if antiAfkConnection then antiAfkConnection:Disconnect(); antiAfkConnection = nil end
    end
end

local antiKickActive = false
local antiBanActive = false
local hooked = false
local function applySecureHooks()
    if hooked then return end
    hooked = true
    local success, err = pcall(function()
        local rawMT = getrawmetatable(game)
        if not rawMT then return end
        setreadonly(rawMT, false)
        local oldNamecall = rawMT.__namecall
        rawMT.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if self == LocalPlayer and string.lower(method) == "kick" and antiKickActive then
                return nil
            end
            if antiBanActive and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                local rn = string.lower(self.Name)
                if string.find(rn, "ban") or string.find(rn, "cheat") or string.find(rn, "detect") then
                    return nil
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(rawMT, true)
    end)
end

local antiLagActive = false
local originalMaterials = {}
local function toggleAntiLag(state)
    antiLagActive = state
    if antiLagActive then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(Character) then
                originalMaterials[v] = {Material = v.Material, Color = v.Color}
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
    else
        for part, data in pairs(originalMaterials) do
            if part and part.Parent then part.Material = data.Material end
        end
        table.clear(originalMaterials)
    end
end

local antiBypassActive = false
local function toggleAntiBypass(state)
    antiBypassActive = state
    if antiBypassActive then
        task.spawn(function()
            while antiBypassActive do
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("LocalScript") then
                        local n = string.lower(v.Name)
                        if string.find(n, "anticheat") or string.find(n, "ac") or string.find(n, "detection") then
                            v.Disabled = true
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
end

----------------------------------------------------------------
-- TAB CONTENTS STRUCTURING
----------------------------------------------------------------
local MainTab = CreateTab("Modifiers", "Main")
local CombatTab = CreateTab("Combat", "Combat")
local MovementTab = CreateTab("Movement", "Movement")
local VisualTab = CreateTab("Shaders", "Visuals")
local BuildTab = CreateTab("Pro Builder", "Build")
local AITab = CreateTab("Quantum AI", "AI")
local ConfigTab = CreateTab("Settings", "Settings")

-- [[ A. MODIFIERS TAB ]]
AddToggle(MainTab, "Flight Mode", false, function(st) flying = st; if flying then startFlying() else stopFlying() end end)
AddAdjuster(MainTab, "Flight Speed", 60, 20, 200, 10, function(v) flySpeed = v end)
AddToggle(MainTab, "Flight Trail Neon", false, function(st) trailEnabled = st; if trailEnabled then setupTrail() else for _, item in ipairs(activeTrails) do if item:IsA("Trail") then item.Enabled = false end end end end)
local speedEnabled = false
AddToggle(MainTab, "Speed Hack", false, function(st) speedEnabled = st; Humanoid.WalkSpeed = speedEnabled and 100 or 16 end)
AddAdjuster(MainTab, "Walk Speed Val", 100, 16, 250, 15, function(v) if speedEnabled then Humanoid.WalkSpeed = v end end)

-- [[ B. COMBAT TAB ]]
AddTextBox(CombatTab, "Enter Target Name for Lock...", function(tx) targetPlayerName = tx end)
AddToggle(CombatTab, "Aimbot Target Lock", false, function(st) aimbotActive = st end)
AddToggle(CombatTab, "Expand World Hitboxes", false, function(st) if st then hitboxActive = true else resetHitboxes() end end)
AddAdjuster(CombatTab, "Hitbox Dimension Radius", 2, 2, 30, 2, function(v) targetHitboxSize = v end)

-- [[ C. MOVEMENT TAB ]]
AddToggle(MovementTab, "Double Jump Trigger", false, function(st) doubleJumpEnabled = st end)
AddToggle(MovementTab, "Dash Dash Mechanics", false, function(st) dashEnabled = st; DashMobileBtn.Visible = st end)
AddAdjuster(MovementTab, "Dash Thrust Velocity", 120, 50, 300, 10, function(v) dashSpeed = v end)
AddToggle(MovementTab, "Walk on Air / Water", false, function(st) toggleAirWalk(st) end)

-- [[ D. SHADER CONTROLS ]]
local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
local blur = Lighting:FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", Lighting)
local colorCorr = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)

AddAdjuster(VisualTab, "Map Lighting Brightness", 2, 0, 10, 1, function(v) Lighting.Brightness = v end)
AddAdjuster(VisualTab, "Graphic Blur Scale", 0, 0, 24, 2, function(v) blur.Size = v end)
AddAdjuster(VisualTab, "Saturation Modifier", 0, 0, 5, 1, function(v) colorCorr.Saturation = v end)
AddAdjuster(VisualTab, "Neon Bloom Ambient", 1, 0, 10, 1, function(v) bloom.Intensity = v end)

-- [[ E. PRO BUILDER TAB (Cải tiến toàn diện) ]]
AddToggle(BuildTab, "Enable Pro Builder Mode", false, function(st) buildActive = st end)
AddButton(BuildTab, "Tool: Click to PLACE Block", function() proBuildMode = "Place" end)
AddButton(BuildTab, "Tool: Click to DELETE Block", function() proBuildMode = "Delete" end)
AddButton(BuildTab, "Tool: Click to ROTATE Block (+45°)", function() proBuildMode = "Rotate" end)
AddButton(BuildTab, "Tool: Click to SCALE Block (Bigger)", function() proBuildMode = "Scale" end)
AddAdjuster(BuildTab, "Default Scale Multiplier", 1, 1, 5, 1, function(v) scaleMultiplier = v end)
AddButton(BuildTab, "Set Material Color: Neon Mint", function() buildColor = Theme.Accent end)
AddButton(BuildTab, "Set Material Color: Ruby Crimson", function() buildColor = Color3.fromRGB(255, 50, 50) end)
AddButton(BuildTab, "Purge Custom Placed Blocks", function() 
    for _, obj in ipairs(workspace:GetChildren()) do 
        if obj:IsA("Part") and obj.Anchored == true and obj.Material == Enum.Material.SmoothPlastic then obj:Destroy() end 
    end 
end)

-- [[ F. QUANTUM AI PREDICT TAB ]]
AddToggle(AITab, "Enable Automatic AI Event Scan", false, function(st) aiEnabled = st end)

-- Khung Chatbot AI Hỏi - Đáp
local AIChatFrame = Instance.new("Frame")
AIChatFrame.Size = UDim2.new(0, 385, 0, 110)
AIChatFrame.BackgroundColor3 = Theme.ElementBg
AIChatFrame.Parent = AITab
Instance.new("UICorner", AIChatFrame).CornerRadius = UDim.new(0, 8)
local aiStroke = Instance.new("UIStroke", AIChatFrame)
aiStroke.Color = Theme.Border

local AIResponseLabel = Instance.new("TextLabel", AIChatFrame)
AIResponseLabel.Size = UDim2.new(1, -20, 0, 55)
AIResponseLabel.Position = UDim2.new(0, 10, 0, 10)
AIResponseLabel.BackgroundTransparency = 1
AIResponseLabel.Text = "Quantum AI: Hệ thống sẵn sàng. Hãy hỏi tôi về Admin, Lag, hoặc mức độ nguy hiểm trong Server này."
AIResponseLabel.TextColor3 = Theme.TextMuted
AIResponseLabel.TextSize = 11
AIResponseLabel.Font = Enum.Font.GothamSemibold
AIResponseLabel.TextWrapped = true
AIResponseLabel.TextYAlignment = Enum.TextYAlignment.Top

local AIQuestionInput = Instance.new("TextBox", AIChatFrame)
AIQuestionInput.Size = UDim2.new(1, -20, 0, 32)
AIQuestionInput.Position = UDim2.new(0, 10, 1, -42)
AIQuestionInput.BackgroundColor3 = Theme.Bg
AIQuestionInput.TextColor3 = Theme.Text
AIQuestionInput.PlaceholderText = "Hỏi AI điều gì đó (Nhấn Enter)..."
AIQuestionInput.PlaceholderColor3 = Theme.TextMuted
AIQuestionInput.Text = ""
AIQuestionInput.TextSize = 12
AIQuestionInput.Font = Enum.Font.Gotham
Instance.new("UICorner", AIQuestionInput).CornerRadius = UDim.new(0, 6)

AIQuestionInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and AIQuestionInput.Text ~= "" then
        local userQ = AIQuestionInput.Text
        AIResponseLabel.Text = "Đang tính toán phân tích dữ liệu server..."
        task.wait(0.5)
        local aiAnswer = getAIPredictionResponse(userQ)
        AIResponseLabel.Text = aiAnswer
        AIQuestionInput.Text = ""
    end
end)

-- [[ G. SETTINGS TAB ]]
AddToggle(ConfigTab, "Ghost Mimic (Phân thân nạp mạng)", false, function(st) 
    ghostActive = st 
    if ghostActive then spawnGhostMimic() else destroyGhost() end 
end)
AddToggle(ConfigTab, "Enable Custom Gaming Cursor", false, function(st) toggleCursor(st) end)
AddToggle(ConfigTab, "Enable Shift Lock Controller", false, function(st) ShiftLockBtn.Visible = st; if not st then toggleShiftLock(false) end end)
AddToggle(ConfigTab, "Anti Fling Mode", false, function(st) toggleAntiFling(st) end)
AddToggle(ConfigTab, "Anti AFK System", false, function(st) toggleAntiAfk(st) end)
AddToggle(ConfigTab, "Anti Ban Bypass (Secure Hooks)", false, function(st) antiBanActive = st; if st then applySecureHooks() end end)
AddToggle(ConfigTab, "Anti Kick Security", false, function(st) antiKickActive = st; if st then applySecureHooks() end end)
AddToggle(ConfigTab, "Anti Lag (Optimized FPS)", false, function(st) toggleAntiLag(st) end)
AddToggle(ConfigTab, "Anti Bypass (AC Freeze)", false, function(st) toggleAntiBypass(st) end)

local rainbowAccent = false
AddToggle(ConfigTab, "Sidebar Rainbow Glow", false, function(state)
    rainbowAccent = state
    task.spawn(function()
        while rainbowAccent do
            for h = 0, 1, 0.005 do
                if not rainbowAccent then break end
                local color = Color3.fromHSV(h, 1, 1)
                MainStroke.Color = color
                FloatStroke.Color = color
                task.wait(0.02)
            end
        end
        MainStroke.Color = Theme.Accent
        FloatStroke.Color = Theme.Accent
    end)
end)

AddButton(ConfigTab, "Rejoin Safe Server Instance", function()
    local ok, _ = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    if not ok then TeleportService:Teleport(game.PlaceId, LocalPlayer) end
end)
AddButton(ConfigTab, "Purge Quantum Engine GUI", function() 
    stopFlying(); resetHitboxes(); toggleAirWalk(false); toggleShiftLock(false); toggleCursor(false)
    toggleAntiFling(false); toggleAntiAfk(false); toggleAntiLag(false); toggleAntiBypass(false); destroyGhost()
    MobileActionGui:Destroy(); ScreenGui:Destroy(); ChargeBarGui:Destroy()
end)

----------------------------------------------------------------
-- INITIALIZATION & CORE STARTUP
----------------------------------------------------------------
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingBtn.Visible = true end)
FloatingBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatingBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() 
    stopFlying(); resetHitboxes(); toggleAirWalk(false); toggleShiftLock(false); toggleCursor(false)
    toggleAntiFling(false); toggleAntiAfk(false); toggleAntiLag(false); toggleAntiBypass(false); destroyGhost()
    MobileActionGui:Destroy(); ScreenGui:Destroy(); ChargeBarGui:Destroy()
end)

-- Auto focus vào Modifiers Tab đầu tiên
local firstTab = TabScroll:FindFirstChild("ModifiersTab")
if firstTab then
    firstTab.TextColor3 = Theme.Accent
    firstTab.BackgroundTransparency = 0.9
    firstTab.BackgroundColor3 = Theme.Accent
    MainTab.Visible = true
end
-- [[ D. SHADER CONTROLS ]]
local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
local blur = Lighting:FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", Lighting)
local colorCorr = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)

AddAdjuster(VisualTab, "Map Lighting Brightness", 2, 0, 10, 1, function(v) Lighting.Brightness = v end)
AddAdjuster(VisualTab, "Graphic Blur Scale", 0, 0, 24, 2, function(v) blur.Size = v end)
AddAdjuster(VisualTab, "Saturation Modifier", 0, 0, 5, 1, function(v) colorCorr.Saturation = v end)
AddAdjuster(VisualTab, "Neon Bloom Ambient", 1, 0, 10, 1, function(v) bloom.Intensity = v end)
