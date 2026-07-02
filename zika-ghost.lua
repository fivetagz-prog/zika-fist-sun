local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local refreshTargetList

local function playClick()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6042053626"
    sound.Volume = 0.5
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)
end

local function isEnemyPlayer(player)
    if player == LocalPlayer then return false end
    if LocalPlayer.Team and player.Team then
        return player.Team ~= LocalPlayer.Team
    end
    return true
end

local function isAlive(player)
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
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

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(110, 50, 210)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 54)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = HeaderFrame

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

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 0, 28)
TitleLabel.Position = UDim2.new(0, 14, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Zika Hub"
TitleLabel.TextColor3 = Color3.fromRGB(235, 225, 255)
TitleLabel.TextSize = 19
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = HeaderFrame

local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(1, -60, 0, 16)
SubLabel.Position = UDim2.new(0, 14, 0, 36)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "Enemy Tracking Edition"
SubLabel.TextColor3 = Color3.fromRGB(170, 200, 255)
SubLabel.TextSize = 11
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = HeaderFrame

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

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 7)
MinBtnCorner.Parent = MinBtn

local MinBtnStroke = Instance.new("UIStroke")
MinBtnStroke.Color = Color3.fromRGB(90, 60, 180)
MinBtnStroke.Thickness = 1
MinBtnStroke.Parent = MinBtn

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

