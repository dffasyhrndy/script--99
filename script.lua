-- Versi HP - OP Script "99 Night in Forest"
-- Fitur: Auto Collect, Auto Hide, Auto Feed, Auto Bring, Auto Teleport ke Target Spesifik (Chest, Anak Hilang, dll)
-- Disesuaikan untuk executor mobile (Hydrogen, Arceus X)

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 170, 0, 210)
frame.Position = UDim2.new(1, -180, 1, -230)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local function createButton(name, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    return btn
end

local hideBtn = createButton("Auto Hide: OFF", 0)
local collectBtn = createButton("Auto Collect", 35)
local bringBtn = createButton("Auto Bring", 70)
local feedBtn = createButton("Auto Feed", 105)
local tpBtn = createButton("Auto Teleport Target", 140)
local stopBtn = createButton("Stop All", 175)

-- Flags
local running = {
    hide = false,
    collecting = false,
    bringing = false,
    feeding = false,
    teleporting = false
}

-- Toggle Buttons
hideBtn.MouseButton1Click:Connect(function()
    running.hide = not running.hide
    hideBtn.Text = running.hide and "Auto Hide: ON" or "Auto Hide: OFF"
end)

collectBtn.MouseButton1Click:Connect(function()
    running.collecting = not running.collecting
end)

bringBtn.MouseButton1Click:Connect(function()
    running.bringing = not running.bringing
end)

feedBtn.MouseButton1Click:Connect(function()
    running.feeding = not running.feeding
end)

tpBtn.MouseButton1Click:Connect(function()
    running.teleporting = not running.teleporting
end)

stopBtn.MouseButton1Click:Connect(function()
    for k in pairs(running) do running[k] = false end
    hideBtn.Text = "Auto Hide: OFF"
end)

-- Core Logic
local function teleportTo(part)
    if part and part:IsA("BasePart") then
        hrp.CFrame = part.CFrame + Vector3.new(0, 2, 0)
        wait(0.2)
        pcall(function()
            firetouchinterest(hrp, part, 0)
            firetouchinterest(hrp, part, 1)
        end)
    end
end

local function collectItems()
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("BasePart") then
            local name = item.Name:lower()
            if name:find("scrap") or name:find("wood") or name:find("ammo") or name:find("gun") or name:find("weapon") then
                teleportTo(item)
            end
        end
    end
end

local function bringItems()
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("BasePart") then
            local name = item.Name:lower()
            if name:find("scrap") or name:find("wood") or name:find("ammo") or name:find("weapon") then
                item.CFrame = hrp.CFrame + Vector3.new(math.random(-3,3), 1, math.random(-3,3))
            end
        end
    end
end

local function feedNPCs()
    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc.Name:lower():find("npc") and npc:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
            wait(0.2)
        end
    end
end

local function autoHider()
    local monster = workspace:FindFirstChild("Monster")
    if monster then
        local dist = (monster.Position - hrp.Position).Magnitude
        if dist < 100 then
            for _, h in ipairs(workspace:GetChildren()) do
                if h:IsA("BasePart") and h.Name:lower():find("hide") then
                    hrp.CFrame = h.CFrame + Vector3.new(0, 2, 0)
                    break
                end
            end
        end
    end
end

local function teleportToTarget()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("chest") or name:find("lost") or name:find("missing") or name:find("kid") then
                teleportTo(obj)
                wait(0.5)
            end
        end
    end
end

-- Loop
spawn(function()
    while wait(1) do
        if running.hide then autoHider() end
        if running.collecting then collectItems() end
        if running.bringing then bringItems() end
        if running.feeding then feedNPCs() end
        if running.teleporting then teleportToTarget() end
    end
end)
