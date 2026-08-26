local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer


local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/lds13/Library.lua"))()

local Window = Library:Window({
    Name = "killez.lol",
    SubTitle = "Ultimate Configuration",
    TimeRemaining = "0 years"
})

local Pages = { }

local PageIcons = {
    "129960652808688", -- Combat / Aimbot
    "109391165290124", -- Visuals / ESP
    "112887626955824", -- Movement / Fly
    "72974659157165"   -- World & Settings
}

for Index = 1, 4 do 
    Pages[Index] = Window:Page({
        Icon = PageIcons[Index] or "131145598162617",
        Columns = 2
    })
end

-- ==========================================
-- SERVICES & CORE CONFIGURATIONS
-- ==========================================
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Camera = Workspace.CurrentCamera

-- Global Feature Configurations
local AimbotConfig = {
    Enabled = false,
    Method = "Camera",
    FOV = 100,
    Smoothness = 5,
    Hitbox = "Head",
    TeamCheck = false,
    FOVColor = Color3.fromRGB(255, 255, 255),
    HardLock = false
}

local TriggerbotConfig = {
    Enabled = false,
    Delay = 0.05
}

local HitboxConfig = {
    Enabled = false,
    PartName = "Head",
    Size = 3,
    Transparency = 0.5
}

local ESPConfig = {
    Enabled = false,
    BoxType = "2D Box",
    Name = false,
    Distance = false,
    Health = false,
    Tracers = false,
    Skeletons = false,
    Chams = false,
    HeadDot = false,
    Preview = false,
    BoxColor = Color3.fromRGB(0, 255, 128),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    TracerColor = Color3.fromRGB(255, 255, 255),
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    ChamsColor = Color3.fromRGB(255, 0, 0),
    ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
    HeadDotColor = Color3.fromRGB(255, 255, 255),
    -- Drag offsets for elements
    BoxOffset = Vector2.new(0, 0),
    HealthBarOffset = Vector2.new(-6, 0),
    NameOffset = Vector2.new(0, -16)
}

local VisualsConfig = {
    PinkSkyEnabled = false
}

local MovementConfig = {
    SpeedEnabled = false,
    WalkSpeed = 16,
    CFrameSpeedEnabled = false,
    CFrameSpeedValue = 25,
    JumpEnabled = false,
    JumpPower = 50,
    FlyEnabled = false,
    FlySpeed = 50,
    BhopEnabled = false,
    GravityEnabled = false,
    GravityValue = 196.2,
    FOVEnabled = false,
    FOVValue = 70,
    NoclipEnabled = false,
    PhysicsBoost = false,
    SpinbotEnabled = false,
    SpinSpeed = 50
}

local CombatConfig = {
    CrosshairEnabled = false,
    CrosshairColor = Color3.fromRGB(255, 255, 255),
    HitmarkerEnabled = false,
    HitmarkerSoundID = "rbxassetid://4590657391"
}

local WorldConfig = {
    TimeEnabled = false,
    TimeValue = 12,
    BrightnessEnabled = false,
    BrightnessValue = 2,
    FogEnabled = false,
    FogEndValue = 100000,
    AmbientEnabled = false,
    AmbientColor = Color3.fromRGB(128, 128, 128),
    WorldColorCustomizerEnabled = false,
    GlobalWorldColor = Color3.fromRGB(255, 255, 255),
    OutdoorAmbientColor = Color3.fromRGB(128, 128, 128)
}

-- ==========================================
-- DRAWING API ESP SYSTEM
-- ==========================================
local ActiveDrawings = {}

local function CreateDrawing(player)
    if ActiveDrawings[player] then return end
    
    local drawings = {
        BoxOutline = Drawing.new("Square"),
        Box = Drawing.new("Square"),
        CornerLines = {
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line")
        },
        Box3D = {
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line")
        },
        NameText = Drawing.new("Text"),
        DistanceText = Drawing.new("Text"),
        HealthBarOutline = Drawing.new("Line"),
        HealthBar = Drawing.new("Line"),
        Tracer = Drawing.new("Line"),
        HeadDot = Drawing.new("Circle"),
        Skeletons = {
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
            Drawing.new("Line"), Drawing.new("Line")
        }
    }
    
    drawings.BoxOutline.Thickness = 3
    drawings.BoxOutline.Filled = false
    drawings.BoxOutline.Visible = false
    drawings.BoxOutline.Color = Color3.new(0, 0, 0)

    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    drawings.Box.Visible = false

    for _, line in ipairs(drawings.CornerLines) do line.Thickness = 1; line.Visible = false end
    for _, line in ipairs(drawings.Box3D) do line.Thickness = 1; line.Visible = false end

    drawings.NameText.Size = 13
    drawings.NameText.Center = true
    drawings.NameText.Outline = true
    drawings.NameText.Visible = false

    drawings.DistanceText.Size = 13
    drawings.DistanceText.Center = true
    drawings.DistanceText.Outline = true
    drawings.DistanceText.Visible = false

    drawings.HealthBarOutline.Thickness = 3
    drawings.HealthBarOutline.Visible = false
    drawings.HealthBarOutline.Color = Color3.new(0, 0, 0)

    drawings.HealthBar.Thickness = 1
    drawings.HealthBar.Visible = false

    drawings.Tracer.Thickness = 1
    drawings.Tracer.Visible = false

    drawings.HeadDot.Radius = 4
    drawings.HeadDot.Filled = true
    drawings.HeadDot.Visible = false

    for _, limb in ipairs(drawings.Skeletons) do limb.Thickness = 1; limb.Visible = false end

    ActiveDrawings[player] = drawings
end

