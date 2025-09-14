-- Blade Ball 超豪華GUIスクリプト
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- UI生成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 420)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 16)

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local Title = Instance.new("TextLabel", Frame)
Title.Text = "⚡ Blade Ball GUI ⚡"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

-- 最小化ボタン
local Minimize = Instance.new("TextButton", Frame)
Minimize.Text = "―"
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -35, 0, 5)
Minimize.AnchorPoint = Vector2.new(1, 0)
Minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 20
local mini = false

local contentHolder = Instance.new("Frame", Frame)
contentHolder.Size = UDim2.new(1, -20, 1, -60)
contentHolder.Position = UDim2.new(0, 10, 0, 50)
contentHolder.BackgroundTransparency = 1

local contentLayout = Instance.new("UIListLayout", contentHolder)
contentLayout.Padding = UDim.new(0, 5)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top

Minimize.MouseButton1Click:Connect(function()
	mini = not mini
	contentHolder.Visible = not mini
end)

-- トグルボタン作成関数
local function createToggle(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Text = "⚪ "..name
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Parent = contentHolder
	local active = false
	btn.MouseButton1Click:Connect(function()
		active = not active
		btn.Text = (active and "🟢 " or "⚪ ")..name
		callback(active)
	end)
end

-- 機能群 ---------------------------------------------

-- 🎯オートエイム
createToggle("オートエイム", function(on)
	if on then
		RunService.RenderStepped:Connect(function()
			-- ここにオートエイム処理
		end)
	end
end)

-- 🛡自動パリィ（近距離）
createToggle("自動パリィ（近距離）", function(on)
	if on then
		RunService.RenderStepped:Connect(function()
			-- ボールが近ければパリィ
		end)
	end
end)

-- ⚡自動パリィ（即反応）
createToggle("自動パリィ（即反応）", function(on)
	if on then
		RunService.RenderStepped:Connect(function()
			-- ボールが自分に向かった瞬間パリィ
		end)
	end
end)

-- 👀ESP
createToggle("ESP（透視）", function(on)
	-- プレイヤー頭上に名前を表示するなど
end)

-- ✨無敵
createToggle("無敵（God）", function(on)
	if on then
		-- ダメージ無効化処理
	else
		-- 元に戻す
	end
end)

-- 🏃スピードブースト
createToggle("スピードブースト", function(on)
	if on then
		LocalPlayer.Character.Humanoid.WalkSpeed = 50
	else
		LocalPlayer.Character.Humanoid.WalkSpeed = 16
	end
end)

-- 💨ジャンプ強化
createToggle("ジャンプ強化", function(on)
	if on then
		LocalPlayer.Character.Humanoid.JumpPower = 100
	else
		LocalPlayer.Character.Humanoid.JumpPower = 50
	end
end)

-- 🌀オーラ
createToggle("オーラ", function(on)
	-- BodyGlowを追加するなど
end)

-- 🌈カラフルネーム
createToggle("カラフルネーム", function(on)
	-- 名前の色を常に変更するなど
end)

-- 🎨テーマ切り替え
createToggle("UIテーマ切り替え", function(on)
	if on then
		Frame.BackgroundColor3 = Color3.fromRGB(230,230,230)
		Title.TextColor3 = Color3.fromRGB(20,20,20)
	else
		Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
		Title.TextColor3 = Color3.fromRGB(255,255,255)
	end
end)
