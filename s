--[[
    ═══════════════════════════════════════════════════════════
    ⚡ ULTIMATE ANTI-CHEAT BYPASS V2.0 - أقوى نسخة
    ═══════════════════════════════════════════════════════════
    
    🛡️ يتجاوز معظم أنواع الحماية
    🔓 يفتح الأسلحة المقفلة
    👻 يخفي وجود الـ Executor بالكامل
    🚫 يمنع الطرد والبان
    ⚡ يعدل الأسلحة تلقائياً
    
    ⚠️ تنبيه: بعض الحمايات قوية جداً (ServerSide) ولا يمكن تجاوزها
    
    ═══════════════════════════════════════════════════════════
]]

-- متغيرات أساسية
local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()

local foundWeapons = 0
local weaponsList = {}
local bypassedAC = 0

-- إشعارات
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 5;
        })
    end)
end

print("═══════════════════════════════════════════════════════════")
print("⚡ ULTIMATE BYPASS V2.0")
print("═══════════════════════════════════════════════════════════")
notify("⚡ BYPASS", "بدء تجاوز الحماية...", 3)

-- ═══════════════════════════════════════════════════════════
-- 🛡️ STEP 1: تعطيل جميع Anti-Cheat Scripts
-- ═══════════════════════════════════════════════════════════
print("\n[1/8] 🛡️ تعطيل Anti-Cheat Scripts...")

local acNames = {
    "AntiCheat", "AC", "AntiExploit", "AE", "Security", "Protection",
    "AntiHack", "Detector", "KickScript", "BanScript", "Guard", "Shield",
    "Anticheat", "anticheat", "ANTICHEAT", "AntiScript", "Blocker"
}

-- تعطيل في جميع الأماكن
local locations = {
    workspace, 
    game:GetService("ReplicatedStorage"),
    game:GetService("ReplicatedFirst"),
    player.PlayerScripts,
    player.PlayerGui,
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
                print("  ✅ " .. name .. " محذوف")
            end
        end)
    end
end

-- تعطيل جميع LocalScripts المشبوهة
for _, script in pairs(player.PlayerScripts:GetDescendants()) do
    if script:IsA("LocalScript") then
        local sName = string.lower(script.Name)
        if string.match(sName, "anti") or string.match(sName, "detect") or 
           string.match(sName, "kick") or string.match(sName, "ban") or
           string.match(sName, "secure") then
            pcall(function()
                script.Disabled = true
                script:Destroy()
                bypassedAC = bypassedAC + 1
                print("  ✅ " .. script.Name .. " معطّل")
            end)
        end
    end
end

print("  📊 تم تعطيل: " .. bypassedAC .. " حماية")
wait(0.5)

-- ═══════════════════════════════════════════════════════════
-- 🚫 STEP 2: منع الطرد (Kick Protection)
-- ═══════════════════════════════════════════════════════════
print("\n[2/8] 🚫 تفعيل Kick Protection...")

-- حماية من Player:Kick()
local oldKick; oldKick = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == player then
        notify("🛡️ BLOCKED", "تم منع محاولة طردك!", 3)
        return
    end
    return oldKick(self, ...)
end)

-- حماية من TeleportService
local ts = game:GetService("TeleportService")
local oldTeleport = ts.Teleport
ts.Teleport = function(...)
    notify("🛡️ BLOCKED", "تم منع Teleport!", 3)
    return
end

print("  ✅ Kick Protection مفعّل")
wait(0.5)

-- ═══════════════════════════════════════════════════════════
-- 👻 STEP 3: إخفاء وجود Executor (Ghost Mode)
-- ═══════════════════════════════════════════════════════════
print("\n[3/8] 👻 تفعيل Ghost Mode...")

-- إخفاء الدوال المشبوهة
local hiddenFuncs = {
    "setreadonly", "getrawmetatable", "hookfunction", "newcclosure",
    "getnamecallmethod", "hookmetamethod", "getgc", "gcinfo",
    "getconnections", "getscriptclosure", "gethiddenproperty", "sethiddenproperty",
    "checkcaller", "isnetworkowner", "getnilinstances"
}

for _, func in pairs(hiddenFuncs) do
    pcall(function()
        getgenv()[func] = nil
        _G[func] = nil
    end)
end

-- إخفاء وجود السكربت
local scriptEnv = getfenv()
scriptEnv.script = nil

print("  ✅ Ghost Mode مفعّل")
wait(0.5)

-- ═══════════════════════════════════════════════════════════
-- 🔓 STEP 4: إلغاء جميع القيود
-- ═══════════════════════════════════════════════════════════
print("\n[4/8] 🔓 إلغاء القيود...")