local function RemoveDrawing(player)
    if ActiveDrawings[player] then
        for _, obj in pairs(ActiveDrawings[player]) do
            if type(obj) == "table" then
                for _, subObj in pairs(obj) do pcall(function() subObj:Remove() end) end
            else
                pcall(function() obj:Remove() end)
            end
        end
        ActiveDrawings[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateDrawing(p) end
end
Players.PlayerAdded:Connect(CreateDrawing)
Players.PlayerRemoving:Connect(RemoveDrawing)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Visible = false

local CustomCrosshairH = Drawing.new("Line")
local CustomCrosshairV = Drawing.new("Line")
CustomCrosshairH.Thickness = 2
CustomCrosshairH.Visible = false
CustomCrosshairV.Thickness = 2
CustomCrosshairV.Visible = false

-- Isolated Draggable ESP Preview Elements
local PreviewPos = Vector2.new(150, 150)
local IsDraggingPreview = false
local IsDraggingBox = false
local IsDraggingHealth = false
local IsDraggingName = false

local BoxOffsetPreview = Vector2.new(0, 0)
local HealthOffsetPreview = Vector2.new(-6, 0)
local NameOffsetPreview = Vector2.new(0, -16)

local DragOffset = Vector2.new(0, 0)
local ActiveDragTarget = nil

local PreviewDrawings = {
    WindowBG = Drawing.new("Square"),
    WindowOutline = Drawing.new("Square"),
    HeaderBar = Drawing.new("Square"),
    HeaderText = Drawing.new("Text"),
    SubText = Drawing.new("Text"),
    Box = Drawing.new("Square"),
    BoxOutline = Drawing.new("Square"),
    CornerLines = {
        Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
        Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line")
    },
    Box3D = {
        Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
        Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
        Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line")
    },
    NameText = Drawing.new("Text"),
    DistanceText = Drawing.new("Text"),
    HealthBar = Drawing.new("Line"),
    HealthBarOutline = Drawing.new("Line"),
    HeadDot = Drawing.new("Circle"),
    Tracer = Drawing.new("Line"),
    Skeletons = {
        Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
        Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
        Drawing.new("Line"), Drawing.new("Line")
    }
}

PreviewDrawings.WindowBG.Filled = true
PreviewDrawings.WindowBG.Color = Color3.fromRGB(20, 20, 25)
PreviewDrawings.WindowBG.Visible = false

PreviewDrawings.WindowOutline.Filled = false
PreviewDrawings.WindowOutline.Thickness = 1
PreviewDrawings.WindowOutline.Color = Color3.fromRGB(45, 45, 55)
PreviewDrawings.WindowOutline.Visible = false

PreviewDrawings.HeaderBar.Filled = true
PreviewDrawings.HeaderBar.Color = Color3.fromRGB(30, 30, 38)
PreviewDrawings.HeaderBar.Visible = false

PreviewDrawings.HeaderText.Size = 13
PreviewDrawings.HeaderText.Center = false
PreviewDrawings.HeaderText.Outline = true
PreviewDrawings.HeaderText.Color = Color3.fromRGB(255, 255, 255)
PreviewDrawings.HeaderText.Text = "ESP Preview (Drag elements!)"
PreviewDrawings.HeaderText.Visible = false

PreviewDrawings.SubText.Size = 11
PreviewDrawings.SubText.Center = false
PreviewDrawings.SubText.Outline = true
PreviewDrawings.SubText.Color = Color3.fromRGB(150, 150, 160)
PreviewDrawings.SubText.Text = "[Window]"
PreviewDrawings.SubText.Visible = false

PreviewDrawings.Box.Visible = false
PreviewDrawings.Box.Filled = false
PreviewDrawings.Box.Thickness = 1
PreviewDrawings.BoxOutline.Visible = false
PreviewDrawings.BoxOutline.Filled = false
PreviewDrawings.BoxOutline.Thickness = 3
PreviewDrawings.BoxOutline.Color = Color3.new(0,0,0)

for _, line in ipairs(PreviewDrawings.CornerLines) do line.Thickness = 1; line.Visible = false end
for _, line in ipairs(PreviewDrawings.Box3D) do line.Thickness = 1; line.Visible = false end
for _, limb in ipairs(PreviewDrawings.Skeletons) do limb.Thickness = 1; limb.Visible = false end

PreviewDrawings.NameText.Size = 13
PreviewDrawings.NameText.Center = true
PreviewDrawings.NameText.Outline = true
PreviewDrawings.NameText.Visible = false

PreviewDrawings.DistanceText.Size = 13
PreviewDrawings.DistanceText.Center = true
PreviewDrawings.DistanceText.Outline = true
PreviewDrawings.DistanceText.Visible = false

PreviewDrawings.HealthBar.Thickness = 1
PreviewDrawings.HealthBar.Visible = false
PreviewDrawings.HealthBarOutline.Thickness = 3
PreviewDrawings.HealthBarOutline.Visible = false
PreviewDrawings.HealthBarOutline.Color = Color3.new(0,0,0)

PreviewDrawings.HeadDot.Radius = 4
PreviewDrawings.HeadDot.Filled = true
PreviewDrawings.HeadDot.Visible = false

PreviewDrawings.Tracer.Thickness = 1
PreviewDrawings.Tracer.Visible = false

-- ==========================================
-- CORE LOGIC LOOP
-- ==========================================
local function GetClosestPlayer()
    local target = nil
    local shortestDist = AimbotConfig.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local hitbox = character:FindFirstChild(AimbotConfig.Hitbox) or character:FindFirstChild("Head")

            local passesTeamCheck = not AimbotConfig.TeamCheck or (player.Team ~= LocalPlayer.Team)

            if humanoid and humanoid.Health > 0 and hitbox and passesTeamCheck then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hitbox.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        target = hitbox
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function(dt)
    local mouseLoc = UserInputService:GetMouseLocation()
    FOVCircle.Position = mouseLoc
    FOVCircle.Radius = AimbotConfig.FOV
    FOVCircle.Color = AimbotConfig.FOVColor
    FOVCircle.Visible = AimbotConfig.Enabled

    if CombatConfig.CrosshairEnabled then
        local center = Camera.ViewportSize / 2
        CustomCrosshairH.Visible = true
        CustomCrosshairH.From = Vector2.new(center.X - 6, center.Y)
        CustomCrosshairH.To = Vector2.new(center.X + 6, center.Y)
        CustomCrosshairH.Color = CombatConfig.CrosshairColor

        CustomCrosshairV.Visible = true
        CustomCrosshairV.From = Vector2.new(center.X, center.Y - 6)
        CustomCrosshairV.To = Vector2.new(center.X, center.Y + 6)
        CustomCrosshairV.Color = CombatConfig.CrosshairColor
    else
        CustomCrosshairH.Visible = false
        CustomCrosshairV.Visible = false
    end

    if AimbotConfig.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local targetHitbox = GetClosestPlayer()
        if targetHitbox then
            if AimbotConfig.HardLock then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHitbox.Position)
            else
                if AimbotConfig.Method == "Camera" then
                    local smoothnessVal = math.max(1, AimbotConfig.Smoothness)
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHitbox.Position), 1 / smoothnessVal)
                elseif AimbotConfig.Method == "Mouse" then
                    local targetPos = Camera:WorldToViewportPoint(targetHitbox.Position)
                    local mousePos = UserInputService:GetMouseLocation()
                    local smoothnessVal = math.max(1, AimbotConfig.Smoothness)
                    mousemoverel((targetPos.X - mousePos.X) / smoothnessVal, (targetPos.Y - mousePos.Y) / smoothnessVal)
                end
            end
        end
    end

    if TriggerbotConfig.Enabled then
        local mouseTarget = LocalPlayer:GetMouse().Target
        if mouseTarget and mouseTarget.Parent then
            local enemyChar = mouseTarget.Parent
            local enemyHumanoid = enemyChar:FindFirstChildOfClass("Humanoid")
            local enemyPlayer = Players:GetPlayerFromCharacter(enemyChar)
            local passesTeamCheck = not AimbotConfig.TeamCheck or (enemyPlayer and enemyPlayer.Team ~= LocalPlayer.Team)
            
            if enemyHumanoid and enemyHumanoid.Health > 0 and passesTeamCheck then
                task.wait(TriggerbotConfig.Delay)
                mouse1click()
            end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local passesTeamCheck = not AimbotConfig.TeamCheck or (player.Team ~= LocalPlayer.Team)
            if character and passesTeamCheck then
                local targetPart = character:FindFirstChild(HitboxConfig.PartName)
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if targetPart and humanoid and humanoid.Health > 0 then
                    if HitboxConfig.Enabled then
                        targetPart.Size = Vector3.new(HitboxConfig.Size, HitboxConfig.Size, HitboxConfig.Size)
                        targetPart.Transparency = HitboxConfig.Transparency
                        targetPart.CanCollide = false
                    else
                        if HitboxConfig.PartName == "Head" then
                            targetPart.Size = Vector3.new(2, 1, 1)
                        elseif HitboxConfig.PartName == "HumanoidRootPart" or HitboxConfig.PartName == "Torso" then
                            targetPart.Size = Vector3.new(2, 2, 1)
                        else
                            targetPart.Size = Vector3.new(1, 2, 1)
                        end
                        targetPart.Transparency = (HitboxConfig.PartName == "HumanoidRootPart" and 1 or 0)
                    end
                end
            end
        end
    end

    local localChar = LocalPlayer.Character
    local localHumanoid = localChar and localChar:FindFirstChildOfClass("Humanoid")
    local rootPart = localChar and localChar:FindFirstChild("HumanoidRootPart")

    if localHumanoid then
        if MovementConfig.SpeedEnabled then
            localHumanoid.WalkSpeed = MovementConfig.WalkSpeed
        end
        if MovementConfig.JumpEnabled then
            localHumanoid.JumpPower = MovementConfig.JumpPower
        end
        if MovementConfig.BhopEnabled and localHumanoid.FloorMaterial ~= Enum.Material.Air then
            localHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    if MovementConfig.CFrameSpeedEnabled and rootPart then
        local moveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Camera.CFrame.RightVector end
        moveDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit
        if moveDirection.Magnitude > 0 then
            rootPart.CFrame = rootPart.CFrame + (moveDirection * (MovementConfig.CFrameSpeedValue * dt))
        end
    end

    if MovementConfig.GravityEnabled then
        Workspace.Gravity = MovementConfig.GravityValue
    end

    if MovementConfig.FOVEnabled then
        Camera.FieldOfView = MovementConfig.FOVValue
    end

    if MovementConfig.FlyEnabled and rootPart then
        local moveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Camera.CFrame.RightVector end
        
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.CFrame = rootPart.CFrame + (moveDirection * MovementConfig.FlySpeed * dt)
    end

    if MovementConfig.NoclipEnabled and localChar then
        for _, part in ipairs(localChar:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if MovementConfig.SpinbotEnabled and rootPart then
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(MovementConfig.SpinSpeed), 0)
    end

    if VisualsConfig.PinkSkyEnabled then
        Lighting.Ambient = Color3.fromRGB(255, 180, 220)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 150, 200)
        for _, sky in ipairs(Lighting:GetChildren()) do
            if sky:IsA("Sky") then
                sky.CelestialBodiesShown = false
                sky.SkyboxBk = "rbxassetid://271042516"
                sky.SkyboxDn = "rbxassetid://271042556"
                sky.SkyboxFt = "rbxassetid://271042596"
                sky.SkyboxLf = "rbxassetid://271042630"
                sky.SkyboxRt = "rbxassetid://271042674"
                sky.SkyboxUp = "rbxassetid://271042716"
            end
        end
    end

    if WorldConfig.WorldColorCustomizerEnabled then
        Lighting.Ambient = WorldConfig.GlobalWorldColor
        Lighting.OutdoorAmbient = WorldConfig.OutdoorAmbientColor
    end

    if WorldConfig.TimeEnabled then
        Lighting.ClockTime = WorldConfig.TimeValue
    end
    if WorldConfig.BrightnessEnabled then
        Lighting.Brightness = WorldConfig.BrightnessValue
    end
    if WorldConfig.FogEnabled then
        Lighting.FogEnd = WorldConfig.FogEndValue
    end
    if WorldConfig.AmbientEnabled and not WorldConfig.WorldColorCustomizerEnabled then
        Lighting.Ambient = WorldConfig.AmbientColor
    end

    -- Dragging Handler updates for preview
    local currentMouse = UserInputService:GetMouseLocation()
    if IsDraggingPreview then
        PreviewPos = currentMouse - DragOffset
    elseif IsDraggingBox then
        BoxOffsetPreview = currentMouse - DragOffset
        ESPConfig.BoxOffset = BoxOffsetPreview
    elseif IsDraggingHealth then
        HealthOffsetPreview = currentMouse - DragOffset
        ESPConfig.HealthBarOffset = HealthOffsetPreview
    elseif IsDraggingName then
        NameOffsetPreview = currentMouse - DragOffset
        ESPConfig.NameOffset = NameOffsetPreview
    end

    -- Isolated ESP Preview Handler
    if ESPConfig.Preview then
        local wSize = Vector2.new(180, 240)

        PreviewDrawings.WindowBG.Visible = true
        PreviewDrawings.WindowBG.Size = wSize
        PreviewDrawings.WindowBG.Position = PreviewPos

        PreviewDrawings.WindowOutline.Visible = true
        PreviewDrawings.WindowOutline.Size = wSize
        PreviewDrawings.WindowOutline.Position = PreviewPos

        PreviewDrawings.HeaderBar.Visible = true
        PreviewDrawings.HeaderBar.Size = Vector2.new(wSize.X, 26)
        PreviewDrawings.HeaderBar.Position = PreviewPos

        PreviewDrawings.HeaderText.Visible = true
        PreviewDrawings.HeaderText.Position = PreviewPos + Vector2.new(8, 6)

        PreviewDrawings.SubText.Visible = true
        PreviewDrawings.SubText.Position = PreviewPos + Vector2.new(wSize.X - 60, 8)

        local charCenterPos = PreviewPos + Vector2.new(wSize.X / 2, 135)
        local cBoxSize = Vector2.new(70, 140)
        local cBoxPos = charCenterPos - (cBoxSize / 2) + ESPConfig.BoxOffset

        -- Reset preview box elements
        PreviewDrawings.Box.Visible = false
        PreviewDrawings.BoxOutline.Visible = false
        for _, line in ipairs(PreviewDrawings.CornerLines) do line.Visible = false end
        for _, line in ipairs(PreviewDrawings.Box3D) do line.Visible = false end

        if ESPConfig.BoxType ~= "Off" then
            if ESPConfig.BoxType == "2D Box" then
                PreviewDrawings.Box.Visible = true
                PreviewDrawings.BoxOutline.Visible = true
                PreviewDrawings.Box.Size = cBoxSize
                PreviewDrawings.Box.Position = cBoxPos
                PreviewDrawings.Box.Color = ESPConfig.BoxColor
                PreviewDrawings.BoxOutline.Size = cBoxSize
                PreviewDrawings.BoxOutline.Position = cBoxPos
            elseif ESPConfig.BoxType == "Corner ESP" then
                local lengthX = cBoxSize.X / 4
                local lengthY = cBoxSize.Y / 4
                local lines = PreviewDrawings.CornerLines
                
                lines[1].Visible = true; lines[1].From = cBoxPos; lines[1].To = cBoxPos + Vector2.new(lengthX, 0); lines[1].Color = ESPConfig.BoxColor
                lines[2].Visible = true; lines[2].From = cBoxPos; lines[2].To = cBoxPos + Vector2.new(0, lengthY); lines[2].Color = ESPConfig.BoxColor
                
                local tr = cBoxPos + Vector2.new(cBoxSize.X, 0)
                lines[3].Visible = true; lines[3].From = tr; lines[3].To = tr - Vector2.new(lengthX, 0); lines[3].Color = ESPConfig.BoxColor
                lines[4].Visible = true; lines[4].From = tr; lines[4].To = tr + Vector2.new(0, lengthY); lines[4].Color = ESPConfig.BoxColor
                
                local bl = cBoxPos + Vector2.new(0, cBoxSize.Y)
                lines[5].Visible = true; lines[5].From = bl; lines[5].To = bl + Vector2.new(lengthX, 0); lines[5].Color = ESPConfig.BoxColor
                lines[6].Visible = true; lines[6].From = bl; lines[6].To = bl - Vector2.new(0, lengthY); lines[6].Color = ESPConfig.BoxColor
                
                local br = cBoxPos + Vector2.new(cBoxSize.X, cBoxSize.Y)
                lines[7].Visible = true; lines[7].From = br; lines[7].To = br - Vector2.new(lengthX, 0); lines[7].Color = ESPConfig.BoxColor
                lines[8].Visible = true; lines[8].From = br; lines[8].To = br - Vector2.new(0, lengthY); lines[8].Color = ESPConfig.BoxColor
            elseif ESPConfig.BoxType == "3D ESP" then
                local depthOffset = 15
                local c3D_Top = {
                    cBoxPos + Vector2.new(0, 0) + Vector2.new(-depthOffset, -depthOffset/2),
                    cBoxPos + Vector2.new(cBoxSize.X, 0) + Vector2.new(depthOffset, -depthOffset/2),
                    cBoxPos + Vector2.new(cBoxSize.X, cBoxSize.Y/2) + Vector2.new(depthOffset, -depthOffset/2),
                    cBoxPos + Vector2.new(0, cBoxSize.Y/2) + Vector2.new(-depthOffset, -depthOffset/2)
                }
                local c3D_Bot = {
                    cBoxPos + Vector2.new(0, cBoxSize.Y) + Vector2.new(-depthOffset, depthOffset/2),
                    cBoxPos + Vector2.new(cBoxSize.X, cBoxSize.Y) + Vector2.new(depthOffset, depthOffset/2),
                    cBoxPos + Vector2.new(cBoxSize.X, cBoxSize.Y/2) + Vector2.new(depthOffset, depthOffset/2),
                    cBoxPos + Vector2.new(0, cBoxSize.Y/2) + Vector2.new(-depthOffset, depthOffset/2)
                }
                local pairs3D = {
                    {1,2}, {2,3}, {3,4}, {4,1},
                    {5,6}, {6,7}, {7,8}, {8,5},
                    {1,5}, {2,6}, {3,7}, {4,8}
                }
                for i, p in ipairs(pairs3D) do
                    local line = PreviewDrawings.Box3D[i]
                    line.Visible = true
                    local fromT = p[1] <= 4 and c3D_Top[p[1]] or c3D_Bot[p[1]-4]
                    local toT = p[2] <= 4 and c3D_Top[p[2]] or c3D_Bot[p[2]-4]
                    line.From = fromT
                    line.To = toT
                    line.Color = ESPConfig.BoxColor
                end
            end
        end

        PreviewDrawings.NameText.Visible = ESPConfig.Name
        if ESPConfig.Name then
            local namePos = (charCenterPos + ESPConfig.NameOffset)
            PreviewDrawings.NameText.Text = "Preview User"
            PreviewDrawings.NameText.Color = ESPConfig.NameColor
            PreviewDrawings.NameText.Position = namePos
        end

        PreviewDrawings.DistanceText.Visible = ESPConfig.Distance
        if ESPConfig.Distance then
            PreviewDrawings.DistanceText.Text = "[10m]"
            PreviewDrawings.DistanceText.Color = ESPConfig.DistanceColor
            PreviewDrawings.DistanceText.Position = cBoxPos + Vector2.new(cBoxSize.X / 2, cBoxSize.Y + 2)
        end

        PreviewDrawings.HealthBar.Visible = ESPConfig.Health
        PreviewDrawings.HealthBarOutline.Visible = ESPConfig.Health
        if ESPConfig.Health then
            local healthBasePos = cBoxPos + ESPConfig.HealthBarOffset
            PreviewDrawings.HealthBarOutline.From = healthBasePos + Vector2.new(0, cBoxSize.Y)
            PreviewDrawings.HealthBarOutline.To = healthBasePos + Vector2.new(0, 0)
            PreviewDrawings.HealthBar.From = healthBasePos + Vector2.new(0, cBoxSize.Y)
            PreviewDrawings.HealthBar.To = healthBasePos + Vector2.new(0, 0)
            PreviewDrawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
        end

        PreviewDrawings.HeadDot.Visible = ESPConfig.HeadDot
        if ESPConfig.HeadDot then
            PreviewDrawings.HeadDot.Position = cBoxPos + Vector2.new(cBoxSize.X / 2, 18)
            PreviewDrawings.HeadDot.Color = ESPConfig.HeadDotColor
        end

        if ESPConfig.Tracers then
            PreviewDrawings.Tracer.Visible = true
            PreviewDrawings.Tracer.From = Vector2.new(PreviewPos.X + (wSize.X / 2), PreviewPos.Y + wSize.Y)
            PreviewDrawings.Tracer.To = cBoxPos + Vector2.new(cBoxSize.X / 2, cBoxSize.Y)
            PreviewDrawings.Tracer.Color = ESPConfig.TracerColor
        else
            PreviewDrawings.Tracer.Visible = false
        end

        if ESPConfig.Skeletons then
            local headP = cBoxPos + Vector2.new(cBoxSize.X / 2, 18)
            local neckP = cBoxPos + Vector2.new(cBoxSize.X / 2, 34)
            local torsoP = cBoxPos + Vector2.new(cBoxSize.X / 2, 65)
            local pelvisP = cBoxPos + Vector2.new(cBoxSize.X / 2, 85)
            local lHandP = cBoxPos + Vector2.new(-12, 75)
            local rHandP = cBoxPos + Vector2.new(cBoxSize.X + 12, 75)
            local lFootP = cBoxPos + Vector2.new(12, cBoxSize.Y)
            local rFootP = cBoxPos + Vector2.new(cBoxSize.X - 12, cBoxSize.Y)

            local skelLines = PreviewDrawings.Skeletons
            for _, limb in ipairs(skelLines) do limb.Color = ESPConfig.SkeletonColor; limb.Visible = true end

            skelLines[1].From = headP; skelLines[1].To = neckP
            skelLines[2].From = neckP; skelLines[2].To = torsoP
            skelLines[3].From = torsoP; skelLines[3].To = pelvisP
            skelLines[4].From = neckP; skelLines[4].To = cBoxPos + Vector2.new(-10, 45)
            skelLines[5].From = cBoxPos + Vector2.new(-10, 45); skelLines[5].To = lHandP
            skelLines[6].From = neckP; skelLines[6].To = cBoxPos + Vector2.new(cBoxSize.X + 10, 45)
            skelLines[7].From = cBoxPos + Vector2.new(cBoxSize.X + 10, 45); skelLines[7].To = rHandP
            skelLines[8].From = pelvisP; skelLines[8].To = lFootP
            skelLines[9].From = pelvisP; skelLines[9].To = rFootP
            skelLines[10].From = lFootP; skelLines[10].To = lFootP + Vector2.new(0, 5)
        else
            for _, limb in ipairs(PreviewDrawings.Skeletons) do limb.Visible = false end
        end
    else
        for _, obj in pairs(PreviewDrawings) do 
            if type(obj) == "table" then
                for _, subObj in pairs(obj) do subObj.Visible = false end
            else
                obj.Visible = false 
            end
        end
        IsDraggingPreview = false
        IsDraggingBox = false
        IsDraggingHealth = false
        IsDraggingName = false
    end

    -- Real Player ESP Render Loop (Utilizing custom dragged offsets)
    for player, drawings in pairs(ActiveDrawings) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        local hideEverything = true
        local passesTeamCheck = not AimbotConfig.TeamCheck or (player.Team ~= LocalPlayer.Team)

        if ESPConfig.Enabled and character and humanoid and rootPart and humanoid.Health > 0 and passesTeamCheck then
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                hideEverything = false
                
                local head = character:FindFirstChild("Head")
                local topPosition = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or vector
                local bottomPosition = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(topPosition.Y - bottomPosition.Y)
                local width = height / 2
                local boxSize = Vector2.new(width, height)
                local baseBoxPosition = Vector2.new(vector.X - width / 2, topPosition.Y)
                local boxPosition = baseBoxPosition + ESPConfig.BoxOffset

                drawings.Box.Visible = false
                drawings.BoxOutline.Visible = false
                for _, line in ipairs(drawings.CornerLines) do line.Visible = false end
                for _, line in ipairs(drawings.Box3D) do line.Visible = false end

                if ESPConfig.BoxType ~= "Off" then
                    if ESPConfig.BoxType == "2D Box" then
                        drawings.Box.Visible = true
                        drawings.BoxOutline.Visible = true
                        drawings.Box.Size = boxSize
                        drawings.Box.Position = boxPosition
                        drawings.Box.Color = ESPConfig.BoxColor
                        drawings.BoxOutline.Size = boxSize
                        drawings.BoxOutline.Position = boxPosition
                    elseif ESPConfig.BoxType == "Corner ESP" then
                        local lengthX = width / 4
                        local lengthY = height / 4
                        local lines = drawings.CornerLines
                        
                        lines[1].Visible = true; lines[1].From = boxPosition; lines[1].To = boxPosition + Vector2.new(lengthX, 0); lines[1].Color = ESPConfig.BoxColor
                        lines[2].Visible = true; lines[2].From = boxPosition; lines[2].To = boxPosition + Vector2.new(0, lengthY); lines[2].Color = ESPConfig.BoxColor
                        
                        local tr = boxPosition + Vector2.new(width, 0)
                        lines[3].Visible = true; lines[3].From = tr; lines[3].To = tr - Vector2.new(lengthX, 0); lines[3].Color = ESPConfig.BoxColor
                        lines[4].Visible = true; lines[4].From = tr; lines[4].To = tr + Vector2.new(0, lengthY); lines[4].Color = ESPConfig.BoxColor
                        
                        local bl = boxPosition + Vector2.new(0, height)
                        lines[5].Visible = true; lines[5].From = bl; lines[5].To = bl + Vector2.new(lengthX, 0); lines[5].Color = ESPConfig.BoxColor
                        lines[6].Visible = true; lines[6].From = bl; lines[6].To = bl - Vector2.new(0, lengthY); lines[6].Color = ESPConfig.BoxColor
                        
                        local br = boxPosition + Vector2.new(width, height)
                        lines[7].Visible = true; lines[7].From = br; lines[7].To = br - Vector2.new(lengthX, 0); lines[7].Color = ESPConfig.BoxColor
                        lines[8].Visible = true; lines[8].From = br; lines[8].To = br - Vector2.new(0, lengthY); lines[8].Color = ESPConfig.BoxColor
                    elseif ESPConfig.BoxType == "3D ESP" then
                        local cf = rootPart.CFrame
                        local size = Vector3.new(3, 5.2, 3)
                        local corners = {
                            cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
                            cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
                            cf * CFrame.new(size.X/2, size.Y/2, size.Z/2),
                            cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
                            cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2),
                            cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
                            cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
                            cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)
                        }
                        local screenCorners = {}
                        local allVisible = true
                        for i, corner in ipairs(corners) do
                            local pos, vis = Camera:WorldToViewportPoint(corner.Position)
                            if not vis then allVisible = false end
                            screenCorners[i] = Vector2.new(pos.X, pos.Y) + ESPConfig.BoxOffset
                        end
                        if allVisible then
                            local pairs3D = {
                                {1,2}, {2,3}, {3,4}, {4,1},
                                {5,6}, {6,7}, {7,8}, {8,5},
                                {1,5}, {2,6}, {3,7}, {4,8}
                            }
                            for i, p in ipairs(pairs3D) do
                                local line = drawings.Box3D[i]
                                line.Visible = true
                                line.From = screenCorners[p[1]]
                                line.To = screenCorners[p[2]]
                                line.Color = ESPConfig.BoxColor
                            end
                        end
                    end
                end

                if ESPConfig.Name then
                    drawings.NameText.Visible = true
                    drawings.NameText.Text = player.Name
                    drawings.NameText.Color = ESPConfig.NameColor
                    local defaultNamePos = Vector2.new(baseBoxPosition.X + width / 2, baseBoxPosition.Y - 16)
                    drawings.NameText.Position = defaultNamePos + ESPConfig.NameOffset
                else
                    drawings.NameText.Visible = false
                end

                if ESPConfig.Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
                    drawings.DistanceText.Visible = true
                    drawings.DistanceText.Text = "[" .. dist .. "m]"
                    drawings.DistanceText.Color = ESPConfig.DistanceColor
                    drawings.DistanceText.Position = Vector2.new(boxPosition.X + width / 2, boxPosition.Y + height + 2)
                else
                    drawings.DistanceText.Visible = false
                end

                if ESPConfig.Health then
                    local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    local barHeight = height * healthPercent
                    drawings.HealthBar.Visible = true
                    drawings.HealthBarOutline.Visible = true
                    
                    local healthBarBase = boxPosition + ESPConfig.HealthBarOffset
                    drawings.HealthBarOutline.From = healthBarBase + Vector2.new(0, height)
                    drawings.HealthBarOutline.To = healthBarBase + Vector2.new(0, 0)
                    
                    drawings.HealthBar.From = healthBarBase + Vector2.new(0, height)
                    drawings.HealthBar.To = healthBarBase + Vector2.new(0, height - barHeight)
                    drawings.HealthBar.Color = Color3.fromRGB(255 - (healthPercent * 255), healthPercent * 255, 0)
                else
                    drawings.HealthBar.Visible = false
                    drawings.HealthBarOutline.Visible = false
                end

                if ESPConfig.HeadDot and head then
                    local headPos, headVisible = Camera:WorldToViewportPoint(head.Position)
                    if headVisible then
                        drawings.HeadDot.Visible = true
                        drawings.HeadDot.Position = Vector2.new(headPos.X, headPos.Y) + ESPConfig.BoxOffset
                        drawings.HeadDot.Color = ESPConfig.HeadDotColor
                    else
                        drawings.HeadDot.Visible = false
                    end
                else
                    drawings.HeadDot.Visible = false
                end

                if ESPConfig.Tracers then
                    drawings.Tracer.Visible = true
                    drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    drawings.Tracer.To = Vector2.new(vector.X, bottomPosition.Y) + ESPConfig.BoxOffset
                    drawings.Tracer.Color = ESPConfig.TracerColor
                else
                    drawings.Tracer.Visible = false
                end

                if ESPConfig.Skeletons and head and (character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")) then
                    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                    local lowerTorso = character:FindFirstChild("LowerTorso") or torso
                    local la = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftHand")
                    local ra = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightHand")
                    local ll = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftFoot")
                    local rl = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightFoot")
                    local leftUpperArm = character:FindFirstChild("LeftUpperArm")
                    local rightUpperArm = character:FindFirstChild("RightUpperArm")
                    local leftUpperLeg = character:FindFirstChild("LeftUpperLeg")
                    local rightUpperLeg = character:FindFirstChild("RightUpperLeg")

                    local function to2D(part)
                        if not part then return nil end
                        local pos, vis = Camera:WorldToViewportPoint(part.Position)
                        return vis and (Vector2.new(pos.X, pos.Y) + ESPConfig.BoxOffset) or nil
                    end

                    for _, limb in ipairs(drawings.Skeletons) do limb.Color = ESPConfig.SkeletonColor end

                    local hPos, tPos = to2D(head), to2D(torso)
                    local ltPos = to2D(lowerTorso)
                    local laPos, raPos = to2D(la), to2D(ra)
                    local llPos, rlPos = to2D(ll), to2D(rl)
                    local luaPos = to2D(leftUpperArm)
                    local ruaPos = to2D(rightUpperArm)
                    local lulPos = to2D(leftUpperLeg)
                    local rulPos = to2D(rightUpperLeg)

                    if hPos and tPos then
                        drawings.Skeletons[1].Visible = true; drawings.Skeletons[1].From = hPos; drawings.Skeletons[1].To = tPos
                    else drawings.Skeletons[1].Visible = false end

                    if tPos and ltPos then
                        drawings.Skeletons[2].Visible = true; drawings.Skeletons[2].From = tPos; drawings.Skeletons[2].To = ltPos
                    else drawings.Skeletons[2].Visible = false end

                    if tPos and (luaPos or laPos) then
                        drawings.Skeletons[3].Visible = true; drawings.Skeletons[3].From = tPos; drawings.Skeletons[3].To = luaPos or laPos
                    else drawings.Skeletons[3].Visible = false end

                    if luaPos and laPos then
                        drawings.Skeletons[4].Visible = true; drawings.Skeletons[4].From = luaPos; drawings.Skeletons[4].To = laPos
                    else drawings.Skeletons[4].Visible = false end

                    if tPos and (ruaPos or raPos) then
                        drawings.Skeletons[5].Visible = true; drawings.Skeletons[5].From = tPos; drawings.Skeletons[5].To = ruaPos or raPos
                    else drawings.Skeletons[5].Visible = false end

                    if ruaPos and raPos then
                        drawings.Skeletons[6].Visible = true; drawings.Skeletons[6].From = ruaPos; drawings.Skeletons[6].To = raPos
                    else drawings.Skeletons[6].Visible = false end

                    if ltPos and (lulPos or llPos) then
                        drawings.Skeletons[7].Visible = true; drawings.Skeletons[7].From = ltPos; drawings.Skeletons[7].To = lulPos or llPos
                    else drawings.Skeletons[7].Visible = false end

                    if lulPos and llPos then
                        drawings.Skeletons[8].Visible = true; drawings.Skeletons[8].From = lulPos; drawings.Skeletons[8].To = llPos
                    else drawings.Skeletons[8].Visible = false end

                    if ltPos and (rulPos or rlPos) then
                        drawings.Skeletons[9].Visible = true; drawings.Skeletons[9].From = ltPos; drawings.Skeletons[9].To = rulPos or rlPos
                    else drawings.Skeletons[9].Visible = false end

                    if rulPos and rlPos then
                        drawings.Skeletons[10].Visible = true; drawings.Skeletons[10].From = rulPos; drawings.Skeletons[10].To = rlPos
                    else drawings.Skeletons[10].Visible = false end
                else
                    for _, limb in ipairs(drawings.Skeletons) do limb.Visible = false end
                end

                local highlight = character:FindFirstChild("KillezChams")
                if ESPConfig.Chams then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "KillezChams"
                        highlight.Adornee = character
                        highlight.Parent = character
                    end
                    highlight.FillColor = ESPConfig.ChamsColor
                    highlight.OutlineColor = ESPConfig.ChamsOutlineColor
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Enabled = true
                else
                    if highlight then highlight.Enabled = false end
                end
            end
        end

        if hideEverything then
            for _, obj in pairs(drawings) do
                if type(obj) == "table" then
                    for _, subObj in pairs(obj) do subObj.Visible = false end
                else
                    obj.Visible = false
                end
            end
            local hl = character and character:FindFirstChild("KillezChams")
            if hl then hl.Enabled = false end
        end
    end
end)

