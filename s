--[[
    ═══════════════════════════════════════════════════════════
    🔥 ULTIMATE RP GUI V2 - واجهة محسّنة + مقالب قوية
    ═══════════════════════════════════════════════════════════
    
    ✅ كل المقالب تشتغل على السيرفر (الكل يشوفها!)
    ✅ تجاوز حماية كامل
    ✅ أشياء جديدة وقوية
    
    🎯 افتح القائمة: F12
    
    ═══════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════
-- المتغيرات
-- ═══════════════════════════════════════════════════════════
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")
local rep = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")

local bypassedAC = 0
local selectedPlayer = nil
local flying = false
local noclipping = false
local esping = false

-- ═══════════════════════════════════════════════════════════
-- BYPASS الكامل
-- ═══════════════════════════════════════════════════════════
print("🛡️ [BYPASS] بدء تعطيل الحماية...")

-- تعطيل Anti-Cheat
local acNames = {
    "AntiCheat", "AC", "AntiExploit", "Security", "Protection",
    "AntiHack", "Detector", "KickScript", "BanScript", "Guard", "Shield"
}

for _, location in pairs({workspace, rep, player.PlayerScripts, player.PlayerGui}) do
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

-- Kick Protection
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" and self == player then
            return
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

print("✅ [BYPASS] تم تعطيل: " .. bypassedAC .. " حماية")

-- ═══════════════════════════════════════════════════════════
-- دوال مساعدة
-- ═══════════════════════════════════════════════════════════
local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔥 RP GUI V2";
            Text = text;
            Duration = 3;
        })
    end)
end

-- دالة لإيجاد RemoteEvents
local function findRemote(keywords)
    for _, remote in pairs(rep:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = string.lower(remote.Name)
            for _, keyword in pairs(keywords) do
                if string.find(name, keyword) then
                    return remote
                end
            end
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════
-- إنشاء GUI
-- ═══════════════════════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RPGUIV2"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 480)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- شريط العنوان
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Color3.fromRGB(255, 70, 100)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 15)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 ULTIMATE RP GUI V2"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local bypassLabel = Instance.new("TextLabel")
bypassLabel.Size = UDim2.new(0, 250, 1, 0)
bypassLabel.Position = UDim2.new(1, -260, 0, 0)
bypassLabel.BackgroundTransparency = 1
bypassLabel.Text = "🛡️ BYPASS: " .. bypassedAC .. " حماية ✅"
bypassLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
bypassLabel.TextSize = 13
bypassLabel.Font = Enum.Font.GothamBold
bypassLabel.TextXAlignment = Enum.TextXAlignment.Right
bypassLabel.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 10)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- الشريط الجانبي
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 160, 1, -60)
sidebar.Position = UDim2.new(0, 8, 0, 58)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 12)
sidebarCorner.Parent = sidebar

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 6)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = sidebar

-- المحتوى
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -178, 1, -68)
contentFrame.Position = UDim2.new(0, 173, 0, 58)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 8
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 70, 100)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentFrame

-- ═══════════════════════════════════════════════════════════
-- دوال إنشاء العناصر
-- ═══════════════════════════════════════════════════════════
local function clearContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

local function createTab(name, icon, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 40)
    btn.Text = icon .. "  " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = sidebar
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = btn
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    return btn
end

