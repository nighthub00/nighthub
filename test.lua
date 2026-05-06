-- ================= Night HUB GUI (WindUI) =================
print("--===== Night HUB LOADED (WindUI) =====--")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- ================= LOAD WINDUI =================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/nighthub00/nighthub/main/test.lua"))()

-- ================= SET FONT (IMPORTANT) =================
-- WindUI text font
WindUI:SetFont("rbxasset://fonts/families/GothamSSm.json")

-- Create the WindUI window
local Window = WindUI:CreateWindow({
    Folder = "Night Hub",
    Title = "Night Hub",
    Author = "by gio",
    Icon = "rbxassetid://140255953349167",
    Theme = "Midnight",
    Size = UDim2.fromOffset(640, 480),
    Draggable = true,
    HasOutline = true,
    Resizable = true,
    Transparent = true,
    User = {
        Enabled = true,
        Anonymous = false,
    },
})

Window:EditOpenButton({
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- Add version tag
Window:Tag({
	Title = "Server: " .. tostring(game.PlaceVersion),
	Icon = "solar:server-bold",
	Color = Color3.fromRGB(255, 105, 180),
	Border = true,
})

local MainTab = Window:Tab({ Title = "Main", Icon = "layers-2" })
local MethodsTab = Window:Tab({ Title = "Methods", Icon = "settings" })
MainTab:Select()

-- Main tab controls
local MainSection = MainTab:Section({ Title = "General", Opened = true })
MainSection:Button({
    Title = "Server Hop",
    Desc = "Find and join another public server",
    Callback = function()
        pcall(function()
            local TeleportService = game:GetService("TeleportService")
            local HttpService2 = game:GetService("HttpService")
            local PlaceId = game.PlaceId
            local JobId = game.JobId
            local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            local body = HttpService2:JSONDecode(req)
            if body and body.data then
                for _, server in pairs(body.data) do
                    if server.id ~= JobId and server.playing < server.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(PlaceId, server.id, player)
                        break
                    end
                end
            end
        end)
    end
})

MainSection:Button({
    Title = "Rejoin",
    Desc = "Rejoin the current place",
    Callback = function()
        pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end)
    end
})

MainSection:Toggle({
    Title = "Anti-AFK (Always On)",
    Desc = "Prevent kicking you in the server",
    Value = true,
    Callback = function() WindUI:Notify({ Title = "Info", Content = "Anti-AFK is always enabled in this script", Icon = "info", Duration = 2 }) end
})

MainSection:Toggle({
    Title = "Auto Reconnect (Always On)",
    Desc = "Automatically reconnect when server shutdown",
    Value = true,
    Callback = function() WindUI:Notify({ Title = "Info", Content = "Auto Reconnect is always enabled in this script", Icon = "info", Duration = 2 }) end
})

-- Methods tab controls (Auto Magpie and options)
local MethodsSection = MethodsTab:Section({ Title = "Auto Magpie", Opened = true})
MethodsSection:Button({
    Title = "Info",
    Desc = "Auto Magpie usage instructions",
    Callback = function()
        WindUI:Notify({
            Title = "Auto Magpie Instructions",
            Content = "Place the pet 1st: 3 mimic, 3 squid, 1 cocktrice and 1 magpie before use this",
            Icon = "info",
            Duration = 8,
        })
    end
})

-- Methods toggles moved below (placed near Auto Magpie variables for correct ordering)

-- Make sure we still remove any previous legacy GUI (keeps file safe)
pcall(function()
    player.PlayerGui:FindFirstChild("XuanHubUI"):Destroy()
end)

-- Legacy GUI removed (full WindUI in use)
local gui = nil -- legacy GUI removed
-- legacy ScreenGui creation removed; WindUI handles GUI parentage

-- Legacy main frame removed (WindUI used instead)
local mainFrame = nil

-- Legacy minimized frame removed
local miniFrame = nil

-- Legacy mini icon/title/expand button removed
local miniIcon, miniTitle, expandBtn = nil, nil, nil

-- Legacy header removed
local header, headerGradient, logo, headerTitle, discordLink, minimizeBtn, closeBtn = nil, nil, nil, nil, nil, nil, nil

-- Legacy sidebar/profile removed
local sidebar, mainTab, methodsTab, profileFrame, avatarIcon, playerName, userName = nil, nil, nil, nil, nil, nil, nil

-- Legacy main content removed
local mainContent, mainListLayout, mainPadding = nil, nil, nil

-- Legacy methods content removed
local methodsContent, methodsListLayout, methodsPadding = nil, nil, nil

-- Legacy auto-reconnect UI removed
local autoReconContainer, autoReconLabel, autoReconToggle, autoReconCircle = nil, nil, nil, nil

-- Legacy anti-afk UI removed
local antiAfkContainer, antiAfkLabel, antiAfkToggle, antiAfkCircle = nil, nil, nil, nil

-- Legacy server actions UI removed (WindUI provides Server Hop & Rejoin buttons)
local serverActionsContainer, serverActionsLabel, serverHopButton, rejoinButton = nil, nil, nil, nil

-- Legacy Auto Magpie UI removed (WindUI MethodsSection provides controls)
local autoMagpieContainer, autoMagpieLabel, infoBtn, openBtn, autoMagpieToggle, autoMagpieCircle = nil, nil, nil, nil, nil, nil

-- Legacy dropdown container removed
local dropdownContainer, dropdownPadding, dropdownLayout = nil, nil, nil

-- Legacy sell option removed
local sellOption, sellLabel, sellToggle, sellCircle = nil, nil, nil, nil

-- Legacy variant option removed
local variantOption, variantLabel, variantToggle, variantCircle = nil, nil, nil, nil

-- Legacy rapid collect option removed
local rapidOption, rapidLabel, rapidToggle, rapidCircle = nil, nil, nil, nil

-- Tab Switching
-- mainTab handled by WindUI; legacy tab switching removed

-- methodsTab handled by WindUI; legacy tab switching removed

-- Button Interactions
-- legacy minimize/expand behavior removed (now managed by WindUI)

-- legacy minimize/expand behavior removed (now managed by WindUI)

-- legacy close button removed (WindUI window controls visibility)



-- ================= MAIN TAB FUNCTIONALITY =================

-- Anti-AFK (Always Enabled - Prevents 20 min AFK kick)
local antiAfkEnabled = true
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
	vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Auto Reconnect (Always Enabled)
local autoReconnectEnabled = true
pcall(function()
	game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
		if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
			game:GetService("TeleportService"):Teleport(game.PlaceId, player)
		end
	end)
end)

