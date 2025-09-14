-- ✅ GUIベース / 白背景 / トグルボタン付き
-- Arceus X Neo 対応

-- GUIを作成
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AimbotToggle = Instance.new("TextButton")
local ESPToggle = Instance.new("TextButton")

-- GUIをプレイヤーに追加
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- フレーム設定
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0.5, -125, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
Frame.Active = true
Frame.Draggable = true

-- タイトル
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Blade Ball (Test GUI)"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.TextScaled = true

-- Aimbotボタン
AimbotToggle.Parent = Frame
AimbotToggle.Size = UDim2.new(0.8, 0, 0, 40)
AimbotToggle.Position = UDim2.new(0.1, 0, 0.3, 0)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
AimbotToggle.TextColor3 = Color3.fromRGB(255,255,255)
AimbotToggle.Text = "Aimbot: OFF"

-- ESPボタン
ESPToggle.Parent = Frame
ESPToggle.Size = UDim2.new(0.8, 0, 0, 40)
ESPToggle.Position = UDim2.new(0.1, 0, 0.55, 0)
ESPToggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
ESPToggle.TextColor3 = Color3.fromRGB(255,255,255)
ESPToggle.Text = "ESP: OFF"

-- 機能ON/OFF管理
local aimbotEnabled = false
local espEnabled = false

AimbotToggle.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	AimbotToggle.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
end)

ESPToggle.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	ESPToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
end)
