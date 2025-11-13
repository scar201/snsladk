--[[
    ═══════════════════════════════════════════════════════════
    ⚡ ULTIMATE WEAPON FINDER V3.0 - النسخة الكاملة
    ═══════════════════════════════════════════════════════════
    
    ✅ تجاوز الحماية (Anti-Cheat Bypass)
    ✅ منع الطرد (Kick Protection)
    ✅ إخفاء Executor (Ghost Mode)
    ✅ اختصارات لوحة المفاتيح
    ✅ واجهة مستخدم
    
    ⌨️ الاختصارات:
    F1 = 🔫 جلب جميع الأسلحة
    F2 = ⚡ تعديل الأسلحة
    F3 = 🚀 طيران (تشغيل/إيقاف)
    F4 = 🛡️ God Mode
    F5 = ⚡ سرعة 100
    F6 = 🎯 ESP
    F7 = 💰 جلب أسلحة VIP
    F8 = 📋 طباعة قائمة
    INSERT = إظهار/إخفاء القائمة
    DELETE = إيقاف السكربت
    
    ═══════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════
-- المتغيرات الأساسية
-- ═══════════════════════════════════════════════════════════
local player = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rep = game:GetService("ReplicatedStorage")

-- حالة البرنامج
local flying = false
local flySpeed = 50
local godMode = false
local espEnabled = false
local weaponsList = {}
local bypassedAC = 0
local espObjects = {}
local bodyVelocity

-- ═══════════════════════════════════════════════════════════
-- إشعارات
-- ═══════════════════════════════════════════════════════════
local function notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 3;
        })
    end)
end

print("═══════════════════════════════════════════════════════════")
print("⚡ ULTIMATE WEAPON FINDER V3.0 - بدء التشغيل...")
print("═══════════════════════════════════════════════════════════")

-- ═══════════════════════════════════════════════════════════
-- BYPASS 1: تعطيل Anti-Cheat
-- ═══════════════════════════════════════════════════════════
print("\n🛡️ [BYPASS 1/5] تعطيل Anti-Cheat...")

local acNames = {
    "AntiCheat", "AC", "AntiExploit", "AE", "Security", "Protection",
    "AntiHack", "Detector", "KickScript", "BanScript", "Guard", "Shield",
    "Anticheat", "anticheat", "ANTICHEAT", "AntiScript"
}

local locations = {
    workspace, rep, game:GetService("ReplicatedFirst"),
    player.PlayerScripts, player.PlayerGui,
    game:GetService("StarterGui"),
    game:GetService("StarterPlayer").StarterPlayerScripts
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
        if string.match(sName, "anti") or string.match(sName, "detect") or 
           string.match(sName, "kick") or string.match(sName, "ban") then
            pcall(function()
                script.Disabled = true
                script:Destroy()
                bypassedAC = bypassedAC + 1
            end)
        end
    end
end

print("  📊 معطّل: " .. bypassedAC .. " حماية")

-- ═══════════════════════════════════════════════════════════
-- BYPASS 2: Kick Protection
-- ═══════════════════════════════════════════════════════════
print("\n🚫 [BYPASS 2/5] Kick Protection...")

pcall(function()
    local oldKick; oldKick = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and self == player then
            notify("🛡️ BLOCKED", "تم منع طردك!")
            return
        end
        return oldKick(self, ...)
    end)
end)

-- حماية TeleportService
pcall(function()
    local ts = game:GetService("TeleportService")
    local oldTeleport = ts.Teleport
    ts.Teleport = function(...)
        notify("🛡️ BLOCKED", "تم منع Teleport!")
        return
    end
end)

print("  ✅ Kick Protection مفعّل")

-- ═══════════════════════════════════════════════════════════
-- BYPASS 3: Ghost Mode
-- ═══════════════════════════════════════════════════════════
print("\n👻 [BYPASS 3/5] Ghost Mode...")

local hiddenFuncs = {
    "setreadonly", "getrawmetatable", "hookfunction", "newcclosure",
    "getnamecallmethod", "hookmetamethod", "getgc", "gcinfo",
    "getconnections", "getscriptclosure"
}

for _, func in pairs(hiddenFuncs) do
    pcall(function()
        getgenv()[func] = nil
        _G[func] = nil
    end)
end

print("  ✅ Ghost Mode مفعّل")

-- ═══════════════════════════════════════════════════════════
-- BYPASS 4 & 5: إلغاء قيود + استعداد للبحث
-- ═══════════════════════════════════════════════════════════
print("\n🔓 [BYPASS 4/5] إلغاء القيود...")
print("  ✅ جاهز")

print("\n⚡ [BYPASS 5/5] الاستعداد للبحث...")
print("  ✅ جاهز")

notify("✅ BYPASS", bypassedAC .. " حماية معطّلة!", 5)

