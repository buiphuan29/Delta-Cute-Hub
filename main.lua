-- Tải thư viện giao diện Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo cửa sổ Menu
local Window = Rayfield:CreateWindow({
   Name = "🚀 Super Fix Lag Hub | Delta",
   LoadingTitle = "Đang tải hệ thống tối ưu...",
   LoadingSubtitle = "Dành riêng cho Delta",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

-- Tạo Tab chức năng
local MainTab = Window:CreateTab("Tối ưu hóa (Lag & FPS)")
local ExtraTab = Window:CreateTab("Tính năng phụ")

-- [1] Nút Kích hoạt Super Fix Lag (Xóa Texture, Đưa về SmoothPlastic)
MainTab:CreateButton({
   Name = "✅ Kích hoạt Super Fix Lag (An Toàn)",
   Callback = function()
        -- Tối ưu ánh sáng
        pcall(function()
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 9e9
            game.Lighting.ShadowSoftness = 0
        end)
        
        -- Tối ưu nước và địa hình
        pcall(function()
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 0
            workspace.Terrain.Decoration = false
        end)
        
        -- Lặp qua để xóa chi tiết thừa (Không xóa khối để tránh rớt map)
        for _, v in pairs(workspace:GetDescendants()) do
            pcall(function()
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                    v.CastShadow = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy() -- Xóa toàn bộ bề mặt ảnh dán
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                elseif v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                    v:Destroy() -- Xóa hiệu ứng chói mắt
                end
            end)
        end
        Rayfield:Notify({
            Title = "Thành công!",
            Content = "Đã tối ưu hóa toàn bộ bản đồ.",
            Duration = 3,
        })
   end,
})

-- [2] Nút xóa bỏ hoàn toàn bầu trời (Tăng FPS đáng kể)
MainTab:CreateButton({
   Name = "🌌 Xóa Bầu Trời (Clear Skybox)",
   Callback = function()
        pcall(function()
            game.Lighting.Sky:Destroy()
            game.Lighting.Atmosphere:Destroy()
        end)
        Rayfield:Notify({
            Title = "Thành công!",
            Content = "Đã xóa bầu trời, giảm tải GPU.",
            Duration = 3,
        })
   end,
})

-- [3] Tối ưu hóa cho cày cuốc (AFK Mode - Màn hình đen)
ExtraTab:CreateToggle({
   Name = "Chế độ AFK (Màn hình đen - Tăng Max FPS)",
   CurrentValue = false,
   Callback = function(Value)
        pcall(function()
            if Value then
                local gui = Instance.new("ScreenGui")
                gui.Name = "AFKGui"
                gui.Parent = game.CoreGui
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(10, 0, 10, 0)
                frame.Position = UDim2.new(-5, 0, -5, 0)
                frame.BackgroundColor3 = Color3.new(0, 0, 0)
                frame.Parent = gui
                
                game:GetService("RunService"):Set3dRenderingEnabled(false) -- Tắt render 3D
            else
                if game.CoreGui:FindFirstChild("AFKGui") then
                    game.CoreGui.AFKGui:Destroy()
                end
                game:GetService("RunService"):Set3dRenderingEnabled(true) -- Bật lại render 3D
            end
        end)
   end,
})

-- Thông báo khi script load xong
Rayfield:Notify({
   Title = "Hệ thống đã sẵn sàng",
   Content = "UI Rayfield đã load thành công trên Delta!",
   Duration = 5,
})
