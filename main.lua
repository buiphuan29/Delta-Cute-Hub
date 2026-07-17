-- [[ QUANTUM CORE PREMIUM HUB V2 - ANTI & CLONE UPDATE ]] --
-- Fixed UI Positioning, Custom Cursor, Shift Lock, Dash, Double Jump, Clone Guard & Anti-Cheats

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

-- Main Window (Sửa lỗi layout, thiết kế sang xịn mịn hơn)
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
Title.Text = "QUANTUM CORE V2"
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
-- SIDEBAR (ĐÃ FIX: Đưa User Card lên đầu để không bị đè nút)
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

-- USER CARD (Tuyệt đối nằm trên cùng, an toàn và trực quan)
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

-- Cuộn Tab ở phía dưới
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
        local center = Instance.new("Frame", iconFrame)
        center.Size = UDim2.new(0, 4, 0, 4)
        center.Position = UDim2.new(0.5, -2, 0.5, -2)
        center.BackgroundColor3 = Theme.TextMuted
        Instance.new("UICorner", center).CornerRadius = UDim.new(1, 0)
    elseif iconType == "Visuals" then
        local line = Instance.new("Frame", iconFrame)
        line.Size = UDim2.new(1, 0, 0, 2)
        line.Position = UDim2.new(0, 0, 0.5, -1)
        line.BackgroundColor3 = Theme.TextMuted
        local block = Instance.new("Frame", iconFrame)
        block.Size = UDim2.new(0, 6, 0, 10)
        block.Position = UDim2.new(0.2, 0, 0.5, -5)
        block.BackgroundColor3 = Theme.TextMuted
    elseif iconType == "Build" then
        local box = Instance.new("Frame", iconFrame)
        box.Size = UDim2.new(1, 0, 0.7, 0)
        box.Position = UDim2.new(0, 0, 0.15, 0)
        box.BackgroundTransparency = 1
        local st = Instance.new("UIStroke", box)
        st.Color = Theme.TextMuted
        st.Thickness = 1.5
    elseif iconType == "Movement" then
        local wingLeft = Instance.new("Frame", iconFrame)
        wingLeft.Size = UDim2.new(0, 2, 0, 10)
        wingLeft.Position = UDim2.new(0.3, 0, 0.2, 0)
        wingLeft.Rotation = 35
        wingLeft.BackgroundColor3 = Theme.TextMuted
        local wingRight = Instance.new("Frame", iconFrame)
        wingRight.Size = UDim2.new(0, 2, 0, 10)
        wingRight.Position = UDim2.new(0.7, -2, 0.2, 0)
        wingRight.Rotation = -35
        wingRight.BackgroundColor3 = Theme.TextMuted
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
-- TABS SCHEMATICS
----------------------------------------------------------------
local function CreateTab(name, vectorType)
    local TabButton = Instance.new("TextButton")
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
-- INTERFACE CORE GENERATORS
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
-- GAME MECHANICS ENGINES
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

-- 2. Fly & Trail Engine
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
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 128)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    trail.LightEmission = 1
    trail.LightInfluence = 0
    trail.Lifetime = 0.6
    trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.2),
        NumberSequenceKeypoint.new(1, 0)
    })
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

    if trailEnabled then
        setupTrail()
        for _, item in ipairs(activeTrails) do if item:IsA("Trail") then item.Enabled = true end end
    end

    task.spawn(function()
        while flying and Character and RootPart do
            local camera = workspace.CurrentCamera
            local moveDir = Humanoid.MoveDirection
            local flyDir = Vector3.new(0,0,0)
            if moveDir.Magnitude > 0 then
                local rawDir = camera.CFrame:VectorToObjectSpace(moveDir)
                local direction = (camera.CFrame.LookVector * -rawDir.Z) + (camera.CFrame.RightVector * rawDir.X)
                if direction.Magnitude > 0 then flyDir = direction.Unit end
            end
            bv.Velocity = flyDir * flySpeed
            if flyDir.Magnitude > 0 then
                bg.CFrame = CFrame.lookAt(RootPart.Position, RootPart.Position + flyDir) * CFrame.Angles(math.rad(-60), 0, 0)
            else
                bg.CFrame = CFrame.new(RootPart.Position) * camera.CFrame.Rotation
            end
            task.wait()
        end
    end)