-- Auto Reconnect UI removed (setting is always enabled by script)

-- Anti-AFK UI removed (setting is always enabled by script)

-- Legacy Server Hop click handler removed (WindUI Server Hop button handles this)

-- Legacy Rejoin click handler removed (WindUI Rejoin button handles this)

-- Destroy legacy GUI to avoid duplicate UI (WindUI used instead)
pcall(function() if gui then gui:Destroy() end end)



-- ================= METHODS TAB FUNCTIONALITY =================

-- Service Declarations for Methods
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local NotificationEvent = GameEvents:WaitForChild("Notification")
local SellInventoryEvent = GameEvents:WaitForChild("Sell_Inventory")
local feedEvent = GameEvents:FindFirstChild("ActivePetService") or GameEvents:FindFirstChild("PetService")
local SELL_POINT = workspace:WaitForChild("Tutorial_Points"):WaitForChild("Tutorial_Point_2")

-- Farm Manager
local FarmManager = {}
FarmManager.findMyFarm = function()
	for _, farm in ipairs(workspace:WaitForChild("Farm"):GetChildren()) do
		local owner = farm:FindFirstChild("Important")
			and farm.Important:FindFirstChild("Data")
			and farm.Important.Data:FindFirstChild("Owner")
		
		if owner and owner.Value == player.Name then
			return farm
		end
	end
	return nil
end

FarmManager.mFarm = FarmManager.findMyFarm()
if not FarmManager.mFarm then
	warn("Farm not found")