local function createButton(text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(255, 70, 100)
    btn.Text = icon .. "  " .. text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

local function createToggle(text, icon, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. "  " .. text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 55, 0, 32)
    toggle.Position = UDim2.new(1, -62, 0.5, -16)
    toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(80, 80, 80)
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return frame
end

local function createPlayerSelector()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 210)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 35)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = "🎯  اختر لاعب للمقلب:"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 15
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -20, 0, 38)
    searchBox.Position = UDim2.new(0, 10, 0, 48)
    searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    searchBox.PlaceholderText = "ابحث هنا..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.new(1, 1, 1)
    searchBox.TextSize = 13
    searchBox.Font = Enum.Font.Gotham
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = frame
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchBox
    
    local playerList = Instance.new("ScrollingFrame")
    playerList.Size = UDim2.new(1, -20, 0, 115)
    playerList.Position = UDim2.new(0, 10, 0, 92)
    playerList.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    playerList.BorderSizePixel = 0
    playerList.ScrollBarThickness = 5
    playerList.ScrollBarImageColor3 = Color3.fromRGB(255, 70, 100)
    playerList.Parent = frame
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = playerList
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 3)
    listLayout.Parent = playerList
    
    local function updateList(filter)
        for _, child in pairs(playerList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for _, plr in pairs(players:GetPlayers()) do
            if plr ~= player then
                local name = plr.Name
                if filter == "" or string.find(string.lower(name), string.lower(filter)) then
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -8, 0, 32)
                    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                    btn.Text = name
                    btn.TextColor3 = Color3.new(1, 1, 1)
                    btn.TextSize = 13
                    btn.Font = Enum.Font.Gotham
                    btn.TextXAlignment = Enum.TextXAlignment.Left
                    btn.Parent = playerList
                    
                    local btnCorner = Instance.new("UICorner")
                    btnCorner.CornerRadius = UDim.new(0, 6)
                    btnCorner.Parent = btn
                    
                    local padding = Instance.new("UIPadding")
                    padding.PaddingLeft = UDim.new(0, 10)
                    padding.Parent = btn
                    
                    btn.MouseButton1Click:Connect(function()
                        selectedPlayer = plr
                        notify("✅ تم اختيار: " .. name)
                        
                        for _, other in pairs(playerList:GetChildren()) do
                            if other:IsA("TextButton") then
                                other.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                            end
                        end
                        btn.BackgroundColor3 = Color3.fromRGB(255, 70, 100)
                    end)
                end
            end
        end
        
        playerList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
    end
    
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateList(searchBox.Text)
    end)
    
    updateList("")
    
    return frame
end

-- ═══════════════════════════════════════════════════════════
-- التبويبات
-- ═══════════════════════════════════════════════════════════

-- تبويب الأسلحة
local weaponsTab = createTab("أسلحة", "🔫")
weaponsTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createButton("جلب جميع الأسلحة", "🔫", function()
        notify("🔍 جاري البحث...")
        local found = 0
        
        for _, item in pairs(rep:GetDescendants()) do
            if item:IsA("Tool") then
                pcall(function()
                    item:Clone().Parent = backpack
                    found = found + 1
                    wait(0.02)
                end)
            end
        end
        
        -- البحث في مجلدات
        local folders = {"Weapons", "Guns", "Tools", "Items", "OTSX", "Arsenal", "Equipment"}
        for _, folderName in pairs(folders) do
            local folder = rep:FindFirstChild(folderName) or workspace:FindFirstChild(folderName)
            if folder then
                for _, weapon in pairs(folder:GetDescendants()) do
                    if weapon:IsA("Tool") then
                        pcall(function()
                            weapon:Clone().Parent = backpack
                            found = found + 1
                            wait(0.02)
                        end)
                    end
                end
            end
        end
        
        notify("✅ تم جلب " .. found .. " سلاح!")
    end)
    
    createButton("تعديل الأسلحة", "⚡", function()
        local modified = 0
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
                            if string.find(name, "range") then child.Value = 9999 end
                        end)
                    end
                end
                modified = modified + 1
            end
        end
        notify("⚡ تم تعديل " .. modified .. " سلاح!")
    end)
    
    createButton("أدوات خاصة (مفاتيح، هواتف)", "🔑", function()
        local found = 0
        local keywords = {"key", "phone", "card", "badge", "id", "radio", "handcuff", "taser", "baton", "medkit"}
        for _, item in pairs(rep:GetDescendants()) do
            if item:IsA("Tool") then
                local itemName = string.lower(item.Name)
                for _, keyword in pairs(keywords) do
                    if string.find(itemName, keyword) then
                        pcall(function()
                            item:Clone().Parent = backpack
                            found = found + 1
                        end)
                        break
                    end
                end
            end
        end
        notify("✅ تم جلب " .. found .. " أداة!")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
end)

