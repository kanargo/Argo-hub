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

local bHopEnabled, wallSpeedEnabled, spinEnabled = false, false, false
local headlessEnabled, korbloxEnabled, infJumpEnabled = false, false, false
local freeCamEnabled = false
local currentSpeed, spinSpeed = 10, 40
local freeCamSpeed = 0.5 

-- Lag Switch Variables
local lagTime = 100 
local lagMethod = "Default"

-- Independent Rotation Variables
local camRotX, camRotY = 0, 0
local camPos = Vector3.new(0,0,0)

local function Notify(title, msg)
    Rayfield:Notify({Title = title, Content = msg, Duration = 3, Image = nil})
end

-- [[ LAG SWITCH MOMENTUM HANDLER ]]
local function TriggerLag()
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    
    if lagMethod == "Fast Flag" and Root then
        local velocity = Root.AssemblyLinearVelocity
        local angularV = Root.AssemblyAngularVelocity
        
        task.spawn(function()
            Root.AssemblyLinearVelocity = velocity
        end)

        local startTime = os.clock()
        local duration = lagTime / 1000 
        while os.clock() - startTime < duration do end
        
        if Root then
            Root.AssemblyLinearVelocity = velocity
            Root.AssemblyAngularVelocity = angularV
        end
    else
        local startTime = os.clock()
        local duration = lagTime / 1000 
        while os.clock() - startTime < duration do end
    end
end

