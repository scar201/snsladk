--[[
    ═══════════════════════════════════════════════════════════
    🎮 ULTIMATE RP GUI + PRANKS - واجهة كاملة مع مقالب
    ═══════════════════════════════════════════════════════════
    
    ✅ واجهة GUI احترافية
    ✅ تجاوز الحماية الكامل
    ✅ ميزات الأسلحة والأدوات
    ✅ ميزات المقالب والتحكم
    ✅ بحث ذكي عن اللاعبين
    
    🎯 افتح القائمة: اضغط INSERT
    
    ═══════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════
-- المتغيرات الأساسية
-- ═══════════════════════════════════════════════════════════
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")
local rep = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

local bypassedAC = 0
local selectedPlayer = nil

-- ═══════════════════════════════════════════════════════════
-- BYPASS: تعطيل Anti-Cheat
-- ═══════════════════════════════════════════════════════════
print("🛡️ تعطيل Anti-Cheat...")

local acNames = {
    "AntiCheat", "AC", "AntiExploit", "Security", "Protection",
    "AntiHack", "Detector", "KickScript", "BanScript", "Guard"
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

-- Kick Protection
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" and self == player then
            return
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

print("✅ Bypass مكتمل: " .. bypassedAC .. " حماية معطّلة")

-- ═══════════════════════════════════════════════════════════
-- إنشاء الواجهة
-- ═══════════════════════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateRPGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("CoreGui")

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 450)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- UICorner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- الظل
local shadow = Instance.new("ImageLabel")
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.ZIndex = 0
shadow.Image = "rbxasset://textures/ui/Controls/shadow.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- شريط العنوان
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

-- العنوان
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ULTIMATE RP GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- حالة Bypass
local bypassStatus = Instance.new("TextLabel")
bypassStatus.Size = UDim2.new(0, 200, 1, 0)
bypassStatus.Position = UDim2.new(1, -215, 0, 0)
bypassStatus.BackgroundTransparency = 1
bypassStatus.Text = "🛡️ " .. bypassedAC .. " حماية معطّلة"
bypassStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
bypassStatus.TextSize = 12
bypassStatus.Font = Enum.Font.GothamBold
bypassStatus.TextXAlignment = Enum.TextXAlignment.Right
bypassStatus.Parent = topBar

-- زر إغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- القوائم الجانبية
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 150, 1, -50)
sidebar.Position = UDim2.new(0, 5, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

-- المحتوى الرئيسي
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -165, 1, -55)
contentFrame.Position = UDim2.new(0, 160, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 6
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 80)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentFrame

-- ═══════════════════════════════════════════════════════════
-- دوال مساعدة
-- ═══════════════════════════════════════════════════════════
local function notify(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎮 RP GUI";
        Text = text;
        Duration = 3;
    })
end

local function createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 40)
    tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tabBtn.Text = icon .. " " .. name
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.TextSize = 14
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = sidebar
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = tabBtn
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tabBtn
    
    return tabBtn
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

local function createToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 30)
    toggle.Position = UDim2.new(1, -55, 0.5, -15)
    toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return frame
end

local function createPlayerSelector()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 200)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = "🎯 اختر لاعب:"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -20, 0, 35)
    searchBox.Position = UDim2.new(0, 10, 0, 40)
    searchBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    searchBox.PlaceholderText = "ابحث عن لاعب..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.new(1, 1, 1)
    searchBox.TextSize = 13
    searchBox.Font = Enum.Font.Gotham
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = frame
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 6)
    searchCorner.Parent = searchBox
    
    local playerList = Instance.new("ScrollingFrame")
    playerList.Size = UDim2.new(1, -20, 0, 110)
    playerList.Position = UDim2.new(0, 10, 0, 85)
    playerList.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    playerList.BorderSizePixel = 0
    playerList.ScrollBarThickness = 4
    playerList.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 80)
    playerList.Parent = frame
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = playerList
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
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
                    btn.Size = UDim2.new(1, -5, 0, 30)
                    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                    btn.Text = name
                    btn.TextColor3 = Color3.new(1, 1, 1)
                    btn.TextSize = 12
                    btn.Font = Enum.Font.Gotham
                    btn.TextXAlignment = Enum.TextXAlignment.Left
                    btn.Parent = playerList
                    
                    local padding = Instance.new("UIPadding")
                    padding.PaddingLeft = UDim.new(0, 10)
                    padding.Parent = btn
                    
                    btn.MouseButton1Click:Connect(function()
                        selectedPlayer = plr
                        notify("✅ تم اختيار: " .. name)
                        
                        -- تحديد الزر
                        for _, other in pairs(playerList:GetChildren()) do
                            if other:IsA("TextButton") then
                                other.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                            end
                        end
                        btn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
                    end)
                end
            end
        end
        
        playerList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end
    
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateList(searchBox.Text)
    end)
    
    updateList("")
    
    return frame