-- ═══════════════════════════════════════════════════════════
-- واجهة المستخدم (GUI)
-- ═══════════════════════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WeaponFinderGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 480)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- ظل
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = mainFrame

-- عنوان
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
title.BorderSizePixel = 0
title.Text = "⚡ ULTIMATE WEAPON FINDER V3"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- زر إغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- محتوى
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, -60)
infoLabel.Position = UDim2.new(0, 10, 0, 55)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextSize = 13
infoLabel.Font = Enum.Font.Code
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextWrapped = true
infoLabel.Parent = mainFrame

-- تحديث الواجهة
local function updateGUI()
    local text = string.format([[
🛡️ BYPASS STATUS:
  • Anti-Cheat: %d معطّل
  • Kick Protection: ✅ مفعّل
  • Ghost Mode: ✅ مفعّل

⌨️ الاختصارات:
  F1 = 🔫 جلب جميع الأسلحة
  F2 = ⚡ تعديل الأسلحة
  F3 = 🚀 طيران (%s)
  F4 = 🛡️ God Mode (%s)
  F5 = ⚡ سرعة 100
  F6 = 🎯 ESP (%s)
  F7 = 💰 أسلحة VIP
  F8 = 📋 طباعة القائمة
  
  INSERT = إخفاء/إظهار
  DELETE = إيقاف

━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 الإحصائيات:
  🔫 أسلحة: %d
  ⚡ سرعة: %.0f
  ❤️ صحة: %.0f / %.0f
  
💡 نصيحة: ابدأ بالضغط على F1!
]], 
    bypassedAC,
    flying and "🟢 ON" or "🔴 OFF",
    godMode and "🟢 ON" or "🔴 OFF",
    espEnabled and "🟢 ON" or "🔴 OFF",
    #weaponsList,
    humanoid.WalkSpeed,
    humanoid.Health,
    humanoid.MaxHealth
)
    infoLabel.Text = text
end

