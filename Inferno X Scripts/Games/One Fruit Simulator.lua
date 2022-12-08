local Player, Rayfield, Click, comma, Notify, CreateWindow, CurrentVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/main/Inferno%20X%20Scripts/Variables.lua"))()

CurrentVersion("v1.1.0")

local Islands = {"None"}
local Quests = {}
local Mobs = {"Closest Mob"}

for i,v in pairs(game:GetService("Workspace")["__GAME"]["__SpawnLocations"]:GetChildren()) do
	table.insert(Islands, v.Name)
end

for i,v in pairs(game:GetService("Workspace")["__GAME"]["__Quests"]:GetChildren()) do
	table.insert(Quests, v.Head.Icon.TextLabel.Text:split("QUEST ")[2])
end

for i,v in pairs(game:GetService("Workspace")["__GAME"]["__Mobs"]:GetDescendants()) do
	if v:IsA("Model") and not table.find(Mobs, v.Name:gsub("%d", ""):split(" ")[1]) then
		table.insert(Mobs, v.Name:gsub("%d", ""):split(" ")[1])
	end
end

local Window = CreateWindow()

local Main = Window:CreateTab("Main", 4483362458)

Main:CreateSection("Weapons")

Main:CreateButton({
	Name = "🛠 Equip all Tools",
	Info = "Equips all the tools in your backpack",
	Interact = 'equip',
	Callback = function()
		for i,v in pairs(Player.Backpack:GetChildren()) do
			v.Parent = Player.Character
		end
	end,
})