-- Handle Preview Window & Item Drag Inputs
UserInputService.InputBegan:Connect(function(input)
    if ESPConfig.Preview and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        
        -- Check click on Name text preview
        local nameTextPos = (PreviewPos + Vector2.new(180/2, 135) - Vector2.new(70/2, 70)) + Vector2.new(0, -16) + NameOffsetPreview
        if (mousePos - nameTextPos).Magnitude < 35 then
            IsDraggingName = true
            DragOffset = mousePos - NameOffsetPreview
            return
        end

        -- Check click on Health bar preview
        local cBoxPos = (PreviewPos + Vector2.new(180/2, 135) - Vector2.new(35, 70)) + BoxOffsetPreview
        local healthBarPos = cBoxPos + HealthOffsetPreview
        if mousePos.X >= healthBarPos.X - 5 and mousePos.X <= healthBarPos.X + 5 and
           mousePos.Y >= healthBarPos.Y and mousePos.Y <= healthBarPos.Y + 140 then
            IsDraggingHealth = true
            DragOffset = mousePos - HealthOffsetPreview
            return
        end

        -- Check click on 2D Box preview
        if mousePos.X >= cBoxPos.X and mousePos.X <= cBoxPos.X + 70 and
           mousePos.Y >= cBoxPos.Y and mousePos.Y <= cBoxPos.Y + 140 then
            IsDraggingBox = true
            DragOffset = mousePos - BoxOffsetPreview
            return
        end

        -- Check click on Window Header bar (Move entire preview window)
        if mousePos.X >= PreviewPos.X and mousePos.X <= PreviewPos.X + 180 and
           mousePos.Y >= PreviewPos.Y and mousePos.Y <= PreviewPos.Y + 26 then
            IsDraggingPreview = true
            DragOffset = mousePos - PreviewPos
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsDraggingPreview = false
        IsDraggingBox = false
        IsDraggingHealth = false
        IsDraggingName = false
    end
end)

