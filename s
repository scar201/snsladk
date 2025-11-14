--[[
    ═══════════════════════════════════════════════════════════
    🔫 SIMPLE WEAPON FINDER - نسخة بسيطة ومضمونة 100%
    ═══════════════════════════════════════════════════════════
    
    ⌨️ الاختصارات:
    F1 = جلب جميع الأسلحة
    F2 = تعديل الأسلحة (ذخيرة لا نهائية)
    F3 = سرعة 100
    F4 = God Mode
    F5 = طيران
    
    ═══════════════════════════════════════════════════════════
]]

-- إشعار بسيط
local function notify(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔫 Weapon Finder";
        Text = text;
        Duration = 3;
    })
end

-- المتغيرات
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")

local flying = false
local flySpeed = 50

print("═══════════════════════════════════════")
print("🔫 Simple Weapon Finder تم التحميل!")
print("اضغط F1 لجلب الأسلحة")
print("═══════════════════════════════════════")

notify("✅ تم التحميل! اضغط F1")

-- ═══════════════════════════════════════════════════════════
-- F1: جلب جميع الأسلحة
-- ═══════════════════════════════════════════════════════════
local function getWeapons()
    local found = 0
    
    notify("🔍 جاري البحث...")
    print("\n🔍 البحث عن الأسلحة...")
    
    -- البحث في ReplicatedStorage
    for _, item in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if item:IsA("Tool") then
            local success = pcall(function()
                local clone = item:Clone()
                clone.Parent = backpack
                found = found + 1
                print("✅ " .. item.Name)
            end)
            wait(0.05)
        end
    end
    
    -- البحث في Workspace
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") and item:FindFirstChild("Handle") then
            pcall(function()
                local clone = item:Clone()
                clone.Parent = backpack
                found = found + 1
                print("✅ " .. item.Name)
            end)
            wait(0.05)
        end
    end
    
    -- البحث في مجلدات الأسلحة
    local folders = {"Weapons", "Guns", "Tools", "Items", "OTSX", "Arsenal"}
    for _, folderName in pairs(folders) do
        local folder = game:GetService("ReplicatedStorage"):FindFirstChild(folderName)
        if folder then
            print("📁 وُجد: " .. folderName)
            for _, weapon in pairs(folder:GetChildren()) do
                if weapon:IsA("Tool") then
                    pcall(function()
                        weapon:Clone().Parent = backpack
                        found = found + 1
                        print("  ✅ " .. weapon.Name)
                    end)
                    wait(0.05)
                end
            end
        end
    end
    
    print("\n✅ تم جلب " .. found .. " سلاح!")
    notify("✅ تم جلب " .. found .. " سلاح!")
end

-- ═══════════════════════════════════════════════════════════
-- F2: تعديل الأسلحة
-- ═══════════════════════════════════════════════════════════
local function modifyWeapons()
    local modified = 0
    
    notify("⚡ جاري التعديل...")
    print("\n⚡ تعديل الأسلحة...")
    
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            -- تعديل القيم
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("IntValue") or child:IsA("NumberValue") then
                    local name = string.lower(child.Name)
                    
                    -- ذخيرة لا نهائية
                    if string.find(name, "ammo") or string.find(name, "mag") then
                        child.Value = 999999
                    end
                    
                    -- دمج عالي
                    if string.find(name, "damage") then
                        child.Value = 500
                    end
                    
                    -- إطلاق سريع
                    if string.find(name, "fire") or string.find(name, "cool") or string.find(name, "rate") then
                        child.Value = 0.01
                    end
                    
                    -- لا ارتداد
                    if string.find(name, "recoil") or string.find(name, "spread") then
                        child.Value = 0
                    end
                end
            end
            modified = modified + 1
        end
    end
    
    print("✅ تم تعديل " .. modified .. " سلاح")
    notify("✅ تم تعديل " .. modified .. " سلاح")
end

-- ═══════════════════════════════════════════════════════════
-- F3: سرعة
-- ═══════════════════════════════════════════════════════════
local function setSpeed()
    humanoid.WalkSpeed = 100
    print("⚡ السرعة: 100")
    notify("⚡ السرعة: 100")
end

-- ═══════════════════════════════════════════════════════════
-- F4: God Mode
-- ═══════════════════════════════════════════════════════════
local function godMode()
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    humanoid.HealthChanged:Connect(function()
        humanoid.Health = math.huge
    end)
    
    print("🛡️ God Mode مفعّل!")
    notify("🛡️ God Mode مفعّل!")
end

-- ═══════════════════════════════════════════════════════════
-- F5: طيران
-- ═══════════════════════════════════════════════════════════
local function toggleFly()
    flying = not flying
    
    if flying then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "FlyGyro"
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 9e4
        bodyGyro.Parent = rootPart
        
        notify("🚀 طيران ON (W/A/S/D)")
        print("🚀 طيران مفعّل!")
        
        spawn(function()
            local uis = game:GetService("UserInputService")
            while flying and rootPart and rootPart.Parent do
                local cam = workspace.CurrentCamera
                bodyGyro.CFrame = cam.CFrame
                
                local direction = Vector3.new(0, 0, 0)
                
                if uis:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + (cam.CFrame.LookVector * flySpeed)
                end
                if uis:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - (cam.CFrame.LookVector * flySpeed)
                end
                if uis:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - (cam.CFrame.RightVector * flySpeed)
                end
                if uis:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + (cam.CFrame.RightVector * flySpeed)
                end
                if uis:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, flySpeed, 0)
                end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, flySpeed, 0)
                end
                
                bodyVelocity.Velocity = direction
                wait()
            end
        end)
    else
        if rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity:Destroy()
        end
        if rootPart:FindFirstChild("FlyGyro") then
            rootPart.FlyGyro:Destroy()
        end
        notify("🚀 طيران OFF")
        print("🚀 طيران معطّل")
    end
end

-- ═══════════════════════════════════════════════════════════
-- الاختصارات
-- ═══════════════════════════════════════════════════════════
local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        getWeapons()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        modifyWeapons()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        setSpeed()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        godMode()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        toggleFly()
    end
end)

print("\n✅ كل شي جاهز!")
print("═══════════════════════════════════════")
