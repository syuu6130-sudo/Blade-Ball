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
Title.Text = "Blade Ball (syu_u0316)"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.TextScaled = true

-- 🧠 Blade Ball Aimbot + ESP (Team対応)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==== ESP ====
local function createESP(char, color)
    if char:FindFirstChild("HumanoidRootPart") and not char:FindFirstChild("ESP_Highlight") then
        local h = Instance.new("Highlight")
        h.Name = "ESP_Highlight"
        h.FillColor = color
        h.OutlineColor = Color3.new(1,1,1)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Parent = char
    end
end

local function setupESP(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        local color = Color3.fromRGB(255,0,0)
        if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            color = Color3.fromRGB(0,255,0)
        end
        createESP(char, color)
    end)
    if plr.Character then
        local color = Color3.fromRGB(255,0,0)
        if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            color = Color3.fromRGB(0,255,0)
        end
        createESP(plr.Character, color)
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        setupESP(p)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        setupESP(p)
    end
end)

-- ==== Aimbot ====
local aimEnabled = true
local aimRadius = 300

local function getClosestEnemy()
    local closest, closestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local sameTeam = (p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team)
            if not sameTeam then
                local pos = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                local dist = (Vector2.new(pos.X,pos.Y) - mousePos).Magnitude
                if dist < closestDist and dist < aimRadius then
                    closest = p
                    closestDist = dist
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

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