end

local function clearContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

-- ═══════════════════════════════════════════════════════════
-- التبويبات
-- ═══════════════════════════════════════════════════════════
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = sidebar

-- تبويب الأسلحة
local weaponsTab = createTab("أسلحة", "🔫")
weaponsTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createButton("🔫 جلب جميع الأسلحة", function()
        notify("🔍 جاري البحث...")
        local found = 0
        for _, item in pairs(rep:GetDescendants()) do
            if item:IsA("Tool") then
                pcall(function()
                    item:Clone().Parent = backpack
                    found = found + 1
                    wait(0.03)
                end)
            end
        end
        notify("✅ تم جلب " .. found .. " سلاح")
    end)
    
    createButton("⚡ تعديل الأسلحة", function()
        local modified = 0
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                for _, child in pairs(tool:GetDescendants()) do
                    if child:IsA("IntValue") or child:IsA("NumberValue") then
                        pcall(function()
                            if string.find(string.lower(child.Name), "ammo") then child.Value = 999999 end
                            if string.find(string.lower(child.Name), "damage") then child.Value = 999 end
                        end)
                    end
                end
                modified = modified + 1
            end
        end
        notify("✅ تم تعديل " .. modified .. " سلاح")
    end)
    
    createButton("🔑 أدوات خاصة (مفاتيح، هواتف)", function()
        local found = 0
        local keywords = {"key", "phone", "card", "badge", "radio"}
        for _, item in pairs(rep:GetDescendants()) do
            if item:IsA("Tool") then
                for _, keyword in pairs(keywords) do
                    if string.find(string.lower(item.Name), keyword) then
                        pcall(function()
                            item:Clone().Parent = backpack
                            found = found + 1
                        end)
                        break
                    end
                end
            end
        end
        notify("✅ تم جلب " .. found .. " أداة")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end)

-- تبويب الحركة
local movementTab = createTab("حركة", "🚀")
movementTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createToggle("🚀 طيران", function(state)
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
                while rootPart:FindFirstChild("FlyVelocity") do
                    local cam = workspace.CurrentCamera
                    bg.CFrame = cam.CFrame
                    local dir = Vector3.new(0, 0, 0)
                    if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector * 50 end
                    if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector * 50 end
                    if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector * 50 end
                    if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector * 50 end
                    if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 50, 0) end
                    if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 50, 0) end
                    bv.Velocity = dir
                    wait()
                end
            end)
            notify("🚀 طيران ON")
        else
            if rootPart:FindFirstChild("FlyVelocity") then rootPart.FlyVelocity:Destroy() end
            if rootPart:FindFirstChild("FlyGyro") then rootPart.FlyGyro:Destroy() end
            notify("🚀 طيران OFF")
        end
    end)
    
    createToggle("👻 Noclip (مشي عبر الجدران)", function(state)
        if state then
            spawn(function()
                while state do
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    wait()
                end
            end)
            notify("👻 Noclip ON")
        else
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            notify("👻 Noclip OFF")
        end
    end)
    
    createButton("⚡ سرعة 100", function()
        humanoid.WalkSpeed = 100
        notify("⚡ سرعة 100")
    end)
    
    createButton("⚡ سرعة عادية", function()
        humanoid.WalkSpeed = 16
        notify("⚡ سرعة عادية")
    end)
    
    createButton("🦘 قفز عالي", function()
        humanoid.JumpPower = 100
        notify("🦘 قفز عالي")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end)

