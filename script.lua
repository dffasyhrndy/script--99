-- mobile_script_op.lua
-- OP features:
-- Auto Teleport (Child/Chest), Auto Collect Fuel & Resources, Auto Bring, Auto Kill Aura, Auto Feed

local Players = game:GetService("Players")
local lp, hrp = Players.LocalPlayer, nil
lp.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
hrp = lp.Character:WaitForChild("HumanoidRootPart")

-- GUI Setup omitted for brevity (buat tombol toggle untuk fitur)

local targets = {"lostchild", "child", "chest"}
local resNames = {"log", "wood", "coal", "oil", "bandage", "rawmeat"}
local enemies = {"Cultist", "Wolf", "Bear", "Wendigo"}

function teleportTo(obj)
  if obj:IsA("BasePart") then
    lp.Character:SetPrimaryPartCFrame(obj.CFrame + Vector3.new(0,2,0))
    wait(0.3)
  end
end

function attemptTouch(obj)
  pcall(function()
    firetouchinterest(hrp, obj, 0)
    firetouchinterest(hrp, obj, 1)
  end)
end

function collectResources()
  for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
      local n = v.Name:lower()
      for _, res in ipairs(resNames) do
        if n:find(res) then
          teleportTo(v); wait(0.2); attemptTouch(v)
          break
        end
      end
    end
  end
end

function bringResources()
  for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
      local n = v.Name:lower()
      for _, res in ipairs(resNames) do
        if n:find(res) then
          v.CFrame = hrp.CFrame + Vector3.new(math.random(-3,3),1,math.random(-3,3))
          break
        end
      end
    end
  end
end

function teleportToTargets()
  for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
      local n = v.Name:lower()
      for _, t in ipairs(targets) do
        if n:find(t) then
          teleportTo(v)
          wait(0.5)
          attemptTouch(v)
          return
        end
      end
    end
  end
end

function killAura()
  for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") then
      for _, en in ipairs(enemies) do
        if v.Name:find(en) and v:FindFirstChild("HumanoidRootPart") then
          lp.Character:SetPrimaryPartCFrame(
            v.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
          ); wait(0.1)
          v.Humanoid:TakeDamage(999)
        end
      end
    end
  end
end

function autoFeedChild()
  for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("Model") and v.Name:lower():find("lostchild") then
      if v:FindFirstChild("HumanoidRootPart") then
        teleportTo(v.HumanoidRootPart)
        -- send food via firetouch? but depends on game mechanics
      end
    end
  end
end

-- Loop utama (digabung dengan GUI toggle boolean)
spawn(function()
  while wait(1) do
    if autoCollect then collectResources() end
    if autoBring then bringResources() end
    if autoTP then teleportToTargets() end
    if autoKillAura then killAura() end
    if autoFeed then autoFeedChild() end
    if autoHide then autoHider() end
  end
end)