UserInputService.JumpRequest:Connect(function()
    if MovementConfig.JumpEnabled and localHumanoid then
        localHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    local humanoid = newChar:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if CombatConfig.HitmarkerEnabled then
            local sound = Instance.new("Sound")
            sound.SoundId = CombatConfig.HitmarkerSoundID
            sound.Volume = 1
            sound.Parent = SoundService
            sound:Play()
            task.delay(2, function() sound:Destroy() end)
        end
    end)
end)


-- ==========================================
-- PAGE 1: COMBAT (Aimbot, Triggerbot & Hitbox)
-- ==========================================
local AimbotLeft = Pages[1]:Section({Name = "Aimbot Settings", Icon = "129960652808688", Side = 1})
local AimbotRight = Pages[1]:Section({Name = "Triggerbot & Hitbox", Icon = "129960652808688", Side = 2})

AimbotLeft:Toggle({
    Name = "Enable Aimbot",
    Flag = "Aimbot_Enable",
    Default = false,
    Callback = function(Value) AimbotConfig.Enabled = Value end
})

AimbotLeft:Toggle({
    Name = "Hard Lock Mode",
    Flag = "Aimbot_HardLock",
    Default = false,
    Callback = function(Value) AimbotConfig.HardLock = Value end
})

AimbotLeft:Dropdown({
    Name = "Aim Method",
    Flag = "Aimbot_Method",
    Default = "Camera",
    Items = {"Camera", "Mouse"},
    MaxSize = 100,
    Callback = function(Value) AimbotConfig.Method = Value end
})

