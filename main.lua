-- Blade Ball Utility GUI (日本語UI + Executor対応)
-- 制作者: @syuu_0316

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- GUI作成
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.new(1,1,1)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(200,200,200)
Title.Text = "Blade Ball ユーティリティ"
Title.TextColor3 = Color3.new(0,0,0)

-- 最小化ボタン
local MinButton = Instance.new("TextButton", MainFrame)
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -35, 0, 0)
MinButton.Text = "―"
MinButton.BackgroundColor3 = Color3.fromRGB(180,180,180)

-- ボタン生成関数
local function createToggleButton(name, yPos)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = name.."：OFF"
    btn.AutoButtonColor = false
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name.."："..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,150,0) or Color3.new(0,0,0)
        -- 各機能のON/OFF処理 ↓
        if name == "🎯 オートエイム" then
            _G.AutoAim = state
        elseif name == "🛡 自動パリィ（近距離）" then
            _G.ParryClose = state
        elseif name == "⚡ 自動パリィ（即反応）" then
            _G.ParryFast = state
        elseif name == "👀 ESP" then
            _G.ESP = state
        elseif name == "✨ 無敵" then
            _G.God = state
        end
    end)
end

-- 各ボタン配置
createToggleButton("🎯 オートエイム", 50)
createToggleButton("🛡 自動パリィ（近距離）", 90)
createToggleButton("⚡ 自動パリィ（即反応）", 130)
createToggleButton("👀 ESP", 170)
createToggleButton("✨ 無敵", 210)

-- 最小化ボタン機能
local minimized = false
MinButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") and child ~= MinButton then
            child.Visible = not minimized
        end
    end
    MainFrame.Size = minimized and UDim2.new(0,250,0,30) or UDim2.new(0,250,0,300)
end)

-- ESP機能（シンプル表示）
RunService.RenderStepped:Connect(function()
    if _G.ESP then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                if not plr.Character.Head:FindFirstChild("BillboardGui") then
                    local bb = Instance.new("BillboardGui", plr.Character.Head)
                    bb.Name = "BillboardGui"
                    bb.Size = UDim2.new(0,100,0,20)
                    bb.AlwaysOnTop = true
                    local tl = Instance.new("TextLabel", bb)
                    tl.Size = UDim2.new(1,0,1,0)
                    tl.BackgroundTransparency = 1
                    tl.Text = plr.Name
                    tl.TextColor3 = Color3.new(1,0,0)
                end
            end
        end
    else
        for _,plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local bb = plr.Character.Head:FindFirstChild("BillboardGui")
                if bb then bb:Destroy() end
            end
        end
    end
end)

-- オートエイム（ボールに照準を合わせる）
RunService.RenderStepped:Connect(function()
    if _G.AutoAim then
        local mouse = LocalPlayer:GetMouse()
        local ball = workspace:FindFirstChild("Ball") -- ゲーム内のボール名が違う場合は変更
        if ball and ball:FindFirstChild("Position") then
            local cam = workspace.CurrentCamera
            local screenPos = cam:WorldToViewportPoint(ball.Position)
            mouse.Icon = "rbxassetid://0"
            mouse.X = screenPos.X
            mouse.Y = screenPos.Y
        end
    end
end)

-- 自動パリィ（近距離 + 即反応）
RunService.Heartbeat:Connect(function()
    if _G.ParryClose or _G.ParryFast then
        local char = LocalPlayer.Character
        local ball = workspace:FindFirstChild("Ball")
        if char and char:FindFirstChild("HumanoidRootPart") and ball and ball:IsA("BasePart") then
            local dist = (ball.Position - char.HumanoidRootPart.Position).Magnitude
            if (_G.ParryClose and dist < 10) or (_G.ParryFast and dist < 30) then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool:Activate()
                end
            end
        end
    end
end)

-- 無敵モード
RunService.Heartbeat:Connect(function()
    if _G.God and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
end)