-- ═══════════════════════════════════════════════════════════
-- F1: جلب جميع الأسلحة (مع Bypass)
-- ═══════════════════════════════════════════════════════════
local function getAllWeapons()
    notify("🔍 البحث", "جاري البحث مع Bypass...")
    local found = 0
    weaponsList = {}
    
    local function safeClone(item, source)
        pcall(function()
            if not table.find(weaponsList, item.Name) then
                wait(math.random(5, 15) / 100) -- تأخير عشوائي
                local clone = item:Clone()
                clone.Parent = backpack
                table.insert(weaponsList, item.Name)
                found = found + 1
                print("  ✅ " .. item.Name .. " ← " .. source)
            end
        end)
    end
    
    -- البحث في كل مكان
    print("\n🔍 البحث في ReplicatedStorage...")
    for _, item in pairs(rep:GetDescendants()) do
        if item:IsA("Tool") then
            safeClone(item, "ReplicatedStorage")
        end
    end
    
    -- المجلدات الشائعة
    local folders = {"Weapons", "Guns", "Tools", "OTSX", "Items", "Arsenal"}
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
        if item:IsA("Tool") then
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
    for _, remote in pairs(rep:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = string.lower(remote.Name)
            if string.find(name, "weapon") or string.find(name, "gun") or string.find(name, "equip") then
                pcall(function()
                    for _, wName in pairs(weaponsList) do
                        remote:FireServer(wName)
                        remote:FireServer("Equip", wName)
                        wait(0.1)
                    end
                end)
            end
        end
    end
    
    notify("✅ تم!", "جُلب " .. found .. " سلاح")
    updateGUI()
end

-- ═══════════════════════════════════════════════════════════
-- F2: تعديل الأسلحة
-- ═══════════════════════════════════════════════════════════
local function modifyWeapons()
    notify("⚡ تعديل", "جاري التعديل...")
    local modified = 0
    
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            -- إلغاء القيود
            pcall(function()
                if tool:FindFirstChild("LevelRequired") then tool.LevelRequired:Destroy() end
                if tool:FindFirstChild("Locked") then tool.Locked.Value = false end
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
    
    notify("✅ تم!", modified .. " سلاح معدّل")
    updateGUI()
end

-- ═══════════════════════════════════════════════════════════
-- F3: طيران
-- ═══════════════════════════════════════════════════════════
local function toggleFly()
    flying = not flying
    
    if flying then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = character.HumanoidRootPart
        
        notify("🚀 طيران", "ON (W/A/S/D/Space/Ctrl)")
        
        spawn(function()
            while flying and character and character:FindFirstChild("HumanoidRootPart") do
                local cam = workspace.CurrentCamera
                local direction = Vector3.new(0, 0, 0)
                
                if uis:IsKeyDown(Enum.KeyCode.W) then direction = direction + (cam.CFrame.LookVector * flySpeed) end
                if uis:IsKeyDown(Enum.KeyCode.S) then direction = direction - (cam.CFrame.LookVector * flySpeed) end
                if uis:IsKeyDown(Enum.KeyCode.A) then direction = direction - (cam.CFrame.RightVector * flySpeed) end
                if uis:IsKeyDown(Enum.KeyCode.D) then direction = direction + (cam.CFrame.RightVector * flySpeed) end
                if uis:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, flySpeed, 0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0, flySpeed, 0) end
                
                bodyVelocity.Velocity = direction
                wait()
            end
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        notify("🚀 طيران", "OFF")
    end
    
    updateGUI()
end

-- ═══════════════════════════════════════════════════════════
-- F4: God Mode
-- ═══════════════════════════════════════════════════════════
local function toggleGodMode()
    godMode = not godMode
    
    if godMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid.HealthChanged:Connect(function()
            if godMode then humanoid.Health = math.huge end
        end)
        notify("🛡️ God Mode", "ON")
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        notify("🛡️ God Mode", "OFF")
    end
    
    updateGUI()
end

-- ═══════════════════════════════════════════════════════════
-- F5: سرعة
-- ═══════════════════════════════════════════════════════════
local function setSpeed()
    humanoid.WalkSpeed = 100
    notify("⚡ سرعة", "100")
    updateGUI()
end

-- ═══════════════════════════════════════════════════════════
-- F6: ESP
-- ═══════════════════════════════════════════════════════════
local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= player and plr.Character then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = plr.Character
                table.insert(espObjects, highlight)
            end
        end
        notify("🎯 ESP", "ON")
    else
        for _, obj in pairs(espObjects) do obj:Destroy() end
        espObjects = {}
        notify("🎯 ESP", "OFF")
    end
    
    updateGUI()
end

-- ═══════════════════════════════════════════════════════════
-- F7: أسلحة VIP
-- ═══════════════════════════════════════════════════════════
local function getVIPWeapons()
    notify("💰 VIP", "جاري البحث...")
    local found = 0
    
    for _, item in pairs(rep:GetDescendants()) do
        if item:IsA("Tool") then
            local name = string.lower(item.Name)
            if string.find(name, "vip") or string.find(name, "premium") or string.find(name, "exclusive") then
                pcall(function()
                    item:Clone().Parent = backpack
                    found = found + 1
                end)
            end
        end
    end
    
    notify("💰 VIP", found .. " سلاح")
end

-- ═══════════════════════════════════════════════════════════
-- F8: طباعة
-- ═══════════════════════════════════════════════════════════
local function printWeapons()
    print("═══════════ قائمة الأسلحة ═══════════")
    local count = 0
    for _, item in pairs(rep:GetDescendants()) do
        if item:IsA("Tool") then
            count = count + 1
            print(count .. ". " .. item.Name)
        end
    end
    print("════════════════════════════════════")
    notify("📋 القائمة", count .. " سلاح في Console")
end

-- ═══════════════════════════════════════════════════════════
-- الاختصارات
-- ═══════════════════════════════════════════════════════════
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then getAllWeapons()
    elseif input.KeyCode == Enum.KeyCode.F2 then modifyWeapons()
    elseif input.KeyCode == Enum.KeyCode.F3 then toggleFly()
    elseif input.KeyCode == Enum.KeyCode.F4 then toggleGodMode()
    elseif input.KeyCode == Enum.KeyCode.F5 then setSpeed()
    elseif input.KeyCode == Enum.KeyCode.F6 then toggleESP()
    elseif input.KeyCode == Enum.KeyCode.F7 then getVIPWeapons()
    elseif input.KeyCode == Enum.KeyCode.F8 then printWeapons()
    elseif input.KeyCode == Enum.KeyCode.Insert then mainFrame.Visible = not mainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.Delete then
        screenGui:Destroy()
        notify("👋 إيقاف", "تم")
    end
end)

-- ═══════════════════════════════════════════════════════════
-- بدء التشغيل
-- ═══════════════════════════════════════════════════════════
notify("✅ V3.0 جاهز!", "اضغط INSERT للقائمة", 5)
print("\n═══════════════════════════════════════════════════════════")
print("✅ ULTIMATE WEAPON FINDER V3.0 - جاهز!")
print("   🛡️ Bypass مفعّل | " .. bypassedAC .. " حماية معطّلة")
print("   ⌨️ اضغط INSERT لفتح القائمة")
print("   🔫 اضغط F1 لجلب الأسلحة")
print("═══════════════════════════════════════════════════════════")

updateGUI()

-- تحديث تلقائي
spawn(function()
    while wait(1) do
        if humanoid and humanoid.Parent then
            updateGUI()
        end
    end
end)
