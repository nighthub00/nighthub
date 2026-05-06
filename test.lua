-- ================= NIGHT HUB GUI (WindUI) =================
print("--===== Night HUB LOADED (WindUI) =====--")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- ================= LOAD WINDUI =================
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- ================= SET FONT (IMPORTANT) =================
WindUI:SetFont("rbxasset://fonts/families/GothamSSm.json")

-- Create the WindUI window
local Window = WindUI:CreateWindow({
    Folder = "NightHub",
    Title = "Night Hub",
    Author = "by gio",
    Icon = "rbxassetid://103326199885496",
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

-- ================= MAIN TAB =================
local MainTab = Window:Tab({ Title = "Main", Icon = "layers-2" })
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
    Callback = function()
        WindUI:Notify({
            Title = "Info",
            Content = "Anti-AFK is always enabled in this script",
            Icon = "info",
            Duration = 2
        })
    end
})

MainSection:Toggle({
    Title = "Auto Reconnect (Always On)",
    Desc = "Automatically reconnect when server shutdown",
    Value = true,
    Callback = function()
        WindUI:Notify({
            Title = "Info",
            Content = "Auto Reconnect is always enabled in this script",
            Icon = "info",
            Duration = 2
        })
    end
})

-- ================= MAIN TAB FUNCTIONALITY =================

-- Anti-AFK
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Auto Reconnect
pcall(function()
    game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == 'ErrorPrompt'
        and child:FindFirstChild('MessageArea')
        and child.MessageArea:FindFirstChild("ErrorFrame") then
            game:GetService("TeleportService"):Teleport(game.PlaceId, player)
        end
    end)
end)

-- ================= SHOP TAB =================
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")
local BuySeedEvent = GameEvents and GameEvents:FindFirstChild("BuySeed") or nil
local BuyGearEvent = GameEvents and GameEvents:FindFirstChild("BuyGear") or nil
local BuyEggEvent = GameEvents and GameEvents:FindFirstChild("BuyEgg") or nil
local BuyMerchantEvent = GameEvents and GameEvents:FindFirstChild("BuyMerchant") or nil

-- Debug logging
print("[Shop Debug] GameEvents found:", GameEvents ~= nil)
print("[Shop Debug] BuySeedEvent found:", BuySeedEvent ~= nil)
print("[Shop Debug] BuyGearEvent found:", BuyGearEvent ~= nil)
print("[Shop Debug] BuyEggEvent found:", BuyEggEvent ~= nil)
print("[Shop Debug] BuyMerchantEvent found:", BuyMerchantEvent ~= nil)

-- List all children in GameEvents if it exists
if GameEvents then
    print("[Shop Debug] GameEvents children:")
    for _, child in ipairs(GameEvents:GetChildren()) do
        print("  - " .. child.Name)
    end
end

local SeedItems = {
    "Carrot","Strawberry","Blueberry","Buttercup","Tomato","Corn",
    "Daffodil","Watermelon","Pumpkin","Apple","Bamboo","Coconut",
    "Cactus","Dragon Fruit","Mango","Grape","Mushroom",
    "Pepper","Cacao","Sunflower","Beanstalk","Ember Lily",
    "Sugar Apple","Burning Bud","Giant Pinecone","Elder Strawberry",
    "Romanesco","Crimson Thorn","Zebrazinkle","Octobloom","Alien Apple"
}

local GearItems = {
    "Watering Can","Trowel","Trading Ticket","Recall Wrench",
    "Basic Sprinkler","Advanced Sprinkler","Medium Treat","Medium Toy",
    "Godly Sprinkler","Magnifying Glass","Master Sprinkler","Cleaning Spray",
    "Favorite Tool","Harvest Tool","Friendship Pot","Levelup Lollipop",
    "Grandmaster Sprinkler","Reclaimer","Tanning Mirror"
}

local EggItems = { "Basic Egg", "Rare Egg", "Legendary Egg" }

