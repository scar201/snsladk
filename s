--[[
    ═══════════════════════════════════════════════════════════
    🔫 WEAPON FINDER + ANTI-CHEAT BYPASS - النسخة النهائية
    ═══════════════════════════════════════════════════════════
    
    ✅ تجاوز الحماية (Anti-Cheat Bypass)
    ✅ منع الطرد (Kick Protection)
    ✅ جلب الأسلحة من كل مكان
    ✅ تعديل الأسلحة تلقائياً
    
    ⌨️ الاختصارات:
    F1 = جلب جميع الأسلحة
    F2 = تعديل الأسلحة
    F3 = سرعة 100
    F4 = God Mode
    F5 = طيران
    
    ═══════════════════════════════════════════════════════════
]]

-- إشعارات
local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔫 Weapon Finder";
            Text = text;
            Duration = 3;
        })
    end)
end

print("═══════════════════════════════════════")
print("🔫 WEAPON FINDER + BYPASS")
print("═══════════════════════════════════════")

-- المتغيرات
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")
local rep = game:GetService("ReplicatedStorage")

local flying = false
local flySpeed = 50
local bypassedAC = 0

-- ═══════════════════════════════════════════════════════════
-- STEP 1: تعطيل Anti-Cheat
-- ═══════════════════════════════════════════════════════════
print("\n[1/3] 🛡️ تعطيل Anti-Cheat...")

local acNames = {
    "AntiCheat", "AC", "AntiExploit", "Security", "Protection",
    "AntiHack", "Detector", "KickScript", "BanScript", "Guard"
}

local locations = {
    workspace, rep, player.PlayerScripts, player.PlayerGui
}

for _, location in pairs(locations) do
    for _, name in pairs(acNames) do
        pcall(function()
            local ac = location:FindFirstChild(name, true)
            if ac then
                ac:Destroy()
                bypassedAC = bypassedAC + 1
                print("  ✅ " .. name)
            end
        end)
    end
end

-- تعطيل LocalScripts المشبوهة
for _, script in pairs(player.PlayerScripts:GetDescendants()) do
    if script:IsA("LocalScript") then
        local sName = string.lower(script.Name)
        if string.match(sName, "anti") or string.match(sName, "kick") or string.match(sName, "ban") then
            pcall(function()
                script.Disabled = true
                script:Destroy()
                bypassedAC = bypassedAC + 1
            end)
        end
    end
end

print("  📊 تم تعطيل: " .. bypassedAC .. " حماية")

-- ═══════════════════════════════════════════════════════════
-- STEP 2: Kick Protection
-- ═══════════════════════════════════════════════════════════
print("\n[2/3] 🚫 Kick Protection...")

pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and self == player then
            notify("🛡️ تم منع الطرد!")
            print("  🛡️ تم منع محاولة طرد!")
            return
        end
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("  ✅ Kick Protection مفعّل")
end)

-- حماية TeleportService
pcall(function()
    local ts = game:GetService("TeleportService")
    ts.Teleport = function() 
        notify("🛡️ تم منع Teleport!")
        return 
    end
    print("  ✅ Teleport Protection مفعّل")
end)

-- ═══════════════════════════════════════════════════════════
-- STEP 3: Ghost Mode (إخفاء Executor)
-- ═══════════════════════════════════════════════════════════
print("\n[3/3] 👻 Ghost Mode...")

local funcs = {
    "getrawmetatable", "hookmetamethod", "newcclosure",
    "setreadonly", "getnamecallmethod"
}

for _, func in pairs(funcs) do
    pcall(function()
        getgenv()[func] = nil
        _G[func] = nil
    end)
end

print("  ✅ Ghost Mode مفعّل")

notify("✅ Bypass مكتمل! " .. bypassedAC .. " حماية معطّلة")

