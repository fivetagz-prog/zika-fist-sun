local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function playClick()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6042053626"
    sound.Volume = 0.5
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)
end

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Parent = parent
    return stroke
end

local function makeLabel(parent, props)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    for key, value in pairs(props) do
        label[key] = value
    end
    label.Parent = parent
    return label
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZikaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 290, 0, 420)
MainFrame.Position = UDim2.new(0.5, -145, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 9, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

addCorner(MainFrame, UDim.new(0, 14))
addStroke(MainFrame, Color3.fromRGB(110, 50, 210), 1.5)

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 54)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = MainFrame

addCorner(HeaderFrame, UDim.new(0, 14))

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 14)
HeaderFix.Position = UDim2.new(0, 0, 1, -14)
HeaderFix.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = HeaderFrame

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(150, 40, 230)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40,  80, 220)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,  210, 235)),
})
HeaderGradient.Rotation = 90
HeaderGradient.Parent = HeaderFrame

local gradientOffset = 0
RunService.Heartbeat:Connect(function(dt)
    gradientOffset = (gradientOffset + dt * 0.28) % 1
    local t = math.abs(math.sin(gradientOffset * math.pi))
    HeaderGradient.Rotation = 90 + t * 22
end)

makeLabel(HeaderFrame, {
    Size = UDim2.new(1, -60, 0, 28),
    Position = UDim2.new(0, 14, 0, 8),
    Text = "Zika Hub",
    TextColor3 = Color3.fromRGB(235, 225, 255),
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
})

makeLabel(HeaderFrame, {
    Size = UDim2.new(1, -60, 0, 16),
    Position = UDim2.new(0, 14, 0, 36),
    Text = "Esp idk",
    TextColor3 = Color3.fromRGB(170, 200, 255),
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local minimized = false
local fullHeight = 420

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -38, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 18, 58)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(200, 220, 255)
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = HeaderFrame

addCorner(MinBtn, UDim.new(0, 7))
addStroke(MinBtn, Color3.fromRGB(90, 60, 180), 1)

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, 0, 1, -54)
ContentFrame.Position = UDim2.new(0, 0, 0, 54)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 3
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 200)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MainFrame

MinBtn.MouseButton1Click:Connect(function()
    playClick()
    minimized = not minimized
    if minimized then
        MinBtn.Text = "="
        ContentFrame.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 290, 0, 54)
        }):Play()
    else
        MinBtn.Text = "-"
        ContentFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 290, 0, fullHeight)
        }):Play()
    end
end)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ContentFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 12)
UIPadding.PaddingRight = UDim.new(0, 12)
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.Parent = ContentFrame

local function makeRow()
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = Color3.fromRGB(22, 15, 40)
    row.BorderSizePixel = 0
    row.Parent = ContentFrame

    addCorner(row, UDim.new(0, 9))
    addStroke(row, Color3.fromRGB(55, 38, 95), 1)

    return row
end

