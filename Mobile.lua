local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
repeat wait() until player.Character

local character = player.Character
local root = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local recording = false
local playing = false
local looping = false
local recordData = {}

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TinyTask"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0, 30, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
frame.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 25)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "TinyTask Mobile"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.Gotham

local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -30, 0, 5)
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 8)

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 80, 0, 30)
openBtn.Position = UDim2.new(0, 20, 0, 80)
openBtn.Text = "OPEN"
openBtn.Visible = false
openBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 18
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 10)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

minimize.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

local function makeButton(name, text, y)
	local btn = Instance.new("TextButton", frame)
	btn.Name = name
	btn.Text = text
	btn.Size = UDim2.new(0.9, 0, 0, 30)
	btn.Position = UDim2.new(0.05, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 18
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local recordBtn = makeButton("Record", "Record", 40)
local playBtn = makeButton("Play", "Play", 75)
local loopBtn = makeButton("Loop", "Loop", 110)
local stopBtn = makeButton("Stop", "Stop", 145)

recordBtn.MouseButton1Click:Connect(function()
	if recording then
		recording = false
		recordBtn.Text = "Record"
	else
		recording = true
		recordData = {}
		recordBtn.Text = "Stop"
		local start = tick()
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not recording then conn:Disconnect() return end
			local t = tick() - start
			table.insert(recordData, {
				time = t,
				cf = root.CFrame,
				cam = camera.CFrame
			})
		end)
	end
end)

local function playOnce()
	if playing or #recordData == 0 then return end
	playing = true
	character = player.Character
	root = character:WaitForChild("HumanoidRootPart")
	for i = 1, #recordData do
		if not playing then break end
		local current = recordData[i]
		local waitTime = i == 1 and 0 or (recordData[i].time - recordData[i - 1].time)
		wait(waitTime)
		character:SetPrimaryPartCFrame(current.cf)
		camera.CFrame = current.cam
	end
	playing = false
end

playBtn.MouseButton1Click:Connect(function()
	if playing then return end
	coroutine.wrap(playOnce)()
end)

loopBtn.MouseButton1Click:Connect(function()
	if looping then return end
	looping = true
	coroutine.wrap(function()
		while looping do
			playOnce()
			wait(0.1)
		end
	end)()
end)

stopBtn.MouseButton1Click:Connect(function()
	recording = false
	playing = false
	looping = false
end)

local creditGui = Instance.new("TextLabel", frame)
creditGui.Size = UDim2.new(1, -10, 0, 20)
creditGui.Position = UDim2.new(0, 5, 1, -25)
creditGui.BackgroundTransparency = 1
creditGui.Text = "Made by Musa"
creditGui.TextSize = 16
creditGui.Font = Enum.Font.GothamBold
creditGui.TextColor3 = Color3.fromRGB(255, 255, 255)
creditGui.TextStrokeTransparency = 0.6
creditGui.TextXAlignment = Enum.TextXAlignment.Left

local creditCorner = Instance.new("TextLabel", gui)
creditCorner.Size = UDim2.new(0, 150, 0, 25)
creditCorner.Position = UDim2.new(1, -160, 1, -35)
creditCorner.BackgroundTransparency = 1
creditCorner.Text = "Made by Musa"
creditCorner.TextSize = 16
creditCorner.Font = Enum.Font.GothamBold
creditCorner.TextColor3 = Color3.fromRGB(255, 255, 255)
creditCorner.TextStrokeTransparency = 0.6
creditCorner.TextXAlignment = Enum.TextXAlignment.Right

coroutine.wrap(function()
	while true do
		local t = tick()
		local r = math.sin(t * 2) * 127 + 128
		local g = math.sin(t * 2 + 2) * 127 + 128
		local b = math.sin(t * 2 + 4) * 127 + 128
		local color = Color3.fromRGB(r, g, b)
		creditGui.TextColor3 = color
		creditCorner.TextColor3 = color
		RunService.RenderStepped:Wait()
	end
end)()
