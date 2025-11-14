--[[
    ═══════════════════════════════════════════════════════════
    🎮 ROLEPLAY SERVER SCRIPT - سكربت سيرفرات حياة واقعية
    ═══════════════════════════════════════════════════════════
    
    ✅ تجاوز الحماية (Anti-Cheat Bypass)
    ✅ جلب الأسلحة والأدوات
    ✅ ميزات خاصة بالحياة الواقعية
    
    ⌨️ الاختصارات:
    F1 = جلب جميع الأسلحة والأدوات
    F2 = تعديل الأسلحة
    F3 = سرعة 100
    F4 = God Mode
    F5 = طيران
    F6 = Noclip (المشي عبر الجدران)
    F7 = ESP (رؤية اللاعبين)
    F8 = Teleport للاعبين
    F9 = فتح جميع السيارات
    F10 = جلب جميع الأدوات (مفاتيح، هواتف، إلخ)
    
    ═══════════════════════════════════════════════════════════
]]

-- إشعارات
local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🎮 RP Script";
            Text = text;
            Duration = 3;
        })
    end)
end

print("═══════════════════════════════════════")
print("🎮 ROLEPLAY SERVER SCRIPT")
print("═══════════════════════════════════════")

-- المتغيرات
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")
local rep = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local flying = false
local noclip = false
local esp = false
local flySpeed = 50
local bypassedAC = 0
local espObjects = {}

-- ═══════════════════════════════════════════════════════════
-- BYPASS: تعطيل Anti-Cheat
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
            end
        end)
    end
end

for _, script in pairs(player.PlayerScripts:GetDescendants()) do
    if script:IsA("LocalScript") then
        local sName = string.lower(script.Name)
        if string.match(sName, "anti") or string.match(sName, "kick") then
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
-- BYPASS: Kick Protection
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
            return
        end
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("  ✅ Kick Protection مفعّل")
end)

print("\n[3/3] ✅ Bypass مكتمل!")

notify("✅ Bypass جاهز! " .. bypassedAC .. " حماية معطّلة")

-- ═══════════════════════════════════════════════════════════
-- F1: جلب جميع الأسلحة والأدوات
-- ═══════════════════════════════════════════════════════════
local function getAllItems()
    local found = 0
    local items = {}
    
    notify("🔍 جاري البحث...")
    print("\n🔍 البحث عن الأسلحة والأدوات...")
    
    local function safeClone(item, source)
        if table.find(items, item.Name) then return end
        pcall(function()
            wait(0.03)
            local clone = item:Clone()
            clone.Parent = backpack
            table.insert(items, item.Name)
            found = found + 1
            print("  ✅ " .. item.Name .. " ← " .. source)
        end)
    end
    
    -- البحث في ReplicatedStorage
    for _, item in pairs(rep:GetDescendants()) do
        if item:IsA("Tool") then
            safeClone(item, "ReplicatedStorage")
        end
    end
    
    -- المجلدات الشائعة
    local folders = {
        "Weapons", "Guns", "Tools", "Items", "OTSX", "Arsenal",
        "Keys", "Phones", "Food", "Drinks", "Medical", "Equipment"
    }
    
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
    
    print("\n✅ تم جلب " .. found .. " أداة!")
    notify("✅ " .. found .. " أداة مُضافة!")
end

-- ═══════════════════════════════════════════════════════════
-- F2: تعديل الأسلحة
-- ═══════════════════════════════════════════════════════════
local function modifyWeapons()
    local modified = 0
    
    notify("⚡ جاري التعديل...")
    
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("IntValue") or child:IsA("NumberValue") then
                    local name = string.lower(child.Name)
                    pcall(function()
                        if string.find(name, "ammo") then child.Value = 999999 end
                        if string.find(name, "damage") then child.Value = 999 end
                        if string.find(name, "fire") or string.find(name, "cool") then child.Value = 0.01 end
                        if string.find(name, "recoil") or string.find(name, "spread") then child.Value = 0 end
                    end)
                end
            end
            modified = modified + 1
        end
    end
    
    notify("✅ " .. modified .. " أداة معدّلة")
end

-- ═══════════════════════════════════════════════════════════
-- F3: سرعة
-- ═══════════════════════════════════════════════════════════
local function setSpeed()
    humanoid.WalkSpeed = 100
    notify("⚡ سرعة 100")
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
        
        notify("🚀 طيران ON")
        
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
    end
end

-- ═══════════════════════════════════════════════════════════
-- F6: Noclip (المشي عبر الجدران)
-- ═══════════════════════════════════════════════════════════
local function toggleNoclip()
    noclip = not noclip
    
    if noclip then
        notify("👻 Noclip ON")
        
        spawn(function()
            while noclip do
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                wait()
            end
        end)
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        notify("👻 Noclip OFF")
    end
end

-- ═══════════════════════════════════════════════════════════
-- F7: ESP (رؤية اللاعبين)
-- ═══════════════════════════════════════════════════════════
local function toggleESP()
    esp = not esp
    
    if esp then
        notify("🎯 ESP ON")
        
        for _, plr in pairs(players:GetPlayers()) do
            if plr ~= player and plr.Character then
                pcall(function()
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = plr.Character
                    table.insert(espObjects, highlight)
                    
                    -- اسم اللاعب فوق رأسه
                    local head = plr.Character:FindFirstChild("Head")
                    if head then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESPName"
                        billboard.Adornee = head
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = head
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = plr.Name
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextSize = 18
                        label.Font = Enum.Font.GothamBold
                        label.TextStrokeTransparency = 0
                        label.Parent = billboard
                        
                        table.insert(espObjects, billboard)
                    end
                end)
            end
        end
        
        -- ESP للاعبين الجدد
        players.PlayerAdded:Connect(function(plr)
            if esp then
                plr.CharacterAdded:Connect(function(char)
                    wait(1)
                    if esp then
                        pcall(function()
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.Parent = char
                            table.insert(espObjects, highlight)
                        end)
                    end
                end)
            end
        end)
    else
        for _, obj in pairs(espObjects) do
            obj:Destroy()
        end
        espObjects = {}
        
        -- حذف الأسماء
        for _, plr in pairs(players:GetPlayers()) do
            if plr.Character then
                pcall(function()
                    local head = plr.Character:FindFirstChild("Head")
                    if head and head:FindFirstChild("ESPName") then
                        head.ESPName:Destroy()
                    end
                end)
            end
        end
        
        notify("🎯 ESP OFF")
    end