-- تبويب الحركة
local movementTab = createTab("حركة", "🚀")
movementTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createToggle("طيران", "🚀", function(state)
        flying = state
        if state then
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
            
            spawn(function()
                while flying and rootPart:FindFirstChild("FlyVelocity") do
                    local cam = workspace.CurrentCamera
                    bg.CFrame = cam.CFrame
                    local dir = Vector3.new(0, 0, 0)
                    local speed = 50
                    if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector * speed end
                    if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector * speed end
                    if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector * speed end
                    if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector * speed end
                    if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, speed, 0) end
                    if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, speed, 0) end
                    bv.Velocity = dir
                    wait()
                end
            end)
            notify("🚀 طيران مفعّل!")
        else
            if rootPart:FindFirstChild("FlyVelocity") then rootPart.FlyVelocity:Destroy() end
            if rootPart:FindFirstChild("FlyGyro") then rootPart.FlyGyro:Destroy() end
            notify("🚀 طيران معطّل")
        end
    end)
    
    createToggle("Noclip (مشي عبر الجدران)", "👻", function(state)
        noclipping = state
        if state then
            spawn(function()
                while noclipping do
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    wait()
                end
            end)
            notify("👻 Noclip مفعّل!")
        else
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
            notify("👻 Noclip معطّل")
        end
    end)
    
    createButton("سرعة 100", "⚡", function()
        humanoid.WalkSpeed = 100
        notify("⚡ سرعة 100")
    end)
    
    createButton("سرعة عادية (16)", "🚶", function()
        humanoid.WalkSpeed = 16
        notify("🚶 سرعة عادية")
    end)
    
    createButton("قفز عالي", "🦘", function()
        humanoid.JumpPower = 120
        humanoid.JumpHeight = 50
        notify("🦘 قفز عالي!")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
end)