else
	FarmManager.Plants_Physical = FarmManager.mFarm:WaitForChild("Important"):WaitForChild("Plants_Physical")
	FarmManager.Get_Plants_Physical_Objects = function()
		return FarmManager.Plants_Physical:GetChildren()
	end
end

-- Fruit Collector Machine
local _FruitCollectorMachine = {}
local _S = {
	collectEvent = GameEvents:WaitForChild("Crops"):WaitForChild("Collect")
}

local FOtherSettings = {
	g_fruit_weight_min = 0,
	g_fruit_weight_max = 99,
}

-- Allowed fruit variants
local AllowedVariants = {
	Gold = true,
	Rainbow = true,
	Diamond = true,
	Silver = true,
}

-- Feature flags (moved earlier so collector logic can read them)
local VariantCollectEnabled = false -- when true: collect only allowed variants
local RapidCollectEnabled = false
local RapidCollectThread = nil

-- Helper: Check if fruit has allowed variant
local function HasAllowedVariant(fruit)
	local variantValue = fruit:FindFirstChild("Variant")
	if variantValue and variantValue:IsA("StringValue") then
		if AllowedVariants[variantValue.Value] then
			return true
		end
	end
	return false
end

_FruitCollectorMachine.IsFruitReadyToCollect = function(fruit, bypassready)
	if not fruit then return false end
	if fruit:GetAttribute("Favorited") then return false end

	-- Skip fruits that aren't allowed variants if Variant Collect is enabled
	if VariantCollectEnabled and not HasAllowedVariant(fruit) then
		return false
	end

	local ok, weight = pcall(function()
		return tonumber(fruit.Weight.Value)
	end)
	if not ok then return false end

	if weight < FOtherSettings.g_fruit_weight_min
	or weight > FOtherSettings.g_fruit_weight_max then
		return false
	end

	if bypassready then
		return true
	end

	local maxAge = tonumber(fruit:GetAttribute("MaxAge"))
	if not maxAge then return false end

	local ok2, age = pcall(function()
		return tonumber(fruit.Grow.Age.Value)
	end)
	if not ok2 or age < maxAge then
		return false
	end

	local prompt = fruit:FindFirstChildWhichIsA("ProximityPrompt", true)
	return prompt and prompt.Enabled
end

_FruitCollectorMachine.CollectOneFruit = function()
	if not FarmManager.mFarm then return false end
	
	for _, plant in ipairs(FarmManager.Get_Plants_Physical_Objects()) do
		if plant:IsA("Model") then
			local folder = plant:FindFirstChild("Fruits")
			local candidates = folder and folder:GetChildren() or {plant}

			for _, fruit in ipairs(candidates) do
				if _FruitCollectorMachine.IsFruitReadyToCollect(fruit) then
					_S.collectEvent:FireServer({ fruit })
					return true
				end
			end
		end
	end
	return false
end

_FruitCollectorMachine.CollectFruitByNamesBatchMode = function(fruitNames, maxAmount)
	if not FarmManager.mFarm then return false end
	
	local fruitsToCollect = {}
	maxAmount = maxAmount or 15

	for _, plant in ipairs(FarmManager.Get_Plants_Physical_Objects()) do
		if plant:IsA("Model") and (not fruitNames or fruitNames[plant.Name]) then
			local candidates = {}
			local folder = plant:FindFirstChild("Fruits")
			if folder then
				candidates = folder:GetChildren()
			else
				table.insert(candidates, plant)
			end

			for _, fruit in ipairs(candidates) do
				if #fruitsToCollect >= maxAmount then break end
				if _FruitCollectorMachine.IsFruitReadyToCollect(fruit) then
					table.insert(fruitsToCollect, fruit)
				end
			end
		end
	end

	if #fruitsToCollect > 0 then
		_S.collectEvent:FireServer(fruitsToCollect)
		return true
	end

	return false
end

-- Auto Magpie Variables
local AutoMagpieEnabled = false
local AllowSellEnabled = false
local AutoMagpieThread = nil
local DropdownOpen = false