-- ═══════════════════════════════════════════════════════════
-- F1: جلب الأسلحة مع Bypass
-- ═══════════════════════════════════════════════════════════
local function getWeapons()
    local found = 0
    local weapons = {}
    
    notify("🔍 جاري البحث...")
    print("\n🔍 البحث عن الأسلحة...")
    
    local function safeClone(item, source)
        if table.find(weapons, item.Name) then return end
        pcall(function()
            wait(0.03) -- تأخير صغير لتجنب الكشف
            local clone = item:Clone()
            clone.Parent = backpack
            table.insert(weapons, item.Name)
            found = found + 1
            print("  ✅ " .. item.Name .. " ← " .. source)
        end)
    end
    
    -- ReplicatedStorage
    for _, item in pairs(rep:GetDescendants()) do
        if item:IsA("Tool") then
            safeClone(item, "ReplicatedStorage")
        end
    end
    
    -- المجلدات الشائعة
    local folders = {"Weapons", "Guns", "Tools", "Items", "OTSX", "Arsenal", "Armory"}
    for _, folderName in pairs(folders) do
        local folder = rep:FindFirstChild(folderName) or workspace:FindFirstChild(folderName)
        if folder then
            print("📁 " .. folderName)
            for _, weapon in pairs(folder:GetDescendants()) do
                if weapon:IsA("Tool") then
                    safeClone(weapon, folderName)
                end
            end
        end
    end
    
    -- Workspace
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") and item:FindFirstChild("Handle") then
            safeClone(item, "Workspace")
        end
    end
    
    -- Lighting
    for _, item in pairs(game:GetService("Lighting"):GetDescendants()) do
        if item:IsA("Tool") then
            safeClone(item, "Lighting")
        end
    end
    
    -- محاولة RemoteEvents
    print("\n🌐 محاولة طلب من السيرفر...")
    for _, remote in pairs(rep:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = string.lower(remote.Name)
            if string.find(name, "weapon") or string.find(name, "gun") or string.find(name, "equip") then
                pcall(function()
                    for _, wName in pairs(weapons) do
                        remote:FireServer(wName)
                        remote:FireServer("Equip", wName)
                        wait(0.05)
                    end
                end)
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
            -- إلغاء القيود
            pcall(function()
                if tool:FindFirstChild("LevelRequired") then tool.LevelRequired:Destroy() end
                if tool:FindFirstChild("Locked") then tool.Locked.Value = false end
                if tool:FindFirstChild("Price") then tool.Price.Value = 0 end
            end)
            
            -- تعديل القيم
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("IntValue") or child:IsA("NumberValue") then
                    local name = string.lower(child.Name)
                    pcall(function()
                        if string.find(name, "ammo") then child.Value = 999999 end
                        if string.find(name, "damage") then child.Value = 999 end
                        if string.find(name, "fire") or string.find(name, "cool") then child.Value = 0.01 end
                        if string.find(name, "recoil") or string.find(name, "spread") then child.Value = 0 end
                        if string.find(name, "range") then child.Value = 9999 end
                    end)
                end
            end
            modified = modified + 1
        end
    end
    
    print("✅ تم تعديل " .. modified .. " سلاح")
    notify("✅ " .. modified .. " سلاح معدّل")
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
    
    print("🛡️ God Mode ON")
    notify("🛡️ God Mode ON")
end

-- ═══════════════════════════════════════════════════════════
-- F5: طيران
-- ═══════════════════════════════════════════════════════════
local function toggleFly()
    flying = not flying
    
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = rootPart
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9e4
        bg.Parent = rootPart
        
        notify("🚀 طيران ON (W/A/S/D/Space/Shift)")
        print("🚀 طيران ON")
        
        spawn(function()
            local uis = game:GetService("UserInputService")
            while flying and rootPart and rootPart.Parent do
                local cam = workspace.CurrentCamera
                bg.CFrame = cam.CFrame
                
                local dir = Vector3.new(0, 0, 0)
                
                if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + (cam.CFrame.LookVector * flySpeed) end
                if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - (cam.CFrame.LookVector * flySpeed) end
                if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - (cam.CFrame.RightVector * flySpeed) end
                if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + (cam.CFrame.RightVector * flySpeed) end
                if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, flySpeed, 0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, flySpeed, 0) end
                
                bv.Velocity = dir
                wait()
            end
        end)
    else
        if rootPart:FindFirstChild("FlyVelocity") then rootPart.FlyVelocity:Destroy() end
        if rootPart:FindFirstChild("FlyGyro") then rootPart.FlyGyro:Destroy() end
        notify("🚀 طيران OFF")
        print("🚀 طيران OFF")
    end
end

-- ═══════════════════════════════════════════════════════════
-- الاختصارات
-- ═══════════════════════════════════════════════════════════
local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, processed)
    if processed then return end
    
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

print("\n═══════════════════════════════════════")
print("✅ كل شي جاهز!")
print("🛡️ Bypass: " .. bypassedAC .. " حماية معطّلة")
print("⌨️ اضغط F1 لجلب الأسلحة")
print("═══════════════════════════════════════")

notify("✅ جاهز! اضغط F1")