end

-- ═══════════════════════════════════════════════════════════
-- F8: Teleport للاعبين
-- ═══════════════════════════════════════════════════════════
local function teleportToPlayers()
    notify("📍 اختر لاعب...")
    print("\n📍 قائمة اللاعبين:")
    
    local playersList = {}
    for i, plr in pairs(players:GetPlayers()) do
        if plr ~= player then
            table.insert(playersList, plr)
            print(i .. ". " .. plr.Name)
        end
    end
    
    if #playersList == 0 then
        notify("⚠️ لا يوجد لاعبين!")
        return
    end
    
    -- Teleport لأول لاعب (يمكن تعديله)
    local targetPlayer = playersList[1]
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        notify("✅ تم النقل إلى: " .. targetPlayer.Name)
        print("✅ تم النقل إلى: " .. targetPlayer.Name)
    end
end

-- ═══════════════════════════════════════════════════════════
-- F9: فتح جميع السيارات
-- ═══════════════════════════════════════════════════════════
local function unlockCars()
    notify("🚗 جاري فتح السيارات...")
    print("\n🚗 محاولة فتح السيارات...")
    
    local unlocked = 0
    
    -- البحث عن السيارات في Workspace
    for _, vehicle in pairs(workspace:GetDescendants()) do
        if vehicle:IsA("VehicleSeat") then
            pcall(function()
                vehicle.Disabled = false
                vehicle.MaxSpeed = 200
                unlocked = unlocked + 1
                print("  ✅ " .. vehicle.Parent.Name)
            end)
        end
        
        -- محاولة إلغاء القفل
        if vehicle:IsA("Model") and vehicle:FindFirstChild("VehicleSeat") then
            pcall(function()
                local seat = vehicle.VehicleSeat
                seat.Disabled = false
                
                -- إلغاء القفل
                for _, part in pairs(vehicle:GetDescendants()) do
                    if part:IsA("BoolValue") and string.find(string.lower(part.Name), "lock") then
                        part.Value = false
                    end
                end
                
                unlocked = unlocked + 1
            end)
        end
    end
    
    -- محاولة عبر RemoteEvents
    for _, remote in pairs(rep:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = string.lower(remote.Name)
            if string.find(name, "car") or string.find(name, "vehicle") or string.find(name, "unlock") then
                pcall(function()
                    remote:FireServer("Unlock")
                    remote:FireServer(true)
                end)
            end
        end
    end
    
    notify("🚗 تم فتح " .. unlocked .. " سيارة")
    print("✅ تم فتح " .. unlocked .. " سيارة")
end

-- ═══════════════════════════════════════════════════════════
-- F10: جلب جميع الأدوات الخاصة (مفاتيح، هواتف، إلخ)
-- ═══════════════════════════════════════════════════════════
local function getSpecialItems()
    notify("🔑 جاري البحث...")
    print("\n🔑 البحث عن الأدوات الخاصة...")
    
    local found = 0
    local specialKeywords = {
        "key", "phone", "card", "badge", "id", "wallet",
        "radio", "handcuff", "taser", "baton", "medkit"
    }
    
    for _, item in pairs(rep:GetDescendants()) do
        if item:IsA("Tool") then
            local itemName = string.lower(item.Name)
            
            for _, keyword in pairs(specialKeywords) do
                if string.find(itemName, keyword) then
                    pcall(function()
                        item:Clone().Parent = backpack
                        found = found + 1
                        print("  ✅ " .. item.Name)
                    end)
                    break
                end
            end
        end
    end
    
    notify("✅ تم جلب " .. found .. " أداة خاصة")
    print("✅ تم جلب " .. found .. " أداة خاصة")
end

-- ═══════════════════════════════════════════════════════════
-- الاختصارات
-- ═══════════════════════════════════════════════════════════
local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        getAllItems()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        modifyWeapons()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        setSpeed()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        godMode()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.F6 then
        toggleNoclip()
    elseif input.KeyCode == Enum.KeyCode.F7 then
        toggleESP()
    elseif input.KeyCode == Enum.KeyCode.F8 then
        teleportToPlayers()
    elseif input.KeyCode == Enum.KeyCode.F9 then
        unlockCars()
    elseif input.KeyCode == Enum.KeyCode.F10 then
        getSpecialItems()
    end
end)

print("\n═══════════════════════════════════════")
print("✅ كل شي جاهز!")
print("🛡️ Bypass: " .. bypassedAC .. " حماية معطّلة")
print("\n⌨️ الاختصارات:")
print("F1 = أسلحة وأدوات")
print("F2 = تعديل")
print("F3 = سرعة")
print("F4 = God Mode")
print("F5 = طيران")
print("F6 = Noclip")
print("F7 = ESP")
print("F8 = Teleport للاعبين")
print("F9 = فتح السيارات")
print("F10 = أدوات خاصة")
print("═══════════════════════════════════════")

notify("✅ جاهز! اضغط F1")