end

local function stopFlying()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if Humanoid then Humanoid.PlatformStand = false end
    for _, item in ipairs(activeTrails) do if item:IsA("Trail") then item.Enabled = false end end
end

-- 3. Walk & Air Platform Logic
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

-- 4. Double Jump Engine
local doubleJumpEnabled = false
local hasDoubleJumped = false

local function initDoubleJump()
    UserInputService.JumpRequest:Connect(function()
        if not doubleJumpEnabled then return end
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall and not hasDoubleJumped then
            hasDoubleJumped = true
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, Humanoid.JumpPower * 1.2, RootPart.Velocity.Z)
        end
    end)
    Humanoid.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed then
            hasDoubleJumped = false
        end
    end)
end

-- 5. Dash Mechanics Engine
local dashEnabled = false
local canDash = true
local dashSpeed = 120
local dashCooldown = 1.5

local function performDash()
    if not dashEnabled or not canDash or not Character or not RootPart then return end
    canDash = false
    
    local moveDirection = Humanoid.MoveDirection
    if moveDirection.Magnitude == 0 then
        moveDirection = RootPart.CFrame.LookVector
    end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 0, 1e5)
    bodyVelocity.Velocity = moveDirection * dashSpeed
    bodyVelocity.Parent = RootPart

    task.spawn(function()
        task.wait(0.2)
        bodyVelocity:Destroy()
        task.wait(dashCooldown)
        canDash = true
    end)
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        performDash()
    end
end)

-- Mobile Dash UI
local MobileActionGui = Instance.new("ScreenGui")
MobileActionGui.Name = "QuantumMobileActions"
MobileActionGui.ResetOnSpawn = false
MobileActionGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local DashMobileBtn = Instance.new("TextButton")
DashMobileBtn.Size = UDim2.new(0, 50, 0, 50)
DashMobileBtn.Position = UDim2.new(0.8, 0, 0.55, 0)
DashMobileBtn.BackgroundColor3 = Theme.ElementBg
DashMobileBtn.Text = "DASH"
DashMobileBtn.TextColor3 = Theme.Accent
DashMobileBtn.TextSize = 11
DashMobileBtn.Font = Enum.Font.GothamBold
DashMobileBtn.Visible = false
DashMobileBtn.Parent = MobileActionGui
Instance.new("UICorner", DashMobileBtn).CornerRadius = UDim.new(1, 0)
local dashStroke = Instance.new("UIStroke", DashMobileBtn)
dashStroke.Color = Theme.Accent
dashStroke.Thickness = 1.5

DashMobileBtn.MouseButton1Click:Connect(performDash)

-- 6. Shift Lock Custom System
local shiftLockEnabled = false
local slConnection = nil

local ShiftLockBtn = Instance.new("TextButton")
ShiftLockBtn.Size = UDim2.new(0, 50, 0, 50)
ShiftLockBtn.Position = UDim2.new(0.8, 0, 0.45, 0)
ShiftLockBtn.BackgroundColor3 = Theme.ElementBg
ShiftLockBtn.Text = "LOCK"
ShiftLockBtn.TextColor3 = Theme.TextMuted
ShiftLockBtn.TextSize = 10
ShiftLockBtn.Font = Enum.Font.GothamBold
ShiftLockBtn.Visible = false
ShiftLockBtn.Parent = MobileActionGui
Instance.new("UICorner", ShiftLockBtn).CornerRadius = UDim.new(1, 0)
local slStroke = Instance.new("UIStroke", ShiftLockBtn)
slStroke.Color = Theme.Border