local MerchantItems = {
    ["Summer Seed Merchant"] = {"Cauliflower","Rafflesia","Green Apple","Avocado","Banana","Pineapple","Kiwi (Crop)","Bell Pepper","Prickly Pear","Loquat","Feijoa","Pitcher Plant","Common Summer Egg","Rare Summer Egg","Paradise Egg"},
    ["Honey Merchant"] = {"Flower Seed Pack","Honey Sprinkler","Bee Egg","Bee Crate","Honey Crafters Crate"},
    ["Gnome Merchant"] = {"Common Gnome Crate","Farmers Gnome Crate","Classic Gnome Crate","Iconic Gnome Crate"},
    ["Sky Merchant"] = {"Night Staff","Star Collar","Cloud Touch Mutation Spray"},
    ["Fall Merchant"] = {"Fall Seed Packs","Fall Eggs","Red Panda Pet","Various Gears"},
    ["Safari Merchant"] = {"Explorer's Compass","Safari Crates","Seeds","Sprinklers","Mutation Shards","Pets"},
    ["Sprinkler Merchant"] = {"Tropical Mist Sprinkler","Berry Sprinklers"}
}

local function safeFire(event, param)
    if not event then return end
    pcall(function()
        if param ~= nil then
            event:FireServer(param)
        else
            event:FireServer()
        end
    end)
end

local function buyItemLoop(enabledFlag, selected, itemList, event, waitTime)
    task.spawn(function()
        while enabledFlag do
            if event then
                if selected == "ALL" then
                    for _, item in ipairs(itemList) do
                        safeFire(event, item)
                        task.wait(0.25)
                    end
                elseif selected and selected ~= "" then
                    safeFire(event, selected)
                end
            end
            task.wait(waitTime or 2)
        end
    end)
end

-- Seed shop
local SeedSection = ShopTab:Section({ Title = "Seed Shop", Opened = true })
local selectedSeed = nil
local AutoBuySeedSelectedEnabled = false
local AutoBuySeedAllEnabled = false

SeedSection:Dropdown({
    Title = "Select Seed",
    Options = SeedItems,
    Callback = function(opt) selectedSeed = opt end
})
SeedSection:Button({ Title = "Select All", Callback = function() selectedSeed = "ALL" end })
SeedSection:Button({ Title = "Unselect All", Callback = function() selectedSeed = nil end })
SeedSection:Toggle({
    Title = "Auto Buy Selected Seed",
    Value = false,
    Callback = function(state)
        AutoBuySeedSelectedEnabled = state
        if state then
            buyItemLoop(AutoBuySeedSelectedEnabled, selectedSeed, SeedItems, BuySeedEvent, 2)
            WindUI:Notify({ Title = "Seed Shop", Content = "Auto buy selected seed enabled", Icon = "check", Duration = 2 })
        else
            WindUI:Notify({ Title = "Seed Shop", Content = "Auto buy selected seed disabled", Icon = "close", Duration = 2 })
        end
    end
})
SeedSection:Toggle({
    Title = "Auto Buy All Seeds",
    Value = false,
    Callback = function(state)
        AutoBuySeedAllEnabled = state
        if state then
            buyItemLoop(AutoBuySeedAllEnabled, "ALL", SeedItems, BuySeedEvent, 0.5)
            WindUI:Notify({ Title = "Seed Shop", Content = "Auto buy all seeds enabled", Icon = "check", Duration = 2 })
        else
            WindUI:Notify({ Title = "Seed Shop", Content = "Auto buy all seeds disabled", Icon = "close", Duration = 2 })
        end
    end
})

-- Gear shop
local GearSection = ShopTab:Section({ Title = "Gear Shop", Opened = true })
local selectedGear = nil
local AutoBuyGearSelectedEnabled = false
local AutoBuyGearAllEnabled = false

GearSection:Dropdown({
    Title = "Select Gear",
    Options = GearItems,
    Callback = function(opt) selectedGear = opt end
})
GearSection:Button({ Title = "Select All", Callback = function() selectedGear = "ALL" end })
GearSection:Button({ Title = "Unselect All", Callback = function() selectedGear = nil end })
GearSection:Toggle({
    Title = "Auto Buy Selected Gear",
    Value = false,
    Callback = function(state)
        AutoBuyGearSelectedEnabled = state
        if state then
            buyItemLoop(AutoBuyGearSelectedEnabled, selectedGear, GearItems, BuyGearEvent, 2)
            WindUI:Notify({ Title = "Gear Shop", Content = "Auto buy selected gear enabled", Icon = "check", Duration = 2 })
        else
            WindUI:Notify({ Title = "Gear Shop", Content = "Auto buy selected gear disabled", Icon = "close", Duration = 2 })
        end
    end
})
GearSection:Toggle({
    Title = "Auto Buy All Gear",
    Value = false,
    Callback = function(state)
        AutoBuyGearAllEnabled = state
        if state then
            buyItemLoop(AutoBuyGearAllEnabled, "ALL", GearItems, BuyGearEvent, 0.5)
            WindUI:Notify({ Title = "Gear Shop", Content = "Auto buy all gear enabled", Icon = "check", Duration = 2 })
        else
            WindUI:Notify({ Title = "Gear Shop", Content = "Auto buy all gear disabled", Icon = "close", Duration = 2 })
        end
    end
})

