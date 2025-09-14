-- ⚙️ Blade Ball GUI付き Aimbot + ESP (Team対応)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BladeBallMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.4, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BorderSizePixel = 2
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Blade Ball"
Title.TextColor3 = Color3.new(0,0,0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

local AimbotButton = Instance.new("TextButton")
AimbotButton.Size = UDim2.new(1, -20, 0, 40)
AimbotButton.Position = UDim2.new(0, 10, 0, 40)
AimbotButton.BackgroundColor3 = Color3.new(0,0,0)
AimbotButton.TextColor3 = Color3.new(1,1,1)
AimbotButton.Text = "Aimbot: OFF"
AimbotButton.Parent = Frame

local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -20, 0, 40)
ESPButton.Position = UDim2.new(0, 10, 0, 90)
ESPButton.BackgroundColor3 = Color3.new(0,0,0)
ESPButton.TextColor3 = Color3.new(1,1,1)
ESPButton.Text = "ESP: OFF"
ESPButton.Parent = Frame

-- ========== ESP ==========
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
        if ESPEnabled then
            local color = Color3.fromRGB(255,0,0)
            if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                color = Color3.fromRGB(0,255,0)
            end
            createESP(char, color)
        end
    end)
end

-- ========== Aimbot ==========
local aimEnabled = false
local ESPEnabled = false
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

-- ========== ボタン動作 ==========
AimbotButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    AimbotButton.Text = "Aimbot: " .. (aimEnabled and "ON" or "OFF")
end)

ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPButton.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    if ESPEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                setupESP(p)
                if p.Character then
                    local color = Color3.fromRGB(255,0,0)
                    if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then
                        color = Color3.fromRGB(0,255,0)
                    end
                    createESP(p.Character, color)
                end
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESP_Highlight") then
                p.Character.ESP_Highlight:Destroy()
            end
        end
    end
end)