AimbotLeft:Dropdown({
    Name = "Target Bone Selector",
    Flag = "Aimbot_Bone",
    Default = "Head",
    Items = {"Head", "Torso", "HumanoidRootPart"},
    MaxSize = 100,
    Callback = function(Value) 
        AimbotConfig.Hitbox = Value 
    end
})

AimbotLeft:Slider({
    Name = "Customizable FOV Circle",
    Flag = "Aimbot_FOV",
    Default = 100,
    Min = 50,
    Max = 500,
    Decimals = 1,
    Callback = function(Value) AimbotConfig.FOV = Value end
})

AimbotLeft:Slider({
    Name = "Smoothness",
    Flag = "Aimbot_Smoothness",
    Default = 5,
    Min = 1,
    Max = 20,
    Decimals = 1,
    Callback = function(Value) AimbotConfig.Smoothness = Value end
})

AimbotLeft:Label("FOV Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "Aimbot_FOVColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) AimbotConfig.FOVColor = Value end
})

AimbotRight:Toggle({
    Name = "Triggerbot",
    Flag = "Triggerbot_Enable",
    Default = false,
    Callback = function(Value) TriggerbotConfig.Enabled = Value end
})

AimbotRight:Toggle({
    Name = "Enable Hitbox Expander",
    Flag = "Hitbox_Enable",
    Default = false,
    Callback = function(Value) HitboxConfig.Enabled = Value end
})