-- Egg shop
local EggSection = ShopTab:Section({ Title = "Egg Shop", Opened = true })
local selectedEgg = nil
local AutoBuyEggSelectedEnabled = false
local AutoBuyEggAllEnabled = false

EggSection:Dropdown({
    Title = "Select Egg",
    Options = EggItems,
    Callback = function(opt) selectedEgg = opt end
})
EggSection:Button({ Title = "Select All", Callback = function() selectedEgg = "ALL" end })
EggSection:Button({ Title = "Unselect All", Callback = function() selectedEgg = nil end })
EggSection:Toggle({
    Title = "Auto Buy Selected Egg",
    Value = false,
    Callback = function(state)
        AutoBuyEggSelectedEnabled = state
        if state then
            buyItemLoop(AutoBuyEggSelectedEnabled, selectedEgg, EggItems, BuyEggEvent, 2)
            WindUI:Notify({ Title = "Egg Shop", Content = "Auto buy selected egg enabled", Icon = "check", Duration = 2 })
        else
            WindUI:Notify({ Title = "Egg Shop", Content = "Auto buy selected egg disabled", Icon = "close", Duration = 2 })
        end
    end
})
EggSection:Toggle({
    Title = "Auto Buy All Eggs",
    Value = false,
    Callback = function(state)
        AutoBuyEggAllEnabled = state
        if state then
            buyItemLoop(AutoBuyEggAllEnabled, "ALL", EggItems, BuyEggEvent, 0.5)
            WindUI:Notify({ Title = "Egg Shop", Content = "Auto buy all eggs enabled", Icon = "check", Duration = 2 })
        else
            WindUI:Notify({ Title = "Egg Shop", Content = "Auto buy all eggs disabled", Icon = "close", Duration = 2 })
        end
    end
})

-- Traveling merchant
local MerchantSection = ShopTab:Section({ Title = "Traveling Merchant", Opened = true })
local selectedMerchantItem = nil
local AutoBuyMerchantEnabled = false

local MerchantOptions = {}
for merchantName in pairs(MerchantItems) do
    table.insert(MerchantOptions, merchantName)
end

MerchantSection:Dropdown({
    Title = "Select Merchant",
    Options = MerchantOptions,
    Callback = function(opt) selectedMerchantItem = opt end
})
MerchantSection:Button({ Title = "Select All", Callback = function() selectedMerchantItem = "ALL" end })
MerchantSection:Button({ Title = "Unselect All", Callback = function() selectedMerchantItem = nil end })
MerchantSection:Toggle({
    Title = "Auto Buy Merchant Items",
    Value = false,
    Callback = function(state)
        AutoBuyMerchantEnabled = state
        if state then
            task.spawn(function()
                while AutoBuyMerchantEnabled do
                    if BuyMerchantEvent then
                        if selectedMerchantItem == "ALL" then
                            for _, items in pairs(MerchantItems) do
                                for _, item in ipairs(items) do
                                    safeFire(BuyMerchantEvent, item)
                                    task.wait(0.25)
                                end
                            end
                        elseif selectedMerchantItem and MerchantItems[selectedMerchantItem] then
                            for _, item in ipairs(MerchantItems[selectedMerchantItem]) do
                                safeFire(BuyMerchantEvent, item)
                                task.wait(0.25)
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
            WindUI:Notify({ Title = "Traveling Merchant", Content = "Auto buy merchant items enabled", Icon = "check", Duration = 2 })
        else
            WindUI:Notify({ Title = "Traveling Merchant", Content = "Auto buy merchant items disabled", Icon = "close", Duration = 2 })
        end
    end
})