local function makeToggle(labelText, callback)
    local enabled = false

    local Row = makeRow()

    makeLabel(Row, {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Text = labelText,
        TextColor3 = Color3.fromRGB(215, 205, 245),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local ToggleBG = Instance.new("Frame")
    ToggleBG.Size = UDim2.new(0, 44, 0, 24)
    ToggleBG.Position = UDim2.new(1, -54, 0.5, -12)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(45, 35, 75)
    ToggleBG.BorderSizePixel = 0
    ToggleBG.Parent = Row

    addCorner(ToggleBG, UDim.new(1, 0))

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(155, 135, 195)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleBG

    addCorner(Knob, UDim.new(1, 0))

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = Row

    Button.MouseButton1Click:Connect(function()
        playClick()
        enabled = not enabled
        local targetPos  = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local targetBG   = enabled and Color3.fromRGB(75, 55, 175) or Color3.fromRGB(45, 35, 75)
        local targetKnob = enabled and Color3.fromRGB(0, 205, 235) or Color3.fromRGB(155, 135, 195)
        TweenService:Create(Knob,     TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetKnob}):Play()
        TweenService:Create(ToggleBG, TweenInfo.new(0.2),                        {BackgroundColor3 = targetBG}):Play()
        if callback then callback(enabled) end
    end)

    return Row
end

local function makePartSelector(labelText, parts, callback)
    local selected = parts[1]

    local Row = makeRow()

    makeLabel(Row, {
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Text = labelText,
        TextColor3 = Color3.fromRGB(215, 205, 245),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local btns = {}
    for i, part in ipairs(parts) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 62, 0, 28)
        btn.Position = UDim2.new(0, 82 + (i - 1) * 68, 0.5, -14)
        btn.BackgroundColor3 = part == selected and Color3.fromRGB(75, 50, 170) or Color3.fromRGB(35, 25, 65)
        btn.BorderSizePixel = 0
        btn.Text = part
        btn.TextColor3 = Color3.fromRGB(210, 220, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.Parent = Row

        addCorner(btn, UDim.new(0, 6))
        addStroke(btn, Color3.fromRGB(80, 55, 160), 1)

        btns[part] = btn

        btn.MouseButton1Click:Connect(function()
            playClick()
            selected = part
            for p, b in pairs(btns) do
                TweenService:Create(b, TweenInfo.new(0.15), {
                    BackgroundColor3 = p == selected and Color3.fromRGB(75, 50, 170) or Color3.fromRGB(35, 25, 65)
                }):Play()
            end
            if callback then callback(selected) end
        end)
    end

    if callback then callback(selected) end
    return Row
end

local espEnabled = false
local espObjects = {}

local function isAnomalyPlayer(player)
    return player ~= LocalPlayer
        and player.Team ~= nil
        and player.Team.Name == "Anomalies"
end

local function healthColor(pct)
    if pct > 0.6 then
        return Color3.fromRGB(75, 215, 75)
    elseif pct > 0.3 then
        return Color3.fromRGB(225, 185, 40)
    else
        return Color3.fromRGB(225, 50, 50)
    end
end

local function getStuds(char)
    local myChar = LocalPlayer.Character
    if not myChar then return 0 end
    local myRoot    = myChar:FindFirstChild("HumanoidRootPart")
    local theirRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot or not theirRoot then return 0 end
    return math.floor((myRoot.Position - theirRoot.Position).Magnitude)
end

local function detachESP(player)
    local data = espObjects[player]
    if data then
        if data.healthConn  then data.healthConn:Disconnect()  end
        if data.studConn    then data.studConn:Disconnect()    end
        if data.diedConn    then data.diedConn:Disconnect()    end
        if data.container and data.container.Parent then
            data.container:Destroy()
        end
        espObjects[player] = nil
    end
end

local function attachESP(player)
    if not isAnomalyPlayer(player) then return end
    detachESP(player)

    local char = player.Character
    if not char then return end

    local humanoid  = char:FindFirstChildOfClass("Humanoid")
    local rootPart  = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
    if not rootPart or not humanoid then return end
    if humanoid.Health <= 0 then return end

    local container = Instance.new("Folder")
    container.Name = "ZikaESP"
    container.Parent = char

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 30, 30)
    highlight.OutlineColor = Color3.fromRGB(255, 30, 30)
    highlight.FillTransparency = 0.55
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = char
    highlight.Parent = container

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 160, 0, 72)
    bb.AlwaysOnTop = true
    bb.StudsOffsetWorldSpace = Vector3.new(0, 3.6, 0)
    bb.Adornee = rootPart
    bb.Parent = container

    makeLabel(bb, {
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 0),
        Text = "Anomaly",
        TextColor3 = Color3.fromRGB(255, 70, 70),
        TextStrokeTransparency = 0.2,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
    })

    local userStudsLbl = makeLabel(bb, {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 18),
        Text = player.Name .. " | Studs: 0",
        TextColor3 = Color3.fromRGB(190, 210, 255),
        TextStrokeTransparency = 0.2,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 11,
        Font = Enum.Font.Gotham,
    })

    local barBG = Instance.new("Frame")
    barBG.Size = UDim2.new(1, 0, 0, 10)
    barBG.Position = UDim2.new(0, 0, 0, 35)
    barBG.BackgroundColor3 = Color3.fromRGB(18, 10, 28)
    barBG.BorderSizePixel = 0
    barBG.Parent = bb

    addCorner(barBG, UDim.new(1, 0))
    addStroke(barBG, Color3.fromRGB(55, 38, 75), 1)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(1, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(75, 215, 75)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBG

    addCorner(barFill, UDim.new(1, 0))

    local barShine = Instance.new("Frame")
    barShine.Size = UDim2.new(1, 0, 0.45, 0)
    barShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    barShine.BackgroundTransparency = 0.78
    barShine.BorderSizePixel = 0
    barShine.ZIndex = 2
    barShine.Parent = barFill

    addCorner(barShine, UDim.new(1, 0))

    local hpLbl = makeLabel(bb, {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 48),
        TextColor3 = Color3.fromRGB(200, 200, 255),
        TextStrokeTransparency = 0.2,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
    })

    local lastPct = 1

    local function updateBar()
        if not humanoid or not humanoid.Parent then return end
        local maxHp = humanoid.MaxHealth
        local hp    = humanoid.Health
        local pct   = maxHp > 0 and math.clamp(hp / maxHp, 0, 1) or 0
        if math.abs(pct - lastPct) < 0.001 then return end
        lastPct = pct
        local col = healthColor(pct)
        TweenService:Create(barFill, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(pct, 0, 1, 0),
            BackgroundColor3 = col,
        }):Play()
        hpLbl.Text = "HP: " .. math.floor(hp) .. " / " .. math.floor(maxHp)
        hpLbl.TextColor3 = col
    end

    local healthConn = humanoid:GetPropertyChangedSignal("Health"):Connect(updateBar)
    updateBar()

    local studConn = RunService.Heartbeat:Connect(function()
        if not char or not char.Parent then return end
        userStudsLbl.Text = player.Name .. " | Studs: " .. getStuds(char)
    end)

    local diedConn
    diedConn = humanoid.Died:Connect(function()
        detachESP(player)
    end)

    espObjects[player] = {
        container  = container,
        healthConn = healthConn,
        studConn   = studConn,
        diedConn   = diedConn,
    }
