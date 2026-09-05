-- VÔ HIỆU HOÁ ÁNH SÁNG & BÓNG ĐỔ
local Lighting = game:GetService("Lighting")
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.ShadowSoftness = 0
sethiddenproperty(Lighting, "Technology", 2) -- Chuyển sang công nghệ ánh sáng nhẹ nhất (Compatibility)

-- TỐI ƯU HOÁ ĐỊA HÌNH & NƯỚC
local Terrain = workspace:WaitForChild("Terrain")
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Terrain.Decoration = false

-- LẶP QUA TẤT CẢ VẬT THỂ ĐỂ GIẢM CHI TIẾT
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
        v.CastShadow = false
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy() -- Xóa hình ảnh dán trên khối
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
        v.Enabled = false -- Tắt các hiệu ứng hạt (lửa, khói, vệt sáng)
    elseif v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") then
        v.Enabled = false -- Tắt các hiệu ứng camera
    end
end

-- TẮT HOẠT ẢNH THỪA (Tùy chọn, giúp giảm tải CPU)
workspace.DescendantAdded:Connect(function(child)
    if child:IsA("BasePart") then
        child.Material = Enum.Material.SmoothPlastic
        child.CastShadow = false
    end
end)

-- THÔNG BÁO HOÀN TẤT
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Tối ưu hóa hoàn tất!";
    Text = "Đã giảm đồ họa, xóa texture & tăng FPS.";
    Duration = 5;
})
