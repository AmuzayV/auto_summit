local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local STEP_DELAY = 2.5
local SUMMIT_WAIT = 2.5
local BASECAMP_TO_CP1_DELAY = 2.5
local TELEPORT_OFFSET = Vector3.new(0, 2.5, 0)

local running = false
local runToken = 0

--==================================================
-- CFRAME DATA
-- Diambil dari MOUNT SOREYA.txt
--==================================================

local checkpoints = {
    CFrame.new(463.759888,455.334808,-8945.72363,
    -0.0348786116,0.00183136202,-0.999389887,
    0.0175414421,0.999845386,0.00121999998,
    0.999237657,-0.017488189,-0.0349054337),

    CFrame.new(449.5,500,-9568,
    0,0,-1,0,1,0,1,0,0),

    CFrame.new(398.275421,640,-10113.5293,
    0.0175017118,0,-0.999846935,
    0,1,0,0.999846935,0,0.0175017118),

    CFrame.new(486.500458,649,-10680.999,
    1,0,0,0,1,0,0,0,1),

    CFrame.new(1088.50122,735.5,-11156.499,
    0,0,1,0,1,0,-1,0,0),

    CFrame.new(973.687439,746,-11808.9043,
    0.996191859,0,-0.0871884301,
    0,1,0,0.0871884301,0,0.996191859),

    CFrame.new(391.5,896,-11839,
    1,0,0,0,1,0,0,0,1),

    CFrame.new(-325.874237,858.783447,-11738.4873,
    -0.999847054,0.0174499545,-0.00148872123,
    0.017421497,0.999697447,0.0173637085,
    0.00179126672,0.0173351094,-0.999848485),

    CFrame.new(-869.700195,864.099976,-11737.4004,
    1,0,0,0,1,0,0,0,1),

    CFrame.new(-1281.52966,868.233643,-12093.6221,
    -0.0370904207,-0.00480727572,-0.99930048,
    0.0171143264,0.99983871,-0.00544508314,
    0.999165535,-0.0173043106,-0.0370020866),

    CFrame.new(-1310.59595,900.258057,-12834.415,
    -0.998505235,-0.0156297516,0.0523745082,
    -0.0156071372,0.99987787,0.000840785215,
    -0.052381251,0.0000221123046,-0.998627186),

    CFrame.new(-2326.6875,924.822815,-12672.8594,
    -0.0448124409,0.0125930849,-0.99891603,
    -0.0314307585,0.999407768,0.0140092997,
    0.998500824,0.0320244767,-0.0443900824),

    CFrame.new(-2309.1001,928.094788,-11856.9004,
    0,0,-1,0,1,0,1,0,0),

    CFrame.new(-2444.75879,972.773743,-11057.5,
    -0.999970078,0.00145893788,-0.00759792235,
    0.00147598691,0.999996424,-0.00223878049,
    0.00759462919,-0.00224992796,-0.999968648),

    CFrame.new(-3480.15356,992.511719,-11014.8867,
    -0.999627948,0.000893750112,0.0272742379,
    0.000832528691,0.999997079,-0.00225593569,
    -0.0272761751,-0.00223238906,-0.999625802),

    CFrame.new(-4225.69971,1012.00183,-11018.0068,
    0.999627352,0.00139046006,-0.0272628572,
    -0.000853594975,0.999805689,0.0196939409,
    0.0272849444,-0.0196633302,0.999434292),

    CFrame.new(-4650.55029,1091.40015,-11665.2578,
    -0.999685407,0.00139356358,-0.025046343,
    0.00188625604,0.999804974,-0.0196583886,
    0.0250140633,-0.019699445,-0.999493003),

    CFrame.new(-5543.90723,1112.61926,-11651.751,
    -0.999627709,0.00139046006,0.0272628572,
    0.000853594975,0.999805689,-0.0196939409,
    -0.0272849444,-0.0196633302,-0.99943459),

    CFrame.new(-6766.57275,1106.15234,-11507.1396,
    -0.0272916555,0.0013668891,-0.999626696,
    0.0196667388,0.999806225,0.000830198638,
    0.999434173,-0.019636739,-0.0273132324),

    CFrame.new(-6761.15381,1114.65051,-10800.5576,
    -0.0272916555,0.0013668891,-0.999626696,
    0.0196667388,0.999806225,0.000830198638,
    0.999434173,-0.019636739,-0.0273132324),
}