end

local function clearAllESP()
    for player, _ in pairs(espObjects) do
        detachESP(player)
    end
end

local function hookPlayer(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.15)
        if espEnabled and isAnomalyPlayer(player) then
            attachESP(player)
        end
    end)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if espEnabled then
            if isAnomalyPlayer(player) then
                attachESP(player)
            else
                detachESP(player)
            end
        end
    end)
end

local function scanPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        hookPlayer(player)
        if isAnomalyPlayer(player) then
            attachESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    hookPlayer(player)
    if espEnabled and isAnomalyPlayer(player) then
        task.wait(0.15)
        attachESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    detachESP(player)
end)

local selectedTarget = nil
local aimPart = "Head"
local aimbotEnabled = false
local aimlockEnabled = false

makeToggle("Esp Cham", function(state)
    espEnabled = state
    if state then
        scanPlayers()
    else
        clearAllESP()
    end
end)

makePartSelector("Aim Part", {"Head", "Torso"}, function(part)
    aimPart = part
end)

makeToggle("Aimbot", function(state)
    aimbotEnabled = state
end)

makeToggle("Aimlock", function(state)
    aimlockEnabled = state
end)

RunService.RenderStepped:Connect(function()
    if (aimbotEnabled or aimlockEnabled) and selectedTarget and selectedTarget.Character then
        local targetChar = selectedTarget.Character
        local targetPart = targetChar:FindFirstChild(aimPart)
        local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
        
        if targetPart and humanoid and humanoid.Health > 0 then
            if aimlockEnabled then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            elseif aimbotEnabled then
                local targetRotation = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetRotation, 0.2)
            end
        end
    end
end)