local function makeToggle(labelText, callback)
    local enabled = false

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 44)
    Row.BackgroundColor3 = Color3.fromRGB(22, 15, 40)
    Row.BorderSizePixel = 0
    Row.Parent = ContentFrame

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 9)
    RowCorner.Parent = Row

    local RowStroke = Instance.new("UIStroke")
    RowStroke.Color = Color3.fromRGB(55, 38, 95)
    RowStroke.Thickness = 1
    RowStroke.Parent = Row

    local RowLabel = Instance.new("TextLabel")
    RowLabel.Size = UDim2.new(1, -70, 1, 0)
    RowLabel.Position = UDim2.new(0, 12, 0, 0)
    RowLabel.BackgroundTransparency = 1
    RowLabel.Text = labelText
    RowLabel.TextColor3 = Color3.fromRGB(215, 205, 245)
    RowLabel.TextSize = 13
    RowLabel.Font = Enum.Font.Gotham
    RowLabel.TextXAlignment = Enum.TextXAlignment.Left
    RowLabel.Parent = Row

    local ToggleBG = Instance.new("Frame")
    ToggleBG.Size = UDim2.new(0, 44, 0, 24)
    ToggleBG.Position = UDim2.new(1, -54, 0.5, -12)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(45, 35, 75)
    ToggleBG.BorderSizePixel = 0
    ToggleBG.Parent = Row

    local ToggleBGCorner = Instance.new("UICorner")
    ToggleBGCorner.CornerRadius = UDim.new(1, 0)
    ToggleBGCorner.Parent = ToggleBG

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(155, 135, 195)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleBG

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

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

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 44)
    Row.BackgroundColor3 = Color3.fromRGB(22, 15, 40)
    Row.BorderSizePixel = 0
    Row.Parent = ContentFrame

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 9)
    RowCorner.Parent = Row

    local RowStroke = Instance.new("UIStroke")
    RowStroke.Color = Color3.fromRGB(55, 38, 95)
    RowStroke.Thickness = 1
    RowStroke.Parent = Row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 80, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(215, 205, 245)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Row

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

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(80, 55, 160)
        btnStroke.Thickness = 1
        btnStroke.Parent = btn

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
    if not isEnemyPlayer(player) then return end
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

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, 0, 0, 18)
    nameLbl.Position = UDim2.new(0, 0, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = "Enemy"
    nameLbl.TextColor3 = Color3.fromRGB(255, 70, 70)
    nameLbl.TextStrokeTransparency = 0.2
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Parent = bb

    local userStudsLbl = Instance.new("TextLabel")
    userStudsLbl.Size = UDim2.new(1, 0, 0, 14)
    userStudsLbl.Position = UDim2.new(0, 0, 0, 18)
    userStudsLbl.BackgroundTransparency = 1
    userStudsLbl.Text = player.Name .. " | Studs: 0"
    userStudsLbl.TextColor3 = Color3.fromRGB(190, 210, 255)
    userStudsLbl.TextStrokeTransparency = 0.2
    userStudsLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    userStudsLbl.TextSize = 11
    userStudsLbl.Font = Enum.Font.Gotham
    userStudsLbl.Parent = bb

    local barBG = Instance.new("Frame")
    barBG.Size = UDim2.new(1, 0, 0, 10)
    barBG.Position = UDim2.new(0, 0, 0, 35)
    barBG.BackgroundColor3 = Color3.fromRGB(18, 10, 28)
    barBG.BorderSizePixel = 0
    barBG.Parent = bb

    local barBGCorner = Instance.new("UICorner")
    barBGCorner.CornerRadius = UDim.new(1, 0)
    barBGCorner.Parent = barBG

    local barBGStroke = Instance.new("UIStroke")
    barBGStroke.Color = Color3.fromRGB(55, 38, 75)
    barBGStroke.Thickness = 1
    barBGStroke.Parent = barBG

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(1, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(75, 215, 75)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBG

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill

    local barShine = Instance.new("Frame")
    barShine.Size = UDim2.new(1, 0, 0.45, 0)
    barShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    barShine.BackgroundTransparency = 0.78
    barShine.BorderSizePixel = 0
    barShine.ZIndex = 2
    barShine.Parent = barFill

    local barShineCorner = Instance.new("UICorner")
    barShineCorner.CornerRadius = UDim.new(1, 0)
    barShineCorner.Parent = barShine

    local hpLbl = Instance.new("TextLabel")
    hpLbl.Size = UDim2.new(1, 0, 0, 14)
    hpLbl.Position = UDim2.new(0, 0, 0, 48)
    hpLbl.BackgroundTransparency = 1
    hpLbl.TextColor3 = Color3.fromRGB(200, 200, 255)
    hpLbl.TextStrokeTransparency = 0.2
    hpLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hpLbl.TextSize = 11
    hpLbl.Font = Enum.Font.GothamBold
    hpLbl.Text = "HP: ..."
    hpLbl.Parent = bb

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
        if espEnabled and isEnemyPlayer(player) then
            attachESP(player)
        end
        if refreshTargetList then refreshTargetList() end
    end)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if espEnabled then
            if isEnemyPlayer(player) then
                attachESP(player)
            else
                detachESP(player)
            end
        end
        if refreshTargetList then refreshTargetList() end
    end)
end

local function scanPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        hookPlayer(player)
        if isEnemyPlayer(player) then
            attachESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    hookPlayer(player)
    if espEnabled and isEnemyPlayer(player) then
        task.wait(0.15)
        attachESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    detachESP(player)
end)

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    clearAllESP()
    if espEnabled then scanPlayers() end
    if refreshTargetList then refreshTargetList() end
end)

local selectedTarget = nil
local aimPart = "Head"
local aimbotEnabled = false

makeToggle("Esp Cham", function(state)
    espEnabled = state
    if state then
        scanPlayers()
    else
        clearAllESP()
    end
end)

makeToggle("Aimbot Lock", function(state)
    aimbotEnabled = state
end)