-- تبويب الحماية
local protectionTab = createTab("حماية", "🛡️")
protectionTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createButton("🛡️ God Mode", function()
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid.HealthChanged:Connect(function()
            humanoid.Health = math.huge
        end)
        notify("🛡️ God Mode ON")
    end)
    
    createToggle("🎯 ESP (رؤية اللاعبين)", function(state)
        if state then
            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    pcall(function()
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.Parent = plr.Character
                    end)
                end
            end
            notify("🎯 ESP ON")
        else
            for _, plr in pairs(players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("ESPHighlight") then
                    plr.Character.ESPHighlight:Destroy()
                end
            end
            notify("🎯 ESP OFF")
        end
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end)

-- تبويب المقالب
local pranksTab = createTab("مقالب", "😈")
pranksTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createPlayerSelector()
    
    createButton("💥 تفجير اللاعب", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                local explosion = Instance.new("Explosion")
                explosion.Position = selectedPlayer.Character.HumanoidRootPart.Position
                explosion.BlastRadius = 20
                explosion.BlastPressure = 500000
                explosion.Parent = workspace
                notify("💥 تم تفجير " .. selectedPlayer.Name)
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("🚀 رمي اللاعب للسماء", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                local hrp = selectedPlayer.Character.HumanoidRootPart
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = Vector3.new(0, 500, 0)
                bv.Parent = hrp
                wait(1)
                bv:Destroy()
                notify("🚀 تم رمي " .. selectedPlayer.Name)
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("🌪️ دوران مستمر", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                local hrp = selectedPlayer.Character.HumanoidRootPart
                local spin = Instance.new("BodyAngularVelocity")
                spin.Name = "Spin"
                spin.MaxTorque = Vector3.new(0, 9e9, 0)
                spin.AngularVelocity = Vector3.new(0, 100, 0)
                spin.Parent = hrp
                notify("🌪️ " .. selectedPlayer.Name .. " يدور الآن!")
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("🔥 نار تحت اللاعب", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                local fire = Instance.new("Fire")
                fire.Size = 20
                fire.Heat = 25
                fire.Parent = selectedPlayer.Character.HumanoidRootPart
                notify("🔥 " .. selectedPlayer.Name .. " يحترق!")
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("❄️ تجميد اللاعب", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                local hrp = selectedPlayer.Character.HumanoidRootPart
                hrp.Anchored = true
                notify("❄️ تم تجميد " .. selectedPlayer.Name)
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("🔓 فك التجميد", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                selectedPlayer.Character.HumanoidRootPart.Anchored = false
                notify("🔓 تم فك التجميد")
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("👻 إخفاء اللاعب", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                for _, part in pairs(selectedPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then
                        part.Transparency = 1
                    end
                end
                notify("👻 تم إخفاء " .. selectedPlayer.Name)
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("🎪 تكبير اللاعب", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                local humanoid = selectedPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.BodyDepthScale.Value = 3
                    humanoid.BodyHeightScale.Value = 3
                    humanoid.BodyWidthScale.Value = 3
                    humanoid.HeadScale.Value = 3
                    notify("🎪 تم تكبير " .. selectedPlayer.Name)
                end
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("🐜 تصغير اللاعب", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                local humanoid = selectedPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.BodyDepthScale.Value = 0.3
                    humanoid.BodyHeightScale.Value = 0.3
                    humanoid.BodyWidthScale.Value = 0.3
                    humanoid.HeadScale.Value = 0.3
                    notify("🐜 تم تصغير " .. selectedPlayer.Name)
                end
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("🎭 نسخ شكل اللاعب", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                local appearance = players:GetCharacterAppearanceAsync(selectedPlayer.UserId)
                player.Character = appearance
                notify("🎭 تم نسخ شكل " .. selectedPlayer.Name)
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("📍 Teleport إلى اللاعب", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                rootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
                notify("📍 تم النقل إلى " .. selectedPlayer.Name)
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("🎯 جلب اللاعب إليك", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                selectedPlayer.Character.HumanoidRootPart.CFrame = rootPart.CFrame
                notify("🎯 تم جلب " .. selectedPlayer.Name)
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    createButton("🔊 رسالة صوتية مزعجة", function()
        if selectedPlayer and selectedPlayer.Character then
            pcall(function()
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://5816432987"
                sound.Volume = 10
                sound.Looped = true
                sound.Parent = selectedPlayer.Character.HumanoidRootPart
                sound:Play()
                notify("🔊 صوت مزعج يشتغل عند " .. selectedPlayer.Name)
            end)
        else
            notify("⚠️ اختر لاعب أولاً!")
        end
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end)

-- تبويب السيارات
local carsTab = createTab("سيارات", "🚗")
carsTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createButton("🚗 فتح جميع السيارات", function()
        local unlocked = 0
        for _, vehicle in pairs(workspace:GetDescendants()) do
            if vehicle:IsA("VehicleSeat") then
                pcall(function()
                    vehicle.Disabled = false
                    vehicle.MaxSpeed = 200
                    unlocked = unlocked + 1
                end)
            end
        end
        notify("🚗 تم فتح " .. unlocked .. " سيارة")
    end)
    
    createButton("🏎️ سرعة السيارات × 3", function()
        for _, vehicle in pairs(workspace:GetDescendants()) do
            if vehicle:IsA("VehicleSeat") then
                pcall(function()
                    vehicle.MaxSpeed = vehicle.MaxSpeed * 3
                end)
            end
        end
        notify("🏎️ تم زيادة سرعة السيارات")
    end)
    
    createButton("🚁 طيران السيارة", function()
        for _, vehicle in pairs(workspace:GetDescendants()) do
            if vehicle:IsA("VehicleSeat") and vehicle.Occupant then
                pcall(function()
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Velocity = Vector3.new(0, 50, 0)
                    bv.Parent = vehicle
                end)
            end
        end
        notify("🚁 السيارة تطير!")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end)

-- تبويب العالم
local worldTab = createTab("العالم", "🌍")
worldTab.MouseButton1Click:Connect(function()
    clearContent()
    
    createButton("🌅 وقت النهار", function()
        game:GetService("Lighting").TimeOfDay = "12:00:00"
        notify("🌅 النهار")
    end)
    
    createButton("🌙 وقت الليل", function()
        game:GetService("Lighting").TimeOfDay = "00:00:00"
        notify("🌙 الليل")
    end)
    
    createButton("🌈 ألوان مجنونة", function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        lighting.OutdoorAmbient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        notify("🌈 ألوان مجنونة!")
    end)
    
    createButton("🌫️ ضباب كثيف", function()
        game:GetService("Lighting").FogEnd = 50
        notify("🌫️ ضباب كثيف")
    end)
    
    createButton("☀️ إزالة الضباب", function()
        game:GetService("Lighting").FogEnd = 100000
        notify("☀️ لا ضباب")
    end)
    
    createButton("💥 انفجارات عشوائية", function()
        spawn(function()
            for i = 1, 20 do
                local explosion = Instance.new("Explosion")
                explosion.Position = Vector3.new(
                    math.random(-500, 500),
                    math.random(0, 100),
                    math.random(-500, 500)
                )
                explosion.BlastRadius = 30
                explosion.Parent = workspace
                wait(0.3)
            end
        end)
        notify("💥 انفجارات في كل مكان!")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end)

-- تبويب الإعدادات
local settingsTab = createTab("إعدادات", "⚙️")
settingsTab.MouseButton1Click:Connect(function()
    clearContent()
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 150)
    infoLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    infoLabel.Text = [[
🛡️ حالة الحماية:
• Bypass نشط: ]] .. bypassedAC .. [[ حماية معطّلة
• Kick Protection: ✅ مفعّل
• Ghost Mode: ✅ مفعّل

📝 معلومات:
• اسم اللاعب: ]] .. player.Name .. [[

• UserId: ]] .. player.UserId .. [[


💡 نصيحة:
استخدم المقالب بحذر!
    ]]
    infoLabel.TextColor3 = Color3.new(1, 1, 1)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Code
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = infoLabel
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.Parent = infoLabel
    
    createButton("🔄 إعادة تحميل السكربت", function()
        screenGui:Destroy()
        notify("🔄 جاري إعادة التحميل...")
        wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scar201/snsladk/refs/heads/main/s"))()
    end)
    
    createButton("❌ إغلاق السكربت", function()
        screenGui:Destroy()
        notify("👋 تم إغلاق السكربت")
    end)
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end)

-- ═══════════════════════════════════════════════════════════
-- فتح/إغلاق القائمة بـ INSERT
-- ═══════════════════════════════════════════════════════════
uis.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
        
        if mainFrame.Visible then
            -- فتح التبويب الأول تلقائياً
            weaponsTab.MouseButton1Click()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- تشغيل أولي
-- ═══════════════════════════════════════════════════════════
print("\n═══════════════════════════════════════")
print("✅ ULTIMATE RP GUI جاهز!")
print("🛡️ Bypass: " .. bypassedAC .. " حماية معطّلة")
print("⌨️ اضغط INSERT لفتح القائمة")
print("═══════════════════════════════════════")

notify("✅ GUI جاهز! اضغط INSERT")

-- فتح القائمة تلقائياً
wait(1)
mainFrame.Visible = true
weaponsTab.MouseButton1Click()
