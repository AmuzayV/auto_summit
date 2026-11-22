
--==================================================
-- AUTO SUMMIT CONTROLLER - FIXED VERSION
-- Session Protection + LastCheckpoint Protection
--==================================================

--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- SESSION PROTECTION
--==================================================

local env = _G

if type(getgenv) == "function" then
    env = getgenv()
end

env.__SummitControllerSession =
    (env.__SummitControllerSession or 0) + 1

local sessionId = env.__SummitControllerSession

local function isCurrentSession()
    return env.__SummitControllerSession == sessionId
end

--==================================================
-- REMOTE & SUMMIT COORDINATES
--==================================================

local resetRemote = ReplicatedStorage
    :WaitForChild("LavaSummitKit")
    :WaitForChild("Remotes")
    :WaitForChild("ResetCheckpoint")

local summitCFrame = CFrame.new(
    5565.88232, 4275.94482, 12533.79,
    0.999180496, 0, 0.0404767282,
    0, 1, 0,
    -0.0404767282, 0, 0.999180496
)

local summitPos = summitCFrame.Position

--==================================================
-- CHECKPOINT COORDINATES (31 CHECKPOINTS)
--==================================================

local checkpoints = {

    CFrame.new(-1581.7677, 1245.74988, -5047.02686, 0.977872908, -0, -0.209199861, 0, 1, -0, 0.209199861, 0, 0.977872908),

    CFrame.new(-1454.29895, 1324, -4513.14453, 0.967664599, 0, 0.252240509, 0, 1, 0, -0.252240509, 0, 0.967664509),

    CFrame.new(-1403, 1222.20837, -3738, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(-1464, 1350.93323, -3112, 0.829943836, -0, -0.557846963, 0, 1, -0, 0.557846963, 0, 0.829943836),

    CFrame.new(-1399.11865, 1230.93323, -2657.13892, 0.928458512, -0, -0.371436089, 0, 1, -0, 0.371436089, 0, 0.928458512),

    CFrame.new(-1360, 1230.93323, -2230, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(-1488, 1294.93323, -2048, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(-1428, 1274.93323, -1402, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(-1384.14148, 1274, -985.836365, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(-1486, 1274.9353, -374, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(-1260, 1398, 252, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(-1387.93506, 1557.3252, 1171, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(-1138, 1831, 1638, 0.826299846, 0, 0.563230455, 0, 1, 0, -0.563230455, 0, 0.826299846),

    CFrame.new(-764.511047, 1830.77429, 1865.87769, -0.67859149, 0, -0.734516025, 0, 1, 0, 0.734516025, 0, -0.67859149),

    CFrame.new(-313.403473, 1702.86365, 2313.35181, -0.639399171, 0, 0.768875003, 0, 1, 0, -0.768875003, 0, -0.639399171),

    CFrame.new(-18.6811943, 2018, 1678.28992, 0.251489282, -0, -0.967860103, 0, 1, -0, 0.967860103, 0, 0.251489282),

    CFrame.new(547.332153, 2033.45068, 1988.92505, 0.327806115, 0, 0.944745004, 0, 1, 0, -0.944745004, 0, 0.327806115),

    CFrame.new(1204.5, 1778, 1815, -0.129094124, 0, 0.991632402, 0, 1, 0, -0.991632402, 0, -0.129094124),

    CFrame.new(1806, 2026, 1760.94263, -0.0991055965, 0, 0.995076954, 0, 1, 0, -0.995076954, 0, -0.0991055965),

    CFrame.new(2613.90356, 2089.70312, 2101.90381, 0.587670267, 0, 0.809100568, 0, 1, 0, -0.809100568, 0, 0.587670267),

    CFrame.new(2474, 2140, 2435, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(2814.02441, 2170.1106, 2804.10376, 0.71468246, 0, 0.699449062, 0, 1, 0, -0.699449062, 0, 0.71468246),

    CFrame.new(3400.94385, 2129.95508, 3189.89917, 0.580505967, 0, 0.814255953, 0, 1, 0, -0.814255953, 0, 0.580505967),

    CFrame.new(4302, 2566.86548, 3980, 0.288513899, 0, 0.957475662, 0, 1, 0, -0.957475662, 0, 0.288513899),

    CFrame.new(5424.49951, 2554.77441, 4780.99951, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(7168, 3989.89917, 8614, 0.789531708, -0, -0.613709807, 0, 1, -0, 0.613709807, 0, 0.789531708),

    CFrame.new(6855.75684, 4014.41943, 8878.71973, 0.900222182, -0, -0.435430884, 0, 1, -0, 0.435430884, 0, 0.900222182),

    CFrame.new(6703.70459, 4001.32446, 9497.36328, 1, 0, 0, 0, 1, 0, 0, 0, 1),

    CFrame.new(6362.45215, 4057.63916, 10214.6201, 0.944055617, -0, -0.329786301, 0, 1, -0, 0.329786301, 0, 0.944055617),

    CFrame.new(6185.94971, 4160.06348, 10926.7461, 0.999370456, -5.43565257e-05, 0.0354778655, 0.00115381635, 0.999519646, -0.0309702847, -0.0354591422, 0.0309917238, 0.99889046),

    CFrame.new(6061.63086, 4224.59375, 11640.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),

}

--==================================================
-- SETTINGS
--==================================================

local STEP_DELAY = 0.90
local CP31_TO_SUMMIT_DELAY = 1
local SUMMIT_WAIT_DELAY = 2.00
local LASTCHECKPOINT_TO_CP1_DELAY = 2.00
local SUMMIT_RADIUS = 30

local autoLastCheckpoint = false
local autoSummit = false
local minimized = false

local lastFireClock = 0

-- Toggle generation counters
local lastCheckpointVersion = 0
local summitVersion = 0

--==================================================
-- CHECKPOINT FUNCTIONS
--==================================================

local function getCheckpointValue()

    local leaderstats = player:FindFirstChild("leaderstats")
    local cp = leaderstats and leaderstats:FindFirstChild("Checkpoint")

    return cp and tostring(cp.Value) or nil

end

local function isNearSummit()

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    return hrp and
        ((hrp.Position - summitPos).Magnitude <= SUMMIT_RADIUS)
        or false

end

--==================================================
-- TELEPORT FUNCTION
--==================================================

local function teleportTo(cf)

    if not isCurrentSession() then
        return false
    end

    local char = player.Character or player.CharacterAdded:Wait()

    if not isCurrentSession() then
        return false
    end

    local hrp = char:WaitForChild("HumanoidRootPart")

    if not isCurrentSession() then
        return false
    end

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    hrp.CFrame = cf + Vector3.new(0, 2.5, 0)

    return true

end

--==================================================
-- AUTO LASTCHECKPOINT - PROTECTED
--==================================================

local function fireLastCheckpointAfterWait()

    if not isCurrentSession() then
        return
    end

    if not autoLastCheckpoint then
        return
    end

    if os.clock() - lastFireClock < 2.5 then
        return
    end

    -- Remember which ON/OFF state started this operation
    local currentVersion = lastCheckpointVersion

    lastFireClock = os.clock()

    task.wait(SUMMIT_WAIT_DELAY)

    -- Validate session
    if not isCurrentSession() then
        return
    end

    -- Validate toggle state and generation
    if not autoLastCheckpoint then
        return
    end

    if currentVersion ~= lastCheckpointVersion then
        return
    end

    -- Validate actual character position
    if not isNearSummit() then
        return
    end

    -- Send reset only after all checks pass
    resetRemote:FireServer()

end

--==================================================
-- GUI SETUP
--==================================================

local existingGui = playerGui:FindFirstChild("SummitControlGui")

if existingGui then
    existingGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SummitControlGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local fullSize = UDim2.new(0, 270, 0, 165)
local minSize = UDim2.new(0, 270, 0, 36)

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = fullSize
frame.Position = UDim2.new(0.5, -135, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(34, 38, 48)
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -46, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Summit Controller"
title.TextColor3 = Color3.fromRGB(240, 244, 248)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = header

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 24)
minBtn.Position = UDim2.new(1, -32, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(52, 58, 72)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minBtn

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -48)
content.Position = UDim2.new(0, 10, 0, 42)
content.BackgroundTransparency = 1
content.Parent = frame

-- Auto LastCheckpoint Button
local lastCpBtn = Instance.new("TextButton")
lastCpBtn.Size = UDim2.new(1, 0, 0, 46)
lastCpBtn.Position = UDim2.new(0, 0, 0, 4)
lastCpBtn.BackgroundColor3 = Color3.fromRGB(45, 52, 66)
lastCpBtn.Text = "Auto LastCheckpoint: OFF"
lastCpBtn.TextColor3 = Color3.fromRGB(235, 238, 242)
lastCpBtn.Font = Enum.Font.GothamSemibold
lastCpBtn.TextSize = 13
lastCpBtn.Parent = content

local lastCpCorner = Instance.new("UICorner")
lastCpCorner.CornerRadius = UDim.new(0, 6)
lastCpCorner.Parent = lastCpBtn

-- Auto Summit Button
local summitBtn = Instance.new("TextButton")
summitBtn.Size = UDim2.new(1, 0, 0, 46)
summitBtn.Position = UDim2.new(0, 0, 0, 58)
summitBtn.BackgroundColor3 = Color3.fromRGB(45, 52, 66)
summitBtn.Text = "Auto Summit: OFF"
summitBtn.TextColor3 = Color3.fromRGB(235, 238, 242)
summitBtn.Font = Enum.Font.GothamSemibold
summitBtn.TextSize = 13
summitBtn.Parent = content

local summitCorner = Instance.new("UICorner")
summitCorner.CornerRadius = UDim.new(0, 6)
summitCorner.Parent = summitBtn

--==================================================
-- DRAG SYSTEM
--==================================================

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

header.InputBegan:Connect(function(input)

    if not isCurrentSession() then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)

    end

end)

header.InputChanged:Connect(function(input)

    if not isCurrentSession() then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not isCurrentSession() then
        return
    end

    if input == dragInput and dragging then

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

    end

end)

--==================================================
-- MINIMIZE / MAXIMIZE
--==================================================

minBtn.MouseButton1Click:Connect(function()

    if not isCurrentSession() then
        return
    end

    minimized = not minimized

    content.Visible = not minimized

    frame.Size = minimized and minSize or fullSize

    minBtn.Text = minimized and "+" or "-"

end)

--==================================================
-- TOGGLE AUTO LASTCHECKPOINT
--==================================================

lastCpBtn.MouseButton1Click:Connect(function()

    if not isCurrentSession() then
        return
    end

    autoLastCheckpoint = not autoLastCheckpoint

    -- Invalidate any pending operation
    lastCheckpointVersion = lastCheckpointVersion + 1

    lastCpBtn.Text = autoLastCheckpoint
        and "Auto LastCheckpoint: ON"
        or "Auto LastCheckpoint: OFF"

    lastCpBtn.BackgroundColor3 = autoLastCheckpoint
        and Color3.fromRGB(34, 139, 87)
        or Color3.fromRGB(45, 52, 66)

end)

--==================================================
-- TOGGLE AUTO SUMMIT
--==================================================

summitBtn.MouseButton1Click:Connect(function()

    if not isCurrentSession() then
        return
    end

    autoSummit = not autoSummit

    -- Invalidate the previous Summit run
    summitVersion = summitVersion + 1

    summitBtn.Text = autoSummit
        and "Auto Summit: ON"
        or "Auto Summit: OFF"

    summitBtn.BackgroundColor3 = autoSummit
        and Color3.fromRGB(37, 99, 235)
        or Color3.fromRGB(45, 52, 66)

end)

--==================================================
-- WORKER 1: AUTO LASTCHECKPOINT
--==================================================

task.spawn(function()

    while isCurrentSession() do

        if autoLastCheckpoint
            and (
                getCheckpointValue() == "Summit"
                or isNearSummit()
            ) then

            fireLastCheckpointAfterWait()

        end

        task.wait(0.25)

    end

end)

--==================================================
-- WORKER 2: AUTO SUMMIT
--==================================================

task.spawn(function()

    while isCurrentSession() do

        if autoSummit then

            local currentRun = summitVersion

            local function isRunActive()
                return isCurrentSession()
                    and autoSummit
                    and summitVersion == currentRun
            end

            -- Already at Summit
            if getCheckpointValue() == "Summit" then

                task.wait(SUMMIT_WAIT_DELAY)

                while isRunActive()
                    and getCheckpointValue() ~= "Basecamp" do

                    task.wait(0.25)

                end

            else

                -- Visit all 31 checkpoints
                for i, cf in ipairs(checkpoints) do

                    if not isRunActive()
                        or getCheckpointValue() == "Summit" then

                        break

                    end

                    if not teleportTo(cf) then
                        break
                    end

                    if i == #checkpoints then

                        task.wait(CP31_TO_SUMMIT_DELAY)

                    else

                        task.wait(STEP_DELAY)

                    end

                    if not isRunActive() then
                        break
                    end

                end

                -- Teleport to Summit
                if isRunActive()
                    and getCheckpointValue() ~= "Summit" then

                    teleportTo(summitCFrame)

                    task.wait(SUMMIT_WAIT_DELAY)

                end

                -- Wait until server returns player to Basecamp
                while isRunActive()
                    and getCheckpointValue() ~= "Basecamp" do

                    task.wait(0.25)

                end

            end

        else

            task.wait(0.25)

        end

    end

end)

--==================================================
-- SCRIPT INITIALIZED
--==================================================

print("[Summit Controller] Loaded successfully!")
print("[Summit Controller] Session:", sessionId)
print("[Summit Controller] Checkpoints:", #checkpoints)