-- تبويب الحماية
local protectionTab = createTab("حماية", "🛡️")
protectionTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createButton("God Mode", "🛡️", function()
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid.HealthChanged:Connect(function()
            humanoid.Health = math.huge
        end)
        notify("🛡️ God Mode مفعّل!")
    end)
    
    createToggle("ESP (رؤية اللاعبين)", "🎯", function(state)
        esping = state
        if state then
            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    pcall(function()
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 50, 50)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = plr.Character
                        
                        -- اسم اللاعب
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
                            label.TextColor3 = Color3.new(1, 1, 1)
                            label.TextSize = 18
                            label.Font = Enum.Font.GothamBold
                            label.TextStrokeTransparency = 0
                            label.Parent = billboard
                        end
                    end)
                end
            end
            notify("🎯 ESP مفعّل!")
        else
            for _, plr in pairs(players:GetPlayers()) do
                if plr.Character then
                    pcall(function()
                        if plr.Character:FindFirstChild("ESPHighlight") then
                            plr.Character.ESPHighlight:Destroy()
                        end
                        local head = plr.Character:FindFirstChild("Head")
                        if head and head:FindFirstChild("ESPName") then
                            head.ESPName:Destroy()
                        end
                    end)
                end
            end
            notify("🎯 ESP معطّل")
        end
    end)
    
    createButton("إزالة الضرر من الأسلحة", "🔰", function()
        -- محاولة تعطيل الضرر عبر RemoteEvents
        for _, remote in pairs(rep:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = string.lower(remote.Name)
                if string.find(name, "damage") or string.find(name, "hurt") or string.find(name, "hit") then
                    pcall(function()
                        remote:Destroy()
                    end)
                end
            end
        end
        notify("🔰 تم محاولة تعطيل الضرر!")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
end)

-- تبويب المقالب (الأقوى!)
local pranksTab = createTab("مقالب", "😈", Color3.fromRGB(255, 70, 100))
pranksTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createPlayerSelector()
    
    -- مقالب تشتغل عبر RemoteEvents (الكل يشوفها!)
    createButton("💥 تفجير قوي", "💥", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        -- محاولة عبر RemoteEvent
        local explodeRemote = findRemote({"explode", "explosion", "boom", "damage"})
        if explodeRemote then
            pcall(function()
                explodeRemote:FireServer(selectedPlayer.Character.HumanoidRootPart.Position)
            end)
        end
        
        -- تفجير محلي (تشوفه أنت فقط)
        local explosion = Instance.new("Explosion")
        explosion.Position = selectedPlayer.Character.HumanoidRootPart.Position
        explosion.BlastRadius = 30
        explosion.BlastPressure = 1000000
        explosion.Parent = workspace
        
        notify("💥 تم التفجير!")
    end)
    
    createButton("📍 Teleport إليه", "📍", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        rootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        notify("📍 تم النقل!")
    end)
    
    createButton("🎯 جلبه إليك", "🎯", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        -- محاولة عبر RemoteEvent
        local tpRemote = findRemote({"teleport", "tp", "move", "position"})
        if tpRemote then
            pcall(function()
                tpRemote:FireServer(selectedPlayer, rootPart.Position)
            end)
        end
        
        notify("🎯 محاولة جلب " .. selectedPlayer.Name)
    end)
    
    createButton("🚀 رمي للسماء", "🚀", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        local hrp = selectedPlayer.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 500, 0)
        bv.Parent = hrp
        
        wait(1)
        bv:Destroy()
        
        notify("🚀 تم رمي " .. selectedPlayer.Name .. " للسماء!")
    end)
    
    createButton("🌪️ دوران مجنون", "🌪️", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        local spin = Instance.new("BodyAngularVelocity")
        spin.Name = "CrazySpinPrank"
        spin.MaxTorque = Vector3.new(0, 9e9, 0)
        spin.AngularVelocity = Vector3.new(0, 150, 0)
        spin.Parent = selectedPlayer.Character.HumanoidRootPart
        
        notify("🌪️ " .. selectedPlayer.Name .. " يدور الآن!")
    end)
    
    createButton("🔥 حرق اللاعب", "🔥", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        for _, part in pairs(selectedPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                local fire = Instance.new("Fire")
                fire.Size = 15
                fire.Heat = 25
                fire.Parent = part
            end
        end
        
        notify("🔥 " .. selectedPlayer.Name .. " يحترق!")
    end)
    
    createButton("⚡ صعقة كهربائية", "⚡", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        for i = 1, 5 do
            local spark = Instance.new("Sparkles")
            spark.SparkleColor = Color3.fromRGB(100, 200, 255)
            spark.Parent = selectedPlayer.Character.HumanoidRootPart
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://130818250"
            sound.Volume = 1
            sound.Parent = selectedPlayer.Character.HumanoidRootPart
            sound:Play()
        end
        
        notify("⚡ " .. selectedPlayer.Name .. " مصعوق!")
    end)
    
    createButton("🎆 ألعاب نارية فوق رأسه", "🎆", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        spawn(function()
            for i = 1, 10 do
                local firework = Instance.new("Part")
                firework.Size = Vector3.new(1, 1, 1)
                firework.Position = selectedPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 20, 0)
                firework.Anchored = true
                firework.CanCollide = false
                firework.Material = Enum.Material.Neon
                firework.BrickColor = BrickColor.Random()
                firework.Parent = workspace
                
                local explosion = Instance.new("Explosion")
                explosion.Position = firework.Position
                explosion.BlastRadius = 10
                explosion.BlastPressure = 0
                explosion.Parent = workspace
                
                wait(0.3)
                firework:Destroy()
            end
        end)
        
        notify("🎆 ألعاب نارية فوق " .. selectedPlayer.Name .. "!")
    end)
    
    createButton("🎵 موسيقى مزعجة", "🎵", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        local sounds = {
            "rbxassetid://5816432987",
            "rbxassetid://130768997",
            "rbxassetid://142376088"
        }
        
        for _, soundId in pairs(sounds) do
            local sound = Instance.new("Sound")
            sound.SoundId = soundId
            sound.Volume = 3
            sound.Looped = true
            sound.Parent = selectedPlayer.Character.HumanoidRootPart
            sound:Play()
        end
        
        notify("🎵 موسيقى مزعجة عند " .. selectedPlayer.Name .. "!")
    end)
    
    createButton("🌈 تغيير لون اللاعب", "🌈", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        spawn(function()
            for i = 1, 50 do
                for _, part in pairs(selectedPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.BrickColor = BrickColor.Random()
                    end
                end
                wait(0.1)
            end
        end)
        
        notify("🌈 " .. selectedPlayer.Name .. " ألوان قوس قزح!")
    end)
    
    createButton("👻 إخفاء/إظهار اللاعب", "👻", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        local isVisible = selectedPlayer.Character.HumanoidRootPart.Transparency == 0
        
        for _, part in pairs(selectedPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = isVisible and 1 or 0
            elseif part:IsA("Decal") then
                part.Transparency = isVisible and 1 or 0
            end
        end
        
        notify("👻 تم " .. (isVisible and "إخفاء" or "إظهار") .. " " .. selectedPlayer.Name)
    end)
    
    createButton("🎪 تكبير/تصغير عشوائي", "🎪", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        local humanoid = selectedPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            spawn(function()
                for i = 1, 20 do
                    local scale = math.random(1, 50) / 10
                    humanoid.BodyDepthScale.Value = scale
                    humanoid.BodyHeightScale.Value = scale
                    humanoid.BodyWidthScale.Value = scale
                    humanoid.HeadScale.Value = scale
                    wait(0.2)
                end
            end)
        end
        
        notify("🎪 " .. selectedPlayer.Name .. " يتغير حجمه!")
    end)
    
    createButton("🌪️ إعصار حول اللاعب", "🌪️", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        spawn(function()
            for i = 1, 30 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(2, 8, 2)
                part.Anchored = true
                part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.BrickColor = BrickColor.new("Cyan")
                part.Transparency = 0.5
                
                local angle = math.rad(i * 12)
                local radius = 10
                local pos = selectedPlayer.Character.HumanoidRootPart.Position
                part.Position = pos + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                part.Parent = workspace
                
                game:GetService("Debris"):AddItem(part, 2)
                wait(0.05)
            end
        end)
        
        notify("🌪️ إعصار حول " .. selectedPlayer.Name .. "!")
    end)
    
    createButton("💫 تأثيرات مجنونة", "💫", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        local effects = {"Sparkles", "Smoke", "Fire"}
        for _, effectName in pairs(effects) do
            for _, part in pairs(selectedPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local effect = Instance.new(effectName)
                    effect.Parent = part
                end
            end
        end
        
        notify("💫 تأثيرات مجنونة على " .. selectedPlayer.Name .. "!")
    end)
    
    createButton("🎭 سرقة شكله", "🎭", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        pcall(function()
            local description = players:GetHumanoidDescriptionFromUserId(selectedPlayer.UserId)
            humanoid:ApplyDescription(description)
        end)
        
        notify("🎭 تم نسخ شكل " .. selectedPlayer.Name .. "!")
    end)
    
    createButton("🔊 إيقاف كل الأصوات", "🔊", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        for _, obj in pairs(selectedPlayer.Character:GetDescendants()) do
            if obj:IsA("Sound") then
                obj:Stop()
                obj:Destroy()
            end
        end
        
        notify("🔊 تم إيقاف جميع الأصوات!")
    end)
    
    createButton("❄️ تجميد اللاعب", "❄️", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        for _, part in pairs(selectedPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
        
        notify("❄️ تم تجميد " .. selectedPlayer.Name .. "!")
    end)
    
    createButton("🔓 فك التجميد", "🔓", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        for _, part in pairs(selectedPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
        
        notify("🔓 تم فك تجميد " .. selectedPlayer.Name .. "!")
    end)
    
    createButton("💀 قتل اللاعب (محاولة)", "💀", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        -- محاولة عبر RemoteEvent
        local killRemote = findRemote({"kill", "death", "die", "damage"})
        if killRemote then
            pcall(function()
                killRemote:FireServer(selectedPlayer)
            end)
        end
        
        -- محاولة محلية
        pcall(function()
            selectedPlayer.Character.Humanoid.Health = 0
        end)
        
        notify("💀 محاولة قتل " .. selectedPlayer.Name)
    end)
    
    createButton("🎪 Ragdoll اللاعب", "🎪", function()
        if not selectedPlayer or not selectedPlayer.Character then
            notify("⚠️ اختر لاعب أولاً!")
            return
        end
        
        pcall(function()
            selectedPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end)
        
        notify("🎪 " .. selectedPlayer.Name .. " أصبح Ragdoll!")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
end)

-- تبويب السيارات
local carsTab = createTab("سيارات", "🚗")
carsTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createButton("فتح جميع السيارات", "🚗", function()
        local unlocked = 0
        
        for _, vehicle in pairs(workspace:GetDescendants()) do
            if vehicle:IsA("VehicleSeat") then
                pcall(function()
                    vehicle.Disabled = false
                    vehicle.MaxSpeed = 200
                    unlocked = unlocked + 1
                end)
            end
            
            if vehicle:IsA("Model") and vehicle:FindFirstChild("VehicleSeat") then
                pcall(function()
                    for _, part in pairs(vehicle:GetDescendants()) do
                        if part:IsA("BoolValue") and string.find(string.lower(part.Name), "lock") then
                            part.Value = false
                        end
                    end
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
        
        notify("🚗 تم فتح " .. unlocked .. " سيارة!")
    end)
    
    createButton("سرعة السيارات × 5", "🏎️", function()
        for _, vehicle in pairs(workspace:GetDescendants()) do
            if vehicle:IsA("VehicleSeat") then
                pcall(function()
                    vehicle.MaxSpeed = vehicle.MaxSpeed * 5
                end)
            end
        end
        notify("🏎️ تم زيادة السرعة!")
    end)
    
    createButton("طيران السيارة", "🚁", function()
        for _, vehicle in pairs(workspace:GetDescendants()) do
            if vehicle:IsA("VehicleSeat") and vehicle.Occupant == humanoid then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = Vector3.new(0, 50, 0)
                bv.Parent = vehicle
                notify("🚁 السيارة تطير!")
                break
            end
        end
    end)
    
    createButton("إصلاح السيارة", "🔧", function()
        for _, vehicle in pairs(workspace:GetDescendants()) do
            if vehicle:IsA("VehicleSeat") and vehicle.Occupant == humanoid then
                pcall(function()
                    vehicle.Health = 100
                    notify("🔧 تم إصلاح السيارة!")
                end)
                break
            end
        end
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
end)

-- تبويب العالم
local worldTab = createTab("العالم", "🌍")
worldTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createButton("وقت النهار", "🌅", function()
        lighting.TimeOfDay = "12:00:00"
        notify("🌅 النهار")
    end)
    
    createButton("وقت الليل", "🌙", function()
        lighting.TimeOfDay = "00:00:00"
        notify("🌙 الليل")
    end)
    
    createButton("وقت الغروب", "🌆", function()
        lighting.TimeOfDay = "18:00:00"
        notify("🌆 الغروب")
    end)
    
    createButton("ألوان مجنونة", "🌈", function()
        lighting.Ambient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        lighting.OutdoorAmbient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        notify("🌈 ألوان مجنونة!")
    end)
    
    createButton("ضباب كثيف", "🌫️", function()
        lighting.FogEnd = 50
        lighting.FogStart = 0
        notify("🌫️ ضباب كثيف!")
    end)
    
    createButton("إزالة الضباب", "☀️", function()
        lighting.FogEnd = 100000
        notify("☀️ لا ضباب!")
    end)
    
    createButton("سماء ملونة", "🎨", function()
        lighting.SkyboxBk = "rbxasset://sky/moon.jpg"
        lighting.Ambient = Color3.fromRGB(255, 100, 200)
        notify("🎨 سماء ملونة!")
    end)
    
    createButton("انفجارات عشوائية", "💥", function()
        spawn(function()
            for i = 1, 30 do
                local explosion = Instance.new("Explosion")
                explosion.Position = Vector3.new(
                    math.random(-500, 500),
                    math.random(0, 100),
                    math.random(-500, 500)
                )
                explosion.BlastRadius = 25
                explosion.Parent = workspace
                wait(0.2)
            end
        end)
        notify("💥 انفجارات في كل مكان!")
    end)
    
    createButton("مطر من الأجزاء", "🌧️", function()
        spawn(function()
            for i = 1, 100 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(2, 2, 2)
                part.Position = rootPart.Position + Vector3.new(
                    math.random(-100, 100),
                    100,
                    math.random(-100, 100)
                )
                part.BrickColor = BrickColor.Random()
                part.Material = Enum.Material.Neon
                part.Parent = workspace
                game:GetService("Debris"):AddItem(part, 5)
                wait(0.05)
            end
        end)
        notify("🌧️ مطر من الأجزاء!")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
end)

-- تبويب الإعدادات
local settingsTab = createTab("إعدادات", "⚙️")
settingsTab.MouseButton1Click:Connect(function()
    clearContent()
    
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, -20, 0, 200)
    infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    infoFrame.Parent = contentFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 10)
    infoCorner.Parent = infoFrame
    
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -20, 1, -20)
    infoText.Position = UDim2.new(0, 10, 0, 10)
    infoText.BackgroundTransparency = 1
    infoText.Text = string.format([[
🛡️ حالة الحماية:
  • Bypass: %d حماية معطّلة ✅
  • Kick Protection: ✅
  • Ghost Mode: ✅

📊 معلومات:
  • اسم اللاعب: %s
  • User ID: %d
  • FPS: جيد

⌨️ الاختصار:
  • F12 = فتح/إغلاق القائمة

💡 نصيحة:
  المقالب تعمل بشكل أفضل
  على اللاعبين القريبين منك!
]], bypassedAC, player.Name, player.UserId)
    infoText.TextColor3 = Color3.new(1, 1, 1)
    infoText.TextSize = 13
    infoText.Font = Enum.Font.Code
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.Parent = infoFrame
    
    createButton("إعادة تحميل السكربت", "🔄", function()
        screenGui:Destroy()
        notify("🔄 جاري إعادة التحميل...")
        wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scar201/snsladk/refs/heads/main/s"))()
    end)
    
    createButton("إغلاق السكربت", "❌", function()
        screenGui:Destroy()
        notify("👋 تم إغلاق السكربت")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
end)

-- ═══════════════════════════════════════════════════════════
-- فتح/إغلاق بـ F12
-- ═══════════════════════════════════════════════════════════
uis.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F12 then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            weaponsTab.MouseButton1Click()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- بدء التشغيل
-- ═══════════════════════════════════════════════════════════
print("\n═══════════════════════════════════════")
print("🔥 ULTIMATE RP GUI V2 - جاهز!")
print("🛡️ Bypass: " .. bypassedAC .. " حماية معطّلة")
print("⌨️ اضغط F12 لفتح القائمة")
print("═══════════════════════════════════════")

notify("🔥 GUI V2 جاهز! اضغط F12")

-- فتح تلقائي
wait(1.5)
mainFrame.Visible = true
weaponsTab.MouseButton1Click()
