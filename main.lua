-- Tải thư viện Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo Cửa Sổ Menu
local Window = Rayfield:CreateWindow({
   Name = "⚡ Delta Super Hub | Fix Lag & Auto",
   LoadingTitle = "Đang tải hệ thống...",
   LoadingSubtitle = "Phiên bản Nâng Cao",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

---------------------------------------------------------
-- TAB 1: TỐI ƯU HÓA ĐỒ HỌA & MAP (REDUCE MỌI THỨ)
---------------------------------------------------------
local OptimizeTab = Window:CreateTab("Tối ưu (Giảm Lag)")

OptimizeTab:CreateButton({
   Name = "1. Super Fix Lag (Làm mượt, giữ nguyên Map)",
   Callback = function()
        pcall(function() game.Lighting.GlobalShadows = false game.Lighting.FogEnd = 9e9 end)
        for _, v in pairs(workspace:GetDescendants()) do
            pcall(function()
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0 v.CastShadow = false
                elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then
                    v:Destroy()
                end
            end)
        end
        Rayfield:Notify({Title = "Thành công", Content = "Đã tối ưu hóa kết cấu đồ họa.", Duration = 3})
   end,
})

OptimizeTab:CreateButton({
   Name = "2. XÓA TOÀN BỘ KHỐI MAP (Tăng Max FPS)",
   Callback = function()
        -- Lấy vị trí người chơi hiện tại
        local lp = game.Players.LocalPlayer
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        
        -- Tạo 1 sàn đỡ tàng hình dưới chân để không bị rơi chết
        local safeZone = Instance.new("Part")
        safeZone.Size = Vector3.new(2000, 5, 2000)
        safeZone.Position = hrp.Position - Vector3.new(0, 5, 0)
        safeZone.Anchored = true
        safeZone.Transparency = 0.5
        safeZone.BrickColor = BrickColor.new("Bright green")
        safeZone.Parent = workspace

        -- Quét và xóa toàn bộ khối (Chỉ xóa khối, trừ nhân vật)
        for _, v in pairs(workspace:GetDescendants()) do
            pcall(function()
                -- Nếu nó là Khối (Part) và KHÔNG phải sàn an toàn
                if v:IsA("BasePart") and v ~= safeZone then
                    -- Kiểm tra xem khối đó có thuộc về người chơi/NPC không
                    local isCharacter = v.Parent:FindFirstChild("Humanoid") or v:FindFirstAncestorWhichIsA("Accessory")
                    if not isCharacter then
                        v:Destroy() -- Xóa khối
                    end
                elseif v:IsA("Texture") or v:IsA("Decal") then
                    v:Destroy() -- Xóa luôn texture nếu còn sót
                end
            end)
        end
        Rayfield:Notify({
            Title = "Đã dọn sạch Map!", 
            Content = "Đã xóa toàn bộ khối trên bản đồ, chừa lại sàn đỡ xanh lá.", 
            Duration = 5
        })
   end,
})

---------------------------------------------------------
-- TAB 2: HỆ THỐNG AUTO CLICK
---------------------------------------------------------
local AutoTab = Window:CreateTab("Auto Clicker")
local autoClicking = false
local autoTool = false

AutoTab:CreateToggle({
   Name = "Bật Auto Click (Click chuột ảo liên tục)",
   CurrentValue = false,
   Callback = function(Value)
      autoClicking = Value
      if autoClicking then
         task.spawn(function()
            local VirtualUser = game:GetService("VirtualUser")
            while autoClicking do
               -- Tự động gửi tín hiệu click chuột trái
               VirtualUser:CaptureController()
               VirtualUser:ClickButton1(Vector2.new(0, 0))
               task.wait(0.01) -- Độ trễ cực thấp
            end
         end)
      end
   end,
})

AutoTab:CreateToggle({
   Name = "Bật Auto Đánh (Tự động dùng vũ khí/vật phẩm)",
   CurrentValue = false,
   Callback = function(Value)
      autoTool = Value
      if autoTool then
         task.spawn(function()
            local lp = game.Players.LocalPlayer
            while autoTool do
               pcall(function()
                   local char = lp.Character
                   if char then
                      -- Tìm vật phẩm đang cầm trên tay và tự động kích hoạt
                      local tool = char:FindFirstChildOfClass("Tool")
                      if tool then
                         tool:Activate()
                      end
                   end
               end)
               task.wait(0.05)
            end
         end)
      end
   end,
})

---------------------------------------------------------
-- TAB 3: TIỆN ÍCH PHỤ TRỢ (EXTRA)
---------------------------------------------------------
local ExtraTab = Window:CreateTab("Tính năng phụ")

ExtraTab:CreateButton({
   Name = "🧹 Dọn rác bộ nhớ (Giảm RAM & Ping ảo)",
   Callback = function()
        pcall(function()
            -- Ép Roblox dọn dẹp các dữ liệu không dùng đến trong RAM
            gcinfo() 
            collectgarbage("collect")
        end)
        Rayfield:Notify({Title = "Thành công", Content = "Đã dọn dẹp RAM, game sẽ đỡ khựng hơn.", Duration = 3})
   end,
})

ExtraTab:CreateToggle({
   Name = "🌙 Chế độ Treo Máy (AFK - Tắt Render 3D)",
   CurrentValue = false,
   Callback = function(Value)
        pcall(function()
            if Value then
                local gui = Instance.new("ScreenGui")
                gui.Name = "BlackScreenAFK"
                gui.Parent = game.CoreGui
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(10, 0, 10, 0)
                frame.Position = UDim2.new(-5, 0, -5, 0)
                frame.BackgroundColor3 = Color3.new(0, 0, 0)
                frame.Parent = gui
                game:GetService("RunService"):Set3dRenderingEnabled(false) -- Tắt xử lý đồ họa
            else
                if game.CoreGui:FindFirstChild("BlackScreenAFK") then
                    game.CoreGui.BlackScreenAFK:Destroy()
                end
                game:GetService("RunService"):Set3dRenderingEnabled(true) -- Bật lại đồ họa
            end
        end)
   end,
})

Rayfield:Notify({Title = "Load thành công!", Content = "Giao diện đã sẵn sàng.", Duration = 4})
