local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Auto Clicker Hub",
   Icon = 0,
   LoadingTitle = "Auto Clicker Hub",
   LoadingSubtitle = "Rayfield Interface",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "AutoClickerConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Chức Năng Chính", 4483362458)

local autoClicking = false
local clickDelay = 0.1

local function simulateClick()
    if mouse1click then
        mouse1click()
    elseif game:GetService("VirtualInputManager") then
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
    else
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0))
    end
end

local Toggle = MainTab:CreateToggle({
   Name = "Bật / Tắt Auto Click",
   CurrentValue = false,
   Flag = "AutoClickerToggle",
   Callback = function(Value)
      autoClicking = Value
      if autoClicking then
         Rayfield:Notify({
            Title = "Auto Clicker",
            Content = "Đã BẬT Auto Click!",
            Duration = 2,
            Image = 4483362458,
         })
      else
         Rayfield:Notify({
            Title = "Auto Clicker",
            Content = "Đã TẮT Auto Click!",
            Duration = 2,
            Image = 4483362458,
         })
      end
   end,
})

local Keybind = MainTab:CreateKeybind({
   Name = "Phím Tắt (Hotkey)",
   CurrentKeybind = "E",
   HoldToInteract = false,
   Flag = "AutoClickerKeybind",
   Callback = function(Keybind)
      Toggle:Set(not autoClicking)
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "Thời Gian Delay (Giây)",
   Range = {0.001, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "AutoClickerDelay",
   Callback = function(Value)
      clickDelay = Value
   end,
})

task.spawn(function()
    while true do
        if autoClicking then
            pcall(simulateClick)
        end
        task.wait(clickDelay)
    end
end)