local function toggleShiftLock(state)
    shiftLockEnabled = state
    if shiftLockEnabled then
        ShiftLockBtn.TextColor3 = Theme.Accent
        slStroke.Color = Theme.Accent
        slConnection = RunService.RenderStepped:Connect(function()
            if Character and RootPart then
                Camera.CameraType = Enum.CameraType.Scriptable
                local camRotation = Camera.CFrame.Rotation
                Camera.CFrame = CFrame.new(RootPart.Position + Vector3.new(0, 2.5, 0)) * camRotation * CFrame.new(2.5, 0, 10)
                RootPart.CFrame = CFrame.lookAt(RootPart.Position, RootPart.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z))
            end
        end)
    else
        ShiftLockBtn.TextColor3 = Theme.TextMuted
        slStroke.Color = Theme.Border
        if slConnection then slConnection:Disconnect(); slConnection = nil end
        Camera.CameraType = Enum.CameraType.Custom
    end
end

ShiftLockBtn.MouseButton1Click:Connect(function()
    toggleShiftLock(not shiftLockEnabled)
end)

-- 7. Cursor Changer
local cursorEnabled = false
local customCursorUrl = "rbxassetid://13214539130"
local originalCursor = ""

local function toggleCursor(state)
    cursorEnabled = state
    if cursorEnabled then
        originalCursor = UserInputService.MouseIcon
        UserInputService.MouseIcon = customCursorUrl
    else
        UserInputService.MouseIcon = originalCursor
    end
end

-- 8. Combat (Aimbot & Hitbox)
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
    while task.wait(0.8) do
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

-- 9. World Builder Block Placer
local buildActive = false
local blockColor = Theme.Accent

UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not buildActive then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local ray = Camera:ScreenPointToRay(input.Position.X, input.Position.Y)
        local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 500)
        
        if raycastResult then
            local p = Instance.new("Part")
            p.Size = Vector3.new(4, 4, 4)
            p.Position = raycastResult.Position + (raycastResult.Normal * 2)
            p.Color = blockColor
            p.Material = Enum.Material.SmoothPlastic
            p.Anchored = true
            p.Parent = workspace
        end
    end
end)

----------------------------------------------------------------
-- [[ NEW UPDATE: PREMIUM SECURITY & ADVANCED SYSTEMS ]]
----------------------------------------------------------------

-- A. CLONE FLING GUARD ENGINE (Phân Thân Bảo Vệ + Fling Kẻ Địch)
local cloneActive = false
local currentClone = nil

local function destroyClone()
    if currentClone then
        currentClone:Destroy()
        currentClone = nil
    end
end

