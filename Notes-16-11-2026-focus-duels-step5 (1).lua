loadstring([=[
local __HH = {}
local LP = LP
local Lighting = Lighting
local Players = Players
local RunService = RunService
local SKY_PRESETS = SKY_PRESETS
local TS = TS
local loadConfig = loadConfig
local uiScaleValue = uiScaleValue
do

-- ============================================================
-- RED CIRCLE — always ON. No toggle, no button, no config.
-- Flat red disc on the ground right under the player, exactly
-- like Horizon Hub's red circle. Follows the ground everywhere and
-- keeps working across respawns automatically.
-- ============================================================
do
    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
        local plrs = game:GetService("Players")
        local run  = game:GetService("RunService")
        local lplr = plrs.LocalPlayer
        local c = Instance.new("Part")
        c.Name = "HorizonHubBlueHitRange"
        c.Shape = Enum.PartType.Cylinder
        c.Size = Vector3.new(12, 0.1, 12)
        c.Anchored = true
        c.CanCollide = false
        c.CanQuery = false
        c.CanTouch = false
        c.CastShadow = false
        c.Material = Enum.Material.SmoothPlastic
        c.Color = Color3.fromRGB(25, 80, 200)
        c.Transparency = 0.4
        c.Parent = workspace
        print("[horizonhub] BLUE HIT RANGE CREATED ✓")
        run.Heartbeat:Connect(function()
            pcall(function()
                if not (c and c.Parent) then return end
                local char = lplr.Character
                if not char then c.Visible = false; return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then c.Visible = false; return end
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {char, c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local res = workspace:Raycast(hrp.Position, Vector3.new(0, -2000, 0), rp)
                if res then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local gy = res.Position.Y + 0.06
                    if hum then
                        -- hard clamp: the circle never rises into the player
                        gy = math.min(gy, hrp.Position.Y - hum.HipHeight - 0.05)
                    end
                    c.Visible = true
                    c.CFrame = CFrame.new(res.Position.X, gy, res.Position.Z)
                else
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.FloorMaterial ~= Enum.Material.Air then
                        c.Visible = true
                        c.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - hum.HipHeight - 0.1, hrp.Position.Z)
                    else
                        c.Visible = false
                    end
                end
            end)
        end)
    end)
end

task.spawn(function() pcall(function()
repeat task.wait() until game:IsLoaded()
local TweenService      = game:GetService("TweenService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Stats             = game:GetService("Stats")
local SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Tech","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
local SKY_PRESETS = {
    Off={kind="off"},
    Night={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140}},
    Aurora={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150}},
    Sunset={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110}},
    Galaxy={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110}},
    Tech={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180}},
    Sakura={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150}},
    Volcanic={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50}},
    Arctic={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140}},
    Vaporwave={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210}},
    Toxic={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70}},
    Hellscape={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40}},
    Heaven={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220}},
    Storm={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120}},
    Sunrise={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230}},
    Inferno={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220}}
}
local function _vC3(t) return Color3.fromRGB(t[1],t[2],t[3]) end
local function _v4mpClearSky()
    for _,v in ipairs(game:GetService("Lighting"):GetChildren()) do if v:GetAttribute("_AceDuelsSky") then pcall(function() v:Destroy() end) end end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,v in ipairs(terrain:GetChildren()) do if v:GetAttribute("_AceDuelsSky") then pcall(function() v:Destroy() end) end end end
end
local function applyCustomSky(mode)
    _v4mpClearSky()
    local p = SKY_PRESETS[mode]
    local Lighting = game:GetService("Lighting")
    if not p or p.kind=="off" then 
        Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.GlobalShadows=true; 
        __HH.currentSkyTheme="Off"; return 
    end
    Lighting.ClockTime=p.clock or 14; Lighting.Brightness=p.brightness or 2; 
    if p.ambient then Lighting.Ambient=_vC3(p.ambient) end; 
    if p.outAmb then Lighting.OutdoorAmbient=_vC3(p.outAmb) end
    local atm=Instance.new("Atmosphere"); atm:SetAttribute("_AceDuelsSky",true); atm.Density=0.35; atm.Color=Lighting.Ambient; atm.Decay=Lighting.OutdoorAmbient; atm.Parent=Lighting
    local sky=Instance.new("Sky"); sky:SetAttribute("_AceDuelsSky",true); sky.StarCount=(mode=="Galaxy" or mode=="Deep Space") and 10000 or 2000; sky.Parent=Lighting
    __HH.currentSkyTheme=mode
end
end) end)

-- insta steal
task.spawn(function() pcall(function()
repeat task.wait() until game:IsLoaded()
local TweenService      = game:GetService("TweenService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats             = game:GetService("Stats")
local LP = Players.LocalPlayer
if _G.InstaStealConn then
    pcall(function() _G.InstaStealConn:Disconnect() end)
    _G.InstaStealConn = nil
end
if _G.FRHUBNormalSteal and _G.FRHUBNormalSteal.stealConn then
    pcall(function() _G.FRHUBNormalSteal.stealConn:Disconnect() end)
end
if _G.FRHUBSemiSteal and _G.FRHUBSemiSteal.conn then
    pcall(function() _G.FRHUBSemiSteal.conn:Disconnect() end)
end
pcall(function()
    local old = CoreGui:FindFirstChild("InstaSteal_Standalone")
    if old then old:Destroy() end
end)
local CONFIG_PATH = "FR Hub/wallahi_config.json"
local Radii = {Normal = 60, Semi = 9, SemiV2 = 51, SemiV3 = 60}
local selectedMode   = "SemiV3"
local isEnabled      = true
local uiScaleValue   = 100
local mainUIScale    = nil
local function saveConfig()
    pcall(function()
        local data = {
            normalRadius = Radii.Normal,
            semiRadius   = Radii.Semi,
            semiV2Radius = Radii.SemiV2,
            semiV3Radius = Radii.SemiV3,
            mode         = selectedMode,
            enabled      = isEnabled,
            uiScale      = uiScaleValue,
        }
        writefile(CONFIG_PATH, game:GetService("HttpService"):JSONEncode(data))
    end)
end
local function loadConfig()
    pcall(function()
        if not isfile(CONFIG_PATH) then return end
        local raw = readfile(CONFIG_PATH)
        local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
        if not ok or type(data) ~= "table" then return end
        if type(data.normalRadius) == "number" then Radii.Normal = data.normalRadius end
        if type(data.semiRadius)   == "number" then Radii.Semi   = data.semiRadius   end
        if type(data.semiV2Radius) == "number" then Radii.SemiV2 = data.semiV2Radius end
        if type(data.semiV3Radius) == "number" then Radii.SemiV3 = data.semiV3Radius end
        -- Only the SemiV3 engine is implemented in this script.
        -- Old configs that saved mode "Normal"/"Semi"/"SemiV2" were silently
        -- disabling the auto steal entirely, so always force SemiV3.
        selectedMode = "SemiV3"
        if type(data.enabled) == "boolean" then isEnabled = data.enabled end
        if type(data.uiScale) == "number"  then uiScaleValue = math.clamp(math.floor(data.uiScale + 0.5), 50, 200) end
    end)
end
loadConfig()
local ProgressBarFill = nil
local ProgressPercentLabel = nil
local grabPercentageLabel = nil
local _currentStealProgress = 0
_G.HorizonHubIntroFinished = false
local function setProgress(val, labelText)
    _currentStealProgress = math.clamp(val, 0, 1)
    if _G.StealBar then
        _G.StealBar.SetState("STEALING")
        _G.StealBar.SetProgress(_currentStealProgress, labelText)
    end
    if ProgressBarFill then
        TweenService:Create(ProgressBarFill, TweenInfo.new(0.05), {
            Size = UDim2.new(_currentStealProgress, 0, 1, 0)
        }):Play()
    end
    if ProgressPercentLabel then
        ProgressPercentLabel.Text = math.floor(_currentStealProgress * 100 + 0.5) .. "%"
    end
    if grabPercentageLabel then
        if type(labelText) == "string" and labelText ~= "" then
            grabPercentageLabel.Text = string.upper(labelText)
        elseif _currentStealProgress > 0 then
            grabPercentageLabel.Text = "STEALING  " .. math.floor(_currentStealProgress * 100 + 0.5) .. "%"
        else
            grabPercentageLabel.Text = "GRAB PERCENTAGE"
        end
    end
end

-- Sound Hub progress HUD — UI only.
-- The steal/auto-grab engines are untouched; this keeps the same _G.StealBar
-- interface already used by Sound's existing setProgress function.
_G.loadSoundCustomAsset = function(fileName, url, fallbackId)
    local assetUrl = fallbackId or ""
    pcall(function()
        local gca = getcustomasset or getsynasset
        if not (gca and writefile) then return end
        if not (isfile and isfile(fileName)) then
            local raw = game:HttpGet(url)
            if type(raw) == "string" and #raw > 100 then
                writefile(fileName, raw)
            end
        end
        if isfile and isfile(fileName) then
            assetUrl = gca(fileName)
        end
    end)
    return assetUrl
end

local function setupNexusGrabBar()
    _G.setupNexusGrabBar = setupNexusGrabBar
    local pg = LP:WaitForChild("PlayerGui")
    local cg = game:GetService("CoreGui")
    local old = pg:FindFirstChild("StealBarGui")
    if old then old:Destroy() end
    local oldc = cg:FindFirstChild("StealBarGui")
    if oldc then oldc:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StealBarGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 200
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Enabled = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = cg end) then gui.Parent = pg end

    local savedPos
    pcall(function()
        if isfile and isfile("horizon_steal_bar_pos.json") then
            savedPos = game:GetService("HttpService"):JSONDecode(readfile("horizon_steal_bar_pos.json"))
        end
    end)
    local defaultPos = UDim2.new(0.5, 0, 1, -14)
    -- Always start centered at the bottom (saved drag position ignored on launch).
    local savedUDim = defaultPos

    local BAR_BG      = Color3.fromRGB(4, 8, 20)
    local BLUE_STROKE = Color3.fromRGB(40, 110, 230)
    local BLUE_ACTIVE = Color3.fromRGB(30, 100, 240)
    local BLUE_OFF    = Color3.fromRGB(12, 22, 54)
    local CYAN_READY  = Color3.fromRGB(70, 150, 255)
    local TEXT_BRIGHT = Color3.fromRGB(238, 245, 255)
    local TEXT_DIM    = Color3.fromRGB(176, 200, 240)

    local shadow = Instance.new("Frame", gui)
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(0, 444, 0, 58)
    shadow.Position = UDim2.new(savedUDim.X.Scale, savedUDim.X.Offset, savedUDim.Y.Scale, savedUDim.Y.Offset + 3)
    shadow.AnchorPoint = Vector2.new(0.5, 1)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.38
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 299
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 60)

    local card = Instance.new("Frame", gui)
    card.Name = "StealProgressGui"
    -- Keep the bottom progress banner at its original, unscaled dimensions.
    card.Size = UDim2.new(0, 440, 0, 54)
    local bannerScale = Instance.new("UIScale")
    bannerScale.Scale = 1
    bannerScale.Parent = card
    card.Position = savedUDim
    card.AnchorPoint = Vector2.new(0.5, 1)
    card.BackgroundColor3 = BAR_BG
    card.BackgroundTransparency = 0.04
    card.BorderSizePixel = 0
    card.Active = true
    card.Visible = true
    card.ClipsDescendants = true
    card.ZIndex = 300
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 60)

    local border = Instance.new("UIStroke", card)
    border.Color = BLUE_STROKE
    border.Thickness = 1.3
    border.Transparency = 0.22

    local cardGradient = Instance.new("UIGradient", card)
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 8, 20)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(9, 15, 36)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 8, 20))
    })
    cardGradient.Rotation = 0

    local textFrame = Instance.new("Frame", card)
    textFrame.Size = UDim2.new(1, 0, 1, 0)
    textFrame.BackgroundTransparency = 1
    textFrame.ZIndex = 301

    -- LEFT: "STEAL" label (padding 28 from left for pill curve)
    local stealLabel = Instance.new("TextLabel", textFrame)
    stealLabel.Size = UDim2.new(0, 110, 1, 0)
    stealLabel.Position = UDim2.new(0, 34, 0, 0)
    stealLabel.BackgroundTransparency = 1
    stealLabel.Text = "STEAL"
    stealLabel.TextColor3 = TEXT_BRIGHT
    stealLabel.Font = Enum.Font.GothamBlack
    stealLabel.TextSize = 16
    stealLabel.TextXAlignment = Enum.TextXAlignment.Left
    stealLabel.ZIndex = 302

    -- CENTER: percentage
    local pctLbl = Instance.new("TextLabel", textFrame)
    pctLbl.Size = UDim2.new(0, 90, 1, 0)
    pctLbl.Position = UDim2.new(0.5, -45, 0, 0)
    pctLbl.BackgroundTransparency = 1
    pctLbl.Text = ""
    pctLbl.TextColor3 = TEXT_BRIGHT
    pctLbl.Font = Enum.Font.GothamBold
    pctLbl.TextSize = 16
    pctLbl.TextXAlignment = Enum.TextXAlignment.Center
    pctLbl.ZIndex = 302

    -- RIGHT: FPS | PING (padding 28 from right for pill curve)
    local fpsLabel = Instance.new("TextLabel", textFrame)
    fpsLabel.Size = UDim2.new(0, 190, 1, 0)
    fpsLabel.Position = UDim2.new(1, -224, 0, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS:60 | PING:11ms"
    fpsLabel.TextColor3 = TEXT_DIM
    fpsLabel.Font = Enum.Font.GothamMedium
    fpsLabel.TextSize = 14
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
    fpsLabel.ZIndex = 302

    -- dummy ping label (kept for logic compat)
    local pingLabel = Instance.new("TextLabel", textFrame)
    pingLabel.Size = UDim2.new(0, 0, 0, 0)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = ""
    pingLabel.ZIndex = 1
    pingLabel.Visible = false

    -- dummy activePill kept for SetState compat (invisible)
    local activePill = Instance.new("Frame", textFrame)
    activePill.Name = "ActiveBadge"
    activePill.Size = UDim2.new(0, 0, 0, 0)
    activePill.BackgroundTransparency = 1
    activePill.BorderSizePixel = 0
    activePill.ZIndex = 1
    activePill.Visible = false

    -- Full-card background fill (replaces thin bottom bar)
    local fillLine = Instance.new("Frame", card)
    fillLine.Name = "ProgressFill"
    fillLine.Size = UDim2.new(0, 0, 1, 0)
    fillLine.Position = UDim2.new(0, 0, 0, 0)
    fillLine.AnchorPoint = Vector2.new(0, 0)
    fillLine.BackgroundColor3 = Color3.fromRGB(20, 70, 190)
    fillLine.BackgroundTransparency = 0.18
    fillLine.BorderSizePixel = 0
    fillLine.ZIndex = 299
    local fillCorner = Instance.new("UICorner", fillLine)
    fillCorner.CornerRadius = UDim.new(0, 60)
    local fillGrad = Instance.new("UIGradient", fillLine)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 130, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 70, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 20, 100))
    })
    fillGrad.Rotation = 0


    -- ===== SHINY STEAL BAR (UI only): moving border shine + light sweep =====
    do
        local RS_ = game:GetService("RunService")
        local TS_ = game:GetService("TweenService")
        local borderGrad = Instance.new("UIGradient", border)
        borderGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110, 140, 235)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(110, 140, 235)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(110, 140, 235))
        })
        border.Thickness = 2
        border.Transparency = 0.05
        border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local glow = Instance.new("UIStroke", card)
        glow.Name = "ShineGlow"
        glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        glow.Color = BLUE_STROKE
        glow.Thickness = 6
        glow.Transparency = 0.82

        local sweep = Instance.new("Frame", card)
        sweep.Name = "ShineSweep"
        sweep.AnchorPoint = Vector2.new(0.5, 0.5)
        sweep.Size = UDim2.new(0, 70, 2.4, 0)
        sweep.Position = UDim2.new(-0.2, 0, 0.5, 0)
        sweep.Rotation = 20
        sweep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sweep.BorderSizePixel = 0
        sweep.Active = false
        sweep.ZIndex = 303
        local sg = Instance.new("UIGradient", sweep)
        sg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.0, 1),
            NumberSequenceKeypoint.new(0.5, 0.82),
            NumberSequenceKeypoint.new(1.0, 1)
        })

        task.spawn(function()
            while card.Parent do
                sweep.Position = UDim2.new(-0.2, 0, 0.5, 0)
                local tw = TS_:Create(sweep, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Position = UDim2.new(1.2, 0, 0.5, 0)})
                tw:Play()
                tw.Completed:Wait()
                task.wait(2.4)
            end
        end)

        local c2
        c2 = RS_.Heartbeat:Connect(function(dt)
            if not card.Parent then c2:Disconnect() return end
            borderGrad.Rotation = (borderGrad.Rotation + dt * 90) % 360
        end)
    end

    local dragLayer = Instance.new("TextButton", card)
    dragLayer.Name = "DragLayer"
    dragLayer.Size = UDim2.new(1, 0, 1, 0)
    dragLayer.BackgroundTransparency = 1
    dragLayer.Text = ""
    dragLayer.AutoButtonColor = false
    dragLayer.ZIndex = 310

    local dragging, dragStart, startPos = false, nil, nil
    dragLayer.InputBegan:Connect(function(input)
        if _G.YousefUiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = card.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and not _G.YousefUiLocked
            and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            card.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            shadow.Position = UDim2.new(card.Position.X.Scale, card.Position.X.Offset, card.Position.Y.Scale, card.Position.Y.Offset + 3)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not _G.YousefUiLocked then
                pcall(function()
                    writefile("horizon_steal_bar_pos.json", game:GetService("HttpService"):JSONEncode({
                        xs = card.Position.X.Scale, xo = card.Position.X.Offset,
                        ys = card.Position.Y.Scale, yo = card.Position.Y.Offset
                    }))
                end)
            end
        end
    end)

    card:GetPropertyChangedSignal("Position"):Connect(function()
        shadow.Position = UDim2.new(card.Position.X.Scale, card.Position.X.Offset, card.Position.Y.Scale, card.Position.Y.Offset + 3)
    end)

    task.spawn(function()
        local frameTimes = {}
        local totalFrameTime = 0
        local lastUiUpdate = 0
        local renderConn

        renderConn = RunService.RenderStepped:Connect(function(deltaTime)
            if not card.Parent then
                if renderConn then renderConn:Disconnect() end
                return
            end

            if type(deltaTime) == "number" and deltaTime > 0 and deltaTime < 1 then
                frameTimes[#frameTimes + 1] = deltaTime
                totalFrameTime = totalFrameTime + deltaTime
                while totalFrameTime > 0.5 and #frameTimes > 2 do
                    totalFrameTime = totalFrameTime - table.remove(frameTimes, 1)
                end
            end

            local now = os.clock()
            if now - lastUiUpdate < 0.15 then return end
            lastUiUpdate = now

            local fps = 60
            if totalFrameTime > 0 and #frameTimes > 0 then
                fps = math.floor(#frameTimes / totalFrameTime + 0.5)
            end

            local pingMs
            pcall(function()
                local network = Stats and Stats:FindFirstChild("Network")
                local serverStats = network and network:FindFirstChild("ServerStatsItem")
                local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
                if dataPing then pingMs = tonumber(dataPing:GetValue()) end
            end)
            if not pingMs then
                pcall(function() pingMs = LP:GetNetworkPing() * 1000 end)
            end
            pingMs = math.floor((tonumber(pingMs) or 11) + 0.5)

            fpsLabel.Text = string.format("FPS:%d | PING:%dms", fps, pingMs)
        end)
    end)

    task.spawn(function()
        while gui.Parent do
            if _G.HorizonHubIntroFinished then
                gui.Enabled = true
                card.Visible = true
                shadow.Visible = true
            end
            task.wait(0.05)
        end
    end)

    _G.StealBar = {
        SetProgress = function(value, labelText)
            local v = math.clamp(tonumber(value) or 0, 0, 1)
            if _G.HorizonHubIntroFinished then gui.Enabled = true end
            card.Visible = true
            shadow.Visible = true
            TweenService:Create(fillLine, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(v, 0, 1, 0)
            }):Play()
            if v > 0 then
                pctLbl.Text = math.floor(v * 100 + 0.5) .. "%"
                stealLabel.Text = "STEAL"
            else
                pctLbl.Text = ""
            end
        end,
        SetState = function(text)
            if type(text) ~= "string" or text == "" then return end
            local state = string.upper(text)
            if state == "STEALING" or state == "OP HOLD" then
                stealLabel.Text = "ACTIVE"
                stealLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                activePill.BackgroundColor3 = BLUE_ACTIVE
                border.Color = Color3.fromRGB(70, 150, 255)
            elseif state == "READY" then
                stealLabel.Text = "ACTIVE"
                stealLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                activePill.BackgroundColor3 = BLUE_ACTIVE
                border.Color = BLUE_STROKE
            elseif state == "OFF" then
                stealLabel.Text = "OFF"
                stealLabel.TextColor3 = Color3.fromRGB(160, 190, 235)
                activePill.BackgroundColor3 = BLUE_OFF
                border.Color = Color3.fromRGB(25, 55, 120)
            end
        end,
        Reset = function()
            fillLine.Size = UDim2.new(0, 0, 1, 0)
            pctLbl.Text = ""
            stealLabel.Text = "ACTIVE"
            stealLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            activePill.BackgroundColor3 = BLUE_ACTIVE
            border.Color = BLUE_STROKE
        end
    }
    _G.StealBar.Reset()
end
_G.setupNexusGrabBar = setupNexusGrabBar
task.delay(0.15, setupNexusGrabBar)

task.spawn(function()
    local lastFrame = tick()
    local fpsSamples = {}
    local fpsAvg = 60
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - lastFrame
        lastFrame = now
        if dt > 0 then
            table.insert(fpsSamples, 1 / dt)
            if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
            local sum = 0
            for _, v in ipairs(fpsSamples) do sum = sum + v end
            fpsAvg = sum / #fpsSamples
        end
    end)
    while true do
        task.wait(0.5)
        pcall(function()
            if ProgressPercentLabel and ProgressPercentLabel.Parent then
                local ping = 0
                if LP and LP.GetNetworkPing then
                    ping = math.floor(LP:GetNetworkPing() * 1000 + 0.5)
                else
                    local stat = Stats.Network.ServerStatsItem["Data Ping"]
                    if stat then ping = math.floor(tonumber(stat:GetValue()) or 0) end
                end
                local pctStr = tostring(math.floor(_currentStealProgress * 100 + 0.5)) .. "%"
                ProgressPercentLabel.Text = string.format("%s | FPS:%d | PING:%dms", pctStr, math.floor(fpsAvg + 0.5), ping)
            end
        end)
    end
end)

local function getHRP()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
end
local function isMyBase(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end




local SemiV3State = {
    conn = nil, isStealing = false, stealStartTime = nil, Data = {},
    HalfFireRange = 10, HalfHoldMin = 1.3, HalfHoldMax = 2.6, HalfEntryDelay = 0.3,
    lastScan = 0, lastFallbackScan = 0, lastFallbackResult = nil,
}
local function sv3PromptDist(prompt)
    local char = LP.Character
    if not char then return math.huge end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return math.huge end
    local part = prompt.Parent
    if part and part:IsA("Attachment") then part = part.Parent end
    while part and not part:IsA("BasePart") and part ~= workspace and part.Parent ~= nil do
        part = part.Parent
    end
    if part and part:IsA("BasePart") then return (part.Position - root.Position).Magnitude end
    local ok, cf = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and cf then return (cf - root.Position).Magnitude end
    return math.huge
end
local function sv3IsStealPrompt(pr)
    if not (pr and pr:IsA("ProximityPrompt")) then return false end
    local a = (pr.ActionText or ""):lower()
    return a:find("steal") ~= nil or a:find("grab") ~= nil or a:find("snatch") ~= nil
end
local function sv3FindNearestPrompt()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyBase(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local sp = base and base:FindFirstChild("Spawn")
                    if sp then
                        local d = (sp.Position - root.Position).Magnitude
                        if d <= Radii.SemiV3 and d < dist then
                            local found = nil
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, pr in ipairs(att:GetChildren()) do
                                    if sv3IsStealPrompt(pr) then found = pr end
                                end
                            end
                            if not found then
                                for _, pr in ipairs(sp:GetDescendants()) do
                                    if sv3IsStealPrompt(pr) then found = pr end
                                end
                            end
                            if found then nearest, dist = found, d end
                        end
                    end
                end
            end
        end
    end
    return nearest
end
-- Generic fallback scan: if the AnimalPodiums/Spawn structure above was not
-- found (different map / game update), search every ProximityPrompt on enemy
-- plots that looks like a steal prompt. Throttled by the caller.
local function sv3FindNearestPromptFallback()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyBase(plot.Name) then
            for _, pr in ipairs(plot:GetDescendants()) do
                if pr:IsA("ProximityPrompt") then
                    local a = (pr.ActionText or ""):lower()
                    if a:find("steal") or a:find("grab") then
                        local d = sv3PromptDist(pr)
                        if d <= Radii.SemiV3 and d < dist then
                            nearest, dist = pr, d
                        end
                    end
                end
            end
        end
    end
    return nearest
end
local function sv3CaptureConnections(prompt, data)
    if not getconnections then return end
    pcall(function()
        for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
            if c.Function then table.insert(data.hold, c.Function) end
        end
        for _, c in ipairs(getconnections(prompt.Triggered)) do
            if c.Function then table.insert(data.trigger, c.Function) end
        end
    end)
end
local function sv3FireHold(data)
    for _, fn in ipairs(data.hold) do task.spawn(fn) end
end
local function sv3FireTrigger(prompt, data)
    if #data.trigger > 0 then
        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
        return
    end
    -- No captured handlers (executor without getconnections, or the game
    -- connected later). Simulate the prompt directly instead of doing nothing.
    if fireproximityprompt then
        pcall(function() fireproximityprompt(prompt) end)
        return
    end
    pcall(function() prompt:InputHoldBegin() end)
    task.wait(0.3)
    pcall(function() prompt:InputHoldEnd() end)
end
local function sv3ExecuteSteal(prompt)
    if SemiV3State.isStealing then return end
    if not SemiV3State.Data[prompt] then
        SemiV3State.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        sv3CaptureConnections(prompt, SemiV3State.Data[prompt])
    end
    local data = SemiV3State.Data[prompt]
    if not data.ready then return end
    data.ready = false
    SemiV3State.isStealing = true
    SemiV3State.stealStartTime = tick()
    task.spawn(function()
        local fired = false
        local ok, err = pcall(function()
            sv3FireHold(data)
            task.wait(SemiV3State.HalfHoldMin)
            local lastWasInRange = sv3PromptDist(prompt) <= SemiV3State.HalfFireRange
            while true do
                local el = tick() - SemiV3State.stealStartTime
                if el > SemiV3State.HalfHoldMax or not prompt.Parent then break end
                setProgress(math.clamp(el / SemiV3State.HalfHoldMax, 0, 1))
                local nowInRange = sv3PromptDist(prompt) <= SemiV3State.HalfFireRange
                local firedNow = false
                if nowInRange then
                    if lastWasInRange then
                        firedNow = true
                    else
                        task.wait(0.3)
                        if sv3PromptDist(prompt) <= SemiV3State.HalfFireRange and prompt.Parent then
                            firedNow = true
                        else
                            lastWasInRange = false
                            task.wait()
                        end
                    end
                    if firedNow then
                        sv3FireTrigger(prompt, data)
                        fired = true
                        break
                    end
                else
                    lastWasInRange = nowInRange
                    task.wait()
                end
            end
        end)
        if not ok then warn("[horizonhub] steal error: " .. tostring(err)) end
        if fired then setProgress(1) end
        task.wait(0.05)
        setProgress(0)
        -- Always unlock, even if something above threw.
        data.ready = true
        SemiV3State.isStealing = false
    end)
end
local function startSemiV3Mode()
    if SemiV3State.conn then pcall(function() SemiV3State.conn:Disconnect() end); SemiV3State.conn = nil end
    SemiV3State.isStealing = false
    SemiV3State.conn = RunService.Heartbeat:Connect(function()
        if not isEnabled then return end
        local now = tick()
        -- Watchdog: if a steal ever gets stuck (error inside a captured
        -- connection etc.), force-unlock the engine so it never dies.
        if SemiV3State.isStealing then
            if SemiV3State.stealStartTime and (now - SemiV3State.stealStartTime) > (SemiV3State.HalfHoldMax + 3) then
                SemiV3State.isStealing = false
                for _, d in pairs(SemiV3State.Data) do d.ready = true end
                setProgress(0)
            end
            return
        end
        -- Throttle the world scan (no need to run it 60x per second).
        if now - (SemiV3State.lastScan or 0) < 0.2 then return end
        SemiV3State.lastScan = now
        local ok, p = pcall(sv3FindNearestPrompt)
        if not p and (now - (SemiV3State.lastFallbackScan or 0)) > 1.5 then
            SemiV3State.lastFallbackScan = now
            task.spawn(function()
                local ok2, p2 = pcall(sv3FindNearestPromptFallback)
                if ok2 then SemiV3State.lastFallbackResult = p2 end
            end)
        end
        if not p and SemiV3State.lastFallbackResult then
            local d = sv3PromptDist(SemiV3State.lastFallbackResult)
            if d <= Radii.SemiV3 then p = SemiV3State.lastFallbackResult end
        end
        if ok and p then pcall(sv3ExecuteSteal, p) end
    end)
end
local function stopSemiV3Mode()
    if SemiV3State.conn then pcall(function() SemiV3State.conn:Disconnect() end); SemiV3State.conn = nil end
    SemiV3State.isStealing = false
    setProgress(0)
end




local function stopAll()
    stopSemiV3Mode()
    setProgress(0)
end
local function startAll()
    if not isEnabled then return end
    startSemiV3Mode()
end

-- ============================================================
-- UI BRIDGE  (this was MISSING -> the "Instant Steal" toggle
-- button in the main GUI did nothing, and the Radius box too)
-- ============================================================
_G.YousefInstantSteal = {
    SetEnabled = function(v)
        -- Legacy compatibility only; Galaxy V1/V2 owns Auto Steal.
        isEnabled = (v == true)
        saveConfig()
    end,
    GetEnabled = function() return isEnabled end,
    SetRadius = function(v)
        local n = tonumber(v) or Radii.SemiV3
        n = math.max(1, math.floor(n + 0.5))
        Radii.Normal = n
        Radii.Semi   = n
        Radii.SemiV2 = n
        Radii.SemiV3 = n
        saveConfig()
    end,
    GetRadius = function() return Radii.SemiV3 end,
    SetMode = function(m)
        selectedMode = "SemiV3"
        saveConfig()
    end,
    GetMode = function() return "V1" end,
}

-- The Galaxy V1/V2 engine below owns Auto Steal. Do not start the legacy
-- Instant/Semi engine from this older block.
end) end)
-- end of legacy insta steal helpers
repeat task.wait() until game:IsLoaded()

Players, RunService, __HH.UIS, TS, Lighting, __HH.HS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService")
LP = Players.LocalPlayer

__HH.antiRagdollEnabled, __HH.infJumpEnabled = false, false
__HH.medusaCounterEnabled = false
__HH.medusaResetEnabled = false
__HH.batCounterEnabled = false
__HH.unwalkEnabled = false
__HH.medusaDebounce, __HH.medusaLastUsed, __HH.dropActive = false, 0, false
Conns = {autoSteal = nil, antiRag = nil, batCounter = nil, anchor = {}}
__HH.tpLockEnabled = false
__HH.tpLockSetVisual = nil
__HH.mobBtnRefs = nil
__HH.batV2Enabled = false
__HH.batV2SetVisual = nil
__HH.antiDieEnabled = false
__HH.setAntiDieVisual = nil
__HH.antiDieConns = {}
__HH.setBatCounterVisual = nil
local startBatCounter, stopBatCounter
__HH.antiLagEnabled = false
__HH.removeAccessoriesEnabled = false
__HH.antiLagDescConn = nil
__HH.stretchRezEnabled = false
__HH.stretchRezConn = nil
__HH.setStretchRezVisual = nil

-- FRHUB Auto Left / Auto Right state, UI setters and controller functions.
-- Sound is already near Luau's 200-local limit, so these cross-script bridge
-- names are initialized explicitly while the implementation itself is scoped.
autoLeftEnabled, autoRightEnabled = false, false
autoLeftSetVisual, autoRightSetVisual = nil, nil
startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight = nil, nil, nil, nil
toggleAutoLeft, toggleAutoRight = nil, nil

__HH.unwalkSavedAnimate = nil
__HH._anyKeyListening = false
end
do
__HH._lastKbSet = 0
__HH.autoTPEnabled = false
__HH.autoTPHeight = 20
__HH.autoTPConn = nil
__HH.setAutoTPVisual = nil
__HH.setInfJumpVisual = nil
__HH.mainFrame = nil
__HH.bgImage = nil
local _guiLocked = false

setCarryVisual = nil
setLaggerVisual = nil
setAutoSwingVisual = nil
__HH.setBatCounterVisual = nil
setAntiRagVisual = nil
setMedusaVisual = nil
setMedusaResetVisual = nil
setUnwalkVisual = nil
setAntiLagVisual = nil
__HH.setStretchRezVisual = nil
__HH.setAutoTPVisual = nil
setSaturationVisual = nil
setVoidModeVisual = nil
setStretchRezV2Visual = nil
setTranspVisual = nil
setLockVisual = nil
setMobVisual = nil
setCircleBtnsVisual = nil
setShapeVisual = nil
setRectVisual = nil
__HH.setInfJumpVisual = nil

__HH.espEnabled = false
__HH.headlessEnabled = false
__HH.korbloxEnabled = false
__HH.setESPVisual = nil

uiScaleValue = 0.7
__HH.uiScaleObject = nil
__HH.guiSizeValue = 2
__HH.panelScaleObject = nil

__HH.TOGGLE_ON_COLOR = Color3.fromRGB(216, 171, 255)

-- ============================================
-- FRHUBVELOCITYv67 engine ports: Normal = V7, Bypass = V11 BYPASS.
-- Only the requested backends are imported, not FR's UI, loaders, config files,
-- god-mode/anti-lava code, or unrelated aimbot versions.
if type(aimbotV1Speed) ~= "number" then aimbotV1Speed = 56 end
if batAimMode ~= "normal" and batAimMode ~= "bypass" then batAimMode = "normal" end
autoBatEnabled = autoBatEnabled == true

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer

    -- Tear down the previous port on a rerun. Also stop both branches of the
    -- pre-port backend, whose old bypass getter did not report V2 correctly.
    pcall(function()
        if _G.SoundAimbotPort and _G.SoundAimbotPort.Destroy then
            _G.SoundAimbotPort.Destroy()
        elseif type(_G.SoundCursedSetAimbot) == "function" then
            local previousMode = batAimMode
            batAimMode = "normal"; pcall(_G.SoundCursedSetAimbot, false)
            batAimMode = "bypass"; pcall(_G.SoundCursedSetAimbot, false)
            batAimMode = previousMode
        end
        if type(_G.HHGoodAimSet) == "function" then _G.HHGoodAimSet(false) end
    end)

    local S = {destroyed = false, activeMode = nil, connections = {}, normalVersion = "FR V7", bypassVersion = "FR V11 BYPASS"}
    local v7, v11 = {}, {}
    local ownedMirror = nil
    local function track(connection)
        S.connections[#S.connections + 1] = connection
        return connection
    end
    local function aimSpeed()
        return math.clamp(tonumber(aimbotV1Speed) or 56, 1, 500)
    end
    local function v11CombatSpeed()
        if laggerCarryToggled == true then return tonumber(LAGGER_CARRY_SPEED) or 40 end
        if laggerModeEnabled == true then return tonumber(LAGGER_SPEED) or 40 end
        return aimSpeed()
    end
    local function zeroRoot(root)
        if not root then return end
        pcall(function() root.Velocity = Vector3.zero end)
        pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
        pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
    end
    -- FR V7 core (the same backend used by FR's AIMBOT V7 panel).
    do
        local CFG = {
            SPEED                 = 58,
            VERT_SPEED            = 58,
            HEIGHT                = 1,
            V_OFF                 = 0,
            TURN_SPEED            = 40,
            MAX_TORQUE            = 500000,
            JUMP_PREDICT          = 0.35,
            TP_DOWN_PREDICT       = 0.5,
            JUMP_DETECT_THRESHOLD = 0,
            MAX_JUMP_HISTORY      = 12,
            JUMP_COUNT_TRIGGER    = 0,
            TP_DOWN_VEL_THRESHOLD = -80,
            TP_DOWN_RESPONSE_DIST = 8,
            VEL_SAMPLES           = 6,
            POS_SAMPLES           = 4,
            PREDICT_PCT           = 120,
            SWING_COOLDOWN        = 0.08,
            autoSwing             = true,
            BatSpam               = false,
            SpamDelay             = 50,
            keybind               = "V",
        }

        local aimEnabled, batEquippedThisRun = false, false
        local angVelc, angVelcAtt, SpamThread = nil, nil, nil
        local swingCD = false
        local _intendedVel = Vector3.zero
        local _velHistory, _posHistory, _jumpHistory = {}, {}, {}
        local _infiniteJumpDetected, _tpDownDetected, _jumpCount = false, false, 0
        local _peakY, _normalModeTimer, _lastTargetY = 0, 0, 0
        local DETECT_NAMES = {"LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt","AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock"}

        local function purgeHRP(hrp)
            if not hrp then return end
            pcall(function()
                for _, n in ipairs(DETECT_NAMES) do
                    local o = hrp:FindFirstChild(n)
                    if o then o:Destroy() end
                end
                for _, c in ipairs(hrp:GetChildren()) do
                    local low = c.Name:lower()
                    if c.Name ~= "_UA_AngV" and c.Name ~= "_UA_Att"
                    and c.Name ~= "_PR_AngV" and c.Name ~= "_PR_Att"
                    and c.Name ~= "_GB_AngV" and c.Name ~= "_GB_Att"
                    and (low:find("lockb") or low:find("lockangv") or low:find("batlock") or low:find("antiaim") or low:find("velocitylock")) then
                        pcall(function() c:Destroy() end)
                    end
                end
            end)
        end

        local function setupAngVelc(hrp)
            pcall(function()
                local o1 = hrp:FindFirstChild("_UA_AngV")
                local o2 = hrp:FindFirstChild("_UA_Att")
                if o1 then o1:Destroy() end
                if o2 then o2:Destroy() end
            end)
            local att = Instance.new("Attachment"); att.Name = "_UA_Att"; att.Parent = hrp
            local av = Instance.new("AngularVelocity")
            av.Name = "_UA_AngV"; av.Attachment0 = att
            av.RelativeTo = Enum.ActuatorRelativeTo.World
            av.MaxTorque = CFG.MAX_TORQUE; av.AngularVelocity = Vector3.zero; av.Parent = hrp
            angVelcAtt = att; angVelc = av
        end
        local function cleanAngVelc()
            pcall(function() if angVelc    and angVelc.Parent    then angVelc:Destroy()    end end)
            pcall(function() if angVelcAtt and angVelcAtt.Parent then angVelcAtt:Destroy() end end)
            angVelc = nil; angVelcAtt = nil
        end

        local TARGET_PARTS = {"HumanoidRootPart", "Torso", "UpperTorso", "Head", "LowerTorso"}

        local function findBestPart(myHRP)
            local nearestHRP  = nil
            local nearestDist = math.huge
            local bestPart    = nil
            for _, p in Players:GetPlayers() do
                if p ~= LP and p.Character then
                    local eh  = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if eh and hum and hum.Health > 0 then
                        local d = (eh.Position - myHRP.Position).Magnitude
                        if d < nearestDist then
                            nearestDist = d
                            nearestHRP  = eh
                            local closestPart = eh
                            local closestD    = d
                            for _, pName in ipairs(TARGET_PARTS) do
                                local part = p.Character:FindFirstChild(pName)
                                if part and part:IsA("BasePart") then
                                    local pd = (part.Position - myHRP.Position).Magnitude
                                    if pd < closestD then
                                        closestD    = pd
                                        closestPart = part
                                    end
                                end
                            end
                            bestPart = closestPart
                        end
                    end
                end
            end
            return nearestHRP, nearestDist, bestPart
        end

        local function detectInfiniteJump(targetHRP)
            if not targetHRP then
                _infiniteJumpDetected = false; _tpDownDetected = false; _jumpCount = 0
                return "normal"
            end
            local velY = targetHRP.Velocity.Y
            local posY = targetHRP.Position.Y
            if posY > _peakY then _peakY = posY end
            local upwardSpikes = 0
            for i = 2, #_jumpHistory do
                if _jumpHistory[i] > CFG.JUMP_DETECT_THRESHOLD
                and _jumpHistory[i-1] < CFG.JUMP_DETECT_THRESHOLD * 0.3 then
                    upwardSpikes = upwardSpikes + 1
                end
            end
            if upwardSpikes >= CFG.JUMP_COUNT_TRIGGER and not _infiniteJumpDetected then
                _infiniteJumpDetected = true; _jumpCount = upwardSpikes; _peakY = posY; _tpDownDetected = false
            end
            if _infiniteJumpDetected and velY < CFG.TP_DOWN_VEL_THRESHOLD then
                _tpDownDetected = true; return "tp_down"
            end
            if _infiniteJumpDetected and velY < -20 and (posY < _peakY - 5) then return "falling" end
            if _infiniteJumpDetected and math.abs(velY) < 5 and posY < _lastTargetY + 2 then
                _normalModeTimer = _normalModeTimer + 1
                if _normalModeTimer > 8 then
                    _infiniteJumpDetected = false; _tpDownDetected = false; _jumpCount = 0
                    _peakY = 0; _normalModeTimer = 0; _jumpHistory = {}
                    return "normal"
                end
            else
                _normalModeTimer = 0
            end
            _lastTargetY = posY
            if _infiniteJumpDetected then return _tpDownDetected and "tp_down" or "infinite_jump" end
            return "normal"
        end

        local GRAVITY = -196.2

        local function computePredictedPos(myHRP, targetHRP, bestPart, mode)
            local aimPart   = bestPart or targetHRP
            local curPos    = aimPart.Position
            local rawCurVel = aimPart.Velocity
            local xzSpikeMag = math.abs(rawCurVel.X) + math.abs(rawCurVel.Z)
            local curVel
            if xzSpikeMag > 400 then
                if #_velHistory > 0 then
                    local safe = _velHistory[#_velHistory]
                    curVel = Vector3.new(safe.X, rawCurVel.Y, safe.Z)
                else
                    curVel = Vector3.new(0, rawCurVel.Y, 0)
                end
            else
                curVel = rawCurVel
            end
            table.insert(_velHistory, curVel)
            if #_velHistory > CFG.VEL_SAMPLES then table.remove(_velHistory, 1) end
            table.insert(_posHistory, curPos)
            if #_posHistory > CFG.POS_SAMPLES then table.remove(_posHistory, 1) end
            table.insert(_jumpHistory, rawCurVel.Y)
            if #_jumpHistory > CFG.MAX_JUMP_HISTORY then table.remove(_jumpHistory, 1) end
            local accel = Vector3.zero
            if #_velHistory >= 3 then
                local newest = _velHistory[#_velHistory]
                local oldest = _velHistory[1]
                accel = (newest - oldest) / math.max(#_velHistory * 0.016, 0.016)
            end
            local wasTeleported = false
            if #_posHistory >= 2 then
                local delta = _posHistory[#_posHistory] - _posHistory[#_posHistory - 1]
                if delta.Magnitude > 12 then
                    wasTeleported = true
                    _velHistory = {}
                    _posHistory = { curPos }
                end
            end
            local targetVelXZ = Vector3.new(curVel.X, 0, curVel.Z)
            local targetSpeed  = targetVelXZ.Magnitude
            local mySpeed      = math.max(CFG.SPEED, 1)
            local dXZ          = Vector3.new(curPos.X - myHRP.Position.X, 0, curPos.Z - myHRP.Position.Z)
            local vv  = targetVelXZ:Dot(targetVelXZ)
            local dv  = dXZ:Dot(targetVelXZ)
            local dd  = dXZ:Dot(dXZ)
            local ia  = vv - mySpeed * mySpeed
            local ib  = 2 * dv
            local interceptT
            if math.abs(ia) < 0.01 then
                interceptT = dXZ.Magnitude / math.max(mySpeed - targetSpeed * 0.5, 1)
            else
                local disc = ib * ib - 4 * ia * dd
                if disc < 0 then
                    interceptT = dXZ.Magnitude / mySpeed
                else
                    local sq = math.sqrt(disc)
                    local t1 = (-ib - sq) / (2 * ia)
                    local t2 = (-ib + sq) / (2 * ia)
                    if     t1 > 0.001 and t2 > 0.001 then interceptT = math.min(t1, t2)
                    elseif t1 > 0.001                  then interceptT = t1
                    elseif t2 > 0.001                  then interceptT = t2
                    else                                    interceptT = dXZ.Magnitude / mySpeed
                    end
                end
            end
            interceptT = math.clamp(interceptT, 0.02, 1.5)
            local pctMult  = math.max(CFG.PREDICT_PCT / 100, 0.05)
            local leadTime = math.clamp(interceptT * pctMult, 0.02, 1.5)
            local predictedPos
            local isEmergency = false
            if wasTeleported then
                predictedPos = curPos + curVel * math.min(leadTime, 0.08)
            elseif mode == "tp_down" then
                local landX = curPos.X + curVel.X * CFG.TP_DOWN_PREDICT
                local landZ = curPos.Z + curVel.Z * CFG.TP_DOWN_PREDICT
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {LP.Character}; rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(Vector3.new(landX, curPos.Y, landZ), Vector3.new(0, -200, 0), rp)
                local gy = rr and rr.Position.Y or curPos.Y
                predictedPos = Vector3.new(landX, gy + CFG.HEIGHT + 3, landZ)
                isEmergency = true
            elseif mode == "infinite_jump" then
                local jt = CFG.JUMP_PREDICT
                predictedPos = curPos + Vector3.new(curVel.X * jt * 0.5, -2, curVel.Z * jt * 0.5)
            elseif curVel.Y < -28 then
                local deltaY = curVel.Y * 0.22
                local disc   = curVel.Y * curVel.Y - 2 * GRAVITY * math.abs(deltaY)
                local ballT  = disc > 0 and ((-curVel.Y - math.sqrt(disc)) / (-GRAVITY)) or 0.18
                ballT = math.clamp(ballT, 0.04, 0.55)
                local blendT = math.max(leadTime, ballT)
                predictedPos = Vector3.new(
                    curPos.X + curVel.X * blendT,
                    curPos.Y + curVel.Y * ballT + 0.5 * GRAVITY * ballT * ballT + 2.8,
                    curPos.Z + curVel.Z * blendT
                )
            elseif curVel.Y > 28 then
                local tPeak  = curVel.Y / math.abs(GRAVITY)
                local blendT = math.min(leadTime, tPeak * 1.2)
                predictedPos = Vector3.new(
                    curPos.X + curVel.X * blendT + accel.X * blendT * blendT * 0.5,
                    curPos.Y + curVel.Y * blendT + 0.5 * GRAVITY * blendT * blendT,
                    curPos.Z + curVel.Z * blendT + accel.Z * blendT * blendT * 0.5
                )
            else
                predictedPos = curPos + curVel * leadTime + accel * (leadTime * leadTime * 0.5)
            end
            if targetVelXZ.Magnitude > 1 and not wasTeleported then
                local fwdDir     = targetVelXZ.Unit
                local relToTgt   = myHRP.Position - curPos
                local relXZ      = Vector3.new(relToTgt.X, 0, relToTgt.Z)
                local relDot     = relXZ:Dot(fwdDir)
                local minAhead   = 4
                local catchUp    = math.max(minAhead - relDot, 0)
                local speedBonus = math.clamp(targetSpeed * 0.09, 1, 5)
                local totalBias  = math.clamp(catchUp + speedBonus, 2, 14)
                predictedPos = predictedPos + Vector3.new(fwdDir.X * totalBias, 0, fwdDir.Z * totalBias)
            end
            predictedPos = predictedPos + Vector3.new(0, CFG.V_OFF, 0)
            return predictedPos, isEmergency
        end

        local function startBatSpam()
            if SpamThread then return end
            SpamThread = task.spawn(function()
                while CFG.BatSpam do
                    pcall(function()
                        local char = LP.Character
                        if char then
                            local bat = char:FindFirstChild("bat") or char:FindFirstChild("Bat")
                            if not bat then
                                for _, tool in pairs(LP.Backpack:GetChildren()) do
                                    if tool.Name:lower() == "bat" then bat = tool break end
                                end
                            end
                            if bat and bat:IsA("Tool") then
                                bat:Activate()
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local _, nearDist, _ = findBestPart(hrp)
                                    if nearDist and nearDist < 6 then
                                        task.wait(0.02)
                                        bat:Activate()
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(CFG.SpamDelay / 1000)
                end
                SpamThread = nil
            end)
        end
        local function stopBatSpam()
            CFG.BatSpam = false
            SpamThread  = nil
        end

        local function resetHistory()
            _velHistory, _posHistory, _jumpHistory = {}, {}, {}
            _infiniteJumpDetected, _tpDownDetected, _jumpCount = false, false, 0
            _peakY, _normalModeTimer, _lastTargetY = 0, 0, 0
            _intendedVel = Vector3.zero
            swingCD = false
            v7.target = nil
        end
        v7.cfg = CFG
        v7.enabled = function() return aimEnabled end
        v7.clearVelocity = function()
            _intendedVel = Vector3.zero
            if angVelc then pcall(function() angVelc.AngularVelocity = Vector3.zero end) end
            zeroRoot(v7.lastRoot)
            local char = LP.Character
            zeroRoot(char and char:FindFirstChild("HumanoidRootPart"))
        end
        v7.start = function()
            if S.destroyed or aimEnabled then return end
            resetHistory()
            aimEnabled, batEquippedThisRun = true, false
            CFG.SPEED = aimSpeed() -- Sound's existing AIM BOT Speed control.
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                v7.lastRoot = root
                purgeHRP(root)
                setupAngVelc(root)
            end
            if CFG.BatSpam then startBatSpam() end
        end
        v7.stop = function()
            local wasEnabled = aimEnabled
            aimEnabled, batEquippedThisRun = false, false
            local spam = SpamThread
            stopBatSpam()
            if spam and task.cancel then pcall(task.cancel, spam) end
            if wasEnabled then v7.clearVelocity() end
            local oldHumanoid = v7.lastRoot and v7.lastRoot.Parent and v7.lastRoot.Parent:FindFirstChildOfClass("Humanoid")
            local char = LP.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if wasEnabled then
                if oldHumanoid then pcall(function() oldHumanoid.AutoRotate = true end) end
                if humanoid then pcall(function() humanoid.AutoRotate = true end) end
            end
            cleanAngVelc()
            resetHistory()
            v7.lastRoot = nil
        end
        track(RunService.Heartbeat:Connect(function()
            if not aimEnabled or S.destroyed then return end
            CFG.SPEED = aimSpeed()
            local char = LP.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root or not hum or hum.Health <= 0 then v7.target = nil; return end
            v7.lastRoot = root
            purgeHRP(root)
            if not angVelc or not angVelc.Parent or angVelc.Parent ~= root then cleanAngVelc(); setupAngVelc(root) end
            if not batEquippedThisRun then
                batEquippedThisRun = true
                if not char:FindFirstChildOfClass("Tool") then
                    local bp  = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
                    local bat = bp and bp:FindFirstChild("Bat")
                    if bat then pcall(function() hum:EquipTool(bat) end) end
                end
            end
            local target, dist, bestPart = findBestPart(root)
            v7.target = target
            if not target then
                zeroRoot(root) -- clear stale movement on target loss
                hum.AutoRotate = true
                if angVelc then pcall(function() angVelc.AngularVelocity = Vector3.zero end) end
                return
            end
            local mode = detectInfiniteJump(target)
            local predictedPos, isEmergency = computePredictedPos(root, target, bestPart, mode)
            hum.AutoRotate = false
            pcall(function()
                if not angVelc or not angVelc.Parent then return end
                local dCF = CFrame.lookAt(root.Position, predictedPos)
                local rCF = root.CFrame:ToObjectSpace(dCF)
                local ax, an = rCF:ToAxisAngle()
                if an > 0.01 then
                    angVelc.AngularVelocity = root.CFrame:VectorToWorldSpace(ax) * (an * CFG.TURN_SPEED)
                else
                    angVelc.AngularVelocity = Vector3.zero
                end
            end)
            local moveDir = predictedPos - root.Position
            local hDir    = Vector3.new(moveDir.X, 0, moveDir.Z)
            local hVel    = hDir.Magnitude > 0.1 and hDir.Unit * CFG.SPEED or Vector3.zero
            local vVel
            if isEmergency then
                vVel = Vector3.new(0, math.sign(moveDir.Y) * CFG.VERT_SPEED * 1.3, 0)
            elseif math.abs(moveDir.Y) > 0.1 then
                vVel = Vector3.new(0, math.sign(moveDir.Y) * CFG.VERT_SPEED, 0)
            else
                vVel = Vector3.new(0, -2, 0)
            end
            _intendedVel = hVel + vVel
            root.Velocity = _intendedVel
            if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
            if CFG.autoSwing and not swingCD then
                local bat = char:FindFirstChild("Bat")
                if bat and bat:IsA("Tool") then
                    swingCD = true
                    pcall(function()
                        bat:Activate()
                        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if ev then ev:FireServer() end
                    end)
                    task.delay(CFG.SWING_COOLDOWN, function() swingCD = false end)
                end
            end
        end))
        track(RunService.RenderStepped:Connect(function()
            if not aimEnabled or S.destroyed then return end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local velocity = root.Velocity
            if math.abs(velocity.X) > 350 or math.abs(velocity.Z) > 350 then root.Velocity = _intendedVel end
            purgeHRP(root)
        end))
        track(LP.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            if S.destroyed or LP.Character ~= character then return end
            batEquippedThisRun = false
            resetHistory()
            if aimEnabled then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then cleanAngVelc(); v7.lastRoot = root; purgeHRP(root); setupAngVelc(root) end
                if CFG.BatSpam then startBatSpam() end
            end
        end))
    end
    -- Final predictive V11 core from FR's "AIMBOT V11 BYPASS" switch.
    -- FR's global helper names are local to this factory, avoiding collisions
    -- with a separately running FR script or Sound's existing features.
    do
        local m, K, c = LP, Players, RunService
        local E = {Aimbot = false, ["Lagger Aimbot"] = false}
        local H = {}
        local autoplayActive = false
        local ci = function() end
        local _FRHUBV11StartFollowing, _FRHUBV11Stop
        local _G = {
            __FRHUB_V11_STATE = H,
            __FRHUBV11AutoDrop = function(fn) if fn then fn() end end,
            __FRHUBV11StopSpeedBoost = function() end,
            __FRHUBV11RefreshSpeedBoost = function() end,
            __FRHUBV11StopAutoplay = function() end,
            __FRHUBV11DeactivateOthers = function() v7.stop() end,
        }
        local function __FRHUBV11CombatSpeed() return v11CombatSpeed() end
        local function __v11Stopper(fn) v11.stopCore = fn end
        local i = m;
        local function o()
            local a = i.Character;
            if a then
                local Pi = a:FindFirstChildOfClass("Tool");
                if Pi then
                    local a = Pi.Name:lower();
                    if a:find("bat", 1, true) or(a:find("slap", 1, true)) then
                        return Pi;
                    end;
                end;
                Pi = i:FindFirstChildOfClass("Backpack");
                if Pi then
                    for i, a in ipairs(Pi:GetChildren()) do
                        if a:IsA("Tool") then
                            i = a.Name:lower();
                            if i:find("bat", 1, true) or(i:find("slap", 1, true)) then
                                return a;
                            end;
                        end;
                    end;
                end;
            end;
            return nil;
        end;
        local i, a, Pi = {targetPlayer = nil, lastTargetPos = nil, targetVelocity = Vector3.zero, smoothedVelocity = Vector3.zero, velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {}, verticalVelocityHistory = {}, previousDirection = nil, lastDirectionChangeTime = 0, airborneTime = 0, lastYVelocity = 0, lastJumpTime = 0, lastActivationTime = 0, currentPing = 0.1, realPingMs = 0}, {FOLLOW_SPEED = 55, ACTIVATE_DISTANCE = 13, MIN_FOLLOW_DISTANCE = 1, PREDICTION_TIME = 0.12, PREDICT_AHEAD = 1.5, MAX_VELOCITY_CHANGE = 150, VELOCITY_SMOOTHING = 0.2, MAX_HORIZONTAL_VELOCITY = 80, SERVER_TICKRATE = 0.016666666666666666, MIN_PING_COMPENSATION = 0.03, MAX_PING_COMPENSATION = 0.12, ACCELERATION_PREDICTION_WEIGHT = 0.3, DIRECTION_CHANGE_DETECTION_TIME = 0.12, QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5, GRAVITY = 196.2, AIR_CONTROL_FACTOR = 0.8, AERIAL_VELOCITY_DECAY = 0.95, MIN_AIRBORNE_TIME = 0.08, FALLING_SPEED_THRESHOLD =- 15};
        v11.state, v11.tuning = i, a
        local function ki(xi)
            if #xi == 0 then
                return Vector3.zero;
            end;
            local _i = Vector3.zero;
            for Li, Li in ipairs(xi) do
                _i += Li;
            end;
            return _i / #xi;
        end;
        local function xi(_i, Li, zi)
            table.insert(_i, Li);
            if #_i > zi then
                table.remove(_i, 1);
            end;
        end;
        local function _i ()
            i.targetPlayer = nil;
            i.lastTargetPos = nil;
            i.targetVelocity = Vector3.zero;
            i.smoothedVelocity = Vector3.zero;
            i.velocityHistory = {};
            i.accelerationHistory = {};
            i.aerialVelocityHistory = {};
            i.verticalVelocityHistory = {};
            i.previousDirection = nil;
            i.airborneTime = 0;
            i.lastYVelocity = 0;
        end;
        local function Li(zi)
            local Si, gi = math.huge;
            for Oi, ni in ipairs(K:GetPlayers()) do
                if ni ~= m and ni.Character then
                    local Ji, fi = ni.Character:FindFirstChild("HumanoidRootPart"), ni.Character:FindFirstChildOfClass("Humanoid");
                    if Ji and fi and fi.Health > 0 then
                        Oi = (zi.Position - Ji.Position).Magnitude;
                        if Oi < Si then
                            Si, gi = Oi, ni;
                        end;
                    end;
                end;
            end;
            return gi;
        end;
        local function zi(Si, gi)
            if gi.Magnitude < 0.01 then
                return;
            end;
            local Oi = Si.CFrame.LookVector:Cross(gi.Unit);
            gi = math.asin(math.clamp(Oi.Magnitude,- 1, 1));
            Si.AssemblyAngularVelocity = Oi.Magnitude > 0.01 and Oi.Unit * gi * 80 or Vector3.zero;
        end;
        local function Si()
            local gi, Oi = pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue(); end);
            if gi and type(Oi) == "number" then
                i.realPingMs = math.floor(Oi);
            end;
            i.currentPing = math.clamp(i.realPingMs / 1000, a.MIN_PING_COMPENSATION, a.MAX_PING_COMPENSATION);
        end;
        task.spawn(function() while _G.__FRHUB_V11_STATE == H do pcall(Si); task.wait(0.5); end; end);
        local function Si()
            if Pi then
                Pi:Disconnect();
                Pi = nil;
            end;
            local gi = m.Character;
            local Oi, ni = gi and(gi:FindFirstChildOfClass("Humanoid")), gi and(gi:FindFirstChild("HumanoidRootPart"));
            if Oi then
                Oi.AutoRotate = true;
            end;
            if ni then
                ni.AssemblyAngularVelocity = Vector3.zero;
            end;
            _i ();
            i.lastActivationTime = 0;
        end;
        local function gi(Oi)
            Oi = Oi or m.Character;
            local ni, Ji = Oi and(Oi:FindFirstChildOfClass("Humanoid")), Oi and(Oi:FindFirstChild("HumanoidRootPart"));
            if not ni or not Ji then
                return;
            end;
            Si();
            ni.AutoRotate = false;
            local fi = o();
            if fi and fi.Parent ~= Oi then
                pcall(ni.EquipTool, ni, fi);
            end;
            Pi = c.RenderStepped:Connect(function(Pi) if not E.Aimbot then Si(); return; end; local Oi = m.Character; local oi, qi = Oi and(Oi:FindFirstChild("HumanoidRootPart")), Oi and(Oi:FindFirstChildOfClass("Humanoid")); if not oi or not qi or qi.Health <= 0 then return; end; qi.AutoRotate = false; Ji, ni = oi, qi; v11.lastRoot = Ji; fi = Oi:FindFirstChildOfClass("Tool") or(o()); if fi and fi.Parent ~= Oi then pcall(qi.EquipTool, qi, fi); end; Oi = nil; if _G.__FRHUBV11MarkerCFrame then oi, qi = pcall(_G.__FRHUBV11MarkerCFrame); Oi = if oi then qi else Oi; end; if Oi then oi = Oi.Position - Ji.Position; if oi.Magnitude > 0.1 then zi(Ji, oi); end; if oi.Magnitude > a.MIN_FOLLOW_DISTANCE then qi = math.clamp(__FRHUBV11CombatSpeed(), 1, 120); local f11m = Vector3.new(oi.X, 0, oi.Z); local y11m = oi.Y * 19.5; if ni and ni.FloorMaterial ~= Enum.Material.Air then y11m = math.max(y11m, 13) end; y11m = math.clamp(y11m, -70, 110); if f11m.Magnitude > 0.01 then Ji.AssemblyLinearVelocity = Vector3.new(f11m.Unit.X * qi, y11m, f11m.Unit.Z * qi) else Ji.AssemblyLinearVelocity = Vector3.new(0, y11m, 0) end else Ji.AssemblyLinearVelocity = Vector3.zero; end; return; end; i.targetPlayer = Li(Ji); oi = i.targetPlayer and i.targetPlayer.Character; qi, Oi = oi and(oi:FindFirstChild("HumanoidRootPart")), oi and(oi:FindFirstChildOfClass("Humanoid")); if not qi or not Oi or Oi.Health <= 0 then _i (); Ji.AssemblyLinearVelocity = Vector3.zero; Ji.AssemblyAngularVelocity = Vector3.zero; return; end; local o, _i = qi.Position, math.max(Pi, 0.004166666666666667); if i.lastTargetPos then oi = (o - i.lastTargetPos) / _i; Pi = oi - i.targetVelocity; oi = if Pi.Magnitude > a.MAX_VELOCITY_CHANGE then i.targetVelocity + Pi.Unit * a.MAX_VELOCITY_CHANGE else oi; qi = Vector3.new(oi.X, 0, oi.Z); if qi.Magnitude > a.MAX_HORIZONTAL_VELOCITY then qi = qi.Unit * a.MAX_HORIZONTAL_VELOCITY; oi = (Vector3.new(qi.X, oi.Y, qi.Z)); end; xi(i.accelerationHistory, (oi - i.targetVelocity) / _i, 4); xi(i.velocityHistory, oi, 8); xi(i.verticalVelocityHistory, oi.Y, 5); i.targetVelocity = oi; i.smoothedVelocity = i.smoothedVelocity:Lerp(oi, a.VELOCITY_SMOOTHING); end; i.lastTargetPos = o; Pi = Oi.FloorMaterial == Enum.Material.Air; i.airborneTime = Pi and i.airborneTime + _i or 0; if Pi and i.airborneTime >= a.MIN_AIRBORNE_TIME then xi(i.aerialVelocityHistory, i.targetVelocity, 6); elseif not Pi then i.aerialVelocityHistory = {}; end; qi = i.smoothedVelocity; if Pi and #i.aerialVelocityHistory > 0 then Oi = ki(i.aerialVelocityHistory); qi = Vector3.new(Oi.X, i.targetVelocity.Y, Oi.Z) * a.AIR_CONTROL_FACTOR; end; _i, Oi = false, Vector3.new(i.targetVelocity.X, 0, i.targetVelocity.Z); if Oi.Magnitude > 5 then oi = Oi.Unit; if i.previousDirection and i.previousDirection:Dot(oi) < 0.5 then _i = tick() - i.lastDirectionChangeTime < a.DIRECTION_CHANGE_DETECTION_TIME; i.lastDirectionChangeTime = tick(); end; i.previousDirection = oi; end; oi = i.currentPing + a.SERVER_TICKRATE; local xi, Li = o + qi * (if _i then oi * a.QUICK_DIRECTION_CHANGE_MULTIPLIER else oi) + ki(i.accelerationHistory) * a.ACCELERATION_PREDICTION_WEIGHT * ((if _i then oi * a.QUICK_DIRECTION_CHANGE_MULTIPLIER else oi) * (if _i then oi * a.QUICK_DIRECTION_CHANGE_MULTIPLIER else oi) * 0.5), a.PREDICTION_TIME * 1.1; xi = if Pi then xi + qi * Li + Vector3.new(0,- 0.5 * a.GRAVITY * Li * Li, 0) else xi + qi * Li; local ld11 = xi - o; if ld11.Magnitude > 9 then xi = o + ld11.Unit * 9 end; Oi = Vector3.new(qi.X, 0, qi.Z); Pi = (if Oi.Magnitude > 1 then xi + Oi.Unit * a.PREDICT_AHEAD else xi) - Ji.Position; zi(Ji, Pi); if Ji.Position.Y < -5 and o.Y - Ji.Position.Y > 6 then if not i.underSince then i.underSince = tick() elseif tick() - i.underSince > 0.2 and tick() - (i.lastRelock or 0) > 0.25 then i.lastRelock = tick(); i.underSince = nil; local _, yaw11 = Ji.CFrame:ToEulerAnglesYXZ(); Ji.CFrame = CFrame.new(Ji.Position.X, o.Y + 3, Ji.Position.Z) * CFrame.Angles(0, yaw11, 0); Ji.AssemblyLinearVelocity = Vector3.zero end else i.underSince = nil end; if(o - Ji.Position).Magnitude <= a.ACTIVATE_DISTANCE and tick() - i.lastActivationTime >= 0.08 and autoSwingEnabled == true then if fi then pcall(fi.Activate, fi); pcall(function() local ev11 = fi:FindFirstChildWhichIsA("RemoteEvent"); if ev11 then ev11:FireServer() end end); end; i.lastActivationTime = tick(); end; if Pi.Magnitude > a.MIN_FOLLOW_DISTANCE then qi = math.clamp(__FRHUBV11CombatSpeed(), 1, 120); local f11 = Vector3.new(Pi.X, 0, Pi.Z); local h11 = 1.5; do local tc11 = i.targetPlayer and i.targetPlayer.Character; local hd11 = tc11 and tc11:FindFirstChild("Head"); if hd11 then h11 = math.clamp(hd11.Position.Y - o.Y, 0, 3) end end; local y11 = (Pi.Y + h11 + 3.7) * 19.5 + i.targetVelocity.Y * 0.8; if ni and ni.FloorMaterial ~= Enum.Material.Air then y11 = math.max(y11, 13) end; y11 = math.clamp(y11, -70, 110); if f11.Magnitude > 0.01 then Ji.AssemblyLinearVelocity = Vector3.new(f11.Unit.X * qi, y11, f11.Unit.Z * qi); else Ji.AssemblyLinearVelocity = Vector3.new(0, y11, 0) end; else Ji.AssemblyLinearVelocity = Vector3.new(0, Ji.AssemblyLinearVelocity.Y * 0.5, 0) end; end);
        end;
        _FRHUBV11StartFollowing = gi;
        _FRHUBV11Stop = Si;
        _G.FRHUBSetAimbotV11Core = function(i)
            if i then
                if _G.__FRHUBV11StopSpeedBoost then
                    _G.__FRHUBV11StopSpeedBoost ();
                end;
                if autoplayActive or E.Autoplay then
                    _G.__FRHUBV11StopAutoplay ();
                end;
                ci("Aimbot");
                if _G.__FRHUBV11DeactivateOthers then
                    _G.__FRHUBV11DeactivateOthers ("Aimbot");
                end;
                _G.__FRHUBV11AutoDrop (function() gi(m.Character); end);
            else
                Si();
                if _G.__FRHUBV11RefreshSpeedBoost then
                    _G.__FRHUBV11RefreshSpeedBoost ();
                end;
            end;
        end;
        __v11Stopper (Si);
        v11.enabled = function() return E.Aimbot == true end
        v11.clearVelocity = function()
            zeroRoot(v11.lastRoot)
            local char = LP.Character
            zeroRoot(char and char:FindFirstChild("HumanoidRootPart"))
        end
        v11.start = function()
            if S.destroyed or E.Aimbot then return end
            E.Aimbot = true
            _G.FRHUBSetAimbotV11Core(true)
        end
        v11.stop = function()
            local wasEnabled = E.Aimbot
            E.Aimbot, E["Lagger Aimbot"] = false, false
            if _G.FRHUBSetAimbotV11Core then _G.FRHUBSetAimbotV11Core(false) end
            if wasEnabled then v11.clearVelocity() end
            v11.lastRoot = nil
        end
        v11.dispose = function()
            v11.stop()
            _G.__FRHUB_V11_STATE = nil -- terminate this instance's ping sampler.
        end
        track(LP.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            if not S.destroyed and E.Aimbot and LP.Character == character then
                _FRHUBV11StartFollowing(character)
            end
        end))
    end
    local function clearAimVelocity()
        if v7.clearVelocity then v7.clearVelocity() end
        if v11.clearVelocity then v11.clearVelocity() end
        local character = LP.Character
        zeroRoot(character and character:FindFirstChild("HumanoidRootPart"))
    end
    local function stopEngines()
        v7.stop()
        v11.stop()
        S.activeMode = nil
        clearAimVelocity()
    end
    local function getActiveTarget()
        if S.destroyed or not S.activeMode then return nil end
        local target
        if S.activeMode == "normal" and v7.enabled() then target = v7.target
        elseif S.activeMode == "bypass" and v11.enabled() then
            local player = v11.state and v11.state.targetPlayer
            target = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        end
        local character = target and target.Parent
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if target and humanoid and humanoid.Health > 0 then return target end
        return nil
    end
    local function setAutoBatState(enabled)
        if S.destroyed then return false end
        enabled = enabled == true
        local mode = batAimMode == "bypass" and "bypass" or "normal"
        local engine = mode == "bypass" and v11 or v7
        if enabled and S.activeMode == mode and engine.enabled() then return true end
        -- Always stop BOTH engines: the selected mode may already have changed
        -- before the existing UI calls stopAimbotFull().
        stopEngines()
        if enabled then
            if _G.HorizonStealModes then _G.HorizonStealModes.Suspend() end
            if __HH.stopBodyLock then __HH.stopBodyLock() end
            S.activeMode = mode
            engine.start()
            return engine.enabled()
        end
        if _G.HorizonStealModes then _G.HorizonStealModes.Resume() end
        if __HH.bodyLockEnabled and __HH.startBodyLock then
            task.delay(0.2, function()
                if not S.destroyed and not S.activeMode and __HH.bodyLockEnabled then __HH.startBodyLock() end
            end)
        end
        return false
    end
    S.SetEnabled = setAutoBatState
    S.IsEnabled = function()
        if S.destroyed then return false end
        return (S.activeMode == "normal" and v7.enabled()) or (S.activeMode == "bypass" and v11.enabled()) or false
    end
    S.GetActiveMode = function() return S.activeMode end
    S.GetTarget = getActiveTarget
    S.ClearVelocity = clearAimVelocity
    S.normal, S.bypass = v7, v11
    S.Destroy = function()
        if S.destroyed then return end
        stopEngines()
        S.destroyed = true
        if v11.dispose then v11.dispose() end
        for _, connection in ipairs(S.connections) do pcall(function() connection:Disconnect() end) end
        S.connections = {}
        if ownedMirror and ownedMirror.Destroy then ownedMirror.Destroy() end
    end
    _G.SoundAimbotPort = S
    -- Keep the interfaces already used by carry/drop, Safe Mode, TP DOWN,
    -- keyboard/controller keybinds and the mobile AIM BOT button.
    _G.SoundCursedSetAimbot = setAutoBatState
    _G.SoundCursedGetAimbot = S.IsEnabled
    _G.SoundCursedClearAimVelocity = clearAimVelocity

    -- MIRROR TP DOWN (ported from FR HUB and adapted to Sound's AIM BOT).
    -- It watches the selected FR engine's current target and mirrors any sudden 3-stud
    -- downward move by placing the local root at Sound's TP DOWN level.
    do
        local MIRROR_TP_DROP_THRESHOLD = 3
        local MIRROR_TP_DOWN_Y = -7.00
        local mirrorEnabled = false
        local mirrorTrackedRoot = nil
        local mirrorPreviousY = nil
        local mirrorLastTeleport = 0
        local mirrorHeartbeat = nil
        local mirrorCharacterConn = nil

        local function clearMirrorTracking()
            mirrorTrackedRoot = nil
            mirrorPreviousY = nil
        end

        local function getSoundAimTarget()
            return getActiveTarget()
        end

        local function mirrorTeleportDown()
            local character = LP.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not root or not humanoid or humanoid.Health <= 0 then return end

            local now = tick()
            if now - mirrorLastTeleport < 0.08 then return end
            mirrorLastTeleport = now

            local _, yaw = root.CFrame:ToEulerAnglesYXZ()
            root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z)
                * CFrame.Angles(0, yaw, 0)

            -- Clear both imported engines' owned movement for this TP DOWN step.
            clearAimVelocity()
            root.AssemblyAngularVelocity = Vector3.zero
        end

        local function setMirrorEnabled(on)
            mirrorEnabled = on == true
            if not mirrorEnabled then clearMirrorTracking() end
            if _G.SoundMirrorTPDownSetVisual then
                pcall(_G.SoundMirrorTPDownSetVisual, mirrorEnabled)
            end
            return mirrorEnabled
        end

        pcall(function()
            if _G.SoundMirrorTPDown and _G.SoundMirrorTPDown.Destroy then
                _G.SoundMirrorTPDown.Destroy()
            end
        end)

        mirrorHeartbeat = RunService.Heartbeat:Connect(function()
            if not mirrorEnabled then
                clearMirrorTracking()
                return
            end

            local target = getSoundAimTarget()
            if not target then
                clearMirrorTracking()
                return
            end

            local currentY = target.Position.Y
            if target ~= mirrorTrackedRoot then
                mirrorTrackedRoot = target
                mirrorPreviousY = currentY
                return
            end

            local previousY = mirrorPreviousY
            mirrorPreviousY = currentY
            if previousY and previousY - currentY >= MIRROR_TP_DROP_THRESHOLD then
                mirrorTeleportDown()
                mirrorPreviousY = target.Parent and target.Position.Y or nil
            end
        end)

        mirrorCharacterConn = LP.CharacterAdded:Connect(clearMirrorTracking)

        _G.SoundMirrorTPDown = {
            enabled = function() return mirrorEnabled end,
            setEnabled = setMirrorEnabled,
            getTarget = getSoundAimTarget,
            Destroy = function()
                mirrorEnabled = false
                clearMirrorTracking()
                if mirrorHeartbeat then mirrorHeartbeat:Disconnect(); mirrorHeartbeat = nil end
                if mirrorCharacterConn then mirrorCharacterConn:Disconnect(); mirrorCharacterConn = nil end
            end,
        }
    end


    ownedMirror = _G.SoundMirrorTPDown

    function toggleBatV2()
        local turningOn = not __HH.batV2Enabled
        _G.SoundDropThenAimSafeModeAuthorized = false
        __HH.batV2Enabled = turningOn
        setAutoBatState(turningOn)
        if __HH.batV2SetVisual then __HH.batV2SetVisual(turningOn) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(turningOn) end
        return turningOn
    end
    function stopAimbotFull()
        __HH.batV2Enabled = false
        setAutoBatState(false)
        if __HH.batV2SetVisual then __HH.batV2SetVisual(false) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(false) end
    end
    function queueAutoBatStart()
        __HH.batV2Enabled = true
        setAutoBatState(true)
    end
    function stopBatAimbot()
        setAutoBatState(false)
    end

    -- TP BAT (Clean source / AntiDesync implementation)
    _G.AceAntiDesync = _G.AceAntiDesync or {conn=nil,hittingCooldown=false,h=nil,hrp=nil}
    _G.AceAntiDesyncAimbotOn = false
    antiDesyncAutoSwingEnabled = true

    local CLEAN_BAT_NAMES = {
        "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
        "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
        "Nuclear Slap","Galaxy Slap","Glitched Slap"
    }

    local function getBatAntiDesync()
        local char=LP.Character
        if not char then return nil end
        for _,name in ipairs(CLEAN_BAT_NAMES) do
            local tool=char:FindFirstChild(name)
            if tool and tool:IsA("Tool") then return tool end
        end
        local bp=LP:FindFirstChild("Backpack")
        if bp then
            for _,name in ipairs(CLEAN_BAT_NAMES) do
                local tool=bp:FindFirstChild(name)
                if tool and tool:IsA("Tool") then
                    local hum=char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(tool) end) end
                    return tool
                end
            end
        end
        for _,child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end

    local function trySwingAntiDesync()
        local st=_G.AceAntiDesync
        if st.hittingCooldown then return end
        st.hittingCooldown=true
        pcall(function()
            local bat=getBatAntiDesync()
            if bat then
                if bat.Parent~=LP.Character then
                    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(bat) end) end
                end
                bat:Activate()
                local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
        end)
        task.delay(0.01,function()
            if _G.AceAntiDesync then _G.AceAntiDesync.hittingCooldown=false end
        end)
    end

    local function getClosestPlayerAntiDesync()
        local hrp=_G.AceAntiDesync and _G.AceAntiDesync.hrp
        if not hrp then return nil,math.huge end
        local closest,bestDist=nil,math.huge
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP and plr.Character then
                local tr=plr.Character:FindFirstChild("HumanoidRootPart")
                local ph=plr.Character:FindFirstChildOfClass("Humanoid")
                if tr and ph and ph.Health>0 then
                    local d=(hrp.Position-tr.Position).Magnitude
                    if d<bestDist then bestDist=d;closest=plr end
                end
            end
        end
        return closest,bestDist
    end

    local function setupCharAntiDesync(char)
        task.wait(0.1)
        if not _G.AceAntiDesync then return end
        _G.AceAntiDesync.h=char and char:FindFirstChildOfClass("Humanoid") or nil
        _G.AceAntiDesync.hrp=char and char:FindFirstChild("HumanoidRootPart") or nil
    end

    function startAntiDesyncAimbot()
        if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart() then return false end
        if _G.AceStopAutoTPForAction then _G.AceStopAutoTPForAction() end
        if autoBatEnabled and disableAutoBat then pcall(disableAutoBat) end
        if __HH.batV2Enabled and toggleBatV2 then pcall(toggleBatV2) end
        if autoLeftEnabled and stopAutoLeft then autoLeftEnabled=false;stopAutoLeft() end
        if autoRightEnabled and stopAutoRight then autoRightEnabled=false;stopAutoRight() end
        _G.AceAntiDesyncAimbotOn=true
        if _G.AceAntiDesync.conn then _G.AceAntiDesync.conn:Disconnect();_G.AceAntiDesync.conn=nil end
        if LP.Character then task.spawn(function() setupCharAntiDesync(LP.Character) end) end
        _G.AceAntiDesync.conn=RunService.Heartbeat:Connect(function()
            local st=_G.AceAntiDesync
            if not (_G.AceAntiDesyncAimbotOn and st.h and st.hrp) then return end
            local target=getClosestPlayerAntiDesync()
            if target and target.Character then
                local tr=target.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    if sethiddenproperty then pcall(function() sethiddenproperty(st.hrp,"PhysicsRepRootPart",tr) end) end
                    local targetPos=tr.Position+Vector3.new(0,0.9,0)
                    if (st.hrp.Position-targetPos).Magnitude>8 then st.hrp.CFrame=CFrame.new(targetPos) end
                    local cam=workspace.CurrentCamera
                    if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,tr.Position) end
                    if antiDesyncAutoSwingEnabled then trySwingAntiDesync() end
                end
            end
        end)
        if __HH.tpLockSetVisual then __HH.tpLockSetVisual(true) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.tpLock then __HH.mobBtnRefs.tpLock(true) end
        return true
    end

    function stopAntiDesyncAimbot()
        _G.AceAntiDesyncAimbotOn=false
        if _G.AceAntiDesync and _G.AceAntiDesync.conn then
            _G.AceAntiDesync.conn:Disconnect();_G.AceAntiDesync.conn=nil
        end
        if _G.AceAntiDesync then _G.AceAntiDesync.hittingCooldown=false end
        if sethiddenproperty and _G.AceAntiDesync and _G.AceAntiDesync.hrp then
            pcall(function() sethiddenproperty(_G.AceAntiDesync.hrp,"PhysicsRepRootPart",nil) end)
        end
        local cam=workspace.CurrentCamera
        if cam and LP.Character then
            local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then cam.CFrame=CFrame.new(cam.CFrame.Position,hrp.Position) end
        end
        if __HH.tpLockSetVisual then __HH.tpLockSetVisual(false) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.tpLock then __HH.mobBtnRefs.tpLock(false) end
    end

    function toggleAntiDesyncAimbot()
        if _G.AceAntiDesyncAimbotOn then stopAntiDesyncAimbot() else startAntiDesyncAimbot() end
        return _G.AceAntiDesyncAimbotOn
    end

    startTPLock=startAntiDesyncAimbot
    stopTPLock=stopAntiDesyncAimbot
    toggleTPLock=toggleAntiDesyncAimbot
    LP.CharacterAdded:Connect(function(char)
        task.spawn(function() setupCharAntiDesync(char) end)
        if _G.AceAntiDesyncAimbotOn then
            task.wait(0.5)
            if not _G.AceAntiDesync.conn then startAntiDesyncAimbot() end
        end
    end)
    if LP.Character then task.spawn(function() setupCharAntiDesync(LP.Character) end) end
    _G.AceAntiDesyncStart=startAntiDesyncAimbot
    _G.AceAntiDesyncStop=stopAntiDesyncAimbot
    _G.AceAntiDesyncToggle=toggleAntiDesyncAimbot

    _G.SoundTPBatV4Start = startAntiDesyncAimbot
    _G.SoundTPBatV4Stop = stopAntiDesyncAimbot
    _G.SoundTPBatV4Toggle = toggleAntiDesyncAimbot

end


-- BAT SPAM (ported from FR HUB).
-- Uses FR's activation loop, close-range double swing and watchdog behavior.
do
    local S = {enabled=false, thread=nil, delay=50, watchdog=nil}

    local function getEquippedBat()
        local character = LP.Character
        if not character then return nil end
        local bat = character:FindFirstChild("bat") or character:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") and bat.Parent == character then return bat end
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("bat") or name:find("slap") then return tool end
            end
        end
        return nil
    end

    local function getNearestDistance(root)
        local nearest = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                    local distance = (targetRoot.Position - root.Position).Magnitude
                    if distance < nearest then nearest = distance end
                end
            end
        end
        return nearest
    end

    local function runSpamLoop()
        if S.thread then return end
        S.thread = task.spawn(function()
            while S.enabled do
                pcall(function()
                    local character = LP.Character
                    local bat = getEquippedBat()
                    if character and bat then
                        bat:Activate()
                        local root = character:FindFirstChild("HumanoidRootPart")
                        if root and getNearestDistance(root) < 6 then
                            task.wait(0.02)
                            if bat.Parent == character then bat:Activate() end
                        end
                    end
                end)
                task.wait(S.delay / 1000)
            end
            S.thread = nil
        end)
    end

    local function startBatSpam()
        S.enabled = true
        runSpamLoop()
        if not S.watchdog then
            S.watchdog = task.spawn(function()
                while S.enabled do
                    task.wait(0.6)
                    if S.enabled and not S.thread then runSpamLoop() end
                end
                S.watchdog = nil
            end)
        end
    end

    local function stopBatSpam()
        S.enabled = false
        if S.thread then pcall(task.cancel, S.thread); S.thread = nil end
        if S.watchdog then pcall(task.cancel, S.watchdog); S.watchdog = nil end
    end

    local function setBatSpamEnabled(on)
        if on == true then startBatSpam() else stopBatSpam() end
        if _G.SoundBatSpamSetVisual then pcall(_G.SoundBatSpamSetVisual, S.enabled) end
        return S.enabled
    end

    pcall(function()
        if _G.SoundBatSpam and _G.SoundBatSpam.Destroy then _G.SoundBatSpam.Destroy() end
    end)

    _G.SoundBatSpam = {
        enabled = function() return S.enabled end,
        setEnabled = setBatSpamEnabled,
        Destroy = function() stopBatSpam() end,
    }
end

__HH.guiTransparencyEnabled = false
__HH.selectedDevice = "MOBILE" -- locked to MOBILE (no device picker)
__HH.mobileButtonsEnabled = true
__HH.mobileButtonsSize = 80
__HH.circleButtonsEnabled = false
__HH.shapeButtonsEnabled = false
__HH.rectangularButtonsEnabled = false
__HH.mobBtnRefs = {}
local apExtSetLeft  = nil   -- visual updater for external LEFT btn
local apExtSetRight = nil   -- visual updater for external RIGHT btn
-- Mobile tab: per-button visibility (true = show, false = hidden)
__HH.buttonVisibility = {
    drop=true, tpDown=true, batV1=true, batV2=true, tpLock=true,
    lagger=true, laggerCarry=true, carrySpeed=true,
    instaReset=true,
}
-- Auto drop + aimbot when TP BAT / BAT V2 enabled while carrying (always on)
local function refreshAPExtBtns()
    local COL_ON  = Color3.fromRGB(205, 149, 255)
    local COL_OFF = Color3.fromRGB(46, 26, 64)
    if apExtSetLeft  then apExtSetLeft (autoLeftEnabled and COL_ON or COL_OFF) end
    if apExtSetRight then apExtSetRight(autoRightEnabled and COL_ON or COL_OFF) end
end
__HH.mobGuiRef = nil
__HH.infJumpMode = "manual"
__HH.holdInfJumpConn = nil
__HH.uiLocked = false
__HH.perButtonDragEnabled = true

__HH.BTN_OFF = Color3.fromRGB(26, 8, 42)
__HH.BTN_ON = Color3.fromRGB(138, 32, 232)
__HH.TEXT_OFF = Color3.fromRGB(239, 220, 255)
__HH.TEXT_ON = Color3.fromRGB(255, 255, 255)

__HH.iceSectionEffects = setmetatable({}, {__mode = "k"})
__HH.setIceSectionActive = function(button, isActive)
    if not button then return end
    local effect = __HH.iceSectionEffects[button]

    if not effect then
        local underline = Instance.new("Frame", button)
        underline.Name = "SoundBlueUnderline"
        underline.AnchorPoint = Vector2.new(0.5, 1)
        underline.Size = UDim2.new(0.84, 0, 0, 2)
        underline.Position = UDim2.new(0.5, 0, 1, 6)
        underline.BackgroundColor3 = Color3.fromRGB(192, 120, 255)
        underline.BorderSizePixel = 0
        underline.ZIndex = 15

        local ulGrad = Instance.new("UIGradient", underline)
        ulGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(128, 25, 220)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(225, 248, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(128, 25, 220))
        })
        ulGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.85),
            NumberSequenceKeypoint.new(0.25, 0.10),
            NumberSequenceKeypoint.new(0.50, 0.00),
            NumberSequenceKeypoint.new(0.75, 0.10),
            NumberSequenceKeypoint.new(1.00, 0.85)
        })

        local glow = Instance.new("Frame", button)
        glow.Name = "SoundBlueUnderlineGlow"
        glow.AnchorPoint = Vector2.new(0.5, 1)
        glow.Size = UDim2.new(0.96, 0, 0, 8)
        glow.Position = UDim2.new(0.5, 0, 1, 9)
        glow.BackgroundColor3 = Color3.fromRGB(158, 48, 255)
        glow.BorderSizePixel = 0
        glow.ZIndex = 14
        Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

        effect = {underline = underline, glow = glow}
        __HH.iceSectionEffects[button] = effect
    end

    if isActive then
        effect.underline.Visible = true
        effect.glow.Visible = true
        effect.glow.BackgroundTransparency = 0.62
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        effect.underline.Visible = false
        effect.glow.Visible = false
        button.TextColor3 = Color3.fromRGB(215, 196, 232)
    end
end

__HH.KB = {
    DropBrainrot  = {kb = Enum.KeyCode.X,           gp = nil},
    
    TPLock        = {kb = Enum.KeyCode.E,           gp = nil},
    TPFloor       = {kb = Enum.KeyCode.F,           gp = nil},
    GuiHide       = {kb = Enum.KeyCode.LeftControl, gp = nil},
    SpeedToggle   = {kb = Enum.KeyCode.Q,           gp = nil},
    -- Frame Reset uses its original R key. Lagger moves to the old reset key
    -- so the two actions never fire from the same keyboard input.
    LaggerToggle  = {kb = Enum.KeyCode.G,           gp = nil},
    InstaReset    = {kb = Enum.KeyCode.R,           gp = nil},
    AutoLeft      = {kb = Enum.KeyCode.Z,           gp = nil},
    AutoRight     = {kb = Enum.KeyCode.C,           gp = nil},
    BatV2Toggle   = {kb = Enum.KeyCode.V,           gp = nil}
}

__HH.isGamepadInput = function(inp)
    if not inp then return false end
    if inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") then return true end
    return false
end

__HH.isBindableInput = function(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return __HH.isGamepadInput(inp)
end

end
do
local CONTROLLER_BUTTONS = {
    [Enum.KeyCode.ButtonA]      = "A",       [Enum.KeyCode.ButtonB]      = "B",
    [Enum.KeyCode.ButtonX]      = "X",       [Enum.KeyCode.ButtonY]      = "Y",
    [Enum.KeyCode.ButtonL1]     = "LB",      [Enum.KeyCode.ButtonR1]     = "RB",
    [Enum.KeyCode.ButtonL2]     = "LT",      [Enum.KeyCode.ButtonR2]     = "RT",
    [Enum.KeyCode.ButtonL3]     = "LS",      [Enum.KeyCode.ButtonR3]     = "RS",
    [Enum.KeyCode.ButtonStart]  = "START",   [Enum.KeyCode.ButtonSelect] = "SELECT",
    [Enum.KeyCode.DPadUp]       = "DPAD_UP", [Enum.KeyCode.DPadLeft]     = "DPAD_LEFT",
    [Enum.KeyCode.DPadRight]    = "DPAD_RIGHT"
}

__HH.getKeyDisplayName = function(key, isGp)
    if isGp and CONTROLLER_BUTTONS[key] then return CONTROLLER_BUTTONS[key] end
    return key and key.Name or "None"
end

__HH.kbMatch = function(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

local laggerState = {enabled = false, thread = nil, waitTime = 0.25, intensity = 270}
local isTouchEnabled = __HH.UIS.TouchEnabled
if isTouchEnabled then laggerState.waitTime = 5.8 end
local _laggerActive = false

local function createNestedTable(amount)
    local nested = {{}}; local current = nested[1]
    for i = 1, amount do local t = {}; table.insert(current, t); current = t end
    return nested
end

local function sendLagSpam()
    local nested = createNestedTable(laggerState.intensity)
    local payload = {}
    local maxCopies = math.min(499999 / (laggerState.intensity + 2), 1500)
    for i = 1, maxCopies do table.insert(payload, nested) end
    pcall(function()
        local r = game:GetService("RobloxReplicatedStorage"):FindFirstChild("SetPlayerBlockList")
        if r then r:FireServer(payload) end
    end)
end

local function removeNetworkLimit()
    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
end

local function startLaggerEngine()
    if laggerState.thread then task.cancel(laggerState.thread); laggerState.thread = nil end
    laggerState.enabled = true
    laggerState.thread = task.spawn(function()
        while laggerState.enabled do removeNetworkLimit(); sendLagSpam(); task.wait(laggerState.waitTime) end
    end)
end

local function stopLaggerEngine()
    laggerState.enabled = false
    if laggerState.thread then task.cancel(laggerState.thread); laggerState.thread = nil end
end

local AP_L1, AP_L2 = Vector3.new(-476.48,-6.28,92.73), Vector3.new(-483.12,-4.95,94.80)
local AP_R1, AP_R2 = Vector3.new(-476.16,-6.52,25.62), Vector3.new(-483.06,-5.03,25.48)

-- ============================================
-- ============================================
-- SPEED SYSTEM (LinearVelocity-based)
-- ============================================
NS = 60
CS = 30
LAGGER_SPEED = 13
LAGGER_CARRY_SPEED = 13

carrySpeedActive = false
laggerModeEnabled = false
laggerCarryToggled = false
laggerPhase = 0
speedMode = false
autoCarrySpeedEnabled = false
setAutoCarrySpeedVisual = nil

local lastMoveDir = Vector3.new(0, 0, 0)
local MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true
}

local AutoCarry = {
    _autoCarryFromSteal = false,
    _autoCarryGraceUntil = 0,
    _waitingForCarryPickup = false,
    _carryPickupWatchUntil = 0,
    _autoCarryReturnMode = nil,
}

local _spdLV = nil
local _spdAtt = nil
local _vertAtt = nil
local _vertLV = nil
local _stealAttrWasActive = false

local function isCarryName(name)
    local n = tostring(name or ""):lower()
    return n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold")
end

local function isIgnoredCarryTool(name)
    local n = tostring(name or ""):lower()
    return n:find("bat") or n:find("slap") or n:find("medusa") or n:find("head") or n:find("stone")
end

__HH.isCarryingBrainrot = function(char)
    if not char then return false end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then return true end
            if isCarryName(child.Name) then return true end
        elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
            return true
        end
    end
    return false
end

function destroySpeedLV()
    if _spdLV and _spdLV.Parent then _spdLV:Destroy() end
    if _spdAtt and _spdAtt.Parent then _spdAtt:Destroy() end
    _spdLV, _spdAtt = nil, nil
end

local function setupSpeedLV(hrp)
    destroySpeedLV()
    _spdAtt = Instance.new("Attachment", hrp)
    _spdAtt.Name = "NovaHubSpeedAtt"
    _spdLV = Instance.new("LinearVelocity", hrp)
    _spdLV.Name = "NovaHubSpeedLV"
    _spdLV.Attachment0 = _spdAtt
    _spdLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    _spdLV.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    _spdLV.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    _spdLV.MaxForce = math.huge
    _spdLV.RelativeTo = Enum.ActuatorRelativeTo.World
end

function destroyVertLV()
    if _vertLV and _vertLV.Parent then _vertLV:Destroy() end
    if _vertAtt and _vertAtt.Parent then _vertAtt:Destroy() end
    _vertLV, _vertAtt = nil, nil
end

local function getVertLV(root)
    if not _vertLV or _vertLV.Parent ~= root then
        destroyVertLV()
        _vertAtt = Instance.new("Attachment", root)
        _vertLV = Instance.new("LinearVelocity", root)
        _vertLV.Attachment0 = _vertAtt
        _vertLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        _vertLV.MaxForce = math.huge
        _vertLV.RelativeTo = Enum.ActuatorRelativeTo.World
    end
    return _vertLV
end

local function driveHorizontal(root, dir, spd)
    if not dir or dir.Magnitude <= 0.1 then
        return
    end
    root.Velocity = Vector3.new(dir.X * spd, root.Velocity.Y, dir.Z * spd)
end

function drive3D(root, vel)
    local lv = getVertLV(root)
    lv.VectorVelocity = vel
end

local _nearBrainrotAt, _nearBrainrotValue = 0, false
local function isNearBrainrot(char)
    -- The actual stealable Brainrots have a ProximityPrompt, so detect the prompt itself
    -- instead of relying only on the model's display name.
    if tick() - _nearBrainrotAt < 0.15 then return _nearBrainrotValue end
    _nearBrainrotAt = tick(); _nearBrainrotValue = false
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local holder = obj.Parent
            local part = holder and (holder:IsA("BasePart") and holder or holder:FindFirstAncestorWhichIsA("BasePart"))
            if part and (part.Position - root.Position).Magnitude <= 11 then
                _nearBrainrotValue = true
                return true
            end
        end
    end
    return false
end

local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end

-- Auto Carry Speed Logic
local function setCarrySpeedMode(on)
    carrySpeedActive = on == true
    speedMode = on == true
end

local function enableCarrySpeedForSteal()
    AutoCarry._waitingForCarryPickup = false
    AutoCarry._carryPickupWatchUntil = 0
    if not AutoCarry._autoCarryFromSteal then
        -- Keep the selected speed family, so Lagger switches to Lagger Carry.
        AutoCarry._autoCarryReturnMode = laggerCarryToggled and "Lagger Carry"
            or (laggerModeEnabled and "Lagger")
            or (carrySpeedActive and "Carry")
            or "Normal"
    end
    AutoCarry._autoCarryFromSteal = true
    AutoCarry._autoCarryGraceUntil = tick() + 0.75

    if AutoCarry._autoCarryReturnMode == "Lagger" or AutoCarry._autoCarryReturnMode == "Lagger Carry" then
        laggerModeEnabled = false
        carrySpeedActive = false
        laggerCarryToggled = true
        laggerPhase = 2
        speedMode = false
    else
        setCarrySpeedMode(true)
    end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
end

local function disableAutoCarrySpeed()
    if not AutoCarry._autoCarryFromSteal and not AutoCarry._waitingForCarryPickup then return end
    local wasAutoApplied = AutoCarry._autoCarryFromSteal
    local returnMode = AutoCarry._autoCarryReturnMode
    AutoCarry._autoCarryFromSteal = false
    AutoCarry._waitingForCarryPickup = false
    if not wasAutoApplied then return end
    if returnMode == "Lagger Carry" then
        laggerModeEnabled, laggerCarryToggled, carrySpeedActive, speedMode = false, true, false, false
        laggerPhase = 2
    elseif returnMode == "Lagger" then
        laggerModeEnabled, laggerCarryToggled, carrySpeedActive, speedMode = true, false, false, false
        laggerPhase = 1
    elseif returnMode == "Carry" then
        laggerModeEnabled, laggerCarryToggled, carrySpeedActive, speedMode = false, false, true, true
        laggerPhase = 0
    else
        laggerModeEnabled, laggerCarryToggled, carrySpeedActive, speedMode = false, false, false, false
        laggerPhase = 0
    end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
end

-- Main Speed Loop (direct velocity)
RunService.RenderStepped:Connect(function()
    -- Auto carry speed detection
    if autoCarrySpeedEnabled then
        local aChar = LP.Character
        local aHum = aChar and aChar:FindFirstChildOfClass("Humanoid")
        if aChar and aHum then
            local gotHit = isRagdollState(aHum)
            local stealingAttr = LP:GetAttribute("Stealing") == true
            local nearBrainrot = isNearBrainrot(aChar)
            local carryingBrainrot = __HH.isCarryingBrainrot(aChar) or nearBrainrot
            -- Auto Switch Speed immediately enables Carry Speed as soon as a steal prompt is nearby.
            if nearBrainrot and not AutoCarry._autoCarryFromSteal then enableCarrySpeedForSteal() end
            if stealingAttr and not _stealAttrWasActive then
                _stealAttrWasActive = true
                enableCarrySpeedForSteal()
            elseif not stealingAttr then
                _stealAttrWasActive = false
            end
            if AutoCarry._waitingForCarryPickup then
                if gotHit or tick() > (AutoCarry._carryPickupWatchUntil or 0) then
                    AutoCarry._waitingForCarryPickup = false
                elseif carryingBrainrot then
                    enableCarrySpeedForSteal()
                end
            end
            if carryingBrainrot and not AutoCarry._autoCarryFromSteal then enableCarrySpeedForSteal() end
            if AutoCarry._autoCarryFromSteal then
                if gotHit or (tick() > AutoCarry._autoCarryGraceUntil and not carryingBrainrot and not stealingAttr) then
                    disableAutoCarrySpeed()
                end
            end
        end
    end

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if isRagdollState(hum) then
        _G.SoundRagdollKilledCarry = true
        lastMoveDir = Vector3.new(0, 0, 0)
        return
    end

    -- don't interfere with tpLock / batV2 / aimbot
    if __HH.tpLockEnabled or autoLeftEnabled or autoRightEnabled or __HH.batV2Enabled or autoBatEnabled or __HH.dropActive then
        return
    end

    local md = hum.MoveDirection
    local spd = getActiveMoveSpeed()
    local moving = false

    if md.Magnitude > 0 then
        lastMoveDir = md
        moving = true
        driveHorizontal(hrp, md, spd)
    elseif __HH.antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
        local anyHeld = false
        for key in pairs(MOVE_KEYS) do
            if __HH.UIS:IsKeyDown(key) then anyHeld = true; break end
        end
        if anyHeld then
            moving = true
            driveHorizontal(hrp, lastMoveDir, spd)
        end
    end

    -- when not moving, don't set velocity (matches YOUSEF67 approach)
end)

function toggleCarryMode()
    if laggerModeEnabled or laggerCarryToggled then
        laggerModeEnabled = false; laggerCarryToggled = false; laggerPhase = 0
        carrySpeedActive = true; speedMode = true
    else
        carrySpeedActive = not carrySpeedActive
        speedMode = carrySpeedActive
    end
    refreshSpeedModeLabel()
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    carrySpeedActive = false; speedMode = false
    laggerModeEnabled = not laggerModeEnabled
    laggerPhase = laggerModeEnabled and 1 or 0
    refreshSpeedModeLabel()
end

function toggleLaggerCarryMode()
    if laggerModeEnabled then laggerModeEnabled = false; laggerPhase = 0 end
    carrySpeedActive = false; speedMode = false
    laggerCarryToggled = not laggerCarryToggled
    if laggerCarryToggled then laggerPhase = 2 else laggerPhase = 0 end
    refreshSpeedModeLabel()
end

refreshSpeedModeLabel = function()
    if modeValLbl then
        if laggerCarryToggled then modeValLbl.Text="Lagger Carry"
        elseif laggerModeEnabled then modeValLbl.Text="Lagger"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(230, 201, 255) or Color3.fromRGB(0,0,0),BackgroundTransparency=on and 0.4 or 0.85}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(230, 201, 255) or Color3.fromRGB(150,150,150)}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(230, 201, 255) or Color3.fromRGB(0,0,0),BackgroundTransparency=on and 0.4 or 0.85}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(230, 201, 255) or Color3.fromRGB(150,150,150)}):Play()
    end
    if __HH.mobBtnRefs and __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
    if __HH.mobBtnRefs and __HH.mobBtnRefs.lagger then __HH.mobBtnRefs.lagger(laggerModeEnabled) end
    if __HH.mobBtnRefs and __HH.mobBtnRefs.laggerCarry then __HH.mobBtnRefs.laggerCarry(laggerCarryToggled) end
end

-- ============ FR HUB ROUND 3 SPEED BOOST (add-on) ============
-- This is ONLY an addition on top of the Sound speed system.
-- Engine: direct Velocity like FR Hub. Normalized MoveDirection so the
-- full speed is reached even with a partial mobile joystick.
do
    local R3Boost = {
        enabled = false,
        carrySpeed = 32,
        normalSpeed = 62,
        forceCarry = false,
    }
    pcall(function()
        if not (isfile and readfile and isfile("Round3SpeedBooster6_Config.json")) then return end
        local raw = readfile("Round3SpeedBooster6_Config.json")
        local cfg = game:GetService("HttpService"):JSONDecode(raw)
        if type(cfg) == "table" then
            if type(cfg.carrySpeed) == "number" and cfg.carrySpeed > 0 then R3Boost.carrySpeed = cfg.carrySpeed end
            if type(cfg.normalSpeed) == "number" and cfg.normalSpeed > 0 then R3Boost.normalSpeed = cfg.normalSpeed end
        end
    end)

    local Bridge = {
        Enabled = R3Boost.enabled,
        NormalSpeed = R3Boost.normalSpeed,
        CarrySpeed = R3Boost.carrySpeed,
        CarryMode = false,
        ForceCarry = false,
        Force = true,
    }
    _G.Round3SpeedBooster = Bridge

    local function syncBridge()
        Bridge.Enabled = R3Boost.enabled
        Bridge.NormalSpeed = R3Boost.normalSpeed
        Bridge.CarrySpeed = R3Boost.carrySpeed
        Bridge.CarryMode = R3Boost.forceCarry
        Bridge.ForceCarry = R3Boost.forceCarry
    end
    local function saveR3()
        pcall(function()
            if writefile then
                writefile("Round3SpeedBooster6_Config.json", game:GetService("HttpService"):JSONEncode({
                    carrySpeed = R3Boost.carrySpeed,
                    normalSpeed = R3Boost.normalSpeed,
                }))
            end
        end)
    end
    Bridge.setNormalSpeed = function(value)
        value = tonumber(value)
        if not value or value <= 0 then return end
        R3Boost.normalSpeed = value
        syncBridge(); saveR3()
    end
    Bridge.setCarrySpeed = function(value)
        value = tonumber(value)
        if not value or value <= 0 then return end
        R3Boost.carrySpeed = value
        syncBridge(); saveR3()
    end
    Bridge.setForceCarry = function(on)
        R3Boost.forceCarry = on == true
        syncBridge()
    end
    Bridge.setEnabled = function(on)
        R3Boost.enabled = on == true
        if not R3Boost.enabled then R3Boost.forceCarry = false end
        syncBridge()
    end
    local function getR3BoostSpeed()
        if not R3Boost.enabled then return R3Boost.normalSpeed end
        return R3Boost.forceCarry and R3Boost.carrySpeed or R3Boost.normalSpeed
    end
    syncBridge()

    RunService.RenderStepped:Connect(function()
        if not R3Boost.enabled then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        -- let the other movement features own the player while they run
        if __HH.tpLockEnabled or autoLeftEnabled or autoRightEnabled or __HH.batV2Enabled or autoBatEnabled or __HH.dropActive then return end
        local md = hum.MoveDirection
        local spd = getR3BoostSpeed()
        if md.Magnitude > 0.01 then
            -- normalize: mobile joystick gives partial magnitude, which is
            -- why 62 used to feel like ~34. Unit vector = full speed.
            md = md.Unit
            hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
        else
            hrp.Velocity = Vector3.zero
        end
        if R3Boost.forceCarry ~= carrySpeedActive then
            carrySpeedActive = R3Boost.forceCarry
            speedMode = carrySpeedActive
            if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        end
    end)
end

-- R3-aware overrides: when the FR boost is enabled, the Sound velocity loop
-- and the CARRY SPD button drive the FR speeds instead of the Sound ones.
-- Wrapped in do..end so the chunk-level local limit (200) is untouched.
do
    local soundGet = getActiveMoveSpeed
    local soundToggleCarry = toggleCarryMode
    function getActiveMoveSpeed()
        local b = _G.Round3SpeedBooster
        if b and b.Enabled == true then
            return (b.ForceCarry == true) and b.CarrySpeed or b.NormalSpeed
        end
        return soundGet()
    end
    function toggleCarryMode()
        local b = _G.Round3SpeedBooster
        if b and b.Enabled == true then
            if b.setForceCarry then b.setForceCarry(not (b.ForceCarry == true)) end
            carrySpeedActive = (b.ForceCarry == true)
            speedMode = carrySpeedActive
            refreshSpeedModeLabel()
            return
        end
        soundToggleCarry()
    end
end

-- ============================================

-- ============================================================
-- ANTI RAGDOLL (VisDuels version)
-- ============================================================
do
    local visAntiConn = nil
    local visResetCooldown = 0

    local function visForceReset()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") then obj.Enabled = true end
                if obj:IsA("Constraint") then obj.Enabled = true end
            end
            if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end
            local ps = LP:FindFirstChild("PlayerScripts")
            local pm = ps and ps:FindFirstChild("PlayerModule")
            local cm = pm and pm:FindFirstChild("ControlModule")
            if cm then local controls = require(cm); if controls then controls:Enable() end end
            hum.AutoRotate = true
            hum.PlatformStand = false
            hum.Sit = false
        end)
    end

    __HH.stopAntiRagdoll = function()
        if visAntiConn then visAntiConn:Disconnect(); visAntiConn = nil end
    end

    __HH.startAntiRagdoll = function()
        __HH.stopAntiRagdoll()
        if not __HH.antiRagdollEnabled then return end
        visAntiConn = RunService.Heartbeat:Connect(function()
            if not __HH.antiRagdollEnabled then return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end
            local state = hum:GetState()
            local ragdolled = state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
            if ragdolled and tick() - visResetCooldown > 0.15 then
                visResetCooldown = tick()
                visForceReset()
            end
        end)
    end

    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if __HH.antiRagdollEnabled then __HH.startAntiRagdoll() end
    end)
end

-- Instant Reset (Nexus Hub port from Lord Hub): camera-lock + collision strip +
-- HipHeight spike until respawn, hard-kill fallback. Replaces the old void-teleport reset.
end
do
__HH.FrameReset = {}
do
    -- Nexus Hub instant reset (ported from Lord Hub):
    -- camera lock + collision strip + giant HipHeight until respawn is
    -- detected, with a hard-kill fallback if the char refuses to die.
    local camLocked          = false
    local lockedCamCFrame    = nil
    local resetCooldown      = false
    local resetThread        = nil
    local resetStop          = false
    local respawnConn        = nil
    local runtimeAlive       = true
    local deathResetEnabled  = false
    local deathResetThread   = nil
    local INSTANT_RESET_STEP = 0.05

    local function ResetPlayer()
        if resetCooldown then return end
        resetCooldown = true
        resetStop = false
        camLocked = false

        -- Clear anti-die connections so the character can actually die/respawn.
        for _, conn in pairs(__HH.antiDieConns) do pcall(function() conn:Disconnect() end) end
        __HH.antiDieConns = {}

        local character = LP.Character
        if not character then
            resetCooldown = false
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            resetCooldown = false
            return
        end

        local camera = workspace.CurrentCamera
        if camera then
            lockedCamCFrame = camera.CFrame
            camLocked = true
            camera.CFrame = lockedCamCFrame
        end

        local ok = false
        local isRespawning = false

        resetThread = task.spawn(function()
            local attempts = 0
            local maxAttempts = 40
            local originalHipHeight = humanoid.HipHeight

            while character and character.Parent
                and humanoid and humanoid.Health > 0
                and not isRespawning
                and not resetStop do

                if LP.Character ~= character then
                    isRespawning = true
                    break
                end

                pcall(function()
                    humanoid.HipHeight = 1e30
                    humanoid.AutoRotate = true

                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CanCollide = false
                    end

                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end)

                if not character or not character.Parent
                    or not humanoid or humanoid.Health <= 0
                    or LP.Character ~= character then
                    ok = true
                    break
                end

                attempts = attempts + 1
                if attempts >= maxAttempts then break end
                task.wait(INSTANT_RESET_STEP)
            end

            if not ok
                and not resetStop
                and character and character.Parent
                and humanoid and humanoid.Health > 0
                and not isRespawning then

                pcall(function()
                    humanoid.Health = 0
                end)

                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then
                    ok = true
                end
            end

            if not ok and character and character.Parent and humanoid then
                pcall(function()
                    humanoid.HipHeight = originalHipHeight

                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CanCollide = true
                    end

                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end)
            end

            camLocked = false
            resetCooldown = false
            resetThread = nil
            resetStop = false
        end)

        if respawnConn then respawnConn:Disconnect() end
        respawnConn = LP.CharacterAdded:Connect(function(newChar)
            if respawnConn then respawnConn:Disconnect(); respawnConn = nil end
            camLocked = false
            resetCooldown = false
            if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
            local newHum = newChar:WaitForChild("Humanoid", 3)
            pcall(function()
                if camera then
                    camera.CameraSubject = newHum
                    camera.CameraType = Enum.CameraType.Custom
                end
            end)
        end)
    end

    local function StopResetSequence()
        resetStop = true
        if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
        camLocked = false
        resetCooldown = false
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera
        if hum and cam then
            pcall(function() cam.CameraSubject = hum; cam.CameraType = Enum.CameraType.Custom end)
        end
    end

    -- camera lock (Nexus RenderStepped style)
    RunService.RenderStepped:Connect(function()
        if camLocked and lockedCamCFrame and workspace.CurrentCamera then
            workspace.CurrentCamera.CFrame = lockedCamCFrame
        end
    end)

    local function ToggleDeathReset(enable)
        deathResetEnabled = enable == true
        if deathResetEnabled and not deathResetThread then
            deathResetThread = task.spawn(function()
                local cooldown = 0
                while runtimeAlive and deathResetEnabled do
                    task.wait(0.1)
                    local char = LP.Character
                    if not char then
                        if tick() - cooldown > 2 then
                            cooldown = tick()
                            ResetPlayer()
                        end
                    else
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health <= 0 and tick() - cooldown > 0 then
                            cooldown = tick()
                            ResetPlayer()
                            task.wait(0.1)
                        end
                    end
                end
                deathResetThread = nil
            end)
        elseif not deathResetEnabled and deathResetThread then
            task.cancel(deathResetThread)
            deathResetThread = nil
        end
    end

    __HH.FrameReset.ResetPlayer = ResetPlayer
    __HH.FrameReset.StopResetSequence = StopResetSequence
    __HH.FrameReset.ToggleDeathReset = ToggleDeathReset
    __HH.FrameReset.Destroy = function()
        runtimeAlive = false
        ToggleDeathReset(false)
        StopResetSequence()
    end
end

pcall(function()
    if _G.SoundFrameReset and _G.SoundFrameReset.Destroy then
        _G.SoundFrameReset.Destroy()
    end
end)
_G.SoundFrameReset = __HH.FrameReset

__HH.stopAntiDie = function()
    for _, conn in pairs(__HH.antiDieConns) do pcall(function() conn:Disconnect() end) end
    __HH.antiDieConns = {}
end

__HH.startAntiDie = function()
    __HH.stopAntiDie()
    if not __HH.antiDieEnabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hum.BreakJointsOnDeath = false
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    table.insert(__HH.antiDieConns, hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then
            hum.Health = hum.MaxHealth
        end
    end))

    table.insert(__HH.antiDieConns, hum.Died:Connect(function()
        task.wait()
        local newHum = Instance.new("Humanoid")
        newHum.Name = "ReplacedHumanoid"
        newHum.Parent = char
        workspace.CurrentCamera.CameraSubject = newHum
        hum:Destroy()
    end))
end

-- Frame Reset automatic reset-on-death integration.
__HH.autoResetOnDeath = false
__HH.setAutoResetOnDeathVisual = nil
__HH.setupDeathReset = function()
    __HH.FrameReset.ToggleDeathReset(__HH.autoResetOnDeath)
end

RunService.Stepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)


-- ========== AUTO LEFT / AUTO RIGHT (FULL FRHUB PORT) ==========
-- Sound's old path backend is gone. This block carries FRHUB's complete path
-- coordinates, two-phase controller, speed selection, LinearVelocity driver,
-- completion behavior, stop behavior, visual sync and toggle functions.
-- The scope releases all internal helper registers after this backend is built.
do
local FRHubAutoPathPOS = {
    L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80),
    R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.04,-5.09,23.14),
}
local FRHubAutoPathConns = {autoLeft=nil, autoRight=nil}
local FRHubAutoLeftPhase, FRHubAutoRightPhase = 1, 1

local function getFRHubAutoMoveSpeed()
    if laggerCarryToggled then return NS
    elseif laggerModeEnabled then return LAGGER_SPEED
    else return NS end
end

-- Dedicated copy of the horizontal branch used by FRHUB's _setV helper. It
-- prevents Sound's normal speed actuator from replacing the Auto Path force.
local FRHubAutoVelocityCache = setmetatable({}, {__mode="k"})
local function destroyFRHubAutoVelocity(root)
    local cached=FRHubAutoVelocityCache[root]
    if cached then
        pcall(function() if cached[1] and cached[1].Parent then cached[1]:Destroy() end end)
        pcall(function() if cached[2] and cached[2].Parent then cached[2]:Destroy() end end)
        FRHubAutoVelocityCache[root]=nil
    end
end
local function getFRHubAutoVelocity(root)
    local cached=FRHubAutoVelocityCache[root]
    local lv=cached and cached[1]
    if lv and lv.Parent==root then return lv end
    destroyFRHubAutoVelocity(root)
    local attachment=Instance.new("Attachment"); attachment.Name="FRHubAutoPathAttachment"; attachment.Parent=root
    lv=Instance.new("LinearVelocity")
    lv.Name="FRHubAutoPathVelocity"
    lv.Attachment0=attachment
    lv.VelocityConstraintMode=Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis=Vector3.new(1,0,0)
    lv.SecondaryTangentAxis=Vector3.new(0,0,1)
    lv.MaxForce=math.huge
    lv.RelativeTo=Enum.ActuatorRelativeTo.World
    lv.PlaneVelocity=Vector2.zero
    lv.Parent=root
    FRHubAutoVelocityCache[root]={lv,attachment}
    return lv
end
local function setFRHubAutoVelocity(root, velocity)
    if not root or not root.Parent then return end
    if velocity.Magnitude < 0.01 then return end
    root.AssemblyLinearVelocity = Vector3.new(velocity.X, root.AssemblyLinearVelocity.Y, velocity.Z)
end
_G.SoundCursedClearAutoPathVelocity = function(root)
    if root then setFRHubAutoVelocity(root,Vector3.zero) end
end

startAutoLeft = function()
    if FRHubAutoPathConns.autoLeft then FRHubAutoPathConns.autoLeft:Disconnect() end
    FRHubAutoLeftPhase=1
    FRHubAutoPathConns.autoLeft=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end; local spd=getFRHubAutoMoveSpeed()
        if FRHubAutoLeftPhase==1 then
            local target=Vector3.new(FRHubAutoPathPOS.L1.X,root.Position.Y,FRHubAutoPathPOS.L1.Z)
            if (target-root.Position).Magnitude<1 then FRHubAutoLeftPhase=2; return end
            local delta=FRHubAutoPathPOS.L1-root.Position; local move=Vector3.new(delta.X,0,delta.Z).Unit
            hum:Move(move,false); setFRHubAutoVelocity(root,Vector3.new(move.X*spd,0,move.Z*spd))
        elseif FRHubAutoLeftPhase==2 then
            local target=Vector3.new(FRHubAutoPathPOS.L2.X,root.Position.Y,FRHubAutoPathPOS.L2.Z)
            if (target-root.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false); setFRHubAutoVelocity(root,Vector3.zero)
                autoLeftEnabled=false
                if FRHubAutoPathConns.autoLeft then FRHubAutoPathConns.autoLeft:Disconnect(); FRHubAutoPathConns.autoLeft=nil end
                FRHubAutoLeftPhase=1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(false) end
                saveConfig()
                return
            end
            local delta=FRHubAutoPathPOS.L2-root.Position; local move=Vector3.new(delta.X,0,delta.Z).Unit
            hum:Move(move,false); setFRHubAutoVelocity(root,Vector3.new(move.X*spd,0,move.Z*spd))
        end
    end)
end

stopAutoLeft = function()
    if FRHubAutoPathConns.autoLeft then FRHubAutoPathConns.autoLeft:Disconnect(); FRHubAutoPathConns.autoLeft=nil end
    FRHubAutoLeftPhase=1
    local char=LP.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero,false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(false) end
end

startAutoRight = function()
    if FRHubAutoPathConns.autoRight then FRHubAutoPathConns.autoRight:Disconnect() end
    FRHubAutoRightPhase=1
    FRHubAutoPathConns.autoRight=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end; local spd=getFRHubAutoMoveSpeed()
        if FRHubAutoRightPhase==1 then
            local target=Vector3.new(FRHubAutoPathPOS.R1.X,root.Position.Y,FRHubAutoPathPOS.R1.Z)
            if (target-root.Position).Magnitude<1 then FRHubAutoRightPhase=2; return end
            local delta=FRHubAutoPathPOS.R1-root.Position; local move=Vector3.new(delta.X,0,delta.Z).Unit
            hum:Move(move,false); setFRHubAutoVelocity(root,Vector3.new(move.X*spd,0,move.Z*spd))
        elseif FRHubAutoRightPhase==2 then
            local target=Vector3.new(FRHubAutoPathPOS.R2.X,root.Position.Y,FRHubAutoPathPOS.R2.Z)
            if (target-root.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false); setFRHubAutoVelocity(root,Vector3.zero)
                autoRightEnabled=false
                if FRHubAutoPathConns.autoRight then FRHubAutoPathConns.autoRight:Disconnect(); FRHubAutoPathConns.autoRight=nil end
                FRHubAutoRightPhase=1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(false) end
                saveConfig()
                return
            end
            local delta=FRHubAutoPathPOS.R2-root.Position; local move=Vector3.new(delta.X,0,delta.Z).Unit
            hum:Move(move,false); setFRHubAutoVelocity(root,Vector3.new(move.X*spd,0,move.Z*spd))
        end
    end)
end

stopAutoRight = function()
    if FRHubAutoPathConns.autoRight then FRHubAutoPathConns.autoRight:Disconnect(); FRHubAutoPathConns.autoRight=nil end
    FRHubAutoRightPhase=1
    local char=LP.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero,false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(false) end
end

toggleAutoLeft = function()
    autoLeftEnabled=not autoLeftEnabled
    if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
    if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(autoLeftEnabled) end
    if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
    saveConfig()
end

toggleAutoRight = function()
    autoRightEnabled=not autoRightEnabled
    if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
    if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(autoRightEnabled) end
    if autoRightEnabled then startAutoRight() else stopAutoRight() end
    saveConfig()
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if autoLeftEnabled then startAutoLeft() end
    if autoRightEnabled then startAutoRight() end
end)
end

function runDrop()
    -- Ace Drop: briefly rise, then place the player safely on the ground.
    if __HH.dropActive then return end
    if __HH.autoTPEnabled and __HH.stopAutoTP then __HH.stopAutoTP() end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    __HH.dropActive = true
    local startTime = tick()
    local dropConn
    dropConn = RunService.Heartbeat:Connect(function()
        local currentChar = LP.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentChar or not currentRoot then
            if dropConn then dropConn:Disconnect() end
            __HH.dropActive = false
            return
        end

        if tick() - startTime >= 0.2 then
            if dropConn then dropConn:Disconnect() end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {currentChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
            if rayResult then
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
                currentRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                currentRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            __HH.dropActive = false
            return
        end

        currentRoot.Velocity = Vector3.new(currentRoot.Velocity.X, 150, currentRoot.Velocity.Z)
    end)
end

local _lastTPTime = 0
local function doSoundAutoTPDown(force)
    local char=LP.Character
    if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= __HH.autoTPHeight) then return end
    end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)
        * CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
    hrp.Velocity=Vector3.zero
end

function startAutoTP()
    if __HH.autoTPConn then
        pcall(function() task.cancel(__HH.autoTPConn) end)
        __HH.autoTPConn=nil
    end
    _G.FRHUB_AUTO_TP_DOWN_ACTIVE=true
    __HH.autoTPConn=task.spawn(function()
        while __HH.autoTPEnabled do
            task.wait(0.1)
            pcall(function() doSoundAutoTPDown(false) end)
        end
    end)
end

__HH.stopAutoTP=function()
    __HH.autoTPEnabled=false
    _G.FRHUB_AUTO_TP_DOWN_ACTIVE=false
    if __HH.autoTPConn then
        pcall(function() task.cancel(__HH.autoTPConn) end)
        __HH.autoTPConn=nil
    end
end

__HH.tpToGround = function()
    local char=LP.Character; if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)

    -- FRHUB finishes with _setV(hrp, Vector3.zero). Clear Sound's equivalent
    -- movement constraints without using the deleted Sound TP DOWN backend.
    if _G.SoundCursedClearAimVelocity then pcall(_G.SoundCursedClearAimVelocity) end
    if _G.SoundCursedClearAutoPathVelocity then pcall(_G.SoundCursedClearAutoPathVelocity,hrp) end
    destroySpeedLV()
    destroyVertLV()
end

__HH.startUnwalk = function()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim = c:FindFirstChild("Animate")
    if anim then __HH.unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end

__HH.stopUnwalk = function()
    local c = LP.Character
    if c and __HH.unwalkSavedAnimate then __HH.unwalkSavedAnimate:Clone().Parent = c; __HH.unwalkSavedAnimate = nil end
end


-- Ace Animation Pack (Replaced with Asker Hub Animation Packs)
__HH.aceSelectedAnimationPack = "OFF"
__HH.aceAnimationPackIndex = 1
__HH.aceAnimationPackList = {
    "OFF",
    "Unwalk",
    "Hit Harder",
    "Crazy",
    "Adidas Sports",
    "Adidas Community",
    "Adidas Aura",
    "Wicked Popular",
    "Elder",
    "Zombie",
    "Mage",
    "Catwalk Glam",
    "Astronaut",
    "Wicked \"Dancing Through Life\"",
    "Werewolf",
    "Superhero",
    "Toy",
    "No Boundaries",
    "NFL",
    "Amazon Unboxed",
    "Vampire",
    "Ninja",
    "Robot",
    "Levitation",
    "Stylish",
    "Bubbly",
    "Cartoon"
}
local aceAnimationPacks = {
    ["Crazy"] = {
        WalkAnim = 134824450619865,
        RunAnim = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 121454505477205,
        Swim = 121454505477205,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
        ClimbAnim = 121454505477205,
    },
    ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim  = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim     = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
    },
    ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim  = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim     = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
    },
    Elder = {
        WalkAnim = 10921111375,
        RunAnim  = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim     = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Mage = {
        WalkAnim = 10921152678,
        RunAnim  = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim     = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
    },
    ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim  = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim     = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Astronaut = {
        WalkAnim = 10921046031,
        RunAnim  = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim     = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
    },
    ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim  = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim     = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
    },
    Werewolf = {
        WalkAnim = 10921342074,
        RunAnim  = 10921336997,
        JumpAnim = nil,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim     = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
    },
    Superhero = {
        WalkAnim = 10921298616,
        RunAnim  = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim     = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
    },
    Toy = {
        WalkAnim = 10921312010,
        RunAnim  = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim     = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
        Animation2 = nil,
    },
    ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim  = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim     = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
    },
    NFL = {
        WalkAnim = 110358958299415,
        RunAnim  = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim     = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Ninja = {
        Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
        Swim=656119721, SwimIdle=656121397, Climb=656114359,
        Idle={656117400,656118341,886742569}
    },
    Robot = {
        Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
        Swim=616092998, SwimIdle=616094091, Climb=616086039,
        Idle={616088211,616089559,885531463}
    },
    Levitation = {
        Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
        Swim=616011509, SwimIdle=616012453, Climb=616003713,
        Idle={616006778,616008087,886862142}
    },
    Stylish = {
        Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
        Swim=616143378, SwimIdle=616144772, Climb=616133594,
        Idle={616136790,616138447,886888594}
    },
    Bubbly = {
        Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
        Swim=910028158, SwimIdle=910030921, Climb=909997997,
        Idle={910004836,910009958,1018536639}
    },
    Cartoon = {
        Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
        Swim=742639220, SwimIdle=742639812, Climb=742636889,
        Idle={742637544,742638445,885477856}
    },
}
local aceSavedAnimate = nil
__HH.aceOriginalAnims = {}
local aceHitHarderAnimEnabled = false
local aceHitHarderAnims = {
    idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563",
    walk = "rbxassetid://707897309", run = "rbxassetid://707861613",
    jump = "rbxassetid://116936326516985", fall = "rbxassetid://116936326516985",
}

local function aceGetAnimate(char)
    char = char or LP.Character
    return char and char:FindFirstChild("Animate") or nil
end

local function aceStopCurrentAnimations(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
end

local function aceSetAnim(animObj, id)
    if animObj and id then
        local idStr = tostring(id)
        if not string.find(idStr, "rbxassetid://") then
            idStr = "rbxassetid://" .. idStr
        end
        pcall(function() animObj.AnimationId = idStr end)
    end
end

local function aceEnsureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

local function aceEnsureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i = 1, n do
        aceEnsureAnim(idleFolder, "Animation" .. i)
    end
end

local function acePick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

local function aceSaveOriginalAnimate(char)
    if not char then return end
    if aceSavedAnimate then return end
    local animate = char:FindFirstChild("Animate")
    if animate then
        aceSavedAnimate = animate:Clone()
    end
end

local function aceResetAnimations()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        aceStopCurrentAnimations(char)
    end
    if not aceSavedAnimate then return end
    local currentAnimate = char:FindFirstChild("Animate")
    if currentAnimate then
        currentAnimate:Destroy()
    end
    local newAnimate = aceSavedAnimate:Clone()
    newAnimate.Parent = char
    newAnimate.Disabled = true
    task.wait(0.06)
    newAnimate.Disabled = false
end

local function aceEnableUnwalk()
    __HH.unwalkEnabled = true
    local char = LP.Character
    if char and char:FindFirstChild("Animate") then __HH.startUnwalk() end
    if setUnwalkVisual then setUnwalkVisual(true) end
end

local function aceDisableUnwalk()
    if __HH.unwalkEnabled then __HH.stopUnwalk() end
    __HH.unwalkEnabled = false
    if setUnwalkVisual then setUnwalkVisual(false) end
end

local function aceEnableHitHarderAnimation()
    aceHitHarderAnimEnabled = true
    local char = LP.Character
    local animate = aceGetAnimate(char)
    if not animate then return end
    aceSaveOriginalAnimate(char)
    aceStopCurrentAnimations(char)
    local idle1 = animate.idle and animate.idle:FindFirstChild("Animation1")
    local idle2 = animate.idle and animate.idle:FindFirstChild("Animation2")
    local walkObj = animate.walk and animate.walk:FindFirstChild("WalkAnim")
    local runObj = animate.run and animate.run:FindFirstChild("RunAnim")
    local jumpObj = animate.jump and animate.jump:FindFirstChild("JumpAnim")
    local fallObj = animate.fall and animate.fall:FindFirstChild("FallAnim")
    if idle1 then pcall(function() idle1.AnimationId = aceHitHarderAnims.idle1 end) end
    if idle2 then pcall(function() idle2.AnimationId = aceHitHarderAnims.idle2 end) end
    if walkObj then pcall(function() walkObj.AnimationId = aceHitHarderAnims.walk end) end
    if runObj then pcall(function() runObj.AnimationId = aceHitHarderAnims.run end) end
    if jumpObj then pcall(function() jumpObj.AnimationId = aceHitHarderAnims.jump end) end
    if fallObj then pcall(function() fallObj.AnimationId = aceHitHarderAnims.fall end) end
    pcall(function()
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end)
end

local function aceDisableHitHarderAnimation()
    aceHitHarderAnimEnabled = false
    aceResetAnimations()
end

__HH.aceSyncAnimationPackIndex = function()
    for i, name in ipairs(__HH.aceAnimationPackList) do
        if name == __HH.aceSelectedAnimationPack then
            __HH.aceAnimationPackIndex = i
            return
        end
    end
    __HH.aceSelectedAnimationPack = "OFF"
    __HH.aceAnimationPackIndex = 1
end

__HH.aceApplyAnimationPack = function(packName)
    __HH.aceSelectedAnimationPack = packName or "OFF"
    __HH.aceSyncAnimationPackIndex()

    if __HH.aceSelectedAnimationPack ~= "Unwalk" then
        aceDisableUnwalk()
    end
    if __HH.aceSelectedAnimationPack ~= "Hit Harder" and aceHitHarderAnimEnabled then
        aceDisableHitHarderAnimation()
    end
    if __HH.aceSelectedAnimationPack == "Unwalk" then
        aceResetAnimations()
        aceEnableUnwalk()
        return
    end
    if __HH.aceSelectedAnimationPack == "Hit Harder" then
        aceEnableHitHarderAnimation()
        return
    end
    if __HH.aceSelectedAnimationPack == "OFF" then
        aceResetAnimations()
        return
    end

    local pack = aceAnimationPacks[__HH.aceSelectedAnimationPack]
    local char = LP.Character
    local animate = aceGetAnimate(char)
    if not pack or not animate then return end
    aceSaveOriginalAnimate(char)
    aceStopCurrentAnimations(char)

    local runObj   = aceEnsureAnim(animate:FindFirstChild("run"),   "RunAnim")
    local walkObj  = aceEnsureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
    local jumpObj  = aceEnsureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
    local fallObj  = aceEnsureAnim(animate:FindFirstChild("fall"),  "FallAnim")
    local climbObj = aceEnsureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
    local swimObj  = aceEnsureAnim(animate:FindFirstChild("swim"),  "Swim")
    local swimIdleObj = aceEnsureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
    local idleFolder  = animate:FindFirstChild("idle")

    aceSetAnim(walkObj,  acePick(pack, "WalkAnim", "Walk", "walk"))
    aceSetAnim(runObj,   acePick(pack, "RunAnim", "Run", "run"))
    aceSetAnim(jumpObj,  acePick(pack, "JumpAnim", "Jump", "jump"))
    aceSetAnim(fallObj,  acePick(pack, "FallAnim", "Fall", "fall"))
    aceSetAnim(climbObj, acePick(pack, "ClimbAnim", "Climb", "climb"))
    aceSetAnim(swimObj,  acePick(pack, "Swim", "swim"))
    aceSetAnim(swimIdleObj, acePick(pack, "SwimIdle", "swimidle") or acePick(pack, "Swim", "swim"))

    if idleFolder then
        local a1 = acePick(pack, "Animation1")
        local a2 = acePick(pack, "Animation2")
        if a1 or a2 then
            aceEnsureIdleSlots(idleFolder, 2)
            local id1 = a1 or a2
            local id2 = a2 or a1 or id1
            aceSetAnim(idleFolder:FindFirstChild("Animation1"), id1)
            aceSetAnim(idleFolder:FindFirstChild("Animation2"), id2)
        elseif pack.Idle and #pack.Idle > 0 then
            aceEnsureIdleSlots(idleFolder, math.max(2, #pack.Idle))
            aceSetAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
            aceSetAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            for i = 3, #pack.Idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then aceSetAnim(a, pack.Idle[i]) end
            end
        elseif pack.idle and #pack.idle > 0 then
            aceEnsureIdleSlots(idleFolder, math.max(2, #pack.idle))
            aceSetAnim(idleFolder:FindFirstChild("Animation1"), pack.idle[1])
            aceSetAnim(idleFolder:FindFirstChild("Animation2"), pack.idle[2] or pack.idle[1])
            for i = 3, #pack.idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then aceSetAnim(a, pack.idle[i]) end
            end
        end
    end

    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
end

-- Infinite Jump (voided) — manual + hold mode
local function applyInfJumpBoost(boost)
    if not __HH.infJumpEnabled then return end
    if __HH.infJumpMode == "manual" then
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z) end
    end
end

__HH.UIS.JumpRequest:Connect(function() applyInfJumpBoost(50) end)
__HH.UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space and not __HH.UIS:GetFocusedTextBox() then
        task.delay(0.12, function() if __HH.UIS:IsKeyDown(Enum.KeyCode.Space) then applyInfJumpBoost(50) end end)
    end
end)
RunService.Heartbeat:Connect(function()
    if __HH.infJumpEnabled and __HH.infJumpMode == "manual" then
        if __HH.UIS:IsKeyDown(Enum.KeyCode.Space) then applyInfJumpBoost(50) end
    end
end)

__HH.startHoldInfJump = function()
    if __HH.holdInfJumpConn then return end
    __HH.holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not __HH.infJumpEnabled or __HH.infJumpMode ~= "hold" then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld = __HH.UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        if isJumpHeld and root.Velocity.Y < 35 then root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z) end
        if root.Velocity.Y < -120 then root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z) end
    end)
end

__HH.stopHoldInfJump = function()
    if __HH.holdInfJumpConn then __HH.holdInfJumpConn:Disconnect(); __HH.holdInfJumpConn = nil end
end

-- ============ Auto Jump (while holding brainrot, every 2s) ============
-- Detection style matches FR: WalkSpeed < 25 means you're carrying.
-- While holding, applies one 55-stud upward hop every 2 seconds.
__HH.autoJumpBrainrot = __HH.autoJumpBrainrot == true
local autoJumpLastJump = 0
RunService.Heartbeat:Connect(function()
    if not __HH.autoJumpBrainrot then
        autoJumpLastJump = 0
        return
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then
        autoJumpLastJump = 0
        return
    end
    if hum.WalkSpeed >= 25 then
        autoJumpLastJump = 0  -- not holding: reset so next grab jumps instantly
        return
    end
    local now = tick()
    if now - autoJumpLastJump < 2 then return end
    autoJumpLastJump = now
    local cur = root.AssemblyLinearVelocity
    root.AssemblyLinearVelocity = Vector3.new(cur.X, 55, cur.Z)
end)


if __HH.infJumpEnabled and __HH.infJumpMode == "hold" then __HH.startHoldInfJump() end


_G.SoundMedusaState = _G.SoundMedusaState or {connections={}, debounce=false, lastUsed=0}
local function aceFindMedusa()
    local char=LP.Character; if not char then return nil end
    local function scan(container)
        if not container then return nil end
        for _,tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then local n=tool.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return tool end end
        end
    end
    return scan(char) or scan(LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack"))
end
local function aceUseMedusaCounter(force)
    local state=_G.SoundMedusaState
    if (not force and not __HH.medusaCounterEnabled) or state.debounce or tick()-(state.lastUsed or 0)<25 then return end
    local char=LP.Character; if not char then return end
    state.debounce=true
    local tool=aceFindMedusa()
    if tool then
        if tool.Parent~=char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then pcall(function() hum:EquipTool(tool) end); task.wait(.05) end end
        pcall(function() tool:Activate() end); state.lastUsed=tick()
    end
    state.debounce=false
end
setupMedusa = function(char)
    stopMedusaCounter(); char=char or LP.Character; if not char then return end
    local function hook(part)
        if part:IsA("BasePart") then table.insert(_G.SoundMedusaState.connections,part:GetPropertyChangedSignal("Anchored"):Connect(function()
            if __HH.medusaCounterEnabled and part.Anchored and part.Transparency==1 then aceUseMedusaCounter() end
        end)) end
    end
    for _,part in ipairs(char:GetDescendants()) do hook(part) end
    table.insert(_G.SoundMedusaState.connections,char.DescendantAdded:Connect(hook))
end
stopMedusaCounter = function()
    for _,conn in ipairs(_G.SoundMedusaState.connections) do pcall(function() conn:Disconnect() end) end
    _G.SoundMedusaState.connections={}; _G.SoundMedusaState.debounce=false
end

-- SPIN BOT (ported from FRHUB)
do
    local Spin = _G.SoundSpinBot or {}
    _G.SoundSpinBot = Spin
    if Spin.stop then pcall(Spin.stop) end
    Spin.enabled = Spin.enabled == true
    Spin.setVisual = nil

    local _spBAV = nil
    local _spMConns = {}

    local function _spStop()
        if _spBAV then pcall(function() _spBAV:Destroy() end); _spBAV = nil end
        for _, connection in ipairs(_spMConns) do
            pcall(function() connection:Disconnect() end)
        end
        _spMConns = {}
    end

    local function _spStart()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if _spBAV then pcall(function() _spBAV:Destroy() end) end

        _spBAV = Instance.new("BodyAngularVelocity")
        _spBAV.Name = "SpinForce"
        _spBAV.MaxTorque = Vector3.new(0, math.huge, 0)
        _spBAV.AngularVelocity = Vector3.new(0, 25, 0)
        _spBAV.P = 1e5
        _spBAV.Parent = root

        for _, connection in ipairs(_spMConns) do
            pcall(function() connection:Disconnect() end)
        end
        _spMConns = {}

        local character = root.Parent
        if character then
            local function _spOnMedusa(part)
                if part.Anchored and part.Transparency == 1 then
                    pcall(function() aceUseMedusaCounter(true) end)
                    local unanchorConnection
                    unanchorConnection = part:GetPropertyChangedSignal("Anchored"):Connect(function()
                        if not part.Anchored then
                            pcall(function() unanchorConnection:Disconnect() end)
                            if _spBAV then task.defer(_spStart) end
                        end
                    end)
                    table.insert(_spMConns, unanchorConnection)
                end
            end

            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(_spMConns, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                        _spOnMedusa(part)
                    end))
                end
            end
            table.insert(_spMConns, character.DescendantAdded:Connect(function(part)
                if part:IsA("BasePart") then
                    table.insert(_spMConns, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                        _spOnMedusa(part)
                    end))
                end
            end))
        end
    end

    Spin.restart = function()
        if not Spin.enabled then return end
        if _spBAV then _spBAV = nil end
        for _, connection in ipairs(_spMConns) do
            pcall(function() connection:Disconnect() end)
        end
        _spMConns = {}
        task.defer(_spStart)
    end

    Spin.start = _spStart
    Spin.stop = _spStop
    Spin.setEnabled = function(on)
        on = on == true
        Spin.enabled = on
        if Spin.setVisual then Spin.setVisual(on) end
        if on then _spStart() else _spStop() end
    end
end

batCounterDebounce = false
BAT_COUNTER_SLAP_LIST = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "ZeyHubb Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
function findBatForCounter()
    local c = LP.Character
    if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end
local function swingBatForCounter(bat, char)
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char then
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.8); pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end); task.wait(0.8); pcall(function() bat:Activate() end)
    end
end
startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not __HH.batCounterEnabled then return end
        if batCounterDebounce then return end
        local char = LP.Character; if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st = hum2:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, char) end
                task.wait(0.5); batCounterDebounce = false
            end)
        end
    end)
end
stopBatCounter = function()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter = nil end
    batCounterDebounce = false
end

end
do
local SKY_TAG = "VynxSkyTheme"
__HH.currentSkyTheme = "Off"
SKY_PRESETS = {
    ["Off"]           = {kind="off"},
    ["Night"]         = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]        = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]        = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]        = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]         = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]        = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]    = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]    = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]  = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]      = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]        = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]= {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]     = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"]         = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]     = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]        = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]         = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]       = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]    = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]= {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]       = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]      = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local SKY_ORDER = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

local function _color3(rgb) return Color3.fromRGB(rgb[1], rgb[2], rgb[3]) end

local function applySkyTheme(mode)
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(SKY_TAG) then pcall(function() child:Destroy() end) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute(SKY_TAG) then pcall(function() child:Destroy() end) end
        end
    end
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14; Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000; Lighting.GlobalShadows = true
        __HH.currentSkyTheme = "Off"; return
    end
    Lighting.FogStart = 0; Lighting.FogEnd = 100000; Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0); Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true; Lighting.ClockTime = preset.clock or 14; Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _color3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _color3(preset.ambient) end
    if preset.sky then
        local sky = Instance.new("Sky"); sky:SetAttribute(SKY_TAG, true)
        if preset.sky.stars then sky.StarCount = preset.sky.stars end
        if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
        sky.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere"); atm:SetAttribute(SKY_TAG, true)
        atm.Density = preset.atm.dens or 0.3; atm.Color = _color3(preset.atm.color)
        atm.Decay = _color3(preset.atm.decay); atm.Glare = preset.atm.glare or 1; atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds"); clouds:SetAttribute(SKY_TAG, true)
        clouds.Cover = preset.clouds.cover or 0.5; clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _color3(preset.clouds.color); clouds.Parent = terrain
    end
    __HH.currentSkyTheme = mode
end

local defLightBrightness, defLightClock, defLightAmbient

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end

local function enableAntiLag()
    __HH.removeAccessoriesEnabled = true; __HH.antiLagEnabled = true
    defLightBrightness = defLightBrightness or Lighting.Brightness
    defLightClock = defLightClock or Lighting.ClockTime
    defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false; Lighting.FogEnd = 1e10; Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0; Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if __HH.antiLagDescConn then __HH.antiLagDescConn:Disconnect() end
    __HH.antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if __HH.removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)
end

local function disableAntiLag()
    __HH.removeAccessoriesEnabled = false; __HH.antiLagEnabled = false
    if __HH.antiLagDescConn then __HH.antiLagDescConn:Disconnect(); __HH.antiLagDescConn = nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness = defLightBrightness end
        if defLightClock then Lighting.ClockTime = defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
        Lighting.ExposureCompensation = 0
    end)
end

local function enableStretchRez()
    __HH.stretchRezEnabled = true; workspace.CurrentCamera.FieldOfView = 107
    if __HH.stretchRezConn then __HH.stretchRezConn:Disconnect() end
    __HH.stretchRezConn = RunService.RenderStepped:Connect(function()
        if not __HH.stretchRezEnabled then __HH.stretchRezConn:Disconnect(); __HH.stretchRezConn = nil; return end
        workspace.CurrentCamera.FieldOfView = 107
    end)
end

local function disableStretchRez()
    __HH.stretchRezEnabled = false
    if __HH.stretchRezConn then __HH.stretchRezConn:Disconnect(); __HH.stretchRezConn = nil end
    workspace.CurrentCamera.FieldOfView = 70
end

function saveConfig()
    local function ks(e) return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil} end
    local cfg = {
        normalSpeed = NS, carrySpeed = CS,
        r3Enabled = (_G.Round3SpeedBooster and _G.Round3SpeedBooster.Enabled) == true,
        r3NormalSpeed = (_G.Round3SpeedBooster and _G.Round3SpeedBooster.NormalSpeed) or NS,
        r3CarrySpeed = (_G.Round3SpeedBooster and _G.Round3SpeedBooster.CarrySpeed) or CS,
        r3ForceCarry = (_G.Round3SpeedBooster and _G.Round3SpeedBooster.ForceCarry) == true,
        dropBrainrotKey = ks(__HH.KB.DropBrainrot), 
        tpLockKey = ks(__HH.KB.TPLock), laggerToggleKey = ks(__HH.KB.LaggerToggle),
        frameResetKey = ks(__HH.KB.InstaReset), frameResetKeyVersion = 1,
        autoLeftKey = ks(__HH.KB.AutoLeft), autoRightKey = ks(__HH.KB.AutoRight), tpFloorKey = ks(__HH.KB.TPFloor), guiHideKey = ks(__HH.KB.GuiHide),
        speedToggleKey = ks(__HH.KB.SpeedToggle), batV2Key = ks(__HH.KB.BatV2Toggle),
        antiRagdoll = __HH.antiRagdollEnabled,
        infiniteJump = __HH.infJumpEnabled, medusaCounter = __HH.medusaCounterEnabled,
        medusaReset = __HH.medusaResetEnabled, batCounter = __HH.batCounterEnabled,
        carryMode = carrySpeedActive, laggerMode = laggerModeEnabled, laggerCarryMode = (laggerModeEnabled and carrySpeedActive),
        laggerSpeed = LAGGER_SPEED, laggerCarrySpeed = LAGGER_CARRY_SPEED,
        aimbotV1Speed = aimbotV1Speed,
        autoCarrySpeedEnabled = autoCarrySpeedEnabled,
        tpLockEnabled = __HH.tpLockEnabled, autoSwing = autoSwingEnabled,
        mirrorTPDownEnabled = (_G.SoundMirrorTPDown and _G.SoundMirrorTPDown.enabled
            and _G.SoundMirrorTPDown.enabled()) == true,
        batSpamEnabled = (_G.SoundBatSpam and _G.SoundBatSpam.enabled
            and _G.SoundBatSpam.enabled()) == true,
        spinBotEnabled = (_G.SoundSpinBot and _G.SoundSpinBot.enabled) == true,
        unwalkEnabled = __HH.unwalkEnabled, antiLag = __HH.antiLagEnabled, stretchRez = __HH.stretchRezEnabled,
        autoTPEnabled = __HH.autoTPEnabled, autoTPHeight = __HH.autoTPHeight,
        autoJumpBrainrot = __HH.autoJumpBrainrot,
        floatEnabled = __HH.floatEnabled, floatHeight = __HH.floatHeight,
        guiTransparencyEnabled = __HH.guiTransparencyEnabled,
        mobileButtonsEnabled = __HH.mobileButtonsEnabled, mobileButtonsSize = __HH.mobileButtonsSize,
        circleButtonsEnabled = __HH.circleButtonsEnabled, shapeButtonsEnabled = __HH.shapeButtonsEnabled,
        rectangularButtonsEnabled = __HH.rectangularButtonsEnabled,
        infJumpMode = __HH.infJumpMode,
        antiDie = __HH.antiDieEnabled, autoResetOnDeath = __HH.autoResetOnDeath,
        uiLocked = __HH.uiLocked, perButtonDragEnabled = __HH.perButtonDragEnabled,
        batV2Enabled = __HH.batV2Enabled,
        batAimMode = batAimMode,
        skyTheme = __HH.currentSkyTheme, uiScale = uiScaleValue, guiSize = __HH.guiSizeValue,
        buttonVisibility = __HH.buttonVisibility,
        espEnabled = __HH.espEnabled,
        headlessEnabled = __HH.headlessEnabled,
        korbloxEnabled = __HH.korbloxEnabled,
        accessoryPack = currentAccessoryPack,
        autoLeftEnabled = autoLeftEnabled,
        autoRightEnabled = autoRightEnabled,
        antiKick = antiKickEnabled,
        safeMode = antiKickEnabled,
        aceAnimationPack = __HH.aceSelectedAnimationPack,
        -- v17 integrated feature state
        autoStealEnabled = (_G.HorizonStealModes and _G.HorizonStealModes.GetEnabled and _G.HorizonStealModes.GetEnabled()) == true,
        autoStealMode = (_G.HorizonStealModes and _G.HorizonStealModes.GetMode and _G.HorizonStealModes.GetMode()) or "V1",
        autoStealRadius = (_G.HorizonStealModes and _G.HorizonStealModes.GetRadius and _G.HorizonStealModes.GetRadius()) or 60,
        bodyLockEnabled = __HH.bodyLockEnabled == true,
        bodyLockRange = __HH.bodyLockRange or 20,
        antiFlingEnabled = __HH.antiFlingEnabled == true,
        selectedDevice = __HH.selectedDevice,
        -- ===== Ambitious ports =====
        xrayEnabled            = _G.SoundXRayEnabled == true,
        brainrotXRayEnabled    = _G.AmbitiousBrainrotXRayEnabled == true,
        customToolsEnabled     = _G.AmbitiousCustomToolsEnabled == true,
        rainbowToolsEnabled    = _G.AmbitiousRainbowToolsEnabled == true,
        transparentToolsEnabled= _G.AmbitiousTransparentToolsEnabled == true,
        customSoundsEnabled    = _G.AmbitiousCustomSoundsEnabled == true,
        customToolSkins        = _G.AmbitiousCustomToolSkins,
        rainbowJoystickEnabled = _G.AmbitiousRainbowJoystickEnabled == true,
        radiusCircleEnabled    = _G.SoundRadiusCircleEnabled == true,
        radiusCircleRadius     = _G.SoundRadiusCircleRadius or 8,
        radiusCircleColor      = (function()
            local c = _G.SoundRadiusCircleColor or Color3.fromRGB(230, 201, 255)
            return { math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5) }
        end)(),
        avatarChanger = (function()
            local ac = _G._AmbitiousAvatarChanger
            if type(ac) ~= "table" then return nil end
            local out = {}
            for k, v in pairs(ac) do
                out[k] = { enabled = v.enabled == true, savedId = v.savedId, savedName = v.savedName or "" }
            end
            return out
        end)(),
    }
    pcall(function() writefile("VynxPC.json", __HH.HS:JSONEncode(cfg)) end)
    return cfg
end

-- Build the exact same settings table saveConfig() writes to disk, without
-- touching the file. Used by "Copy Config" so the exported code always
-- matches what would be auto-saved.
function __HH.buildConfigTable()
    return saveConfig()
end

-- Copy Config / Load Config: turns the full settings table into a single
-- portable text code (JSON + Base64) and back. Base64 keeps it safe to
-- paste anywhere; JSON round-trips every field exactly so Load Config
-- restores settings identically ("نفسها بالظبط").
-- Implemented as plain Lua (no HttpService:Base64Encode/Decode, which does
-- not exist on Roblox's HttpService and was silently failing before).
local B64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function base64Encode(data)
    local out = {}
    local len = #data
    local i = 1
    while i <= len do
        local b1, b2, b3 = data:byte(i, i + 2)
        b2 = b2 or 0
        b3 = b3 or 0
        local n = b1 * 65536 + b2 * 256 + b3
        local c1 = math.floor(n / 262144) % 64
        local c2 = math.floor(n / 4096) % 64
        local c3 = math.floor(n / 64) % 64
        local c4 = n % 64
        local rem = len - i + 1
        out[#out + 1] = B64_CHARS:sub(c1 + 1, c1 + 1)
        out[#out + 1] = B64_CHARS:sub(c2 + 1, c2 + 1)
        out[#out + 1] = (rem >= 2) and B64_CHARS:sub(c3 + 1, c3 + 1) or "="
        out[#out + 1] = (rem >= 3) and B64_CHARS:sub(c4 + 1, c4 + 1) or "="
        i = i + 3
    end
    return table.concat(out)
end

local B64_LOOKUP = {}
for idx = 1, #B64_CHARS do
    B64_LOOKUP[B64_CHARS:sub(idx, idx)] = idx - 1
end

local function base64Decode(data)
    data = data:gsub("[^" .. B64_CHARS .. "=]", "")
    local out = {}
    local i = 1
    local len = #data
    while i <= len do
        local c1 = data:sub(i, i)
        local c2 = data:sub(i + 1, i + 1)
        local c3 = data:sub(i + 2, i + 2)
        local c4 = data:sub(i + 3, i + 3)
        local n1 = B64_LOOKUP[c1]
        local n2 = B64_LOOKUP[c2]
        if not n1 or not n2 then break end
        local n3 = (c3 ~= "=" and c3 ~= "") and B64_LOOKUP[c3] or nil
        local n4 = (c4 ~= "=" and c4 ~= "") and B64_LOOKUP[c4] or nil
        local n = n1 * 262144 + n2 * 4096 + (n3 or 0) * 64 + (n4 or 0)
        local byte1 = math.floor(n / 65536) % 256
        local byte2 = math.floor(n / 256) % 256
        local byte3 = n % 256
        out[#out + 1] = string.char(byte1)
        if n3 then out[#out + 1] = string.char(byte2) end
        if n4 then out[#out + 1] = string.char(byte3) end
        i = i + 4
    end
    return table.concat(out)
end

local CONFIG_CODE_PREFIX = "HZNV2-"
function __HH.encodeConfigCode(cfg)
    local json = __HH.HS:JSONEncode(cfg)
    local b64 = base64Encode(json)
    return CONFIG_CODE_PREFIX .. b64
end

function __HH.decodeConfigCode(code)
    if type(code) ~= "string" then return nil end
    code = code:gsub("^%s+", ""):gsub("%s+$", "")
    if code == "" then return nil end
    local body = code
    if code:sub(1, #CONFIG_CODE_PREFIX) == CONFIG_CODE_PREFIX then
        body = code:sub(#CONFIG_CODE_PREFIX + 1)
    end
    local okB64, json = pcall(base64Decode, body)
    if not okB64 or type(json) ~= "string" or json == "" then return nil end
    local okJson, cfg = pcall(function() return __HH.HS:JSONDecode(json) end)
    if not okJson or type(cfg) ~= "table" then return nil end
    return cfg
end

task.spawn(function() while task.wait(5) do saveConfig() end end)


-- Removed the execute-time overhead message / Discord and speed labels.

-- ============================================================
-- SOUND HUB — permanent Discord tag above local player head
-- Always visible, survives respawn, AlwaysOnTop.
-- ============================================================
do
    local DISCORD_TEXT = "discord.gg/3qgqS2CdY"
    local TAG_NAME = "SoundHubDiscordTag"

    local function destroyOldTag()
        pcall(function()
            local cg = game:GetService("CoreGui")
            local pg = LP:FindFirstChild("PlayerGui")
            for _, parent in ipairs({cg, pg, workspace}) do
                if parent then
                    local old = parent:FindFirstChild(TAG_NAME)
                    if old then old:Destroy() end
                end
            end
            if LP.Character then
                local head = LP.Character:FindFirstChild("Head")
                if head then
                    local old = head:FindFirstChild(TAG_NAME)
                    if old then old:Destroy() end
                end
            end
        end)
    end

    local function attachDiscordTag(char)
        if not char then return end
        local head = char:WaitForChild("Head", 8)
        if not head then return end
        destroyOldTag()

        local bb = Instance.new("BillboardGui")
        bb.Name = TAG_NAME
        bb.Adornee = head
        bb.Size = UDim2.new(0, 280, 0, 36)
        bb.StudsOffset = Vector3.new(0, 3.4, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 1e5
        bb.LightInfluence = 0
        bb.ResetOnSpawn = false

        local lbl = Instance.new("TextLabel")
        lbl.Name = "Tag"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = DISCORD_TEXT
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 16
        lbl.TextScaled = false
        lbl.TextColor3 = Color3.fromRGB(90, 160, 255)
        lbl.TextStrokeColor3 = Color3.fromRGB(4, 10, 35)
        lbl.TextStrokeTransparency = 0
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.Parent = bb

        -- Prefer CoreGui so it stays even if PlayerGui is wiped
        local parented = pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(bb) end
            bb.Parent = game:GetService("CoreGui")
        end)
        if not parented then
            bb.Parent = LP:WaitForChild("PlayerGui")
        end
    end

    task.spawn(function()
        repeat task.wait() until game:IsLoaded() and LP
        if LP.Character then
            attachDiscordTag(LP.Character)
        end
        LP.CharacterAdded:Connect(function(char)
            task.wait(0.35)
            attachDiscordTag(char)
        end)
    end)
end



-- Clean Hub ragdoll countdown (billboard over head), recolored blue.
do
    local _ragCountdownRunning = false
    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local cGui = game:GetService("CoreGui")
        local pGui = LP:WaitForChild("PlayerGui")
        local existing = cGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local existing2 = pGui:FindFirstChild("RagCountdownBillboard")
        if existing2 then existing2:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "RagCountdownBillboard"
        bb.Size = UDim2.new(0, 84, 0, 42)
        bb.StudsOffset = Vector3.new(0, 4.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        if not pcall(function() bb.Parent = cGui end) then
            bb.Parent = pGui
        end
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        lbl.TextColor3 = Color3.fromRGB(90, 160, 255)
        lbl.TextStrokeColor3 = Color3.fromRGB(5, 12, 40)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = bb
        return bb, lbl
    end
    local function _ragPunch(lbl, text)
        if not (lbl and lbl.Parent) then return end
        lbl.Text = text
    end
    local function _startRagCountdown()
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5
            local step = 0.1
            while timeLeft > 0 and bb.Parent do
                _ragPunch(lbl, string.format("%.1f", timeLeft))
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                _ragPunch(lbl, "READY!")
                task.wait(0.5)
                if bb and bb.Parent then bb:Destroy() end
            end
            _ragCountdownRunning = false
        end)
    end
    local _wasRagdolled = false
    RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then _wasRagdolled = false; return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRagdolled = false; return end
        local st = hum:GetState()
        local inRag = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
        if inRag and not _wasRagdolled then
            _wasRagdolled = true
            _startRagCountdown()
        elseif not inRag then
            _wasRagdolled = false
        end
    end)
end

-- AIM BOT carry handoff:
-- when the internal or floating AIM BOT button is ON during carry animation
-- 71186871415348, disable AIM BOT first and run Sound's DROP BR. AIM BOT stays
-- disabled until the drop motion is finished, the carry animation is gone, and
-- any carry state detected at the start is cleared for stable consecutive frames.
-- If confirmation fails, DROP BR retries while AIM BOT remains disabled; only a
-- confirmed drop restores it. Anti Kick never cancels this cycle.
_G.SoundDropThenAimCycleActive = false
_G.SoundDropThenAimSafeModeAuthorized = false
do
    local CARRY_DROP_AIM_ANIM_ID = "71186871415348"
    local carryDropAimWasPlaying = false
    local carryDropAimLastTrigger = 0
    local carryDropAimSequenceActive = false

    local function isCarryDropAimAnimationPlaying()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then return false end
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local animation = track.Animation
            local animationId = animation and animation.AnimationId or ""
            if string.find(animationId, CARRY_DROP_AIM_ANIM_ID, 1, true) then return true end
        end
        return false
    end

    _G.SoundCursedDropAimCarryAnimationPlaying = isCarryDropAimAnimationPlaying

    local function isSoundAimButtonActive()
        if not __HH.batV2Enabled then return false end
        local getter = _G.SoundCursedGetAimbot
        if type(getter) ~= "function" then return false end
        local ok, enabled = pcall(getter)
        return ok and enabled == true
    end

    -- Ragdoll destroys the carry animation PERMANENTLY: after a ragdoll ends
    -- (~3 seconds) the carry anim id does NOT come back, so the drop must
    -- never fire again for that brainrot. AntiRagdoll and the always-on speed
    -- loop both stamp _G.SoundRagdollKilledCarry = true the moment ragdoll is
    -- detected (even while AIM BOT is off). The flag only resets when a
    -- brand-new carry animation starts (fresh pickup), via rising edge below.
    local function recentlyRagdolled()
        return _G.SoundRagdollKilledCarry == true
    end

    local function stopCarryAnimNow()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then return end
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local animation = track.Animation
            local animationId = animation and animation.AnimationId or ""
            if string.find(animationId, CARRY_DROP_AIM_ANIM_ID, 1, true) then
                track:Stop(0)
            end
        end
    end

    local DROP_CONFIRM_STABLE_HEARTBEATS = 3
    local DROP_RETRY_INTERVAL = 0.75

    local function hasDetectedCarryState()
        local ok, carrying = pcall(__HH.isCarryingBrainrot, LP.Character)
        return ok and carrying == true
    end

    local function restoreSoundAimAfterConfirmedDrop(requireCarryStateClear)
        task.spawn(function()
            local stableClearHeartbeats = 0
            local lastDropAttemptAt = tick()
            while carryDropAimSequenceActive do
                RunService.Heartbeat:Wait()

                local dropMotionFinished = __HH.dropActive ~= true
                local carryAnimationCleared = not isCarryDropAimAnimationPlaying()
                local carryStateCleared = not requireCarryStateClear or not hasDetectedCarryState()

                if dropMotionFinished and carryAnimationCleared and carryStateCleared then
                    stableClearHeartbeats = stableClearHeartbeats + 1
                else
                    stableClearHeartbeats = 0
                end

                if stableClearHeartbeats >= DROP_CONFIRM_STABLE_HEARTBEATS then
                    -- Confirmed drop: finish the handoff and re-enable AIM BOT
                    -- automatically, mirroring the same enable path used by the
                    -- normal BAT V2 toggle (backend + visual + mobile button).
                    _G.SoundDropThenAimSafeModeAuthorized = false
                    __HH.batV2Enabled = true
                    if _G.SoundCursedSetAimbot then pcall(_G.SoundCursedSetAimbot, true) end
                    if __HH.batV2SetVisual then __HH.batV2SetVisual(true) end
                    if __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(true) end
                    carryDropAimSequenceActive = false
                    _G.SoundDropThenAimCycleActive = false
                    saveConfig()
                    return
                end

                -- Failed/not-yet-confirmed drop: keep AIM BOT OFF and retry DROP BR.
                -- Never retry on top of an active drop movement.
                local now = tick()
                if __HH.dropActive ~= true and now - lastDropAttemptAt >= DROP_RETRY_INTERVAL then
                    lastDropAttemptAt = now
                    runDrop()
                end
            end
        end)
    end

    local function triggerSoundDropAimCycle()
        local now = tick()
        if carryDropAimSequenceActive then return end
        if now - carryDropAimLastTrigger < 0.75 then return end
        carryDropAimLastTrigger = now
        carryDropAimSequenceActive = true
        antiKickAimPending = false
        _G.SoundDropThenAimCycleActive = true
        _G.SoundDropThenAimSafeModeAuthorized = false

        -- Stop the backend and synchronize both Aim Bot controls before DROP BR.
        __HH.batV2Enabled = false
        if _G.SoundCursedSetAimbot then pcall(_G.SoundCursedSetAimbot, false) end
        if __HH.batV2SetVisual then __HH.batV2SetVisual(false) end
        if __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(false) end

        -- If a concrete carry state exists now, require that exact condition to
        -- clear too; otherwise the known carry animation is the confirmation signal.
        local requireCarryStateClear = hasDetectedCarryState()
        runDrop()
        restoreSoundAimAfterConfirmedDrop(requireCarryStateClear)
    end

    local carryAnimPrev = false

    RunService.Heartbeat:Connect(function()
        if carryDropAimSequenceActive then
            carryDropAimWasPlaying = isCarryDropAimAnimationPlaying()
            carryAnimPrev = carryDropAimWasPlaying
            return
        end

        local isPlaying = isCarryDropAimAnimationPlaying()

        -- Always-on rising edge: a brand-new carry animation just started
        -- (fresh brainrot pickup). This is the only thing that re-arms the
        -- drop after a ragdoll permanently destroyed the previous carry.
        if isPlaying and not carryAnimPrev then
            _G.SoundRagdollKilledCarry = false
        end
        carryAnimPrev = isPlaying

        if not isSoundAimButtonActive() then
            carryDropAimWasPlaying = false
            return
        end

        if recentlyRagdolled() then
            -- A ragdoll destroyed this carry for good (the anim id never comes
            -- back), so never drop it: just stop the anim and let AIM BOT run
            -- with no drop movement.
            stopCarryAnimNow()
            carryDropAimWasPlaying = false
            return
        end

        if isPlaying and not carryDropAimWasPlaying then triggerSoundDropAimCycle() end
        carryDropAimWasPlaying = isPlaying
    end)
end

-- Anti Kick E01 carry timer (top-screen wide banner, pale ice blue).
do
    local e01Gui, e01Lbl, e01Active = nil, nil, false
    local E01_ANIM = "71186871415348"
    local function e01InCarry()
        local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local animator=hum and hum:FindFirstChildOfClass("Animator")
        if not animator then return false end
        for _,track in ipairs(animator:GetPlayingAnimationTracks()) do if track.Animation.AnimationId:find(E01_ANIM) then return true end end
        return false
    end
    local function clearE01()
        e01Active=false
        if e01Gui then e01Gui:Destroy(); e01Gui=nil end
        e01Lbl=nil
    end
    local function showE01()
        if e01Active then return end
        e01Active=true
        e01Gui=Instance.new("ScreenGui")
        e01Gui.Name="AntiKickE01"; e01Gui.ResetOnSpawn=false; e01Gui.IgnoreGuiInset=true
        e01Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; e01Gui.DisplayOrder=15
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(e01Gui) end end)
        if not pcall(function() e01Gui.Parent=game:GetService("CoreGui") end) then
            e01Gui.Parent=LP:WaitForChild("PlayerGui")
        end
        local bar=Instance.new("Frame",e01Gui)
        bar.AnchorPoint=Vector2.new(0.5,0)
        bar.Size=UDim2.new(1,-40,0,50); bar.Position=UDim2.new(0.5,0,0,70)
        bar.BackgroundColor3=Color3.fromRGB(22, 7, 36); bar.BackgroundTransparency=.5; bar.BorderSizePixel=0
        Instance.new("UICorner",bar).CornerRadius=UDim.new(0,10)
        local stroke=Instance.new("UIStroke",bar); stroke.Color=Color3.fromRGB(230, 201, 255); stroke.Thickness=1.5; stroke.Transparency=.3
        e01Lbl=Instance.new("TextLabel",bar)
        e01Lbl.Size=UDim2.new(1,-8,1,0); e01Lbl.Position=UDim2.new(0,4,0,0)
        e01Lbl.BackgroundTransparency=1; e01Lbl.Text="DON'T WIN OR E01"
        e01Lbl.Font=Enum.Font.GothamBlack; e01Lbl.TextSize=24
        e01Lbl.TextColor3=Color3.fromRGB(230, 201, 255); e01Lbl.ZIndex=5
        local began=tick()
        task.spawn(function()
            while e01Active do
                task.wait(.05)
                if not e01InCarry() then clearE01(); return end
                local left=math.max(0,3.1-(tick()-began))
                if left<=0 then clearE01(); return end
                if left < 1 then
                    e01Lbl.Text = "YOU CAN WIN"
                    e01Lbl.TextSize = 28
                    e01Lbl.TextColor3 = Color3.fromRGB(230, 201, 255)
                else
                    e01Lbl.Text = "DON'T WIN OR E01"
                    e01Lbl.TextSize = 24
                    e01Lbl.TextColor3 = Color3.fromRGB(230, 201, 255)
                end
            end
        end)
    end
    task.spawn(function() local was=false; while task.wait(.12) do local now=e01InCarry(); if now and not was then showE01() elseif not now and was then clearE01() end; was=now end end)
end

local playerSpeedLabels = {}

local function createPlayerSpeedLabel(plr)
    if plr == LP then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if playerSpeedLabels[plr] then
        playerSpeedLabels[plr].gui:Destroy()
        playerSpeedLabels[plr] = nil
    end

    local speedGui = Instance.new("BillboardGui")
    speedGui.Name = "VynxSpeedLabel_Other"
    speedGui.Adornee = head
    speedGui.Size = UDim2.new(0, 160, 0, 28)
    speedGui.StudsOffset = Vector3.new(0, 2.8, 0)
    speedGui.AlwaysOnTop = true
    speedGui.Parent = char

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(1,0,1,0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: 0"
    speedLbl.TextColor3 = Color3.fromRGB(230, 201, 255)
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLbl.TextStrokeTransparency = 0
    speedLbl.Font = Enum.Font.GothamBold
    speedLbl.TextSize = 14
    speedLbl.TextScaled = true
    speedLbl.TextXAlignment = Enum.TextXAlignment.Center
    speedLbl.Parent = speedGui

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not char or not char.Parent then
            conn:Disconnect()
            return
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local spd = hum and hum.WalkSpeed or 0
        speedLbl.Text = string.format("Speed: %.0f", spd)
    end)

    playerSpeedLabels[plr] = {gui = speedGui, lbl = speedLbl, conn = conn}
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LP then
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerSpeedLabel(plr)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if playerSpeedLabels[plr] then
        playerSpeedLabels[plr].gui:Destroy()
        if playerSpeedLabels[plr].conn then playerSpeedLabels[plr].conn:Disconnect() end
        playerSpeedLabels[plr] = nil
    end
end)

local _cachedChar, _cachedHum, _cachedHrp = nil, nil, nil

LP.CharacterAdded:Connect(function(char)
    _cachedChar = nil; _cachedHum = nil; _cachedHrp = nil
    task.wait(0.3)
    _cachedChar = char
    _cachedHum = char:FindFirstChildOfClass("Humanoid")
    _cachedHrp = char:FindFirstChild("HumanoidRootPart")
    if _G.SoundSpinBot and _G.SoundSpinBot.enabled and _G.SoundSpinBot.restart then
        _G.SoundSpinBot.restart()
    end
    if __HH.medusaCounterEnabled or __HH.medusaResetEnabled then setupMedusa(char) end
    if __HH.batCounterEnabled then startBatCounter() end
    if __HH.unwalkEnabled then task.wait(0.5); __HH.startUnwalk() end
    if __HH.aceSelectedAnimationPack ~= "OFF" then
        task.wait(0.15)
        __HH.aceOriginalAnims = {}
        pcall(function() __HH.aceApplyAnimationPack(__HH.aceSelectedAnimationPack) end)
    end
    if __HH.antiRagdollEnabled then __HH.stopAntiRagdoll(); __HH.startAntiRagdoll() end
    __HH.startAntiDie()
    if __HH.autoResetOnDeath then __HH.setupDeathReset() end
    if __HH.tpLockEnabled then
        task.delay(0.2, function()
            if __HH.tpLockEnabled and startTPLock then startTPLock() end
        end)
    end
end)

__HH.UIS.InputBegan:Connect(function(input, gpe)
    if __HH._anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or __HH.UIS:GetFocusedTextBox() then return end
    end
    if not __HH.isGamepadInput(input) then
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    end
    if not __HH.isBindableInput(input) then return end
    local kc = input.KeyCode
    if __HH.kbMatch(__HH.KB.LaggerToggle, kc) then toggleLaggerMode(); saveConfig()
    elseif __HH.kbMatch(__HH.KB.SpeedToggle, kc) then toggleCarryMode(); saveConfig()
    elseif __HH.kbMatch(__HH.KB.DropBrainrot, kc) then runDrop()
    elseif __HH.kbMatch(__HH.KB.InstaReset, kc) then
        if tick() - __HH._lastKbSet > 0.5 then pcall(__HH.FrameReset.ResetPlayer) end
    elseif __HH.kbMatch(__HH.KB.TPFloor, kc) then __HH.tpToGround()
    elseif __HH.kbMatch(__HH.KB.AutoLeft, kc) then
        toggleAutoLeft()
    elseif __HH.kbMatch(__HH.KB.AutoRight, kc) then
        toggleAutoRight()
    elseif __HH.kbMatch(__HH.KB.TPLock, kc) then
        if __HH.batV2Enabled then toggleBatV2() end
        toggleTPLock(); saveConfig()
    elseif __HH.kbMatch(__HH.KB.GuiHide, kc) then
        if __HH.mainFrame then __HH.mainFrame.Visible = not __HH.mainFrame.Visible end
    elseif __HH.kbMatch(__HH.KB.BatV2Toggle, kc) then
        if not __HH.batV2Enabled and _G.AceSafeModeTryStart
            and not _G.AceSafeModeTryStart(false) then return end
        if __HH.tpLockEnabled then toggleTPLock() end
        toggleBatV2(); saveConfig()
    end
end)

local MOB_POS_FILE = "vynx_btnpos.json"
local DRAG_THRESHOLD = 15

local function loadBtnPositions()
    if not (isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok, data = pcall(function() return __HH.HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data) == "table" then return data end
    return {}
end

local function saveBtnPositions()
    if not writefile then return end; if not __HH.mobGuiRef then return end
    local out = {}
    for _, child in ipairs(__HH.mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key = child:GetAttribute("BtnKey")
            out[key] = {xo = child.Position.X.Offset, yo = child.Position.Y.Offset}
        end
    end
    pcall(function() writefile(MOB_POS_FILE, __HH.HS:JSONEncode(out)) end)
end

local function destroyMobileButtons()
    if __HH.mobGuiRef then pcall(function() __HH.mobGuiRef:Destroy() end); __HH.mobGuiRef = nil end
    __HH.mobBtnRefs = {}
end

local function resetBtnPositions()
    pcall(function() if writefile then writefile(MOB_POS_FILE, "{}") end end)
    if __HH.mobileButtonsEnabled then buildMobileButtons() end
end

-- Static purple image background for every floating mobile button.
-- The JPEG is embedded as Base64; supported executors decode it to a local asset.
local SOUND_FLOAT_BG_B64 = [[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btXowmd1OodPby1vWsv3a5K3at63lr0qEzup1DubOX7tdtYT/drzezl+7XW6fcfMtd0DpPYNJutjL81eweH7/ay/NXz9pd18y16jod592uevTJqHrXxG8Pf8Jv8ADq+s7dd19pn+mWv9/fGvzr/wNN3/AHytfn796v0g8K6j5Ukb18VfFjwl/wAIb441DTbddtnK32q1/wCuU/z/APjnzJ/wGscunyylSPO+2eXt1qBulWWWoWr2ahZWZahbpVl+9QtWAFdutQN0qy/eoWSgzKbVC/erj96rN0oApstRN1q43WqrLXPMzmU371C1WW6VE3Ws5nOU261VfvVx+9QtXOBTaq7dauN1qq/egVQrSLVZkq41V261zkFNutRtU1R1zzOcqt1qq/erj96rN0rjMys1V261cbrVV+9Koc5WbpUTdasNULferAzKb96harLdKgrjmB//0/wDooor2DMKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKcvWm0UAS133w18E33xG8b6P4OsW2SalcLG8n/PKL78sv/AEVmrgR1r7f/Zq0GLwx4K8R/FW8X/SLvdpGm5/4C93L+CFE/wCBNW+Foe0q8p6WV4L6xXjSO1+L/iGxvtXGkaOnk6ZpsaWtrEP+WdvAuxF/74WtH4N6Qml2+peP71fl09fstnu/iuJF+d/+AJ/6FXjlx9p1nVtkCmWa4k2xr/eeR/kWvoTx5LbeEtB0/wAE2UgZdMj2zMv/AC0uJP8AXN/33/6DX7Pwzgf+Xkj9Yoe9LmPFvGGtvdXUj7vv14/fT7mre1i882RvmribqX5qvNcVzSPNx1f3itNLvrNkappmqhI1fK1Kh485gz1EWpjdaj3VyTmc/OOpu6m0VmZjt1G6m0UAO3U6o6KAJKcGxUe6nVpCYEq9afVepE7Voac5ODmlqOng5renUOglTtU26qtTr0rUtMsp2qzG1UFerMbVrCYy4vSrKtVNWqZa64TN6ZfVqsxtVBWqzG1dsKhtA0o2q/G1ZUbVcjau+EzrhM24WrShasSNq0oXruoTO2FQ6GFq3reWuVhatu3lr1KEzvhM621l+autsZfu1wdu33a6ezlr0oHdTPS9Nn+Za9I0e6+7Xjmnz/dr0LSbr7taTKPofw7efMtZXx+8P/254NsfFUC/6Roknkzbf+fe4/8A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/NXzH8cLD7H8TNYdM7btorr/AMCIlevoTwzcfMteXftHWe3xBoeq7hturHy//AeVv/iq83C+7XOD/l4fN796harLdKrNXtG5WkqFulWXqs3SswIm61A3Sp261A3SswmVmqu3Wrjdaqv3rMzKb96harLdKrNRMCu3Wqr96tN1qBulZnOU26VWarklV261xmZVfvVZvu1ZfvVaSgCs1U5KuNVaSucyqFZ+9QtU1QtXPMgrt1qNqmfvULVznOf/1vwDooor1DMKKKKACiiigAooooAKKKKACiiigAooooAKKKKAF6cV91fswWiab8L/AIg+I3V1ku5dPsI3/hZD5s0q/wDfSx18M7etfoZ8NrZtB/ZjsGMgb+3NXv7wL/dECRW//tOuvLYfvT6ThunzYlS/lF+GK7/FGparKp26fY3cisv8LyfuU/8AQmrx/wAYXXm3kn+9Xs3w/wBlr4X8WaruKs/2S12/7EjNN/7LXz94kl33Elfs1D3MvifcV6n7o4O8b5qwZfvVsXTferBkr4qvUPmJkTdahpzU2vPmctQjopT1pK5yCOiiiszKRHRRRQQFFFFABRRRQBJRRRQaXCiiigCSimr1p1aAFFFFdAElFFFBoSUUUVoaElFFFaGiHr0paRelLXRACSpKjqSuiBoTLUydqjpy9a66Z0FhauR1TWrK9K2gaFlO1WY6rJ2qzHXXA0gX0q4lUI6uR16MDtgacPWtSGseNq1YelelQOuBs29btu1c9C1bdu1epQO6mdJbt92uqsWrj7frXVWLV7MDugd5prV6XosvzLXlemt81ekaO3zLW8/gOg948My7GWqH7Qln9o8I6Dqqr81vdSws391JE3ov/fatTPDsvzLXSfFq1+3/AAnvJmb5rK4tLhf++/J/9mry6i5asZHBP4z4kbpUTdalbpUTda903IG6VWarLdKrNWYEL96hapn71C1ZhMrt1qq/erTdagbpWZmVmqu3WrDVXbrWkwKr96rN0qy9QtXOZzKbVXbrVxutVX71hMxqFN+9QtVmSqzVkSU2qtJV1utVXrnMynULVZbpUTda55mcyq/eo6nbpUFc5mf/1/wDooor1DMKKKKACiiigAooooAKKKKACiiigAooooAKKKKAJlOGFfpBqUK6P8DPh5pCxfZmbS/tMi/7V3LLMG/4GjK1fm8Oo+tfp18aoJtGj0PwxOwaTR9L0+xbb/ft7WJH/wDQa9bKoe+fX8Jw9+rL+6c3pu+w+E7O6hf7Q1CWRW/vJGip/wCh7q+adcl3SNX0nr2yz+Gvhu2Rv9bDLcN/svJK3/xNfMGsN+8av1/NfdoUo/3T6rHT92JyV03ytWO9atw1ZTNXwdeZ8xUIWpjdKe1RHrXDM5ZiP3qOnN1ptchmxrU2iigzCiiigz5wooooDnCiiigApy02ig0JKKKKDQKkqOnbjWgDqKKK0gA8dKWiiqiaElFFFbGhJRRRWhURR1p9R1JWsChy1KOlRLUo6V1wNYEg6VOvWoB0qdetb0zcsLUydqrL0qylb0zQuJ2qaOq0dTR13QNIF+OrkdUI6uR13UDqpmlHWrBWVHWnD1r1aB1QNiH+Gte3asGL71bdvXo0TvpnSWrV0li9cxa10NjXs0Dtgdzp7fNXoukt8y15pYt8y16FpLfdrvOw9p8Py/Mter+ILf8AtL4b+IrNF8yR7GVlX/bj+f8A9lrxnw/L8y1794fie/0+6sF+9dW8sK/9tImSvFx3u++cFc/O5qhfvUzL5Xyf3PlqF+9e8bkLVTkq41V261mBA3SqzVZbpUTdaAmVX71WbpVl+9QtWZmV261VfvVputVX70AVpKrNVmSqzVzmZC/eq0lWX71WbpWEzGoVm6VTarjVWkqKhJWb71Vm6VZeqzdKxMym3Som61YkqF+9c8zOZWbpUTdasNVdutcZmf/Q/AOiiivUMwooooAKKKKACiiigAooooAKKKKACiiigAooooA6jwhpKa94q0fRJCVS/u7e3Yjss0ip/wCzV+hH7QV15vjrVERtyxTPH/37+Svjf9nvSbXW/jV4J06+/wCPeTVrQv8ARH3/APstfT3xOnm1fxdebPmkupn2/wC/I1e7kcOaZ9zwtT/c1ZF/4nMlvpej2CL5f2fTbRWX+6/lK7/+Ps1fLWqN+8avp/42XW7xFeJ93Y23b/1zSvlfUG+av1HiKfvcp7ua/Ec5P96sySr9x96qLda+HrnzFQhph60+mHrXDMwmRUUUVzmTI6KKKDAKKKKACiiigAooooAKKKKDQctOpq06gApy9abTl61oaDqKKK0AKevSmU9elaALTlptOWtDQdTl602nL1rQ0HVJUdPXpWhoPWpF61DUy9a6IFUxydqsVXqZa66ZtAsr0qZfkqsnarK/drU0LkdTR1WWrK/er0IHQXF6Vcjqgnar8dd1M6qZfjrShrKjrShavSgbQNWCtu1rEjrVt2r1KJ30zpLWuks2+auZtetdBZt81etQPRonbWPVa7/S2+7Xm9i1d/pbfdr0jogewaC33a+h/BMv+kQ/71fNmht8y19A+D5dskb15OOh7pz1j4b8RWf9na9qWmp/y6XVxD/37lZKwX716L8UrNLD4ieIraL7qXkrf9/Pn/8AZq89bpXrUfgiaQIm61VerTdagbpWgFNulRN1qVulRN1rMCBulVmqy3SqzVmZkL96rN0qy/eqzdKAKzVXbrVxutU261zmcyq/eqzdKuN0qtJWEyJlNqrt1q43Wqr96ioZFeX7tVWqy3SqzVhUMynJUL96syVWrCYELVC/erFV371zzOc//9H8A6KKK9QzCiiigAooooAKKKKACiiigAooooAKKKKACiiigD6V/ZOtLa6+O3h1rjpax390P9+3spZk/wDHlr268WbUviFp8US7me+t9q/9tVrzH9juwguvibqd9N9/StC1K4j/AN90WH/0CVq9a8Lu8vxW0eZfm8q+SRv+2fz19XwzDmqx/wAR+icMw/2T/t4574uXX2rxFqE396aVv/H6+cr5vmr2z4hT+bqVw/8AtV4bfN81fecRz/enVmM/eMGX71UT0q3L95qqHpXxdQ8CoRt0pj96e3Som61wTOQbUdSVHWZmFFFFBmFFFFABRRRQAUUUUAFFFFADlp1R05aDQdTl602itDQkopq9adQAU9elMoroAkoooq6ZoSUUg6UtaUzQkp69KYnanLW0CqY6pKjqSt4FElTLUNTLXRA6IEydqtL1qqnarS9a6DQsLUydqhWpk7V2QNIFxKuJVNO1XEruw510y/HV+Cs1K0o69KB0wNaHrWvb9ax4vu1q29erQO+mb1q1dJa/eWuYt+tdJa17NA7YHYWLfNXeaW1ee2P3lrvNLb7tejTOyB6vobfdr3vwq37yOvnvRW+7XvHhVv3kdcWO+A56x89/HK1S1+Jmrbf+Xhbe4/7+RLXj7dK94/aCtfK8eR3P/P3Y27f9+9yf+y14RXVgf4UQh8JC3WoG6VZfvULV0GhTbrUL96maoX71lUAhaq7dasNVdutQZkDdKrNVlulVmoArt1qq33qtN1qq/es5mcys3Sq0i1caq7da55mZTbrVV6uP3qs3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UTdadULUGYxulRN1obrUbVmAxulRN1pz96hagzIX71WbpT2eoX71mA1utQN0p7VDI1ZzImQtUL96e3Som61zmRA3Som61KzVWasqgEL96hapG61A3SomZjH71TkappGqu3WueZmRtUL96maoX71hM55kLPVdutSt0qs1Y1DMY3Som605+9NbrXJM5yBulVmqZ+9QtXPMD//Q/AeiiivcMwooooAKKKKACiiitACiiigAooorQAooooAKKKKACiiigAooqStDMjoqSir9mO4UUUUywooooAKKctOrQAoop200+Q0BetOooqwCipKK05DQ09N1C80m/t9S06dre7tJFkiljO143Rt6srD+Kv0Q0vXdP+P/AIGm8V20aQeKdIVF1m2T/lp/cvIk/uu/+s/uP/wCvzgruvh749134b+KrHxXoDj7Tat80cn+ruIn+/FKv8SSL8pFXD3T1MnzWWHq/wB09yuIJrC6aGVdrJW9p9/92vVvFmj6F488M2nxM8DKTpeofLNAW3y2d0n3oJf9tP8Alm38abXrwhWe1m2PX3OR5zy+7I/RKdTl9+Hwn0b8P/iHf+Fbhk2/bNNuP+Pi0Zvkb/bT+4/+3Xv2qaDo/iPS18Q+Gphc2cv/AH3G/wDddP4Hr4e0+9+7XqngvxvqvhLUPt+lyBldds0En+qmT+66V+k4XF83vROqcOb3onSax4ceJm+WuJutL2t92vrGxbw98RNPa/0HEV4i7riykb97D/t/7af7deb614VmgZk8uvYhUhI5T57m075vu1X+xGvULrRnXd8tYkmnOv8ADWvsDPkOJWzp62tdU1h/s0LYUuQOQwY7X/Zq/Da1tx2H+zV+Gw/2avkDkM23s63rWyq/b2X+zXQ2em1oBWsbCu203S922n6fpfzL8tei6Po25l+WsJz5TOcx+i6RuZflrqvE3iOw+H2ircsol1S7XbawN/6Nf/Yjqzq2r6P4D0f+1dUXzZpvlt7ZW+eZ/wD2RP8Ano9fJHiDxBqXibVJtY1aTzLiX+79xU/gVE/gSvL/AI0v7pphKHtPiKF9eXOpXM1/eTPPcXDPJI8n32eqbPTGamM1d57gM1Qs9PZqhbpQAx+9NbrQ3Wo2oAY3SmM1PbpUTdazAjaoX709ulRN1oAjamN0p7PULNWZmNbrUDdKez1C/egBrdagbpT2qF+9ZmcxjNVZ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]]
local SOUND_FLOAT_BG_ASSET
local function getSoundFloatBackground()
    if SOUND_FLOAT_BG_ASSET then return SOUND_FLOAT_BG_ASSET end
    local decode
    pcall(function()
        if crypt and crypt.base64 and crypt.base64.decode then
            decode = crypt.base64.decode
        elseif base64decode then
            decode = base64decode
        end
    end)
    local makeAsset
    pcall(function()
        makeAsset = getcustomasset or getsynasset
    end)
    if not decode or not makeAsset or not writefile then return nil end
    local ok, asset = pcall(function()
        local bytes = decode(SOUND_FLOAT_BG_B64)
        writefile("SoundHub_PurpleFloatBG.jpg", bytes)
        return makeAsset("SoundHub_PurpleFloatBG.jpg")
    end)
    if ok then SOUND_FLOAT_BG_ASSET = asset end
    return SOUND_FLOAT_BG_ASSET
end

local function buildMobileButtons()
    destroyMobileButtons()
    if not __HH.mobileButtonsEnabled then return end
    -- Lock button shape: always rounded square
    __HH.circleButtonsEnabled = false
    __HH.shapeButtonsEnabled = false
    __HH.rectangularButtonsEnabled = false
    local savedPositions = loadBtnPositions()
    local BTN_SIZE = math.floor(__HH.mobileButtonsSize * 0.65)
    local fontSize = math.max(9, math.floor(__HH.mobileButtonsSize * 0.13))
    local spacing = 20; local cols = 2
    local isRect = false -- always square; rectangular mode disabled
    local btnW = BTN_SIZE; local btnH = BTN_SIZE
    if isRect then btnW = math.floor(BTN_SIZE*1.4); btnH = math.floor(BTN_SIZE*0.75); spacing = 16 end
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local totalW = cols * btnW + (cols-1) * spacing
    local startX = viewport.X - totalW - 30; local startY = 30
    local buttonOrder = {
        {key="drop",         label="DROP BR",         toggle=false},
        {key="tpDown",       label="TP DOWN",         toggle=false},
        {key="batV2",        label="AIM BOT",          toggle=true},
        {key="tpLock",       label="TP BAT",     toggle=true},
        {key="lagger",       label="LAGGER",          toggle=true},
        {key="laggerCarry",  label="LAGGER CARRY",    toggle=true},
        {key="carrySpeed",   label="CARRY SPEED",     toggle=true},
        {key="instaReset",   label="INSTA RESET",     toggle=false},
        {key="autoLeft",     label="AUTO LEFT",       toggle=true},
        {key="autoRight",    label="AUTO RIGHT",      toggle=true},
    }
    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "VynxMobileButtons"; mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 15; mobGui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then
        mobGui.Parent = LP:WaitForChild("PlayerGui")
    end
    __HH.mobGuiRef = mobGui

    -- only render buttons that are visible
    local visibleOrder = {}
    for _, def in ipairs(buttonOrder) do
        if def.key == "autoRight" or __HH.buttonVisibility[def.key] ~= false then
            visibleOrder[#visibleOrder+1] = def
        end
    end
    for i, def in ipairs(visibleOrder) do
        local col = (i-1) % cols; local row = math.floor((i-1)/cols)
        local xPos = startX + col*(btnW+spacing); local yPos = startY + row*(btnH+spacing)
        local saved = savedPositions[def.key]
        local initX = saved and saved.xo or xPos; local initY = saved and saved.yo or yPos
        local frame = Instance.new("Frame", mobGui)
        frame.Name = "MobBtn_"..def.key
        frame.Size = UDim2.new(0,btnW,0,btnH)
        frame.Position = UDim2.new(0,initX,0,initY)
        frame.BackgroundColor3 = Color3.fromRGB(6, 12, 30); frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0; frame.Active = true; frame.ZIndex = 102
        frame:SetAttribute("BtnKey", def.key)
        -- Always square with rounded corners (Button Shapes removed)
        local cornerRadius = UDim.new(0, math.max(8, math.floor(math.min(btnW,btnH)*0.2)))
        local uic = Instance.new("UICorner", frame); uic.CornerRadius = cornerRadius
        frame.ClipsDescendants = true

        -- OFF border: small purple outline, matching every floating button.
        local fstroke = Instance.new("UIStroke", frame)
        fstroke.Name = "SoundIceRunner"
        fstroke.Color = Color3.fromRGB(40, 110, 230)
        fstroke.Thickness = 1
        fstroke.Transparency = 0.12

        -- Full-bleed wallpaper crop: image fills the whole button and follows
        -- the exact same rounded/circular shape as the button itself.
        local bgAsset = "rbxassetid://103229327971654"
        local bg, shade
        if bgAsset then
            frame.BackgroundTransparency = 0
            frame.BackgroundColor3 = Color3.fromRGB(6, 12, 30)

            bg = Instance.new("ImageLabel")
            bg.Name = "SoundPurpleImageBackground"
            bg.BackgroundTransparency = 1
            bg.BorderSizePixel = 0
            bg.AnchorPoint = Vector2.new(0.5, 0.5)
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.Position = UDim2.new(0.5, 0, 0.5, 0)
            bg.ZIndex = 103
            bg.Image = bgAsset
            bg.ScaleType = Enum.ScaleType.Fit
            bg.ImageTransparency = 0
            -- Whole image shown (no wallpaper tiles), centered and nudged up.
            bg.Parent = frame

            shade = Instance.new("Frame")
            shade.Name = "SoundPurpleTextShade"
            shade.BackgroundColor3 = Color3.fromRGB(3, 8, 22)
            shade.BackgroundTransparency = 0.35
            shade.BorderSizePixel = 0
            shade.Size = UDim2.new(1, 0, 1, 0)
            shade.ZIndex = 104
            shade.Parent = frame
            local shadeCorner = Instance.new("UICorner", shade)
            shadeCorner.CornerRadius = cornerRadius
        else
            frame.BackgroundColor3 = Color3.fromRGB(10, 22, 60)
        end

        -- Three clean, static nested borders: black (outer), purple (middle),
        -- and white (inner). They remain hidden until the toggle is ON.
        local function makeOnBorder(name, inset, color, thickness)
            local border = Instance.new("Frame")
            border.Name = name
            border.BackgroundTransparency = 1
            border.BorderSizePixel = 0
            border.Position = UDim2.new(0, inset, 0, inset)
            border.Size = UDim2.new(1, -inset * 2, 1, -inset * 2)
            border.ZIndex = 106
            border.Visible = false
            border.Active = false
            border.Parent = frame
            local bc = Instance.new("UICorner", border)
            bc.CornerRadius = UDim.new(cornerRadius.Scale, math.max(0, cornerRadius.Offset - inset))
            local stroke = Instance.new("UIStroke", border)
            stroke.Color = color
            stroke.Thickness = thickness
            stroke.Transparency = 0
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            return border
        end
        local onBorderPurple = makeOnBorder("OnBorder_Purple", 1, Color3.fromRGB(70, 150, 255), 1)
        local onBorderWhite = makeOnBorder("OnBorder_White", 3, Color3.fromRGB(255, 255, 255), 1)

        -- Static outline; no rotating gradient or animation.
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1,0,1,0)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.ClipsDescendants = true
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = cornerRadius
        btn.Text = def.label; btn.TextColor3 = Color3.fromRGB(225, 238, 255)
        btn.Font = Enum.Font.GothamBold; btn.TextSize = fontSize
        btn.LineHeight = 1.1; btn.TextWrapped = true
        btn.AutoButtonColor = false; btn.ZIndex = 110
        local isOn = false
        local function setOn(v)
            isOn = v
            if v then
                frame:SetAttribute("BtnIsOn", true)
                local color = (def.key == "carrySpeed") and Color3.fromRGB(228, 197, 255) or __HH.BTN_ON
                -- ON = solid purple fill plus the three requested borders.
                frame.BackgroundColor3 = Color3.fromRGB(25, 80, 200)
                frame.BackgroundTransparency = 0
                if bg then bg.Visible = false end
                if shade then shade.Visible = false end
                -- ALL buttons ON: full solid purple, with absolutely no border.
                onBorderPurple.Visible = false
                onBorderWhite.Visible = false
                fstroke.Transparency = 1
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                frame:SetAttribute("BtnIsOn", false)
                -- OFF = return to the full wallpaper crop and original shape.
                frame.BackgroundColor3 = Color3.fromRGB(6, 12, 30)
                frame.BackgroundTransparency = 0
                if bg then bg.Visible = true end
                if shade then shade.Visible = true end
                onBorderPurple.Visible = false
                onBorderWhite.Visible = false
                -- ALL buttons OFF: wallpaper background + small purple outline.
                fstroke.Color = Color3.fromRGB(40, 110, 230)
                fstroke.Thickness = 1
                fstroke.Transparency = 0.12
                btn.TextColor3 = Color3.fromRGB(225, 238, 255)
            end
        end
        __HH.mobBtnRefs[def.key] = setOn
        local dragData = {start=nil,startPos=nil,moved=false,down=false}
        btn.InputBegan:Connect(function(input)
            if __HH.uiLocked or not __HH.perButtonDragEnabled then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragData.moved=false; dragData.down=true
                dragData.start=input.Position; dragData.startPos=frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragData.down=false
                        if dragData.moved then pcall(saveBtnPositions) end
                    end
                end)
            end
        end)
        btn.InputChanged:Connect(function(input)
            if dragData.down and not __HH.uiLocked and __HH.perButtonDragEnabled and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragData.start
                if delta.Magnitude > DRAG_THRESHOLD then dragData.moved = true end
                if dragData.moved then
                    frame.Position = UDim2.new(dragData.startPos.X.Scale, dragData.startPos.X.Offset+delta.X, dragData.startPos.Y.Scale, dragData.startPos.Y.Offset+delta.Y)
                end
            end
        end)
        local function flashWhite()
            -- Deliberately empty: floating buttons have no click animation.
        end
        btn.MouseButton1Click:Connect(function()
            if dragData.moved then dragData.moved=false; return end
            flashWhite()
            if def.key == "tpLock" then
                if __HH.batV2Enabled then toggleBatV2() end
                toggleTPLock(); setOn(__HH.tpLockEnabled); saveConfig(); return
            end
            if def.key == "batV2" then
                if not __HH.batV2Enabled and _G.AceSafeModeTryStart
                    and not _G.AceSafeModeTryStart(true) then
                    setOn(false); saveConfig(); return
                end
                if __HH.tpLockEnabled then toggleTPLock() end
                toggleBatV2(); setOn(__HH.batV2Enabled)
                saveConfig(); return
            end
            if def.key == "carrySpeed" then
                toggleCarryMode(); setOn(carrySpeedActive)
                if __HH.mobBtnRefs.lagger then __HH.mobBtnRefs.lagger(laggerModeEnabled) end
                if __HH.mobBtnRefs.laggerCarry then __HH.mobBtnRefs.laggerCarry(laggerCarryToggled) end
                saveConfig(); return
            end
            if def.key == "lagger" then
                toggleLaggerMode(); setOn(laggerModeEnabled)
                if __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
                if __HH.mobBtnRefs.laggerCarry then __HH.mobBtnRefs.laggerCarry(laggerCarryToggled) end
                saveConfig(); return
            end
            if def.key == "laggerCarry" then
                toggleLaggerCarryMode(); setOn(laggerCarryToggled)
                if __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
                if __HH.mobBtnRefs.lagger then __HH.mobBtnRefs.lagger(laggerModeEnabled) end
                saveConfig(); return
            end
            if def.key == "drop" then runDrop(); return end
            if def.key == "tpDown" then __HH.tpToGround(); return end
            if def.key == "instaReset" then __HH.FrameReset.ResetPlayer(); return end
            if def.key == "autoLeft" then toggleAutoLeft(); return end
            if def.key == "autoRight" then toggleAutoRight(); return end
        end)
    end
    
    if __HH.mobBtnRefs.tpLock then __HH.mobBtnRefs.tpLock(__HH.tpLockEnabled) end
    if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(autoLeftEnabled) end
    if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(autoRightEnabled) end
    if __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(__HH.batV2Enabled) end
    if __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
    if __HH.mobBtnRefs.lagger then __HH.mobBtnRefs.lagger(laggerModeEnabled) end
    if __HH.mobBtnRefs.laggerCarry then __HH.mobBtnRefs.laggerCarry(laggerCarryToggled) end
end

-- loadConfig(externalCfg) applies a settings table either read from disk or
-- passed in directly (used by "Load Config" to restore a pasted code).
-- On a brand-new install (no VynxPC.json yet, or a corrupt one) it writes an
-- initial config immediately so auto-save is active from the very first run
-- instead of waiting for the user to change a setting first.
loadConfig = function(externalCfg)
    local cfg = externalCfg
    if not cfg then
        if not (isfile and isfile("VynxPC.json")) then
            saveConfig()
            return
        end
        local ok, decoded = pcall(function() return __HH.HS:JSONDecode(readfile("VynxPC.json")) end)
        if not ok or type(decoded) ~= "table" then
            saveConfig()
            return
        end
        cfg = decoded
    end
    if cfg.normalSpeed then NS = cfg.normalSpeed end
    if cfg.carrySpeed then CS = cfg.carrySpeed end
    if cfg.laggerSpeed then LAGGER_SPEED = cfg.laggerSpeed end
    if cfg.laggerCarrySpeed then LAGGER_CARRY_SPEED = cfg.laggerCarrySpeed end
    if cfg.aimbotV1Speed then aimbotV1Speed = cfg.aimbotV1Speed end
    if cfg.autoCarrySpeedEnabled ~= nil then autoCarrySpeedEnabled = cfg.autoCarrySpeedEnabled end
    if _G.Round3SpeedBooster then
        if cfg.r3Enabled ~= nil then
            _G.Round3SpeedBooster.setEnabled(cfg.r3Enabled == true)
        end
        if cfg.r3NormalSpeed then _G.Round3SpeedBooster.setNormalSpeed(cfg.r3NormalSpeed) end
        if cfg.r3CarrySpeed then _G.Round3SpeedBooster.setCarrySpeed(cfg.r3CarrySpeed) end
        if cfg.r3ForceCarry ~= nil and _G.Round3SpeedBooster.setForceCarry then
            _G.Round3SpeedBooster.setForceCarry(cfg.r3ForceCarry == true)
        end
    end
    if cfg.autoTPHeight then __HH.autoTPHeight = cfg.autoTPHeight end
    if cfg.autoJumpBrainrot ~= nil then __HH.autoJumpBrainrot = cfg.autoJumpBrainrot end
    if cfg.floatHeight then __HH.floatHeight = math.clamp(tonumber(cfg.floatHeight) or 6, 0, 200) end
    if cfg.floatEnabled ~= nil then __HH.floatEnabled = cfg.floatEnabled end
    if cfg.mobileButtonsSize then __HH.mobileButtonsSize = cfg.mobileButtonsSize end
    if cfg.antiRagdoll ~= nil then __HH.antiRagdollEnabled = cfg.antiRagdoll end
    if cfg.infiniteJump ~= nil then __HH.infJumpEnabled = cfg.infiniteJump end
    if cfg.medusaCounter ~= nil then __HH.medusaCounterEnabled = cfg.medusaCounter end
    if cfg.medusaReset ~= nil then __HH.medusaResetEnabled = cfg.medusaReset end
    if cfg.batCounter ~= nil then __HH.batCounterEnabled = cfg.batCounter end
    if cfg.carryMode ~= nil then carrySpeedActive = cfg.carryMode; speedMode = cfg.carryMode end
    if cfg.laggerMode ~= nil then laggerModeEnabled = cfg.laggerMode end
    if cfg.laggerCarryMode ~= nil then laggerCarryToggled = cfg.laggerCarryMode end
    if cfg.tpLockEnabled ~= nil then __HH.tpLockEnabled = cfg.tpLockEnabled end
    if cfg.autoSwing ~= nil then autoSwingEnabled = cfg.autoSwing end
    if cfg.mirrorTPDownEnabled ~= nil and _G.SoundMirrorTPDown
    and _G.SoundMirrorTPDown.setEnabled then
        _G.SoundMirrorTPDown.setEnabled(cfg.mirrorTPDownEnabled)
    end
    if _G.SoundBatSpam and cfg.batSpamEnabled ~= nil
    and _G.SoundBatSpam.setEnabled then
        _G.SoundBatSpam.setEnabled(cfg.batSpamEnabled)
    end
    if cfg.spinBotEnabled ~= nil and _G.SoundSpinBot then _G.SoundSpinBot.enabled = cfg.spinBotEnabled end
    if cfg.unwalkEnabled ~= nil then __HH.unwalkEnabled = cfg.unwalkEnabled end
    if cfg.antiLag ~= nil then __HH.antiLagEnabled = cfg.antiLag end
    if cfg.stretchRez ~= nil then __HH.stretchRezEnabled = cfg.stretchRez end
    if cfg.autoTPEnabled ~= nil then __HH.autoTPEnabled = cfg.autoTPEnabled end
    if cfg.guiTransparencyEnabled ~= nil then __HH.guiTransparencyEnabled = cfg.guiTransparencyEnabled end
    if cfg.mobileButtonsEnabled ~= nil then __HH.mobileButtonsEnabled = cfg.mobileButtonsEnabled end
    if cfg.circleButtonsEnabled ~= nil then __HH.circleButtonsEnabled = cfg.circleButtonsEnabled end
    if cfg.shapeButtonsEnabled ~= nil then __HH.shapeButtonsEnabled = cfg.shapeButtonsEnabled end
    if cfg.rectangularButtonsEnabled ~= nil then __HH.rectangularButtonsEnabled = cfg.rectangularButtonsEnabled end
    if cfg.antiDie ~= nil then __HH.antiDieEnabled = cfg.antiDie end
    if cfg.autoResetOnDeath ~= nil then __HH.autoResetOnDeath = cfg.autoResetOnDeath end
    if cfg.infJumpMode ~= nil then __HH.infJumpMode = cfg.infJumpMode end
    if cfg.uiLocked ~= nil then __HH.uiLocked = cfg.uiLocked end
    _G.YousefUiLocked = __HH.uiLocked
    if cfg.perButtonDragEnabled ~= nil then __HH.perButtonDragEnabled = cfg.perButtonDragEnabled end
    if cfg.batV2Enabled ~= nil then __HH.batV2Enabled = cfg.batV2Enabled end
    if cfg.batAimMode == "normal" or cfg.batAimMode == "bypass" then
        batAimMode = cfg.batAimMode
    elseif cfg.batAimMode == "v1" or cfg.batAimMode == "v2" then
        batAimMode = "normal"
    end
    if cfg.skyTheme ~= nil then __HH.currentSkyTheme = cfg.skyTheme end
    -- Keep the requested startup layout; do not let an old saved config shrink the FOCUS header.
    uiScaleValue = 0.7
    __HH.guiSizeValue = 2
        if cfg.espEnabled ~= nil then __HH.espEnabled = cfg.espEnabled end
    if type(cfg.headlessEnabled) == "boolean" then __HH.headlessEnabled = cfg.headlessEnabled end
    if type(cfg.korbloxEnabled) == "boolean" then __HH.korbloxEnabled = cfg.korbloxEnabled end
    if type(cfg.accessoryPack) == "string" then currentAccessoryPack = cfg.accessoryPack end
    if cfg.autoLeftEnabled ~= nil then autoLeftEnabled = cfg.autoLeftEnabled end
    if cfg.autoRightEnabled ~= nil then autoRightEnabled = cfg.autoRightEnabled end
    if cfg.safeMode ~= nil then antiKickEnabled = cfg.safeMode
    elseif cfg.antiKick ~= nil then antiKickEnabled = cfg.antiKick end
    if type(cfg.aceAnimationPack) == "string" then __HH.aceSelectedAnimationPack = cfg.aceAnimationPack end
    if cfg.bodyLockEnabled ~= nil then __HH.bodyLockEnabled = cfg.bodyLockEnabled == true end
    if cfg.bodyLockRange ~= nil then __HH.bodyLockRange = math.clamp(tonumber(cfg.bodyLockRange) or 20, 5, 200) end
    if cfg.antiFlingEnabled ~= nil then __HH.antiFlingEnabled = cfg.antiFlingEnabled == true end
    -- ===== Ambitious ports =====
    _G.SoundXRayEnabled                 = cfg.xrayEnabled == true
    _G.AmbitiousBrainrotXRayEnabled     = cfg.brainrotXRayEnabled == true
    _G.AmbitiousCustomToolsEnabled      = cfg.customToolsEnabled == true
    _G.AmbitiousRainbowToolsEnabled     = cfg.rainbowToolsEnabled == true
    _G.AmbitiousTransparentToolsEnabled = cfg.transparentToolsEnabled == true
    _G.AmbitiousCustomSoundsEnabled     = cfg.customSoundsEnabled == true
    _G.AmbitiousRainbowJoystickEnabled  = cfg.rainbowJoystickEnabled == true
    if type(cfg.customToolSkins) == "table" then
        _G.AmbitiousCustomToolSkins = _G.AmbitiousCustomToolSkins or {}
        for k, v in pairs(cfg.customToolSkins) do
            if type(v) == "string" then _G.AmbitiousCustomToolSkins[k] = v end
        end
    end
    _G.SoundRadiusCircleEnabled = cfg.radiusCircleEnabled == true
    if cfg.radiusCircleRadius ~= nil then
        _G.SoundRadiusCircleRadius = math.clamp(tonumber(cfg.radiusCircleRadius) or 8, 0.5, 500)
    end
    if type(cfg.radiusCircleColor) == "table" then
        local savedR = math.clamp(tonumber(cfg.radiusCircleColor[1]) or 201, 0, 255)
        local savedG = math.clamp(tonumber(cfg.radiusCircleColor[2]) or 238, 0, 255)
        local savedB = math.clamp(tonumber(cfg.radiusCircleColor[3]) or 255, 0, 255)
        if savedR == 255 and savedG == 213 and savedB == 140 then
            savedR, savedG, savedB = 201, 238, 255
        end
        _G.SoundRadiusCircleColor = Color3.fromRGB(savedR, savedG, savedB)
    end
    if type(cfg.avatarChanger) == "table" then
        -- Il modulo Avatar Changer nasce piu' avanti: si parcheggia qui e lo
        -- legge lui stesso quando viene costruito.
        _G._AmbitiousAvatarChangerPending = cfg.avatarChanger
        -- Il modulo puo' essere gia' stato costruito (gira prima di qui):
        -- in quel caso gli si passa lo stato adesso.
        if _G._AmbitiousAvatarChangerApplyPending then
            pcall(_G._AmbitiousAvatarChangerApplyPending)
        end
    end
    if _G.HorizonStealModes then
        if cfg.autoStealRadius ~= nil then _G.HorizonStealModes.SetRadius(cfg.autoStealRadius) end
        if cfg.autoStealMode == "V1" or cfg.autoStealMode == "V2" then _G.HorizonStealModes.SetMode(cfg.autoStealMode) end
        if cfg.autoStealEnabled ~= nil then _G.HorizonStealModes.SetEnabled(cfg.autoStealEnabled == true) end
    end
    __HH.aceSyncAnimationPackIndex()
    if type(cfg.buttonVisibility) == "table" then
        for k, v in pairs(cfg.buttonVisibility) do
            if __HH.buttonVisibility[k] ~= nil then __HH.buttonVisibility[k] = v end
        end
    end
    local function applyKey(target, saved)
        if not saved or not target then return end
        if saved.kb and Enum.KeyCode[saved.kb] then target.kb = Enum.KeyCode[saved.kb] else target.kb = nil end
        if saved.gp and Enum.KeyCode[saved.gp] then target.gp = Enum.KeyCode[saved.gp] else target.gp = nil end
    end
    applyKey(__HH.KB.DropBrainrot, cfg.dropBrainrotKey); 
    applyKey(__HH.KB.TPLock, cfg.tpLockKey)
    if cfg.frameResetKey then
        -- New Frame Reset keybind storage: preserve any rebind made in the
        -- existing Combat row.
        applyKey(__HH.KB.LaggerToggle, cfg.laggerToggleKey)
        applyKey(__HH.KB.InstaReset, cfg.frameResetKey)
    else
        -- Migrate old Sound configs (Lagger=R, Insta Reset=G) to the Frame
        -- layout (Frame Reset=R, Lagger=G) without moving the UI row.
        local oldLagger = cfg.laggerToggleKey
        if oldLagger and oldLagger.kb == "R" and not oldLagger.gp then
            __HH.KB.LaggerToggle.kb = Enum.KeyCode.G
            __HH.KB.LaggerToggle.gp = nil
        else
            applyKey(__HH.KB.LaggerToggle, oldLagger)
        end
        __HH.KB.InstaReset.kb = Enum.KeyCode.R
        __HH.KB.InstaReset.gp = nil
    end
    applyKey(__HH.KB.AutoLeft, cfg.autoLeftKey); applyKey(__HH.KB.AutoRight, cfg.autoRightKey); applyKey(__HH.KB.TPFloor, cfg.tpFloorKey)
    applyKey(__HH.KB.GuiHide, cfg.guiHideKey); applyKey(__HH.KB.SpeedToggle, cfg.speedToggleKey)
    applyKey(__HH.KB.BatV2Toggle, cfg.batV2Key)
    -- Always use MOBILE; ignore any previously saved PC/CONTROLLER choice.
    __HH.selectedDevice = "MOBILE"
    __HH.mobileButtonsEnabled = true
    -- Persist immediately so first-run always has a config file on disk,
    -- and so a freshly-loaded/pasted config is saved right away too.
    saveConfig()
end

local function applyState()
    if __HH.antiRagdollEnabled then __HH.stopAntiRagdoll(); __HH.startAntiRagdoll() end
    if setAntiRagVisual then setAntiRagVisual(__HH.antiRagdollEnabled) end
    if __HH.setInfJumpVisual then __HH.setInfJumpVisual(__HH.infJumpEnabled) end
    if __HH.infJumpEnabled and __HH.infJumpMode == "hold" then __HH.startHoldInfJump() end
    if __HH.setAutoJumpBrainrotVisual then __HH.setAutoJumpBrainrotVisual(__HH.autoJumpBrainrot) end
    if __HH.setFloatVisual then __HH.setFloatVisual(__HH.floatEnabled) end
    if __HH.FRFloat then __HH.FRFloat.setHeight(__HH.floatHeight or 6) end
    if __HH.floatEnabled and __HH.FRFloat then __HH.FRFloat.setEnabled(true) end
    if __HH.medusaCounterEnabled or __HH.medusaResetEnabled then
        setupMedusa(LP.Character)
        if setMedusaVisual then setMedusaVisual(__HH.medusaCounterEnabled) end
        if setMedusaResetVisual then setMedusaResetVisual(__HH.medusaResetEnabled) end
    end
    if __HH.batCounterEnabled then startBatCounter() end
    if __HH.setBatCounterVisual then __HH.setBatCounterVisual(__HH.batCounterEnabled) end
    if _G.SoundSpinBot then
        if _G.SoundSpinBot.enabled and _G.SoundSpinBot.start then _G.SoundSpinBot.start() end
        if _G.SoundSpinBot.setVisual then _G.SoundSpinBot.setVisual(_G.SoundSpinBot.enabled) end
    end
    if __HH.tpLockEnabled then
        if startTPLock then startTPLock() end
        if __HH.tpLockSetVisual then __HH.tpLockSetVisual(true) end
    end
    if __HH.unwalkEnabled then __HH.startUnwalk() end
    if setUnwalkVisual then setUnwalkVisual(__HH.unwalkEnabled) end
    if __HH.aceSelectedAnimationPack ~= "OFF" then
        pcall(function() __HH.aceApplyAnimationPack(__HH.aceSelectedAnimationPack) end)
    end
    if __HH.antiLagEnabled then enableAntiLag() end
    if setAntiLagVisual then setAntiLagVisual(__HH.antiLagEnabled) end
    if __HH.stretchRezEnabled then enableStretchRez() end
    if __HH.setStretchRezVisual then __HH.setStretchRezVisual(__HH.stretchRezEnabled) end
    if __HH.autoTPEnabled then startAutoTP() end
    if __HH.setAutoTPVisual then __HH.setAutoTPVisual(__HH.autoTPEnabled) end
    if __HH.batV2Enabled then toggleBatV2() end
    if __HH.batV2SetVisual then __HH.batV2SetVisual(__HH.batV2Enabled) end
    if _G.SoundMirrorTPDown and _G.SoundMirrorTPDown.enabled
    and _G.SoundMirrorTPDownSetVisual then
        pcall(_G.SoundMirrorTPDownSetVisual, _G.SoundMirrorTPDown.enabled())
    end
    if _G.SoundBatSpam and _G.SoundBatSpam.enabled and _G.SoundBatSpamSetVisual then
        pcall(_G.SoundBatSpamSetVisual, _G.SoundBatSpam.enabled())
    end
    if __HH.antiDieEnabled then __HH.startAntiDie() end
    if __HH.setAntiDieVisual then __HH.setAntiDieVisual(__HH.antiDieEnabled) end
    if __HH.autoResetOnDeath then __HH.setupDeathReset() end
    if __HH.setAutoResetOnDeathVisual then __HH.setAutoResetOnDeathVisual(__HH.autoResetOnDeath) end
    if __HH.bodyLockEnabled and not __HH.batV2Enabled and not __HH.tpLockEnabled and __HH.startBodyLock then __HH.startBodyLock() end
    if __HH.setBodyLockVisual then __HH.setBodyLockVisual(__HH.bodyLockEnabled) end
    if __HH.setAntiFlingVisual then __HH.setAntiFlingVisual(__HH.antiFlingEnabled) end
    refreshSpeedModeLabel()
    
    if __HH.currentSkyTheme and __HH.currentSkyTheme ~= "Off" then applySkyTheme(__HH.currentSkyTheme) end
    if __HH.mainFrame and __HH.uiScaleObject then __HH.uiScaleObject.Scale = uiScaleValue end
    if __HH.mainFrame then
        local sizeStep = ((__HH.guiSizeValue or 3) - 3) * 50
        __HH.mainFrame.Size = UDim2.new(0, 480 + sizeStep, 0, 500 + sizeStep)
    end
    if autoLeftEnabled then startAutoLeft() end
    if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
    if autoRightEnabled then startAutoRight() end
    if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
    if __HH.espEnabled and startPlayerESP then startPlayerESP() end
    if __HH.setESPVisual then __HH.setESPVisual(__HH.espEnabled) end
    if __HH.headlessEnabled or __HH.korbloxEnabled then
        task.spawn(function()
            task.wait(0.4)
            local char = LP.Character
            if char then
                pcall(function()
                    if __HH.headlessEnabled then applyHeadless(char, true) end
                    if __HH.korbloxEnabled then applyKorblox(char, true) end
                end)
            end
        end)
    end
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then
        task.spawn(function()
            task.wait(0.5)
            local char = LP.Character
            if char and currentAccessoryPack ~= "Off" then
                pcall(function() applyAccessoryPack(currentAccessoryPack) end)
            end
        end)
    end
    if setSafeModeVisual then setSafeModeVisual(antiKickEnabled) end
end

-- ============================================
-- GALAXY AUTO STEAL (V1 / V2 only)
-- Galaxy timing/trigger behavior. Only V1 and V2 are exposed in Horizon;
-- the internal 9-stud trigger distance is not shown in the UI.
do
    local P=game:GetService("Players"); local R=game:GetService("RunService"); local me=P.LocalPlayer
    local galaxy={
        enabled=false, conn=nil, busy=false, radius=60, finishRange=9,
        version="V1", data={}, stopTime=0.96, stopPercent=0.73,
    }
    local desired=true; local suspended=false
    local VERSION_CONFIG={
        V1={stopPercent=0.73,duration=0.96/0.73},
        -- V2 uses the same timing/logic as V1
        V2={stopPercent=0.73,duration=0.96/0.73},
    }

    local function applyGalaxyVersion(v)
        if v~="V1" and v~="V2" then v="V1" end
        local cfg=VERSION_CONFIG[v]
        galaxy.version=v
        galaxy.stopPercent=cfg.stopPercent
        galaxy.duration=cfg.duration
    end
    applyGalaxyVersion("V1")

    local function galaxyMine(plot)
        local sign=plot and plot:FindFirstChild("PlotSign")
        local y=sign and sign:FindFirstChild("YourBase")
        return y and y:IsA("BillboardGui") and y.Enabled==true
    end

    local function galaxyNearest()
        local c=me.Character
        local root=c and c:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local plots=workspace:FindFirstChild("Plots")
        if not plots then return end
        local best,bd,bn,bsp=nil,math.huge,nil,nil
        for _,plot in ipairs(plots:GetChildren()) do
            if not galaxyMine(plot) then
                local pods=plot:FindFirstChild("AnimalPodiums")
                if pods then
                    for _,pod in ipairs(pods:GetChildren()) do
                        local base=pod:FindFirstChild("Base")
                        local sp=base and base:FindFirstChild("Spawn")
                        if sp then
                            local d=(sp.Position-root.Position).Magnitude
                            if d<=galaxy.radius and d<bd then
                                for _,pr in ipairs(sp:GetDescendants()) do
                                    local ac=pr:IsA("ProximityPrompt") and (pr.ActionText or "") or ""
                                    if ac:find("Steal") then
                                        best,bd,bn,bsp=pr,d,pod.Name,sp
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return best,bn,bsp
    end

    local function galaxyValid()
        return desired and not suspended and galaxy.enabled
    end

    local function galaxyExecute(pr,pod,sp)
        if galaxy.busy or not galaxyValid() then return end
        if not galaxy.data[pr] then
            galaxy.data[pr]={hold={},trigger={},ready=true}
            pcall(function()
                local gc=rawget(getfenv and getfenv() or _G,"getconnections") or getconnections
                if gc then
                    for _,c in ipairs(gc(pr.PromptButtonHoldBegan)) do
                        if c.Function then table.insert(galaxy.data[pr].hold,c.Function) end
                    end
                    for _,c in ipairs(gc(pr.Triggered)) do
                        if c.Function then table.insert(galaxy.data[pr].trigger,c.Function) end
                    end
                end
            end)
        end
        local data=galaxy.data[pr]
        if not data.ready then return end
        data.ready=false; galaxy.busy=true
        task.spawn(function()
            pcall(function()
                if #data.hold>0 then
                    for _,f in ipairs(data.hold) do task.spawn(f) end
                else
                    pr:InputHoldBegin()
                end

                local started=tick()
                local duration=galaxy.duration
                local promptFired=false

                -- Galaxy's fixed stop point; only V1/V2 change the percentage.
                while galaxyValid() and pr.Parent and tick()-started<galaxy.stopTime do
                    local pct=math.clamp((tick()-started)/duration,0,1)
                    if _G.StealBar then
                        _G.StealBar.SetState("STEALING")
                        _G.StealBar.SetProgress(pct,"STEALING")
                    end
                    local c=me.Character
                    local root=c and c:FindFirstChild("HumanoidRootPart")
                    if root and sp and (root.Position-sp.Position).Magnitude>galaxy.radius then return end
                    task.wait()
                end
                if not galaxyValid() or not pr.Parent then return end

                if _G.StealBar then
                    _G.StealBar.SetProgress(galaxy.stopPercent,"STEALING")
                end

                -- Internal Galaxy trigger distance; it is intentionally hidden
                -- from the Horizon UI.
                while galaxyValid() and pr.Parent do
                    local c=me.Character
                    local root=c and c:FindFirstChild("HumanoidRootPart")
                    if root and sp and (root.Position-sp.Position).Magnitude<=galaxy.finishRange then break end
                    if root and sp and (root.Position-sp.Position).Magnitude>galaxy.radius then return end
                    if _G.StealBar then _G.StealBar.SetProgress(galaxy.stopPercent,"STEALING") end
                    task.wait()
                end
                if not galaxyValid() or not pr.Parent then return end

                local fill=tick()
                local fillDuration=math.max(duration-galaxy.stopTime,.05)
                while galaxyValid() and pr.Parent do
                    local fp=math.clamp((tick()-fill)/fillDuration,0,1)
                    if _G.StealBar then
                        _G.StealBar.SetProgress(galaxy.stopPercent+fp*(1-galaxy.stopPercent),"STEALING")
                    end
                    if fp>=1 and not promptFired then
                        promptFired=true
                        for _,f in ipairs(data.trigger) do task.spawn(f) end
                        local re=game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")
                        if re and pod then re:FireServer(pod) end
                        if pr then pcall(function() pr:Fire() end) end
                        break
                    end
                    task.wait()
                end
            end)
            pcall(function() pr:InputHoldEnd() end)
            data.ready=true; galaxy.busy=false
            if _G.StealBar then _G.StealBar.Reset() end
        end)
    end

    local function stopGalaxy()
        galaxy.enabled=false
        galaxy.busy=false
        if galaxy.conn then galaxy.conn:Disconnect();galaxy.conn=nil end
        if _G.StealBar then _G.StealBar.Reset() end
    end

    local function applyGalaxy()
        stopGalaxy()
        if not desired or suspended then return end
        galaxy.enabled=true
        galaxy.conn=R.Heartbeat:Connect(function()
            if galaxy.busy or not galaxyValid() then return end
            local p,n,sp=galaxyNearest()
            if p then galaxyExecute(p,n,sp) end
        end)
    end

    _G.HorizonStealModes={
        SetMode=function(m)
            applyGalaxyVersion(m=="V2" and "V2" or "V1")
            applyGalaxy()
            if _G.StealBar then _G.StealBar.Reset() end
        end,
        GetMode=function() return galaxy.version end,
        SetEnabled=function(on)
            desired=on==true
            applyGalaxy()
            if _G.StealBar then _G.StealBar.Reset() end
        end,
        GetEnabled=function() return desired end,
        Suspend=function() suspended=true;applyGalaxy() end,
        Resume=function() suspended=false;applyGalaxy() end,
        IsSuspended=function() return suspended end,
        SetRadius=function(v)
            galaxy.radius=math.max(1,tonumber(v) or 60)
        end,
        GetRadius=function() return galaxy.radius end,
    }
    applyGalaxy()
end

do
    local P=game:GetService("Players"); local R=game:GetService("RunService"); local me=P.LocalPlayer
    __HH.bodyLockEnabled=false; __HH.bodyLockRange=20; __HH.bodyLockConn=nil; __HH.setBodyLockVisual=nil
    local function stopBL()
        if __HH.bodyLockConn then __HH.bodyLockConn:Disconnect();__HH.bodyLockConn=nil end
        local c=me.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local r=c and c:FindFirstChild("HumanoidRootPart")
        if h then h.AutoRotate=true end;if r then r.AssemblyAngularVelocity=Vector3.zero end
    end
    __HH.stopBodyLock=stopBL
    __HH.startBodyLock=function()
        stopBL(); if not __HH.bodyLockEnabled or __HH.batV2Enabled or __HH.tpLockEnabled then return end
        __HH.bodyLockConn=R.RenderStepped:Connect(function()
            if __HH.batV2Enabled or __HH.tpLockEnabled then return end
            local c=me.Character;local root=c and c:FindFirstChild("HumanoidRootPart");local hum=c and c:FindFirstChildOfClass("Humanoid");if not root or not hum then return end
            local target,dist=nil,math.huge
            for _,p in ipairs(P:GetPlayers()) do if p~=me and p.Character then local tr=p.Character:FindFirstChild("HumanoidRootPart");local th=p.Character:FindFirstChildOfClass("Humanoid")
                if tr and th and th.Health>0 then local d=(tr.Position-root.Position).Magnitude;if d<dist then target,dist=tr,d end end end end
            if not target or dist>__HH.bodyLockRange then hum.AutoRotate=true;return end
            hum.AutoRotate=false
            local tv=target.AssemblyLinearVelocity
            local predicted=target.Position+tv*math.clamp(tv.Magnitude/80,.08,.35)
            local head=target.Parent and target.Parent:FindFirstChild("Head")
            local targetY=head and head.Position.Y or target.Position.Y
            local correction=math.clamp((targetY-(root.Position.Y+(hum.HipHeight or 0)))*.15,-1.5,1.5)
            local flat=Vector3.new(predicted.X,root.Position.Y+correction,predicted.Z)
            if (flat-root.Position).Magnitude>.1 then
                local goal=CFrame.lookAt(root.Position,flat);local diff=root.CFrame:Inverse()*goal
                local _,ry,_=diff:ToEulerAnglesXYZ();ry=math.clamp(ry,-2.5,2.5)
                root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(0,ry*42,0))
            end
        end)
    end

    __HH.antiFlingEnabled=false; __HH.setAntiFlingVisual=nil
    local fixing=false;local untilT=0
    R.Heartbeat:Connect(function()
        if not __HH.antiFlingEnabled or __HH.batV2Enabled or __HH.tpLockEnabled or __HH.dropActive then fixing=false;return end
        local c=me.Character;local root=c and c:FindFirstChild("HumanoidRootPart");if not root then return end
        if fixing then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero;if os.clock()>=untilT then fixing=false end
        elseif root.AssemblyLinearVelocity.Magnitude>=140 or root.AssemblyAngularVelocity.Magnitude>=90 then fixing=true;untilT=os.clock()+.15 end
    end)

    __HH.antiVoidTPBat=false;local hist={}
    R.Heartbeat:Connect(function()
        if not __HH.antiVoidTPBat then hist={};return end
        local c=me.Character;local root=c and c:FindFirstChild("HumanoidRootPart");if not root then return end
        local now=os.clock();table.insert(hist,{t=now,p=root.Position});while #hist>0 and now-hist[1].t>2 do table.remove(hist,1) end
        local old=nil;for i=#hist,1,-1 do if hist[i].t<=now-.6 then old=hist[i].p;break end end
        if old and (root.Position-old).Magnitude>150 then root.CFrame=CFrame.new(old);root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero;hist={} end
    end)
end

-- ============================================
-- ESP (UVA DUELS port): mini avatar billboard + highlight box + tracer lines
-- ============================================
do
    local playerData = {}
    local playerSPConnections = {}
    local playerSPRenderConn = nil
    local playerSPRunning = false

    local ESP_CONFIG = {
        CircleSize = 32,
        AvatarOffset = 2.5,
        LineColor = Color3.fromRGB(216, 172, 255),
        LineThickness = 1.5,
        BoxColor = Color3.fromRGB(216, 173, 255),
        BoxThickness = 2,
        GlowColor = Color3.fromRGB(230, 201, 255),
        GlowSize = 0.65,
        GlowTransparency = 0.05,
        FontSize = 10,
        NameOffset = 2,
    }

    -- clean leftovers from previous versions / previous runs
    pcall(function()
        for _, d in ipairs(workspace:GetDescendants()) do
            if d.Name == "VoidedESP" or d.Name == "VoidedESPTag"
                or d.Name == "MiniAvatarESP" or d.Name == "RedESPBox" then
                d:Destroy()
            end
        end
        local function sweep(root)
            if not root then return end
            for _, g in ipairs(root:GetChildren()) do
                if string.sub(g.Name, 1, 11) == "HorizonESP_" or string.sub(g.Name, 1, 8) == "DiceESP_" then
                    g:Destroy()
                end
            end
        end
        sweep(game:GetService("CoreGui"))
        sweep(LP:FindFirstChildOfClass("PlayerGui"))
    end)

    local function createPlayerSPBillboard(player, char)
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        local existing = head:FindFirstChild("MiniAvatarESP")
        if existing then existing:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "MiniAvatarESP"
        billboard.Size = UDim2.new(0, 80, 0, 110)
        billboard.StudsOffset = Vector3.new(0, ESP_CONFIG.AvatarOffset, 0)
        billboard.AlwaysOnTop = true
        billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        billboard.Parent = head

        local container = Instance.new("Frame", billboard)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.ClipsDescendants = false

        local circleSize = ESP_CONFIG.CircleSize
        local radius = circleSize / 2

        local circleBg = Instance.new("Frame", container)
        circleBg.Size = UDim2.new(0, circleSize, 0, circleSize)
        circleBg.Position = UDim2.new(0.5, -radius, 0, 0)
        circleBg.BackgroundColor3 = Color3.fromRGB(26, 11, 39)
        circleBg.BackgroundTransparency = 0.3
        circleBg.BorderSizePixel = 0
        circleBg.ZIndex = 1

        local corner = Instance.new("UICorner", circleBg)
        corner.CornerRadius = UDim.new(1, 0)

        local stroke = Instance.new("UIStroke", circleBg)
        stroke.Color = Color3.fromRGB(216, 172, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.5

        local avatarImage = Instance.new("ImageLabel", circleBg)
        avatarImage.Size = UDim2.new(1, -4, 1, -4)
        avatarImage.Position = UDim2.new(0, 2, 0, 2)
        avatarImage.BackgroundTransparency = 1
        avatarImage.ZIndex = 2

        local avatarUrl = string.format(
            "https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png",
            player.UserId
        )
        avatarImage.Image = avatarUrl

        local nameLabel = Instance.new("TextLabel", container)
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.Position = UDim2.new(0, 0, 0, circleSize + ESP_CONFIG.NameOffset)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.DisplayName or player.Name
        nameLabel.TextColor3 = Color3.fromRGB(216, 172, 255)
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0.3
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = ESP_CONFIG.FontSize
        nameLabel.TextScaled = false
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
        nameLabel.ZIndex = 3

        return billboard
    end

    local function createPlayerSPBox(char)
        if not char then return end
        local existing = char:FindFirstChild("RedESPBox")
        if existing then existing:Destroy() end

        local highlight = Instance.new("Highlight")
        highlight.Name = "RedESPBox"
        highlight.Adornee = char
        highlight.FillColor = ESP_CONFIG.BoxColor
        highlight.OutlineColor = Color3.fromRGB(0,0,0)
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0.1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        return highlight
    end

    -- Small light-blue point that stays directly under every ESP target (non-Neon).
    local function createPlayerSPGlow(player)
        local old = workspace:FindFirstChild("HorizonESPGlow_" .. tostring(player.UserId))
        if old then old:Destroy() end

        local glow = Instance.new("Part")
        glow.Name = "HorizonESPGlow_" .. tostring(player.UserId)
        glow.Shape = Enum.PartType.Ball
        glow.Size = Vector3.new(ESP_CONFIG.GlowSize, ESP_CONFIG.GlowSize, ESP_CONFIG.GlowSize)
        glow.Anchored = true
        glow.CanCollide = false
        glow.CanTouch = false
        glow.CanQuery = false
        glow.CastShadow = false
        glow.Material = Enum.Material.SmoothPlastic
        glow.Color = ESP_CONFIG.GlowColor
        glow.Transparency = ESP_CONFIG.GlowTransparency
        glow.CFrame = CFrame.new(0, -10000, 0)
        glow.Parent = workspace

        local light = Instance.new("PointLight", glow)
        light.Name = "HorizonESPBlueLight"
        light.Color = ESP_CONFIG.GlowColor
        light.Brightness = 2.5
        light.Range = 9
        light.Shadows = false
        return glow
    end

    local function setupPlayerESP(player)
        if player == LP then return end
        if playerData[player] then return end

        local data = {
            Line = nil,
            Billboard = nil,
            Box = nil,
            Glow = nil,
            Connections = {},
        }

        local line = nil
        if Drawing and type(Drawing.new) == "function" then
            line = Drawing.new("Line")
            line.Color = ESP_CONFIG.LineColor
            line.Thickness = ESP_CONFIG.LineThickness
            line.Transparency = 0.6
            line.Visible = false
        end
        data.Line = line
        data.Glow = createPlayerSPGlow(player)

        local charAddedConn = player.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            local bill = createPlayerSPBillboard(player, char)
            if bill then data.Billboard = bill end
            local box = createPlayerSPBox(char)
            if box then data.Box = box end

            char:GetPropertyChangedSignal("Parent"):Connect(function()
                if not char.Parent then
                    if data.Billboard then pcall(function() data.Billboard:Destroy() end); data.Billboard = nil end
                    if data.Box then pcall(function() data.Box:Destroy() end); data.Box = nil end
                end
            end)
        end)

        table.insert(data.Connections, charAddedConn)

        local nameChangedConn = player:GetPropertyChangedSignal("DisplayName"):Connect(function()
            if data.Billboard then
                local nameLabel = data.Billboard:FindFirstChildWhichIsA("TextLabel")
                if nameLabel then nameLabel.Text = player.DisplayName end
            end
        end)
        table.insert(data.Connections, nameChangedConn)

        if player.Character then
            task.wait(0.2)
            local bill = createPlayerSPBillboard(player, player.Character)
            if bill then data.Billboard = bill end
            local box = createPlayerSPBox(player.Character)
            if box then data.Box = box end
        end

        playerData[player] = data
    end

    local function removePlayerESP(player)
        if playerData[player] then
            if playerData[player].Line then
                pcall(function() playerData[player].Line:Remove() end)
            end
            if playerData[player].Billboard then
                pcall(function() playerData[player].Billboard:Destroy() end)
            end
            if playerData[player].Box then
                pcall(function() playerData[player].Box:Destroy() end)
            end
            if playerData[player].Glow then
                pcall(function() playerData[player].Glow:Destroy() end)
            end
            for _, conn in ipairs(playerData[player].Connections or {}) do
                pcall(function() conn:Disconnect() end)
            end
            playerData[player] = nil
        end
    end

    local function updatePlayerSPLines()
        local myChar = LP.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if not myHrp then
            for _, data in pairs(playerData) do
                if data.Line then data.Line.Visible = false end
            end
            return
        end

        local myPos, visible = workspace.CurrentCamera:WorldToViewportPoint(myHrp.Position)
        if not visible then
            for _, data in pairs(playerData) do
                if data.Line then data.Line.Visible = false end
            end
            return
        end

        for player, data in pairs(playerData) do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp then
                -- Keep the light point attached under the actual character,
                -- not on the floor. It follows flight, falling and dead bodies.
                if data.Glow and data.Glow.Parent then
                    local bottomOffset = (hrp.Size.Y * 0.5) + 2.35
                    data.Glow.CFrame = CFrame.new(hrp.Position - Vector3.new(0, bottomOffset, 0))
                    data.Glow.Transparency = ESP_CONFIG.GlowTransparency
                end
                local targetPos, visible2 = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if data.Line then
                    if visible2 then
                        data.Line.Visible = true
                        data.Line.From = Vector2.new(myPos.X, myPos.Y)
                        data.Line.To = Vector2.new(targetPos.X, targetPos.Y)
                    else
                        data.Line.Visible = false
                    end
                end
            else
                if data.Line then data.Line.Visible = false end
                if data.Glow and data.Glow.Parent then
                    data.Glow.CFrame = CFrame.new(0, -10000, 0)
                end
            end
        end
    end

    function startPlayerESP()
        if playerSPRunning then return end
        playerSPRunning = true
        __HH.espEnabled = true

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                setupPlayerESP(player)
            end
        end

        if playerSPRenderConn then playerSPRenderConn:Disconnect() end
        playerSPRenderConn = RunService.RenderStepped:Connect(function()
            pcall(updatePlayerSPLines)
        end)

        local playerAddedConn = Players.PlayerAdded:Connect(function(p)
            if p ~= LP then setupPlayerESP(p) end
        end)
        table.insert(playerSPConnections, playerAddedConn)

        local playerRemovingConn = Players.PlayerRemoving:Connect(function(p)
            removePlayerESP(p)
        end)
        table.insert(playerSPConnections, playerRemovingConn)

        local charAddedConn = LP.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            for player, data in pairs(playerData) do
                if player.Character then
                    local bill = createPlayerSPBillboard(player, player.Character)
                    if bill then
                        if data.Billboard then pcall(function() data.Billboard:Destroy() end) end
                        data.Billboard = bill
                    end
                    local box = createPlayerSPBox(player.Character)
                    if box then
                        if data.Box then pcall(function() data.Box:Destroy() end) end
                        data.Box = box
                    end
                end
            end
        end)
        table.insert(playerSPConnections, charAddedConn)
    end

    function stopPlayerESP()
        if not playerSPRunning then return end
        playerSPRunning = false
        __HH.espEnabled = false

        if playerSPRenderConn then
            playerSPRenderConn:Disconnect()
            playerSPRenderConn = nil
        end

        for _, conn in ipairs(playerSPConnections) do
            pcall(function() conn:Disconnect() end)
        end
        playerSPConnections = {}

        for player, data in pairs(playerData) do
            removePlayerESP(player)
        end
        playerData = {}
    end
end

-- ============================================
-- AVATAR (Nexus port): Headless + Korblox (client-side cosmetics)
-- ============================================
local HEADLESS_MESH_ID  = "rbxassetid://1095708"
local KORBLOX_MESH_ID   = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local cosmeticState = setmetatable({}, {__mode = "k"})

function applyHeadless(char, enabled)
    local head = char and char:FindFirstChild("Head"); if not head then return end
    local state = cosmeticState[char] or {}; cosmeticState[char] = state
    if enabled then
        if state.headTransparency == nil then
            state.headTransparency = head.Transparency; state.headCanCollide = head.CanCollide
            local face = head:FindFirstChild("face"); state.face = face and face:Clone() or nil
        end
        head.Transparency = 1; head.CanCollide = false
        local face = head:FindFirstChild("face"); if face then face:Destroy() end
        local old = head:FindFirstChild("HorizonHeadlessMesh"); if old then old:Destroy() end
        local mesh = Instance.new("SpecialMesh", head)
        mesh.Name = "HorizonHeadlessMesh"; mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID; mesh.Scale = Vector3.new(.001, .001, .001)
    else
        local mesh = head:FindFirstChild("HorizonHeadlessMesh"); if mesh then mesh:Destroy() end
        if state.headTransparency ~= nil then
            head.Transparency = state.headTransparency; head.CanCollide = state.headCanCollide
            if state.face and not head:FindFirstChild("face") then state.face:Clone().Parent = head end
            state.headTransparency = nil; state.headCanCollide = nil; state.face = nil
        end
    end
end

function applyKorblox(char, enabled)
    local hum = char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local state = cosmeticState[char] or {}; cosmeticState[char] = state
    if hum.RigType == Enum.HumanoidRigType.R6 then
        local leg = char:FindFirstChild("Right Leg"); if not leg then return end
        if enabled then
            if not state.r6LegColor then
                state.r6LegColor = leg.Color; state.r6Meshes = {}
                for _, v in ipairs(leg:GetChildren()) do
                    if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then
                        table.insert(state.r6Meshes, v:Clone()); v:Destroy()
                    end
                end
            end
            leg.Color = Color3.fromRGB(64, 64, 64)
            local old = leg:FindFirstChild("HorizonKorbloxMesh"); if old then old:Destroy() end
            local mesh = Instance.new("SpecialMesh", leg)
            mesh.Name = "HorizonKorbloxMesh"; mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = KORBLOX_MESH_ID; mesh.TextureId = KORBLOX_TEXTURE_ID
        else
            local mesh = leg:FindFirstChild("HorizonKorbloxMesh"); if mesh then mesh:Destroy() end
            if state.r6LegColor then leg.Color = state.r6LegColor end
            if state.r6Meshes then for _, v in ipairs(state.r6Meshes) do v:Clone().Parent = leg end end
            state.r6LegColor = nil; state.r6Meshes = nil
        end
    else
        local upper = char:FindFirstChild("RightUpperLeg")
        local lower = char:FindFirstChild("RightLowerLeg")
        local foot  = char:FindFirstChild("RightFoot")
        if not upper then return end
        if enabled then
            if not state.r15Transparency then
                state.r15Transparency = {upper.Transparency, lower and lower.Transparency or 0, foot and foot.Transparency or 0}
            end
            upper.Transparency = 1; if lower then lower.Transparency = 1 end; if foot then foot.Transparency = 1 end
            local old = char:FindFirstChild("HorizonKorbloxLeg"); if old then old:Destroy() end
            local leg = Instance.new("Part", char)
            leg.Name = "HorizonKorbloxLeg"; leg.Size = Vector3.new(1, 2, 1)
            leg.Anchored = false; leg.CanCollide = false; leg.Massless = true; leg.Color = Color3.fromRGB(64, 64, 64)
            local mesh = Instance.new("SpecialMesh", leg)
            mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = KORBLOX_MESH_ID; mesh.TextureId = KORBLOX_TEXTURE_ID
            local weld = Instance.new("Weld", leg)
            weld.Name = "HorizonKorbloxWeld"; weld.Part0 = upper; weld.Part1 = leg; weld.C0 = CFrame.new(0, -.8, 0)
        else
            local vals = state.r15Transparency
            if vals then
                upper.Transparency = vals[1]
                if lower then lower.Transparency = vals[2] end
                if foot then foot.Transparency = vals[3] end
            end
            local leg = char:FindFirstChild("HorizonKorbloxLeg"); if leg then leg:Destroy() end
            state.r15Transparency = nil
        end
    end
end

-- re-apply cosmetics on respawn
LP.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    pcall(function()
        if __HH.headlessEnabled then applyHeadless(char, true) end
        if __HH.korbloxEnabled then applyKorblox(char, true) end
    end)
end)

-- ============================================
-- CATALOG CHANGER (VisDuels port): Pack Accessory — Bleed 1 / Bleed 2 / Bleed 3
-- Changes shirt / pants / head / accessory / korblox (client-side).
-- ============================================
currentAccessoryPack = "Off"
__HH.OriginalOutfit = {shirt = nil, pants = nil}
__HH.OriginalAccessories = {}

local ACCESSORY_PACK_ORDER = {
    {"Off", "Off"},
    {"Bleed 1", "Bleed 1"},
    {"Bleed 2", "Bleed 2"},
    {"Bleed 3", "Bleed 3"},
}

local BLEED_PACKS = {
    ["Bleed 1"] = {
        accessory = 306969564,
        offset = Vector3.new(0.0000, 0.3000, 0.0000),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=10632503795",
        pants = "http://www.roblox.com/asset/?id=123161592384863",
        korblox = "right",
    },
    ["Bleed 2"] = {
        accessory = 1744060292,
        offset = Vector3.new(0.0000, 1.4000, -0.2000),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11526718530",
        pants = "http://www.roblox.com/asset/?id=93710523210027",
        korblox = "right",
    },
    ["Bleed 3"] = {
        accessory = 112564966849233,
        offset = Vector3.new(0.0000, 0.6000, 0.0000),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11849088376",
        pants = "http://www.roblox.com/asset/?id=16534673928",
        korblox = "right",
    },
}

local function saveOriginalOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    __HH.OriginalOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    __HH.OriginalOutfit.pants = pants and pants.PantsTemplate or nil
end

local function restoreOriginalOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then
            obj:Destroy()
        end
    end
    if __HH.OriginalOutfit.shirt then
        local newShirt = Instance.new("Shirt")
        newShirt.ShirtTemplate = __HH.OriginalOutfit.shirt
        newShirt.Parent = char
    end
    if __HH.OriginalOutfit.pants then
        local newPants = Instance.new("Pants")
        newPants.PantsTemplate = __HH.OriginalOutfit.pants
        newPants.Parent = char
    end
    __HH.OriginalOutfit.shirt = nil
    __HH.OriginalOutfit.pants = nil
end

local function clearAllOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then
            obj:Destroy()
        end
    end
end

local function saveOriginalAccessories(char)
    __HH.OriginalAccessories = {}
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            local clone = child:Clone()
            table.insert(__HH.OriginalAccessories, clone)
        end
    end
end

local function restoreOriginalAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then
            child:Destroy()
        end
    end
    for _, clone in ipairs(__HH.OriginalAccessories) do
        if clone and clone.Parent == nil then
            local newAcc = clone:Clone()
            newAcc.Parent = char
            for _, weld in ipairs(newAcc:GetDescendants()) do
                if weld:IsA("Weld") or weld:IsA("WeldConstraint") then
                    if weld:IsA("Weld") then
                        local part0Name = weld.Part0 and weld.Part0.Name
                        local part1Name = weld.Part1 and weld.Part1.Name
                        if part0Name then
                            local newPart0 = char:FindFirstChild(part0Name)
                            if newPart0 then weld.Part0 = newPart0 end
                        end
                        if part1Name then
                            local newPart1 = char:FindFirstChild(part1Name)
                            if newPart1 then weld.Part1 = newPart1 end
                        end
                    elseif weld:IsA("WeldConstraint") then
                        local part0Name = weld.Part0 and weld.Part0.Name
                        local part1Name = weld.Part1 and weld.Part1.Name
                        if part0Name then
                            local newPart0 = char:FindFirstChild(part0Name)
                            if newPart0 then weld.Part0 = newPart0 end
                        end
                        if part1Name then
                            local newPart1 = char:FindFirstChild(part1Name)
                            if newPart1 then weld.Part1 = newPart1 end
                        end
                    end
                end
            end
        end
    end
    __HH.OriginalAccessories = {}
end

local function clearAllAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then
            child:Destroy()
        end
        if child.Name:find("Korblox_") or child.Name:find("Headless_") then
            child:Destroy()
        end
    end
    local partsToHide = {"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
    for _, partName in ipairs(partsToHide) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") then
        head.Transparency = 0
    end
end

local function applyBleedOutfit(packName)
    local config = BLEED_PACKS[packName]
    if not config then return false end

    local char = LP.Character
    if not char then return false end

    char:WaitForChild("Head", 10)
    local head = char:FindFirstChild("Head")
    if not head then return false end

    if config.headMesh then
        for _, d in ipairs(char:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
                pcall(function() d:Destroy() end)
            end
        end
        local done = false
        if head:IsA("MeshPart") then
            done = pcall(function()
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            end)
        end
        if not done then
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head
            sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = config.headMesh
            sm.TextureId = config.headTexture or ""
        end
    end

    if config.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
    end
    if config.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
    end

    if config.accessory and head then
        local old = char:FindFirstChild("AuFfitAccessory")
        if old then old:Destroy() end
        local objs = nil
        local ok, res = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(config.accessory))
        end)
        if ok and typeof(res) == "table" and #res > 0 then
            objs = res
        else
            ok, res = pcall(function()
                return game:GetService("InsertService"):LoadAsset(config.accessory)
            end)
            if ok and res then objs = {res} end
        end
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = CFrame.new(config.offset or Vector3.zero)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    if config.korblox and config.korblox ~= "none" then
        local function attachKorblox(side)
            local ids = { left = 139607673, right = 139607718 }
            local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
            local hides = {
                left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
                right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
            }
            local targetPart = char:FindFirstChild(targets[side])
            if not targetPart then return false end
            for _, partName in ipairs(hides[side]) do
                local limb = char:FindFirstChild(partName)
                if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
            end
            local success, objects = pcall(function()
                return game:GetObjects("rbxassetid://" .. ids[side])
            end)
            if not success or not objects or #objects == 0 then return false end
            local assetModel = objects[1]
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if not mainMesh then assetModel:Destroy(); return false end
            mainMesh.CanCollide = false
            mainMesh.Massless = true
            mainMesh.CFrame = targetPart.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = targetPart
            weld.Part1 = mainMesh
            weld.Parent = mainMesh
            assetModel.Parent = char
            return true
        end
        if config.korblox == "left" then
            attachKorblox("left")
        elseif config.korblox == "right" then
            attachKorblox("right")
        end
    end

    return true
end

function applyAccessoryPack(packName)
    local char = LP.Character
    if not char then return end

    if packName == "Off" then
        clearAllAccessories(char)
        restoreOriginalOutfit(char)
        restoreOriginalAccessories(char)
        return
    end

    if not __HH.OriginalOutfit.shirt and not __HH.OriginalOutfit.pants then
        saveOriginalOutfit(char)
    end
    if #__HH.OriginalAccessories == 0 then
        saveOriginalAccessories(char)
    end

    clearAllOutfit(char)
    clearAllAccessories(char)
    applyBleedOutfit(packName)
end

-- re-apply pack on respawn (same as VisDuels reapplyAllStates)
LP.CharacterAdded:Connect(function(char)
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then
        task.wait(0.3)
        if LP.Character == char and currentAccessoryPack ~= "Off" then
            pcall(function() applyAccessoryPack(currentAccessoryPack) end)
        end
    end
end)

pcall(function()
    local cg = game:GetService("CoreGui")
    for _, name in ipairs({"Sound Hub", "Bloom Hub", "Horizon Hub", "Sound hub", "HorizonHubMobileButtons", "SoundHubMobileButtons", "VynxMobileButtons", "YousefIntro", "StealBarGui"}) do
        local old = cg:FindFirstChild(name)
        if old then old:Destroy() end
    end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        for _, name in ipairs({"Sound Hub", "Bloom Hub", "Horizon Hub", "Sound hub", "StealBarGui", "YousefIntro", "VynxMobileButtons"}) do
            local old = pg:FindFirstChild(name)
            if old then old:Destroy() end
        end
    end
end)
_G.VYNX_LOADED = true

-- =============== SAFE MODE: CERTZ 5s / GUI PHRASE 2s + 5s ===============
do
    -- Keep all Safe Mode state inside one table so this large script does not
    -- gain many long-lived top-level locals (Luau has a local/register limit).
    local SM = {
        duration          = 5,
        guiLeadDelay      = 2,
        activeDuration    = 5,
        signalCooldown    = 1,
        liveCooldown      = 10,
        roundSignalTime   = 0,
        restoreThread     = nil,
        lastSignalAt      = 0,
        lastGuiSignalAt   = 0,
        p3                = Vector3.new(-476.752, 10.464,   7.107),
        p7                = Vector3.new(-476.752, 10.464, 114.107),
        lastName          = "",
        lastValue         = 0,
        lastLiveAt        = 0,
        wasEnabled        = false,
        generation        = (_G.AceSafeModeGeneration or 0) + 1,
    }
    _G.AceSafeModeGeneration = SM.generation

    function _G.AceSafeModeGetCountdownLabel() return nil end
    function _G.AceSafeModeCountdownNumber(text) return false end
    function _G.AceSafeModeInDuelCountdown() return false end

    function _G.AceSafeModeIsLocked()
        if antiKickEnabled ~= true or SM.roundSignalTime <= 0 then return false end
        return tick() - SM.roundSignalTime < SM.activeDuration
    end

    function _G.AceSafeModeForceStop(reason)
        -- Drop-then-Aim may bypass ordinary manual stops, but it must never
        -- bypass an active Safe Mode window. Otherwise its restore coroutine
        -- can turn AIM BOT back on 1-2 seconds early in later rounds.
        local safeLocked = _G.AceSafeModeIsLocked
            and _G.AceSafeModeIsLocked() == true
        if not safeLocked and (_G.SoundDropThenAimCycleActive == true
        or _G.SoundDropThenAimSafeModeAuthorized == true) then
            return false
        end

        local backendOn = false
        if _G.SoundCursedGetAimbot then
            local ok, enabled = pcall(_G.SoundCursedGetAimbot)
            backendOn = ok and enabled == true
        end
        if not __HH.batV2Enabled and not backendOn then return false end

        antiKickAimPending = false
        __HH.batV2Enabled = false
        if stopAimbotFull then
            pcall(stopAimbotFull)
        elseif _G.SoundCursedSetAimbot then
            pcall(_G.SoundCursedSetAimbot, false)
        end
        if __HH.batV2SetVisual then __HH.batV2SetVisual(false) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(false) end
        return true
    end

    function _G.AceSafeModeRestorePendingAim()
        antiKickAimPending = false
        return false
    end

    function _G.AceSafeModeTryStart(allowDropThenAim)
        if not (_G.AceSafeModeIsLocked and _G.AceSafeModeIsLocked()) then
            return true
        end
        antiKickAimPending = false
        _G.AceSafeModeForceStop("AIM BOT BEFORE START")
        return false
    end

    local function _smOnRoundSignal(source)
        if antiKickEnabled ~= true then return false end

        local now = tick()
        local isGuiPhrase = source == "WON THIS ROUND GUI SAFE MODE"

        -- Certz can detect the result shortly before the visible GUI sentence.
        -- The GUI sentence is authoritative: it is allowed to realign the timer
        -- once, while repeated Text events are ignored. After the sentence, a
        -- late Certz snapshot cannot shorten or restart that same round.
        if isGuiPhrase then
            if SM.lastGuiSignalAt > 0
            and now - SM.lastGuiSignalAt < 1 then return false end
            SM.lastGuiSignalAt = now
        else
            if SM.lastGuiSignalAt > 0
            and now - SM.lastGuiSignalAt < (SM.duration + SM.guiLeadDelay) then return false end
            if SM.lastSignalAt > 0
            and now - SM.lastSignalAt < SM.signalCooldown then return false end
        end

        -- Certz starts a direct five-second pause. The GUI sentence starts with
        -- a two-second lead, followed by the same five-second pause (seven total).
        SM.activeDuration = SM.duration + (isGuiPhrase and SM.guiLeadDelay or 0)
        SM.lastSignalAt = now
        SM.roundSignalTime = now

        -- A completed carry handoff leaves this flag true. Clear that stale
        -- authorization at every new round so it cannot defeat Safe Mode.
        _G.SoundDropThenAimSafeModeAuthorized = false
        _G.AceSafeModeForceStop(source or "ROUND SAFE MODE")
        print(string.format(
            "[SAFE MODE] signal=%s | lead=%.2fs | countdown=%.2fs | total=%.2fs",
            tostring(source or "unknown"),
            isGuiPhrase and SM.guiLeadDelay or 0,
            SM.duration,
            SM.activeDuration
        ))

        if SM.restoreThread then
            pcall(task.cancel, SM.restoreThread)
            SM.restoreThread = nil
        end

        SM.restoreThread = task.delay(SM.activeDuration, function()
            if _G.AceSafeModeGeneration ~= SM.generation then
                SM.restoreThread = nil
                return
            end
            SM.restoreThread = nil
            antiKickAimPending = false
            -- Manual behavior requested: when the Safe Mode timer ends, AIM BOT
            -- stays OFF and can only be enabled again by the user.
            print("[SAFE MODE] timer ended; AIM BOT remains OFF until manually enabled")
        end)
        return true
    end

    local function _smNum(value)
        value = tostring(value):gsub("%s", "")
        local number, suffix = value:match("([%d%.]+)(%a?)")
        number = tonumber(number) or 0
        if suffix == "K" or suffix == "k" then number = number * 1e3
        elseif suffix == "M" or suffix == "m" then number = number * 1e6
        elseif suffix == "B" or suffix == "b" then number = number * 1e9
        elseif suffix == "T" or suffix == "t" then number = number * 1e12 end
        return number
    end

    local function _smMyPlot()
        for _, object in ipairs(workspace:GetDescendants()) do
            if object:IsA("BasePart") and object.Name == "PlotSign" then
                local d3 = (object.Position - SM.p3).Magnitude
                local d7 = (object.Position - SM.p7).Magnitude
                if d3 < 5 or d7 < 5 then
                    for _, label in ipairs(object:GetDescendants()) do
                        if label:IsA("TextLabel") and label.Text ~= "" then
                            if label.Text:find(LP.Name, 1, true)
                            or label.Text:find(LP.DisplayName, 1, true) then
                                return d3 < 5 and 3 or 7
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    -- Certz live-win logic, merged only as a Safe Mode round signal. It does
    -- not send a webhook and deliberately does not check which player won.
    -- The first valid snapshot is accepted immediately, which covers the first
    -- round instead of waiting for a previous "won this round!" GUI sentence.
    task.spawn(function()
        while _G.AceSafeModeGeneration == SM.generation do
            repeat
            task.wait(1)

            if antiKickEnabled ~= true then
                SM.wasEnabled = false
                SM.roundSignalTime = 0
                SM.activeDuration = SM.duration
                SM.lastSignalAt = 0
                SM.lastGuiSignalAt = 0
                if SM.restoreThread then
                    pcall(task.cancel, SM.restoreThread)
                    SM.restoreThread = nil
                end
                break -- continue
            end

            if not SM.wasEnabled then
                SM.wasEnabled = true
                SM.lastName = ""
                SM.lastValue = 0
                SM.lastLiveAt = 0
            end

            local mine = _smMyPlot()
            if not mine then break --[[continue]] end

            local opponentPosition = mine == 3 and SM.p7 or SM.p3
            local debris = workspace:FindFirstChild("Debris")
            if not debris then break --[[continue]] end

            local bestName, bestValue
            for _, object in ipairs(debris:GetChildren()) do
                repeat
                if object.Name ~= "FastOverheadTemplate" then break --[[continue]] end

                local surface = object:FindFirstChildOfClass("SurfaceGui")
                if not surface or not surface.Adornee then break --[[continue]] end
                if (surface.Adornee.Position - opponentPosition).Magnitude > 50 then break --[[continue]] end

                local generation = surface:FindFirstChild("Generation", true)
                if generation and generation:IsA("TextLabel") then
                    local value = _smNum(generation.Text)
                    if not bestValue or value > bestValue then
                        bestValue = value
                        local displayName = surface:FindFirstChild("DisplayName", true)
                        bestName = displayName and displayName.Text or object.Name
                    end
                end
                until true
            end

            if bestName and bestValue then
                local changed = bestName ~= SM.lastName or bestValue ~= SM.lastValue
                if changed then
                    local firstSnapshot = SM.lastName == "" and SM.lastValue == 0
                    SM.lastName = bestName
                    SM.lastValue = bestValue

                    local now = tick()
                    if firstSnapshot or now - SM.lastLiveAt > SM.liveCooldown then
                        SM.lastLiveAt = now
                        _smOnRoundSignal(firstSnapshot
                            and "FIRST ROUND LIVE-WIN SAFE MODE"
                            or "LIVE-WIN CHANGE SAFE MODE")
                    end
                end
            end
            until true
        end
    end)

    local function _smStrip(text)
        return text and text:gsub("<[^>]+>", "") or ""
    end

    local function _smScan(object)
        if _G.AceSafeModeGeneration ~= SM.generation then return end
        if not (object:IsA("TextLabel")
        or object:IsA("TextButton")
        or object:IsA("TextBox")) then return end

        local clean = _smStrip(object.Text):lower()
        -- Ignore punctuation so both "won this round" and
        -- "won this round!" are accepted after RichText tags are removed.
        if clean:find("won this round", 1, true) then
            _smOnRoundSignal("WON THIS ROUND GUI SAFE MODE")
        end
    end

    local playerGui = LP:WaitForChild("PlayerGui")
    for _, object in ipairs(playerGui:GetDescendants()) do
        pcall(_smScan, object)
        if object:IsA("TextLabel")
        or object:IsA("TextButton")
        or object:IsA("TextBox") then
            object:GetPropertyChangedSignal("Text"):Connect(function()
                pcall(_smScan, object)
            end)
        end
    end
    playerGui.DescendantAdded:Connect(function(object)
        pcall(_smScan, object)
        if object:IsA("TextLabel")
        or object:IsA("TextButton")
        or object:IsA("TextBox") then
            object:GetPropertyChangedSignal("Text"):Connect(function()
                pcall(_smScan, object)
            end)
        end
    end)

    if _G.AceSafeModeMonitorConn then
        pcall(function() _G.AceSafeModeMonitorConn:Disconnect() end)
    end
    _G.AceSafeModeMonitorStarted = nil
    _G.AceSafeModeMonitorConn = RunService.Heartbeat:Connect(function()
        if _G.AceSafeModeGeneration ~= SM.generation then return end
        if not _G.AceSafeModeIsLocked() then
            antiKickAimPending = false
            if _G.SoundDropThenAimCycleActive ~= true then
                _G.SoundDropThenAimSafeModeAuthorized = false
            end
            return
        end
        -- Keep enforcing the lock even if Drop-then-Aim finishes during it.
        -- That coroutine may restore AIM BOT once; this heartbeat turns it back
        -- off immediately and the normal Safe Mode timer remains authoritative.
        _G.AceSafeModeForceStop("SAFE MODE HEARTBEAT")
    end)
end
-- =====================================================


-- Irish-style Hit Range, recolored light blue for Horizon.
local HorizonHitRange = {enabled=false, conn=nil, circle=nil, align=nil, attach=nil}
local function stopHorizonHitRange()
    HorizonHitRange.enabled=false
    if HorizonHitRange.conn then HorizonHitRange.conn:Disconnect(); HorizonHitRange.conn=nil end
    if HorizonHitRange.circle then HorizonHitRange.circle:Destroy(); HorizonHitRange.circle=nil end
    if HorizonHitRange.align then HorizonHitRange.align:Destroy(); HorizonHitRange.align=nil end
    if HorizonHitRange.attach then HorizonHitRange.attach:Destroy(); HorizonHitRange.attach=nil end
    local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate=true end
end
local function startHorizonHitRange()
    stopHorizonHitRange()
    local char=LP.Character or LP.CharacterAdded:Wait()
    local hrp=char:WaitForChild("HumanoidRootPart",5)
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    HorizonHitRange.enabled=true
    HorizonHitRange.attach=Instance.new("Attachment",hrp)
    HorizonHitRange.align=Instance.new("AlignOrientation",hrp)
    HorizonHitRange.align.Attachment0=HorizonHitRange.attach
    HorizonHitRange.align.Mode=Enum.OrientationAlignmentMode.OneAttachment
    HorizonHitRange.align.RigidityEnabled=true
    HorizonHitRange.circle=Instance.new("Part")
    HorizonHitRange.circle.Name="HorizonBlueHitRange"
    HorizonHitRange.circle.Shape=Enum.PartType.Cylinder
    HorizonHitRange.circle.Material=Enum.Material.Neon
    HorizonHitRange.circle.Size=Vector3.new(0.05,14.5,14.5)
    HorizonHitRange.circle.Color=Color3.fromRGB(216, 173, 255)
    HorizonHitRange.circle.Transparency=0.35
    HorizonHitRange.circle.CanCollide=false
    HorizonHitRange.circle.CanTouch=false
    HorizonHitRange.circle.CanQuery=false
    HorizonHitRange.circle.Massless=true
    HorizonHitRange.circle.Parent=workspace
    local weld=Instance.new("Weld")
    weld.Part0=hrp; weld.Part1=HorizonHitRange.circle
    weld.C0=CFrame.new(0,-1,0)*CFrame.Angles(0,0,math.rad(90))
    weld.Parent=HorizonHitRange.circle
    HorizonHitRange.conn=RunService.RenderStepped:Connect(function()
        if not HorizonHitRange.enabled then return end
        local c=LP.Character; local root=c and c:FindFirstChild("HumanoidRootPart")
        local h=c and c:FindFirstChildOfClass("Humanoid")
        if not root or not h then return end
        local target, dmin=nil, 7.25
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local tr=p.Character:FindFirstChild("HumanoidRootPart")
                local th=p.Character:FindFirstChildOfClass("Humanoid")
                if tr and th and th.Health>0 then
                    local d=(tr.Position-root.Position).Magnitude
                    if d<=dmin then target=tr; dmin=d end
                end
            end
        end
        if target then
            h.AutoRotate=false
            HorizonHitRange.align.Enabled=true
            HorizonHitRange.align.CFrame=CFrame.lookAt(root.Position,Vector3.new(target.Position.X,root.Position.Y,target.Position.Z))
            local tool=c:FindFirstChild("Bat") or c:FindFirstChild("Medusa")
            if tool then pcall(function() tool:Activate() end) end
        else
            HorizonHitRange.align.Enabled=false
            h.AutoRotate=true
        end
    end)
end
_G.HorizonHitRange={start=startHorizonHitRange,stop=stopHorizonHitRange,enabled=function() return HorizonHitRange.enabled end}

-- Songs section: Irish RIP track.
local HorizonSongSound=nil
local HorizonSongTracks={
    {name="rest in peace to my granny", id="rbxassetid://121252909004354"},
}
local function stopHorizonSong()
    if HorizonSongSound then pcall(function() HorizonSongSound:Stop(); HorizonSongSound:Destroy() end); HorizonSongSound=nil end
end
local function horizonAssetFunction()
    local ok, fn = pcall(function() return getcustomasset end)
    if ok and type(fn) == "function" then return fn end
    local ok2, fn2 = pcall(function() return getsynasset end)
    if ok2 and type(fn2) == "function" then return fn2 end
    if syn and type(syn.getcustomasset) == "function" then return syn.getcustomasset end
    if syn and type(syn.getsynasset) == "function" then return syn.getsynasset end
    return nil
end
local function horizonDownload(url)
    local body=nil
    pcall(function()
        local d=game:HttpGet(url,true)
        if type(d)=="string" and #d>500 then body=d end
    end)
    if not body then
        pcall(function()
            local d=game:HttpGet(url)
            if type(d)=="string" and #d>500 then body=d end
        end)
    end
    if not body then
        local req=syn and syn.request or request or http_request
        if req then
            pcall(function()
                local r=req({Url=url,Method="GET"})
                local d=r and (r.Body or r.body or r.ResponseBody or r.responseBody)
                if type(d)=="string" and #d>500 then body=d end
            end)
        end
    end
    return body
end
local function playHorizonSong(track)
    stopHorizonSong()
    local sound=Instance.new("Sound")
    sound.Volume=1; sound.Looped=true
    if track.id then
        sound.SoundId=track.id
    else
        local assetFunc=horizonAssetFunction()
        if isfile and writefile and assetFunc then
            local bytes=horizonDownload(track.url)
            if bytes then
                pcall(function() writefile(track.file,bytes) end)
                local okAsset,assetId=pcall(function() return assetFunc(track.file) end)
                if okAsset and assetId then sound.SoundId=assetId end
            end
        end
        if sound.SoundId == "" and track.fallback then sound.SoundId=track.fallback end
        if sound.SoundId == "" then sound:Destroy();return end
    end
    sound.Parent=game:GetService("SoundService"); HorizonSongSound=sound
    pcall(function() sound:Play() end)
end


-- ############################################################################
-- ##            AMBITIOUS -> SOUND HUB PORT  (added features)               ##
-- ##  1) X-Ray + Brainrot X-Ray                                             ##
-- ##  2) Avatar Changer                                                     ##
-- ##  3) Custom Tools + Custom Tool Selector + Rainbow Tools + Custom Sounds##
-- ##  4) Rainbow Mobile Joystick                                            ##
-- ##  5) Radius Circle + Radius Circle Colour                               ##
-- ############################################################################
do
    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local TweenService      = game:GetService("TweenService")
    local Lighting          = game:GetService("Lighting")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LP                = Players.LocalPlayer
    local PlayerGui         = LP:WaitForChild("PlayerGui")

    -- Contenitore protetto per i popup (stesso schema dell'Ambitious Hub)
    local HubGui = PlayerGui
    do
        local ok, res = pcall(function()
            if type(gethui) == "function" then return gethui() end
            if type(get_hidden_gui) == "function" then return get_hidden_gui() end
            return game:GetService("CoreGui")
        end)
        if ok and typeof(res) == "Instance" then HubGui = res end
    end

    -- Alias al salvataggio di Sound Hub: l'engine Ambitious lo chiama per nome.
    local function saveAmbitiousConfig()
        pcall(function() if saveConfig then saveConfig() end end)
    end

    -- Helper UI usati dal picker dell'Avatar Changer
    local function corner(o, r)
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = o; return c
    end
    local function stroke(o, col, th, tr)
        local s = Instance.new("UIStroke")
        s.Color = col or Color3.fromRGB(230, 201, 255)
        s.Thickness = th or 1
        s.Transparency = tr or 0.4
        s.Parent = o
        return s
    end
    local function tween(o, props, t)
        return TweenService:Create(o, TweenInfo.new(t or 0.15), props):Play()
    end

    function _G._AmbitiousWaitCharReady(character, timeout)
        character = character or LP.Character
        if not character then return false end
        local deadline = os.clock() + (tonumber(timeout) or 5)
        while os.clock() < deadline do
            if not character.Parent then return false end
            if LP.Character and LP.Character ~= character then return false end
            if character:FindFirstChild("Head")
               and character:FindFirstChild("HumanoidRootPart")
               and character:FindFirstChildOfClass("Humanoid") then
                return true
            end
            task.wait(0.05)
        end
        return false
    end

    -- ============================================================
    -- CUSTOM TOOLS ENGINE (Rainbow / Transparent / Custom)
    -- ============================================================
    do
        local _Players    = game:GetService("Players")
        local _RunService = game:GetService("RunService")
        local _LP         = _Players.LocalPlayer

        -- Item riconosciuti (Bat / Slap Bat / Medusa's Head)
        local CT_ITEMS = {
            { key = "Bat",    match = function(n) n = n:lower() return n:find("bat") ~= nil or n:find("slap") ~= nil end },
            { key = "Medusa", match = function(n) return n:lower():find("medusa") ~= nil end },
        }

        local function ctMatchItem(inst)
            if not (inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("Accessory") or inst:IsA("BasePart")) then
                return nil
            end
            for _, item in ipairs(CT_ITEMS) do
                if item.match(inst.Name) then return item end
            end
            return nil
        end

        local function isReplicaStuff(d)
            if d.Name == "LocalReplica" then return true end
            return d:FindFirstAncestor("LocalReplica") ~= nil
        end

        -- ------------------------------------------------------------
        -- GESTORE TRASPARENZA CONDIVISO
        -- Evita che Transparent e Custom Tools si sovrascrivano a vicenda.
        -- Ogni modulo "prenota" un valore, vince la priorita' piu' alta,
        -- e il valore originale vero viene letto una sola volta (baseline).
        -- ------------------------------------------------------------
        local CT_Trans = {}
        do
            local PRIORITY = { "custom", "rainbow", "transparent" }
            local baseline = setmetatable({}, { __mode = "k" })
            local claims   = setmetatable({}, { __mode = "k" })
            -- Connessioni GetPropertyChangedSignal("Transparency") per parte:
            -- servono a rimettere subito il valore se il gioco lo sovrascrive
            -- (e' il motivo per cui la bat originale ricompariva sopra la custom).
            local guards   = setmetatable({}, { __mode = "k" })

            function CT_Trans.getBaseline(part)
                local b = baseline[part]
                if b ~= nil then return b end
                local ok, val = pcall(function() return part.Transparency end)
                if not ok then return nil end
                baseline[part] = val
                return val
            end

            local function wantedValue(part)
                local c = claims[part]
                if not c then return nil end
                for _, who in ipairs(PRIORITY) do
                    if c[who] ~= nil then return c[who] end
                end
                return nil
            end

            -- Scrive solo se il valore e' davvero diverso: il watchdog dei
            -- Custom Tools richiama claim() sulle stesse parti ogni 0.4s e
            -- senza questo controllo sarebbero centinaia di property write
            -- inutili al secondo.
            local function setIfDifferent(part, v)
                local ok, cur = pcall(function() return part.Transparency end)
                if ok and cur ~= nil and math.abs(cur - v) <= 0.001 then return end
                pcall(function() part.Transparency = v end)
            end

            local function resolve(part)
                local v = wantedValue(part)
                if v ~= nil then
                    setIfDifferent(part, v)
                    return
                end
                local b = baseline[part]
                if b ~= nil then
                    setIfDifferent(part, b)
                end
            end

            -- Riapplica subito il valore prenotato se qualcun altro lo cambia.
            local function armGuard(part)
                if guards[part] then return end
                local ok, conn = pcall(function()
                    return part:GetPropertyChangedSignal("Transparency"):Connect(function()
                        local v = wantedValue(part)
                        if v == nil then return end
                        local ok2, cur = pcall(function() return part.Transparency end)
                        if ok2 and cur ~= nil and math.abs(cur - v) > 0.001 then
                            pcall(function() part.Transparency = v end)
                        end
                    end)
                end)
                if ok and conn then guards[part] = conn end
            end

            local function disarmGuard(part)
                local conn = guards[part]
                if conn then
                    pcall(function() conn:Disconnect() end)
                    guards[part] = nil
                end
            end

            -- Rete di sicurezza: se un evento e' andato perso (o la parte e'
            -- stata sostituita) il sweep periodico rimette tutto a posto.
            function CT_Trans.enforce()
                for part, _ in pairs(claims) do
                    if part.Parent then
                        local v = wantedValue(part)
                        if v ~= nil then
                            local ok, cur = pcall(function() return part.Transparency end)
                            if ok and cur ~= nil and math.abs(cur - v) > 0.001 then
                                pcall(function() part.Transparency = v end)
                            end
                        end
                    end
                end
            end

            function CT_Trans.claim(part, who, value)
                if not part then return end
                if CT_Trans.getBaseline(part) == nil then return end
                local c = claims[part]
                if not c then c = {}; claims[part] = c end
                c[who] = value
                armGuard(part)
                resolve(part)
            end

            function CT_Trans.release(part, who)
                if not part then return end
                local c = claims[part]
                if not c then return end
                c[who] = nil
                if next(c) == nil then
                    claims[part] = nil
                    disarmGuard(part)
                end
                if part.Parent then resolve(part) end
            end
        end

        -- ------------------------------------------------------------
        -- JANITOR: ogni 10s scarta le entry di oggetti non piu' esistenti,
        -- cosi' le tabelle non crescono in sessioni molto lunghe.
        -- ------------------------------------------------------------
        local CT_JANITORS = {}
        task.spawn(function()
            while true do
                task.wait(10)
                for _, fn in ipairs(CT_JANITORS) do pcall(fn) end
            end
        end)

        -- Sweep trasparenze: 4 volte al secondo rimette i valori prenotati.
        -- Gira solo se almeno uno dei tre moduli e' acceso.
        task.spawn(function()
            while true do
                task.wait(0.25)
                if _G.AmbitiousCustomToolsEnabled == true
                or _G.AmbitiousTransparentToolsEnabled == true
                or _G.AmbitiousRainbowToolsEnabled == true then
                    pcall(CT_Trans.enforce)
                end
            end
        end)

        -- ############################################################
        -- ##                     RAINBOW TOOLS                      ##
        -- ############################################################
        do
            local SPEED       = 0.35
            local SPREAD      = 0.035
            local UPDATE_STEP = 1 / 40

            local enabled  = false
            local tracked  = setmetatable({}, { __mode = "k" })
            local watchers = setmetatable({}, { __mode = "k" })
            local unregister

            local function classify(d)
                if d:IsA("MeshPart") then
                    return { obj = d, kind = "part", props = { "Color", "Material", "TextureID" }, clearTexture = "TextureID" }
                elseif d:IsA("BasePart") then
                    return { obj = d, kind = "part", props = { "Color", "Material" } }
                elseif d:IsA("SurfaceAppearance") then
                    return { obj = d, kind = "surface", props = { "Parent" } }
                elseif d:IsA("Decal") or d:IsA("Texture") then
                    return { obj = d, kind = "decal", props = {} }
                elseif d:IsA("SpecialMesh") then
                    return { obj = d, kind = "vector", prop = "VertexColor", props = { "VertexColor", "TextureId" }, clearTexture = "TextureId" }
                elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
                    return { obj = d, kind = "sequence", prop = "Color", props = { "Color" } }
                elseif d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then
                    return { obj = d, kind = "color", prop = "Color", props = { "Color" } }
                elseif d:IsA("Highlight") then
                    return { obj = d, kind = "color", prop = "FillColor", props = { "FillColor" } }
                end
                return nil
            end

            local function snapshot(node)
                node.original = {}
                for _, prop in ipairs(node.props) do
                    local ok, val = pcall(function() return node.obj[prop] end)
                    if ok then node.original[prop] = val end
                end
            end

            local function restoreNode(node)
                if node.kind == "decal" then CT_Trans.release(node.obj, "rainbow") end
                if not node.original then return end
                for prop, val in pairs(node.original) do
                    pcall(function() node.obj[prop] = val end)
                end
            end

            local function applyOnce(node)
                if node.kind == "surface" then
                    pcall(function() node.obj.Parent = nil end)
                elseif node.kind == "decal" then
                    CT_Trans.claim(node.obj, "rainbow", 1)
                elseif node.clearTexture then
                    pcall(function() node.obj[node.clearTexture] = "" end)
                end
            end

            local function addNode(entry, d)
                local node = classify(d)
                if not node then return end
                snapshot(node)
                applyOnce(node)
                if node.kind == "part" then
                    table.insert(entry.parts, node)
                elseif node.kind == "surface" or node.kind == "decal" then
                    table.insert(entry.statics, node)
                else
                    table.insert(entry.effects, node)
                end
            end

            local function register(root)
                if tracked[root] then return end
                local entry = { parts = {}, effects = {}, statics = {}, conns = {} }
                tracked[root] = entry

                for _, d in ipairs(root:GetDescendants()) do addNode(entry, d) end
                if root:IsA("BasePart") then addNode(entry, root) end

                table.insert(entry.conns, root.DescendantAdded:Connect(function(d)
                    addNode(entry, d)
                end))
                table.insert(entry.conns, root.AncestryChanged:Connect(function(_, parent)
                    if not parent then unregister(root, false) end
                end))
            end

            function unregister(root, doRestore)
                local entry = tracked[root]
                if not entry then return end
                for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
                if doRestore then
                    for _, node in ipairs(entry.parts)   do restoreNode(node) end
                    for _, node in ipairs(entry.effects) do restoreNode(node) end
                    for _, node in ipairs(entry.statics) do restoreNode(node) end
                end
                tracked[root] = nil
            end

            local function tryRegister(inst)
                if not enabled then return end
                if ctMatchItem(inst) then register(inst) end
            end

            local function unwatch(container)
                local conns = watchers[container]
                if not conns then return end
                for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
                watchers[container] = nil
            end

            local function watch(container)
                if not container or watchers[container] then return end
                watchers[container] = { container.ChildAdded:Connect(tryRegister) }
                for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
            end

            local function watchAll()
                watch(_LP:FindFirstChildOfClass("Backpack"))
                watch(_LP.Character)
            end

            _LP.ChildAdded:Connect(function(child)
                if enabled and child:IsA("Backpack") then watch(child) end
            end)

            _LP.CharacterAdded:Connect(function(char)
                for root in pairs(tracked) do unregister(root, false) end
                -- pulizia totale: il vecchio Character e il vecchio Backpack sono morti
                for container in pairs(watchers) do unwatch(container) end
                if not enabled then return end
                watch(char)
                task.defer(function()
                    if enabled then watchAll() end
                end)
            end)

            local acc = 0
            _RunService.Heartbeat:Connect(function(dt)
                if not enabled then return end
                if next(tracked) == nil then return end
                acc = acc + dt
                if acc < UPDATE_STEP then return end
                acc = 0

                local baseHue = (tick() * SPEED) % 1

                for _, entry in pairs(tracked) do
                    for i, node in ipairs(entry.parts) do
                        local part = node.obj
                        if part.Parent then
                            pcall(function()
                                part.Color = Color3.fromHSV((baseHue + (i - 1) * SPREAD) % 1, 1, 1)
                            end)
                        end
                    end
                    for i, node in ipairs(entry.effects) do
                        if node.obj.Parent then
                            local col = Color3.fromHSV((baseHue + (i - 1) * SPREAD) % 1, 1, 1)
                            if node.kind == "sequence" then
                                pcall(function() node.obj[node.prop] = ColorSequence.new(col) end)
                            elseif node.kind == "vector" then
                                pcall(function() node.obj[node.prop] = Vector3.new(col.R, col.G, col.B) end)
                            else
                                pcall(function() node.obj[node.prop] = col end)
                            end
                        end
                    end
                end
            end)

            table.insert(CT_JANITORS, function()
                for root in pairs(tracked) do
                    if not root.Parent then unregister(root, false) end
                end
                for container in pairs(watchers) do
                    if container ~= workspace and not container.Parent then unwatch(container) end
                end
            end)

            _G.AmbitiousRainbowTools = {
                setEnabled = function(on)
                    on = on and true or false
                    enabled = on
                    _G.AmbitiousRainbowToolsEnabled = on
                    if on then
                        watchAll()
                    else
                        for root in pairs(tracked) do unregister(root, true) end
                        for container in pairs(watchers) do unwatch(container) end
                    end
                end,
                isEnabled = function() return enabled end,
            }
        end

        -- ############################################################
        -- ##                   TRANSPARENT TOOLS                    ##
        -- ############################################################
        do
            local TRANSPARENCY = 0.5   -- 0 = opaco, 1 = invisibile

            local enabled  = false
            local tracked  = setmetatable({}, { __mode = "k" })
            local watchers = setmetatable({}, { __mode = "k" })
            local unregister

            local function canTouch(d)
                if not d:IsA("BasePart") then return false end
                -- non toccare le parti invisibili di default (baseline, non valore corrente)
                local base = CT_Trans.getBaseline(d)
                if base == nil or base >= 1 then return false end
                return true
            end

            local function addNode(entry, d)
                if not canTouch(d) then return end
                if entry.seen[d] then return end
                entry.seen[d] = true
                local node = { obj = d }
                table.insert(entry.parts, node)
                CT_Trans.claim(d, "transparent", TRANSPARENCY)
            end

            local function register(root)
                if tracked[root] then return end
                local entry = { parts = {}, seen = {}, conns = {} }
                tracked[root] = entry

                for _, d in ipairs(root:GetDescendants()) do addNode(entry, d) end
                if root:IsA("BasePart") then addNode(entry, root) end

                table.insert(entry.conns, root.DescendantAdded:Connect(function(d)
                    addNode(entry, d)
                end))
                table.insert(entry.conns, root.AncestryChanged:Connect(function(_, parent)
                    if not parent then unregister(root, false) end
                end))
            end

            function unregister(root, doRestore)
                local entry = tracked[root]
                if not entry then return end
                for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
                for _, node in ipairs(entry.parts) do
                    CT_Trans.release(node.obj, "transparent")
                end
                tracked[root] = nil
            end

            local function tryRegister(inst)
                if not enabled then return end
                if ctMatchItem(inst) then register(inst) end
            end

            local function unwatch(container)
                local conns = watchers[container]
                if not conns then return end
                for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
                watchers[container] = nil
            end

            local function watch(container)
                if not container or watchers[container] then return end
                watchers[container] = { container.ChildAdded:Connect(tryRegister) }
                for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
            end

            local function watchAll()
                watch(_LP:FindFirstChildOfClass("Backpack"))
                watch(_LP.Character)
            end

            _LP.ChildAdded:Connect(function(child)
                if enabled and child:IsA("Backpack") then watch(child) end
            end)

            _LP.CharacterAdded:Connect(function(char)
                for root in pairs(tracked) do unregister(root, false) end
                -- pulizia totale: il vecchio Character e il vecchio Backpack sono morti
                for container in pairs(watchers) do unwatch(container) end
                if not enabled then return end
                watch(char)
                task.defer(function()
                    if enabled then watchAll() end
                end)
            end)

            table.insert(CT_JANITORS, function()
                for root in pairs(tracked) do
                    if not root.Parent then unregister(root, false) end
                end
                for container in pairs(watchers) do
                    if not container.Parent then unwatch(container) end
                end
            end)

            _G.AmbitiousTransparentTools = {
                setEnabled = function(on)
                    on = on and true or false
                    enabled = on
                    _G.AmbitiousTransparentToolsEnabled = on
                    if on then
                        watchAll()
                    else
                        for root in pairs(tracked) do unregister(root, true) end
                        for container in pairs(watchers) do unwatch(container) end
                    end
                end,
                isEnabled = function() return enabled end,
            }
        end

        -- ############################################################
        -- ##                     CUSTOM TOOLS                       ##
        -- ## Bat -> Diamond Sword  Medusa's Head -> Golden Desert Eagle ##
        -- ############################################################
        do
            -- Catalogo skin. "cat" e' la categoria di oggetto su cui si applica.
            local ASSETS = {
                DiamondSword      = { cat = "Bat",    label = "Diamond Sword",
                                      mesh = "rbxassetid://8827558932", tex = "rbxassetid://8827558969",
                                      scale = Vector3.new(0.2, 0.2, 0.2),
                                      c0 = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), 300),
                                      -- view = distanza della camera nell'anteprima:
                                      -- piu' alta, piu' piccolo appare l'oggetto
                                      view = 4.9 },
                Katana            = { cat = "Bat",    label = "Katana",
                                      mesh = "rbxassetid://13528902482", tex = "rbxassetid://13528902373",
                                      scale = Vector3.new(1.4, 1.4, 1.4),
                                      c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
                                      view = 6.6 },
                Skull             = { cat = "Medusa", label = "Skull",
                                      mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393",
                                      scale = Vector3.new(1, 1, 1),
                                      c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
                                      view = 4.2 },
                GoldenDesertEagle = { cat = "Medusa", label = "Golden Desert Eagle",
                                      mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335",
                                      scale = Vector3.new(0.01, 0.01, 0.01),
                                      c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
                                      view = 3.0 },
            }
            _G.AmbitiousCustomToolAssets = ASSETS

            -- Skin attualmente scelta per ogni categoria.
            -- Le skin salvate vanno lette QUI: questo blocco gira prima di
            -- loadConfig(), quindi affidarsi solo a lui azzererebbe la scelta
            -- ad ogni rejoin.
            if type(_G.AmbitiousCustomToolSkins) ~= "table" then
                local restored = nil
                pcall(function()
                    if isfile and isfile("VynxPC.json") and readfile then
                        local okJson, decoded = pcall(function()
                            return game:GetService("HttpService"):JSONDecode(readfile("VynxPC.json"))
                        end)
                        if okJson and type(decoded) == "table"
                           and type(decoded.customToolSkins) == "table" then
                            restored = decoded.customToolSkins
                        end
                    end
                end)
                _G.AmbitiousCustomToolSkins = { Bat = "DiamondSword", Medusa = "GoldenDesertEagle" }
                if restored then
                    for k, v in pairs(restored) do
                        if type(v) == "string" then _G.AmbitiousCustomToolSkins[k] = v end
                    end
                end
            end

            local function skinFor(cat)
                local key = _G.AmbitiousCustomToolSkins[cat]
                if key and ASSETS[key] and ASSETS[key].cat == cat then return key end
                return (cat == "Bat") and "DiamondSword" or "GoldenDesertEagle"
            end

            local enabled       = false
            local tracked       = setmetatable({}, { __mode = "k" })  -- [tool] = { hidden, conns }
            local watchers      = setmetatable({}, { __mode = "k" })
            local pendingHandle = setmetatable({}, { __mode = "k" })  -- [tool] = conn
            local teardown

            local function buildReplica(handle, mode)
                local existing = handle:FindFirstChild("LocalReplica")
                if existing then existing:Destroy() end

                local data = ASSETS[mode] or ASSETS.DiamondSword

                local m = Instance.new("Model")
                m.Name = "LocalReplica"

                local p = Instance.new("Part")
                p.Name        = "MainPart"
                p.CanCollide  = false
                p.CanQuery    = false
                p.CanTouch    = false
                p.Massless    = true
                p.Size        = Vector3.new(1, 1, 1)
                p.Transparency= 0
                p.Anchored    = false
                p.Parent      = m

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType  = Enum.MeshType.FileMesh
                mesh.MeshId    = data.mesh
                mesh.TextureId = data.tex
                mesh.Parent    = p

                local w = Instance.new("Motor6D")
                w.Part0 = handle
                w.Part1 = p

                -- Scala e impugnatura vengono dal catalogo, non da un if per skin
                mesh.Scale = data.scale
                w.C0 = data.c0

                w.Parent = p
                m.Parent = handle
                return m
            end

            -- Nasconde (NON distrugge) solo la grafica: parti, decal e texture.
            -- Suoni, script e componenti di gioco restano intatti.
            -- Idempotente di proposito: il watchdog lo richiama sulle stesse
            -- parti per ri-prenotare la trasparenza se e' stata persa.
            local function hideNode(entry, d)
                if isReplicaStuff(d) then return end
                if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
                    entry.hidden[d] = true
                    CT_Trans.claim(d, "custom", 1)
                end
            end

            local function setupTool(tool)
                if tracked[tool] then return end

                local handle = tool:FindFirstChild("Handle")
                if not handle then
                    if pendingHandle[tool] then return end
                    local c
                    c = tool.ChildAdded:Connect(function(child)
                        if child.Name == "Handle" then
                            pcall(function() c:Disconnect() end)
                            pendingHandle[tool] = nil
                            if enabled then setupTool(tool) end
                        end
                    end)
                    pendingHandle[tool] = c
                    return
                end

                local entry = { hidden = {}, conns = {} }
                tracked[tool] = entry

                for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end

                local item = ctMatchItem(tool)
                local mode = skinFor((item and item.key == "Bat") and "Bat" or "Medusa")
                entry.cat = (item and item.key == "Bat") and "Bat" or "Medusa"
                buildReplica(handle, mode)

                table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
                    task.defer(function()
                        if tracked[tool] then hideNode(entry, d) end
                    end)
                end))
                table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
                    if not parent then teardown(tool, false) end
                end))
            end

            function teardown(tool, doRestore)
                local entry = tracked[tool]
                if not entry then return end
                for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end

                local handle = tool:FindFirstChild("Handle")
                if handle then
                    local rep = handle:FindFirstChild("LocalReplica")
                    if rep then pcall(function() rep:Destroy() end) end
                end

                for obj in pairs(entry.hidden) do
                    CT_Trans.release(obj, "custom")
                end
                entry.hidden = {}
                tracked[tool] = nil
            end

            local function tryRegister(inst)
                if not enabled then return end
                if inst:IsA("Tool") and ctMatchItem(inst) then
                    setupTool(inst)
                end
            end

            local function unwatch(container)
                local conns = watchers[container]
                if not conns then return end
                for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
                watchers[container] = nil
            end

            local function watch(container)
                if not container or watchers[container] then return end
                watchers[container] = { container.ChildAdded:Connect(tryRegister) }
                for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
            end

            local function watchAll()
                watch(_LP:FindFirstChildOfClass("Backpack"))
                watch(_LP.Character)
            end

            _LP.ChildAdded:Connect(function(child)
                if enabled and child:IsA("Backpack") then watch(child) end
            end)

            _LP.CharacterAdded:Connect(function(char)
                for tool in pairs(tracked) do teardown(tool, false) end
                for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                table.clear(pendingHandle)
                -- pulizia totale: il vecchio Character e il vecchio Backpack sono morti
                for container in pairs(watchers) do unwatch(container) end
                if not enabled then return end
                watch(char)
                task.defer(function()
                    if enabled then watchAll() end
                end)
            end)

            table.insert(CT_JANITORS, function()
                for tool in pairs(tracked) do
                    if not tool.Parent then teardown(tool, false) end
                end
                for tool, c in pairs(pendingHandle) do
                    if not tool.Parent then
                        pcall(function() c:Disconnect() end)
                        pendingHandle[tool] = nil
                    end
                end
                for container in pairs(watchers) do
                    if not container.Parent then unwatch(container) end
                end
            end)

            -- ------------------------------------------------------------
            -- WATCHDOG INTEGRITA'
            -- Copre i due bug segnalati:
            --  1) la replica custom sparisce e resta solo l'arma originale
            --     (tool ri-parentato, Handle sostituito, replica distrutta);
            --  2) l'arma originale ricompare sopra la replica
            --     (trasparenza sovrascritta dal gioco -> ri-nascosta).
            -- ------------------------------------------------------------
            local function rebuildIfNeeded(tool, entry, deep)
                local handle = tool:FindFirstChild("Handle")
                if not handle then return end
                local rep      = handle:FindFirstChild("LocalReplica")
                local mainPart = rep and rep:FindFirstChild("MainPart")
                local motor    = mainPart and mainPart:FindFirstChildOfClass("Motor6D")
                local broken   = (not rep) or (not mainPart) or (not motor) or motor.Part0 ~= handle
                if broken then
                    local item = ctMatchItem(tool)
                    buildReplica(handle, skinFor((item and item.key == "Bat") and "Bat" or "Medusa"))
                end
                -- Ripassata completa solo se la replica era rotta o su richiesta
                if broken or deep then
                    for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end
                end
            end

            -- deep = ripassa anche tutti i descendant dei tool (piu' costoso).
            -- Il giro leggero controlla solo che la replica esista: la
            -- trasparenza e' gia' coperta dai guard + sweep di CT_Trans.
            local function integrityPass(deep)
                if not enabled then return end
                -- ri-aggancia i container (Backpack ricreato, respawn, ecc.)
                watchAll()
                local bp = _LP:FindFirstChildOfClass("Backpack")
                if bp then for _, ch in ipairs(bp:GetChildren()) do tryRegister(ch) end end
                local chr = _LP.Character
                if chr then for _, ch in ipairs(chr:GetChildren()) do tryRegister(ch) end end
                for tool, entry in pairs(tracked) do
                    if not tool.Parent then
                        teardown(tool, false)
                    else
                        rebuildIfNeeded(tool, entry, deep)
                    end
                end
            end

            _G.AmbitiousCustomToolsRecheck = function() pcall(integrityPass, true) end

            -- Cambio skin: aggiorna la scelta e ricostruisce subito le repliche
            -- gia' agganciate, senza dover spegnere e riaccendere il modulo.
            _G.AmbitiousSetCustomToolSkin = function(cat, key)
                if not ASSETS[key] or ASSETS[key].cat ~= cat then return end
                _G.AmbitiousCustomToolSkins[cat] = key
                for tool, entry in pairs(tracked) do
                    if tool.Parent and entry.cat == cat then
                        local handle = tool:FindFirstChild("Handle")
                        if handle then pcall(buildReplica, handle, key) end
                    end
                end
                if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
            end

            task.spawn(function()
                local n = 0
                while true do
                    task.wait(0.4)
                    if enabled then
                        n = n + 1
                        pcall(integrityPass, (n % 5) == 0)   -- deep ogni 2s
                    end
                end
            end)

            -- Riapplica subito quando equipaggi/sganci un'arma, senza aspettare
            -- il giro del watchdog.
            _LP.CharacterAdded:Connect(function()
                task.delay(0.6, function() if enabled then pcall(integrityPass, true) end end)
            end)

            _G.AmbitiousCustomTools = {
                setEnabled = function(on)
                    on = on and true or false
                    enabled = on
                    _G.AmbitiousCustomToolsEnabled = on
                    if on then
                        watchAll()
                        pcall(integrityPass, true)
                    else
                        for tool in pairs(tracked) do teardown(tool, true) end
                        for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                        table.clear(pendingHandle)
                        for container in pairs(watchers) do unwatch(container) end
                    end
                end,
                isEnabled = function() return enabled end,
            }
        end

        -- ############################################################
        -- ##                    CUSTOM SOUNDS                       ##
        -- ##   Bat -> katana slash      Medusa -> gunshot           ##
        -- ##   Indipendente da Custom Tools: funziona anche da solo ##
        -- ############################################################
        do
            local SOUNDS = {
                Bat    = { id = "rbxassetid://5713085119", skip = 0.2 },
                Medusa = { id = "rbxassetid://3102797479", doublePlay = true, delay = 0.5 },
            }

            -- Un Sound puo' essere agganciato UNA volta sola: senza questo le
            -- connessioni si accumulavano a ogni re-equip (memory leak).
            local hooked = setmetatable({}, { __mode = "k" })

            local enabled       = false
            local tracked       = setmetatable({}, { __mode = "k" })  -- [tool] = { sound, data, conns, muted }
            local watchers      = setmetatable({}, { __mode = "k" })
            local pendingHandle = setmetatable({}, { __mode = "k" })
            local teardown

            local function playCustom(entry)
                local cs = entry.sound
                if not cs or not cs.Parent then return end
                local d = entry.data

                -- cancella un eventuale secondo colpo ancora in coda
                if entry.timer then
                    pcall(task.cancel, entry.timer)
                    entry.timer = nil
                end

                pcall(function()
                    cs:Stop()
                    cs.TimePosition = d.skip or 0
                    cs.Volume = 1
                    cs:Play()
                end)

                if d.doublePlay and d.delay then
                    entry.timer = task.delay(d.delay, function()
                        entry.timer = nil
                        if not enabled then return end
                        if cs and cs.Parent then
                            pcall(function()
                                cs:Stop()
                                cs.TimePosition = d.skip or 0
                                cs.Volume = 1
                                cs:Play()
                            end)
                        end
                    end)
                end
            end

            -- Silenzia il suono originale e fa partire quello custom
            local function hookSound(entry, snd)
                if not snd:IsA("Sound") then return end
                if snd.Name == "CustomSound" then return end
                if hooked[snd] then return end          -- gia' agganciato: niente doppioni
                if entry.muted[snd] ~= nil then return end

                entry.muted[snd] = snd.Volume
                hooked[snd] = true

                local function trigger()
                    if not enabled then return end
                    if snd.Playing or snd.TimePosition > 0 then
                        pcall(function()
                            snd.Volume = 0
                            snd:Stop()
                        end)
                        playCustom(entry)
                    end
                end

                local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
                local c2 = snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
                table.insert(entry.conns, c1)
                table.insert(entry.conns, c2)

                -- il Sound viene distrutto: si liberano subito le connessioni
                local c3
                c3 = snd.AncestryChanged:Connect(function(_, parent)
                    if parent then return end
                    pcall(function() c1:Disconnect() end)
                    pcall(function() c2:Disconnect() end)
                    pcall(function() c3:Disconnect() end)
                    hooked[snd] = nil
                    entry.muted[snd] = nil
                    if entry.timer then
                        pcall(task.cancel, entry.timer)
                        entry.timer = nil
                    end
                end)
                table.insert(entry.conns, c3)

                if snd.Playing then trigger() end
            end

            local function setupTool(tool)
                if tracked[tool] then return end

                local item = ctMatchItem(tool)
                if not item then return end
                local data = SOUNDS[item.key]
                if not data then return end

                local handle = tool:FindFirstChild("Handle")
                if not handle then
                    if pendingHandle[tool] then return end
                    local c
                    c = tool.ChildAdded:Connect(function(child)
                        if child.Name == "Handle" then
                            pcall(function() c:Disconnect() end)
                            pendingHandle[tool] = nil
                            if enabled then setupTool(tool) end
                        end
                    end)
                    pendingHandle[tool] = c
                    return
                end

                local old = handle:FindFirstChild("CustomSound")
                if old then pcall(function() old:Destroy() end) end

                local cs = Instance.new("Sound")
                cs.Name        = "CustomSound"
                cs.SoundId     = data.id
                cs.Volume      = 1
                cs.Looped      = false
                cs.RollOffMode = Enum.RollOffMode.Inverse
                cs.MaxDistance = 1000
                cs.MinDistance = 1000
                cs.Parent      = handle

                local entry = { sound = cs, data = data, conns = {}, muted = {} }
                tracked[tool] = entry

                for _, d in ipairs(tool:GetDescendants()) do hookSound(entry, d) end

                table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
                    if tracked[tool] then hookSound(entry, d) end
                end))
                table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
                    if not parent then teardown(tool) end
                end))
            end

            function teardown(tool)
                local entry = tracked[tool]
                if not entry then return end
                if entry.timer then
                    pcall(task.cancel, entry.timer)
                    entry.timer = nil
                end
                for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
                if entry.sound then pcall(function() entry.sound:Destroy() end) end
                for snd, vol in pairs(entry.muted) do
                    hooked[snd] = nil
                    if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
                end
                tracked[tool] = nil
            end

            local function tryRegister(inst)
                if not enabled then return end
                if inst:IsA("Tool") and ctMatchItem(inst) then setupTool(inst) end
            end

            local function unwatch(container)
                local conns = watchers[container]
                if not conns then return end
                for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
                watchers[container] = nil
            end

            local function watch(container)
                if not container or watchers[container] then return end
                watchers[container] = { container.ChildAdded:Connect(tryRegister) }
                for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
            end

            local function watchAll()
                watch(_LP:FindFirstChildOfClass("Backpack"))
                watch(_LP.Character)
            end

            _LP.ChildAdded:Connect(function(child)
                if enabled and child:IsA("Backpack") then watch(child) end
            end)

            _LP.CharacterAdded:Connect(function(char)
                for tool in pairs(tracked) do teardown(tool) end
                for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                table.clear(pendingHandle)
                for container in pairs(watchers) do unwatch(container) end
                if not enabled then return end
                watch(char)
                task.defer(function()
                    if enabled then watchAll() end
                end)
            end)

            table.insert(CT_JANITORS, function()
                for tool in pairs(tracked) do
                    if not tool.Parent then teardown(tool) end
                end
                for tool, c in pairs(pendingHandle) do
                    if not tool.Parent then
                        pcall(function() c:Disconnect() end)
                        pendingHandle[tool] = nil
                    end
                end
                for container in pairs(watchers) do
                    if not container.Parent then unwatch(container) end
                end
            end)

            _G.AmbitiousCustomSounds = {
                setEnabled = function(on)
                    on = on and true or false
                    enabled = on
                    _G.AmbitiousCustomSoundsEnabled = on
                    if on then
                        watchAll()
                    else
                        for tool in pairs(tracked) do teardown(tool) end
                        for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                        table.clear(pendingHandle)
                        for container in pairs(watchers) do unwatch(container) end
                    end
                end,
                isEnabled = function() return enabled end,
            }
        end

        _G.AmbitiousRainbowToolsEnabled     = false
        _G.AmbitiousTransparentToolsEnabled = false
        _G.AmbitiousCustomToolsEnabled      = false
        _G.AmbitiousCustomSoundsEnabled     = false
    end


    _G._AmbitiousXRayFolders = {
        "Base", "PlotSign", "FriendPanel", "Cash", "Laser",
        "Decorations", "Skin", "Unlock", "Purchases"
    }
    _G._AmbitiousXRayOrigTrans = {}  -- tabella forte: il GC non raccoglie le chiavi durante il restore
    _G._AmbitiousXRayConns = {}
    _G._AmbitiousXRayLoopId = 0

    do
    local function setXRayTargetTransparency(instance, alphaPercent, loopId)
        if not instance then return end
        if loopId and loopId ~= _G._AmbitiousXRayLoopId then return end
        local function apply(obj)
            if obj:IsA("BasePart") then
                if _G._AmbitiousXRayOrigTrans[obj] == nil then
                    _G._AmbitiousXRayOrigTrans[obj] = obj.Transparency
                end
                local orig = _G._AmbitiousXRayOrigTrans[obj]
                if orig < 1 then
                    local target = orig + (1 - orig) * alphaPercent
                    if math.abs(obj.Transparency - target) > 0.01 then
                        obj.Transparency = target
                    end
                end
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if _G._AmbitiousXRayOrigTrans[obj] == nil then
                    _G._AmbitiousXRayOrigTrans[obj] = { text = obj.TextTransparency, bg = obj.BackgroundTransparency }
                end
                local orig = _G._AmbitiousXRayOrigTrans[obj]
                if orig.text < 1 then
                    local target = orig.text + (1 - orig.text) * alphaPercent
                    if math.abs(obj.TextTransparency - target) > 0.01 then obj.TextTransparency = target end
                end
                if orig.bg < 1 then
                    local target = orig.bg + (1 - orig.bg) * alphaPercent
                    if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
                end
            elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                if _G._AmbitiousXRayOrigTrans[obj] == nil then
                    _G._AmbitiousXRayOrigTrans[obj] = obj.BackgroundTransparency
                end
                local orig = _G._AmbitiousXRayOrigTrans[obj]
                if orig < 1 then
                    local target = orig + (1 - orig) * alphaPercent
                    if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
                end
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                if _G._AmbitiousXRayOrigTrans[obj] == nil then
                    _G._AmbitiousXRayOrigTrans[obj] = { img = obj.ImageTransparency, bg = obj.BackgroundTransparency }
                end
                local orig = _G._AmbitiousXRayOrigTrans[obj]
                if orig.img < 1 then
                    local target = orig.img + (1 - orig.img) * alphaPercent
                    if math.abs(obj.ImageTransparency - target) > 0.01 then obj.ImageTransparency = target end
                end
                if orig.bg < 1 then
                    local target = orig.bg + (1 - orig.bg) * alphaPercent
                    if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
                end
            end
        end
        apply(instance)
        local descendants = instance:GetDescendants()
        for i, child in ipairs(descendants) do
            apply(child)
            if i % 300 == 0 then
                task.wait()
                if loopId and loopId ~= _G._AmbitiousXRayLoopId then return end
            end
        end
    end

    local function trackXRaySubtree(root, alphaPercent, loopId)
        if not root then return end
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        setXRayTargetTransparency(root, alphaPercent, loopId)
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        table.insert(_G._AmbitiousXRayConns, root.DescendantAdded:Connect(function(obj)
            if loopId ~= _G._AmbitiousXRayLoopId then return end
            setXRayTargetTransparency(obj, alphaPercent, loopId)
        end))
    end

    local function processPlotXRay(plot, alphaPercent, loopId)
        if not plot then return end
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        for _, fname in ipairs(_G._AmbitiousXRayFolders) do
            if loopId ~= _G._AmbitiousXRayLoopId then return end
            trackXRaySubtree(plot:FindFirstChild(fname), alphaPercent, loopId)
        end
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        table.insert(_G._AmbitiousXRayConns, plot.ChildAdded:Connect(function(child)
            if loopId ~= _G._AmbitiousXRayLoopId then return end
            for _, fname in ipairs(_G._AmbitiousXRayFolders) do
                if child.Name == fname then
                    trackXRaySubtree(child, alphaPercent, loopId)
                    break
                end
            end
        end))
        local animalPodiums = plot:FindFirstChild("AnimalPodiums")
        if animalPodiums then
            local function processPodium(podium)
                for _, child in ipairs(podium:GetChildren()) do
                    if child.Name == "Claim" then
                        trackXRaySubtree(child, alphaPercent, loopId)
                    elseif child.Name == "Base" then
                        trackXRaySubtree(child:FindFirstChild("Decorations"), alphaPercent, loopId)
                    elseif child:IsA("Model") and child.Name ~= "Decorations" then
                        trackXRaySubtree(child, alphaPercent, loopId)
                    end
                end
            end
            for _, podium in ipairs(animalPodiums:GetChildren()) do
                processPodium(podium)
            end
            table.insert(_G._AmbitiousXRayConns, animalPodiums.ChildAdded:Connect(function(podium)
                if loopId ~= _G._AmbitiousXRayLoopId then return end
                task.wait(0.1)
                if loopId ~= _G._AmbitiousXRayLoopId then return end
                processPodium(podium)
            end))
        end
    end

    local function applyTransparencyToAllPlotsXRay(alphaPercent, loopId)
        local plotsFolder = workspace:FindFirstChild("Plots")
        if not plotsFolder then return end
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if loopId ~= _G._AmbitiousXRayLoopId then return end
            processPlotXRay(plot, alphaPercent, loopId)
            task.wait()
        end
        table.insert(_G._AmbitiousXRayConns, plotsFolder.ChildAdded:Connect(function(plot)
            if loopId ~= _G._AmbitiousXRayLoopId then return end
            task.wait(0.2)
            processPlotXRay(plot, alphaPercent, loopId)
        end))
    end

    function setXRay(enabled)
        for _, conn in ipairs(_G._AmbitiousXRayConns) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
        _G._AmbitiousXRayConns = {}
        _G._AmbitiousXRayLoopId = _G._AmbitiousXRayLoopId + 1
        local currentLoopId = _G._AmbitiousXRayLoopId
        if enabled then
            local alphaPercent = 0.5
            task.spawn(function()
                while currentLoopId == _G._AmbitiousXRayLoopId and not workspace:FindFirstChild("Plots") do
                    task.wait(0.5)
                end
                if currentLoopId ~= _G._AmbitiousXRayLoopId then return end
                pcall(applyTransparencyToAllPlotsXRay, alphaPercent, currentLoopId)
            end)
        else
            local snapshot = _G._AmbitiousXRayOrigTrans
            _G._AmbitiousXRayOrigTrans = {}  -- tabella forte: il GC non raccoglie le chiavi durante il restore
            for obj, orig in pairs(snapshot) do
                pcall(function()
                    if obj:IsA("BasePart") then
                        obj.Transparency = orig
                    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        obj.TextTransparency = orig.text
                        obj.BackgroundTransparency = orig.bg
                    elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                        obj.BackgroundTransparency = orig
                    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                        obj.ImageTransparency = orig.img
                        obj.BackgroundTransparency = orig.bg
                    end
                end)
            end
        end
    end
    end -- X-RAY do block

    -- >>> BRAINROT X-RAY BEGIN
    -- Rende trasparenti i brainrot (i Model il cui nome sta in Datas.Animals).
    --
    -- NOTA SUI LOCAL: il main chunk e' a ridosso del limite di 200 local, quindi
    -- qui NON se ne dichiara nemmeno uno: stato e funzioni stanno tutti dentro
    -- la tabella _G._AmbitiousBrainrotXRay. I local dentro le funzioni non
    -- contano, vivono nello scope della funzione.
    --
    -- Logica a eventi, come il No Animations dell'Anti Lag:
    --  * UNA sola scansione del Workspace, all'accensione, spezzata in blocchi
    --    per non far scattare il frame. Da li' in poi non si riscansiona piu'.
    --  * Il DescendantAdded lavora solo sull'istanza arrivata: se e' un Model
    --    animale applica a quello, se e' una parte risale al massimo 3 livelli.
    --  * Spegnendolo, ogni istanza toccata torna alla trasparenza ORIGINALE,
    --    con lo stesso snapshot che usa l'X-Ray normale.
    _G._AmbitiousBrainrotXRay = {
      enabled = false,
      trans   = 0.5,
      names   = nil,
      -- [istanza] = trasparenza originale.
      -- TABELLA FORTE, NON weak: con __mode="k" il GC puo' buttare via la voce
      -- anche se la parte e' ancora viva nel mondo (Lua non ha piu' un
      -- riferimento suo, ma l'istanza esiste lo stesso nel DataModel). Era per
      -- quello che alcuni brainrot restavano trasparenti allo spegnimento.
      -- Non cresce all'infinito: viene svuotata ad ogni spegnimento.
      saved   = {},
      conns   = {},
      scanId  = 0,
    }

    _G._AmbitiousBrainrotXRay.loadNames = function()
      local BRX = _G._AmbitiousBrainrotXRay
      if BRX.names then return BRX.names end
      local t = {}
      pcall(function()
        local datas = ReplicatedStorage:FindFirstChild("Datas")
        local m = datas and datas:FindFirstChild("Animals")
        if m and m:IsA("ModuleScript") then
          for k in pairs(require(m)) do t[k] = true end
        end
      end)
      BRX.names = t
      return t
    end

    _G._AmbitiousBrainrotXRay.isHitbox = function(o)
      local n = string.lower(o.Name)
      return (string.find(n, "hit") or string.find(n, "target") or string.find(n, "box")
           or string.find(n, "root") or string.find(n, "collect") or string.find(n, "prompt")) ~= nil
    end

    -- Applica a UNA istanza, salvando il valore originale la prima volta.
    _G._AmbitiousBrainrotXRay.applyOne = function(o)
      local BRX = _G._AmbitiousBrainrotXRay
      if not (o:IsA("BasePart") or o:IsA("Decal") or o:IsA("Texture")) then return end
      local orig = BRX.saved[o]
      if orig == nil then
        orig = o.Transparency
        -- Le hitbox gia' semi-trasparenti vanno trattate come invisibili,
        -- altrimenti spegnendo tornerebbero visibili a meta'.
        if orig > 0.5 and orig < 0.99 and o:IsA("BasePart") and BRX.isHitbox(o) then
          orig = 1
        end
        BRX.saved[o] = orig
      end
      -- Si tocca solo cio' che era davvero visibile.
      if orig < 0.5 and o.Transparency ~= BRX.trans then
        o.Transparency = BRX.trans
      end
    end

    _G._AmbitiousBrainrotXRay.applyModel = function(m)
      local BRX = _G._AmbitiousBrainrotXRay
      for _, o in ipairs(m:GetDescendants()) do
        BRX.applyOne(o)
      end
    end

    _G._AmbitiousBrainrotXRay.isAnimal = function(m)
      local BRX = _G._AmbitiousBrainrotXRay
      return m:IsA("Model") and BRX.names and BRX.names[m.Name] == true
    end

    -- Gate O(1): si risale di pochi livelli, non si cerca nulla.
    _G._AmbitiousBrainrotXRay.animalAncestor = function(inst)
      local BRX = _G._AmbitiousBrainrotXRay
      local p = inst.Parent
      -- 5 livelli invece di 3: mesh e accessori possono stare piu' in fondo,
      -- e se non li si riconosce restano opachi (e poi non si ripristinano).
      for _ = 1, 5 do
        if not p or p == workspace then return nil end
        if p:IsA("Model") and BRX.names and BRX.names[p.Name] then return p end
        p = p.Parent
      end
      return nil
    end

    _G._AmbitiousBrainrotXRay.restoreAll = function()
      local BRX = _G._AmbitiousBrainrotXRay
      -- Si stacca lo snapshot e si riparte da zero, cosi' la tabella non
      -- accumula istanze morte da una sessione all'altra.
      local snapshot = BRX.saved
      BRX.saved = {}
      for o, orig in pairs(snapshot) do
        pcall(function()
          if o and o.Parent then o.Transparency = orig end
        end)
      end
    end

    function _G.AmbitiousSetBrainrotXRay(on)
      local BRX = _G._AmbitiousBrainrotXRay
      on = on and true or false
      BRX.enabled = on
      _G.AmbitiousBrainrotXRayEnabled = on

      for _, c in ipairs(BRX.conns) do
        pcall(function() c:Disconnect() end)
      end
      BRX.conns = {}
      BRX.scanId = BRX.scanId + 1

      if not on then
        BRX.restoreAll()
        return
      end

      BRX.loadNames()

      -- Scansione iniziale, a blocchi di 500 istanze
      local myScan = BRX.scanId
      task.spawn(function()
        local n = 0
        for _, d in ipairs(workspace:GetDescendants()) do
          if BRX.scanId ~= myScan then return end
          if BRX.isAnimal(d) then BRX.applyModel(d) end
          n = n + 1
          if n % 500 == 0 then task.wait() end
        end
      end)

      -- Da qui in poi: solo l'istanza che arriva, niente rescan.
      table.insert(BRX.conns, workspace.DescendantAdded:Connect(function(inst)
        if not BRX.enabled then return end
        if inst:IsA("Model") then
          if BRX.names and BRX.names[inst.Name] then
            -- il model arriva vuoto: si aspetta un frame che si popoli
            task.defer(function()
              if BRX.enabled and inst.Parent then BRX.applyModel(inst) end
            end)
          end
          return
        end
        if inst:IsA("BasePart") or inst:IsA("Decal") or inst:IsA("Texture") then
          if BRX.animalAncestor(inst) then BRX.applyOne(inst) end
        end
      end))
    end
    -- <<< BRAINROT X-RAY END

    -- >>> RAINBOW MOBILE JOYSTICK BEGIN
    -- ============================================================
    -- RAINBOW MOBILE JOYSTICK
    -- Colora in arcobaleno il thumbstick e il tasto salto dei controlli touch.
    -- Il modulo sta FUORI da __AmbitiousDuelsSetupVisualsUI: quella funzione
    -- viene richiamata dal Reset All Settings, e definirlo li' dentro
    -- significherebbe registrare un secondo set di connessioni ad ogni reset.
    -- ============================================================
    _G.AmbitiousRainbowJoystickEnabled = _G.AmbitiousRainbowJoystickEnabled == true
    ;(function()
      local conns = {}
      local renderConn = nil
      -- [oggetto] = {prop = "ImageColor3" | "BackgroundColor3", orig = Color3}
      -- Il colore originale si tiene da parte alla prima volta che si incontra
      -- l'oggetto: spegnendo il toggle si rimette quello, invece di lasciare
      -- i controlli dell'ultima tinta dell'arcobaleno.
      local targets = {}

      local startRJ, stopRJ

      local function restoreAll()
        for obj, info in pairs(targets) do
          if obj and obj.Parent then
            pcall(function() obj[info.prop] = info.orig end)
          end
        end
        targets = {}
      end

      local function addTarget(obj)
        if targets[obj] then return end
        if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
          targets[obj] = {prop = "ImageColor3", orig = obj.ImageColor3}
        elseif obj:IsA("Frame") then
          targets[obj] = {prop = "BackgroundColor3", orig = obj.BackgroundColor3}
        end
      end

      local function rescan()
        local touchGui = PlayerGui:FindFirstChild("TouchGui")
        if not touchGui then return end

        for _, v in ipairs(touchGui:GetDescendants()) do
          if v:IsA("ImageLabel") or v:IsA("Frame") then
            local n = v.Name:lower()
            if n:find("thumbstick") or n:find("stick") then addTarget(v) end
          end
        end

        -- Tasto salto: il primo ImageButton dentro TouchControlFrame, con i
        -- suoi figli. Come nell'originale ci si ferma al primo.
        local tcf = touchGui:FindFirstChild("TouchControlFrame")
        if tcf then
          for _, v in ipairs(tcf:GetDescendants()) do
            if v:IsA("ImageButton") then
              addTarget(v)
              for _, d in ipairs(v:GetDescendants()) do
                if d:IsA("ImageLabel") then addTarget(d) end
              end
              break
            end
          end
        end
      end

      stopRJ = function()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        if renderConn then
          pcall(function() renderConn:Disconnect() end)
          renderConn = nil
        end
        restoreAll()
      end

      startRJ = function()
        stopRJ()
        rescan()

        -- I controlli touch possono comparire dopo (Roblox li crea al primo
        -- tocco) o essere ricostruiti: si riaggancia invece di dare per
        -- scontato che TouchGui esista gia'. Niente WaitForChild con timeout,
        -- che bloccherebbe il toggle per dieci secondi su PC.
        table.insert(conns, PlayerGui.ChildAdded:Connect(function(ch)
          if ch.Name == "TouchGui" and _G.AmbitiousRainbowJoystickEnabled then
            task.wait(0.2)
            if _G.AmbitiousRainbowJoystickEnabled then startRJ() end
          end
        end))

        local touchGui = PlayerGui:FindFirstChild("TouchGui")
        if touchGui then
          table.insert(conns, touchGui.DescendantAdded:Connect(function()
            task.wait(0.2)
            if _G.AmbitiousRainbowJoystickEnabled then rescan() end
          end))
        end

        renderConn = RunService.RenderStepped:Connect(function()
          local t = tick() * 2
          local color = Color3.new(
            math.sin(t) * 0.5 + 0.5,
            math.sin(t + 2) * 0.5 + 0.5,
            math.sin(t + 4) * 0.5 + 0.5
          )
          for obj, info in pairs(targets) do
            if obj and obj.Parent then
              obj[info.prop] = color
            else
              -- oggetto distrutto: si toglie dalla lista invece di ritentare
              -- di colorarlo sessanta volte al secondo
              targets[obj] = nil
            end
          end
        end)
      end

      function _G.AmbitiousSetRainbowJoystick(on)
        on = on and true or false
        _G.AmbitiousRainbowJoystickEnabled = on
        if on then startRJ() else stopRJ() end
      end
    end)()

    -- Applica lo stato letto dal config (loadAmbitiousConfig gira prima di qui).
    if _G.AmbitiousRainbowJoystickEnabled then
      pcall(_G.AmbitiousSetRainbowJoystick, true)
    end
    -- <<< RAINBOW MOBILE JOYSTICK END

    -- ========================== AVATAR CHANGER ==========================
    do
        -- ---- Stato persistente ----
        _G._AmbitiousAvatarChanger = {
          Hair     = { enabled=false, savedId=nil, savedName="" },
          Hats     = { enabled=false, savedId=nil, savedName="" },
          Face     = { enabled=false, savedId=nil, savedName="" },
          Neck     = { enabled=false, savedId=nil, savedName="" },
          Shoulder = { enabled=false, savedId=nil, savedName="" },
          Front    = { enabled=false, savedId=nil, savedName="" },
          Back     = { enabled=false, savedId=nil, savedName="" },
          Waist    = { enabled=false, savedId=nil, savedName="" },
          Shirts   = { enabled=false, savedId=nil, savedName="" },
          Pants    = { enabled=false, savedId=nil, savedName="" },
          ["T-Shirts"] = { enabled=false, savedId=nil, savedName="" },
          Jackets  = { enabled=false, savedId=nil, savedName="" },
          Sweaters = { enabled=false, savedId=nil, savedName="" },
          Bottoms  = { enabled=false, savedId=nil, savedName="" },
        }
        -- Applica i dati caricati dal config se presenti.
        -- Questo blocco gira PRIMA di loadConfig(), quindi la funzione resta
        -- esposta: loadConfig la richiama appena ha letto il file.
        _G._AmbitiousAvatarChangerApplyPending = function()
          if type(_G._AmbitiousAvatarChangerPending) ~= "table" then return end
          for k,v in pairs(_G._AmbitiousAvatarChangerPending) do
            if _G._AmbitiousAvatarChanger[k] and type(v) == "table" then
              _G._AmbitiousAvatarChanger[k].enabled   = v.enabled == true
              _G._AmbitiousAvatarChanger[k].savedId   = tonumber(v.savedId)
              _G._AmbitiousAvatarChanger[k].savedName = tostring(v.savedName or "")
            end
          end
          _G._AmbitiousAvatarChangerPending = nil
        end
        -- Primo tentativo: serve se il config era gia' stato letto altrove.
        _G._AmbitiousAvatarChangerApplyPending()
        -- Fallback diretto dal file, per lo stesso motivo delle skin.
        if type(_G._AmbitiousAvatarChangerPending) ~= "table" then
          pcall(function()
            if isfile and isfile("VynxPC.json") and readfile then
              local okJson, decoded = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile("VynxPC.json"))
              end)
              if okJson and type(decoded) == "table" and type(decoded.avatarChanger) == "table" then
                _G._AmbitiousAvatarChangerPending = decoded.avatarChanger
                _G._AmbitiousAvatarChangerApplyPending()
              end
            end
          end)
        end

        local AC_CATEGORIES = {
          { Name="Hair",     AssetTypes={Enum.AvatarAssetType.HairAccessory} },
          { Name="Hats",     AssetTypes={Enum.AvatarAssetType.Hat} },
          { Name="Face",     AssetTypes={Enum.AvatarAssetType.FaceAccessory} },
          { Name="Neck",     AssetTypes={Enum.AvatarAssetType.NeckAccessory} },
          { Name="Shoulder", AssetTypes={Enum.AvatarAssetType.ShoulderAccessory} },
          { Name="Front",    AssetTypes={Enum.AvatarAssetType.FrontAccessory} },
          { Name="Back",     AssetTypes={Enum.AvatarAssetType.BackAccessory} },
          { Name="Waist",    AssetTypes={Enum.AvatarAssetType.WaistAccessory} },
          { Name="Shirts",   AssetTypes={Enum.AvatarAssetType.Shirt} },
          { Name="Pants",    AssetTypes={Enum.AvatarAssetType.Pants} },
          { Name="T-Shirts", AssetTypes={Enum.AvatarAssetType.TShirt} },
          { Name="Jackets",  AssetTypes={Enum.AvatarAssetType.JacketAccessory} },
          { Name="Sweaters", AssetTypes={Enum.AvatarAssetType.SweaterAccessory} },
          { Name="Bottoms",  AssetTypes={Enum.AvatarAssetType.ShortsAccessory} },
        }

        -- ---- Equip ----
        -- Generazione: cresce ad ogni respawn. Serve ad abortire gli equip
        -- rimasti in sospeso su un character ormai vecchio.
        local _acGen = 0
        -- Cache dei template scaricati: il watcher puo' riapplicare un item
        -- molte volte, senza cache ogni volta sarebbe una richiesta di rete.
        local _acAssetCache = {}

        -- Usa l'helper condiviso definito in cima allo script
        local _acWaitCharReady = _G._AmbitiousWaitCharReady

        -- Ritorna true solo se l'item e' stato davvero applicato.
        local function _acEquipItem(itemId, itemType, itemName, gen)
          if not itemId then return false end
          if gen == nil then gen = _acGen end
          local ok, applied = pcall(function()
            local objects
            local cached = _acAssetCache[itemId]
            if cached then
              objects = { cached:Clone() }
            else
              objects = game:GetObjects("rbxassetid://"..tostring(itemId))
              if objects and objects[1] then
                _acAssetCache[itemId] = objects[1]:Clone()
              end
            end
            -- GetObjects fa una richiesta di rete: nel frattempo il character
            -- puo' essere cambiato, quindi si rilegge adesso e non prima.
            if gen ~= _acGen then return false end
            local character = LP.Character
            if not character or not character.Parent then return false end
            if not _acWaitCharReady(character, 5) then return false end
            if gen ~= _acGen then return false end
            if not objects or #objects==0 then return false end
              local item = objects[1]
              if item:IsA("Folder") or item:IsA("Model") then
                local core = item:FindFirstChildOfClass("Accessory")
                  or item:FindFirstChildOfClass("Shirt")
                  or item:FindFirstChildOfClass("Pants")
                  or item:FindFirstChildOfClass("ShirtGraphic")
                if core then item=core end
              end
              if item:IsA("Shirt") then
                for _,c in pairs(character:GetChildren()) do if c:IsA("Shirt") then c:Destroy() end end
                item.Name="ACShirt"; item.Parent=character; return true
              elseif item:IsA("Pants") then
                for _,c in pairs(character:GetChildren()) do if c:IsA("Pants") then c:Destroy() end end
                item.Name="ACPants"; item.Parent=character; return true
              elseif item:IsA("ShirtGraphic") then
                for _,c in pairs(character:GetChildren()) do if c:IsA("ShirtGraphic") then c:Destroy() end end
                item.Name="ACTShirt"; item.Parent=character; return true
              end
              if item:IsA("Accessory") then
                local handle=item:FindFirstChild("Handle")
                if handle then
                  if itemType==Enum.AvatarAssetType.HairAccessory then
                    for _,c in pairs(character:GetChildren()) do
                      if c:IsA("Accessory") and (c.Name:lower():find("hair") or (c:FindFirstChild("Handle") and c.Handle:FindFirstChild("HairAttachment"))) then c:Destroy() end
                    end
                  else
                    for _,c in pairs(character:GetChildren()) do
                      if c:IsA("Accessory") and (c.Name==itemName or c.Name=="AC"..itemName) then c:Destroy() end
                    end
                  end
                  local attachment=handle:FindFirstChildOfClass("Attachment")
                  local targetPart=character:FindFirstChild("Head")
                  local targetAttachment=nil
                  if attachment then
                    for _,bodyPart in pairs(character:GetChildren()) do
                      if bodyPart:IsA("BasePart") then
                        targetAttachment=bodyPart:FindFirstChild(attachment.Name)
                        if targetAttachment then targetPart=bodyPart; break end
                      end
                    end
                  end
                  -- Senza un punto di aggancio valido il weld esplode: meglio
                  -- fallire pulito e lasciare che il retry ci riprovi.
                  if not targetPart then
                    targetPart = character:FindFirstChild("HumanoidRootPart")
                  end
                  if not targetPart then return false end
                  item.Name="AC"..itemName; item.Parent=character
                  handle.CFrame=targetPart.CFrame
                  for _,j in pairs(handle:GetChildren()) do
                    if j:IsA("Weld") or j:IsA("ManualWeld") or j:IsA("WeldConstraint") then j:Destroy() end
                  end
                  local w=Instance.new("Weld")
                  w.Name="ACManualWeld"; w.Part0=handle; w.Part1=targetPart
                  if attachment and targetAttachment then w.C0=attachment.CFrame; w.C1=targetAttachment.CFrame
                  else w.C0=CFrame.new(0,0.5,0) end
                  w.Parent=handle
                  return true
                end
              end
              return false
          end)
          return ok and applied == true
        end

        -- ---- Rimuovi item dal character ----
        local function _acRemoveItem(itemType, itemName)
          local character = LP.Character
          if not character then return end
          pcall(function()
            if itemType == Enum.AvatarAssetType.Shirt then
              for _,c in pairs(character:GetChildren()) do
                if c:IsA("Shirt") and (c.Name=="ACShirt" or c.Name==itemName) then c:Destroy() end
              end
            elseif itemType == Enum.AvatarAssetType.Pants then
              for _,c in pairs(character:GetChildren()) do
                if c:IsA("Pants") and (c.Name=="ACPants" or c.Name==itemName) then c:Destroy() end
              end
            elseif itemType == Enum.AvatarAssetType.TShirt then
              for _,c in pairs(character:GetChildren()) do
                if c:IsA("ShirtGraphic") and (c.Name=="ACTShirt" or c.Name==itemName) then c:Destroy() end
              end
            else
              -- Accessory: rimuovi per nome salvato
              for _,c in pairs(character:GetChildren()) do
                if c:IsA("Accessory") and (c.Name=="AC"..itemName or c.Name==itemName) then c:Destroy() end
              end
            end
          end)
        end

        -- ---- Save/Load separato ----
        local function _acSaveConfig()
          pcall(saveAmbitiousConfig)
        end

        -- (load avviene in loadAmbitiousConfig, già eseguita prima di questo blocco)

        -- Applica tutti gli item con toggle ON
        local function _acApplyAll(gen)
          if gen == nil then gen = _acGen end
          -- Si aspetta che il character sia completo PRIMA di iniziare:
          -- l'attesa a tempo fisso era la causa degli item saltati al reset.
          local character = LP.Character
          if not character then return end
          if not _acWaitCharReady(character, 10) then return end
          if gen ~= _acGen then return end

          for _,cat in ipairs(AC_CATEGORIES) do
            if gen ~= _acGen then return end   -- respawn nel frattempo: si abortisce
            local entry=_G._AmbitiousAvatarChanger[cat.Name]
            if entry and entry.enabled and entry.savedId then
              -- Fino a 3 tentativi: se l'asset tarda o il weld non trova
              -- l'attachment, si riprova invece di perdere l'item.
              for attempt = 1, 3 do
                if gen ~= _acGen then return end
                if _acEquipItem(entry.savedId, cat.AssetTypes[1], entry.savedName, gen) then
                  break
                end
                task.wait(0.25 * attempt)
              end
              task.wait(0.05)
            end
          end
        end

        -- Applica subito al personaggio esistente se c'e' un char e toggle ON
        task.spawn(function()
          if not LP.Character then return end
          _acApplyAll(_acGen)
        end)

        -- Applica al respawn
        LP.CharacterAdded:Connect(function()
          _acGen = _acGen + 1          -- invalida gli equip del character precedente
          local gen = _acGen
          task.spawn(function()
            _acApplyAll(gen)
          end)
        end)

        -- ------------------------------------------------------------
        -- WATCHER RE-EQUIP
        -- Gli item dell'Avatar Changer sono locali: quando un altro giocatore
        -- ti colpisce (o il gioco risincronizza il character) il server li
        -- cancella e restavi senza capelli. Qui vengono rimessi subito,
        -- sia per evento (ChildRemoved / HealthChanged) sia con un poll di
        -- sicurezza ogni secondo.
        -- ------------------------------------------------------------
        ;(function()
          local lastTry   = {}
          local fails     = {}
          local charConns = {}
          local pendingCheck = false

          -- Gli eventi (HealthChanged soprattutto) possono arrivare a raffica:
          -- qui vengono compattati in un solo controllo.
          local runCheck
          local function requestCheck(delaySec)
            if pendingCheck then return end
            pendingCheck = true
            task.delay(delaySec or 0.1, function()
              pendingCheck = false
              pcall(runCheck)
            end)
          end

          local function expectedFor(cat, entry)
            local at = cat.AssetTypes[1]
            if at == Enum.AvatarAssetType.Shirt then
              return "ACShirt", "Shirt"
            elseif at == Enum.AvatarAssetType.Pants then
              return "ACPants", "Pants"
            elseif at == Enum.AvatarAssetType.TShirt then
              return "ACTShirt", "ShirtGraphic"
            end
            return "AC"..tostring(entry.savedName or ""), "Accessory"
          end

          local function isPresent(character, cat, entry)
            local nm, cls = expectedFor(cat, entry)
            for _, c in ipairs(character:GetChildren()) do
              if c:IsA(cls) and (c.Name == nm or c.Name == entry.savedName) then
                return true
              end
            end
            return false
          end

          function runCheck()
            local character = LP.Character
            if not character or not character.Parent then return end
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then return end
            local now = tick()
            for _, cat in ipairs(AC_CATEGORIES) do
              local entry = _G._AmbitiousAvatarChanger[cat.Name]
              if entry and entry.enabled and entry.savedId then
                if isPresent(character, cat, entry) then
                  fails[cat.Name] = nil
                else
                  -- Backoff: se un asset non si applica (id rotto, attachment
                  -- assente) non si riprova all'infinito ogni 0.6s.
                  local n = fails[cat.Name] or 0
                  local wait = math.min(0.6 * (2 ^ math.min(n, 5)), 20)
                  if (now - (lastTry[cat.Name] or 0)) > wait then
                    lastTry[cat.Name] = now
                    local gen = _acGen
                    local _cn = cat.Name
                    local _id, _at, _nm = entry.savedId, cat.AssetTypes[1], entry.savedName
                    task.spawn(function()
                      if gen ~= _acGen then return end
                      if _acEquipItem(_id, _at, _nm, gen) then
                        fails[_cn] = nil
                      else
                        fails[_cn] = (fails[_cn] or 0) + 1
                      end
                    end)
                  end
                end
              end
            end
          end
          _G._AmbitiousAvatarChangerRecheck = function() fails = {}; pcall(runCheck) end

          local function hookCharacter(character)
            for _, c in ipairs(charConns) do pcall(function() c:Disconnect() end) end
            charConns = {}
            if not character then return end
            table.insert(charConns, character.ChildRemoved:Connect(function(child)
              if child:IsA("Accessory") or child:IsA("Shirt")
              or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                requestCheck(0.05)
              end
            end))
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
              -- Il caso segnalato: colpito da un altro player -> accessori persi
              table.insert(charConns, hum.HealthChanged:Connect(function()
                requestCheck(0.15)
              end))
            end
          end

          hookCharacter(LP.Character)
          LP.CharacterAdded:Connect(function(c)
            task.delay(0.6, function() hookCharacter(c) end)
          end)

          task.spawn(function()
            while true do
              task.wait(1)
              pcall(runCheck)
            end
          end)
        end)()

        -- ---- Visual callbacks sub-toggle ----
        local _acSubSetVisuals = {}

        -- ---- Unico popup condiviso ----
        local _acPickerGui = nil
        -- Categoria del popup attualmente aperto: serve per il toggle sul riclick
        local _acPickerCat = nil
        -- Il backdrop e' un Frame e non assorbe il click, quindi cliccando un PICK
        -- mentre il popup e' aperto arrivano DUE eventi in quest'ordine:
        --   1) backdrop.InputBegan -> chiude il popup
        --   2) pickBtn.Activated   -> lo trovava gia' chiuso e lo riapriva
        -- Ricordiamo cosa e' stato appena chiuso per ignorare il secondo evento.
        local _acPickerJustClosedCat = nil
        local _acPickerJustClosedAt = 0

        local function _acClosePicker()
          if _acPickerGui and _acPickerGui.Parent then
            _acPickerGui:Destroy()
            _acPickerJustClosedCat = _acPickerCat
            _acPickerJustClosedAt = tick()
          end
          _acPickerGui = nil
          _acPickerCat = nil
        end

        local function _acOpenPicker(catName, assetTypes)
          -- Riclick sullo stesso PICK: chiude, come fanno gli altri picker.
          -- Click su un PICK diverso: passa a quella categoria.
          if _acPickerGui and _acPickerGui.Parent and _acPickerCat == catName then
            _acClosePicker()
            return
          end
          -- Il backdrop ha appena chiuso questo stesso popup: non riaprirlo.
          if _acPickerJustClosedCat == catName and (tick() - _acPickerJustClosedAt) < 0.25 then
            _acPickerJustClosedCat = nil
            return
          end
          _acClosePicker()
          _acPickerJustClosedCat = nil
          _acPickerCat = catName

          _acPickerGui=Instance.new("ScreenGui")
          _acPickerGui.Name="AmbitiousHubAVChanger"
          _acPickerGui.ResetOnSpawn=false
          _acPickerGui.IgnoreGuiInset=true
          _acPickerGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
          _acPickerGui.DisplayOrder=9998
          _acPickerGui.Parent=HubGui

          -- Frame (non TextButton) come tutti gli altri picker: un TextButton
          -- catturerebbe l'input e i bottoni sotto smetterebbero di ricevere
          -- MouseLeave, restando bloccati nello stato hover.
          local backdrop=Instance.new("Frame")
          backdrop.Name="Backdrop"
          backdrop.Size=UDim2.new(1,0,1,0)
          backdrop.BackgroundColor3=Color3.fromRGB(0,0,0)
          backdrop.BackgroundTransparency=0.45
          backdrop.BorderSizePixel=0
          backdrop.ZIndex=1
          backdrop.Parent=_acPickerGui

          local pickerFrame=Instance.new("Frame")
          pickerFrame.Name="Frame"
          pickerFrame.Size=UDim2.new(0,370,0,510)
          pickerFrame.Position=UDim2.new(0.5,-185,0.5,-255)
          pickerFrame.BackgroundColor3=Color3.fromRGB(9, 8, 10)
          pickerFrame.BorderSizePixel=0
          pickerFrame.ZIndex=2
          pickerFrame.Parent=_acPickerGui
          corner(pickerFrame,16)
          stroke(pickerFrame,Color3.fromRGB(98, 90, 105),1.2,0.3)

          -- Title bar
          local titleBar=Instance.new("Frame")
          titleBar.Size=UDim2.new(1,0,0,48)
          titleBar.BackgroundColor3=Color3.fromRGB(14, 12, 15)
          titleBar.BackgroundTransparency=0.15
          titleBar.BorderSizePixel=0
          titleBar.ZIndex=3
          titleBar.Parent=pickerFrame
          corner(titleBar,16)

          local titleLabel=Instance.new("TextLabel")
          titleLabel.Size=UDim2.new(1,-60,1,0)
          titleLabel.Position=UDim2.new(0,18,0,0)
          titleLabel.BackgroundTransparency=1
          titleLabel.Text=catName.." Changer"
          titleLabel.TextColor3=Color3.fromRGB(255,255,255)
          titleLabel.Font=Enum.Font.GothamBlack
          titleLabel.TextSize=15
          titleLabel.TextXAlignment=Enum.TextXAlignment.Left
          titleLabel.ZIndex=4
          titleLabel.Parent=titleBar

          local closeBtn=Instance.new("TextButton")
          closeBtn.Size=UDim2.new(0,36,0,36)
          closeBtn.Position=UDim2.new(1,-44,0,6)
          closeBtn.BackgroundColor3=Color3.fromRGB(25,25,28)
          closeBtn.BackgroundTransparency=0.1
          closeBtn.BorderSizePixel=0
          closeBtn.Text="X"
          closeBtn.TextColor3=Color3.fromRGB(255,255,255)
          closeBtn.Font=Enum.Font.GothamBlack
          closeBtn.TextSize=14
          closeBtn.AutoButtonColor=false
          closeBtn.ZIndex=4
          closeBtn.Parent=titleBar
          corner(closeBtn,10)
          stroke(closeBtn,Color3.fromRGB(98, 90, 105),1,0.4)
          closeBtn.MouseEnter:Connect(function() tween(closeBtn,{BackgroundColor3=Color3.fromRGB(119, 50, 180)},0.12) end)
          closeBtn.MouseLeave:Connect(function() tween(closeBtn,{BackgroundColor3=Color3.fromRGB(25,25,28)},0.12) end)
          closeBtn.Activated:Connect(_acClosePicker)

          -- Search bar
          local searchBar=Instance.new("TextBox")
          searchBar.Size=UDim2.new(1,-24,0,30)
          searchBar.Position=UDim2.new(0,12,0,55)
          searchBar.BackgroundColor3=Color3.fromRGB(20, 18, 22)
          searchBar.BackgroundTransparency=0.1
          searchBar.BorderSizePixel=0
          searchBar.PlaceholderText="Search name, or paste an asset ID..."
          searchBar.PlaceholderColor3=Color3.fromRGB(110,110,120)
          searchBar.Text=""
          searchBar.TextColor3=Color3.fromRGB(245,245,255)
          searchBar.Font=Enum.Font.GothamSemibold
          searchBar.TextSize=12
          searchBar.ClearTextOnFocus=false
          searchBar.ZIndex=4
          searchBar.Parent=pickerFrame
          corner(searchBar,8)
          stroke(searchBar,Color3.fromRGB(78, 70, 85),1,0.4)

          -- Status label
          local statusLabel=Instance.new("TextLabel")
          statusLabel.Size=UDim2.new(1,-24,0,22)
          statusLabel.Position=UDim2.new(0,12,0,92)
          statusLabel.BackgroundTransparency=1
          statusLabel.Text="Loading..."
          statusLabel.TextColor3=Color3.fromRGB(150,150,160)
          statusLabel.Font=Enum.Font.GothamSemibold
          statusLabel.TextSize=11
          statusLabel.ZIndex=4
          statusLabel.Parent=pickerFrame

          -- Scroll con thumbnails a griglia
          local scrollFrame=Instance.new("ScrollingFrame")
          scrollFrame.Size=UDim2.new(1,-12,1,-100)
          scrollFrame.Position=UDim2.new(0,6,0,96)
          scrollFrame.BackgroundTransparency=1
          scrollFrame.BorderSizePixel=0
          scrollFrame.ScrollBarThickness=4
          scrollFrame.ScrollBarImageColor3=Color3.fromRGB(80,80,90)
          scrollFrame.CanvasSize=UDim2.new(0,0,0,0)
          scrollFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
          scrollFrame.ZIndex=3
          scrollFrame.Parent=pickerFrame

          local gridLayout=Instance.new("UIGridLayout")
          gridLayout.CellSize=UDim2.new(0,100,0,120)
          gridLayout.CellPadding=UDim2.new(0,8,0,8)
          gridLayout.FillDirection=Enum.FillDirection.Horizontal
          gridLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
          gridLayout.SortOrder=Enum.SortOrder.LayoutOrder
          gridLayout.Parent=scrollFrame

          local gridPad=Instance.new("UIPadding")
          gridPad.PaddingTop=UDim.new(0,8)
          gridPad.PaddingBottom=UDim.new(0,8)
          gridPad.PaddingLeft=UDim.new(0,6)
          gridPad.PaddingRight=UDim.new(0,6)
          gridPad.Parent=scrollFrame

          local itemOrder=0
          local currentCatalogPage=nil
          local loadingMore=false

          local function makeItemCard(item)
            itemOrder=itemOrder+1
            local card=Instance.new("TextButton")
            card.Name="AC_Item_"..tostring(item.Id)
            card.BackgroundColor3=Color3.fromRGB(18, 16, 20)
            card.BackgroundTransparency=0.05
            card.BorderSizePixel=0
            card.Text=""
            card.AutoButtonColor=false
            card.LayoutOrder=itemOrder
            card.ZIndex=4
            card.Parent=scrollFrame
            corner(card,10)
            local cardStroke=Instance.new("UIStroke")
            cardStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            cardStroke.Color=Color3.fromRGB(56, 50, 62)
            cardStroke.Thickness=1
            cardStroke.Transparency=0.5
            cardStroke.Parent=card

            -- Thumbnail immagine
            local thumb=Instance.new("ImageLabel")
            thumb.Size=UDim2.new(1,-8,0,72)
            thumb.Position=UDim2.new(0,4,0,4)
            thumb.BackgroundColor3=Color3.fromRGB(25, 22, 28)
            thumb.BorderSizePixel=0
            thumb.ZIndex=5
            thumb.Image="rbxthumb://type=Asset&id="..tostring(item.Id).."&w=150&h=150"
            thumb.ScaleType=Enum.ScaleType.Fit
            thumb.Parent=card
            corner(thumb,7)

            -- Nome item (sotto thumbnail, troncato)
            local nameLabel=Instance.new("TextLabel")
            nameLabel.Size=UDim2.new(1,-6,0,30)
            nameLabel.Position=UDim2.new(0,3,0,78)
            nameLabel.BackgroundTransparency=1
            nameLabel.Text=item.Name or "?"
            nameLabel.TextColor3=Color3.fromRGB(225,225,235)
            nameLabel.Font=Enum.Font.GothamSemibold
            nameLabel.TextSize=9
            nameLabel.TextWrapped=true
            nameLabel.TextXAlignment=Enum.TextXAlignment.Center
            nameLabel.TextYAlignment=Enum.TextYAlignment.Top
            nameLabel.ZIndex=5
            nameLabel.Parent=card

            card.MouseEnter:Connect(function()
              tween(card,{BackgroundColor3=Color3.fromRGB(34, 30, 38)},0.1)
              tween(cardStroke,{Color=Color3.fromRGB(200,200,210),Transparency=0.15},0.1)
            end)
            card.MouseLeave:Connect(function()
              -- ripristina colore normale (verde=selezionato gia' equipaggiato)
              local entry=_G._AmbitiousAvatarChanger[catName]
              local isSaved = entry and entry.savedId == item.Id
              tween(card,{BackgroundColor3=isSaved and Color3.fromRGB(28, 20, 36) or Color3.fromRGB(18, 16, 20)},0.1)
              tween(cardStroke,{Color=isSaved and Color3.fromRGB(173, 120, 220) or Color3.fromRGB(56, 50, 62),Transparency=isSaved and 0.15 or 0.5},0.1)
            end)

            -- Evidenzia se gia' salvato
            local entry=_G._AmbitiousAvatarChanger[catName]
            if entry and entry.savedId == item.Id then
              card.BackgroundColor3=Color3.fromRGB(28, 20, 36)
              cardStroke.Color=Color3.fromRGB(173, 120, 220)
              cardStroke.Transparency=0.15
            end

            card.Activated:Connect(function()
              local ent=_G._AmbitiousAvatarChanger[catName]
              if not ent then return end
              -- Se toggle ON e c'era un vecchio item, rimuovilo prima
              if ent.enabled and ent.savedId and ent.savedName ~= "" then
                _acRemoveItem(assetTypes[1], ent.savedName)
              end
              ent.savedId=item.Id
              ent.savedName=item.Name or ""
              if ent.enabled then
                local _id, _at, _nm = item.Id, assetTypes[1], item.Name or ""
                task.spawn(function() _acEquipItem(_id,_at,_nm) end)
              end
              _acSaveConfig()
              -- Aggiorna highlight su tutte le card
              for _,ch in ipairs(scrollFrame:GetChildren()) do
                if ch:IsA("TextButton") then
                  local st2=ch:FindFirstChildOfClass("UIStroke")
                  local isThis=(ch.Name=="AC_Item_"..tostring(item.Id))
                  tween(ch,{BackgroundColor3=isThis and Color3.fromRGB(28, 20, 36) or Color3.fromRGB(18, 16, 20)},0.14)
                  if st2 then tween(st2,{Color=isThis and Color3.fromRGB(173, 120, 220) or Color3.fromRGB(56, 50, 62),Transparency=isThis and 0.15 or 0.5},0.14) end
                end
              end
            end)
          end

          -- Numero della categoria per l'API web di Roblox. Serve al fallback
          -- HTTP: AvatarEditorService:SearchCatalog richiede il permesso del
          -- giocatore e su molti executor fallisce in silenzio, lasciando la
          -- griglia vuota (era il motivo per cui non si poteva scegliere nulla).
          local AC_WEB_TYPE = {
            [Enum.AvatarAssetType.HairAccessory]     = 41,
            [Enum.AvatarAssetType.Hat]               = 8,
            [Enum.AvatarAssetType.FaceAccessory]     = 42,
            [Enum.AvatarAssetType.NeckAccessory]     = 43,
            [Enum.AvatarAssetType.ShoulderAccessory] = 44,
            [Enum.AvatarAssetType.FrontAccessory]    = 45,
            [Enum.AvatarAssetType.BackAccessory]     = 46,
            [Enum.AvatarAssetType.WaistAccessory]    = 47,
            [Enum.AvatarAssetType.Shirt]             = 11,
            [Enum.AvatarAssetType.Pants]             = 12,
            [Enum.AvatarAssetType.TShirt]            = 2,
            [Enum.AvatarAssetType.JacketAccessory]   = 65,
            [Enum.AvatarAssetType.SweaterAccessory]  = 64,
            [Enum.AvatarAssetType.ShortsAccessory]   = 66,
          }

          -- Ricerca via HTTP sul catalogo pubblico. Ritorna una lista di
          -- {Id=, Name=} oppure nil se l'executor non espone una request.
          local function webSearch(keyword)
            local req = (syn and syn.request) or (http and http.request)
                        or http_request or request
            if not req then return nil end
            local webType = AC_WEB_TYPE[assetTypes[1]]
            if not webType then return nil end
            local url = "https://catalog.roblox.com/v1/search/items/details?Category=11"
                     .. "&AssetTypeId=" .. tostring(webType)
                     .. "&Limit=30&SortType=0"
            if keyword and keyword ~= "" then
              url = url .. "&Keyword=" .. (game:GetService("HttpService"):UrlEncode(keyword))
            end
            local ok, res = pcall(req, { Url = url, Method = "GET" })
            if not ok or not res or not res.Body then return nil end
            local ok2, decoded = pcall(function()
              return game:GetService("HttpService"):JSONDecode(res.Body)
            end)
            if not ok2 or type(decoded) ~= "table" or type(decoded.data) ~= "table" then
              return nil
            end
            local out = {}
            for _, d in ipairs(decoded.data) do
              if d.id then
                table.insert(out, { Id = d.id, Name = d.name or ("Asset " .. tostring(d.id)) })
              end
            end
            return out
          end

          local function loadItems(keyword)
            for _,c in ipairs(scrollFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            itemOrder=0
            currentCatalogPage=nil
            loadingMore=false
            statusLabel.Text="Loading..."
            statusLabel.Visible=true

            -- Se la ricerca e' solo cifre la si tratta come un ID diretto:
            -- funziona sempre, anche senza catalogo e senza HTTP.
            local asId = keyword and tonumber(keyword:match("^%s*(%d+)%s*$"))
            if asId then
              statusLabel.Visible=false
              makeItemCard({ Id = asId, Name = "Asset " .. tostring(asId) })
              return
            end

            task.spawn(function()
              local ok,pages2=pcall(function()
                local params=CatalogSearchParams.new()
                params.AssetTypes=assetTypes
                if keyword and keyword~="" then params.SearchKeyword=keyword end
                return game:GetService("AvatarEditorService"):SearchCatalog(params)
              end)

              if ok and pages2 then
                local okPage, firstPage = pcall(function() return pages2:GetCurrentPage() end)
                if okPage and type(firstPage) == "table" and #firstPage > 0 then
                  currentCatalogPage=pages2
                  statusLabel.Visible=false
                  statusLabel.Text=""
                  for _,item in ipairs(firstPage) do makeItemCard(item) end
                  return
                end
              end

              -- Fallback HTTP
              local webItems = webSearch(keyword)
              if webItems and #webItems > 0 then
                currentCatalogPage=nil   -- niente paginazione infinita qui
                statusLabel.Visible=false
                statusLabel.Text=""
                for _,item in ipairs(webItems) do makeItemCard(item) end
                return
              end

              statusLabel.Visible=true
              statusLabel.Text="No catalog access — type an asset ID in the search bar."
            end)
          end

          scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if loadingMore or not currentCatalogPage then return end
            local posY=scrollFrame.CanvasPosition.Y
            local canvasH=scrollFrame.CanvasSize.Y.Offset
            local viewH=scrollFrame.AbsoluteSize.Y
            if canvasH>0 and posY+viewH>=canvasH-100 and not currentCatalogPage.IsFinished then
              loadingMore=true
              task.spawn(function()
                local ok2=pcall(function() currentCatalogPage:AdvanceToNextPageAsync() end)
                if ok2 then
                  for _,item in ipairs(currentCatalogPage:GetCurrentPage()) do makeItemCard(item) end
                end
                loadingMore=false
              end)
            end
          end)

          local searchDebounce=nil
          searchBar:GetPropertyChangedSignal("Text"):Connect(function()
            if searchDebounce then task.cancel(searchDebounce) end
            searchDebounce=task.delay(0.5,function() loadItems(searchBar.Text) end)
          end)

          backdrop.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
              _acClosePicker()
            end
          end)

          pickerFrame.Size=UDim2.new(0,0,0,0)
          pickerFrame.Position=UDim2.new(0.5,0,0.5,0)
          TweenService:Create(pickerFrame,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size=UDim2.new(0,370,0,510),
            Position=UDim2.new(0.5,-185,0.5,-255)
          }):Play()

          loadItems("")
        end

        -- Ponte verso la GUI di Sound Hub
        _G.SoundAvatarChanger = {
            categories = AC_CATEGORIES,
            state      = _G._AmbitiousAvatarChanger,
            openPicker = _acOpenPicker,
            removeItem = _acRemoveItem,
            equipItem  = _acEquipItem,
            applyAll   = function() task.spawn(function() _acApplyAll() end) end,
        }
    end

    -- ========================== RADIUS CIRCLE ==========================
    -- Disco piatto alla base dei piedi, raggio e colore regolabili.
    do
        _G.SoundRadiusCircleEnabled = _G.SoundRadiusCircleEnabled == true
        _G.SoundRadiusCircleRadius  = tonumber(_G.SoundRadiusCircleRadius) or 8
        _G.SoundRadiusCircleColor   = _G.SoundRadiusCircleColor or Color3.fromRGB(230, 201, 255)

        local rcPart, rcConn

        local function rcDestroy()
            if rcConn then pcall(function() rcConn:Disconnect() end); rcConn = nil end
            if rcPart then pcall(function() rcPart:Destroy() end); rcPart = nil end
        end

        local function rcEnsure()
            if rcPart and rcPart.Parent then return rcPart end
            local cam = workspace.CurrentCamera
            if not cam then return nil end
            for _, o in ipairs(cam:GetChildren()) do
                if o.Name == "SoundRadiusCircle" or o.Name == "BloomRadiusCircle" then pcall(function() o:Destroy() end) end
            end
            local p = Instance.new("Part")
            p.Name        = "SoundRadiusCircle"
            p.Shape       = Enum.PartType.Cylinder
            p.Anchored    = true
            p.CanCollide  = false
            p.CanQuery    = false
            p.CanTouch    = false
            p.CastShadow  = false
            p.Massless    = true
            p.Material    = Enum.Material.Neon
            p.Color       = _G.SoundRadiusCircleColor
            p.Transparency = 0.72
            p.Size        = Vector3.new(0.12, 2, 2)
            p.Parent      = cam
            rcPart = p
            return p
        end

        local function rcStep()
            if _G.SoundRadiusCircleEnabled ~= true then rcDestroy() return end
            local char = LP.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp then if rcPart then rcPart.Transparency = 1 end return end
            local p = rcEnsure(); if not p then return end
            p.Transparency = 0.72
            local d = math.clamp(tonumber(_G.SoundRadiusCircleRadius) or 8, 0.5, 500) * 2
            p.Size = Vector3.new(0.12, d, d)
            local footY = hrp.Position.Y - (hrp.Size.Y * 0.5) - ((hum and hum.HipHeight) or 2)
            local prev = _G._SoundRCLastY
            if prev and math.abs(footY - prev) < 1.5 then
                footY = prev + (footY - prev) * 0.4
            end
            _G._SoundRCLastY = footY
            p.CFrame = CFrame.new(hrp.Position.X, footY + 0.2, hrp.Position.Z)
                     * CFrame.Angles(0, 0, math.rad(90))
        end

        function _G.SoundSetRadiusCircle(on)
            _G.SoundRadiusCircleEnabled = on and true or false
            if _G.SoundRadiusCircleEnabled then
                if not rcConn then
                    rcConn = RunService.RenderStepped:Connect(function()
                        local ok = pcall(rcStep)
                        if not ok and rcPart then rcPart.Transparency = 1 end
                    end)
                end
            else
                rcDestroy()
            end
        end

        function _G.SoundSetRadiusCircleColor(c)
            if typeof(c) ~= "Color3" then return end
            _G.SoundRadiusCircleColor = c
            if rcPart and rcPart.Parent then pcall(function() rcPart.Color = c end) end
        end

        function _G.SoundSetRadiusCircleRadius(v)
            v = tonumber(v); if not v then return end
            _G.SoundRadiusCircleRadius = math.clamp(v, 0.5, 500)
        end
    end
end
-- ################## END AMBITIOUS -> SOUND HUB PORT ##################

local function buildGui()
    local WHITE      = Color3.fromRGB(240, 246, 255)
    local BLACK      = Color3.fromRGB(4, 12, 32)
    local DARK       = Color3.fromRGB(2, 5, 13)
    local DARKER     = Color3.fromRGB(1, 4, 10)
    local MID        = Color3.fromRGB(9, 20, 46)
    local DIM_LINE   = Color3.fromRGB(40, 77, 163)
    local CHECK_OFF  = Color3.fromRGB(7, 18, 42)
    local BTN_ACT    = Color3.fromRGB(6, 22, 60)
    local INP_BG     = Color3.fromRGB(5, 11, 25)
    local CYAN_SECT  = Color3.fromRGB(67, 112, 218)
    local BLUE_GLOW  = Color3.fromRGB(41, 95, 220)
    local PILL_ON    = Color3.fromRGB(21, 77, 209)
    local ROW_W      = 0.96 -- expanded rows so toggles fill the right side

    __HH.TOGGLE_ON_COLOR = PILL_ON

    for _, name in ipairs({"Sound Hub", "Bloom Hub", "Horizon Hub", "Sound hub", "HorizonHubMobileButtons", "SoundHubMobileButtons", "yousefStealBar", "yousefRagdollTimer"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(name)
        if old then old:Destroy() end
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
    end

    if _G.setupNexusGrabBar then pcall(_G.setupNexusGrabBar) end
    local gui = Instance.new("ScreenGui")
    gui.Name = "Sound Hub"; gui.ResetOnSpawn = false
    gui.DisplayOrder = 10; gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    __HH.uiScaleObject = Instance.new("UIScale", gui)
    __HH.uiScaleObject.Scale = uiScaleValue

    __HH.mainFrame = Instance.new("Frame", gui)
    __HH.mainFrame.Name = "MainFrame"
    local sizeStep = ((__HH.guiSizeValue or 3) - 3) * 50
    __HH.mainFrame.Size = UDim2.new(0, 480 + sizeStep, 0, 500 + sizeStep)
    __HH.mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    __HH.mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- always opens in the center of the screen
    __HH.panelScaleObject = nil -- GUI Size now adjusts width and height directly.
    __HH.mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local panelGrad = Instance.new("UIGradient", __HH.mainFrame)
    panelGrad.Name = "PanelGradient"
    panelGrad.Rotation = 90
    panelGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(10, 20, 65))
    })
    __HH.mainFrame.BorderSizePixel = 0
    __HH.mainFrame.ClipsDescendants = true
    Instance.new("UICorner", __HH.mainFrame).CornerRadius = UDim.new(0, 24)

    -- ============================================================
    -- SHINY PANEL + IDLE DIM (UI only)
    -- Animated shiny border, soft glow, light sweep. When the panel
    -- is not touched for IDLE_AFTER seconds a dark film fades over it
    -- (nothing inside the panel is changed, so nothing can get stuck
    -- invisible). Tap/click/hover removes the film instantly.
    -- ============================================================
    do
        local UIS_ = game:GetService("UserInputService")
        local RS_  = game:GetService("RunService")
        local TS_  = game:GetService("TweenService")
        local GuiService_ = game:GetService("GuiService")
        local mf   = __HH.mainFrame

        -- tweak these
        local SHINE_COLOR   = Color3.fromRGB(110, 165, 255) -- border colour
        local IDLE_AFTER    = 3     -- seconds without touching before idle
        local IDLE_DARKEN   = 0.6   -- how dark the idle film gets (0 = none, 1 = black)
        local SWEEP_EVERY   = 3.2   -- seconds between light sweeps

        local shineStroke = Instance.new("UIStroke", mf)
        shineStroke.Name = "ShineBorder"
        shineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        shineStroke.Color = SHINE_COLOR
        shineStroke.Thickness = 2
        shineStroke.Transparency = 0.05
        local shineGrad = Instance.new("UIGradient", shineStroke)
        shineGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(70, 95, 190)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(70, 95, 190)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(70, 95, 190))
        })

        local glowStroke = Instance.new("UIStroke", mf)
        glowStroke.Name = "ShineGlow"
        glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        glowStroke.Color = SHINE_COLOR
        glowStroke.Thickness = 6
        glowStroke.Transparency = 0.82

        -- extra purple line border inside the panel (everything sits inside it)
        local PURPLE_LINE = Color3.fromRGB(150, 70, 255)
        local innerBorder = Instance.new("Frame", mf)
        innerBorder.Name = "PurpleInnerBorder"
        innerBorder.Size = UDim2.new(1, -12, 1, -12)
        innerBorder.Position = UDim2.new(0, 6, 0, 6)
        innerBorder.BackgroundTransparency = 1
        innerBorder.BorderSizePixel = 0
        innerBorder.Active = false
        innerBorder.ZIndex = 60
        Instance.new("UICorner", innerBorder).CornerRadius = UDim.new(0, 19)
        local innerLine = Instance.new("UIStroke", innerBorder)
        innerLine.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        innerLine.Color = PURPLE_LINE
        innerLine.Thickness = 1.6
        innerLine.Transparency = 0.1
        local innerGlow = Instance.new("UIStroke", innerBorder)
        innerGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        innerGlow.Color = PURPLE_LINE
        innerGlow.Thickness = 4
        innerGlow.Transparency = 0.85

        local sweep = Instance.new("Frame", mf)
        sweep.Name = "ShineSweep"
        sweep.AnchorPoint = Vector2.new(0.5, 0.5)
        sweep.Size = UDim2.new(0, 110, 2, 0)
        sweep.Position = UDim2.new(-0.3, 0, 0.5, 0)
        sweep.Rotation = 18
        sweep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sweep.BackgroundTransparency = 0
        sweep.BorderSizePixel = 0
        sweep.Active = false
        sweep.ZIndex = 400
        local sweepGrad = Instance.new("UIGradient", sweep)
        sweepGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.0, 1),
            NumberSequenceKeypoint.new(0.5, 0.90),
            NumberSequenceKeypoint.new(1.0, 1)
        })

        -- extra purple border line inside the panel (banner + everything sits inside it)
        local innerBorder = Instance.new("Frame", mf)
        innerBorder.Name = "PurpleBorder"
        innerBorder.Size = UDim2.new(1, -12, 1, -12)
        innerBorder.Position = UDim2.new(0, 6, 0, 6)
        innerBorder.BackgroundTransparency = 1
        innerBorder.BorderSizePixel = 0
        innerBorder.Active = false
        innerBorder.ZIndex = 60
        Instance.new("UICorner", innerBorder).CornerRadius = UDim.new(0, 18)
        local innerBorderStroke = Instance.new("UIStroke", innerBorder)
        innerBorderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        innerBorderStroke.Color = Color3.fromRGB(255, 255, 255)
        innerBorderStroke.Thickness = 2
        innerBorderStroke.Transparency = 0.05
        local innerBorderGrad = Instance.new("UIGradient", innerBorderStroke)
        innerBorderGrad.Rotation = 90
        innerBorderGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(185, 105, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 45, 205))
        })

        -- idle film: only exists (Visible) while idle, so it never blocks the panel when awake
        local idleDim = Instance.new("TextButton", mf)
        idleDim.Name = "IdleDim"
        idleDim.Size = UDim2.new(1, 0, 1, 0)
        idleDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        idleDim.BackgroundTransparency = 1
        idleDim.BorderSizePixel = 0
        idleDim.Text = ""
        idleDim.AutoButtonColor = false
        idleDim.Active = true
        idleDim.Visible = false
        idleDim.ZIndex = 450
        Instance.new("UICorner", idleDim).CornerRadius = UDim.new(0, 24)

        local dimAmt, lastActive = 0, os.clock()

        local function inside(pos)
            local p, s = mf.AbsolutePosition, mf.AbsoluteSize
            return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
        end
        local function wake() lastActive = os.clock() end
        local function onAnyInput(input)
            local t = input.UserInputType
            if t == Enum.UserInputType.Touch or t == Enum.UserInputType.MouseButton1
                or t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.MouseWheel then
                local inset = GuiService_:GetGuiInset()
                if inside(Vector2.new(input.Position.X, input.Position.Y + inset.Y)) or inside(Vector2.new(input.Position.X, input.Position.Y)) then
                    wake()
                end
            end
        end
        UIS_.InputBegan:Connect(onAnyInput)
        UIS_.InputChanged:Connect(onAnyInput)
        mf.InputBegan:Connect(function(input)
            local t = input.UserInputType
            if t == Enum.UserInputType.Touch or t == Enum.UserInputType.MouseButton1 then wake() end
        end)
        idleDim.MouseButton1Down:Connect(wake)
        idleDim.InputBegan:Connect(function(input)
            local t = input.UserInputType
            if t == Enum.UserInputType.Touch or t == Enum.UserInputType.MouseButton1 then wake() end
        end)

        -- light sweep loop
        task.spawn(function()
            while mf.Parent do
                if mf.Visible and dimAmt < 0.5 then
                    sweep.Visible = true
                    sweep.Position = UDim2.new(-0.3, 0, 0.5, 0)
                    local tw = TS_:Create(sweep, TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                        {Position = UDim2.new(1.3, 0, 0.5, 0)})
                    tw:Play()
                    tw.Completed:Wait()
                else
                    sweep.Visible = false
                end
                task.wait(SWEEP_EVERY)
            end
        end)

        -- border rotation + idle controller
        local conn
        conn = RS_.Heartbeat:Connect(function(dt)
            if not mf.Parent then conn:Disconnect() return end
            shineGrad.Rotation = (shineGrad.Rotation + dt * 70) % 360

            local function clearDim()
                if dimAmt > 0 or idleDim.Visible then
                    dimAmt = 0
                    idleDim.BackgroundTransparency = 1
                    idleDim.Visible = false
                end
            end
            if not mf.Visible then lastActive = os.clock() clearDim() return end

            local active = (os.clock() - lastActive) < IDLE_AFTER
                or UIS_:GetFocusedTextBox() ~= nil
            -- on phones the mouse position is stale, so only use it when a real mouse exists
            if not active and UIS_.MouseEnabled and inside(UIS_:GetMouseLocation()) then
                active = true
                lastActive = os.clock()
            end

            if active then clearDim() return end

            -- idle: fade the dark film in
            if dimAmt >= 1 then return end
            dimAmt = math.min(1, dimAmt + dt / 0.45)
            idleDim.Visible = true
            idleDim.BackgroundTransparency = 1 - IDLE_DARKEN * dimAmt
        end)
    end

    -- (panel border outline removed)

    -- Main GUI background (embedded Base64 — Sound Hub art)
    local SOUND_MAIN_BG_B64 = [[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KtVoBMD2qdGOarjrUydapDNBGOKl6VAnSp60iFyYE9KlU5OKhHWpV61omFyyig1IowaYlWEWqTC5Mgq2naoUWp061aEWkqUdaiSpR1qkMux1NUMdTmqGmPBOKlyRUI6VLQMeORU6jAqAdKsDpQA4HFPVjio6evSgCYc1MnAqFamXpSGh2akjBYgDucVFVqzZUmMkn3UUsfw5obSV2XFqOp4V+0XrZ0/RINFiYCR8HHfAbmvisj5AD1716/8AGzxM/iXxhK8RzFbllX0wcH1NeQnlQ571+U51XliMQ53ukfLYqblUeuhHtBo2LTqK8Z+87nPPTY//1PxF3UbqbRX6a5HsEdFFFYuYDtxo3U2iobJuMPWkpT1pKhyC43caNxpD1pKLiHbjRuNNoouAdaKKKi4BRRRRcAooorRAFFFFMBQcUu402ipbAUnNJRRRcAooopAFFFFACg4pdxptFADwc0tNWnUAFFFFFwEJxSbjSt0plO4Dtxo3Gm0UXAduNG402ii4Dtxo3Gm0U0A7caNxptFMBdxpKKKACiiigAp+0U0dafSYCbRS0UUrgFFFFFwCm7jTqjouA7caNxptFFwHbjRgHmm1IOlFwE2ilooouAUu40lFFwHbjRuNNooTAduNG402iqAduNN60UUAFKDikooAduNG402imhoduNOVjio6evSmUP3GjcabRTQDtxo3Gm0VQDtxo3Gm0UAO3GlVjTKctAEm40bjTaKaAduNKpyeaZSg4qgJcClBC8iotxoBzQgJvMPpQHJ7VHRnFUBNuNAOTUG6lDc0wLFKOtRbjQGOaq5ZYyKTIqLJoBNFwJNxo3Gm0o61aYXJAcU8OemKjoqlILliiot1KGq7lE240bjTaKrmAsUVFuo3Vpcst4FGBUW40u40+YsmoqLdRurRMotADHWnggVACcUuTWiYE4c5qUOaphvWplNWpFlxXNTBziqQb1qdTWsZAW1epgxqmrcVMprojIdy0GNTrJiqatUoatYyNEzTjckDNW42rKjfjFW43PSt4zHc1Ufircb1lI5xVqN62UzRM1434q9HLisRZDVpJTXTGWhaZvRznGKuhzIAOn0rAilOOK0IpfWqUi0zooJhwrDp3qa4srPWrdrS8UN6FutZETvtLLVqKds5HBrSUFVjyzLbUlynzx4r8JXvh+7JClom6Hn29q4912AE96+w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AGacBitEA9adTVp1UAU5aQDJxUgTFbRLiPpy9abTl61oUTDpTl600dKcvWtYmkSYdqkqMU7dVlodTl61Hup4OK1iMnHSnhqgD9sVJWsQLIaplaqo61OvFbxZcS8rVKGqordjUwNbRZZbBqwjdKpqeM1ZT1rpgyol5G4q2j1nK2Ksoa6oO5ojTR8VcjkrMTgVcjGa2izSJrRyVciz5gYdKzYulXosrwT1rem9TRHRxuqsAehryP4laMbS8/tGEfLJ1/DAr1BG3IFPbvS+INLXW9DaDOGUdevcf4VzY2nzxIrw5ony8imUmQ9ql3bwDUeGhdl64PNOLg9Bivla0eV2PGkraDT1pjdaeeaY3rXNIkgamVIwphGKyYELUyntUZOKiQEbVE1SMaYRmueRMtiB6harDrULDFYTM2V3qOpWFM21zMk//9P8Z6KdtNG01+xNHvWG0U7aaNprJoLENFOKkU2s2gsMPWkp200bTUNCG0U7bRtosKxEetJTipzRtNIVhtFO2mjaaVgG0UdKKVgGt1ptOIzRtNSwG0U7aaNppARt1ptPZTmk2mpYDaKdtNG00gG0UpGKSnYloa1NpzU2iwWCilAzS7TSENopSMUlABRRRSZSCilAzS7TSGNop200bTRYBtFO2mjaaLANopcEUlJpksD0qOpD0qOlZiCiiiizAKKKKLAFFFFFgsFFFFFh2CiiiiwgoooosAUUUUWAKKKKLAFMPWn03aaTQDaKdtNG01NgG0U7aab0osAUUUuCaLAJTD1qXaajYYNFgG09elMp69KLALTW606mt1osJjaa3WnU0jNIVhtFO2mjbQwsNop22jbU2Cw2inbaQjFFgsJRRRRYQUUUUWAKKKKACiiikAUUUUrDsFFFFFgsFIelLSHkUWEMop200bTRYY2inbTRtNRYobRTtpo2miwXG0U7aaNposQNop200bTRYBtFO2mjaaLANop200bTRYBtFO2mjaaLFjaKdtNG00WAcOlFFFTYkKKKKVhBRRRTsygoooosxhRRRVWJYUUUUWEFFFFUkAUUoGaXaadgG0U7aaNppgNop200bTTAbRTttG2gpAtOpAMUtAxy9adTV606gAopQM0u01ogFTrUtRoMGpKYDl606mr1p1aIBR1p9MHWn1QWHJ96pqgU4OalDg1tEtDqcvWm0oOK0KuTjpTl61EHFODc1rFlxZZHSimBgeKfVpmiYo60+o6eDmtYjuOHWp6hAPWpcg1ohkw61PVcHvU+Qa2iykTDrVgdarA96sBhmtYlFgfdqdWqsGGKlHSumCLiy0rVaRuBVBSatp0FdMXY0iy+jVejbpWcnSrkZxWyZpE1Ym4q2knas6NwBVlW5zXRTNYs3IJMCt/TpVUkSfdNcrC2BWtbShRzW/LzRZorNHhPjnR30TXJUAwkmMfkP8a5QjHFe6fE3Tjqeix6xFjMecg9eSBXhIyFyxr5DH03GbueJiKbU3oLSN0pofJ6U9geledI5yFutRt1qRhUbdayYiBqjbpUxXNRMpHFRILkLdabTmFNrnkKWxG9QP0qd6gfpWEzNkDU2lY03cK5mSf/1Pxrooor9lPoAop200bTWbAjbrUR61MQSaj2Gs2gGUU7aaNprNokbRRRQ0IYetJTiCTRtNQ0A2ijpRSJGHrSUp60lABRRRUsAooooAa3Wm04jNG01LAbRSkYpKQDWptPIzSbTQBG1NqRlNN2mgAWnUiqaftNS0SxjdKZUjKcU3aaLCG0U4KTS7DSKQi9adSbSOaWgYUUUUAFFFFACHpTKeeRSbTQSxp6VHUu003YaBDKKfsNJtNJgNopdppKQBRRRQUgoop200DG0U7aabQSwooooEFFFFABRRS7TQAlFO2mjaaTAbRTtpo2mpAbSbc0/aaUcCgCPbS4xUlMPWgBKjYZNSUUARbaXGKkppGaAG01utSbTTGU5pMBlFO2mjaakBtFO2mjaaAG0U7aaNpoAbRjNO2mlAxQDI9tIRipqawJ6UE2IaKfsNIUIoYWG0U7aaNpqQsNop200bTQFhtFO2mjaaChtFO2mkwRQAlFFFBAUUUUAFFFFQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQWFFFFABRS7TS7TUkjaKKKQgoooqwCiiigAooooAKKKKACiiiqAevSlpF6UtMAooooAKKKKACiiigAooooAcvWnU1etOoKQ5etOpq9adWiGOXrTqavWnUwHL1p1NXrTq0QCjrT6YOtPqikFOWm9aeBitYjJaKQHNLWiAUdakHWox1qQdatFxJV61NUK9al3CriULTlpm4UqsK3iWiwOlKOtMDDFODDNaGiJx0qYdagDDFTjg1cWMmHSph1qAHtUoYA1vBgWB0qwOgqqHHSrIYGuqEhomHarCGq689KlXOa2vc0iXkarqNwKzkq4nQVvBmqZfRqtxniqCcCraZxmumDsaxZqxNWhE/FZMbACrkbdfetKdToXB2NVrVdUsZNOk5BHT9a+Y9RtpbK/e2cY2mvqG0mEUgcfjXjfxG0o2upf2rHjyp+FHcFQM5ry80oXjznLio3XMcCFXbTD1pqI+4rkcUEjOK+Za1seXsyNqibrUp5qNlOamcbEMZUT9alPFRNycisJCK7UypWU1GRiueQmRPVeTtVh6rvWEyWV3qOpWFM2muZkn//V/GuinbTRtNfsrPoB1FFFZsBh60lO2mjaaTQ7ER60lP2GjYahomzI9tG2penFFJisQHg0lSFCTmmEYqGgsRnrSU4gk0bTUNE2Ij1pKeVOaTaaQrDaKXaaXaaVgG0U7aaNposA2inbTRtNS4gRt1ptPZTmk2mjlAbRTtpo2mlYCNqbT3GKZRYBy06mrTqLEtCN0plPIzSbTRYLAvWnU0DFOqWhoRulMp7dKZRYYUUUUmAUUUUgCijrTtpp2JaG0U7aaNposFhp6VHUpU4pm01LCw09KjqUqcUzaaQWG0U7aaNposNCDrT6btNOosMKjqSm7TRYTG0U7aaNposKw2inbTRtNArDakHSm7TTqACiiikwCiiilYAoooosAUw9afTSCTRYBtFO2mm9KLAFFFFFgCmt1p1NIzSaAbRTtpo2mpsA2inbTRtNFgG0U7aaNppANop200hGKAEooop2AKRulLSN0pNAMoooqbAFFFFFgCiiiiwBSHpS0h5FFgGUU7aaTBFFibCUUUUWCwUUUVNhBRRRRYAoooosAUUUUWAKKKKLAFFFFFgCiiikXcKKKKAJB0ooHSipsSMPWkpT1pKLCCiiiqAKKKKACiiigAooooAKKKKoB69KWkXpS0wCiiiiwBRSgZpdposA2inbTRtNFh2G0U7aaNpoCwL1p1IqnNP2mizGgXrTqRVOaftNaIYL1p1NAxTqdgHL1p1NXrTq0QCjrT6YOtPqikKOtPpg4NOyDWkRjh1p9MHWn1qgFHWpB1pgU08dapMuJKvWnUxetOBzVxZQtOWk2mnAYreLRaJR0pR1pm4U8cGrbLTJh0qzVYHtVjcKuLKuTDrT6jDDNP3CtUBMOtTK3NVwwzUg65roi2NF5G4qZW5qmretTKwzXRFlo0EbirSNwKoIc1aQ9BXTBlo0EarqNwKzYzVtX4xWyZrFmkjVbjas1GFXoz0Nbqxcn2NmFvWs7xdpQ1Tw67gZeHkfiRVuFuK2bF45S1pNysnH5UVY88HEdRc1OyPk3cY5Ap6g809jk8Vra/p7abrM0EgA6EY96xVBAw1fG14OFRpnhVE1Kw6mN1p9MbrXNN3egmQtTKlKk1GRg4NYyJIWqJqlaomrnkJkL1A/Sp3qB+RWEyWQNTaewplczIP/1vxvooor9maPowoooqGgCil2ml2mk0A2iiioaAYetJTiCTRtNZ2IG1C1Sk44qMjNFgGUUhOOKNwqWiRp60lOxnmjaahoQ2inbTRtNIkbRTtpo2mgBtFKRikoAa3Wm04jNG00ANop200bTUsCNhmmbamIxSUARYxS08jNJtNADaKUjFJQAUUUVLQCN0plPIzSbTRYBtFO2mjaaloBtFO2mjaaVgEHWn00Ag06mgCiiimAHpUdSGm7TUSQDT0qOpSpxTNpqbANop200bTVIBtFO2mjaaAG0U7aaNpoAbRS7TSUAFKetJSnrSYmJRRRSJCiiigAooooAKKKKACiiigAph60+mHrQAlFFFABRRSgZpMBKKdtNIRipASiiigAooooAKa1OpCM0AMop200bTQA2kbpT9pprKcUAR0U7aaNpqAG0U7aaQgigBKKKOtABRTtpo2mgBtIelP2mmlTigCOlFLtNG00ANop200m01JAlFFFABRRRQAUUUUAFFFFABRRRQAUUUVABRRRQBIOlFICMUZFADT1pKKKACiiigAooooAKKUAml2mgBtFO2mjaaAG0U7aaNpqkAq9KWkAxS0wCiiiqQDlp1NWnUAFFFFBSCiiigY5etOpq9adVIBy9adTV606mAUUUVSAcvWnU1etOq0Ao60+mDrT6CkFKOtJSjrWkRkq08daYtOq0BKKB1pARRVoaJl60L1poYCgMM1SLRYHSimhhS5FaxZaFqSosipMg1oMmHWp6rg96n3Ct4lRJh1p9Rhhmn5FbIsmHWpx0quGGanByK3Q0SjtUy9ahHapl61rBlJl2PpVpOtVIyKtIwreLLTLiVZXtVVCKsqe9bwZomW061ejOAKoIe9W09RW6ZSNSJq1IXKbZB2zWNEwA5rTtZF+4/8AF0reLNIdTzb4naQY51v4h94cn6AV5OmSvNfT/iLTX1nQZEQAyIp6+9fMki+VI0TcFCQa+azGlabmebioWdxtNbrQzBV3HpSfe5FeNayZxNdRKifrUp4qJzk1lMRXaomqVqiauaQmQvULVM9QtWEyGQvUdSPUdczMz//X/G+in7GpNjV+0tH0lhtFLg0uDUMLDqKKWkxWIz1pKUg0YNQwEooorNokhb7xptOYHNJg0gsQsvNJtqfBowaTIIhxRTiDmkwahgJRSmkqLEBRRRRYBrdabTm602iwBRRRRYAoooqWgGtTaeRmm4NKwCUUuDRg0WAa3SmU9gcU3BosAlFLg0YNACUUuDRg0AJRS4NGDUtAJRS4NJRYAooopAFFFFABRRRSYAelR1IaZg0rAJRS4NJRYAoopcGiwCUUuDRg0AJUdS4NR4NIBKU9aMGl2mkxMbRTtpo2mkKw2inbTTM44oELRSZFLRYAoopcGiwCUU7aab0oCwUw9afTSDmgBtFLg0YNACU9elNwacBikwFprdadTW60rMBtFFFFgCiiiiwBRRRRYAoooosAUjdKWkbpSaAZRRRUAFIelLSHpQAylHWjBpQDmmA6iiigApD0paQ9KAGUopKKQBQelLSHpUkkdFO2mk2mgBKKXBowaBCUUUUAFFFFABRRRQAUUUVIBRRRSAKKKKACiiigAooooAKKKKAHjpS0g6UtAwooooAKKKKoAooopgFFLjNGDVILCrTqQDFLQFgooooGgooooGOXrTqYDinZFUgHr1p1RhhmnhgelMBaKKKpAOXrTqYDg07Iq0A4dafUakZqSgpBSjrSU4A5rSIyRadTQadVoBR1p9MHWnZFWhoWlHWm5FKKZaJl606mKwzTsitIlIWpR1qHIqUEZrZFE46VLUIIxUuRW0Sokw60+owRmn5FbJlkw61OpquGGakHrW6Y0Wg3rUqtVVTUq9a0ixmgh9Ksq1UUNWUzxW0WUi+h44q2jcVnoatIeK6Ke5pE0UarkbcVmpwKuoeK3RojRRquwMOv92sxDVyBgH56Gtolx3Oj02Xzd1u3R+K+c/GuknSNdeID5Wwfz5r3+1JjfetcR8VtNa406HVYVztJ3n2ArgzKlzUuaKMcZTvDmR4cP3mV9Oal27RioUYbSy85GPxqXPAz6V8vU2PIurEbVE3WpW5qJhg1zTJIGqJqlaomrmkJkL1C1TPULVhMhkL1HUjGo65mZn//0Px3opcGjBr9raPpSKilwaMGoaASiiipaAKKKKhoBh60lKetJSaJGHrSU4g5pMGs2gEooopNEDD1pKcQc0mDWbQDG602nlTmk2tSsSxtFLtNGDQIY3Wm08qc0m1vSgljaKXaaMGgBKKXBowalgJRS4xSUgCiiigBG6UynkZpuDQAlFLjFJSYBRRRSAKKKKAEPSmU89Kbg0AJRS4NGDUsBKKXBowaQCUUuDSUAFFFFAAelR1IaZg0AA60+mAGn0AFFFFJgFR1JTMGkAlFLg0YNACUUuDSUAFRMvNS0uDSEyDbTwDipMGnYFBJDg08U/App60mNCUw9afTD1pFCUUUUCYUUUUEhRRRTQ0FNbrTqaRmmUNpe1GDRg4oYmJRS4NGDUkiUUuDRjFACUUUUAFI3SlpCM0mAyilwaMGpASilwaMGgBKKXBowaAEooooAKQ9KWkPSgBlFFFABRS4NGDUAJRRRQAUUuDRg0EEVFLg0YNACUUuDRg1ICUUUUAFFFFABRRRQAUUUUAFFFFABRRRUgFFFFIB46UtNBGKXIqixaKKKYBRRRQAUUUUAPXpS0i9KWqQBRRRQAUUUUAFFFFABRRRVIAp60zGaevFMCWikzmloAKKKK0QDk+9U1Qr96pcirRSHDrT6jUjNSVaGKOtPpg60+mNBRRRVxGKOtPpg60+qAUdafTB1p9axNIhUo61FUo61oiiYdKlqIHtUmRWsWVEmHWn1GCM1JWhoiUdanHSoB1qYEVvEomHWpV61CD3qZTzWyGi0lWlPFVEYVMDXRAZaVquRtwKz16VaRhgCuimNGkjVaRuBWfGeKtIwrdM0iaMbelW425FUEOatxg1pGVjWLsb1u3FXr3TF1zQ7vT267Pl+pNZlvxXQ6XM8NwH7d6uUOam0aS1g0fIIgMF5JA/HlsR+RxTM5J+tdj8QdJk0rX28tcLKu/PuxNcYCMfzr4vFQ5JuJ89KPK3EdUT9akyKjfk5rimSV2qJqmYVEVNc0hMgeoH6VO/Gagc5Fc8iGQNTac1NrnZmf/R/Huiiiv29o+mI6KXBowazaAjPWkpT1pKloQUUuDRg1DAjPWkpxVielG1vSk0SNoo6UVDQDD1pKcQc0mDUtEiUUuDRg1DQhKKXBowamxLGN1ptOYHNJg0CEoo6UVLE0NbrTacetJg0hWEopcGjBqWFhjU2nsDTcGgBKKXBowaQCUUHjrRkUAI3SmU4mm0mAUUUUgCiiigAooooAKKKXBoASilwaSgAPSo6kNMwaAEopcGjBoASilwaMGpYCUUuDRg0gEopcGkoAKKKXBoASilwaMGgBKYQakwadgUAQ4NPFPwKZSYBRRRSAKYetPph60mAlMPWn00g5qQG0UuDRg0CYlFLg0YNBIlFLg0YNNDQlFLg0YNMoSl7UYNGKGJiUUuKMVJIlNan4prA0AMopcGjBoASilwaMGkAlFLg0YNKwCUUuDRgiiwCUh6UtIelIBlFLg0YNACUh6U7BpCDigCOlHWjBpQMGgB1B6UZFJxUgMpR1owaMGgB9FFFIkjopcGjBoASilwRSZFSIjooooAKKKKACiiigAooooAKKKKACiiigAopcE0YNACUUuDRg0Fjh0paQdKWgAooooAKKKKAHr0paRelLVIAooooAKKKKACiiigAooxmlwapAKvWnU0DFOpgOXrTqavWnUAFFFFaIBR1p9MHWn1aGhyfeqaoVB3VNVooUdafTB1p9MaCiiiriMUdafTB1p9UMUdafTQpzT8GtYlxEqSmYNSYNWUSDrT6YOtPrSJUSUdanqADvU+RWqNEyUdakHWoweakFbxKuTL0qUdqhU1MO1bIaJ16VZXoKqr0qypHArogxlhelTL2qBeamUit4saL0dWU61VjIqyhANbJmiNCOr8ZxWfERVtTzmtYass2YW4rStpysmKyISMVpR7Qu/PXgV0RetjSL1scd8VNM+06QmrR8sp2n6AE18/p90E96+rtTt21LQ7ixcZO1mHucYr5ZuIWtrqS2kGGViMfQ18znFHlnzJaHlY6HLUuRUjdKX2pG6V4MzjIm602nN1ptcshMqy9KqHpVuXpVQ9KwkQyJqbTmptc7Mz/9L8e6KXBowa/cXE+oEopcGjBrNoCDbRtqbb7UY9qlokjop200bWqGhDaKKKgCFvvGm05gc0mDUgJRRRUEhRRRQAUUUUEMa3Wm049aTBrNgMbrTacwOaTBqQEopcGjBoASilwaMGkyWMam05qbSEFFFFADHGRTNtTUYFAEBGKSpXHHFR4NSyWJRRRSAKKKXBoASilwaMGgAHWn0wA5p9AAelR1IelMwaAEoowaKTAKKKKQBRRRQNBRRRQMKjqSmYNSxMSpKZg0+kIKKKKACiiigAph60+mEHNACUUuDSUAFMPWn0wg5pMBKKXBpKkAooowaACilwaMGgBKKXBowaAEopcGkoAKa1OprUANopcGkoAKKKKGJhRS4NJUkhRRRQAUUUUAFIelLSHpQAyiiigAooopAFIelLSHpUgMoPSlwaAKAI8GgA5qbaKTaKAG0UUUAFFFFQAUUUUAIelQnrUxIxUJBzQQJRS4NGDQAlFLg0YNSAlFLg0YNACUUUUAFFGDS4NACUUuDRg0AOHSlpB0paACiiigsKKKKACiiiqJYUUUUCHr0paRelLQWFFFFABRRRQAUUUUAOXrTqYOtPyKpAFFFFMBy9adTV606gAooorRAFOWm05aYE460+mDrT60iUhR1p9MHWn1QwoopcGmhoB1qQdajAOakAOatFolXrTqYvWn1ohhUlR1JkVoikFSjrUWDUo61pEZMOlOHWmjpTh1rRDRMOlSjpUQ6VIOlbRLRKO1WB0quO1TgitolIlHapl61CO1SqRmt4lFtKlHWoUIqYda2gVEux1OOtQRkVOOtdMWaJmhD0q7GeKoxEYqyrc1qi0zViarqSZKr6Gs2I8VdjI655rRFxN63IYsh/iGK+bfHumvpuvswHDjd+ZNfRETFVDL1rz74o6W1xp6anGmduASB0wCa4szhzUbGGNjzUzwp2wAR3px5FNOGRQfajoCD618fUVtDyGNbrTaViM03IrjktRPaxWl6VUPSrUvIqswOKxkZsham05qbXOzM//9P8f6KXBowa/dT6gSilwaMGs2gEopcGjBqWiRKKXBowazaAgb7xptOb7xptZNAMPWkpT1pKgQw9aSlIOaMGpJEopcGjBpAJRS4NGDQS0JRRRWbCw1utNpx60mDRYVhKKXBowaLAJRRg0uDSsSyNxnFM2mpsetGBQBARikqRx6UzB9KloBKKXBowaLANbpTKewNNwaloljW6UynsDim4NIQq9adTVBzT8GkAlFLg0YNACUUuDRg0AJRRg0UwA9KjqQ9KjqWAUUUUgCiiigaCiiigYUUUuDSYmJRS4NJUiCiijBoAKKXBpKACiiigAph60+mEHNACUUuDSUmAUw9afTCDmkAlPHSm4NOHSgBaKKKACilwaSgAprdadTT1oAbRS4NJQAU1qdTWpANpy0mDSrQxMdSN0paQ9KkkZRS4NGDQAlFLg0lABSHpS0h6UAMopcGjBoASilwaMGkAlFLg0YNSAlFLg0mDQAUHpRQe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qbbRtrNoCsetJUxWjbUNEENFKetJUMBh60lKetJUNEjD1pKU9aSs2hBRRRUWAKKKKVgIn+9TKnIzSbahgQ0U5hg02gAoooqWgHr0paRelLRYCOTtUdTkZpNtFiWQ0U9ximVDQDWptOam1LQWCiiiiwWCiiikSwooooEIelMqUDNLtpNEsiHWn04jFNpWEFFFFSwCiiikAh6GocGp6TAoAhwaSp8Ck20AQ0VNto20AQjrUlO202gAqOpKjoAKjqSo6ACiiikwCiiilYAqQdKjqQdKloAqFgc1NSYFSBDg0lT4FRNw1AmNooooEFFFSKMigCOipttRsMGgBtFFFDAKKKKkAooooAKa1OprUANooopAFFFFKwBSN0paRulFgGUUUUgCiiigApD0paQ9KgBlFFFABSHpS0h6UAMoopRQISg9KKD0oJI6KKKACiiipAKKKKAJKKKKACiiigCM9aKU9aSoAKKKKACiiigAooooAKKKKACiiigBh60lKetJQAUUUUAFFSKMinbaAGL0paUjFJQAUUUUAFFFFADlp1NWnVSAKKKKYDl606mr1p1UgCiiigBy9adTV606qQBRRRTAUdafTB1p9UikKOtPpg60+mMKUdaSlHWrjsNEq9adTV606qGKOtPpg60+qRSAdakpg60+qQwoooq0NBUlR1JWkSiUdanqAdanrRDQUo60lKOtUhky9KcOtNXpTh1rSJSJl6U4daavSnDrXTEZMvSnAU1elTKO9bIaJUFXF+7UKKMVOOlaxNIk61Zj6Cqy1Zj6Cto7llxOtWUqsnWrKVvEqJdj61YXqKrx9asr94VtEs0YK27SQKCn97j86xbftWjHnKt6MDV8vPFovdHzh4+099O8Ryg/8tST+ZNcS67Plr3T4xWKf6Pqij+ED9Sa8KL+YN3rX59mkOSs4ngV1ao0RN1qJ+lSt1qJ+leVMxkQNTac1NrnZzs//9D8l6KKK/oM+tCiiioAjoooqGiSA9TSVNto21m0BWPWkqcrzSbahogrHrSVOV5pNtS1cCuRzSYNTlRmkwKTWgEY6UtKeDSVk0BGwOeKbhqmIFJgUrEsjGe9LSkYNJRYQUUUVLQDG60lObrTaVgGtTac1NqWgGtTac1NpWAKKKKloBrdKbUoGaXbRYCNetOpSMUlSwCiiigAooopWIluFFFFFiQooopMAooopAFG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]]
    local function getSoundMainBackground()
        local decode
        pcall(function()
            if crypt and crypt.base64 and crypt.base64.decode then
                decode = crypt.base64.decode
            elseif base64decode then
                decode = base64decode
            end
        end)
        local makeAsset
        pcall(function()
            makeAsset = getcustomasset or getsynasset
        end)
        if not decode or not makeAsset or not writefile then return nil end
        local ok, asset = pcall(function()
            local bytes = decode(SOUND_MAIN_BG_B64)
            writefile("SoundHub_MainBG.jpg", bytes)
            return makeAsset("SoundHub_MainBG.jpg")
        end)
        if ok then return asset end
        return nil
    end

    __HH.bgImage = Instance.new("ImageLabel", __HH.mainFrame)
    -- FOCUS top banner: fill the full header area instead of leaving side gaps.
    __HH.bgImage.Size = UDim2.new(1, -12, 0, 112)
    __HH.bgImage.Position = UDim2.new(0, 6, 0, 6)
    __HH.bgImage.BackgroundTransparency = 1
    __HH.bgImage.Image = "rbxassetid://103229327971654"
    __HH.bgImage.ScaleType = Enum.ScaleType.Stretch; __HH.bgImage.ZIndex = 2
    __HH.bgImage.ImageTransparency = 0
    Instance.new("UICorner", __HH.bgImage).CornerRadius = UDim.new(0, 14) -- ClipsDescendants ignores rounded corners, so round the banner itself

    -- Main background replaced with the FOCUS CONFUSER asset (old download override removed)

    local bgOverlay = Instance.new("Frame", __HH.mainFrame)
    bgOverlay.Size = UDim2.new(1, 0, 1, 0); bgOverlay.BackgroundColor3 = DARK
    bgOverlay.BackgroundTransparency = 1
    bgOverlay.BorderSizePixel = 0; bgOverlay.ZIndex = 2
    Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0, 24)

    local dragging, dragInput2, dragStart2, startPos2
    __HH.mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart2 = input.Position
            startPos2 = __HH.mainFrame.Position
            dragInput2 = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragInput2 = nil
                end
            end)
        end
    end)
    __HH.mainFrame.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart2
            if delta.Magnitude > 5 then
                __HH.mainFrame.Position = UDim2.new(
                    startPos2.X.Scale,
                    startPos2.X.Offset + delta.X,
                    startPos2.Y.Scale,
                    startPos2.Y.Offset + delta.Y
                )
            end
        end
    end)

    local Header = Instance.new("Frame", __HH.mainFrame)
    Header.Name = "Header"; Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundTransparency = 1; Header.ZIndex = 3

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(0, 220, 0, 38); Title.Position = UDim2.new(0, 22, 0, 10)
    Title.BackgroundTransparency = 1; Title.Text = ""; Title.Visible = false
    Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 26; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.ZIndex = 4
    local titleGrad = Instance.new("UIGradient", Title)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(235, 218, 250)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(122, 143, 192))
    })
    titleGrad.Rotation = 90

    local closeBtn = Instance.new("TextButton", Header)
    closeBtn.Size = UDim2.new(0, 40, 0, 24); closeBtn.Position = UDim2.new(1, -54, 0, 14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(6, 15, 37); closeBtn.BackgroundTransparency = 0.25
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"; closeBtn.TextColor3 = Color3.fromRGB(164, 182, 224)
    closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 18; closeBtn.ZIndex = 6
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    local closeBtnStroke = Instance.new("UIStroke", closeBtn)
    closeBtnStroke.Color = Color3.fromRGB(44, 89, 194); closeBtnStroke.Thickness = 1; closeBtnStroke.Transparency = 0.3

    -- Mini open/hide toggle with custom BG (base64 + URL fallback)
    local SOUND_MINI_TOGGLE_B64 = [[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]]
    local function getSoundMiniToggleBg()
        local decode
        pcall(function()
            if crypt and crypt.base64 and crypt.base64.decode then
                decode = crypt.base64.decode
            elseif base64decode then
                decode = base64decode
            end
        end)
        local makeAsset
        pcall(function()
            makeAsset = getcustomasset or getsynasset
        end)
        if not decode or not makeAsset or not writefile then return nil end
        local ok, asset = pcall(function()
            local bytes = decode(SOUND_MINI_TOGGLE_B64)
            writefile("SoundHub_MiniToggleBG.png", bytes)
            return makeAsset("SoundHub_MiniToggleBG.png")
        end)
        if ok and asset then return asset end
        return nil
    end

    local miniToggleBtn = Instance.new("TextButton", gui)
    miniToggleBtn.Name = "MiniToggle"
    miniToggleBtn.Size = UDim2.new(0, 270, 0, 78)
    miniToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
    miniToggleBtn.Position = UDim2.new(0, 10, 0.46, 0)
    miniToggleBtn.BackgroundColor3 = Color3.fromRGB(8, 16, 42)
    miniToggleBtn.BackgroundTransparency = 1
    miniToggleBtn.Text = ""
    miniToggleBtn.TextColor3 = WHITE
    miniToggleBtn.Font = Enum.Font.GothamBlack
    miniToggleBtn.TextSize = 17
    miniToggleBtn.BorderSizePixel = 0
    miniToggleBtn.ZIndex = 100
    miniToggleBtn.Visible = false
    miniToggleBtn.ClipsDescendants = true
    Instance.new("UICorner", miniToggleBtn).CornerRadius = UDim.new(0, 26)

    local miniBg = Instance.new("ImageLabel", miniToggleBtn)
    miniBg.Name = "MiniBg"
    miniBg.Size = UDim2.new(1, -20, 1, -10)
    miniBg.Position = UDim2.new(0, 10, 0, 5)
    miniBg.BackgroundTransparency = 1
    miniBg.Image = ""
    miniBg.ScaleType = Enum.ScaleType.Crop
    miniBg.ZIndex = 99

    local miniStroke = Instance.new("UIStroke", miniToggleBtn)
    miniStroke.Color = Color3.fromRGB(40, 110, 230); miniStroke.Thickness = 2.5

    -- Pill image replaced with the asset from FOCUS CONFUSER
    miniBg.Image = "rbxassetid://103229327971654"
    miniBg.ScaleType = Enum.ScaleType.Fit

    -- ===== Minimized tab layout:  [ IMG ] MENU
    --                                      View GUI
    miniToggleBtn.Size = UDim2.new(0, 250, 0, 84)
    miniToggleBtn.BackgroundColor3 = Color3.fromRGB(6, 10, 24)
    miniToggleBtn.BackgroundTransparency = 0.04
    miniToggleBtn:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 22)

    local miniBox = Instance.new("Frame", miniToggleBtn)
    miniBox.Name = "MiniBox"
    miniBox.Size = UDim2.new(1, -14, 1, -14)
    miniBox.Position = UDim2.new(0, 7, 0, 7)
    miniBox.BackgroundColor3 = Color3.fromRGB(14, 20, 44)
    miniBox.BackgroundTransparency = 0.2
    miniBox.BorderSizePixel = 0
    miniBox.Active = false
    miniBox.ZIndex = 98
    Instance.new("UICorner", miniBox).CornerRadius = UDim.new(0, 16)
    local miniBoxStroke = Instance.new("UIStroke", miniBox)
    miniBoxStroke.Color = Color3.fromRGB(40, 110, 230); miniBoxStroke.Thickness = 1; miniBoxStroke.Transparency = 0.45

    local miniImgHolder = Instance.new("Frame", miniBox)
    miniImgHolder.Name = "ImgHolder"
    miniImgHolder.Size = UDim2.new(0, 83, 1, -12)       -- about 1/3 of the tab width
    miniImgHolder.Position = UDim2.new(0, 6, 0, 6)
    miniImgHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniImgHolder.BorderSizePixel = 0
    miniImgHolder.Active = false
    miniImgHolder.ClipsDescendants = true
    miniImgHolder.ZIndex = 100
    Instance.new("UICorner", miniImgHolder).CornerRadius = UDim.new(0, 12)
    miniBg.Parent = miniImgHolder
    miniBg.Size = UDim2.new(1, 0, 1, 0); miniBg.Position = UDim2.new(0, 0, 0, 0)
    miniBg.ScaleType = Enum.ScaleType.Fit
    miniBg.ZIndex = 101

    local miniMenuLbl = Instance.new("TextLabel", miniBox)
    miniMenuLbl.Name = "MenuLabel"
    miniMenuLbl.BackgroundTransparency = 1
    miniMenuLbl.Position = UDim2.new(0, 100, 0, 6)
    miniMenuLbl.Size = UDim2.new(1, -106, 0, 34)
    miniMenuLbl.Text = "MENU"
    miniMenuLbl.Font = Enum.Font.GothamBold
    miniMenuLbl.TextSize = 26
    miniMenuLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniMenuLbl.TextXAlignment = Enum.TextXAlignment.Left
    miniMenuLbl.ZIndex = 101

    local miniViewLbl = Instance.new("TextLabel", miniBox)
    miniViewLbl.Name = "ViewLabel"
    miniViewLbl.BackgroundTransparency = 1
    miniViewLbl.Position = UDim2.new(0, 101, 0, 40)
    miniViewLbl.Size = UDim2.new(1, -106, 0, 22)
    miniViewLbl.Text = "View GUI"
    miniViewLbl.Font = Enum.Font.Gotham
    miniViewLbl.TextSize = 15
    miniViewLbl.TextColor3 = Color3.fromRGB(150, 156, 178)
    miniViewLbl.TextXAlignment = Enum.TextXAlignment.Left
    miniViewLbl.ZIndex = 101

    miniToggleBtn.MouseButton1Click:Connect(function()
        __HH.mainFrame.Visible = true
        miniToggleBtn.Visible = false
    end)

    local miniDrag, miniDragStart, miniStartPos
    miniToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniDrag = true
            miniDragStart = input.Position
            miniStartPos = miniToggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then miniDrag = false end
            end)
        end
    end)
    __HH.UIS.InputChanged:Connect(function(input)
        if miniDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - miniDragStart
            miniToggleBtn.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        __HH.mainFrame.Visible = false
        miniToggleBtn.Visible = true
    end)

    local Sidebar = Instance.new("Frame", __HH.mainFrame)
    Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(1, -32, 0, 42)
    Sidebar.Position = UDim2.new(0, 16, 0, 122); Sidebar.BackgroundTransparency = 1; Sidebar.ZIndex = 4

    -- Tab bar background box
    local TabBox = Instance.new("Frame", Sidebar)
    TabBox.Name = "TabBox"
    TabBox.Size = UDim2.new(1, 0, 1, 0)
    TabBox.Position = UDim2.new(0, 0, 0, 0)
    TabBox.BackgroundColor3 = Color3.fromRGB(4, 9, 21)
    TabBox.BackgroundTransparency = 0.1
    TabBox.BorderSizePixel = 0
    TabBox.ZIndex = 5
    Instance.new("UICorner", TabBox).CornerRadius = UDim.new(0, 10)
    local tabBoxStroke = Instance.new("UIStroke", TabBox)
    tabBoxStroke.Color = Color3.fromRGB(33, 73, 167); tabBoxStroke.Thickness = 1.2; tabBoxStroke.Transparency = 0.2

    local SidebarLine = Instance.new("Frame", Sidebar)
    SidebarLine.Size = UDim2.new(1, 0, 0, 1); SidebarLine.Position = UDim2.new(0, 0, 1, 2)
    SidebarLine.BackgroundColor3 = Color3.fromRGB(34, 68, 145); SidebarLine.BackgroundTransparency = 0.52
    SidebarLine.BorderSizePixel = 0; SidebarLine.ZIndex = 3

    local TabContainer = Instance.new("Frame", TabBox)
    TabContainer.Size = UDim2.new(1, -8, 1, -6); TabContainer.Position = UDim2.new(0, 4, 0, 3)
    TabContainer.BackgroundTransparency = 1; TabContainer.ZIndex = 10
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal; TabListLayout.Padding = UDim.new(0, 3); TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center


    local ContentContainer = Instance.new("Frame", __HH.mainFrame)
    ContentContainer.Size = UDim2.new(1, -32, 1, -186); ContentContainer.Position = UDim2.new(0, 16, 0, 170)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(3, 7, 18)
    ContentContainer.BackgroundTransparency = 0.55
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ZIndex = 3
    Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 20)

    local innerStroke = Instance.new("UIStroke", ContentContainer)
    innerStroke.Color = Color3.fromRGB(43, 94, 213)
    innerStroke.Thickness = 1.3
    innerStroke.Transparency = 0.18

    local currentTab = nil
    local TabRefs = {contents = {}, btns = {}, underlines = {}, active = "Speed"}
    local TabList = {"Speed","Combat","Mechns","Visual","Extra","Mobile"}

    local tabDisplay = {Speed="Speed", Combat="Combat", Mechns="Keybind", Visual="Visual", Extra="Settings", Mobile="Mobile"}

    local function styleTab(btn, isActive)
        if isActive then
            btn.BackgroundColor3 = Color3.fromRGB(10, 31, 79)
            btn.BackgroundTransparency = 0.05
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 11
            btn.Font = Enum.Font.GothamBold
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then st.Color = Color3.fromRGB(54, 101, 211); st.Thickness = 1.4; st.Transparency = 0 end
        else
            btn.BackgroundColor3 = Color3.fromRGB(5, 13, 32)
            btn.BackgroundTransparency = 0.3
            btn.TextColor3 = Color3.fromRGB(73, 110, 194)
            btn.TextSize = 9
            btn.Font = Enum.Font.GothamSemibold
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then st.Color = Color3.fromRGB(25, 60, 141); st.Thickness = 1; st.Transparency = 0.4 end
        end
    end

    for i, name in ipairs(TabList) do
        local btn = Instance.new("TextButton", TabContainer)
        btn.Size = UDim2.new(1/6, -4, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(5, 13, 32)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Text = tabDisplay[name] or name
        btn.TextColor3 = Color3.fromRGB(73, 110, 194)
        btn.TextTransparency = 0
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 9
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.LayoutOrder = i
        btn.ZIndex = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
        local st = Instance.new("UIStroke", btn)
        st.Color = Color3.fromRGB(25, 60, 141); st.Thickness = 1; st.Transparency = 0.4

        if i == 1 then styleTab(btn, true) end

        TabRefs.btns[name] = btn

        local page = Instance.new("ScrollingFrame", ContentContainer)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = BLUE_GLOW
        page.Visible = (i == 1)
        page.ZIndex = 4
        local pageLayout = Instance.new("UIListLayout", page)
        pageLayout.Padding = UDim.new(0, 6)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        local pagePad = Instance.new("UIPadding", page)
        pagePad.PaddingLeft = UDim.new(0, 16)
        pagePad.PaddingRight = UDim.new(0, 14)
        pagePad.PaddingTop = UDim.new(0, 10)
        pagePad.PaddingBottom = UDim.new(0, 10)

        TabRefs.contents[name] = page

        if i == 1 then
            currentTab = {Btn = btn, Pg = page}
        end

        btn.MouseButton1Click:Connect(function()
            if currentTab then
                __HH.setIceSectionActive(currentTab.Btn, false)
                styleTab(currentTab.Btn, false)
                currentTab.Pg.Visible = false
            end
            styleTab(btn, true)
            page.Visible = true
            currentTab = {Btn = btn, Pg = page}
            TabRefs.active = name
            __HH.setIceSectionActive(btn, true)
        end)
    end

    local function styleCapsuleBtn(btn, isAccent)
        btn.BackgroundColor3 = isAccent and Color3.fromRGB(6, 22, 60) or Color3.fromRGB(5, 13, 33)
        btn.BackgroundTransparency = 0.08
        btn.BorderSizePixel = 0
        btn.TextColor3 = isAccent and WHITE or CYAN_SECT
        btn.Font = Enum.Font.GothamSemibold
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", btn)
        st.Color = isAccent and BLUE_GLOW or Color3.fromRGB(35, 80, 185)
        st.Thickness = 1.3
        st.Transparency = 0.14
        local grad = Instance.new("UIGradient", btn)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 46, 121)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(6, 23, 63)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 39, 104))
        })
        grad.Rotation = 90
        return st
    end

    local function mkSect(parent, txt)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(ROW_W, 0, 0, 20); f.BackgroundTransparency = 1
        f.LayoutOrder = #parent:GetChildren() + 1
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
        l.Text = txt:upper(); l.TextColor3 = CYAN_SECT
        l.Font = Enum.Font.GothamBold; l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, 0, 0, 1); line.Position = UDim2.new(0, 0, 1, -1)
        line.BackgroundColor3 = Color3.fromRGB(33, 60, 125); line.BackgroundTransparency = 0.72; line.BorderSizePixel = 0
    end

    local function mkRow(parent)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(ROW_W, 0, 0, 34); f.BackgroundTransparency = 1
        f.LayoutOrder = #parent:GetChildren() + 1
        local rowLine = Instance.new("Frame", f)
        rowLine.Size = UDim2.new(1, 0, 0, 1); rowLine.Position = UDim2.new(0, 0, 1, -1)
        rowLine.BackgroundColor3 = Color3.fromRGB(33, 59, 120); rowLine.BackgroundTransparency = 0.80
        rowLine.BorderSizePixel = 0; rowLine.ZIndex = 3
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.62, 0, 1, 0); l.Position = UDim2.new(0, 0, 0, 0)
        l.BackgroundTransparency = 1; l.Text = txt
        l.TextColor3 = WHITE; l.Font = Enum.Font.GothamSemibold
        l.TextSize = 15; l.TextXAlignment = Enum.TextXAlignment.Left
        l.ZIndex = 4
    end

    local function mkToggle(parent, txt, cb, initVal)
        local row = mkRow(parent)
        mkLabel(row, txt)
        local chk = Instance.new("TextButton", row)
        chk.Size = UDim2.new(0, 48, 0, 24); chk.Position = UDim2.new(1, -50, 0.5, -12)
        chk.BackgroundColor3 = initVal and PILL_ON or CHECK_OFF
        chk.BackgroundTransparency = 0.08
        chk.BorderSizePixel = 0; chk.Text = ""; chk.AutoButtonColor = false; chk.ZIndex = 5
        Instance.new("UICorner", chk).CornerRadius = UDim.new(1, 0)
        local chkStroke = Instance.new("UIStroke", chk)
        chkStroke.Color = BLUE_GLOW; chkStroke.Thickness = 1.3; chkStroke.Transparency = 0.18

        local knob = Instance.new("Frame", chk)
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = initVal and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(245, 250, 255)
        knob.BorderSizePixel = 0; knob.ZIndex = 6
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local state = initVal == true
        local function sv(s)
            state = s == true
            TS:Create(chk, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
                BackgroundColor3 = state and PILL_ON or CHECK_OFF
            }):Play()
            TS:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
                Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            }):Play()
            TS:Create(chkStroke, TweenInfo.new(0.16), {
                Color = state and Color3.fromRGB(95, 134, 224) or BLUE_GLOW
            }):Play()
        end
        sv(state)
        chk.MouseButton1Click:Connect(function()
            if __HH._anyKeyListening then return end
            state = not state; sv(state); cb(state)
        end)
        return sv
    end

    local function mkBoxRow(parent, txt, default, cb)
        local row = mkRow(parent)
        mkLabel(row, txt)
        local tb = Instance.new("TextBox", row)
        tb.Size = UDim2.new(0, 74, 0, 24); tb.Position = UDim2.new(1, -76, 0.5, -12)
        tb.BackgroundColor3 = INP_BG; tb.BackgroundTransparency = 0.15
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE; tb.Font = Enum.Font.GothamSemibold
        tb.TextSize = 14; tb.ClearTextOnFocus = false; tb.ZIndex = 5
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 7)
        local bs = Instance.new("UIStroke", tb); bs.Color = DIM_LINE; bs.Thickness = 1.2; bs.Transparency = 0.25
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color=BLUE_GLOW, Transparency=0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color=DIM_LINE, Transparency=0.25}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        return tb
    end

    local function mkKB(parent, kbEntry, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 44, 0, 20); btn.Position = UDim2.new(1, -108, 0.5, -10)
        btn.BackgroundColor3 = INP_BG; btn.BackgroundTransparency = 0.12; btn.BorderSizePixel = 0
        local function getLabel()
            return (kbEntry.gp and __HH.getKeyDisplayName(kbEntry.gp, true)) or (kbEntry.kb and kbEntry.kb.Name) or "None"
        end
        btn.Text = getLabel(); btn.TextColor3 = CYAN_SECT
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn); bs.Color = DIM_LINE; bs.Thickness = 1.1; bs.Transparency = 0.25
        local li, lc, pv, listenStart = false, nil, btn.Text, 0
        btn.MouseButton1Click:Connect(function()
            if li then
                li = false; __HH._anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return
            end
            pv = btn.Text; li = true; __HH._anyKeyListening = true; listenStart = tick(); btn.Text = "..."
            lc = __HH.UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    li = false; __HH._anyKeyListening = false
                    if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return
                end
                local isGp = __HH.isGamepadInput(inp)
                if isGp and tick()-listenStart < 0.15 then return end
                if not __HH.isBindableInput(inp) then return end
                btn.Text = __HH.getKeyDisplayName(inp.KeyCode, isGp)
                pv = btn.Text; li = false; __HH._anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                if cb then cb(inp.KeyCode, isGp) end
            end)
        end)
        return btn
    end

    local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB)
        local row = mkRow(parent)
        mkLabel(row, txt)
        if kbEntry then
            mkKB(row, kbEntry, function(k, isGp)
                if isGp then kbEntry.gp = k; kbEntry.kb = nil else kbEntry.kb = k; kbEntry.gp = nil end
                if onKB then onKB(k, isGp) end
            end)
        end
        local chk = Instance.new("TextButton", row)
        chk.Size = UDim2.new(0, 48, 0, 24); chk.Position = UDim2.new(1, -50, 0.5, -12)
        chk.BackgroundColor3 = CHECK_OFF; chk.BackgroundTransparency = 0.08
        chk.BorderSizePixel = 0; chk.Text = ""; chk.AutoButtonColor = false; chk.ZIndex = 5
        Instance.new("UICorner", chk).CornerRadius = UDim.new(1, 0)
        local chkStroke = Instance.new("UIStroke", chk); chkStroke.Color = BLUE_GLOW; chkStroke.Thickness = 1.3; chkStroke.Transparency = 0.18
        local knob = Instance.new("Frame", chk)
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(245, 250, 255)
        knob.BorderSizePixel = 0; knob.ZIndex = 6
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local state = false
        local function sv(s)
            state = s == true
            TS:Create(chk, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
                BackgroundColor3 = state and PILL_ON or CHECK_OFF
            }):Play()
            TS:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
                Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            }):Play()
        end
        chk.MouseButton1Click:Connect(function()
            if __HH._anyKeyListening then return end
            state = not state; sv(state); if onToggle then onToggle(state) end
        end)
        return sv
    end

    local function mkActionRow(parent, txt, onActivate, kbEntry)
        local row = mkRow(parent)
        mkLabel(row, txt)
        if kbEntry then
            mkKB(row, kbEntry, function(k, isGp)
                if isGp then kbEntry.gp = k; kbEntry.kb = nil else kbEntry.kb = k; kbEntry.gp = nil end
                saveConfig()
            end)
        end
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 48, 0, 24); btn.Position = UDim2.new(1, -50, 0.5, -12)
        btn.Text = "Run"; btn.TextSize = 12
        btn.AutoButtonColor = false; btn.ZIndex = 5
        styleCapsuleBtn(btn, true)
        btn.MouseButton1Click:Connect(function()
            TS:Create(btn, TweenInfo.new(0.06), {BackgroundColor3 = PILL_ON}):Play()
            task.delay(0.14, function()
                TS:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = BTN_ACT}):Play()
            end)
            if onActivate then onActivate() end
        end)
        return row
    end

    local sfSpeed   = TabRefs.contents["Speed"]
    local sfCombat  = TabRefs.contents["Combat"]
    local sfMechns  = TabRefs.contents["Mechns"]
    local sfVisual  = TabRefs.contents["Visual"]
    local sfExtra   = TabRefs.contents["Extra"]
    local sfMobile  = TabRefs.contents["Mobile"]

    -- ─── Shared Reset All Settings logic ───────────────────────────────────
    -- Wipes every saved toggle/speed/keybind/UI setting back to the script's
    -- hardcoded defaults. Does NOT touch the selected device (PC/Mobile/
    -- Controller) — that is what "Reset Device" is for. Used by both the
    -- Extra tab and Mobile tab "Reset All Settings" buttons.
    local function performResetAllSettings()
        -- Turn off anything currently running so the reset takes effect
        -- immediately, not just on the next join.
        pcall(function() if __HH.tpLockEnabled and stopTPLock then stopTPLock() end end)
        pcall(function() if __HH.batV2Enabled and toggleBatV2 then toggleBatV2() end end)
        pcall(function() if autoLeftEnabled and stopAutoLeft then autoLeftEnabled = false; stopAutoLeft() end end)
        pcall(function() if autoRightEnabled and stopAutoRight then autoRightEnabled = false; stopAutoRight() end end)
        pcall(function() if __HH.antiRagdollEnabled and __HH.stopAntiRagdoll then __HH.stopAntiRagdoll() end end)
        pcall(function() if __HH.medusaCounterEnabled and stopMedusaCounter then stopMedusaCounter() end end)
        pcall(function() if __HH.batCounterEnabled and stopBatCounter then stopBatCounter() end end)
        pcall(function() if __HH.unwalkEnabled and __HH.stopUnwalk then __HH.stopUnwalk() end end)
        pcall(function() if __HH.antiLagEnabled and disableAntiLag then disableAntiLag() end end)
        pcall(function() if __HH.stretchRezEnabled and disableStretchRez then disableStretchRez() end end)
        pcall(function() if __HH.autoTPEnabled and __HH.stopAutoTP then __HH.stopAutoTP() end end)
        pcall(function() if __HH.antiDieEnabled and __HH.stopAntiDie then __HH.stopAntiDie() end end)
        pcall(function() if __HH.espEnabled and stopPlayerESP then stopPlayerESP() end end)
        pcall(function() if __HH.bodyLockEnabled and __HH.stopBodyLock then __HH.stopBodyLock() end end)
        pcall(function() if __HH.headlessEnabled and applyHeadless and LP.Character then applyHeadless(LP.Character, false) end end)
        pcall(function() if __HH.korbloxEnabled and applyKorblox and LP.Character then applyKorblox(LP.Character, false) end end)
        pcall(function() if applyAccessoryPack then applyAccessoryPack("Off") end end)
        pcall(function() if _G.SoundSpinBot and _G.SoundSpinBot.enabled and _G.SoundSpinBot.stop then _G.SoundSpinBot.enabled = false; _G.SoundSpinBot.stop() end end)
        pcall(function() if _G.HorizonStealModes then _G.HorizonStealModes.SetEnabled(false) end end)
        pcall(function() if _G.SoundMirrorTPDown and _G.SoundMirrorTPDown.setEnabled then _G.SoundMirrorTPDown.setEnabled(false) end end)
        pcall(function() if _G.SoundBatSpam and _G.SoundBatSpam.setEnabled then _G.SoundBatSpam.setEnabled(false) end end)
        pcall(function() if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setEnabled then _G.Round3SpeedBooster.setEnabled(false) end end)

        -- Speeds / numeric values back to script defaults.
        NS = 60; CS = 30
        LAGGER_SPEED = 13; LAGGER_CARRY_SPEED = 13
        aimbotV1Speed = 56
        autoCarrySpeedEnabled = false
        carrySpeedActive = false; laggerModeEnabled = false; laggerCarryToggled = false
        speedMode = false; laggerPhase = 0
        pcall(function()
            if _G.Round3SpeedBooster then
                if _G.Round3SpeedBooster.setNormalSpeed then _G.Round3SpeedBooster.setNormalSpeed(62) end
                if _G.Round3SpeedBooster.setCarrySpeed then _G.Round3SpeedBooster.setCarrySpeed(32) end
                if _G.Round3SpeedBooster.setForceCarry then _G.Round3SpeedBooster.setForceCarry(false) end
            end
        end)
        batAimMode = "normal"
        uiScaleValue = 0.7
        __HH.guiSizeValue = 2
        if __HH.uiScaleObject then __HH.uiScaleObject.Scale = 0.7 end
        if __HH.mainFrame then __HH.mainFrame.Size = UDim2.new(0, 430, 0, 450) end
        __HH.autoTPHeight = 20
        __HH.floatHeight = 6
        __HH.mobileButtonsSize = 80
        __HH.bodyLockRange = 20
        __HH.currentSkyTheme = "Off"
        currentAccessoryPack = "Off"
        __HH.aceSelectedAnimationPack = "OFF"

        -- Toggles back to OFF / defaults.
        __HH.antiRagdollEnabled = false
        __HH.infJumpEnabled = false
        __HH.infJumpMode = "manual"
        __HH.medusaCounterEnabled = false
        __HH.medusaResetEnabled = false
        __HH.batCounterEnabled = false
        __HH.unwalkEnabled = false
        __HH.antiLagEnabled = false
        __HH.stretchRezEnabled = false
        __HH.autoTPEnabled = false
        __HH.autoJumpBrainrot = false
        __HH.floatEnabled = false
        __HH.guiTransparencyEnabled = false
        __HH.circleButtonsEnabled = false
        __HH.shapeButtonsEnabled = false
        __HH.rectangularButtonsEnabled = false
        __HH.antiDieEnabled = false
        __HH.autoResetOnDeath = false
        __HH.uiLocked = false; _G.YousefUiLocked = false
        __HH.perButtonDragEnabled = true
        __HH.batV2Enabled = false
        __HH.espEnabled = false
        __HH.headlessEnabled = false
        __HH.korbloxEnabled = false
        __HH.bodyLockEnabled = false
        __HH.antiFlingEnabled = false
        __HH.tpLockEnabled = false
        autoSwingEnabled = false
        autoLeftEnabled = false; autoRightEnabled = false
        antiKickEnabled = false

        -- Mobile-specific settings back to defaults.
        __HH.mobileButtonsEnabled = (__HH.selectedDevice == "MOBILE")

        -- Keybinds back to their original defaults.
        __HH.KB.DropBrainrot  = {kb = Enum.KeyCode.X,           gp = nil}
        __HH.KB.TPLock        = {kb = Enum.KeyCode.E,           gp = nil}
        __HH.KB.TPFloor       = {kb = Enum.KeyCode.F,           gp = nil}
        __HH.KB.GuiHide       = {kb = Enum.KeyCode.LeftControl, gp = nil}
        __HH.KB.SpeedToggle   = {kb = Enum.KeyCode.Q,           gp = nil}
        __HH.KB.LaggerToggle  = {kb = Enum.KeyCode.G,           gp = nil}
        __HH.KB.InstaReset    = {kb = Enum.KeyCode.R,           gp = nil}
        __HH.KB.AutoLeft      = {kb = Enum.KeyCode.Z,           gp = nil}
        __HH.KB.AutoRight     = {kb = Enum.KeyCode.C,           gp = nil}
        __HH.KB.BatV2Toggle   = {kb = Enum.KeyCode.V,           gp = nil}

        -- Button visibility (mobile buttons) back to all-on.
        __HH.buttonVisibility = {
            drop=true, tpDown=true, batV1=true, batV2=true, tpLock=true,
            lagger=true, laggerCarry=true, carrySpeed=true,
            instaReset=true,
        }

        -- Reset saved mobile button positions too, so "Reset All Settings"
        -- from the Mobile tab also puts the floating buttons back at their
        -- default layout.
        pcall(function() if writefile then writefile(MOB_POS_FILE, "{}") end end)

        -- Persist the wipe immediately, then rebuild the whole UI so every
        -- toggle/keybind label reflects the new defaults without needing a
        -- rejoin.
        saveConfig()
        task.delay(0.3, function()
            pcall(function()
                if __HH.mainFrame then __HH.mainFrame:Destroy() end
                buildGui()
                applyState()
                if __HH.mobileButtonsEnabled and buildMobileButtons then task.spawn(buildMobileButtons)
                elseif destroyMobileButtons then destroyMobileButtons() end
                if __HH.mainFrame then __HH.mainFrame.Visible = true end
            end)
        end)
    end

    -- Attaches a two-click "arm/confirm" reset flow to any button, calling
    -- performResetAllSettings() and optionally flashing a status message.
    local function wireResetAllButton(btn, defaultText, flashStatusFn)
        local armed = false
        local armedUntil = 0
        btn.MouseButton1Click:Connect(function()
            if not armed or tick() > armedUntil then
                armed = true
                armedUntil = tick() + 3
                btn.Text = "Confirm?"
                task.delay(3, function()
                    if armed and tick() > armedUntil - 0.05 then
                        armed = false
                        btn.Text = defaultText
                    end
                end)
                return
            end
            armed = false
            btn.Text = defaultText
            performResetAllSettings()
            if flashStatusFn then flashStatusFn("All settings reset to default!") end
        end)
    end

    -- Speed control helper: label + [-] [value box] [+] buttons
    local function mkSpeedCtrl(parent, txt, getVal, setVal, step)
        step = step or 5
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1,0,0,32); row.BackgroundTransparency = 1
        row.LayoutOrder = #parent:GetChildren() + 1
        mkLabel(row, txt)
        local minBtn = Instance.new("TextButton", row)
        minBtn.Size = UDim2.new(0,24,0,22); minBtn.Position = UDim2.new(1,-148,0.5,-11)
        minBtn.BackgroundColor3 = BTN_ACT; minBtn.BorderSizePixel = 0
        minBtn.Text = "-"; minBtn.TextColor3 = WHITE
        minBtn.Font = Enum.Font.GothamBlack; minBtn.TextSize = 15
        minBtn.AutoButtonColor = false; minBtn.ZIndex = 5
        Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,5)
        local mStroke = Instance.new("UIStroke", minBtn); mStroke.Color = WHITE; mStroke.Thickness = 1
        local valTb = Instance.new("TextBox", row)
        valTb.Size = UDim2.new(0,52,0,22); valTb.Position = UDim2.new(1,-120,0.5,-11)
        valTb.BackgroundColor3 = INP_BG; valTb.Text = tostring(getVal())
        valTb.TextColor3 = WHITE; valTb.Font = Enum.Font.GothamBold
        valTb.TextSize = 13; valTb.ClearTextOnFocus = false
        valTb.TextXAlignment = Enum.TextXAlignment.Center; valTb.ZIndex = 5
        Instance.new("UICorner", valTb).CornerRadius = UDim.new(0,5)
        local tbStroke = Instance.new("UIStroke", valTb); tbStroke.Color = DIM_LINE; tbStroke.Thickness = 1
        valTb.Focused:Connect(function() TS:Create(tbStroke, TweenInfo.new(0.12), {Color=WHITE}):Play() end)
        valTb.FocusLost:Connect(function()
            TS:Create(tbStroke, TweenInfo.new(0.12), {Color=DIM_LINE}):Play()
            local n = tonumber(valTb.Text)
            if n then setVal(math.clamp(math.floor(n), 1, 500)) end
            valTb.Text = tostring(getVal())
        end)
        local plusBtn = Instance.new("TextButton", row)
        plusBtn.Size = UDim2.new(0,24,0,22); plusBtn.Position = UDim2.new(1,-64,0.5,-11)
        plusBtn.BackgroundColor3 = BTN_ACT; plusBtn.BorderSizePixel = 0
        plusBtn.Text = "+"; plusBtn.TextColor3 = WHITE
        plusBtn.Font = Enum.Font.GothamBlack; plusBtn.TextSize = 15
        plusBtn.AutoButtonColor = false; plusBtn.ZIndex = 5
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0,5)
        local pStroke = Instance.new("UIStroke", plusBtn); pStroke.Color = WHITE; pStroke.Thickness = 1
        local function flash(b)
            TS:Create(b, TweenInfo.new(0.07), {BackgroundColor3=WHITE}):Play()
            task.delay(0.14, function() TS:Create(b, TweenInfo.new(0.10), {BackgroundColor3=BTN_ACT}):Play() end)
        end
        minBtn.MouseButton1Click:Connect(function()
            setVal(math.max(1, getVal() - step)); valTb.Text = tostring(getVal()); flash(minBtn)
        end)
        plusBtn.MouseButton1Click:Connect(function()
            setVal(math.min(500, getVal() + step)); valTb.Text = tostring(getVal()); flash(plusBtn)
        end)
    end

    mkSect(sfSpeed, "Speed Values")
    local grabSpeedTb
    mkBoxRow(sfSpeed, "Normal Speed", NS, function(v)
        if v>0 and v<=500 then
            NS=v; CS=math.max(1, math.floor(NS/2)); saveConfig()
            -- Grab Speed is auto-derived from Normal Speed, so its own
            -- textbox must reflect the new value immediately instead of
            -- showing a stale number until the panel is reopened.
            if grabSpeedTb then grabSpeedTb.Text = tostring(CS) end
        end
    end)
    grabSpeedTb = mkBoxRow(sfSpeed, "Grab Speed",   CS, function(v) if v>0 and v<=500 then CS=v; saveConfig() end end)
    mkBoxRow(sfSpeed, "Lagger Normal", LAGGER_SPEED, function(v) if v>0 and v<=500 then LAGGER_SPEED=v end; saveConfig() end)
    mkBoxRow(sfSpeed, "Lagger Carry", LAGGER_CARRY_SPEED, function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end; saveConfig() end)
    mkBoxRow(sfSpeed, "AIM BOT Speed", aimbotV1Speed, function(v) if v>0 and v<=500 then aimbotV1Speed=v end; saveConfig() end)
    setAutoCarrySpeedVisual = mkToggle(sfSpeed, "Auto Switch Speed", function(on)
        autoCarrySpeedEnabled = on
        if __HH.mobBtnRefs.carrySpeed then __HH.mobBtnRefs.carrySpeed(carrySpeedActive) end
        saveConfig()
    end, autoCarrySpeedEnabled)

    mkSect(sfSpeed, "Round 3 Speed Boost")
    mkToggle(sfSpeed, "ROUND 3 SPEED", function(on)
        if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setEnabled then
            _G.Round3SpeedBooster.setEnabled(on)
        end
        saveConfig()
    end, (_G.Round3SpeedBooster and _G.Round3SpeedBooster.Enabled) == true)
    mkBoxRow(sfSpeed, "Normal Speed", (_G.Round3SpeedBooster and _G.Round3SpeedBooster.NormalSpeed) or 62, function(v)
        if v>0 and v<=500 then
            if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setNormalSpeed then
                _G.Round3SpeedBooster.setNormalSpeed(v)
            end
        end
        saveConfig()
    end)
    mkBoxRow(sfSpeed, "Carry Speed", (_G.Round3SpeedBooster and _G.Round3SpeedBooster.CarrySpeed) or 32, function(v)
        if v>0 and v<=500 then
            if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setCarrySpeed then
                _G.Round3SpeedBooster.setCarrySpeed(v)
            end
        end
        saveConfig()
    end)
    mkToggle(sfSpeed, "Force Carry", function(on)
        if _G.Round3SpeedBooster and _G.Round3SpeedBooster.setForceCarry then
            _G.Round3SpeedBooster.setForceCarry(on)
        end
        saveConfig()
    end, (_G.Round3SpeedBooster and _G.Round3SpeedBooster.ForceCarry) == true)

    mkSect(sfCombat, "Combat")
    setAutoSwingVisual   = mkToggle(sfCombat, "Auto Swing",     function(on) autoSwingEnabled=on; saveConfig() end, autoSwingEnabled)
    __HH.setHitRangeVisual = mkToggle(sfCombat, "Hit Range", function(on)
        if on then startHorizonHitRange() else stopHorizonHitRange() end
        saveConfig()
    end, false)
    -- SPIN BOT toggle removed from the Combat tab.
    setAntiRagVisual     = mkToggle(sfCombat, "Anti Ragdoll",   function(on) __HH.antiRagdollEnabled=on; if on then __HH.startAntiRagdoll() else __HH.stopAntiRagdoll() end; saveConfig() end, __HH.antiRagdollEnabled)
    setMedusaResetVisual = mkToggle(sfCombat, "Medusa Reset",   function(on) __HH.medusaResetEnabled=on; saveConfig() end, __HH.medusaResetEnabled)
    setUnwalkVisual      = mkToggle(sfCombat, "Unwalk",         function(on) __HH.unwalkEnabled=on; if on then __HH.startUnwalk() else __HH.stopUnwalk() end; saveConfig() end, __HH.unwalkEnabled)

    mkSect(sfCombat, "Body Protection")
    __HH.setBodyLockVisual = mkToggle(sfCombat, "Body Lock", function(on)
        __HH.bodyLockEnabled=on==true
        if on and not __HH.batV2Enabled and not __HH.tpLockEnabled then __HH.startBodyLock() else __HH.stopBodyLock() end
        saveConfig()
    end, __HH.bodyLockEnabled)
    mkBoxRow(sfCombat, "Body Lock Range", __HH.bodyLockRange, function(v) __HH.bodyLockRange=math.clamp(math.floor(v),5,200);saveConfig() end)
    __HH.setAntiFlingVisual = mkToggle(sfCombat, "Anti Fling", function(on) __HH.antiFlingEnabled=on==true;saveConfig() end, __HH.antiFlingEnabled)

    mkSect(sfCombat, "Yousef")
    __HH.setBatCounterVisual  = mkToggle(sfCombat, "Bat Counter",    function(on) __HH.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end; saveConfig() end, __HH.batCounterEnabled)
    setMedusaVisual      = mkToggle(sfCombat, "Medusa Counter", function(on) __HH.medusaCounterEnabled=on; if on then setupMedusa(LP.Character) else stopMedusaCounter() end; saveConfig() end, __HH.medusaCounterEnabled)




    _G.SoundMirrorTPDownSetVisual = mkToggle(sfCombat, "MIRROR TP DOWN", function(on)
        if _G.SoundMirrorTPDown and _G.SoundMirrorTPDown.setEnabled then
            _G.SoundMirrorTPDown.setEnabled(on)
        end
        saveConfig()
    end, (_G.SoundMirrorTPDown and _G.SoundMirrorTPDown.enabled
        and _G.SoundMirrorTPDown.enabled()) == true)

    _G.SoundBatSpamSetVisual = mkToggle(sfCombat, "Bat Spam", function(on)
        if _G.SoundBatSpam and _G.SoundBatSpam.setEnabled then
            _G.SoundBatSpam.setEnabled(on)
        end
        saveConfig()
    end, (_G.SoundBatSpam and _G.SoundBatSpam.enabled
        and _G.SoundBatSpam.enabled()) == true)

    __HH.setAntiDieVisual = mkToggle(sfCombat, "Anti Die", function(on)
        __HH.antiDieEnabled = on
        if on then __HH.startAntiDie() else __HH.stopAntiDie() end
        saveConfig()
    end, __HH.antiDieEnabled)

    __HH.setAutoResetOnDeathVisual = mkToggle(sfCombat, "Instant Reset on Die", function(on)
        __HH.autoResetOnDeath = on
        if on and __HH.antiDieEnabled then
            __HH.antiDieEnabled = false
            __HH.stopAntiDie()
            if __HH.setAntiDieVisual then __HH.setAntiDieVisual(false) end
        end
        __HH.setupDeathReset()
        saveConfig()
    end, __HH.autoResetOnDeath)

    mkSect(sfMechns, "Actions")
    mkActionRow(sfMechns, "Speed Toggle",  nil, __HH.KB.SpeedToggle)
    mkActionRow(sfMechns, "Lagger Toggle", nil, __HH.KB.LaggerToggle)
    mkActionRow(sfMechns, "Insta Reset",   function() __HH.FrameReset.ResetPlayer() end, __HH.KB.InstaReset)
    mkActionRow(sfMechns, "Drop Brainrot", function() runDrop() end,     __HH.KB.DropBrainrot)
    mkActionRow(sfMechns, "TP Down",       function() __HH.tpToGround() end,  __HH.KB.TPFloor)
    mkActionRow(sfMechns, "Hide GUI",      function() if __HH.mainFrame then __HH.mainFrame.Visible = not __HH.mainFrame.Visible end end, __HH.KB.GuiHide)

    mkSect(sfMechns, "Toggles")
    __HH.tpLockSetVisual = mkToggleKB(sfMechns, "TP BAT", __HH.KB.TPLock, function(on)
        if __HH._anyKeyListening then return end
        if on then
            
            if __HH.batV2Enabled then toggleBatV2() end
            toggleTPLock()
        else if __HH.tpLockEnabled then toggleTPLock() end end
        saveConfig()
    end, function() saveConfig() end)
    __HH.tpLockSetVisual(__HH.tpLockEnabled)

    __HH.batV2SetVisual = mkToggleKB(sfMechns, "AIM BOT", __HH.KB.BatV2Toggle, function(on)
        if __HH._anyKeyListening then return end
        if on then
            if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart(true) then
                if __HH.batV2SetVisual then __HH.batV2SetVisual(false) end
                return
            end
            if __HH.tpLockEnabled then toggleTPLock() end
            toggleBatV2()
        else
            if __HH.batV2Enabled then toggleBatV2() end
        end
        saveConfig()
    end, function() saveConfig() end)
    __HH.batV2SetVisual(__HH.batV2Enabled)


    do
        local mRow = mkRow(sfMechns); mkLabel(mRow, "AIM Mode")
        local mBtns = {}
        local function mkAimModeBtn(lbl, xOff, mode)
            local b = Instance.new("TextButton", mRow)
            b.Size = UDim2.new(0,100,0,20); b.Position = UDim2.new(1,xOff,0.5,-10)
            b.BackgroundColor3 = (batAimMode==mode) and WHITE or BTN_ACT
            b.BorderSizePixel = 0; b.Text = lbl
            b.TextColor3 = (batAimMode==mode) and BLACK or Color3.fromRGB(180,180,200)
            b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.AutoButtonColor = false; b.ZIndex = 5
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
            table.insert(mBtns, b)
            b.MouseButton1Click:Connect(function()
                if batAimMode == mode then return end
                batAimMode = mode
                b.BackgroundColor3 = WHITE; b.TextColor3 = BLACK
                for _, ob in ipairs(mBtns) do
                    if ob ~= b then
                        ob.BackgroundColor3 = BTN_ACT; ob.TextColor3 = Color3.fromRGB(180,180,200)
                    end
                end
                if __HH.batV2Enabled then
                    stopAimbotFull()
                    queueAutoBatStart()
                    if __HH.batV2SetVisual then __HH.batV2SetVisual(true) end
                    if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(true) end
                end
                saveConfig()
            end)
            return b
        end
        mkAimModeBtn("Normal", -208, "normal")
        mkAimModeBtn("Bypass", -104, "bypass")
    end
    autoLeftSetVisual = mkToggleKB(sfMechns, "Auto Left", __HH.KB.AutoLeft, function(on)
        if __HH._anyKeyListening then return end
        autoLeftEnabled = on
        if __HH.mobBtnRefs.autoLeft then __HH.mobBtnRefs.autoLeft(on) end
        if on then startAutoLeft() else stopAutoLeft() end
        saveConfig()
    end, function() saveConfig() end)
    autoLeftSetVisual(autoLeftEnabled)

    autoRightSetVisual = mkToggleKB(sfMechns, "Auto Right", __HH.KB.AutoRight, function(on)
        if __HH._anyKeyListening then return end
        autoRightEnabled = on
        if __HH.mobBtnRefs.autoRight then __HH.mobBtnRefs.autoRight(on) end
        if on then startAutoRight() else stopAutoRight() end
        saveConfig()
    end, function() saveConfig() end)
    autoRightSetVisual(autoRightEnabled)


    mkSect(sfCombat, "Auto Steal")
    do
        local bridge = _G.HorizonStealModes
        mkToggle(sfCombat, "Auto Steal", function(on) if bridge then bridge.SetEnabled(on) end end, bridge and bridge.GetEnabled() or false)
        local row=mkRow(sfCombat);mkLabel(row,"Steal Mode")
        local v1Btn=Instance.new("TextButton",row);v1Btn.Size=UDim2.new(0,58,0,20);v1Btn.Position=UDim2.new(1,-122,.5,-10);v1Btn.Text="V1";v1Btn.Font=Enum.Font.GothamBold;v1Btn.TextSize = 10;v1Btn.BorderSizePixel=0;v1Btn.ZIndex=5;Instance.new("UICorner",v1Btn).CornerRadius=UDim.new(0,4)
        local v2Btn=Instance.new("TextButton",row);v2Btn.Size=UDim2.new(0,58,0,20);v2Btn.Position=UDim2.new(1,-58,.5,-10);v2Btn.Text="V2";v2Btn.Font=Enum.Font.GothamBold;v2Btn.TextSize = 10;v2Btn.BorderSizePixel=0;v2Btn.ZIndex=5;Instance.new("UICorner",v2Btn).CornerRadius=UDim.new(0,4)
        local function paint(m) v1Btn.BackgroundColor3=m=="V1" and WHITE or BTN_ACT;v2Btn.BackgroundColor3=m=="V2" and WHITE or BTN_ACT;v1Btn.TextColor3=m=="V1" and BLACK or WHITE;v2Btn.TextColor3=m=="V2" and BLACK or WHITE end
        v1Btn.MouseButton1Click:Connect(function() if bridge then bridge.SetMode("V1");paint("V1") end end)
        v2Btn.MouseButton1Click:Connect(function() if bridge then bridge.SetMode("V2");paint("V2") end end);paint(bridge and bridge.GetMode() or "V1")
        mkBoxRow(sfCombat,"Radius",bridge and bridge.GetRadius() or 60,function(v) if bridge then bridge.SetRadius(v) end end)
    end

    mkSect(sfCombat, "Misc")
    setSafeModeVisual = mkToggle(sfCombat, "Anti Kick", function(on)
        antiKickEnabled = on
        if on and _G.AceSafeModeIsLocked and _G.AceSafeModeIsLocked()
            and _G.AceSafeModeForceStop then
            _G.AceSafeModeForceStop("AIM BOT BEFORE START")
        end
        saveConfig()
    end, antiKickEnabled)
    __HH.setInfJumpVisual = mkToggle(sfCombat, "Infinite Jump", function(on)
        __HH.infJumpEnabled = on
        if __HH.infJumpEnabled then if __HH.infJumpMode == "hold" then __HH.startHoldInfJump() end
        else __HH.stopHoldInfJump() end
        saveConfig()
    end, __HH.infJumpEnabled)

    -- Jump Mode selector: Manual / Hold
    do
        local jRow = mkRow(sfCombat); mkLabel(jRow, "Jump Mode")
        local jBtns = {}
        local function mkJumpModeBtn(lbl, xOff, mode)
            local b = Instance.new("TextButton", jRow)
            b.Size = UDim2.new(0,52,0,20); b.Position = UDim2.new(1,xOff,0.5,-10)
            b.BackgroundColor3 = (__HH.infJumpMode==mode) and WHITE or BTN_ACT
            b.BorderSizePixel = 0; b.Text = lbl
            b.TextColor3 = (__HH.infJumpMode==mode) and BLACK or Color3.fromRGB(180,180,200)
            b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.AutoButtonColor = false; b.ZIndex = 5
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
            table.insert(jBtns, b)
            b.MouseButton1Click:Connect(function()
                if __HH.infJumpMode == mode then return end
                __HH.infJumpMode = mode
                b.BackgroundColor3 = WHITE; b.TextColor3 = BLACK
                for _, ob in ipairs(jBtns) do
                    if ob ~= b then
                        ob.BackgroundColor3 = BTN_ACT; ob.TextColor3 = Color3.fromRGB(180,180,200)
                    end
                end
                __HH.stopHoldInfJump()
                if __HH.infJumpEnabled and mode == "hold" then __HH.startHoldInfJump() end
                saveConfig()
            end)
            return b
        end
        mkJumpModeBtn("Manual", -110, "manual")
        mkJumpModeBtn("Hold",    -54,  "hold")
    end

    mkSect(sfCombat, "Auto Jump - Brainrot")
    __HH.setAutoJumpBrainrotVisual = mkToggle(sfCombat, "Auto Jump while holding", function(on)
        __HH.autoJumpBrainrot = on
        saveConfig()
    end, __HH.autoJumpBrainrot)

    mkSect(sfCombat, "Float")
    __HH.setFloatVisual = mkToggle(sfCombat, "Float", function(on)
        __HH.floatEnabled = on
        if __HH.FRFloat then __HH.FRFloat.setEnabled(on) end
        saveConfig()
    end, __HH.floatEnabled)
    do
        local fRow = mkRow(sfCombat)
        mkLabel(fRow, "Float Height (studs)")
        local fBox = Instance.new("TextBox", fRow)
        fBox.Size = UDim2.new(0,70,0,20); fBox.Position = UDim2.new(1,-76,0.5,-10)
        fBox.BackgroundColor3 = INP_BG
        fBox.Text = tostring((__HH.FRFloat and __HH.FRFloat.getHeight()) or (__HH.floatHeight or 6))
        fBox.TextColor3 = WHITE; fBox.Font = Enum.Font.GothamBold; fBox.TextSize = 12
        fBox.ClearTextOnFocus = false; fBox.TextXAlignment = Enum.TextXAlignment.Center; fBox.ZIndex = 5
        Instance.new("UICorner", fBox).CornerRadius = UDim.new(0,4)
        local fbs = Instance.new("UIStroke", fBox); fbs.Color = DIM_LINE; fbs.Thickness = 1
        fBox.Focused:Connect(function() TS:Create(fbs, TweenInfo.new(0.12), {Color=WHITE}):Play() end)
        fBox.FocusLost:Connect(function()
            TS:Create(fbs, TweenInfo.new(0.12), {Color=DIM_LINE}):Play()
            local n = tonumber(fBox.Text)
            if n then
                __HH.floatHeight = math.clamp(n, 0, 200)
                if __HH.FRFloat then __HH.FRFloat.setHeight(__HH.floatHeight) end
                saveConfig()
                fBox.Text = tostring(__HH.floatHeight)
            else
                fBox.Text = tostring((__HH.FRFloat and __HH.FRFloat.getHeight()) or (__HH.floatHeight or 6))
            end
        end)
    end

    mkSect(sfCombat, "Auto TP")
    __HH.setAutoTPVisual = mkToggle(sfCombat, "Auto TP", function(on)
        __HH.autoTPEnabled=on; if on then startAutoTP() else __HH.stopAutoTP() end; saveConfig()
    end, __HH.autoTPEnabled)
    mkBoxRow(sfCombat, "TP Height", __HH.autoTPHeight, function(v) if v>=0 and v<=500 then __HH.autoTPHeight=v end; saveConfig() end)

    mkSect(sfVisual, "Avatar")
    mkToggle(sfVisual, "Headless", function(on)
        __HH.headlessEnabled = on == true
        local char = LP.Character
        if char then pcall(function() applyHeadless(char, __HH.headlessEnabled) end) end
        saveConfig()
    end, __HH.headlessEnabled)
    mkToggle(sfVisual, "Korblox", function(on)
        __HH.korbloxEnabled = on == true
        local char = LP.Character
        if char then pcall(function() applyKorblox(char, __HH.korbloxEnabled) end) end
        saveConfig()
    end, __HH.korbloxEnabled)

    -- Pack Accessory (Catalog Changer — VisDuels port)
    do
        local row = mkRow(sfVisual)
        mkLabel(row, "Pack Accessory")
        row.Size = UDim2.new(ROW_W, 0, 0, 42)
        row.ClipsDescendants = true

        local left = Instance.new("TextButton", row)
        left.BackgroundColor3 = Color3.fromRGB(4, 9, 20); left.BackgroundTransparency = 0.04
        left.Text = "<"; left.TextColor3 = Color3.fromRGB(230, 201, 255); left.TextSize = 14
        left.Font = Enum.Font.GothamSemibold; left.Size = UDim2.new(0, 42, 0, 28)
        left.Position = UDim2.new(1, -186, 0.5, -14); left.BorderSizePixel = 0; left.ZIndex = 8
        Instance.new("UICorner", left).CornerRadius = UDim.new(0, 8)
        local leftStroke = Instance.new("UIStroke", left); leftStroke.Color = Color3.fromRGB(49, 66, 105); leftStroke.Transparency = 0.42

        local holder = Instance.new("Frame", row)
        holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0); holder.BackgroundTransparency = 0.28
        holder.Size = UDim2.new(0, 92, 0, 28); holder.Position = UDim2.new(1, -139, 0.5, -14); holder.ClipsDescendants = true; holder.ZIndex = 7
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 8)
        local holderStroke = Instance.new("UIStroke", holder); holderStroke.Color = Color3.fromRGB(230, 201, 255); holderStroke.Transparency = 0.35

        local accValueLabel = Instance.new("TextLabel", holder)
        accValueLabel.BackgroundTransparency = 1; accValueLabel.Text = currentAccessoryPack
        accValueLabel.TextColor3 = Color3.fromRGB(230, 201, 255); accValueLabel.TextSize = 13
        accValueLabel.Font = Enum.Font.GothamSemibold; accValueLabel.Size = UDim2.new(1, 0, 1, 0); accValueLabel.ZIndex = 9
        accValueLabel.TextXAlignment = Enum.TextXAlignment.Center

        local right = Instance.new("TextButton", row)
        right.BackgroundColor3 = Color3.fromRGB(4, 9, 20); right.BackgroundTransparency = 0.04
        right.Text = ">"; right.TextColor3 = Color3.fromRGB(230, 201, 255); right.TextSize = 14
        right.Font = Enum.Font.GothamSemibold; right.Size = UDim2.new(0, 42, 0, 28)
        right.Position = UDim2.new(1, -42, 0.5, -14); right.BorderSizePixel = 0; right.ZIndex = 8
        Instance.new("UICorner", right).CornerRadius = UDim.new(0, 8)
        local rightStroke = Instance.new("UIStroke", right); rightStroke.Color = Color3.fromRGB(49, 66, 105); rightStroke.Transparency = 0.42

        local function updateAccessorySelector(direction)
            local idx = 1
            for i, entry in ipairs(ACCESSORY_PACK_ORDER) do
                if entry[2] == currentAccessoryPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ACCESSORY_PACK_ORDER end
            if newIdx > #ACCESSORY_PACK_ORDER then newIdx = 1 end
            local packName = ACCESSORY_PACK_ORDER[newIdx][2]
            currentAccessoryPack = packName
            accValueLabel.Text = packName
            applyAccessoryPack(packName)
            saveConfig()
        end

        left.MouseButton1Click:Connect(function() updateAccessorySelector(-1) end)
        right.MouseButton1Click:Connect(function() updateAccessorySelector(1) end)
    end

    mkSect(sfVisual, "ESP")
    __HH.setESPVisual = mkToggle(sfVisual, "ESP Players", function(on)
        __HH.espEnabled = on == true
        if on then
            if startPlayerESP then startPlayerESP() end
        else
            if stopPlayerESP then stopPlayerESP() end
        end
        saveConfig()
    end, __HH.espEnabled)

    mkSect(sfVisual, "Visual Effects")
    setAntiLagVisual    = mkToggle(sfVisual, "Anti Lag",    function(on) if on then enableAntiLag() else disableAntiLag() end; saveConfig() end, __HH.antiLagEnabled)
    __HH.setStretchRezVisual = mkToggle(sfVisual, "Stretch Rez", function(on) if on then enableStretchRez() else disableStretchRez() end; saveConfig() end, __HH.stretchRezEnabled)


    -- ===================== AMBITIOUS PORTS (GUI ROWS) =====================
    do
        local function mkSelector(parent, labelText, getText, onLeft, onRight)
            local row = mkRow(parent)
            mkLabel(row, labelText)
            row.Size = UDim2.new(ROW_W, 0, 0, 42)
            row.ClipsDescendants = true
            local function mkArrow(txt, xOff)
                local b = Instance.new("TextButton", row)
                b.BackgroundColor3 = Color3.fromRGB(4, 9, 20); b.BackgroundTransparency = 0.04
                b.Text = txt; b.TextColor3 = WHITE; b.TextSize = 14
                b.Font = Enum.Font.GothamSemibold; b.Size = UDim2.new(0, 42, 0, 28)
                b.Position = UDim2.new(1, xOff, 0.5, -14); b.BorderSizePixel = 0; b.ZIndex = 8
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
                local st = Instance.new("UIStroke", b); st.Color = DIM_LINE; st.Transparency = 0.42
                return b
            end
            local left  = mkArrow("<", -186)
            local holder = Instance.new("Frame", row)
            holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0); holder.BackgroundTransparency = 0.28
            holder.Size = UDim2.new(0, 92, 0, 28); holder.Position = UDim2.new(1, -139, 0.5, -14)
            holder.ClipsDescendants = true; holder.ZIndex = 7
            Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 8)
            local hs = Instance.new("UIStroke", holder); hs.Color = WHITE; hs.Transparency = 0.35
            local val = Instance.new("TextLabel", holder)
            val.BackgroundTransparency = 1; val.TextColor3 = WHITE; val.TextSize = 12
            val.Font = Enum.Font.GothamSemibold; val.Size = UDim2.new(1, 0, 1, 0); val.ZIndex = 9
            val.TextXAlignment = Enum.TextXAlignment.Center
            local right = mkArrow(">", -42)
            local function refresh() val.Text = tostring(getText()) end
            left.MouseButton1Click:Connect(function() onLeft(); refresh() end)
            right.MouseButton1Click:Connect(function() onRight(); refresh() end)
            refresh()
            return refresh
        end

        -- ---------------- X-RAY ----------------
        mkSect(sfVisual, "X-Ray")
        mkToggle(sfVisual, "X-Ray", function(on)
            _G.SoundXRayEnabled = on == true
            pcall(function() if setXRay then setXRay(on) end end)
            saveConfig()
        end, _G.SoundXRayEnabled == true)
        mkToggle(sfVisual, "Brainrot X-Ray", function(on)
            pcall(function() if _G.AmbitiousSetBrainrotXRay then _G.AmbitiousSetBrainrotXRay(on) end end)
            saveConfig()
        end, _G.AmbitiousBrainrotXRayEnabled == true)

        -- ---------------- TOOLS ----------------
        mkSect(sfVisual, "Tools")
        mkToggle(sfVisual, "Custom Tools", function(on)
            if _G.AmbitiousCustomTools then pcall(function() _G.AmbitiousCustomTools.setEnabled(on) end) end
            saveConfig()
        end, _G.AmbitiousCustomToolsEnabled == true)

        -- ---- Custom Tools Selector: popup completo con anteprime 3D ----
        do
            local row = mkRow(sfVisual)
            mkLabel(row, "Custom Tools Selector")

            local pickHolder = Instance.new("Frame", row)
            pickHolder.Size = UDim2.new(0, 62, 0, 24)
            pickHolder.Position = UDim2.new(1, -68, 0.5, -12)
            pickHolder.BackgroundColor3 = BTN_ACT
            pickHolder.BorderSizePixel = 0
            pickHolder.ClipsDescendants = true
            pickHolder.ZIndex = 6
            Instance.new("UICorner", pickHolder).CornerRadius = UDim.new(0, 12)
            local phStroke = Instance.new("UIStroke", pickHolder)
            phStroke.Color = WHITE; phStroke.Thickness = 1.3; phStroke.Transparency = 0.2
            local phGrad = Instance.new("UIGradient", pickHolder)
            phGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(236, 215, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(162, 180, 224)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(115, 145, 216)),
            })
            phGrad.Rotation = 18

            local pickBtn = Instance.new("TextButton", pickHolder)
            pickBtn.Size = UDim2.new(1, 0, 1, 0)
            pickBtn.BackgroundTransparency = 1
            pickBtn.Text = "PICK"
            pickBtn.TextColor3 = Color3.fromRGB(5, 18, 50)
            pickBtn.Font = Enum.Font.GothamBlack
            pickBtn.TextSize = 13
            pickBtn.AutoButtonColor = false
            pickBtn.ZIndex = 7

            local ctGui = nil
            local function closeCTPicker()
                if ctGui and ctGui.Parent then
                    local fr = ctGui:FindFirstChild("Frame")
                    if fr then TS:Create(fr, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play() end
                    local dying = ctGui
                    ctGui = nil
                    task.delay(0.22, function()
                        if dying and dying.Parent then dying:Destroy() end
                    end)
                end
                saveConfig()
            end

            pickBtn.MouseButton1Click:Connect(function()
                if ctGui and ctGui.Parent then closeCTPicker() return end

                ctGui = Instance.new("ScreenGui")
                ctGui.Name = "SoundCustomToolsPicker"
                ctGui.ResetOnSpawn = false
                ctGui.IgnoreGuiInset = true
                ctGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                ctGui.DisplayOrder = 9999
                if not pcall(function() ctGui.Parent = game:GetService("CoreGui") end) then
                    ctGui.Parent = LP:WaitForChild("PlayerGui")
                end

                local backdrop = Instance.new("TextButton", ctGui)
                backdrop.Size = UDim2.new(1, 0, 1, 0)
                backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                backdrop.BackgroundTransparency = 0.5
                backdrop.BorderSizePixel = 0
                backdrop.Text = ""
                backdrop.AutoButtonColor = false
                backdrop.ZIndex = 1

                local frame = Instance.new("Frame", ctGui)
                frame.Name = "Frame"
                frame.Size = UDim2.new(0, 420, 0, 470)
                frame.Position = UDim2.new(0.5, -210, 0.5, -235)
                frame.BackgroundColor3 = DARK
                frame.BorderSizePixel = 0
                frame.ZIndex = 2
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
                local fStroke = Instance.new("UIStroke", frame)
                fStroke.Color = WHITE; fStroke.Thickness = 1.3; fStroke.Transparency = 0.3

                local titleBar = Instance.new("Frame", frame)
                titleBar.Size = UDim2.new(1, 0, 0, 44)
                titleBar.BackgroundColor3 = Color3.fromRGB(6, 12, 27)
                titleBar.BackgroundTransparency = 0.1
                titleBar.BorderSizePixel = 0
                titleBar.ZIndex = 3
                Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

                local titleLabel = Instance.new("TextLabel", titleBar)
                titleLabel.Size = UDim2.new(1, -60, 1, 0)
                titleLabel.Position = UDim2.new(0, 16, 0, 0)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = "CUSTOM TOOLS SELECTOR"
                titleLabel.TextColor3 = WHITE
                titleLabel.Font = Enum.Font.GothamBlack
                titleLabel.TextSize = 14
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.ZIndex = 4

                local closeBtn = Instance.new("TextButton", titleBar)
                closeBtn.Size = UDim2.new(0, 30, 0, 30)
                closeBtn.Position = UDim2.new(1, -38, 0, 7)
                closeBtn.BackgroundColor3 = Color3.fromRGB(9, 18, 38)
                closeBtn.BorderSizePixel = 0
                closeBtn.Text = "X"
                closeBtn.TextColor3 = WHITE
                closeBtn.Font = Enum.Font.GothamBlack
                closeBtn.TextSize = 14
                closeBtn.AutoButtonColor = false
                closeBtn.ZIndex = 4
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
                local cbStroke = Instance.new("UIStroke", closeBtn)
                cbStroke.Color = DIM_LINE; cbStroke.Thickness = 1; cbStroke.Transparency = 0.4
                closeBtn.MouseEnter:Connect(function()
                    TS:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(38, 74, 158)}):Play()
                end)
                closeBtn.MouseLeave:Connect(function()
                    TS:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(9, 18, 38)}):Play()
                end)
                closeBtn.MouseButton1Click:Connect(closeCTPicker)

                -- ---- selettore sezioni Bat | Medusa ----
                local tabsHolder = Instance.new("Frame", frame)
                tabsHolder.BackgroundColor3 = Color3.fromRGB(7, 14, 31)
                tabsHolder.BackgroundTransparency = 0.25
                tabsHolder.Size = UDim2.new(1, -24, 0, 38)
                tabsHolder.Position = UDim2.new(0, 12, 0, 58)
                tabsHolder.BorderSizePixel = 0
                tabsHolder.ZIndex = 3
                tabsHolder.ClipsDescendants = true
                Instance.new("UICorner", tabsHolder).CornerRadius = UDim.new(0, 10)

                local slide = Instance.new("Frame", tabsHolder)
                slide.BackgroundColor3 = BTN_ACT
                slide.AnchorPoint = Vector2.new(0.5, 0.5)
                slide.Size = UDim2.new(0.5, 0, 1, 0)
                slide.Position = UDim2.new(0.25, 0, 0.5, 0)
                slide.BorderSizePixel = 0
                slide.ZIndex = 4
                Instance.new("UICorner", slide).CornerRadius = UDim.new(0, 10)
                local slideGrad = Instance.new("UIGradient", slide)
                slideGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(238, 219, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(133, 160, 222)),
                })
                slideGrad.Rotation = 90

                local CATS = { {key = "Bat", text = "BAT"}, {key = "Medusa", text = "MEDUSA"} }
                local catLabels = {}
                for i, c in ipairs(CATS) do
                    local lbl = Instance.new("TextLabel", tabsHolder)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = c.text
                    lbl.TextColor3 = WHITE
                    lbl.TextSize = 14
                    lbl.Font = Enum.Font.GothamBlack
                    lbl.AnchorPoint = Vector2.new(0.5, 0.5)
                    lbl.Size = UDim2.new(0.5, 0, 1, 0)
                    lbl.Position = UDim2.new(0.25 + 0.5 * (i - 1), 0, 0.5, 0)
                    lbl.ZIndex = 6
                    catLabels[i] = lbl
                end

                -- ---- area anteprime ----
                local page = Instance.new("Frame", frame)
                page.BackgroundTransparency = 1
                page.Size = UDim2.new(1, -24, 1, -118)
                page.Position = UDim2.new(0, 12, 0, 106)
                page.ClipsDescendants = true
                page.ZIndex = 3

                local cards = {}
                local spinConn = nil

                local function buildCard(def, key)
                    local card = Instance.new("Frame", page)
                    card.Name = "Skin_" .. key
                    card.BackgroundColor3 = Color3.fromRGB(5, 11, 26)
                    card.BackgroundTransparency = 0.15
                    card.Size = UDim2.new(0, 148, 0, 172)
                    card.BorderSizePixel = 0
                    card.ZIndex = 4
                    card.Visible = false
                    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
                    local cStroke = Instance.new("UIStroke", card)
                    cStroke.Color = DIM_LINE; cStroke.Thickness = 1.3; cStroke.Transparency = 0.5

                    local vp = Instance.new("ViewportFrame", card)
                    vp.BackgroundColor3 = Color3.fromRGB(3, 8, 19)
                    vp.BackgroundTransparency = 0.25
                    vp.Size = UDim2.new(1, -16, 0, 116)
                    vp.Position = UDim2.new(0, 8, 0, 8)
                    vp.BorderSizePixel = 0
                    vp.ZIndex = 5
                    vp.Ambient = Color3.fromRGB(190, 190, 200)
                    vp.LightColor = Color3.fromRGB(255, 255, 255)
                    vp.LightDirection = Vector3.new(-0.4, -1, -0.6)
                    Instance.new("UICorner", vp).CornerRadius = UDim.new(0, 12)

                    local part = Instance.new("Part")
                    part.Anchored = true
                    part.CanCollide = false
                    part.Size = Vector3.new(1, 1, 1)
                    part.CFrame = CFrame.new(0, 0, 0)
                    part.Parent = vp

                    local mesh = Instance.new("SpecialMesh", part)
                    mesh.MeshType = Enum.MeshType.FileMesh
                    mesh.MeshId = def.mesh
                    mesh.TextureId = def.tex
                    mesh.Scale = def.scale

                    local cam = Instance.new("Camera", vp)
                    cam.FieldOfView = 45
                    vp.CurrentCamera = cam
                    local dist = def.view or 4
                    cam.CFrame = CFrame.new(Vector3.new(0, dist * 0.35, dist), Vector3.new(0, 0, 0))

                    local nameLbl = Instance.new("TextLabel", card)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.Text = def.label
                    nameLbl.TextColor3 = WHITE
                    nameLbl.TextSize = 14
                    nameLbl.Font = Enum.Font.GothamBlack
                    nameLbl.TextWrapped = true
                    nameLbl.Size = UDim2.new(1, -12, 0, 36)
                    nameLbl.Position = UDim2.new(0, 6, 0, 130)
                    nameLbl.ZIndex = 6

                    local click = Instance.new("TextButton", card)
                    click.BackgroundTransparency = 1
                    click.Text = ""
                    click.AutoButtonColor = false
                    click.Size = UDim2.new(1, 0, 1, 0)
                    click.ZIndex = 8

                    local entry = { card = card, cat = def.cat, key = key, part = part, stroke = cStroke }

                    local function refreshSel()
                        local sel = ((_G.AmbitiousCustomToolSkins or {})[def.cat] == key)
                        TS:Create(cStroke, TweenInfo.new(0.14), {
                            Color = sel and WHITE or DIM_LINE,
                            Transparency = sel and 0 or 0.5,
                            Thickness = sel and 2.2 or 1.3,
                        }):Play()
                        TS:Create(card, TweenInfo.new(0.14), {BackgroundTransparency = sel and 0 or 0.15}):Play()
                    end
                    entry.refresh = refreshSel

                    click.MouseEnter:Connect(function()
                        local w = entry.baseW or card.Size.X.Offset
                        local x = entry.baseX or card.Position.X.Offset
                        TS:Create(card, TweenInfo.new(0.12), {
                            Size = UDim2.new(0, w + 4, 0, 176),
                            Position = UDim2.new(0, x - 2, 0, 8),
                        }):Play()
                    end)
                    click.MouseLeave:Connect(function()
                        local w = entry.baseW or card.Size.X.Offset
                        local x = entry.baseX or card.Position.X.Offset
                        TS:Create(card, TweenInfo.new(0.12), {
                            Size = UDim2.new(0, w, 0, 172),
                            Position = UDim2.new(0, x, 0, 10),
                        }):Play()
                    end)
                    click.MouseButton1Click:Connect(function()
                        if _G.AmbitiousSetCustomToolSkin then
                            pcall(_G.AmbitiousSetCustomToolSkin, def.cat, key)
                        end
                        for _, e in ipairs(cards) do e.refresh() end
                        saveConfig()   -- la skin scelta resta dopo il rejoin
                    end)

                    refreshSel()
                    return entry
                end

                for key, def in pairs(_G.AmbitiousCustomToolAssets or {}) do
                    cards[#cards + 1] = buildCard(def, key)
                end

                spinConn = RunService.RenderStepped:Connect(function(dt)
                    for _, e in ipairs(cards) do
                        if e.card.Visible and e.part.Parent then
                            e.part.CFrame = e.part.CFrame * CFrame.Angles(0, dt * 1.2, 0)
                        end
                    end
                end)
                ctGui.AncestryChanged:Connect(function(_, parent)
                    if not parent and spinConn then
                        pcall(function() spinConn:Disconnect() end)
                        spinConn = nil
                    end
                end)

                local current = "Bat"
                local PAGE_W, GAP, INSET = 420 - 24, 14, 9

                local function layoutCat(cat, fromRight, animate)
                    local list = {}
                    for _, e in ipairs(cards) do
                        if e.cat == cat then list[#list + 1] = e end
                    end
                    local n = #list
                    if n == 0 then return end
                    local cardW = math.floor((PAGE_W - INSET * 2 - GAP * (n - 1)) / n)
                    for i, e in ipairs(list) do
                        local targetX = INSET + (i - 1) * (cardW + GAP)
                        e.card.Size = UDim2.new(0, cardW, 0, 172)
                        e.baseW = cardW
                        e.baseX = targetX
                        e.card.Visible = true
                        if animate then
                            e.card.Position = UDim2.new(0, targetX + (fromRight and 300 or -300), 0, 10)
                            TS:Create(e.card, TweenInfo.new(0.24), {Position = UDim2.new(0, targetX, 0, 10)}):Play()
                        else
                            e.card.Position = UDim2.new(0, targetX, 0, 10)
                        end
                    end
                end

                local switchToken = 0
                local function setCat(cat, animate)
                    if cat == current and animate then return end
                    local goingRight = (cat == "Medusa")
                    switchToken = switchToken + 1
                    local myToken = switchToken

                    local outList = {}
                    for _, e in ipairs(cards) do
                        if e.cat ~= cat and e.card.Visible then outList[#outList + 1] = e end
                    end
                    current = cat

                    if animate then
                        for _, e in ipairs(outList) do
                            local x = e.card.Position.X.Offset
                            TS:Create(e.card, TweenInfo.new(0.18), {
                                Position = UDim2.new(0, x + (goingRight and -300 or 300), 0, 10)
                            }):Play()
                        end
                        task.delay(0.14, function()
                            if myToken ~= switchToken then return end
                            for _, e in ipairs(outList) do
                                if e.card.Parent then e.card.Visible = false end
                            end
                        end)
                    else
                        for _, e in ipairs(outList) do e.card.Visible = false end
                    end

                    layoutCat(cat, goingRight, animate)
                    local idx = (cat == "Bat") and 1 or 2
                    TS:Create(slide, TweenInfo.new(0.2), {Position = UDim2.new(0.25 + 0.5 * (idx - 1), 0, 0.5, 0)}):Play()
                    for i, lbl in ipairs(catLabels) do
                        TS:Create(lbl, TweenInfo.new(0.16), {
                            TextColor3 = (i == idx) and Color3.fromRGB(5, 18, 50) or WHITE,
                            TextTransparency = (i == idx) and 0 or 0.35,
                        }):Play()
                    end
                end

                for i, c in ipairs(CATS) do
                    local clickTab = Instance.new("TextButton", tabsHolder)
                    clickTab.BackgroundTransparency = 1
                    clickTab.Text = ""
                    clickTab.AutoButtonColor = false
                    clickTab.AnchorPoint = Vector2.new(0.5, 0.5)
                    clickTab.Size = UDim2.new(0.5, 0, 1, 0)
                    clickTab.Position = UDim2.new(0.25 + 0.5 * (i - 1), 0, 0.5, 0)
                    clickTab.ZIndex = 8
                    local key = c.key
                    clickTab.MouseButton1Click:Connect(function() setCat(key, true) end)
                end

                backdrop.MouseButton1Click:Connect(closeCTPicker)

                task.defer(function()
                    for _, e in ipairs(cards) do e.card.Visible = false end
                    setCat("Bat", false)
                end)

                frame.Size = UDim2.new(0, 0, 0, 0)
                frame.Position = UDim2.new(0.5, 0, 0.5, 0)
                TS:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 420, 0, 470),
                    Position = UDim2.new(0.5, -210, 0.5, -235)
                }):Play()
            end)
        end

        mkToggle(sfVisual, "Transparent Tools", function(on)
            if _G.AmbitiousTransparentTools then pcall(function() _G.AmbitiousTransparentTools.setEnabled(on) end) end
            saveConfig()
        end, _G.AmbitiousTransparentToolsEnabled == true)

        -- ---------------- RADIUS CIRCLE ----------------
        mkSect(sfVisual, "Radius Circle")
        mkToggle(sfVisual, "Radius Circle", function(on)
            if _G.SoundSetRadiusCircle then pcall(_G.SoundSetRadiusCircle, on) end
            saveConfig()
        end, _G.SoundRadiusCircleEnabled == true)
        mkBoxRow(sfVisual, "Circle Radius", _G.SoundRadiusCircleRadius or 8, function(v)
            if _G.SoundSetRadiusCircleRadius then pcall(_G.SoundSetRadiusCircleRadius, v) end
            saveConfig()
        end)

        -- Colour picker vero: barra Hue + quadrato Saturation/Value, con
        -- anteprima dal vivo. Niente piu' tre caselle di numeri.
        do
            local row = mkRow(sfVisual)
            mkLabel(row, "Circle Colour")
            row.Size = UDim2.new(ROW_W, 0, 0, 36)

            local swatch = Instance.new("TextButton", row)
            swatch.Size = UDim2.new(0, 54, 0, 24)
            swatch.Position = UDim2.new(1, -60, 0.5, -12)
            swatch.BackgroundColor3 = _G.SoundRadiusCircleColor or Color3.fromRGB(230, 201, 255)
            swatch.BorderSizePixel = 0
            swatch.Text = ""
            swatch.AutoButtonColor = false
            swatch.ZIndex = 6
            Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 7)
            local swStroke = Instance.new("UIStroke", swatch)
            swStroke.Color = WHITE; swStroke.Thickness = 1.4; swStroke.Transparency = 0.15

            -- Stato HSV, inizializzato dal colore salvato
            local h, sat, val = (_G.SoundRadiusCircleColor or Color3.fromRGB(230, 201, 255)):ToHSV()
            local pickerGui = nil

            local function applyColour()
                local c = Color3.fromHSV(h, sat, val)
                swatch.BackgroundColor3 = c
                if _G.SoundSetRadiusCircleColor then pcall(_G.SoundSetRadiusCircleColor, c) end
            end

            local function closePicker()
                if pickerGui then pcall(function() pickerGui:Destroy() end); pickerGui = nil end
                saveConfig()
            end

            local function openPicker()
                if pickerGui then closePicker(); return end

                pickerGui = Instance.new("ScreenGui")
                pickerGui.Name = "SoundRadiusColourPicker"
                pickerGui.ResetOnSpawn = false
                pickerGui.IgnoreGuiInset = true
                pickerGui.DisplayOrder = 9999
                pickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                if not pcall(function() pickerGui.Parent = game:GetService("CoreGui") end) then
                    pickerGui.Parent = LP:WaitForChild("PlayerGui")
                end

                local backdrop = Instance.new("TextButton", pickerGui)
                backdrop.Size = UDim2.new(1, 0, 1, 0)
                backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                backdrop.BackgroundTransparency = 0.5
                backdrop.BorderSizePixel = 0
                backdrop.Text = ""
                backdrop.AutoButtonColor = false
                backdrop.ZIndex = 1

                local panel = Instance.new("Frame", pickerGui)
                panel.Size = UDim2.new(0, 280, 0, 300)
                panel.Position = UDim2.new(0.5, -140, 0.5, -150)
                panel.BackgroundColor3 = DARK
                panel.BorderSizePixel = 0
                panel.ZIndex = 2
                Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
                local pStroke = Instance.new("UIStroke", panel)
                pStroke.Color = WHITE; pStroke.Thickness = 1.4; pStroke.Transparency = 0.3

                local title = Instance.new("TextLabel", panel)
                title.Size = UDim2.new(1, -20, 0, 34)
                title.Position = UDim2.new(0, 14, 0, 4)
                title.BackgroundTransparency = 1
                title.Text = "RADIUS CIRCLE COLOUR"
                title.TextColor3 = WHITE
                title.Font = Enum.Font.GothamBlack
                title.TextSize = 14
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.ZIndex = 3

                local closeBtn = Instance.new("TextButton", panel)
                closeBtn.Size = UDim2.new(0, 26, 0, 26)
                closeBtn.Position = UDim2.new(1, -34, 0, 8)
                closeBtn.BackgroundColor3 = Color3.fromRGB(9, 18, 38)
                closeBtn.BorderSizePixel = 0
                closeBtn.Text = "X"
                closeBtn.TextColor3 = WHITE
                closeBtn.Font = Enum.Font.GothamBlack
                closeBtn.TextSize = 13
                closeBtn.AutoButtonColor = false
                closeBtn.ZIndex = 4
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

                -- ---- Quadrato Saturation / Value ----
                local sv = Instance.new("ImageLabel", panel)
                sv.Size = UDim2.new(0, 252, 0, 150)
                sv.Position = UDim2.new(0, 14, 0, 42)
                sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                sv.BorderSizePixel = 0
                sv.ZIndex = 3
                Instance.new("UICorner", sv).CornerRadius = UDim.new(0, 8)

                -- bianco -> trasparente (orizzontale)
                local whiteGrad = Instance.new("Frame", sv)
                whiteGrad.Size = UDim2.new(1, 0, 1, 0)
                whiteGrad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                whiteGrad.BorderSizePixel = 0
                whiteGrad.ZIndex = 4
                Instance.new("UICorner", whiteGrad).CornerRadius = UDim.new(0, 8)
                local wg = Instance.new("UIGradient", whiteGrad)
                wg.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                })

                -- nero -> trasparente (verticale)
                local blackGrad = Instance.new("Frame", sv)
                blackGrad.Size = UDim2.new(1, 0, 1, 0)
                blackGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                blackGrad.BorderSizePixel = 0
                blackGrad.ZIndex = 5
                Instance.new("UICorner", blackGrad).CornerRadius = UDim.new(0, 8)
                local bg = Instance.new("UIGradient", blackGrad)
                bg.Rotation = 90
                bg.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0),
                })

                local svDot = Instance.new("Frame", sv)
                svDot.Size = UDim2.new(0, 12, 0, 12)
                svDot.AnchorPoint = Vector2.new(0.5, 0.5)
                svDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                svDot.BorderSizePixel = 0
                svDot.ZIndex = 7
                Instance.new("UICorner", svDot).CornerRadius = UDim.new(1, 0)
                local dotStroke = Instance.new("UIStroke", svDot)
                dotStroke.Color = Color3.fromRGB(0, 0, 0); dotStroke.Thickness = 1.6

                -- ---- Barra Hue ----
                local hueBar = Instance.new("Frame", panel)
                hueBar.Size = UDim2.new(0, 252, 0, 22)
                hueBar.Position = UDim2.new(0, 14, 0, 202)
                hueBar.BorderSizePixel = 0
                hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                hueBar.ZIndex = 3
                Instance.new("UICorner", hueBar).CornerRadius = UDim.new(0, 7)
                local hueGrad = Instance.new("UIGradient", hueBar)
                local hueKeys = {}
                for i = 0, 6 do
                    table.insert(hueKeys, ColorSequenceKeypoint.new(i/6, Color3.fromHSV(i/6, 1, 1)))
                end
                hueGrad.Color = ColorSequence.new(hueKeys)

                local hueDot = Instance.new("Frame", hueBar)
                hueDot.Size = UDim2.new(0, 6, 1, 6)
                hueDot.AnchorPoint = Vector2.new(0.5, 0.5)
                hueDot.Position = UDim2.new(h, 0, 0.5, 0)
                hueDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                hueDot.BorderSizePixel = 0
                hueDot.ZIndex = 5
                Instance.new("UICorner", hueDot).CornerRadius = UDim.new(0, 3)
                local hueDotStroke = Instance.new("UIStroke", hueDot)
                hueDotStroke.Color = Color3.fromRGB(0, 0, 0); hueDotStroke.Thickness = 1.4

                -- ---- Anteprima ----
                local preview = Instance.new("Frame", panel)
                preview.Size = UDim2.new(0, 252, 0, 40)
                preview.Position = UDim2.new(0, 14, 0, 236)
                preview.BorderSizePixel = 0
                preview.ZIndex = 3
                Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 8)
                local prevStroke = Instance.new("UIStroke", preview)
                prevStroke.Color = WHITE; prevStroke.Thickness = 1.2; prevStroke.Transparency = 0.4

                local hexLabel = Instance.new("TextLabel", preview)
                hexLabel.Size = UDim2.new(1, 0, 1, 0)
                hexLabel.BackgroundTransparency = 1
                hexLabel.Font = Enum.Font.GothamBlack
                hexLabel.TextSize = 15
                hexLabel.ZIndex = 4

                local function refreshUI()
                    local c = Color3.fromHSV(h, sat, val)
                    sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    svDot.Position = UDim2.new(sat, 0, 1 - val, 0)
                    hueDot.Position = UDim2.new(h, 0, 0.5, 0)
                    preview.BackgroundColor3 = c
                    local r8 = math.floor(c.R*255+0.5)
                    local g8 = math.floor(c.G*255+0.5)
                    local b8 = math.floor(c.B*255+0.5)
                    hexLabel.Text = string.format("#%02X%02X%02X   (%d, %d, %d)", r8, g8, b8, r8, g8, b8)
                    -- testo leggibile su qualunque sfondo
                    local lum = 0.299*c.R + 0.587*c.G + 0.114*c.B
                    hexLabel.TextColor3 = lum > 0.55 and Color3.fromRGB(5, 16, 42) or Color3.fromRGB(255,255,255)
                    applyColour()
                end

                -- ---- Input drag ----
                local UIS = game:GetService("UserInputService")

                local function bindDrag(frame, onMove)
                    local dragging = false
                    local function handle(input)
                        local abs, size = frame.AbsolutePosition, frame.AbsoluteSize
                        local px = math.clamp((input.Position.X - abs.X) / size.X, 0, 1)
                        local py = math.clamp((input.Position.Y - abs.Y) / size.Y, 0, 1)
                        onMove(px, py)
                    end
                    frame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true; handle(input)
                        end
                    end)
                    frame.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false; saveConfig()
                        end
                    end)
                    UIS.InputChanged:Connect(function(input)
                        if not dragging then return end
                        if input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch then
                            handle(input)
                        end
                    end)
                    UIS.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                            if dragging then dragging = false; saveConfig() end
                        end
                    end)
                end

                bindDrag(sv, function(px, py) sat = px; val = 1 - py; refreshUI() end)
                bindDrag(hueBar, function(px, _) h = px; refreshUI() end)

                closeBtn.MouseButton1Click:Connect(closePicker)
                backdrop.MouseButton1Click:Connect(closePicker)

                refreshUI()

                panel.Size = UDim2.new(0, 0, 0, 0)
                panel.Position = UDim2.new(0.5, 0, 0.5, 0)
                TS:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 280, 0, 300),
                    Position = UDim2.new(0.5, -140, 0.5, -150),
                }):Play()
            end

            swatch.MouseButton1Click:Connect(openPicker)
        end

    end
    -- =================== END AMBITIOUS PORTS (GUI ROWS) ===================


    -- ============================================================
    -- FONTS (Visuals): dropdown with 10 fonts. Changes the font of
    -- this menu, the steal bar, the mobile buttons AND the game's
    -- own text (PlayerGui + billboard/surface text). "Default"
    -- puts every original font back.
    -- ============================================================
    mkSect(sfVisual, "Fonts")
    do
        local PlayersS_ = game:GetService("Players")
        local CoreGui_  = game:GetService("CoreGui")
        local FONT_LIST = {
            {"Default (original)", nil},
            {"Sci-Fi",        "SciFi"},
            {"Arcade",        "Arcade"},
            {"Bangers",       "Bangers"},
            {"Indie Flower",  "IndieFlower"},   -- cursive / handwritten
            {"Kalam",         "Kalam"},         -- cursive / handwritten
            {"Fondamento",    "Fondamento"},    -- calligraphy
            {"Merriweather",  "Merriweather"},  -- serif, straight
            {"Special Elite", "SpecialElite"},  -- typewriter
            {"Oswald",        "Oswald"},        -- tall, straight
            {"Nunito",        "Nunito"},        -- clean, rounded, straight
        }
        local OURS = {
            ["Sound Hub"]=true, ["StealBarGui"]=true, ["VynxMobileButtons"]=true,
            ["HorizonHubMobileButtons"]=true, ["SoundHubMobileButtons"]=true,
            ["HorizonWelcomeToast"]=true, ["SoundCustomToolsPicker"]=true,
            ["SoundRadiusColourPicker"]=true, ["yousefStealBar"]=true, ["yousefRagdollTimer"]=true,
        }
        local origFont = setmetatable({}, {__mode = "k"})
        local currentFont = nil        -- Enum.Font or nil (= originals)
        local currentIdx = 1

        local function isText(o)
            return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
        end
        local function applyTo(o)
            if not isText(o) or o:GetAttribute("KeepFont") then return end
            if origFont[o] == nil then origFont[o] = o.Font end
            local target = currentFont or origFont[o]
            if o.Font ~= target then pcall(function() o.Font = target end) end
        end
        local function isOursObj(o)
            local g = o:FindFirstAncestorOfClass("ScreenGui")
            return g ~= nil and OURS[g.Name] == true
        end
        local function inGameBillboard(o)
            return o:FindFirstAncestorOfClass("BillboardGui") ~= nil or o:FindFirstAncestorOfClass("SurfaceGui") ~= nil
        end

        local function applyAll()
            task.spawn(function()
                local n = 0
                local function walk(root)
                    for _, d in ipairs(root:GetDescendants()) do
                        applyTo(d)
                        n = n + 1
                        if n % 800 == 0 then task.wait() end
                    end
                end
                pcall(walk, gui)
                pcall(function()
                    local pg = PlayersS_.LocalPlayer:FindFirstChild("PlayerGui")
                    if pg then walk(pg) end
                end)
                pcall(function()
                    for _, g in ipairs(CoreGui_:GetChildren()) do
                        if OURS[g.Name] then walk(g) end
                    end
                end)
                pcall(function()
                    for _, d in ipairs(workspace:GetDescendants()) do
                        if isText(d) and inGameBillboard(d) then applyTo(d) end
                        n = n + 1
                        if n % 1500 == 0 then task.wait() end
                    end
                end)
            end)
        end

        -- keep new text (menus, popups, game UI) in the chosen font
        pcall(function()
            local pg = PlayersS_.LocalPlayer:WaitForChild("PlayerGui", 5)
            if pg then pg.DescendantAdded:Connect(function(o) if currentFont or origFont[o] then applyTo(o) end end) end
        end)
        pcall(function()
            CoreGui_.DescendantAdded:Connect(function(o)
                if currentFont and isText(o) and isOursObj(o) then applyTo(o) end
            end)
        end)
        pcall(function()
            gui.DescendantAdded:Connect(function(o) if currentFont then applyTo(o) end end)
        end)
        pcall(function()
            workspace.DescendantAdded:Connect(function(o)
                if currentFont and isText(o) and inGameBillboard(o) then applyTo(o) end
            end)
        end)

        local function setFont(idx)
            currentIdx = idx
            local entry = FONT_LIST[idx]
            local ok, f = pcall(function() return entry[2] and Enum.Font[entry[2]] or nil end)
            currentFont = ok and f or nil
            pcall(function() writefile("horizon_font.txt", entry[2] or "") end)
            applyAll()
        end

        -- ---------- dropdown UI ----------
        local ITEM_H, HEAD_H = 28, 34
        local row = mkRow(sfVisual)
        mkLabel(row, "Font")
        row.ClipsDescendants = true

        local head = Instance.new("TextButton", row)
        head.Size = UDim2.new(0, 160, 0, 26); head.Position = UDim2.new(1, -162, 0, 4)
        head.BackgroundColor3 = Color3.fromRGB(4, 9, 20); head.BackgroundTransparency = 0.04
        head.BorderSizePixel = 0; head.AutoButtonColor = false; head.Text = ""
        head.ZIndex = 8
        Instance.new("UICorner", head).CornerRadius = UDim.new(0, 8)
        local headStroke = Instance.new("UIStroke", head)
        headStroke.Color = BLUE_GLOW; headStroke.Transparency = 0.35

        local headTxt = Instance.new("TextLabel", head)
        headTxt.BackgroundTransparency = 1; headTxt.Size = UDim2.new(1, -30, 1, 0)
        headTxt.Position = UDim2.new(0, 10, 0, 0); headTxt.Text = FONT_LIST[1][1]
        headTxt.TextColor3 = WHITE; headTxt.TextSize = 13; headTxt.Font = Enum.Font.GothamSemibold
        headTxt.TextXAlignment = Enum.TextXAlignment.Left; headTxt.ZIndex = 9

        local arrow = Instance.new("TextLabel", head)
        arrow:SetAttribute("KeepFont", true)
        arrow.BackgroundTransparency = 1; arrow.Size = UDim2.new(0, 24, 1, 0)
        arrow.Position = UDim2.new(1, -26, 0, -1); arrow.Text = "v"
        arrow.TextColor3 = CYAN_SECT; arrow.TextSize = 16; arrow.Font = Enum.Font.GothamBold
        arrow.ZIndex = 9

        local list = Instance.new("Frame", row)
        list.Position = UDim2.new(0, 0, 0, HEAD_H + 4)
        list.Size = UDim2.new(1, 0, 0, #FONT_LIST * ITEM_H)
        list.BackgroundTransparency = 1; list.Visible = false; list.ZIndex = 7

        local itemBtns = {}
        local function refreshSel()
            for i, b in ipairs(itemBtns) do
                local sel = (i == currentIdx)
                b.BackgroundColor3 = sel and PILL_ON or Color3.fromRGB(4, 9, 20)
                b.BackgroundTransparency = sel and 0.12 or 0.25
            end
            headTxt.Text = FONT_LIST[currentIdx][1]
        end

        local open = false
        local function setOpen(v)
            open = v
            list.Visible = v
            arrow.Text = v and "^" or "v"
            row.Size = UDim2.new(ROW_W, 0, 0, v and (HEAD_H + 8 + #FONT_LIST * ITEM_H) or HEAD_H)
        end

        for i, entry in ipairs(FONT_LIST) do
            local b = Instance.new("TextButton", list)
            b:SetAttribute("KeepFont", true) -- each name is shown in its own font
            b.Size = UDim2.new(1, -4, 0, ITEM_H - 3)
            b.Position = UDim2.new(0, 2, 0, (i - 1) * ITEM_H)
            b.BorderSizePixel = 0; b.AutoButtonColor = false
            b.Text = entry[1]; b.TextColor3 = WHITE; b.TextSize = 17
            b.TextXAlignment = Enum.TextXAlignment.Left
            local okf, fe = pcall(function() return entry[2] and Enum.Font[entry[2]] or Enum.Font.GothamSemibold end)
            b.Font = okf and fe or Enum.Font.GothamSemibold
            b.ZIndex = 8
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
            local pad = Instance.new("UIPadding", b); pad.PaddingLeft = UDim.new(0, 12)
            itemBtns[i] = b
            b.MouseButton1Click:Connect(function()
                setFont(i); refreshSel(); setOpen(false)
            end)
        end
        head.MouseButton1Click:Connect(function() setOpen(not open) end)
        setOpen(false)
        refreshSel()

        -- restore the saved font
        pcall(function()
            if isfile and isfile("horizon_font.txt") then
                local saved = readfile("horizon_font.txt")
                for i, entry in ipairs(FONT_LIST) do
                    if entry[2] and entry[2] == saved then setFont(i); refreshSel() break end
                end
            end
        end)
    end

    mkSect(sfVisual, "Sky Theme")
    do
        local skyThemes = SKY_PRESETS_LIST or {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Tech", "Sakura", "Pink Night", "Blood Moon", "Emerald Dawn", "Volcanic", "Arctic", "Midnight Ocean", "Vaporwave", "Toxic", "Solar Eclipse", "Hellscape", "Heaven", "Storm", "Sunrise", "Deep Space", "Lavender Dream", "Inferno", "Mint Sky"}
        local skyIndex = 1
        for i, name in ipairs(skyThemes) do if name == __HH.currentSkyTheme then skyIndex = i break end end
        
        local row = mkRow(sfVisual); mkLabel(row, "Sky Theme")
        row.Size = UDim2.new(ROW_W, 0, 0, 42)
        row.ClipsDescendants = true
        
        local left = Instance.new("TextButton", row)
        left.BackgroundColor3 = Color3.fromRGB(4, 9, 20); left.BackgroundTransparency = 0.04
        left.Text = "<"; left.TextColor3 = Color3.fromRGB(230, 201, 255); left.TextSize = 14
        left.Font = Enum.Font.GothamSemibold; left.Size = UDim2.new(0, 42, 0, 28)
        left.Position = UDim2.new(1, -186, 0.5, -14); left.BorderSizePixel = 0; left.ZIndex = 8
        Instance.new("UICorner", left).CornerRadius = UDim.new(0, 8)
        local leftStroke = Instance.new("UIStroke", left); leftStroke.Color = Color3.fromRGB(49, 66, 105); leftStroke.Transparency = 0.42
        
        local holder = Instance.new("Frame", row)
        holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0); holder.BackgroundTransparency = 0.28
        holder.Size = UDim2.new(0, 92, 0, 28); holder.Position = UDim2.new(1, -139, 0.5, -14); holder.ClipsDescendants = true; holder.ZIndex = 7
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 8)
        local holderStroke = Instance.new("UIStroke", holder); holderStroke.Color = Color3.fromRGB(230, 201, 255); holderStroke.Transparency = 0.35
        
        skyValueLabel = Instance.new("TextLabel", holder)
        skyValueLabel.BackgroundTransparency = 1; skyValueLabel.Text = skyThemes[skyIndex]
        skyValueLabel.TextColor3 = Color3.fromRGB(230, 201, 255); skyValueLabel.TextSize = 13
        skyValueLabel.Font = Enum.Font.GothamSemibold; skyValueLabel.Size = UDim2.new(1, 0, 1, 0); skyValueLabel.ZIndex = 9
        skyValueLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        local right = Instance.new("TextButton", row)
        right.BackgroundColor3 = Color3.fromRGB(4, 9, 20); right.BackgroundTransparency = 0.04
        right.Text = ">"; right.TextColor3 = Color3.fromRGB(230, 201, 255); right.TextSize = 14
        right.Font = Enum.Font.GothamSemibold; right.Size = UDim2.new(0, 42, 0, 28)
        right.Position = UDim2.new(1, -42, 0.5, -14); right.BorderSizePixel = 0; right.ZIndex = 8
        Instance.new("UICorner", right).CornerRadius = UDim.new(0, 8)
        local rightStroke = Instance.new("UIStroke", right); rightStroke.Color = Color3.fromRGB(49, 66, 105); rightStroke.Transparency = 0.42
        
        local function setSkyIndex(nextIndex)
            if nextIndex < 1 then nextIndex = #skyThemes end
            if nextIndex > #skyThemes then nextIndex = 1 end
            skyIndex = nextIndex
            __HH.currentSkyTheme = skyThemes[skyIndex]
            if type(applySkyTheme) == "function" then applySkyTheme(__HH.currentSkyTheme) end
            if skyValueLabel then skyValueLabel.Text = __HH.currentSkyTheme end
            saveConfig()
        end
        left.MouseButton1Click:Connect(function() setSkyIndex(skyIndex - 1) end)
        right.MouseButton1Click:Connect(function() setSkyIndex(skyIndex + 1) end)
    end


    do
        local row = mkRow(sfExtra)
        mkLabel(row, "Animation Changer")
        row.ZIndex = 10

        local pillBtn = Instance.new("TextButton", row)
        pillBtn.Size = UDim2.new(0, 62, 0, 26)
        pillBtn.Position = UDim2.new(1, -64, 0.5, -13)
        pillBtn.BackgroundColor3 = CHECK_OFF
        pillBtn.BackgroundTransparency = 0.08
        pillBtn.BorderSizePixel = 0
        pillBtn.Text = ""
        pillBtn.AutoButtonColor = false
        pillBtn.ZIndex = 5
        Instance.new("UICorner", pillBtn).CornerRadius = UDim.new(1, 0)
        local pillStroke = Instance.new("UIStroke", pillBtn)
        pillStroke.Color = BLUE_GLOW
        pillStroke.Thickness = 1.3
        pillStroke.Transparency = 0.16

        local valueLabel = Instance.new("TextLabel", pillBtn)
        valueLabel.Size = UDim2.new(1, -24, 1, 0)
        valueLabel.Position = UDim2.new(0, 6, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.TextColor3 = WHITE
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 11
        valueLabel.TextXAlignment = Enum.TextXAlignment.Center
        valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
        valueLabel.ZIndex = 6

        local knob = Instance.new("Frame", pillBtn)
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(1, -22, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(245, 250, 255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 6
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function refreshAcePackLabel()
            local pack = tostring(__HH.aceSelectedAnimationPack or "OFF")
            valueLabel.Text = pack
            local isOff = (pack:upper() == "OFF")
            pillBtn.BackgroundColor3 = isOff and CHECK_OFF or PILL_ON
        end
        local function setAcePack(index)
            if index < 1 then index = #__HH.aceAnimationPackList end
            if index > #__HH.aceAnimationPackList then index = 1 end
            __HH.aceAnimationPackIndex = index
            __HH.aceSelectedAnimationPack = __HH.aceAnimationPackList[index]
            refreshAcePackLabel()
            pcall(function() __HH.aceApplyAnimationPack(__HH.aceSelectedAnimationPack) end)
            saveConfig()
        end

        __HH.aceSyncAnimationPackIndex()
        refreshAcePackLabel()
        pillBtn.MouseButton1Click:Connect(function()
            setAcePack((__HH.aceAnimationPackIndex or 1) + 1)
        end)
    end

    mkSect(sfExtra, "Songs")
    for _, track in ipairs(HorizonSongTracks) do
        mkToggle(sfExtra, track.name, function(on)
            if on then playHorizonSong(track) else stopHorizonSong() end
        end, false)
    end

    mkSect(sfExtra, "Performance")
    mkToggle(sfExtra, "Nuke Optimizer", function(on)
        if on then
            pcall(function()
                Lighting.GlobalShadows = false; Lighting.FogEnd = 9e9
                Lighting.EnvironmentDiffuseScale = 0; Lighting.EnvironmentSpecularScale = 0
                for _, e in ipairs(Lighting:GetChildren()) do
                    if e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("Atmosphere") or e:IsA("Clouds") then
                        e:Destroy()
                    end
                end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
                        pcall(function() obj:Destroy() end)
                    end
                    if obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character) then
                        pcall(function() obj.CastShadow = false end)
                    end
                end
            end)
        end; saveConfig()
    end, false)

    do
        local scaleRow = mkRow(sfExtra)
        local scaleHolder = Instance.new("Frame", scaleRow)
        scaleHolder.Size = UDim2.new(0, 152, 0, 28)
        scaleHolder.Position = UDim2.new(0, 0, 0.5, -14)
        scaleHolder.BackgroundColor3 = INP_BG
        scaleHolder.BackgroundTransparency = 0.18
        scaleHolder.BorderSizePixel = 0
        scaleHolder.ZIndex = 5
        Instance.new("UICorner", scaleHolder).CornerRadius = UDim.new(0, 8)
        local shStroke = Instance.new("UIStroke", scaleHolder)
        shStroke.Color = Color3.fromRGB(69, 88, 134)
        shStroke.Thickness = 1.1
        shStroke.Transparency = 0.25

        local scaleTb = Instance.new("TextBox", scaleHolder)
        scaleTb.Size = UDim2.new(0, 64, 1, 0)
        scaleTb.Position = UDim2.new(0, 10, 0, 0)
        scaleTb.BackgroundTransparency = 1
        scaleTb.Text = tostring(math.floor(uiScaleValue * 10 + 0.5))
        scaleTb.TextColor3 = WHITE
        scaleTb.Font = Enum.Font.GothamSemibold
        scaleTb.TextSize = 14
        scaleTb.TextXAlignment = Enum.TextXAlignment.Left
        scaleTb.ClearTextOnFocus = false
        scaleTb.ZIndex = 6

        local scaleCaption = Instance.new("TextLabel", scaleHolder)
        scaleCaption.Size = UDim2.new(0, 74, 1, 0)
        scaleCaption.Position = UDim2.new(1, -82, 0, 0)
        scaleCaption.BackgroundTransparency = 1
        scaleCaption.Text = "GUI Scale"
        scaleCaption.TextColor3 = Color3.fromRGB(226, 205, 244)
        scaleCaption.Font = Enum.Font.GothamMedium
        scaleCaption.TextSize = 13
        scaleCaption.TextXAlignment = Enum.TextXAlignment.Right
        scaleCaption.ZIndex = 6

        scaleTb.Focused:Connect(function()
            TS:Create(shStroke, TweenInfo.new(0.12), {Color = BLUE_GLOW, Transparency = 0}):Play()
        end)
        scaleTb.FocusLost:Connect(function()
            TS:Create(shStroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(69, 88, 134), Transparency = 0.25}):Play()
            -- Box shows 1 - 10 (10 = full size); real UIScale is value / 10.
            local v = tonumber(scaleTb.Text)
            if v and v >= 1 and v <= 10 then
                uiScaleValue = v / 10
                if __HH.uiScaleObject then __HH.uiScaleObject.Scale = uiScaleValue end
                scaleTb.Text = tostring(math.floor(v * 10 + 0.5) / 10)
                saveConfig()
            else
                scaleTb.Text = tostring(math.floor(uiScaleValue * 10 + 0.5))
            end
        end)
    end

    local devLbl
    do
        local row = mkRow(sfExtra)
        mkLabel(row, "Current Device")
        local devBadge = Instance.new("TextButton", row)
        devBadge.Size = UDim2.new(0, 106, 0, 26)
        devBadge.Position = UDim2.new(1, -108, 0.5, -13)
        devBadge.Text = __HH.selectedDevice or "MOBILE"
        devBadge.TextSize = 13
        devBadge.AutoButtonColor = false
        devBadge.ZIndex = 5
        styleCapsuleBtn(devBadge, false)
        devLbl = devBadge

        mkSect(sfExtra, "Mobile")
        local resetRow = mkRow(sfExtra)
        mkLabel(resetRow, "Reset Device")
        local resetDevBtn = Instance.new("TextButton", resetRow)
        resetDevBtn.Size = UDim2.new(0, 106, 0, 26)
        resetDevBtn.Position = UDim2.new(1, -108, 0.5, -13)
        resetDevBtn.Text = "Reset Device"
        resetDevBtn.TextSize = 13
        resetDevBtn.AutoButtonColor = false
        resetDevBtn.ZIndex = 5
        styleCapsuleBtn(resetDevBtn, true)
        resetDevBtn.MouseButton1Click:Connect(function()
            if __HH.runDeviceSelection then
                __HH.mainFrame.Visible = false
                __HH.runDeviceSelection(true)
                if devLbl then devLbl.Text = __HH.selectedDevice or "MOBILE" end
                __HH.mainFrame.Visible = true
            end
        end)
    end

    do
        local copyRow = mkRow(sfExtra)
        mkLabel(copyRow, "Copy Config")
        local copyBtn = Instance.new("TextButton", copyRow)
        copyBtn.Size = UDim2.new(0, 106, 0, 26)
        copyBtn.Position = UDim2.new(1, -108, 0.5, -13)
        copyBtn.Text = "Copy Config"
        copyBtn.TextSize = 13
        copyBtn.AutoButtonColor = false
        copyBtn.ZIndex = 5
        styleCapsuleBtn(copyBtn, true)

        local loadRow = mkRow(sfExtra)
        mkLabel(loadRow, "Load Config")
        local loadInput = Instance.new("TextBox", loadRow)
        loadInput.Size = UDim2.new(0, 118, 0, 24); loadInput.Position = UDim2.new(1, -184, 0.5, -12)
        loadInput.BackgroundColor3 = INP_BG; loadInput.PlaceholderText = "paste code"
        loadInput.Text = ""; loadInput.ClearTextOnFocus = false
        loadInput.TextColor3 = WHITE; loadInput.PlaceholderColor3 = Color3.fromRGB(111, 133, 183)
        loadInput.Font = Enum.Font.GothamSemibold; loadInput.TextSize = 11; loadInput.ZIndex = 5
        loadInput.ClipsDescendants = true
        Instance.new("UICorner", loadInput).CornerRadius = UDim.new(0, 7)
        local loadInputStroke = Instance.new("UIStroke", loadInput); loadInputStroke.Color = DIM_LINE; loadInputStroke.Thickness = 1.1; loadInputStroke.Transparency = 0.25

        local loadBtn = Instance.new("TextButton", loadRow)
        loadBtn.Size = UDim2.new(0, 60, 0, 24); loadBtn.Position = UDim2.new(1, -62, 0.5, -12)
        loadBtn.Text = "Load"; loadBtn.TextSize = 12
        loadBtn.AutoButtonColor = false; loadBtn.ZIndex = 5
        styleCapsuleBtn(loadBtn, true)

        local statusRow = mkRow(sfExtra)
        local statusLbl = Instance.new("TextLabel", statusRow)
        statusLbl.Size = UDim2.new(1, 0, 1, 0); statusLbl.BackgroundTransparency = 1
        statusLbl.Text = ""; statusLbl.TextColor3 = CYAN_SECT
        statusLbl.Font = Enum.Font.GothamBold; statusLbl.TextSize = 12
        statusLbl.TextXAlignment = Enum.TextXAlignment.Left; statusLbl.ZIndex = 5

        local function flashStatus(msg)
            statusLbl.Text = msg
            task.delay(3, function() if statusLbl.Text == msg then statusLbl.Text = "" end end)
        end

        copyBtn.MouseButton1Click:Connect(function()
            local ok, codeStr = pcall(function() return __HH.encodeConfigCode(__HH.buildConfigTable()) end)
            if ok and codeStr then
                local copied = false
                pcall(function()
                    if setclipboard then setclipboard(codeStr); copied = true
                    elseif toclipboard then toclipboard(codeStr); copied = true end
                end)
                if copied then
                    flashStatus("Config copied to clipboard!")
                else
                    loadInput.Text = codeStr
                    flashStatus("Clipboard unsupported - code placed in box above.")
                end
            else
                flashStatus("Failed to build config code.")
            end
        end)

        loadBtn.MouseButton1Click:Connect(function()
            local raw = loadInput.Text
            if not raw or raw == "" then flashStatus("Paste a config code first."); return end
            local ok, cfg = pcall(function() return __HH.decodeConfigCode(raw) end)
            if ok and type(cfg) == "table" then
                loadConfig(cfg)
                applyState()
                if __HH.mobileButtonsEnabled and buildMobileButtons then task.spawn(buildMobileButtons)
                elseif destroyMobileButtons then destroyMobileButtons() end
                if devLbl then devLbl.Text = __HH.selectedDevice or "MOBILE" end
                flashStatus("Config loaded successfully!")
                task.delay(0.3, function()
                    pcall(function()
                        if __HH.mainFrame then __HH.mainFrame:Destroy() end
                        buildGui()
                        applyState()
                        if __HH.mobileButtonsEnabled and buildMobileButtons then task.spawn(buildMobileButtons)
                        elseif destroyMobileButtons then destroyMobileButtons() end
                        if __HH.mainFrame then __HH.mainFrame.Visible = true end
                    end)
                end)
            else
                flashStatus("Invalid config code.")
            end
        end)

        local resetAllRow = mkRow(sfExtra)
        mkLabel(resetAllRow, "Reset All Settings")
        local resetAllBtn = Instance.new("TextButton", resetAllRow)
        resetAllBtn.Size = UDim2.new(0, 106, 0, 26); resetAllBtn.Position = UDim2.new(1, -108, 0.5, -13)
        resetAllBtn.Text = "Reset All"; resetAllBtn.TextSize = 13
        resetAllBtn.AutoButtonColor = false; resetAllBtn.ZIndex = 5
        styleCapsuleBtn(resetAllBtn, true)
        wireResetAllButton(resetAllBtn, "Reset All", flashStatus)
    end

    -- ─── Mobile Tab ─────────────────────────────────────────────────────────
    do
        mkSect(sfMobile, "Button Visibility")
        local mobBtnDefs = {
            {key="drop",         label="DROP BR"},
            {key="tpDown",       label="TP DOWN"},
            {key="batV2",        label="AIM BOT"},
            {key="tpLock",       label="TP BAT"},
            {key="lagger",       label="LAGGER"},
            {key="laggerCarry",  label="LAGGER CARRY"},
            {key="carrySpeed",   label="CARRY SPD"},
            {key="instaReset",   label="INSTA RESET"},
            {key="autoLeft",     label="AUTO LEFT"},
            {key="autoRight",    label="AUTO RIGHT"},
        }
        for _, def in ipairs(mobBtnDefs) do
            local key = def.key
            mkToggle(sfMobile, def.label, function(on)
                __HH.buttonVisibility[key] = on
                if __HH.mobileButtonsEnabled then buildMobileButtons() end
                saveConfig()
            end, __HH.buttonVisibility[key] ~= false)
        end

        -- ─── Mobile Settings ─────────────────────────────────────────────────
        mkSect(sfMobile, "Mobile Settings")

        local mobShowSet = mkToggle(sfMobile, "Show Mobile UI", function(on)
            __HH.mobileButtonsEnabled = on
            if on then buildMobileButtons() else destroyMobileButtons() end
            if setMobVisual then setMobVisual(on) end
            saveConfig()
        end, __HH.mobileButtonsEnabled)

        mkBoxRow(sfMobile, "Btn Size", __HH.mobileButtonsSize, function(v)
            if v >= 10 and v <= 200 then
                __HH.mobileButtonsSize = v
                if __HH.mobileButtonsEnabled then buildMobileButtons() end
                saveConfig()
            end
        end)

        local mobDragSet = mkToggle(sfMobile, "Btn Drag Per Btn", function(on)
            __HH.perButtonDragEnabled = on
            if __HH.mobileButtonsEnabled then buildMobileButtons() end
            saveConfig()
        end, __HH.perButtonDragEnabled)

        local mobLockSet = mkToggle(sfMobile, "Lock UI", function(on)
            __HH.uiLocked = on
            _G.YousefUiLocked = on
            if setLockVisual then setLockVisual(on) end
            saveConfig()
        end, __HH.uiLocked)

        do
            local row = mkRow(sfMobile); mkLabel(row, "Reset Mobile Btns")
            local resetBtn = Instance.new("TextButton", row)
            resetBtn.Size = UDim2.new(0,60,0,20); resetBtn.Position = UDim2.new(1,-65,0.5,-10)
            resetBtn.BackgroundColor3 = BTN_ACT; resetBtn.BorderSizePixel = 0
            resetBtn.Text = "Reset"; resetBtn.TextColor3 = WHITE
            resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 11
            resetBtn.AutoButtonColor = false; resetBtn.ZIndex = 5
            Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,5)
            local rStroke = Instance.new("UIStroke", resetBtn); rStroke.Color = WHITE; rStroke.Thickness = 1
            resetBtn.MouseButton1Click:Connect(function()
                resetBtnPositions()
                TS:Create(resetBtn, TweenInfo.new(0.1), {BackgroundColor3=WHITE}):Play()
                task.delay(0.15, function()
                    TS:Create(resetBtn, TweenInfo.new(0.1), {BackgroundColor3=BTN_ACT}):Play()
                end)
            end)
        end

        -- ─── Reset All Settings (Mobile tab copy) ──────────────────────────────
        -- Same shared reset as the Extra tab's button — every toggle, speed,
        -- keybind and mobile setting goes back to default. Kept here too so
        -- it's reachable straight from the Mobile tab without switching tabs.
        do
            local mobResetAllRow = mkRow(sfMobile)
            mkLabel(mobResetAllRow, "Reset All Settings")
            local mobResetAllBtn = Instance.new("TextButton", mobResetAllRow)
            mobResetAllBtn.Size = UDim2.new(0,90,0,20); mobResetAllBtn.Position = UDim2.new(1,-95,0.5,-10)
            mobResetAllBtn.BackgroundColor3 = Color3.fromRGB(72, 118, 224); mobResetAllBtn.BorderSizePixel = 0
            mobResetAllBtn.Text = "Reset All"; mobResetAllBtn.TextColor3 = WHITE
            mobResetAllBtn.Font = Enum.Font.GothamBold; mobResetAllBtn.TextSize = 12
            mobResetAllBtn.AutoButtonColor = false; mobResetAllBtn.ZIndex = 5
            Instance.new("UICorner", mobResetAllBtn).CornerRadius = UDim.new(0,5)
            local mobResetAllStroke = Instance.new("UIStroke", mobResetAllBtn); mobResetAllStroke.Color = WHITE; mobResetAllStroke.Thickness = 1

            local mobResetStatusRow = mkRow(sfMobile)
            local mobResetStatusLbl = Instance.new("TextLabel", mobResetStatusRow)
            mobResetStatusLbl.Size = UDim2.new(1,0,1,0); mobResetStatusLbl.BackgroundTransparency = 1
            mobResetStatusLbl.Text = ""; mobResetStatusLbl.TextColor3 = BTN_ACT
            mobResetStatusLbl.Font = Enum.Font.GothamBold; mobResetStatusLbl.TextSize = 12
            mobResetStatusLbl.TextXAlignment = Enum.TextXAlignment.Left; mobResetStatusLbl.ZIndex = 5
            local function mobFlashStatus(msg)
                mobResetStatusLbl.Text = msg
                task.delay(3, function() if mobResetStatusLbl.Text == msg then mobResetStatusLbl.Text = "" end end)
            end

            wireResetAllButton(mobResetAllBtn, "Reset All", mobFlashStatus)
        end

    end

    __HH.mainFrame.Visible = false
    miniToggleBtn.Visible = false
    
    print("Sound Hub GUI Fully Loaded")


end

loadConfig()
-- Force the requested main-panel settings after loading any saved config.
uiScaleValue = 0.7
__HH.guiSizeValue = 2
if __HH.uiScaleObject then __HH.uiScaleObject.Scale = 0.7 end
if __HH.mainFrame then __HH.mainFrame.Size = UDim2.new(0, 430, 0, 450) end

-- ============================================================
-- DEVICE SELECTION (PC / MOBILE / CONTROLLER)
-- ============================================================
-- Shows a full-screen picker the first time the script ever runs (or again
-- after "Reset Device" is pressed from the Extra tab). PC and Controller
-- both hide the floating mobile buttons and rely on keybinds / gamepad
-- buttons; Mobile shows the floating buttons normally.
do
    local DEV_ICE   = Color3.fromRGB(230, 201, 255)
    local DEV_ACCENT= Color3.fromRGB(162, 180, 224)
    local DEV_NAVY  = Color3.fromRGB(8, 24, 62)
    local DEV_DARK  = Color3.fromRGB(16, 6, 25)

    -- Small toast shown when the config is reset.
    local function showWelcomeToast()
        print("[FOCUS DUELS] Config Successfully Resetted!")
        pcall(function()
            local coreGui = game:GetService("CoreGui")
            local playerGui = LP:WaitForChild("PlayerGui")
            local old = coreGui:FindFirstChild("HorizonWelcomeToast") or playerGui:FindFirstChild("HorizonWelcomeToast")
            if old then old:Destroy() end

            local toastGui = Instance.new("ScreenGui")
            toastGui.Name = "HorizonWelcomeToast"
            toastGui.ResetOnSpawn = false
            toastGui.IgnoreGuiInset = true
            toastGui.DisplayOrder = 2147483646
            if not pcall(function() toastGui.Parent = coreGui end) then
                toastGui.Parent = playerGui
            end

            local card = Instance.new("Frame", toastGui)
            card.AnchorPoint = Vector2.new(0.5, 0)
            card.Position = UDim2.new(0.5, 0, 0, 24)
            card.Size = UDim2.new(0, 360, 0, 44)
            card.BackgroundColor3 = DEV_DARK
            card.BackgroundTransparency = 0.05
            card.BorderSizePixel = 0
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
            local cardStroke = Instance.new("UIStroke", card)
            cardStroke.Color = DEV_ACCENT; cardStroke.Thickness = 1.4; cardStroke.Transparency = 0.15

            local lbl = Instance.new("TextLabel", card)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, -16, 1, 0)
            lbl.Position = UDim2.new(0, 8, 0, 0)
            lbl.Text = "[FOCUS DUELS] Config Successfully Resetted!"
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = 15
            lbl.TextColor3 = DEV_ICE
            lbl.TextXAlignment = Enum.TextXAlignment.Center

            card.BackgroundTransparency = 1
            cardStroke.Transparency = 1
            lbl.TextTransparency = 1
            local TSvc = game:GetService("TweenService")
            TSvc:Create(card, TweenInfo.new(0.25), {BackgroundTransparency = 0.05}):Play()
            TSvc:Create(cardStroke, TweenInfo.new(0.25), {Transparency = 0.15}):Play()
            TSvc:Create(lbl, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
            task.delay(2.6, function()
                if not toastGui.Parent then return end
                TSvc:Create(card, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                TSvc:Create(cardStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
                TSvc:Create(lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                task.delay(0.35, function() pcall(function() toastGui:Destroy() end) end)
            end)
        end)
    end
    __HH.showWelcomeToast = showWelcomeToast

    -- Same picker structure/behaviour as the original source (backdrop +
    -- centered card + row of mode buttons, MouseButton1Click sets the
    -- selection and destroys the GUI, then a blocking wait returns the
    -- result) — only the name, the color scheme (ice blue instead of
    -- white/black) and a third "CONTROLLER" button were added/changed.
    local function choosePlatformMode()
        -- Device picker removed: always MOBILE, no UI
        return "MOBILE"
    end
    __HH.choosePlatformMode = choosePlatformMode

    -- Runs the picker (if needed) and applies the resulting device choice.
    -- force = true always re-shows the picker (used by "Reset Device").
    __HH.runDeviceSelection = function(force)
        -- Device selection is permanently locked to MOBILE. This also makes
        -- the Extra-tab "Reset Device" action return to MOBILE without a picker.
        __HH.selectedDevice = "MOBILE"
        __HH.mobileButtonsEnabled = true
        saveConfig()
        if __HH.mobGuiRef then
            if buildMobileButtons then
                task.spawn(buildMobileButtons)
            end
        end
        if setMobVisual then pcall(setMobVisual, true) end
        if force then showWelcomeToast() end
        return "MOBILE"
    end
end

-- Ask the player which device they're on before anything else shows up.
-- Runs once ever (persisted in VynxPC.json); "Reset Device" in the Extra
-- tab re-triggers this with force=true.
if __HH.runDeviceSelection then __HH.runDeviceSelection(false) end

do
    buildGui()
    _G.HorizonHubIntroFinished = true
    -- The grab progress HUD only appears after the intro finishes.
    pcall(function()
        local stealGui = game:GetService("CoreGui"):FindFirstChild("StealBarGui")
            or LP:WaitForChild("PlayerGui"):FindFirstChild("StealBarGui")
        if stealGui then stealGui.Enabled = true end
    end)
    if __HH.mainFrame then __HH.mainFrame.Visible = true end
    if __HH.mobileButtonsEnabled then task.spawn(buildMobileButtons) end
    applyState()

    -- ===== Ambitious ports: applica lo stato salvato all'avvio =====
    task.spawn(function()
        pcall(function()
            if _G.SoundXRayEnabled and setXRay then setXRay(true) end
        end)
        pcall(function()
            if _G.AmbitiousBrainrotXRayEnabled and _G.AmbitiousSetBrainrotXRay then
                _G.AmbitiousSetBrainrotXRay(true)
            end
        end)
        pcall(function()
            if _G.AmbitiousCustomToolsEnabled and _G.AmbitiousCustomTools then
                _G.AmbitiousCustomTools.setEnabled(true)
                -- Riapplica le skin salvate agli strumenti gia' in mano:
                -- setEnabled costruisce le repliche con la skin corrente, ma
                -- se il tool era gia' agganciato serve un giro esplicito.
                task.delay(0.6, function()
                    pcall(function()
                        for cat, key in pairs(_G.AmbitiousCustomToolSkins or {}) do
                            if _G.AmbitiousSetCustomToolSkin then
                                _G.AmbitiousSetCustomToolSkin(cat, key)
                            end
                        end
                        if _G.AmbitiousCustomToolsRecheck then
                            _G.AmbitiousCustomToolsRecheck()
                        end
                    end)
                end)
            end
        end)
        pcall(function()
            if _G.AmbitiousRainbowToolsEnabled and _G.AmbitiousRainbowTools then
                _G.AmbitiousRainbowTools.setEnabled(true)
            end
        end)
        pcall(function()
            if _G.AmbitiousTransparentToolsEnabled and _G.AmbitiousTransparentTools then
                _G.AmbitiousTransparentTools.setEnabled(true)
            end
        end)
        pcall(function()
            if _G.AmbitiousCustomSoundsEnabled and _G.AmbitiousCustomSounds then
                _G.AmbitiousCustomSounds.setEnabled(true)
            end
        end)
        pcall(function()
            if _G.AmbitiousRainbowJoystickEnabled and _G.AmbitiousSetRainbowJoystick then
                _G.AmbitiousSetRainbowJoystick(true)
            end
        end)
        pcall(function()
            if _G.SoundRadiusCircleEnabled and _G.SoundSetRadiusCircle then
                _G.SoundSetRadiusCircle(true)
            end
        end)
        pcall(function()
            if _G.SoundAvatarChanger and _G.SoundAvatarChanger.applyAll then
                _G.SoundAvatarChanger.applyAll()
            end
        end)
    end)
    task.spawn(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                task.spawn(function()
                    if plr.Character then createPlayerSpeedLabel(plr)
                    else plr.CharacterAdded:Wait(); createPlayerSpeedLabel(plr) end
                end)
            end
        end
    end)
    print("Sound Hub Fully Loaded")
end

end

task.spawn(function()
	local _rs = game:GetService("RunService")
	local _p = game:GetService("Players")
	local _lp = _p.LocalPlayer

	local _s = 59
	local _a = false
	local _v = Vector3.zero

	local _mt = getrawmetatable(game)
	setreadonly(_mt, false)

	local _oi = _mt.__index
	local _on = _mt.__newindex

	_mt.__index = newcclosure(function(t, k)
		if not checkcaller() then
			local _tk = tostring(k)
			if _tk == "AssemblyLinearVelocity" or _tk == "Velocity" then
				if typeof(t) == "Instance" and t:IsA("BasePart") then
					local _tn = t.Name
					if _tn == "HumanoidRootPart" or _tn == "Torso" or _tn == "UpperTorso" then
						if t:IsDescendantOf(_lp.Character) then
							return _v
						end
					end
				end
			end
		end
		return _oi(t, k)
	end)

	_mt.__newindex = newcclosure(function(t, k, v)
		if not checkcaller() then
			local _tk = tostring(k)
			if _tk == "AssemblyLinearVelocity" or _tk == "Velocity" then
				if typeof(t) == "Instance" and t:IsA("BasePart") then
					local _tn = t.Name
					if _tn == "HumanoidRootPart" or _tn == "Torso" or _tn == "UpperTorso" then
						if t:IsDescendantOf(_lp.Character) then
							_v = v
							return
						end
					end
				end
			end
		end
		return _on(t, k, v)
	end)

	setreadonly(_mt, true)

	local function _gc()
		local c = _lp.Character
		if not c then return nil, nil, nil end
		local h = c:FindFirstChildOfClass("Humanoid")
		local r = c:FindFirstChild("HumanoidRootPart")
		if h and h.Health > 0 and r then return c, h, r end
		return nil, nil, nil
	end

	local _r = Random.new()
	local _t = 0

	_rs.PreSimulation:Connect(function(d)
		_t = _t + d
		if _t < 0.016 then return end
		_t = 0
		if not _a then return end

		local c, h, r = _gc()
		if not c or not h or not r then return end

		local m = h.MoveDirection
		if m.Magnitude > 0.05 then
			pcall(function()
				if r.SetNetworkOwner then
					r:SetNetworkOwner(_lp)
				end
			end)

			local u = m.Unit
			local jx, jz = _r:NextNumber(-0.003, 0.003), _r:NextNumber(-0.003, 0.003)

			_v = Vector3.new(u.X * 16 + jx, r.AssemblyLinearVelocity.Y, u.Z * 16 + jz)
			r.AssemblyLinearVelocity = Vector3.new(u.X * _s + jx, r.AssemblyLinearVelocity.Y, u.Z * _s + jz)
		else
			_v = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
		end
	end)
end)
-- Remote loader disabled (prevented device picker / external override)
-- task.defer(function() ... railway loader ... end)


]=])()
