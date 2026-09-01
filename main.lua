-- Services
local function getService(name)
    local service = game:GetService(name)
    return (cloneref and cloneref(service)) or service
end

local Players = getService("Players")
local VirtualInputManager = getService("VirtualInputManager")
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local CoreGui = getService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Global Variables
local autoClicking = false
local clickDelay = 0.1
local toggleKey = Enum.KeyCode.E
local isMinimized = false

-- Main ScreenGui Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerHub_" .. math.random(1000, 9999)
screenGui.ResetOnSpawn = false

-- Safe GUI Parent
if gethui then
    screenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(screenGui)
    screenGui.Parent = CoreGui
else
    local success, _ = pcall(function() screenGui.Parent = CoreGui end)
    if not success then
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- Toast Notification Container (Góc dưới bên phải)
local toastHolder = Instance.new("Frame")
toastHolder.Name = "ToastHolder"
toastHolder.Size = UDim2.new(0, 220, 1, -20)
toastHolder.Position = UDim2.new(1, -230, 0, 10)
toastHolder.BackgroundTransparency = 1
toastHolder.Parent = screenGui

local toastLayout = Instance.new("UIListLayout")
toastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
toastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
toastLayout.SortOrder = Enum.SortOrder.LayoutOrder
toastLayout.Padding = UDim.new(0, 8)
toastLayout.Parent = toastHolder

-- Function tạo Toast Notification
local function showToast(titleText, messageText, accentColor)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(1, 0, 0, 45)
    toast.Position = UDim2.new(1, 240, 0, 0) -- Xuất hiện từ ngoài màn hình
    toast.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    toast.BorderSizePixel = 0
    toast.ClipsDescendants = true
    toast.Parent = toastHolder

    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 6)
    toastCorner.Parent = toast

    -- Thanh màu đánh dấu bên trái
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 4, 1, 0)
    indicator.BackgroundColor3 = accentColor or Color3.fromRGB(0, 170, 255)
    indicator.BorderSizePixel = 0
    indicator.Parent = toast

    -- Tiêu đề
    local tTitle = Instance.new("TextLabel")
    tTitle.Size = UDim2.new(1, -15, 0, 20)
    tTitle.Position = UDim2.new(0, 12, 0, 4)
    tTitle.Text = titleText
    tTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    tTitle.TextSize = 12
    tTitle.Font = Enum.Font.GothamBold
    tTitle.BackgroundTransparency = 1
    tTitle.TextXAlignment = Enum.TextXAlignment.Left
    tTitle.Parent = toast

    -- Nội dung
    local tMsg = Instance.new("TextLabel")
    tMsg.Size = UDim2.new(1, -15, 0, 18)
    tMsg.Position = UDim2.new(0, 12, 0, 22)
    tMsg.Text = messageText
    tMsg.TextColor3 = Color3.fromRGB(180, 180, 190)
    tMsg.TextSize = 11
    tMsg.Font = Enum.Font.Gotham
    tMsg.BackgroundTransparency = 1
    tMsg.TextXAlignment = Enum.TextXAlignment.Left
    tMsg.Parent = toast

    -- Animation Trượt Vào (Slide In)
    toast.Position = UDim2.new(1, 240, 0, 0)
    local tweenIn = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    tweenIn:Play()

    -- Tự động biến mất sau 2.5 giây
    task.delay(2.5, function()
        local tweenOut = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 240, 0, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            toast:Destroy()
        end)
    end)
end

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 230, 0, 185)
frame.Position = UDim2.new(0.5, -115, 0.4, -92)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Title Bar Container
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundTransparency = 1
titleBar.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.Text = "AUTO CLICK HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Minimize/Maximize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -30, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.075, 0, 0.05, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
toggleBtn.Text = "Auto Click: OFF [" .. toggleKey.Name .. "]"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamMedium
toggleBtn.TextSize = 13
toggleBtn.Parent = contentFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

-- Speed Input Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 0, 30)
speedLabel.Position = UDim2.new(0.075, 0, 0.37, 0)
speedLabel.Text = "Delay (giây):"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.Gotham
speedLabel.BackgroundTransparency = 1
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = contentFrame

-- Speed Input Box
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.35, 0, 0, 30)
speedBox.Position = UDim2.new(0.575, 0, 0.37, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
speedBox.Text = tostring(clickDelay)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 13
speedBox.Parent = contentFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = speedBox

-- Hotkey Input Label
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.5, 0, 0, 30)
keyLabel.Position = UDim2.new(0.075, 0, 0.65, 0)
keyLabel.Text = "Phím tắt:"
keyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
keyLabel.TextSize = 13
keyLabel.Font = Enum.Font.Gotham
keyLabel.BackgroundTransparency = 1
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = contentFrame

-- Hotkey Input Box
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.35, 0, 0, 30)
keyBox.Position = UDim2.new(0.575, 0, 0.65, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
keyBox.Text = toggleKey.Name
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 13
keyBox.Parent = contentFrame

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 6)
keyBoxCorner.Parent = keyBox

-- Minimize / Maximize Logic
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        contentFrame.Visible = false
        frame:TweenSize(UDim2.new(0, 230, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        minBtn.Text = "+"
    else
        frame:TweenSize(UDim2.new(0, 230, 0, 185), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true, function()
            contentFrame.Visible = true
        end)
        minBtn.Text = "-"
    end
end)

-- Toggle State Logic + Toast Notification Call
local function updateToggleState()
    autoClicking = not autoClicking
    if autoClicking then
        toggleBtn.Text = "Auto Click: ON [" .. toggleKey.Name .. "]"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
        showToast("Auto Clicker", "Đã BẬT Auto Click (Delay: " .. clickDelay .. "s)", Color3.fromRGB(50, 200, 80))
    else
        toggleBtn.Text = "Auto Click: OFF [" .. toggleKey.Name .. "]"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
        showToast("Auto Clicker", "Đã TẮT Auto Click", Color3.fromRGB(210, 50, 50))
    end
end

toggleBtn.MouseButton1Click:Connect(updateToggleState)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == toggleKey then
            updateToggleState()
        end
    end
end)

keyBox.FocusLost:Connect(function()
    local inputStr = keyBox.Text:upper()
    local success, newKey = pcall(function() return Enum.KeyCode[inputStr] end)
    
    if success and newKey then
        toggleKey = newKey
        showToast("Phím Tắt", "Đã đổi phím tắt sang: " .. toggleKey.Name, Color3.fromRGB(0, 170, 255))
    end
    keyBox.Text = toggleKey.Name
    
    if autoClicking then
        toggleBtn.Text = "Auto Click: ON [" .. toggleKey.Name .. "]"
    else
        toggleBtn.Text = "Auto Click: OFF [" .. toggleKey.Name .. "]"
    end
end)

speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val and val >= 0.001 then
        clickDelay = val
        showToast("Tốc Độ", "Đã chỉnh delay thành: " .. clickDelay .. "s", Color3.fromRGB(0, 170, 255))
    else
        speedBox.Text = tostring(clickDelay)
    end
end)

-- Simulate Click Logic
local function simulateClick()
    if mouse1click then
        mouse1click()
    elseif VirtualInputManager then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    else
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0))
    end
end

-- Auto Click Loop
task.spawn(function()
    while true do
        if autoClicking then
            pcall(simulateClick)
        end
        task.wait(clickDelay)
    end
end)
