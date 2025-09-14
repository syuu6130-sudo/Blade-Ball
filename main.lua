-- Blade Ball GUI Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- ライブラリ読み込み（オシャレUI）
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("⚔️ Blade Ball - ツールパネル", "Ocean")

-- UIタブ
local Tab = Window:NewTab("メイン")
local Section = Tab:NewSection("機能")

-- ===== GUI 移動・最小化対応 =====
-- KavoUIにはデフォルトでドラッグ移動と最小化ボタンが搭載されています

-- トグル管理
local AutoAimEnabled = false
local AutoParryNearEnabled = false
local AutoParryInstantEnabled = false
local ESPEnabled = false
local GodModeEnabled = false

----------------------------------------------------
-- 🎯 オートエイム（ボールを追尾）
----------------------------------------------------
Section:NewToggle("🎯 オートエイム", "ボールを自動で狙います", function(state)
    AutoAimEnabled = state
end)

task.spawn(function()
    while task.wait() do
        if AutoAimEnabled then
            local ball = workspace:FindFirstChild("Ball")
            if ball and ball:IsA("BasePart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, ball.Position)
            end
        end
    end
end)

----------------------------------------------------
-- 🛡 自動パリィ（近距離）
----------------------------------------------------
Section:NewToggle("🛡 自動パリィ（近距離）", "近距離でパリィします", function(state)
    AutoParryNearEnabled = state
end)

task.spawn(function()
    while task.wait() do
        if AutoParryNearEnabled then
            local ball = workspace:FindFirstChild("Ball")
            if ball and (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Parry"):FireServer()
            end
        end
    end
end)

----------------------------------------------------
-- ⚡ 自動パリィ（即反応）
----------------------------------------------------
Section:NewToggle("⚡ 自動パリィ（即反応）", "ボールに即反応してパリィ", function(state)
    AutoParryInstantEnabled = state
end)

task.spawn(function()
    while task.wait() do
        if AutoParryInstantEnabled then
            local ball = workspace:FindFirstChild("Ball")
            if ball and ball.AssemblyLinearVelocity.Magnitude > 50 then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Parry"):FireServer()
            end
        end
    end
end)

----------------------------------------------------
-- 👀 ESP（全プレイヤー透視）
----------------------------------------------------
Section:NewToggle("👀 ESP（全プレイヤー）", "全プレイヤーを透視表示します", function(state)
    ESPEnabled = state
    if not state then
        for _, v in ipairs(workspace:GetChildren()) do
            if v:FindFirstChild("ESP") then v.ESP:Destroy() end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if ESPEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not plr.Character:FindFirstChild("ESP") then
                        local billboard = Instance.new("BillboardGui", plr.Character)
                        billboard.Name = "ESP"
                        billboard.Adornee = plr.Character.HumanoidRootPart
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.AlwaysOnTop = true
                        local text = Instance.new("TextLabel", billboard)
                        text.Size = UDim2.new(1,0,1,0)
                        text.BackgroundTransparency = 1
                        text.Text = plr.Name
                        text.TextColor3 = Color3.fromRGB(255, 0, 0)
                        text.TextStrokeTransparency = 0
                        text.TextScaled = true
                    end
                end
            end
        end
    end
end)

----------------------------------------------------
-- ✨ 無敵（Godモード）
----------------------------------------------------
Section:NewToggle("✨ 無敵（Godモード）", "一時的に無敵化します", function(state)
    GodModeEnabled = state
    if state then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end
end)

----------------------------------------------------

-- ✅ ロード完了通知
Library:Notify("✅ Blade Ball ツールパネルを読み込みました", 5)