AimbotRight:Dropdown({
    Name = "Hitbox Expand Target",
    Flag = "Hitbox_PartSelector",
    Default = "Head",
    Items = {"Head", "Torso", "HumanoidRootPart"},
    MaxSize = 100,
    Callback = function(Value) HitboxConfig.PartName = Value end
})

AimbotRight:Slider({
    Name = "Hitbox Size",
    Flag = "Hitbox_Size",
    Default = 3,
    Min = 2,
    Max = 20,
    Decimals = 1,
    Callback = function(Value) HitboxConfig.Size = Value end
})

AimbotRight:Toggle({
    Name = "Team Check",
    Flag = "Aimbot_TeamCheck",
    Default = false,
    Callback = function(Value) AimbotConfig.TeamCheck = Value end
})

AimbotRight:Toggle({
    Name = "Custom Crosshair",
    Flag = "Combat_Crosshair",
    Default = false,
    Callback = function(Value) CombatConfig.CrosshairEnabled = Value end
})

AimbotRight:Label("Crosshair Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "Combat_CrosshairColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) CombatConfig.CrosshairColor = Value end
})

AimbotRight:Toggle({
    Name = "Hitmarker Audio Effects",
    Flag = "Combat_Hitmarker",
    Default = false,
    Callback = function(Value) CombatConfig.HitmarkerEnabled = Value end
})