Main:CreateToggle({
	Name = "⚔ Auto Train",
	Info = "Automatically trains with your current item(s)",
	CurrentValue = false,
	Flag = "AutoTrain",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.AutoTrain.CurrentValue then
			for i,Tool in pairs(Player.Character:GetChildren()) do
				if Tool:IsA("Tool") then
					game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\3", "Combat", 1, false, Tool, Tool:GetAttribute("Type")}})
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "💨 Auto Skills",
	Info = "Automatically uses your weapon(s)' skills (Z-B)",
	CurrentValue = false,
	Flag = "AutoSkills",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.AutoSkills.CurrentValue and Player.Character:FindFirstChild("HumanoidRootPart") then
			for _,r in pairs(Player.Character:GetChildren()) do
				if r:IsA("Tool") then
					for i,v in pairs({"Z", "X", "C", "V", "B"}) do
						game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\3", "skillsControl", r.Name, v, "Release", require(game:GetService("ReplicatedStorage").SharedModules.ExtraFunctions).GetCurrentMouse(Player, true, 1200)[1]}})
						task.wait()
					end
				end
			end
		end
	end
end)

Main:CreateSection("Collecting")

Main:CreateToggle({
	Name = "💼 Auto Collect Chests",
	Info = "Automatically collects chests that spawn",
	CurrentValue = false,
	Flag = "AutoChests",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.AutoChests.CurrentValue then
			for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
				if v:FindFirstChild("ChestInteract") then
					local PreviousPosition = Player.Character.HumanoidRootPart.CFrame
					repeat
						Player.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
						fireproximityprompt(v.ChestInteract)
						task.wait()
					until not v or not v:FindFirstChild("ChestInteract")
					Player.Character.HumanoidRootPart.CFrame = PreviousPosition
				end
			end
		end
	end
end)

Main:CreateToggle({
	Name = "🥭 Auto Collect Fruit",
	Info = "Automatically collects fruit that spawn",
	CurrentValue = false,
	Flag = "AutoFruit",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.AutoFruit.CurrentValue then
			for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
				if v:FindFirstChild("Eat") or (not v:IsA("Folder") and v.Name:lower():match("fruit")) then
					local PreviousPosition = Player.Character.HumanoidRootPart.CFrame
					repeat
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChildWhichIsA("BasePart").CFrame
						fireproximityprompt(v.Eat)
						task.wait()
					until not v or not v:FindFirstChild("Eat")
					Player.Character.HumanoidRootPart.CFrame = PreviousPosition
				end
			end
		end
	end
end)

Main:CreateSection("Framerate")

Main:CreateToggle({
	Name = "💥 Disable Effects",
	Info = "Disable effects from skills",
	CurrentValue = false,
	Flag = "Effects",
	Callback = function(Value)	end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Effects.CurrentValue then
			for i,v in pairs(game:GetService("Workspace").Effects:GetChildren()) do
				if not v:IsA("Folder") then
					v:Destroy()
				end
			end

			for i,v in pairs(game:GetService("Workspace").Trees:GetChildren()) do
				v:Destroy()
			end
		end
	end
end)

local Misc = Window:CreateTab("Misc", 4483362458)

Misc:CreateSection("Teleports")

Misc:CreateDropdown({
	Name = "👾 Mob",
	Options = Mobs,
	CurrentOption = "Closest Mob",
	Flag = "SelectedMob",
	Callback = function(Option)	end,
})

Misc:CreateToggle({
	Name = "⚡ Teleport to Mob",
	CurrentValue = false,
	Flag = "MobTeleport",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.MobTeleport.CurrentValue and Player.Character:FindFirstChild("HumanoidRootPart") then
			local CurrentNumber = math.huge
			local Mob

			for i,v in pairs(game:GetService("Workspace")["__GAME"]["__Mobs"]:GetDescendants()) do
				if v:IsA("Model") and v.Name == "NpcModel" then
					if (Rayfield.Flags.SelectedMob.CurrentOption ~= "Closest Mob" and v.Parent.Name:match(Rayfield.Flags.SelectedMob.CurrentOption)) and (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude < CurrentNumber or (Rayfield.Flags.SelectedMob.CurrentOption == "Closest Mob" and (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude < CurrentNumber) then
						CurrentNumber = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
						Mob = v.HumanoidRootPart
					end
				end
			end

			Player.Character.HumanoidRootPart.CFrame = Mob.CFrame + Vector3.new(0, 10, 0)
		end
	end
end)

Misc:CreateDropdown({
	Name = "🏝 Teleport to Island",
	Options = Islands,
	CurrentOption = "None",
	Flag = "SelectedIsland",
	Callback = function(Option)
		if Option ~= "None" then
			Player.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["__GAME"]["__SpawnLocations"]:FindFirstChild(Option).CFrame
		end
	end,
})

Misc:CreateSection("Quests")

Misc:CreateDropdown({
	Name = "📰 Quest",
	Options = Quests,
	CurrentOption = "",
	Flag = "SelectedQuest",
	Callback = function(Option) end,
})

Misc:CreateToggle({
	Name = "📜 Auto Start Quest",
	CurrentValue = false,
	Flag = "Quest",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.Quest.CurrentValue and Rayfield.Flags.SelectedQuest.CurrentOption ~= "" and tostring(Player.PlayerGui.Quests.CurrentQuestContainer.Position):split(",")[1] == "{1.5" then
			for i,v in pairs(game:GetService("Workspace")["__GAME"]["__Quests"]:GetChildren()) do
				if v.Head.Icon.TextLabel.Text:split("QUEST ")[2] == Rayfield.Flags.SelectedQuest.CurrentOption then
					game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\7", "GetQuest", v.Name:split("0")[2]}})
				end
			end
		end
	end
end)

Misc:CreateSection("Storage")

Misc:CreateToggle({
	Name = "🍐 Auto Store Fruit",
	CurrentValue = false,
	Flag = "StoreFruit",
	Callback = function(Value) end,
})

task.spawn(function()
	while task.wait() do
		if Rayfield.Flags.StoreFruit.CurrentValue then
			for i,v in pairs(Player.Backpack:GetChildren()) do
				if v.Name:lower():match("fruit") and v:FindFirstChildWhichIsA("BasePart") then
					v.Parent = Player.Character
					game:GetService("ReplicatedStorage").RemoteEvent:FireServer({{"\3", "EatFruit", v, "Storage"}})
				end
			end
		end
	end
end)