local function buildTargetSelector()
    local listFrame = Instance.new("Frame")
    listFrame.Name = "TargetList"
    listFrame.Size = UDim2.new(1, 0, 0, 10)
    listFrame.AutomaticSize = Enum.AutomaticSize.Y
    listFrame.BackgroundTransparency = 1
    listFrame.BorderSizePixel = 0
    listFrame.Parent = ContentFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = listFrame

    local selectedRow = nil

    local function refreshList()
        for _, child in ipairs(listFrame:GetChildren()) do
            if not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end
        selectedRow = nil

        local anomalyPlayers = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if isAnomalyPlayer(player) then
                table.insert(anomalyPlayers, player)
            end
        end

        if #anomalyPlayers == 0 then
            makeLabel(listFrame, {
                Size = UDim2.new(1, 0, 0, 30),
                Text = "No Anomaly players found",
                TextColor3 = Color3.fromRGB(130, 130, 160),
                TextSize = 12,
                Font = Enum.Font.Gotham,
            })
            return
        end

        for _, player in ipairs(anomalyPlayers) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 56)
            row.BackgroundColor3 = Color3.fromRGB(20, 13, 36)
            row.BorderSizePixel = 0
            row.Parent = listFrame

            addCorner(row, UDim.new(0, 9))
            local rowStroke = addStroke(row, Color3.fromRGB(55, 38, 95), 1)

            local avatarImg = Instance.new("ImageLabel")
            avatarImg.Size = UDim2.new(0, 40, 0, 40)
            avatarImg.Position = UDim2.new(0, 8, 0.5, -20)
            avatarImg.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
            avatarImg.BorderSizePixel = 0
            avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=48&height=48&format=png"
            avatarImg.Parent = row

            addCorner(avatarImg, UDim.new(0, 6))

            makeLabel(row, {
                Size = UDim2.new(0, 110, 0, 18),
                Position = UDim2.new(0, 56, 0, 10),
                Text = player.Name,
                TextColor3 = Color3.fromRGB(215, 205, 245),
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
            })

            makeLabel(row, {
                Size = UDim2.new(0, 110, 0, 14),
                Position = UDim2.new(0, 56, 0, 30),
                Text = "ID: " .. player.UserId,
                TextColor3 = Color3.fromRGB(130, 145, 190),
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local selectBtn = Instance.new("TextButton")
            selectBtn.Size = UDim2.new(0, 52, 0, 26)
            selectBtn.Position = UDim2.new(1, -60, 0.5, -13)
            selectBtn.BackgroundColor3 = Color3.fromRGB(55, 38, 130)
            selectBtn.BorderSizePixel = 0
            selectBtn.Text = "Select"
            selectBtn.TextColor3 = Color3.fromRGB(200, 220, 255)
            selectBtn.TextSize = 11
            selectBtn.Font = Enum.Font.GothamBold
            selectBtn.Parent = row

            addCorner(selectBtn, UDim.new(0, 6))
            addStroke(selectBtn, Color3.fromRGB(90, 65, 200), 1)

            if selectedTarget == player then
                selectedRow = row
                row.BackgroundColor3 = Color3.fromRGB(35, 20, 65)
                rowStroke.Color = Color3.fromRGB(0, 195, 225)
                selectBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 180)
                selectBtn.Text = "Selected"
            end

            selectBtn.MouseButton1Click:Connect(function()
                playClick()
                selectedTarget = player

                if selectedRow and selectedRow ~= row then
                    TweenService:Create(selectedRow, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 13, 36)}):Play()
                    local prevStroke = selectedRow:FindFirstChildOfClass("UIStroke")
                    if prevStroke then prevStroke.Color = Color3.fromRGB(55, 38, 95) end
                    local prevBtn = selectedRow:FindFirstChildOfClass("TextButton")
                    if prevBtn then
                        prevBtn.Text = "Select"
                        TweenService:Create(prevBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 38, 130)}):Play()
                    end
                end

                selectedRow = row
                TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 20, 65)}):Play()
                rowStroke.Color = Color3.fromRGB(0, 195, 225)
                TweenService:Create(selectBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 140, 180)}):Play()
                selectBtn.Text = "Selected"
            end)

            row.MouseEnter:Connect(function()
                if row ~= selectedRow then
                    TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 18, 50)}):Play()
                end
            end)
            row.MouseLeave:Connect(function()
                if row ~= selectedRow then
                    TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(20, 13, 36)}):Play()
                end
            end)
        end
    end

    refreshList()

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, 0, 0, 32)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(28, 20, 52)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "Refresh List"
    refreshBtn.TextColor3 = Color3.fromRGB(160, 175, 220)
    refreshBtn.TextSize = 12
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = ContentFrame

    addCorner(refreshBtn, UDim.new(0, 8))
    addStroke(refreshBtn, Color3.fromRGB(60, 45, 110), 1)

    refreshBtn.MouseEnter:Connect(function()
        TweenService:Create(refreshBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(38, 28, 68)}):Play()
    end)
    refreshBtn.MouseLeave:Connect(function()
        TweenService:Create(refreshBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28, 20, 52)}):Play()
    end)
    refreshBtn.MouseButton1Click:Connect(function()
        playClick()
        refreshList()
    end)

    Players.PlayerAdded:Connect(function()
        task.defer(refreshList)
    end)
    Players.PlayerRemoving:Connect(function(player)
        if selectedTarget == player then selectedTarget = nil end
        task.defer(refreshList)
    end)
end

buildTargetSelector()