local summitCFrame = CFrame.new(
   -6766.08349609,1310.39770508,-10085.51953125,
   -0.999999940,0.000000005,0.000277710,
   0.000000005,1.000000000,0.000000073,
   -0.000277710,0.000000073,-0.999999940

)

local baseCampCFrame = CFrame.new(
    -6832.21093750,1312.61535645,-9842.54785156,
    -0.064271353,0.000000072,0.997932434,
    0.000000000,1.000000000,-0.000000072,
    -0.997932434,-0.000000004,-0.064271353
)

--==================================================
-- TELEPORT SYSTEM
--==================================================

local function teleportTo(cf)
    local character = player.Character
    if not character then
        return false
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return false
    end

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = cf + TELEPORT_OFFSET

    return true
end

local function waitCancelable(seconds, token)
    local startTime = os.clock()

    while os.clock() - startTime < seconds do
        if not running or token ~= runToken then
            return false
        end
        task.wait(0.05)
    end

    return running and token == runToken
end

--==================================================
-- GUI
--==================================================

local oldGui = playerGui:FindFirstChild("SoreyaAutoSummit")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SoreyaAutoSummit"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280, 190)
frame.Position = UDim2.new(0.5,-140,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,28,36)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,9)

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1,0,0,35)
header.BackgroundColor3 = Color3.fromRGB(38,43,55)
header.Text = "MOUNT SOREYA | AUTO SUMMIT"
header.TextColor3 = Color3.new(1,1,1)
header.Font = Enum.Font.GothamBold
header.TextSize = 12
header.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,48)
status.Position = UDim2.fromOffset(10,43)
status.BackgroundTransparency = 1
status.Text = "Status: STOPPED\nCheckpoint: -"
status.TextColor3 = Color3.fromRGB(100,255,160)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

local function createButton(name,text,y,color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1,-20,0,38)
    btn.Position = UDim2.fromOffset(10,y)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = frame
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)
    return btn
end

local startBtn = createButton(
    "StartButton","START AUTO SUMMIT",100,
    Color3.fromRGB(30,145,85)
)

local stopBtn = createButton(
    "StopButton","STOP",145,
    Color3.fromRGB(180,55,55)
)

-- Drag GUI
local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--==================================================
-- AUTO SUMMIT LOOP
--==================================================

local function startAutoSummit()
    if running then
        return
    end

    running = true
    runToken += 1

    local token = runToken

    task.spawn(function()
        while running and token == runToken do

            -- CP1 sampai CP20
            for i, cf in ipairs(checkpoints) do
                if not running or token ~= runToken then
                    break
                end

                status.Text = string.format(
                    "Status: RUNNING\nCheckpoint: CP%d / CP20",
                    i
                )

                if not teleportTo(cf) then
                    status.Text = "Character tidak ditemukan!"
                    running = false
                    break
                end

                if not waitCancelable(STEP_DELAY,token) then
                    break
                end
            end

            if not running or token ~= runToken then
                break
            end

            -- SUMMIT
            status.Text = "Status: RUNNING\nCheckpoint: SUMMIT"

            teleportTo(summitCFrame)

            if not waitCancelable(SUMMIT_WAIT,token) then
                break
            end

            -- BASECAMP
            status.Text = "Status: RUNNING\nCheckpoint: BASECAMP"

            teleportTo(baseCampCFrame)

            if not waitCancelable(BASECAMP_TO_CP1_DELAY,token) then
                break
            end
        end

        if token == runToken then
            running = false
            status.Text = "Status: STOPPED\nCheckpoint: -"
        end
    end)
end

local function stopAutoSummit()
    running = false
    runToken += 1
    status.Text = "Status: STOPPED\nCheckpoint: -"
end

startBtn.MouseButton1Click:Connect(startAutoSummit)
stopBtn.MouseButton1Click:Connect(stopAutoSummit)