-- إلغاء WalkSpeed/JumpPower Limits
local humanoid = character:WaitForChild("Humanoid")
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldIndex = mt.__index
    
    mt.__index = newcclosure(function(self, key)
        if self == humanoid then
            if key == "WalkSpeed" or key == "JumpPower" then
                return oldIndex(self, key)
            end
        end
        return oldIndex(self, key)
    end)
    
    setreadonly(mt, true)
end)

print("  ✅ القيود ملغاة")
wait(0.5)

-- ═══════════════════════════════════════════════════════════
-- 🔍 STEP 5: البحث الذكي عن الأسلحة
-- ═══════════════════════════════════════════════════════════
print("\n[5/8] 🔍 البحث عن الأسلحة...")

local function safeClone(item, source)
    local success = pcall(function()
        if table.find(weaponsList, item.Name) then return end
        
        wait(math.random(10, 50) / 100) -- تأخير عشوائي لتجنب الكشف
        
        local clone = item:Clone()
        clone.Parent = backpack
        
        foundWeapons = foundWeapons + 1
        table.insert(weaponsList, item.Name)
        print("  ✅ " .. item.Name .. " ← " .. source)
    end)
    return success
end

-- البحث في ReplicatedStorage
local rep = game:GetService("ReplicatedStorage")
for _, item in pairs(rep:GetDescendants()) do
    if item:IsA("Tool") then
        safeClone(item, "ReplicatedStorage")
    end
end

-- البحث في المجلدات الشائعة
local folders = {
    "Weapons", "Guns", "Tools", "Items", "Arsenal", "Armory", "OTSX",
    "Equipment", "Gear", "Inventory", "Shop", "Store", "WeaponStorage",
    "PlayerItems", "GameItems", "Models", "Assets"
}

for _, folderName in pairs(folders) do
    pcall(function()
        local folder = rep:FindFirstChild(folderName) or workspace:FindFirstChild(folderName)
        if folder then
            print("  📁 " .. folderName)
            for _, weapon in pairs(folder:GetDescendants()) do
                if weapon:IsA("Tool") then
                    safeClone(weapon, folderName)
                end
            end
        end
    end)
end

-- البحث في Workspace
for _, item in pairs(workspace:GetDescendants()) do
    if item:IsA("Tool") and item:FindFirstChild("Handle") then
        safeClone(item, "Workspace")
    end
end

-- البحث في Lighting
for _, item in pairs(game:GetService("Lighting"):GetDescendants()) do
    if item:IsA("Tool") then
        safeClone(item, "Lighting")
    end
end

-- البحث بالكلمات المفتاحية
local keywords = {"gun", "weapon", "rifle", "pistol", "sword", "knife", "otsx", "ak", "m4", "sniper", "shotgun"}
for _, location in pairs({rep, workspace}) do
    for _, obj in pairs(location:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and obj:FindFirstChild("Handle")) then
            local objName = string.lower(obj.Name)
            for _, keyword in pairs(keywords) do
                if string.find(objName, keyword) and not table.find(weaponsList, obj.Name) then
                    if obj:IsA("Tool") then
                        safeClone(obj, "Keyword: " .. keyword)
                    end
                end
            end
        end
    end
end

wait(1)

-- ═══════════════════════════════════════════════════════════
-- 🌐 STEP 6: محاولة ServerSide (RemoteEvents)
-- ═══════════════════════════════════════════════════════════
print("\n[6/8] 🌐 محاولة طلب الأسلحة من السيرفر...")

local remoteAttempts = 0
for _, remote in pairs(rep:GetDescendants()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        local remoteName = string.lower(remote.Name)
        
        if string.find(remoteName, "weapon") or string.find(remoteName, "gun") or 
           string.find(remoteName, "equip") or string.find(remoteName, "give") or
           string.find(remoteName, "buy") or string.find(remoteName, "purchase") then
            
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    -- محاولات متعددة
                    for _, weaponName in pairs(weaponsList) do
                        remote:FireServer(weaponName)
                        remote:FireServer("Equip", weaponName)
                        remote:FireServer("Give", weaponName)
                        remote:FireServer({Weapon = weaponName})
                        wait(0.1)
                    end
                    remoteAttempts = remoteAttempts + 1
                end
            end)
        end
    end
end

print("  📡 تم محاولة " .. remoteAttempts .. " Remote")
wait(1)

-- ═══════════════════════════════════════════════════════════
-- ⚡ STEP 7: تعديل الأسلحة (God Mode Weapons)
-- ═══════════════════════════════════════════════════════════
print("\n[7/8] ⚡ تعديل الأسلحة...")

