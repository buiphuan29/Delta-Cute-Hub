-- Services
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Global Variables
local autoClicking = false
local clickDelay = 0.1
local toggleKey = Enum.KeyCode.E -- Phím tắt mặc định (phím E)

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerHub"
screenGui.ResetOnSpawn = false

local parentTarget = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
screenGui.Parent = parentTarget

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 230, 0, 185)
frame.Position = UDim2.new(0.5, -115, 0.4, -92)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "AUTO CLICK HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.Parent = frame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.075, 0, 0.22, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
toggleBtn.Text = "Auto Click: OFF [" .. toggleKey.Name .. "]"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamMedium
toggleBtn.TextSize = 13
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

-- Speed Input Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 0, 30)
speedLabel.Position = UDim2.new(0.075, 0, 0.46, 0)
speedLabel.Text = "Delay (giây):"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.Gotham
speedLabel.BackgroundTransparency = 1
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

-- Speed Input Box
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.35, 0, 0, 30)
speedBox.Position = UDim2.new(0.575, 0, 0.46, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
speedBox.Text = tostring(clickDelay)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 13
speedBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = speedBox

-- Hotkey Input Label
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.5, 0, 0, 30)
keyLabel.Position = UDim2.new(0.075, 0, 0.68, 0)
keyLabel.Text = "Phím tắt:"
keyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
keyLabel.TextSize = 13
keyLabel.Font = Enum.Font.Gotham
keyLabel.BackgroundTransparency = 1
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = frame

-- Hotkey Input Box
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.35, 0, 0, 30)
keyBox.Position = UDim2.new(0.575, 0, 0.68, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
keyBox.Text = toggleKey.Name
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 13
keyBox.Parent = frame

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 6)
keyBoxCorner.Parent = keyBox

-- Toggle Logic Function
local function updateToggleState()
    autoClicking = not autoClicking
    if autoClicking then
        toggleBtn.Text = "Auto Click: ON [" .. toggleKey.Name .. "]"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
    else
        toggleBtn.Text = "Auto Click: OFF [" .. toggleKey.Name .. "]"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
    end
end

-- Button Click Event
toggleBtn.MouseButton1Click:Connect(updateToggleState)

-- Keybind Event (UserInputService)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- gameProcessed kiểm tra xem người dùng có đang gõ chat/nhập chữ hay không
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == toggleKey then
            updateToggleState()
        end
    end
end)

-- Hotkey Changing Logic
keyBox.FocusLost:Connect(function()
    local inputStr = keyBox.Text:upper()
    local success, newKey = pcall(function()
        return Enum.KeyCode[inputStr]
    end)
    
    if success and newKey then
        toggleKey = newKey
        keyBox.Text = toggleKey.Name
    else
        keyBox.Text = toggleKey.Name
    end
    
    -- Cập nhật chữ trên nút
    if autoClicking then
        toggleBtn.Text = "Auto Click: ON [" .. toggleKey.Name .. "]"
    else
        toggleBtn.Text = "Auto Click: OFF [" .. toggleKey.Name .. "]"
    end
end)

-- Speed Adjustment Logic
speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val and val >= 0.001 then
        clickDelay = val
    else
        speedBox.Text = tostring(clickDelay)
    end
end)

-- Auto Click Loop
task.spawn(function()
    while true do
        if autoClicking then
            if mouse1click then
                mouse1click()
            else
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end
        end
        task.wait(clickDelay)
    end
end)