-- Auto Feed Pets variables
local AutoFeedPetsEnabled = false
local AutoFeedPetsThread = nil
local feedInterval = 3 -- seconds between feed attempts (one pet per cycle)
local feedFruits = {
    "Buttercup",
    "Tomato",
    "Coconut",
    "Bone Blossom",
    "BoneBlossom",
    "Blueberry",
    "Beast Buttercup",
    "Bonanza Bloom",
    "Crimson Thorn",
    "Firework Fern",
    "Gingerbread Blossom",
    "Great Pumpkin",
    "Heart Gem",
    "Jungle Cherry",
    "Luminova",
    "Maple Resin",
    "New Years Tinsel",
    "Octobloom",
    "Peppermint Vine",
    "Purple Treeshroom",
    "Reindeer Root",
    "Spirit Sparkle",
    "Star Palm",
    "Taffy Tree",
    "Trinity Fruit",
    "Weeping Branch",
    "Witches Hair",
    "Zebrazinkle",
}

-- Internal pointer for round-robin feeding
local AutoFeedCurrentIndex = 1

-- Helper: feed one owned pet per cycle using available fruit tools
local function startAutoFeedPets()
    if AutoFeedPetsThread then return end
    AutoFeedPetsThread = task.spawn(function()
        while AutoFeedPetsEnabled do
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local backpack = player:FindFirstChild("Backpack")
            if humanoid and backpack and feedEvent then
                -- collect owned pets
                local petsOwned = {}
                for _, petMover in ipairs(workspace:FindFirstChild("PetsPhysical") and workspace.PetsPhysical:GetChildren() or {}) do
                    if petMover:GetAttribute("OWNER") == player.Name then
                        local petUUID = petMover:GetAttribute("UUID")
                        if petUUID then table.insert(petsOwned, petMover) end
                    end
                end

                if #petsOwned > 0 then
                    if AutoFeedCurrentIndex > #petsOwned then AutoFeedCurrentIndex = 1 end
                    local petMover = petsOwned[AutoFeedCurrentIndex]
                    local petUUID = petMover and petMover:GetAttribute("UUID")

                    -- find a suitable fruit tool
                    local fed = false
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool:GetAttribute("b") == "j" then
                            local tname = tool.Name:lower()
                            for _, f in ipairs(feedFruits) do
                                if tname:find(f:lower()) then
                                    pcall(function() humanoid:EquipTool(tool) end)
                                    if petUUID then pcall(function() feedEvent:FireServer("Feed", petUUID) end) end
                                    fed = true
                                    break
                                end
                            end
                        end
                        if fed then break end
                    end

                    -- advance to next pet for next cycle
                    AutoFeedCurrentIndex = AutoFeedCurrentIndex + 1
                    if AutoFeedCurrentIndex > #petsOwned then AutoFeedCurrentIndex = 1 end
                end
            end
            task.wait(feedInterval)
        end
        AutoFeedPetsThread = nil
    end)
end

local function stopAutoFeedPets()
    AutoFeedPetsEnabled = false
    if AutoFeedPetsThread then
        task.cancel(AutoFeedPetsThread)
        AutoFeedPetsThread = nil
    end
end

-- Auto Magpie toggle removed (control the feature via script variables or other UI)

-- Rapid Collect control: spawns a background thread that repeatedly collects in batch mode
local function startRapidCollect()
    if RapidCollectThread then return end
    RapidCollectThread = task.spawn(function()
        while RapidCollectEnabled do
            if FarmManager.mFarm then
                pcall(function()
                    -- batch collect up to 15 fruits (respects VariantCollectEnabled via IsFruitReadyToCollect)
                    _FruitCollectorMachine.CollectFruitByNamesBatchMode(nil, 15)
                end)
            end
            task.wait(1)
        end
        RapidCollectThread = nil
    end)
end

local function stopRapidCollect()
    RapidCollectEnabled = false
    if RapidCollectThread then
        task.cancel(RapidCollectThread)
        RapidCollectThread = nil
    end
end