---
--- 1. MAIN TAB
---
local MainTab = Window:CreateTab("Main", nil)
MainTab:CreateButton({
   Name = "Clear Invisible Walls",
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("BasePart") and v.Transparency > 0.1 and v.CanCollide == true then v.CanCollide = false end
       end
       Notify("Clean", "Obstacles cleared!")
   end,
})
MainTab:CreateButton({Name = "Edge Script", Callback = function() pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/zk2zk5kV"))() end) end})
MainTab:CreateSection("Movement")
MainTab:CreateToggle({Name = "Auto bHop", CurrentValue = false, Callback = function(V) bHopEnabled = V end})
MainTab:CreateSlider({Name = "WalkSpeed", Range = {0, 100}, Increment = 1, CurrentValue = 10, Callback = function(V) currentSpeed = V end})
MainTab:CreateToggle({Name = "Speed Toggle", CurrentValue = false, Callback = function(V) wallSpeedEnabled = V end})

---
--- 2. NETWORK TAB (LAG SWITCH)
---
local NetworkTab = Window:CreateTab("Lagswitch", nil)
NetworkTab:CreateSection("Lag Switch Settings")
NetworkTab:CreateDropdown({
   Name = "Lag Mode",
   Options = {"Default", "Fast Flag but having trouble"},
   CurrentOption = {"Default"},
   MultipleOptions = false,
   Callback = function(Option)
      lagMethod = Option[1]
   end,
})
NetworkTab:CreateSlider({
    Name = "Freeze Duration (ms)",
    Range = {10, 1000},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(V) lagTime = V end
})
NetworkTab:CreateKeybind({
   Name = "Lag Switch Keybind",
   CurrentKeybind = "H",
   HoldToInteract = false,
   Callback = function() TriggerLag() end,
})

---
--- 3. FUN TAB
---
local FunTab = Window:CreateTab("Fun", nil)
FunTab:CreateToggle({Name = "Infinity Jump", CurrentValue = false, Callback = function(V) infJumpEnabled = V end})
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
FunTab:CreateSection("Spin Bot")
FunTab:CreateToggle({Name = "Toggle Spin", CurrentValue = false, Callback = function(V) spinEnabled = V end})
FunTab:CreateSlider({Name = "Spin Speed", Range = {0, 500}, Increment = 10, CurrentValue = 40, Callback = function(V) spinSpeed = V end})

---
--- 4. VISUAL TAB
---
local VisualTab = Window:CreateTab("Visual", nil)
VisualTab:CreateToggle({Name = "Headless", CurrentValue = false, Callback = function(V) headlessEnabled = V end})
VisualTab:CreateToggle({Name = "Korblox", CurrentValue = false, Callback = function(V) korbloxEnabled = V end})

---
--- 5. MAP TAB (ĐÃ SỬA LỖI XÓA)
---
local MapTab = Window:CreateTab("Map", nil)
local mapID = ""
local spawnedMap = nil -- Biến lưu trữ object map

MapTab:CreateInput({
    Name = "Map ID", 
    PlaceholderText = "Enter ID...", 
    Callback = function(T) 
        mapID = T:gsub("%D", "") 
    end
})

MapTab:CreateButton({
    Name = "Create Map", 
    Callback = function() 
        -- Nếu đã có map cũ thì xóa trước khi tạo mới
        if spawnedMap then spawnedMap:Destroy() spawnedMap = nil end
        local backup = workspace:FindFirstChild("Argo_CustomMap")
        if backup then backup:Destroy() end

        pcall(function() 
            local obj = game:GetObjects("rbxassetid://" .. mapID)[1]
            if obj then
                spawnedMap = obj
                spawnedMap.Name = "Argo_CustomMap" -- Đặt tên để dễ tìm lại
                spawnedMap.Parent = workspace
                if spawnedMap:IsA("Model") then
                    spawnedMap:MoveTo(Vector3.new(0, 2500, 0))
                end
                Notify("Map System", "Map created at Y: 2500")
            else
                Notify("Error", "Invalid Map ID")
            end
        end) 
    end
})

MapTab:CreateButton({
    Name = "Teleport to Map", 
    Callback = function() 
        if spawnedMap and LocalPlayer.Character then 
            LocalPlayer.Character:MoveTo(Vector3.new(0, 2515, 0)) 
        else
            Notify("Warning", "Create map first!")
        end 
    end
})

MapTab:CreateButton({
    Name = "Delete Map", 
    Callback = function() 
        -- Xóa theo biến lưu trữ
        if spawnedMap then 
            spawnedMap:Destroy() 
            spawnedMap = nil 
            Notify("Map System", "Map deleted successfully.")
        else
            -- Xóa theo tên trong workspace (dự phòng)
            local backup = workspace:FindFirstChild("Argo_CustomMap")
            if backup then
                backup:Destroy()
                Notify("Map System", "Map found and removed.")
            else
                Notify("Error", "No map to delete!")
            end
        end 
    end
})

---
--- [[ CORE SYSTEM ]]
---
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService:BindToRenderStep("ArgoFreeCam", Enum.RenderPriority.Camera.Value, function(dt)
    if freeCamEnabled then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            local delta = UserInputService:GetMouseDelta()
            camRotY = camRotY - delta.X * 0.4
            camRotX = math.clamp(camRotX - delta.Y * 0.4, -89, 89)
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
        local finalRotation = CFrame.Angles(0, math.rad(camRotY), 0) * CFrame.Angles(math.rad(camRotX), 0, 0)
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + finalRotation.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - finalRotation.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - finalRotation.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + finalRotation.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
        camPos = camPos + (moveDir * (freeCamSpeed * 60 * dt))
        Camera.CFrame = CFrame.new(camPos) * finalRotation
    end
end)

RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char then return end
    if headlessEnabled and Char:FindFirstChild("Head") then
        Char.Head.Transparency = 1
        if Char.Head:FindFirstChildOfClass("Decal") then Char.Head:FindFirstChildOfClass("Decal").Transparency = 1 end
    end
    if korbloxEnabled then
        local parts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
        for _, p in pairs(parts) do if Char:FindFirstChild(p) then Char[p].Transparency = 1 end end
        local main = Char:FindFirstChild("RightUpperLeg") or Char:FindFirstChild("Right Leg")
        if main and not main:FindFirstChild("KorbloxBone") then
            local m = Instance.new("SpecialMesh", main)
            m.Name = "KorbloxBone"
            m.MeshId = "rbxassetid://139607718"
            m.Scale = Vector3.new(1.15, 1.15, 1.15)
        end
    end
    local Root = Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    if Root and Hum and not freeCamEnabled then
        if bHopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) and Hum.FloorMaterial ~= Enum.Material.Air then
            Hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        if wallSpeedEnabled and Hum.MoveDirection.Magnitude > 0 then
            Root.CFrame = Root.CFrame + (Hum.MoveDirection * currentSpeed / 10)
        end 
        if spinEnabled then
            Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end
end)

Notify("Argo Hub", "Script Loaded Successfully!")