local function spawnCloneGuard()
    destroyClone()
    if not Character or not RootPart then return end
    
    Character.Archivable = true
    local clone = Character:Clone()
    Character.Archivable = false
    clone.Name = "QuantumProtector_Clone"
    clone.Parent = workspace
    currentClone = clone

    -- Thiết lập ngoại hình Neon cho Clone
    for _, part in ipairs(clone:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Color = Theme.Accent
            part.Material = Enum.Material.Neon
            part.CanCollide = false
        elseif part:IsA("LocalScript") or part:IsA("Script") then
            part:Destroy() -- Xóa Script gốc tránh gây lỗi
        end
    end

    local cRoot = clone:FindFirstChild("HumanoidRootPart")
    local cHum = clone:FindFirstChildOfClass("Humanoid")
    if not cRoot or not cHum then return end

    -- Gắn các chuyển động xoay siêu tốc để tạo lực đẩy FLING mạnh mẽ
    local bodyAngular = Instance.new("BodyAngularVelocity")
    bodyAngular.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyAngular.AngularVelocity = Vector3.new(0, 20000, 0) -- Xoay cực mạnh để Fling
    bodyAngular.Parent = cRoot

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = cRoot

    task.spawn(function()
        while cloneActive and clone and clone.Parent do
            if RootPart and Character then
                local playerPos = RootPart.Position
                local clonePos = cRoot.Position
                local distanceToPlayer = (clonePos - playerPos).Magnitude

                -- Tìm đối thủ gần nhất để húc bay (Fling)
                local nearestEnemy = nil
                local shortestDistance = 35 -- Khoảng cách bảo vệ (Studs)

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local enemyRoot = p.Character.HumanoidRootPart
                        local dist = (enemyRoot.Position - playerPos).Magnitude
                        if dist < shortestDistance then
                            nearestEnemy = enemyRoot
                            shortestDistance = dist
                        end
                    end
                end

                if nearestEnemy then
                    -- Lao Clone thẳng vào đối thủ
                    cHum:MoveTo(nearestEnemy.Position)
                    bodyVelocity.Velocity = (nearestEnemy.Position - clonePos).Unit * 120
                    
                    -- Khi chạm trúng đối thủ, kích hoạt lực Fling cực mạnh
                    cRoot.Touched:Connect(function(hit)
                        local enemyChar = hit.Parent
                        if enemyChar and enemyChar ~= Character and enemyChar ~= clone then
                            local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
                            if enemyRoot then
                                -- Áp lực ném cực mạnh đẩy thẳng lên trời và ra xa
                                enemyRoot.Velocity = Vector3.new(math.random(-5000, 5000), 50000, math.random(-5000, 5000))
                            end
                        end
                    end)
                else
                    -- Đi tuần tra xung quanh bảo vệ người chơi
                    if distanceToPlayer > 8 then
                        cHum:MoveTo(playerPos + Vector3.new(math.random(-4, 4), 0, math.random(-4, 4)))
                    end
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end
            task.wait(0.1)
        end
        destroyClone()
    end)
end

-- B. ANTI FLING (Chống bị hất văng)
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
            -- Tắt va chạm vật lý tạm thời với tất cả người chơi khác
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, subPart in ipairs(p.Character:GetDescendants()) do
                        if subPart:IsA("BasePart") then
                            subPart.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        if antiFlingConnection then antiFlingConnection:Disconnect(); antiFlingConnection = nil end
    end
end

-- C. ANTI AFK (Chống treo máy bị Kick)
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

-- D. ANTI KICK & ANTI BAN BYPASS (Bảo vệ Client dùng Metatable Hooking)
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
            local args = {...}
            
            -- Chống Kick từ Script Cục bộ
            if self == LocalPlayer and string.lower(method) == "kick" and antiKickActive then
                return nil -- Chặn đứng hành vi Kick
            end
            
            -- Chống Ban (Bypass Remote Signals chuyên dụng)
            if antiBanActive and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                local remoteName = string.lower(self.Name)
                if string.find(remoteName, "ban") or string.find(remoteName, "kick") or string.find(remoteName, "cheat") or string.find(remoteName, "detect") then
                    return nil -- Chặn không gửi gói tin nghi vấn về Server
                end
            end
            
            return oldNamecall(self, ...)
        end)
        setreadonly(rawMT, true)
    end)
end

-- E. ANTI LAG (Hỗ trợ máy yếu tăng FPS)
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
            if part and part.Parent then
                part.Material = data.Material
            end
        end
        table.clear(originalMaterials)
    end
end