MethodsSection:Toggle({
    Title = "Auto Collect Variant Fruit",
    Desc = "Collect fruit with variant",
    Value = false,
    Callback = function(state)
        RapidCollectEnabled = state
        if state then
            startRapidCollect()
            WindUI:Notify({ Title = "Auto Collect Variant Fruit", Content = "Enabled", Icon = "check", Duration = 2 })
        else
            stopRapidCollect()
            WindUI:Notify({ Title = "Auto Collect Variant Fruit", Content = "Disabled", Icon = "check", Duration = 2 })
        end
    end
})

MethodsSection:Toggle({
    Title = "Allow Sell when Full",
    Desc = "Automatically sell when backpack is full",
    Value = false,
    Callback = function(state) AllowSellEnabled = state end
})




MethodsSection:Toggle({
    Title = "Auto Feed Pets",
    Desc = "Automatically feed pets",
    Value = false,
    Callback = function(state)
        AutoFeedPetsEnabled = state
        if state then
            WindUI:Notify({ Title = "Auto Feed Pets", Content = "Enabled", Icon = "check", Duration = 2 })
            startAutoFeedPets()
        else
            stopAutoFeedPets()
            WindUI:Notify({ Title = "Auto Feed Pets", Content = "Disabled", Icon = "check", Duration = 2 })
        end
    end
})

-- Show Event Time toggle removed (Surface preview can be enabled via script if desired)

-- Info Button Click
-- legacy info button removed (WindUI provides same info via MethodsSection:Button)

-- Open/Close Dropdown
-- legacy dropdown open/close removed (WindUI handles options)

-- Allow Sell Toggle
-- legacy sell toggle removed (WindUI handles Allow Sell setting)

-- Variant Collect Toggle
-- legacy variant collect toggle removed (WindUI handles Variant Collect setting)

-- Rapid Collect Toggle
-- legacy rapid collect toggle removed (WindUI handles Rapid Collect setting)

-- Auto Magpie Main Toggle
-- legacy AutoMagpie toggle handler removed (WindUI MethodsSection toggle manages AutoMagpieEnabled)

-- Auto Sell Processing (controlled by AllowSellEnabled from dropdown)
local AutoSellProcessing = false
local AutoSellConnection = NotificationEvent.OnClientEvent:Connect(function(message)
	if not AllowSellEnabled then return end
	if AutoSellProcessing then return end
	if typeof(message) ~= "string" then return end

	if message:lower():find("max backpack") then
		AutoSellProcessing = true

		local character = player.Character
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		if not hrp then
			AutoSellProcessing = false
			return
		end

		-- Save position
		local oldCFrame = hrp.CFrame

		-- Teleport to sell
		hrp.CFrame = SELL_POINT.CFrame
		task.wait(1.5)

		-- Sell inventory
		pcall(function()
			SellInventoryEvent:FireServer()
		end)

		task.wait(1)

		-- Return
		if hrp then
			hrp.CFrame = oldCFrame
		end

		AutoSellProcessing = false
	end
end)

-- ================= SHOP TAB =================
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })

-- RemoteEvents (adjust names if different in your game)
local BuySeedEvent = pcall(function() return GameEvents:WaitForChild("BuySeed") end) and GameEvents:WaitForChild("BuySeed") or nil
local BuyGearEvent = pcall(function() return GameEvents:WaitForChild("BuyGear") end) and GameEvents:WaitForChild("BuyGear") or nil
local BuyEggEvent = pcall(function() return GameEvents:WaitForChild("BuyEgg") end) and GameEvents:WaitForChild("BuyEgg") or nil
local BuyMerchantEvent = pcall(function() return GameEvents:WaitForChild("BuyMerchant") end) and GameEvents:WaitForChild("BuyMerchant") or nil

-- ================= SEED SHOP =================
local SeedSection = ShopTab:Section({ Title = "Seed Shop", Opened = true })
local selectedSeed = nil
local AutoBuySeedSelectedEnabled = false
local AutoBuySeedAllEnabled = false