-- ==========================================
-- PAGE 2: VISUALS (ESP & Custom Pink Sky)
-- ==========================================
local ESPLeft = Pages[2]:Section({Name = "ESP Overlays", Icon = "109391165290124", Side = 1})
local ESPRight = Pages[2]:Section({Name = "ESP Colors & Visual Themes", Icon = "109391165290124", Side = 2})

ESPLeft:Toggle({
    Name = "Enable ESP",
    Flag = "ESP_Enable",
    Default = false,
    Callback = function(Value) ESPConfig.Enabled = Value end
})


ESPLeft:Dropdown({
    Name = "Box ESP Type",
    Flag = "ESP_BoxType",
    Default = "2D Box",
    Items = {"Off", "2D Box", "Corner ESP", "3D ESP"},
    MaxSize = 120,
    Callback = function(Value) ESPConfig.BoxType = Value end
})

ESPLeft:Toggle({
    Name = "Stickman Skeleton",
    Flag = "ESP_Skeletons",
    Default = false,
    Callback = function(Value) ESPConfig.Skeletons = Value end
})

ESPLeft:Toggle({
    Name = "Health Bar",
    Flag = "ESP_Health",
    Default = false,
    Callback = function(Value) ESPConfig.Health = Value end
})

ESPLeft:Toggle({
    Name = "Player Names",
    Flag = "ESP_Name",
    Default = false,
    Callback = function(Value) ESPConfig.Name = Value end
})

ESPLeft:Toggle({
    Name = "Distance",
    Flag = "ESP_Distance",
    Default = false,
    Callback = function(Value) ESPConfig.Distance = Value end
})