-- F. ANTI BYPASS (Chặn quét Anti-Cheat cục bộ)
local antiBypassActive = false
local function toggleAntiBypass(state)
    antiBypassActive = state
    if antiBypassActive then
        task.spawn(function()
            while antiBypassActive do
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("LocalScript") then
                        local name = string.lower(v.Name)
                        if string.find(name, "anticheat") or string.find(name, "ac") or string.find(name, "bypass") or string.find(name, "detection") then
                            v.Disabled = true -- Vô hiệu hóa script quét
                        end
                    end
                end
                task.wait(1.5)
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
local BuildTab = CreateTab("Builder", "Build")
local ConfigTab = CreateTab("Settings", "Settings")

-- [[ A. MAIN TAB MODIFIERS ]]
AddToggle(MainTab, "Flight Mode", false, function(st) flying = st; if flying then startFlying() else stopFlying() end end)
AddAdjuster(MainTab, "Flight Speed", 60, 20, 200, 10, function(v) flySpeed = v end)
AddToggle(MainTab, "Flight Trail Neon", false, function(st)
    trailEnabled = st
    if trailEnabled then setupTrail() else
        for _, item in ipairs(activeTrails) do if item:IsA("Trail") then item.Enabled = false end end
    end
end)
local speedEnabled = false
AddToggle(MainTab, "Speed Hack", false, function(st)
    speedEnabled = st
    Humanoid.WalkSpeed = speedEnabled and 100 or 16
end)
AddAdjuster(MainTab, "Walk Speed Val", 100, 16, 250, 15, function(v)
    if speedEnabled then Humanoid.WalkSpeed = v end
end)

-- [[ B. COMBAT TAB ]]
AddToggle(CombatTab, "Clone Protect Guard (Fling)", false, function(st)
    cloneActive = st
    if cloneActive then spawnCloneGuard() else destroyClone() end
end)
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

-- [[ E. BUILDER TAB ]]
AddToggle(BuildTab, "Raycast Core Placement", false, function(st) buildActive = st end)
AddButton(BuildTab, "Set Material Color: Neon Mint", function() blockColor = Theme.Accent end)
AddButton(BuildTab, "Set Material Color: Ruby Crimson", function() blockColor = Color3.fromRGB(255, 50, 50) end)
AddButton(BuildTab, "Purge Custom Placed Blocks", function() 
    for _, obj in ipairs(workspace:GetChildren()) do 
        if obj:IsA("Part") and obj.Size == Vector3.new(4, 4, 4) and obj.Anchored == true then obj:Destroy() end 
    end 
end)

-- [[ F. SETTINGS TAB (ĐÃ THÊM CÁC TÍNH NĂNG CHỐNG HACK) ]]
AddToggle(ConfigTab, "Enable Custom Gaming Cursor", false, function(st) toggleCursor(st) end)
AddToggle(ConfigTab, "Enable Shift Lock Controller", false, function(st) ShiftLockBtn.Visible = st; if not st then toggleShiftLock(false) end end)
AddToggle(ConfigTab, "Anti Fling Mode", false, function(st) toggleAntiFling(st) end)
AddToggle(ConfigTab, "Anti AFK System", false, function(st) toggleAntiAfk(st) end)
AddToggle(ConfigTab, "Anti Ban (Secure Hooks)", false, function(st) antiBanActive = st; if st then applySecureHooks() end end)
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
    toggleAntiFling(false); toggleAntiAfk(false); toggleAntiLag(false); toggleAntiBypass(false); destroyClone()
    MobileActionGui:Destroy(); ScreenGui:Destroy() 
end)

----------------------------------------------------------------
-- INITIALIZATION & CORE STARTUP
----------------------------------------------------------------
initDoubleJump()

MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingBtn.Visible = true end)
FloatingBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatingBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() 
    stopFlying(); resetHitboxes(); toggleAirWalk(false); toggleShiftLock(false); toggleCursor(false)
    toggleAntiFling(false); toggleAntiAfk(false); toggleAntiLag(false); toggleAntiBypass(false); destroyClone()
    MobileActionGui:Destroy(); ScreenGui:Destroy() 
end)

-- Focus vào Modifiers đầu tiên
local firstTab = TabScroll:FindFirstChild("ModifiersTab")
if firstTab then
    firstTab.TextColor3 = Theme.Accent
    firstTab.BackgroundTransparency = 0.9
    firstTab.BackgroundColor3 = Theme.Accent
    MainTab.Visible = true
    for _, sub in ipairs(firstTab:FindFirstChild("Frame"):GetChildren()) do
        if sub:IsA("Frame") then sub.BackgroundColor3 = Theme.Accent end
    end
end