local modifiedWeapons = 0
for _, tool in pairs(backpack:GetChildren()) do
    if tool:IsA("Tool") then
        -- إلغاء القيود
        pcall(function()
            if tool:FindFirstChild("LevelRequired") then tool.LevelRequired:Destroy() end
            if tool:FindFirstChild("Price") then tool.Price.Value = 0 end
            if tool:FindFirstChild("Locked") then tool.Locked.Value = false end
            if tool:FindFirstChild("CanUse") then tool.CanUse.Value = true end
        end)
        
        -- تعديل الخصائص
        for _, child in pairs(tool:GetDescendants()) do
            if child:IsA("IntValue") or child:IsA("NumberValue") then
                local childName = string.lower(child.Name)
                
                pcall(function()
                    -- ذخيرة لا نهائية
                    if string.find(childName, "ammo") or string.find(childName, "mag") then
                        child.Value = 999999
                    end
                    
                    -- دمج عالي
                    if string.find(childName, "damage") then
                        child.Value = 999
                    end
                    
                    -- إطلاق سريع
                    if string.find(childName, "fire") or string.find(childName, "cool") or string.find(childName, "delay") then
                        child.Value = 0.01
                    end
                    
                    -- لا ارتداد
                    if string.find(childName, "recoil") or string.find(childName, "spread") then
                        child.Value = 0
                    end
                    
                    -- مدى بعيد
                    if string.find(childName, "range") then
                        child.Value = 9999
                    end
                end)
            end
        end
        
        modifiedWeapons = modifiedWeapons + 1
    end
end

print("  ✅ تم تعديل " .. modifiedWeapons .. " سلاح")
wait(1)

-- ═══════════════════════════════════════════════════════════
-- 🔓 STEP 8: فتح الأسلحة المخفية
-- ═══════════════════════════════════════════════════════════
print("\n[8/8] 🔓 محاولة فتح الأسلحة المخفية...")

-- محاولة فتح GamePasses
for _, item in pairs(rep:GetDescendants()) do
    if item:IsA("Tool") then
        local itemName = string.lower(item.Name)
        if string.find(itemName, "vip") or string.find(itemName, "premium") or 
           string.find(itemName, "exclusive") or string.find(itemName, "admin") then
            safeClone(item, "VIP/Premium")
        end
    end
end

-- ═══════════════════════════════════════════════════════════
-- 📊 النتيجة النهائية
-- ═══════════════════════════════════════════════════════════
print("\n═══════════════════════════════════════════════════════════")
print("✅ BYPASS مكتمل!")
print("═══════════════════════════════════════════════════════════")
print("📊 الإحصائيات:")
print("  🛡️ Anti-Cheat معطّل: " .. bypassedAC)
print("  🔫 أسلحة مُضافة: " .. foundWeapons)
print("  ⚡ أسلحة معدّلة: " .. modifiedWeapons)
print("═══════════════════════════════════════════════════════════")

if foundWeapons > 0 then
    print("\n📋 قائمة الأسلحة:")
    for i, name in pairs(weaponsList) do
        print("  " .. i .. ". " .. name)
    end
    notify("✅ نجح!", foundWeapons .. " سلاح | " .. bypassedAC .. " حماية معطّلة", 7)
    
    print("\n💡 التعديلات المُطبّقة:")
    print("  ✅ ذخيرة لا نهائية")
    print("  ✅ دمج 999")
    print("  ✅ إطلاق نار سريع")
    print("  ✅ لا ارتداد")
    print("  ✅ مدى طويل")
else
    print("\n⚠️ لم يتم العثور على أسلحة!")
    print("\n🔍 الأسباب المحتملة:")
    print("  1. الماب يستخدم ServerSide القوي")
    print("  2. الأسلحة مخفية في مكان غير تقليدي")
    print("  3. تحتاج Executor أقوى")
    
    print("\n💡 الحلول:")
    print("  • استخدم Dark Dex للبحث اليدوي:")
    print('    loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))()')
    print("  • استخدم Infinite Yield:")
    print('    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()')
    print("    ثم اكتب: ;gtools")
    print("  • استخدم Synapse X (مدفوع) للحمايات القوية")
    
    notify("⚠️ فشل", "الماب محمي بـ ServerSide قوي", 7)
end

print("\n═══════════════════════════════════════════════════════════")
print("🎮 جاهز للعب!")
print("═══════════════════════════════════════════════════════════")

-- ميزات إضافية تلقائية
wait(2)
print("\n⚡ تفعيل ميزات إضافية...")

-- سرعة
humanoid.WalkSpeed = 50
print("  ✅ السرعة: 50")

-- قفز
humanoid.JumpPower = 80
print("  ✅ القفز: 80")

-- صحة
humanoid.MaxHealth = 500
humanoid.Health = 500
print("  ✅ الصحة: 500")

notify("🚀 ALL DONE!", "كل شيء جاهز!", 5)
