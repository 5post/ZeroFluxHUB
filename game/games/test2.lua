local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "ZeroFlux HUB 1.0 BETA Summer Edition💥",
    SubTitle = "by CrashCover",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "arrow-left-right" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Trolling = Window:AddTab({ Title = "Trolling", Icon = "laugh" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "person-standing" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Emotes = Window:AddTab({ Title = "Emotes", Icon = "smile" }),
    Other = Window:AddTab({ Title = "Other", Icon = "power" }),
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "puzzle" }),
    ReportBugs = Window:AddTab({ Title = "ReportBugs", Icon = "bug" }),
    Status = Window:AddTab({ Title = "Status", Icon = "siren" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "link-2" }),
    AboutScript = Window:AddTab({ Title = "AboutScript", Icon = "file-code-2" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    -- Получаем игрока и его персонажа
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    local Camera = workspace.CurrentCamera

    -- Переменные для управления полетом и Noclip
    local FlyEnabled = false
    local NoclipEnabled = false
    local FlyBodyVelocity, FlyBodyGyro
    local DefaultGravity = workspace.Gravity

    -- Функция для применения JumpPower с повторными попытками
    local function ApplyJumpPower(value)
        local attempts = 0
        local maxAttempts = 10
        local function tryApply()
            if Humanoid then
                Humanoid.JumpPower = value
                print("JumpPower successfully set to:", value)
            else
                attempts = attempts + 1
                if attempts < maxAttempts then
                    task.wait(0.1)
                    task.defer(tryApply)
                else
                    print("Failed to set JumpPower: Humanoid not found after", maxAttempts, "attempts")
                end
            end
        end
        tryApply()
    end

    -- Функция для включения/выключения полета (как в Infinite Yield)
    local function ToggleFly(enabled)
        FlyEnabled = enabled
        if FlyEnabled then
            -- Отключаем гравитацию
            workspace.Gravity = 0
            Humanoid.PlatformStand = true -- Отключаем управление персонажем

            FlyBodyVelocity = Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            FlyBodyVelocity.Parent = RootPart

            FlyBodyGyro = Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyGyro.P = 9000
            FlyBodyGyro.D = 500
            FlyBodyGyro.CFrame = RootPart.CFrame
            FlyBodyGyro.Parent = RootPart

            -- Управление полетом
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            RunService:BindToRenderStep("FlyLoop", Enum.RenderPriority.Input.Value, function()
                if not FlyEnabled then return end
                local moveDirection = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end

                -- Нормализация направления и применение скорости
                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit * Options.FlySpeed.Value
                end
                FlyBodyVelocity.Velocity = Vector3.new(moveDirection.X, moveDirection.Y, moveDirection.Z)
                FlyBodyGyro.CFrame = Camera.CFrame
            end)
        else
            -- Отключаем полет
            if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
            if FlyBodyGyro then FlyBodyGyro:Destroy() end
            workspace.Gravity = DefaultGravity
            Humanoid.PlatformStand = false
            game:GetService("RunService"):UnbindFromRenderStep("FlyLoop")
        end
    end

    -- Функция для включения/выключения Noclip
    local function ToggleNoclip(enabled)
        NoclipEnabled = enabled
        task.spawn(function()
            while NoclipEnabled do
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                task.wait(1/60)
            end
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end)
    end

    -- Обновление персонажа при респавне
    LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        Humanoid = newCharacter:WaitForChild("Humanoid")
        RootPart = newCharacter:WaitForChild("HumanoidRootPart")
        if Options.EnableWalkspeed.Value then
            Humanoid.WalkSpeed = Options.WalkSpeed.Value
        end
        if Options.EnableJumpPower.Value then
            ApplyJumpPower(Options.JumpPower.Value)
        end
        if FlyEnabled then
            ToggleFly(true)
        end
        if NoclipEnabled then
            ToggleNoclip(true)
        end
    end)

    -- Раздел "Character"
    Tabs.Player:AddParagraph({
        Title = "Character",
        Content = ""
    })

    -- WalkSpeed
    local WalkSpeedToggle = Tabs.Player:AddToggle("EnableWalkspeed", {Title = "Enable Walkspeed", Default = false})
    WalkSpeedToggle:OnChanged(function(value)
        Options.EnableWalkspeed.Value = value
        if value and Humanoid then
            Humanoid.WalkSpeed = Options.WalkSpeed.Value
        else
            if Humanoid then
                Humanoid.WalkSpeed = 16
            end
        end
    end)

    local WalkSpeedSlider = Tabs.Player:AddSlider("WalkSpeed", {
        Title = "WalkSpeed",
        Default = 16,
        Min = 16,
        Max = 250,
        Rounding = 1,
        Callback = function(value)
            if Options.EnableWalkspeed.Value and Humanoid then
                Humanoid.WalkSpeed = value
            end
        end
    })

    -- JumpPower
    local JumpPowerToggle = Tabs.Player:AddToggle("EnableJumpPower", {Title = "Enable JumpPower", Default = false})
    JumpPowerToggle:OnChanged(function(value)
        Options.EnableJumpPower.Value = value
        if value then
            ApplyJumpPower(Options.JumpPower.Value)
        else
            ApplyJumpPower(50)
        end
    end)

    local JumpPowerSlider = Tabs.Player:AddSlider("JumpPower", {
        Title = "JumpPower",
        Default = 50,
        Min = 50,
        Max = 500,
        Rounding = 1,
        Callback = function(value)
            if Options.EnableJumpPower.Value then
                ApplyJumpPower(value)
            end
        end
    })

    -- Fly
    local FlyToggle = Tabs.Player:AddToggle("Fly", {Title = "Fly", Default = false})
    FlyToggle:OnChanged(function(value)
        ToggleFly(value)
    end)

    local FlySpeedSlider = Tabs.Player:AddSlider("FlySpeed", {
        Title = "FlySpeed",
        Default = 50,
        Min = 30,
        Max = 500,
        Rounding = 1,
        Callback = function(value)
            -- Скорость обновляется в цикле полета
        end
    })

    -- Noclip
    local NoclipToggle = Tabs.Player:AddToggle("Noclip", {Title = "Noclip", Default = false})
    NoclipToggle:OnChanged(function(value)
        ToggleNoclip(value)
    end)

    -- FOV
    local FOVSlider = Tabs.Player:AddSlider("FOV", {
        Title = "FOV",
        Default = 70,
        Min = 10,
        Max = 120,
        Rounding = 1,
        Callback = function(value)
            Camera.FieldOfView = value
        end
    })

    -- Раздел "Other"
    Tabs.Player:AddParagraph({
        Title = "Other",
        Content = ""
    })

    -- Кнопка Rejoin
    Tabs.Player:AddButton({
        Title = "Rejoin",
        Description = "Rejoin the game",
        Callback = function()
            local TeleportService = game:GetService("TeleportService")
            local placeId = game.PlaceId
            local jobId = game.JobId
            TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
        end
    })
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("ZeroFlux")
SaveManager:SetFolder("ZeroFlux/config")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