local SeedItems = {
    "Carrot","Strawberry","Blueberry","Buttercup","Tomato","Corn","Daffodil","Watermelon",
    "Pumpkin","Apple","Bamboo","Coconut","Cactus","Dragon Fruit","Mango","Grape","Mushroom",
    "Pepper","Cacao","Sunflower","Beanstalk","Ember Lily","Sugar Apple","Burning Bud",
    "Giant Pinecone","Elder Strawberry","Romanesco","Crimson Thorn","Zebrazinkle",
    "Octobloom","Alien Apple"
}

SeedSection:Dropdown({ Title = "Select Seeds", Options = SeedItems, Callback = function(opt) selectedSeed = opt end })
SeedSection:Button({ Title = "Select All", Callback = function() selectedSeed = "ALL" end })
SeedSection:Button({ Title = "Unselect All", Callback = function() selectedSeed = nil end })

SeedSection:Toggle({
    Title = "Auto Buy Selected",
    Value = false,
    Callback = function(state)
        AutoBuySeedSelectedEnabled = state
        if state then
            task.spawn(function()
                while AutoBuySeedSelectedEnabled do
                    if selectedSeed and selectedSeed ~= "ALL" and BuySeedEvent then
                        pcall(function() BuySeedEvent:FireServer(selectedSeed) end)
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

SeedSection:Toggle({
    Title = "Auto Buy All",
    Value = false,
    Callback = function(state)
        AutoBuySeedAllEnabled = state
        if state then
            task.spawn(function()
                while AutoBuySeedAllEnabled do
                    for _, seed in ipairs(SeedItems) do
                        if not AutoBuySeedAllEnabled then break end
                        if BuySeedEvent then
                            pcall(function() BuySeedEvent:FireServer(seed) end)
                        end
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})

-- ================= GEAR SHOP =================
local GearSection = ShopTab:Section({ Title = "Gear Shop", Opened = true })
local selectedGear = nil
local AutoBuyGearSelectedEnabled = false
local AutoBuyGearAllEnabled = false

local GearItems = {
    "Watering Can","Trowel","Trading Ticket","Recall Wrench","Basic Sprinkler","Advanced Sprinkler",
    "Medium Treat","Medium Toy","Godly Sprinkler","Magnifying Glass","Master Sprinkler","Cleaning Spray",
    "Favorite Tool","Harvest Tool","Friendship Pot","Levelup Lollipop","Grandmaster Sprinkler",
    "Reclaimer","Tanning Mirror"
}

GearSection:Dropdown({ Title = "Select Gears", Options = GearItems, Callback = function(opt) selectedGear = opt end })
GearSection:Button({ Title = "Select All", Callback = function() selectedGear = "ALL" end })
GearSection:Button({ Title = "Unselect All", Callback = function() selectedGear = nil end })

GearSection:Toggle({
    Title = "Auto Buy Selected",
    Value = false,
    Callback = function(state)
        AutoBuyGearSelectedEnabled = state
        if state then
            task.spawn(function()
                while AutoBuyGearSelectedEnabled do
                    if selectedGear and selectedGear ~= "ALL" and BuyGearEvent then
                        pcall(function() BuyGearEvent:FireServer(selectedGear) end)
                    end
                    task.wait(3)
                end
            end)
        end
    end
})

GearSection:Toggle({
    Title = "Auto Buy All",
    Value = false,
    Callback = function(state)
        AutoBuyGearAllEnabled = state
        if state then
            task.spawn(function()
                while AutoBuyGearAllEnabled do
                    for _, gear in ipairs(GearItems) do
                        if not AutoBuyGearAllEnabled then break end
                        if BuyGearEvent then
                            pcall(function() BuyGearEvent:FireServer(gear) end)
                        end
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})

-- ================= EGG SHOP =================
local EggSection = ShopTab:Section({ Title = "Egg Shop", Opened = true })
local selectedEgg = nil
local AutoBuyEggSelectedEnabled = false
local AutoBuyEggAllEnabled = false

local EggItems = { "Basic Egg","Rare Egg","Legendary Egg" }

EggSection:Dropdown({ Title = "Select Eggs", Options = EggItems, Callback = function(opt) selectedEgg = opt end })
EggSection:Button({ Title = "Select All", Callback = function() selectedEgg = "ALL" end })
EggSection:Button({ Title = "Unselect All", Callback = function() selectedEgg = nil end })

EggSection:Toggle({
    Title = "Auto Buy Selected",
    Value = false,
    Callback = function(state)
        AutoBuyEggSelectedEnabled = state
        if state then
            task.spawn(function()
                while AutoBuyEggSelectedEnabled do
                    if selectedEgg and selectedEgg ~= "ALL" and BuyEggEvent then
                        pcall(function() BuyEggEvent:FireServer(selectedEgg) end)
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

EggSection:Toggle({
    Title = "Auto Buy All",
    Value = false,
    Callback = function(state)
        AutoBuyEggAllEnabled = state
        if state then
            task.spawn(function()
                while AutoBuyEggAllEnabled do
                    for _, egg in ipairs(EggItems) do
                        if not AutoBuyEggAllEnabled then break end
                        if BuyEggEvent then
                            pcall(function() BuyEggEvent:FireServer(egg) end)
                        end
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})

-- ================= TRAVELING MERCHANT =================
local MerchantSection = ShopTab:Section({ Title = "Traveling Merchant", Opened = true })
local selectedMerchantItem = nil
local AutoBuyMerchantEnabled = false

local MerchantItems = {
    ["Summer Seed Merchant"] = {
        "Cauliflower","Rafflesia","Green Apple","Avocado","Banana","Pineapple","Kiwi (Crop)",
        "Bell Pepper","Prickly Pear","Loquat","Feijoa","Pitcher Plant",
        "Common Summer Egg","Rare Summer Egg","Paradise Egg"
    },
    ["Honey Merchant"] = {
        "Flower Seed Pack","Honey Sprinkler","Bee Egg","Bee Crate","Honey Crafters Crate"
    },
    ["Gnome Merchant"] = {
        "Common Gnome Crate","Farmers Gnome Crate","Classic Gnome Crate","Iconic Gnome Crate"
    },
    ["Sky Merchant"] = {
        "Night Staff","Star Collar","Cloud Touch Mutation Spray"
    },
    ["Fall Merchant"] = {
        "Fall Seed Packs","Fall Eggs","Red Panda Pet","Various Gears"
    },
    ["Safari Merchant"] = {
        "Explorer's Compass","Safari Crates","Seeds","Sprinklers","Mutation Shards","Pets"
    },
    ["Sprinkler Merchant"] = {
        "Tropical Mist Sprinkler","Berry Sprinklers"
    }
}

MerchantSection:Dropdown({
    Title = "Select Merchant",
    Options = { "Summer Seed Merchant","Honey Merchant","Gnome Merchant","Sky Merchant","Fall Merchant","Safari Merchant","Sprinkler Merchant" },
    Callback = function(opt) selectedMerchantItem = opt end
})
MerchantSection:Button({ Title = "Select All", Callback = function() selectedMerchantItem = "ALL" end })
MerchantSection:Button({ Title = "Unselect All", Callback = function() selectedMerchantItem = nil end })

MerchantSection:Toggle({
    Title = "Auto Buy Traveling Merchant",
    Value = false,
    Callback = function(state)
        AutoBuyMerchantEnabled = state
        if state then
            task.spawn(function()
                while AutoBuyMerchantEnabled do
                    if selectedMerchantItem == "ALL" then
                        for merchant, items in pairs(MerchantItems) do
                            if not AutoBuyMerchantEnabled then break end
                            for _, item in ipairs(items) do
                                if not AutoBuyMerchantEnabled then break end
                                if BuyMerchantEvent then
                                    pcall(function() BuyMerchantEvent:FireServer(item) end)
                                end
                                task.wait(1)
                            end
                        end
                    elseif selectedMerchantItem and MerchantItems[selectedMerchantItem] then
                        for _, item in ipairs(MerchantItems[selectedMerchantItem]) do
                            if not AutoBuyMerchantEnabled then break end
                            if BuyMerchantEvent then
                                pcall(function() BuyMerchantEvent:FireServer(item) end)
                            end
                            task.wait(1)
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    end
})