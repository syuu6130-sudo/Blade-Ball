--// Blade Ball GUI 修正版 by ChatGPT
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// メインUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BladeBallGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 300)
Frame.Position = UDim2.new(0.7, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = Frame

--// タイトルバー
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Text = "⚔ Blade Ball GUI"
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

--// 最小化ボタン
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Text = "―"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
MinimizeButton.TextColor3 = Color3.new(1,1,1)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.TextSize = 18
MinimizeButton.Parent = TitleBar

--// コンテンツ
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -40)
Content.Position = UDim2.new(0, 10, 0, 35)
Content.BackgroundTransparency = 1
Content.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Parent = Content

local toggles = {
	["🎯 オートエイム"] = false,
	["🛡 自動パリィ（近距離）"] = false,
	["⚡ 自動パリィ（即反応）"] = false,
	["👀 ESP"] = false,
	["✨ 無敵（Godモード）"] = false
}

local function createButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.Text = name .. "：OFF"
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	btn.Parent = Content
	btn.MouseButton1Click:Connect(function()
		toggles[name] = not toggles[name]
		btn.Text = name .. (toggles[name] and "：ON" or "：OFF")
		btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0,150,255) or Color3.fromRGB(50,50,50)
	end)
end

for name,_ in pairs(toggles) do
	createButton(name)
end

--// 最小化機能
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	Content.Visible = not minimized
end)

--// ESP
local function updateESP()
	for _,player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local highlight = player.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight")
			highlight.Name = "ESPHighlight"
			highlight.Adornee = player.Character
			highlight.FillTransparency = 1
			highlight.OutlineColor = Color3.new(1,0,0)
			highlight.OutlineTransparency = toggles["👀 ESP"] and 0 or 1
			highlight.Parent = player.Character
		end
	end
end

--// オートエイム（ボール）
local function autoAim()
	local ball = workspace:FindFirstChild("Ball")
	if ball and ball:IsA("BasePart") then
		local pos = ball.Position
		local dir = (pos - LocalPlayer.Character.Head.Position).unit
		Mouse.Hit = CFrame.new(pos)
	end
end

--// 自動パリィ（近距離）
local function autoParryClose()
	local ball = workspace:FindFirstChild("Ball")
	if ball and LocalPlayer.Character and LocalPlayer:DistanceFromCharacter(ball.Position) < 15 then
		game:GetService("ReplicatedStorage").Remotes.Parry:FireServer()
	end
end

--// 自動パリィ（即反応）
local function autoParryInstant()
	local ball = workspace:FindFirstChild("Ball")
	if ball then
		local vel = ball.AssemblyLinearVelocity
		if vel.Magnitude > 80 then
			game:GetService("ReplicatedStorage").Remotes.Parry:FireServer()
		end
	end
end

--// 無敵モード
local function godMode()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.Health = 100
		LocalPlayer.Character.Humanoid.MaxHealth = math.huge
	end
end

--// メインループ
RunService.RenderStepped:Connect(function()
	if toggles["👀 ESP"] then updateESP() end
	if toggles["🎯 オートエイム"] then autoAim() end
	if toggles["🛡 自動パリィ（近距離）"] then autoParryClose() end
	if toggles["⚡ 自動パリィ（即反応）"] then autoParryInstant() end
	if toggles["✨ 無敵（Godモード）"] then godMode() end
end)

-- 完了通知
game.StarterGui:SetCore("SendNotification", {
	Title = "✅ Blade Ball GUI",
	Text = "GUIが正常に読み込まれました！",
	Duration = 5
})
