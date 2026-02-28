local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Argo-PORNHUBFURRY",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by @N.Argo on tiktok",
    Theme = "Green", 
    Transparent = true 
})

-- [[ SYSTEM VARIABLES ]]
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local bHopEnabled, wallSpeedEnabled, spinEnabled = false, false, false
local headlessEnabled, infJumpEnabled = false, false -- Đã xóa korbloxEnabled
local freeCamEnabled = false
local currentSpeed, spinSpeed = 10, 40
local freeCamSpeed = 0.5 

-- Lag Switch Variables
local lagTime = 100 

-- FreeCam Variables
local camRotX, camRotY = 0, 0
local camPos = Vector3.new(0,0,0)

local function Notify(title, msg)
    Rayfield:Notify({Title = title, Content = msg, Duration = 3, Image = nil})
end

-- [[ LAG SWITCH MOMENTUM HANDLER ]]
local function TriggerLag()
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    
    local velocity = Root.AssemblyLinearVelocity
    local startTime = os.clock()
    local duration = lagTime / 1000 
    
    while os.clock() - startTime < duration do 
        Root.AssemblyLinearVelocity = Vector3.new(0,0,0)
    end
    
    if Root then Root.AssemblyLinearVelocity = velocity end
end

---
--- 1. MAIN TAB
---
local MainTab = Window:CreateTab("Main", nil)
MainTab:CreateButton({
    Name = "Clear Invisible Walls",
    Callback = function()
        pcall(function() loadstring(game:HttpGet('https://pastebin.com/raw/DP2ZtJPg'))() end)
    end,
})

MainTab:CreateButton({
    Name = "Edge Script", 
    Callback = function() 
        local BOOST_POWER = 100
        local edgeIsEnabled = true
        RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if edgeIsEnabled and hrp and hrp.AssemblyLinearVelocity.Y < -1 then
                if #hrp:GetTouchingParts() > 0 then
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, BOOST_POWER, hrp.AssemblyLinearVelocity.Z)
                end
            end
        end)
        UserInputService.InputBegan:Connect(function(i, g)
            if not g and i.KeyCode == Enum.KeyCode.U then edgeIsEnabled = not edgeIsEnabled Notify("Edge Boost", edgeIsEnabled and "ON" or "OFF") end
        end)
        Notify("Edge Script", "Kích hoạt! (U để bật/tắt)")
    end
})

MainTab:CreateSection("Movement")
MainTab:CreateToggle({Name = "Auto bHop", CurrentValue = false, Callback = function(V) bHopEnabled = V end})
MainTab:CreateSlider({Name = "WalkSpeed", Range = {0, 100}, Increment = 1, CurrentValue = 10, Callback = function(V) currentSpeed = V end})
MainTab:CreateToggle({Name = "Speed Toggle", CurrentValue = false, Callback = function(V) wallSpeedEnabled = V end})

---
--- 2. NETWORK TAB
---
local NetworkTab = Window:CreateTab("Lagswitch", nil)
NetworkTab:CreateSlider({Name = "Freeze Duration (ms)", Range = {10, 1000}, Increment = 10, CurrentValue = 100, Callback = function(V) lagTime = V end})
NetworkTab:CreateKeybind({Name = "Lag Switch Keybind", CurrentKeybind = "H", HoldToInteract = false, Callback = function() TriggerLag() end})

---
--- 3. FUN TAB
---
local FunTab = Window:CreateTab("Fun", nil)
FunTab:CreateToggle({Name = "Infinity Jump", CurrentValue = false, Callback = function(V) infJumpEnabled = V end})

-- Section FreeCam
FunTab:CreateSection("Free Camera")
FunTab:CreateToggle({
    Name = "Toggle Free Cam", 
    CurrentValue = false, 
    Callback = function(V) 
        freeCamEnabled = V 
        if V then
            Camera.CameraType = Enum.CameraType.Scriptable
            camPos = Camera.CFrame.Position
            local rX, rY, rZ = Camera.CFrame:ToEulerAnglesYXZ()
            camRotX, camRotY = math.deg(rX), math.deg(rY)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                LocalPlayer.Character.HumanoidRootPart.Anchored = true 
            end
        else
            Camera.CameraType = Enum.CameraType.Custom
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                LocalPlayer.Character.HumanoidRootPart.Anchored = false 
            end
        end
    end
})
FunTab:CreateSlider({Name = "Cam Speed", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 0.5, Callback = function(V) freeCamSpeed = V end})

