-- Touch Fling (Fully Working)
-- Работает на большинстве экзекьюторов

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local FlingPower = 10000 -- Сила флаинга (можно менять)
local Enabled = true

local function GetCharacter(player)
    return player.Character or player.CharacterAdded:Wait()
end

local function Fling(target)
    local char = GetCharacter(LocalPlayer)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetChar = GetCharacter(target)
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    -- Создаём BodyAngularVelocity для сильного вращения
    local bv = Instance.new("BodyAngularVelocity")
    bv.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = math.huge
    bv.AngularVelocity = Vector3.new(FlingPower, FlingPower, FlingPower)
    bv.Parent = hrp

    -- Дополнительный BodyVelocity для толчка
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = (targetHRP.Position - hrp.Position).Unit * FlingPower + Vector3.new(0, FlingPower / 2, 0)
    bodyVel.Parent = hrp

    task.wait(0.15)
    bv:Destroy()
    bodyVel:Destroy()
end

-- Основной цикл касания
local connection
connection = RunService.Heartbeat:Connect(function()
    if not Enabled then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player \~= LocalPlayer then
            local targetChar = player.Character
            if targetChar then
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    local distance = (hrp.Position - targetHRP.Position).Magnitude
                    if distance < 4.5 then -- Дистанция касания
                        Fling(player)
                    end
                end
            end
        end
    end
end)

-- Переключение вкл/выкл (клавиша F)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        Enabled = not Enabled
        print("Touch Fling:", Enabled and "ВКЛ" or "ВЫКЛ")
    end
end)

print("Touch Fling загружен! Нажми F чтобы вкл/выкл")