ESPLeft:Toggle({
    Name = "Head Dot",
    Flag = "ESP_HeadDot",
    Default = false,
    Callback = function(Value) ESPConfig.HeadDot = Value end
})

ESPLeft:Toggle({
    Name = "Tracers",
    Flag = "ESP_Tracers",
    Default = false,
    Callback = function(Value) ESPConfig.Tracers = Value end
})

ESPLeft:Toggle({
    Name = "Wall Chams",
    Flag = "ESP_Chams",
    Default = false,
    Callback = function(Value) ESPConfig.Chams = Value end
})

ESPRight:Toggle({
    Name = "Custom Pink Sky Theme",
    Flag = "Visuals_PinkSky",
    Default = false,
    Callback = function(Value) VisualsConfig.PinkSkyEnabled = Value end
})

ESPRight:Label("Box Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "ESP_BoxColor",
    Default = Color3.fromRGB(0, 255, 128),
    Callback = function(Value) ESPConfig.BoxColor = Value end
})

ESPRight:Label("Name Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "ESP_NameColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) ESPConfig.NameColor = Value end
})

ESPRight:Label("Distance Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "ESP_DistanceColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) ESPConfig.DistanceColor = Value end
})

ESPRight:Label("Tracer Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "ESP_TracerColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) ESPConfig.TracerColor = Value end
})

ESPRight:Label("Skeleton Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "ESP_SkeletonColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) ESPConfig.SkeletonColor = Value end
})

ESPRight:Label("Wall Chams Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "ESP_ChamsColor",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value) ESPConfig.ChamsColor = Value end
})

ESPRight:Label("Wall Chams Outline Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "ESP_ChamsOutlineColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) ESPConfig.ChamsOutlineColor = Value end
})


-- ==========================================
-- PAGE 3: MOVEMENT & UTILITIES
-- ==========================================
local MoveLeft = Pages[3]:Section({Name = "Movement Modifications", Icon = "112887626955824", Side = 1})
local MoveRight = Pages[3]:Section({Name = "Flight, Physics & Spinbot", Icon = "112887626955824", Side = 2})

MoveLeft:Toggle({
    Name = "Enable Speedhack",
    Flag = "Move_SpeedEnable",
    Default = false,
    Callback = function(Value) MovementConfig.SpeedEnabled = Value end
})

MoveLeft:Slider({
    Name = "WalkSpeed",
    Flag = "Move_Speed",
    Default = 16,
    Min = 16,
    Max = 200,
    Decimals = 1,
    Callback = function(Value) MovementConfig.WalkSpeed = Value end
})

MoveLeft:Toggle({
    Name = "Enable CFrame Speedhack",
    Flag = "Move_CFrameSpeedEnable",
    Default = false,
    Callback = function(Value) MovementConfig.CFrameSpeedEnabled = Value end
})

MoveLeft:Slider({
    Name = "CFrame Speed Value",
    Flag = "Move_CFrameSpeedVal",
    Default = 25,
    Min = 10,
    Max = 150,
    Decimals = 1,
    Callback = function(Value) MovementConfig.CFrameSpeedValue = Value end
})

MoveLeft:Toggle({
    Name = "Enable Inf Jump",
    Flag = "Move_JumpEnable",
    Default = false,
    Callback = function(Value) MovementConfig.JumpEnabled = Value end
})

MoveLeft:Toggle({
    Name = "Bunny Hop (BHop)",
    Flag = "Move_Bhop",
    Default = false,
    Callback = function(Value) MovementConfig.BhopEnabled = Value end
})

MoveLeft:Toggle({
    Name = "Noclip",
    Flag = "Move_Noclip",
    Default = false,
    Callback = function(Value) MovementConfig.NoclipEnabled = Value end
})

MoveRight:Toggle({
    Name = "Enable CFrame Fly",
    Flag = "Move_FlyEnable",
    Default = false,
    Callback = function(Value) MovementConfig.FlyEnabled = Value end
})

MoveRight:Slider({
    Name = "Fly Speed",
    Flag = "Move_FlySpeed",
    Default = 50,
    Min = 10,
    Max = 200,
    Decimals = 1,
    Callback = function(Value) MovementConfig.FlySpeed = Value end
})

MoveRight:Toggle({
    Name = "Physics Boost (No Rubberband)",
    Flag = "Move_PhysicsBoost",
    Default = false,
    Callback = function(Value) MovementConfig.PhysicsBoost = Value end
})

MoveRight:Toggle({
    Name = "Spinbot",
    Flag = "Move_Spinbot",
    Default = false,
    Callback = function(Value) MovementConfig.SpinbotEnabled = Value end
})

MoveRight:Slider({
    Name = "Spin Speed",
    Flag = "Move_SpinSpeed",
    Default = 50,
    Min = 10,
    Max = 200,
    Decimals = 1,
    Callback = function(Value) MovementConfig.SpinSpeed = Value end
})


-- ==========================================
-- PAGE 4: WORLD STUFF
-- ==========================================
local WorldLeft = Pages[4]:Section({Name = "Environment & Time", Icon = "72974659157165", Side = 1})
local WorldRight = Pages[4]:Section({Name = "World Themes & Sky", Icon = "72974659157165", Side = 2})

WorldLeft:Toggle({
    Name = "Custom Time",
    Flag = "World_TimeEnable",
    Default = false,
    Callback = function(Value) WorldConfig.TimeEnabled = Value end
})

WorldLeft:Slider({
    Name = "Clock Time",
    Flag = "World_TimeValue",
    Default = 12,
    Min = 0,
    Max = 24,
    Decimals = 1,
    Callback = function(Value) WorldConfig.TimeValue = Value end
})

WorldLeft:Toggle({
    Name = "Custom Brightness",
    Flag = "World_BrightnessEnable",
    Default = false,
    Callback = function(Value) WorldConfig.BrightnessEnabled = Value end
})

WorldLeft:Slider({
    Name = "Brightness Level",
    Flag = "World_BrightnessValue",
    Default = 2,
    Min = 0,
    Max = 10,
    Decimals = 1,
    Callback = function(Value) WorldConfig.BrightnessValue = Value end
})

WorldRight:Toggle({
    Name = "Remove Fog (Full Vision)",
    Flag = "World_FogEnable",
    Default = false,
    Callback = function(Value) WorldConfig.FogEnabled = Value end
})

WorldRight:Toggle({
    Name = "Enable Global World Color",
    Flag = "World_ColorToggle",
    Default = false,
    Callback = function(Value) WorldConfig.WorldColorCustomizerEnabled = Value end
})

WorldRight:Label("Global World / Ambient Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "World_GlobalColorPicker",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) WorldConfig.GlobalWorldColor = Value end
})

WorldRight:Label("Outdoor Ambient Color"):Colorpicker({
    Name = "Colorpicker",
    Flag = "World_OutdoorColorPicker",
    Default = Color3.fromRGB(128, 128, 128),
    Callback = function(Value) WorldConfig.OutdoorAmbientColor = Value end
})