-- Section Spin
FunTab:CreateSection("Spin Bot")
FunTab:CreateToggle({Name = "Toggle Spin", CurrentValue = false, Callback = function(V) spinEnabled = V end})
FunTab:CreateSlider({Name = "Spin Speed", Range = {0, 500}, Increment = 10, CurrentValue = 40, Callback = function(V) spinSpeed = V end})

---
--- 4. VISUAL TAB
---
local VisualTab = Window:CreateTab("Visual", nil)
VisualTab:CreateSection("Character")
VisualTab:CreateToggle({Name = "Headless", CurrentValue = false, Callback = function(V) headlessEnabled = V end})

-- [KORBLOX ĐÃ XÓA]

VisualTab:CreateSection("Skybox")
local skyboxID = "123280270736635"
VisualTab:CreateInput({
    Name = "Skybox ID (Số)",
    PlaceholderText = "Ví dụ: 123280270736635",
    Callback = function(T) skyboxID = T:gsub("%D", "") end
})
VisualTab:CreateButton({
    Name = "Apply Skybox",
    Callback = function()
        if not skyboxID or skyboxID == "" then return Notify("Skybox", "Nhập ID số trước!") end
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if not sky then
            sky = Instance.new("Sky")
            sky.Parent = Lighting
        end
        local formattedID = "rbxassetid://" .. skyboxID
        sky.SkyboxBk = formattedID
        sky.SkyboxDn = formattedID
        sky.SkyboxFt = formattedID
        sky.SkyboxLf = formattedID
        sky.SkyboxRt = formattedID
        sky.SkyboxUp = formattedID
        Notify("Skybox", "Đã áp dụng: " .. skyboxID)
    end
})
VisualTab:CreateButton({
    Name = "Remove Skybox",
    Callback = function()
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if sky then
            sky:Destroy()
            Notify("Skybox", "Đã xóa Skybox!")
        else
            Notify("Skybox", "Không có Skybox!")
        end
    end
})

---
--- 5. MAP TAB
---
local MapTab = Window:CreateTab("Map", nil)
local mapID = ""
local spawnedMap = nil
MapTab:CreateInput({Name = "Map ID", PlaceholderText = "ID...", Callback = function(T) mapID = T:gsub("%D", "") end})
MapTab:CreateButton({
    Name = "Create Map", 
    Callback = function() 
        if spawnedMap then spawnedMap:Destroy() end
        pcall(function() 
            spawnedMap = game:GetObjects("rbxassetid://" .. mapID)[1]
            spawnedMap.Name = "Argo_CustomMap"
            spawnedMap.Parent = workspace
            spawnedMap:MoveTo(Vector3.new(0, 2500, 0))
            Notify("Map", "Đã tạo map!")
        end)
    end
})
MapTab:CreateButton({Name = "Teleport", Callback = function() if spawnedMap then LocalPlayer.Character:MoveTo(Vector3.new(0, 2515, 0)) end end})
MapTab:CreateButton({Name = "Delete Map", Callback = function() if spawnedMap then spawnedMap:Destroy() spawnedMap = nil end end})

---
--- [[ CORE SYSTEM ]]
---

RunService.RenderStepped:Connect(function(dt)
    if freeCamEnabled then
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
        camPos = camPos + (moveDir * (freeCamSpeed * 100 * dt))
        Camera.CFrame = CFrame.new(camPos, camPos + Camera.CFrame.LookVector)
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            local delta = UserInputService:GetMouseDelta()
            camRotX = camRotX - delta.Y * 0.1
            camRotY = camRotY - delta.X * 0.1
            camRotX = math.clamp(camRotX, -80, 80)
            Camera.CFrame = CFrame.Angles(0, math.rad(camRotY), 0) * CFrame.Angles(math.rad(camRotX), 0, 0) + camPos
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char then return end
    local Root = Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    
    if Root and Hum and not freeCamEnabled then
        if bHopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) and Hum.FloorMaterial ~= Enum.Material.Air then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        if wallSpeedEnabled and Hum.MoveDirection.Magnitude > 0 then Root.CFrame = Root.CFrame + (Hum.MoveDirection * currentSpeed / 10) end 
        if spinEnabled then Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0) end
    end

    if headlessEnabled and Char:FindFirstChild("Head") then Char.Head.Transparency = 1 end
    
    -- [PHẦN CORE ĐÃ XÓA]
end)

-- [PHẦN JUMPRequest ĐÃ SỬA]
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            -- Chỉnh số 35 xuống thấp hơn nếu muốn bay thấp hơn
            rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 35, rootPart.Velocity.Z)
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Notify("Argo-Hub", "Skybox ID updated!🥳🎉")