makePartSelector("Aim Part", {"Head", "Torso"}, function(part)
    aimPart = part
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

        local enemyPlayers = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if isEnemyPlayer(player) then
                table.insert(enemyPlayers, player)
            end
        end

        if #enemyPlayers == 0 then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 30)
            lbl.BackgroundTransparency = 1
            lbl.Text = "No Enemy players found"
            lbl.TextColor3 = Color3.fromRGB(130, 130, 160)
            lbl.TextSize = 12
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = listFrame
            return
        end

        for _, player in ipairs(enemyPlayers) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 56)
            row.BackgroundColor3 = Color3.fromRGB(20, 13, 36)
            row.BorderSizePixel = 0
            row.Parent = listFrame

            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 9)
            rowCorner.Parent = row

            local rowStroke = Instance.new("UIStroke")
            rowStroke.Color = Color3.fromRGB(55, 38, 95)
            rowStroke.Thickness = 1
            rowStroke.Parent = row

            local avatarImg = Instance.new("ImageLabel")
            avatarImg.Size = UDim2.new(0, 40, 0, 40)
            avatarImg.Position = UDim2.new(0, 8, 0.5, -20)
            avatarImg.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
            avatarImg.BorderSizePixel = 0
            avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=48&height=48&format=png"
            avatarImg.Parent = row

            local avatarCorner = Instance.new("UICorner")
            avatarCorner.CornerRadius = UDim.new(0, 6)
            avatarCorner.Parent = avatarImg

            local usernameLbl = Instance.new("TextLabel")
            usernameLbl.Size = UDim2.new(0, 110, 0, 18)
            usernameLbl.Position = UDim2.new(0, 56, 0, 10)
            usernameLbl.BackgroundTransparency = 1
            usernameLbl.Text = player.Name
            usernameLbl.TextColor3 = Color3.fromRGB(215, 205, 245)
            usernameLbl.TextSize = 13
            usernameLbl.Font = Enum.Font.GothamBold
            usernameLbl.TextXAlignment = Enum.TextXAlignment.Left
            usernameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            usernameLbl.Parent = row

            local idLbl = Instance.new("TextLabel")
            idLbl.Size = UDim2.new(0, 110, 0, 14)
            idLbl.Position = UDim2.new(0, 56, 0, 30)
            idLbl.BackgroundTransparency = 1
            idLbl.Text = "ID: " .. player.UserId
            idLbl.TextColor3 = Color3.fromRGB(130, 145, 190)
            idLbl.TextSize = 11
            idLbl.Font = Enum.Font.Gotham
            idLbl.TextXAlignment = Enum.TextXAlignment.Left
            idLbl.Parent = row

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

            local selectCorner = Instance.new("UICorner")
            selectCorner.CornerRadius = UDim.new(0, 6)
            selectCorner.Parent = selectBtn

            local selectStroke = Instance.new("UIStroke")
            selectStroke.Color = Color3.fromRGB(90, 65, 200)
            selectStroke.Thickness = 1
            selectStroke.Parent = selectBtn

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
    refreshTargetList = refreshList

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, 0, 0, 32)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(28, 20, 52)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "Refresh List"
    refreshBtn.TextColor3 = Color3.fromRGB(160, 175, 220)
    refreshBtn.TextSize = 12
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = ContentFrame

    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshBtn

    local refreshStroke = Instance.new("UIStroke")
    refreshStroke.Color = Color3.fromRGB(60, 45, 110)
    refreshStroke.Thickness = 1
    refreshStroke.Parent = refreshBtn

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

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and selectedTarget and isEnemyPlayer(selectedTarget) and isAlive(selectedTarget) then
        local char = selectedTarget.Character
        if char then
            local targetPartName = aimPart
            if targetPartName == "Torso" then
                if char:FindFirstChild("UpperTorso") then
                    targetPartName = "UpperTorso"
                elseif not char:FindFirstChild("Torso") and char:FindFirstChild("HumanoidRootPart") then
                    targetPartName = "HumanoidRootPart"
                end
            end
            local targetPart = char:FindFirstChild(targetPartName)
            if targetPart then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end
    elseif selectedTarget and (not isEnemyPlayer(selectedTarget) or not isAlive(selectedTarget)) then
        selectedTarget = nil
        if refreshTargetList then refreshTargetList() end
    end
end)
