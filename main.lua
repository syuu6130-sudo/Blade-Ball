--// Blade Ball GUI 豪華版
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

--// 保存用データ
local SaveFile = "BladeBallGUI_Pos.json"

--// メインUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BladeBallGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 400)
Frame.Position = UDim2.new(0.7, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = Frame

-- 保存位置読み込み
pcall(function()
	if isfile and isfile(SaveFile) then
		local data = HttpService:JSONDecode(readfile(SaveFile))
		Frame.Position = UDim2.new(data.XScale, data.XOffset, data.YScale, data.YOffset)
	end
end)

Frame:GetPropertyChangedSignal("Position"):Connect(function()
	if writefile then
		writefile(SaveFile, HttpService:JSONEncode({
			XScale = Frame.Position.X.Scale,
			XOffset = Frame.Position.X.Offset,
			YScale = Frame.Position.Y.Scale,
			YOffset = Frame.Position.Y.Offset
		}))
	end
end)

--// タイトルバー
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Text = "⚔ Blade Ball GUI"
Title.Size = UDim2.new(1, -60, 1, 0)
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
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.TextColor3 = Color3.new(1,1,1)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.TextSize = 18
MinimizeButton.Parent = TitleBar

--// テーマボタン
local ThemeButton = Instance.new("TextButton")
ThemeButton.Text = "🎨"
ThemeButton.Size = UDim2.new(0, 30, 1, 0)
ThemeButton.Position = UDim2.new(1, -30, 0, 0)
ThemeButton.TextColor3 = Color3.new(1,1,1)
ThemeButton.BackgroundTransparency = 1
ThemeButton.Font = Enum.Font.Gotham
ThemeButton.TextSize = 18
ThemeButton.Parent = TitleBar

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

--// トグル管理
local toggles = {
	["🎯 オートエイム"] = false,
	["🛡 自動パリィ（近距離）"] = false,
	["⚡ 自動パリィ（即反応）"] = false,
	["💥 自動パリィ（色変化）"] = false,
	["👀 ESP"] = false,
	["✨ 無敵（Godモード）"] = false
}

--// 効果音
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
clickSound.Parent = Frame

--// ボタン作成
local function createButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.Text = name.."：OFF"
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	btn.Parent = Content

	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		if name:find("パリィ") then
			for k,_ in pairs(toggles) do
				if k:find("パリィ") and k ~= name then
					toggles[k] = false
					for _,b in ipairs(Content:GetChildren()) do
						if b:IsA("TextButton") and b.Text:find(k) then
							b.Text = k.."：OFF"
							b.BackgroundColor3 = Color3.fromRGB(60,60,60)
						end
					end
				end
			end
		end
		toggles[name] = not toggles[name]
		btn.Text = name..(toggles[name] and "：ON" or "：OFF")
		btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,60,60)

		-- 光るアニメ
		if toggles[name] then
			spawn(function()
				for i=1,10 do
					btn.BackgroundColor3 = Color3.fromRGB(0,170+i*8,255)
					task.wait(0.03)
				end
			end)
		end
	end)
end

for name,_ in pairs(toggles) do
	createButton(name)
end

--// テーマ切り替え
local themes = {
	{bg=Color3.fromRGB(25,25,25), bar=Color3.fromRGB(50,50,50)}, --ダーク
	{bg=Color3.fromRGB(240,240,240), bar=Color3.fromRGB(180,180,180)}, --ライト
	{bg=Color3.fromRGB(20,20,50), bar=Color3.fromRGB(0,150,255)} --ネオン
}
local themeIndex = 1
ThemeButton.MouseButton1Click:Connect(function()
	themeIndex += 1
	if themeIndex > #themes then themeIndex = 1 end
	Frame.BackgroundColor3 = themes[themeIndex].bg
	TitleBar.BackgroundColor3 = themes[themeIndex].bar
end)

--// 最小化
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	Content.Visible = not minimized
end)

--// 機能実行
local lastColor
local function autoAim()
	local ball = workspace:FindFirstChild("Ball")
	if ball then
		Mouse.Hit = CFrame.new(ball.Position)
	end
end
local function autoParryClose()
	local ball = workspace:FindFirstChild("Ball")
	if ball and LocalPlayer:DistanceFromCharacter(ball.Position) < 15 then
		ReplicatedStorage.Remotes.Parry:FireServer()
	end
end
local function autoParryInstant()
	local ball = workspace:FindFirstChild("Ball")
	if ball and ball.AssemblyLinearVelocity.Magnitude > 80 then
		ReplicatedStorage.Remotes.Parry:FireServer()
	end
end
local function autoParryColor()
	local ball = workspace:FindFirstChild("Ball")
	if ball then
		local c = tostring(ball.Color)
		if lastColor and c~=lastColor then
			ReplicatedStorage.Remotes.Parry:FireServer()
		end
		lastColor = c
	end
end
local function esp()
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
			local hl = p.Character:FindFirstChild("ESP") or Instance.new("Highlight")
			hl.Name="ESP"
			hl.Adornee=p.Character
			hl.FillTransparency=1
			hl.OutlineColor=Color3.new(1,0,0)
			hl.OutlineTransparency = toggles["👀 ESP"] and 0 or 1
			hl.Parent=p.Character
		end
	end
end
local function god()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		local hum=LocalPlayer.Character.Humanoid
		hum.Health=hum.MaxHealth
		hum.MaxHealth=math.huge
	end
end

RunService.RenderStepped:Connect(function()
	if toggles["🎯 オートエイム"] then autoAim() end
	if toggles["🛡 自動パリィ（近距離）"] then autoParryClose() end
	if toggles["⚡ 自動パリィ（即反応）"] then autoParryInstant() end
	if toggles["💥 自動パリィ（色変化）"] then autoParryColor() end
	if toggles["👀 ESP"] then esp() end
	if toggles["✨ 無敵（Godモード）"] then god() end
end)

game.StarterGui:SetCore("SendNotification", {
	Title="✅ Blade Ball GUI",
	Text="豪華版 GUIが読み込まれました！",
	Duration=5
})
