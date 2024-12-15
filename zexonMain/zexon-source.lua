-- #########################################################
-- ##################### Blacklist Service #################
-- #########################################################
local blacklistedGames = {
    [16732694052] = "Fisch has strong anti-cheat systems", 
    [4111023553] = "Deepwoken has detection measures",
    [9938675423] = "Oaklands might detect this",
    [6403373529] = "Slap Battles has risky anti-cheat",
    [2768379856] = "3008 doesn't allow scripts",
    [13772394625] = "Bladeball might get you banned",
    [2788229376] = "Da Hood has strict protection",
    [9872472334] = "Evade might detect scripts",
    [185655149] = "Bloxburg blocks external scripts",
    [10228136016] = "Fallen Survival has protection"
}

-- #########################################################
-- ##################### Safety Checks ####################
-- #########################################################
local function log(message)
    print("[zexon] " .. message)
end

local function safeGetService(serviceName)
    local success, service = pcall(function()
        return game:GetService(serviceName)
    end)
    if not success then
        log("couldn't get " .. serviceName .. " service :(")
        return nil
    end
    return service
end

-- #########################################################
-- ##################### Initialize Services ##############
-- #########################################################
local Players = safeGetService("Players")
local RunService = safeGetService("RunService")

if not Players or not RunService then
    log("critical services missing, can't continue")
    return
end

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    log("couldn't find local player")
    return
end

-- #########################################################
-- ##################### Blacklist Check #################
-- #########################################################
local placeId = game.PlaceId
if blacklistedGames[placeId] then
    local message = "hey! we had to stop because " .. blacklistedGames[placeId] .. " <3"
    LocalPlayer:Kick(message)
    while true do task.wait() end
end

-- #########################################################
-- ##################### Load Main Script ################
-- #########################################################
log("loading main script...")

local success, content = pcall(function()
    return game:HttpGet('https://pastebin.com/raw/XQp2bfhe')
end)

if not success then
    log("couldn't load script :( error: " .. tostring(content))
    return
end

local ok, err = pcall(loadstring(content))
if not ok then
    log("script failed to start: " .. tostring(err))
    return
end


-- #########################################################
-- ##################### Load Dependencies #################
-- #########################################################
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
-- #########################################################
-- ################# Global Variables ######################
-- #########################################################
local walkspeedValue = 16

-- #########################################################
-- #################### Utility Functions ##################
-- #########################################################
local settingsFile = "zexon-main-config.json"
local defaultSettings = {
    walkspeed = 16,
    autosaveEnabled = false,
    autosaveNotifications = false
}

-- Improved load function
local function loadSettings()
    local success, result = pcall(function()
        if isfile(settingsFile) then
            local json = readfile(settingsFile)
            local decoded = HttpService:JSONDecode(json)
            -- Merge with defaults to ensure all fields exist
            for key, value in pairs(defaultSettings) do
                if decoded[key] == nil then
                    decoded[key] = value
                end
            end
            return decoded
        end
        return defaultSettings
    end)
    
    if success then
        settings = result
    else
        warn("[Zexon] Settings load error:", result)
        settings = defaultSettings
    end
    return settings
end

-- Improved save function
local function saveSettings()
    local success, result = pcall(function()
        local json = HttpService:JSONEncode(settings)
        writefile(settingsFile, json)
    end)
    
    if not success then
        warn("[Zexon] Settings save error:", result)
    end
end

local function applySettings()
    walkspeedValue = settings.walkspeed
    settings.autosaveEnabled = settings.autosaveEnabled or false
    settings.autosaveNotifications = settings.autosaveNotifications or false
end

-- Load settings on startup
loadSettings()
applySettings()

-- #########################################################
-- ######################## UI Setup #######################
-- #########################################################
local uilibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/a-guy-lol/program-project/refs/heads/main/zexonUI.lua"))()
local windowz = uilibrary:CreateWindow("                                                              Zexon V1.3", "(Zyron)", true)




-- #########################################################
-- ######################## Info Page ######################
-- #########################################################

local infoPage = windowz:CreatePage("Info")
local infoSection = infoPage:CreateSection("Zexon - Info")

infoSection:CreateParagraph("welcome to zexon!", [[how's it going!

   Zexon is just a simple lightweight script hub that helps you gain access to many features 😄.
   
   oh btw use Z key to close and open the UI
   
   even though exploiting is fun, we decided to blacklist these games due to their anticheats:
   
   Blacklisted Games:
   - Fisch
   - Deepwoken
   - Oaklands
   - Slap Battles
   - 3008
   - Bladeball
   - Da Hood
   - Evade
   - Bloxburg
   - Fallen Survival
   
   we just want to keep you safe from these evil anti cheats 😔.
]], 22)

local infoSection = infoPage:CreateSection("Zexon - Latest Update")
infoSection:CreateParagraph("Zexon Release V1.3 - 2024 Dec 14", [[
   + Added "Fallen Survival" to the blacklist.
   + Fixed ZexonUI's errors (sometimes pages wouldn't load) 
   + Zexon Cyclone Updates
        - Added collapse button to drop Cyclone Parts
        - New seats noclip for Cyclone to reduce getting flung
        - New X,Y,Z configs
        - Added Crazy Mode toggle for fun
        - Updated player dropdown and FINALLY FIXED THIS..
   + Adjusted fling logic for better consistency.
   Note: Cyclone will be disregarded for some time due to lack of development time. This update took quite a bit cause I wanted to fix all of the current ongoing issuses. It involved a lot of testing but I concluded it and the script is more stable.
]], 12)
infoSection:CreateButton("   Teleport | secret 🤫", function ()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(3397, 1358.871, -125)
    end
end)





-- #########################################################
-- ######################## Main Page ######################
-- #########################################################
local mainPage = windowz:CreatePage("Main")
local mainSection = mainPage:CreateSection("Main - FE")

mainSection:CreateButton("   Execute | Inf Yield", function ()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
mainSection:CreateSlider("   Change WalkSpeed", {Min = 16, Max = 150, DefaultValue = settings.walkspeed}, function(Value)
    local speaker = game.Players.LocalPlayer
    local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
    local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")

    if Char and Human then
        Human.WalkSpeed = Value
    end
    
    -- Update settings immediately
    settings.walkspeed = Value
    saveSettings()
    
    -- Rest of your existing walkspeed code...
end)





-- #########################################################
-- ######################## Fling Players ##################
-- #########################################################
local bugFling = {
    [189707] = true,
    [606849621] = true
}
local targetDropdown, targetCharacter
local placeId = game.PlaceId
local flingSection = mainPage:CreateSection("Fling Players - FE")
local function updateTargetDropdown()
    local playerOptions = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerOptions, player.Name)
        end
    end

    if targetDropdown then
        targetDropdown:Clear()
        targetDropdown:Add(playerOptions)
    end
end
targetDropdown = flingSection:CreateDropdown("Select a Target", {
    List = {},
    Default = nil
}, function(selectedPlayerName)
    local selectedPlayer = Players:FindFirstChild(selectedPlayerName)
    if selectedPlayer and selectedPlayer.Character then
        targetCharacter = selectedPlayer.Character
    else
        targetCharacter = nil
    end
end)
Players.PlayerAdded:Connect(updateTargetDropdown)
Players.PlayerRemoving:Connect(updateTargetDropdown)
updateTargetDropdown()

local function isTargetMoving(TargetRootPart)
    return TargetRootPart.Velocity.Magnitude > 0.5
end
local function randomDecimal(min, max)
    return min + math.random() * (max - min)
end
local function SkidFling(TargetPlayer)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")

    if not (Character and Humanoid and RootPart) then
        return false
    end

    if not (TCharacter and THumanoid and TRootPart) then
        return false
    end
    if not getgenv().OldPos then
        getgenv().OldPos = RootPart.CFrame
    end
    local TargetStartPos = TRootPart.Position
    
    local StartTime = tick()
    local MaxFlingTime = 7.5

    local FPos = function(BasePart, Pos, Ang)
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    local SFBasePart = function(BasePart)
        local Angle = 0

        repeat
            if (TRootPart.Position - TargetStartPos).Magnitude > 100 then
                return true
            end
            if not Humanoid or Humanoid.Health <= 0 then
                return false
            end
            if tick() - StartTime > MaxFlingTime then
                uilibrary:AddNoti("Anti-fling detected", "Target has antifling", 3, true)
                return false
            end
            Angle = Angle + 0
            local moveDirection = TRootPart.Velocity.Unit
            local offset
            if isTargetMoving(TRootPart) then
                local forwardOffset = moveDirection * randomDecimal(-10, 10)
                offset = forwardOffset
            else
                offset = Vector3.new(0, 1, 0)
            end
            FPos(BasePart, CFrame.new(offset) + Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)), CFrame.Angles(math.rad(Angle), 0, 0))
            task.wait()
        until BasePart.Parent ~= TargetPlayer.Character
    end
    workspace.FallenPartsDestroyHeight = math.huge
    local BV = Instance.new("BodyVelocity")
    BV.Name = "FlingVelocity"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    local success = false
    if TRootPart then
        success = SFBasePart(TRootPart)
    elseif THead then
        success = SFBasePart(THead)
    else
        success = false
    end
    BV:Destroy()
    RootPart.Velocity = Vector3.zero
    RootPart.RotVelocity = Vector3.zero
    workspace.FallenPartsDestroyHeight = -500
    RootPart.CFrame = getgenv().OldPos
    task.wait(0.1)
    return success
end
local function FlingAll()
    local players = Players:GetPlayers()
    local totalPlayers = #players - 1
    local flungCount = 0

    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
                uilibrary:AddNoti("Fling All Stopped", "You died during the flinging process.", 3, true)
                break
            end
            if SkidFling(player) then
                flungCount = flungCount + 1
                uilibrary:AddNoti(
                    "Flung Player.",
                    string.format("%d/%d Players flung", flungCount, totalPlayers),
                    3,
                    true
                )
            end
        end
    end
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    if RootPart then
        RootPart.Velocity = Vector3.zero
        RootPart.RotVelocity = Vector3.zero
        RootPart.CFrame = getgenv().OldPos
    end
end
if bugFling[placeId] then
flingSection:CreateButton('   Fling Target   -    Might not work', function()
    if targetCharacter then
        local TargetPlayer = Players:FindFirstChild(targetCharacter.Name)
        if TargetPlayer then
            SkidFling(TargetPlayer)
        end
    end
end)
flingSection:CreateButton('   Fling All     -      Might not work ', function()
    FlingAll()
end)

else
flingSection:CreateButton("   Fling All", function()
    FlingAll()
end)
flingSection:CreateButton("   Fling Target", function()
    if targetCharacter then
        local TargetPlayer = Players:FindFirstChild(targetCharacter.Name)
        if TargetPlayer then
            SkidFling(TargetPlayer)
        end
    end
end)
end





-- #########################################################
-- ######################## Cyclone #######################
-- #########################################################

local CyclonePage = windowz:CreatePage("Cyclone")
local CycloneSection = CyclonePage:CreateSection("Cyclone - FE")
CycloneSection:CreateParagraph("Why did we seperate Cyclone?", [[
   The main reason of seperating Cyclone from the Main script of Zexon was due to Cyclone being patched in some games. In these patched games your character would freeze, so we wanted to make the main script usable if Cyclone was patched.
]], 5)
CycloneSection:CreateButton("   Execute | Cyclone", function ()
    local coreGui = game:GetService("CoreGui")
    if coreGui:FindFirstChild("ZexonUI") then
        coreGui:FindFirstChild("ZexonUI"):Destroy()
    end
    loadstring(game:HttpGet('https://pastebin.com/raw/HYuVwnZK'))()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/a-guy-lol/program-project/refs/heads/main/cyclone-source.lua'))()
 end)






-- #########################################################
-- ################# Custom Game Logic #####################
-- #########################################################
if placeId == 189707 then
    -- Natural Disaster Survival loadstring
    elseif placeID == 142823291 then
        -- Murder mystery loadstring
    else
        local customGame = windowz:CreatePage("Game")
        local customGameSection = customGame:CreateSection("Unknown Game")
        customGameSection:CreateParagraph("Unsupported Game", [[
       This custom game is unsupported. Custom games that we put here have their own exploits to teleport to locations or to do an automation.
       We currently only support:
       - Natural Disaster Survival
       - Murder Mystery 2
       
       More custom games will be added.
    ]], 7)
    end
    








-- #########################################################
-- #################### Settings Logic #####################
-- #########################################################
local settingsPage = windowz:CreatePage("Settings")
local settingsSection = settingsPage:CreateSection("Zexon - Settings")

function loadGetServiceV95()
    local serviceV96 = windowz:CreatePage("ServiceTab - FE")
    local serviceSectionV98 = serviceV96:CreateSection("Service - Settings")
    serviceSectionV98:CreateButton("   Unpack | ServiceV6", function ()
    loadstring(game:HttpGet('https://pastebin.com/raw/c3b0rWf1'))()
    end)
    serviceSectionV98:CreateButton("   Unpack | ServiceV15", function ()
    loadstring(game:HttpGet('https://pastebin.com/raw/2Xk8Tm8r'))()
    end)
end
if getgenv().syLaBgQEIxLMqjOuVhNop3AUXlcDG3 == "3mgSJ9XjIBEmIsFmAdrukvtLWnMQoc6z" then
    loadGetServiceV95()
end
settingsSection:CreateToggle("   Autosave Notifications", {Toggled = settings.autosaveNotifications, Description = "Toggle autosave notifications on/off"}, function(Value)
    settings.autosaveNotifications = Value
    autosaveNotifications = Value
    saveSettings()

end)

settingsSection:CreateToggle("   Enable Autosave", {Toggled = settings.autosaveEnabled, Description = "Enable or disable autosaving configurations"}, function(Value)
    settings.autosaveEnabled = Value 
    saveSettings()
end)

local settingsTerminateSection = settingsPage:CreateSection("Zexon - Terminate")
settingsTerminateSection:CreateButton("Terminate | Zexon Script", function()
    local function safeCleanup()
        local coreGui = game:GetService("CoreGui")
        if coreGui:FindFirstChild("ZexonUI") then
            coreGui:FindFirstChild("ZexonUI"):Destroy()
        end
    end
    safeCleanup()
    print("[zexon] script has been terminated.")
end)

spawn(function()
    while true do
        task.wait(15)
        if settings.autosaveEnabled then
            saveSettings()
            if autosaveNotifications then
                uilibrary:AddNoti("Settings Autosaved.", "Zexon has successfully autosaved your settings.", 5, true)
            end
        end
        
    end
end)
spawn(function()
    task.wait(1)
    uilibrary:AddNoti("UI loaded.", "Zexon has successfully loaded your settings.", 5, true)
end)







-- #########################################################
-- ###################### Release Notes ####################
-- #########################################################

local releasePage = windowz:CreatePage("Releases")

local releasesSection = releasePage:CreateSection("Zexon - Releases")
releasesSection:CreateParagraph("Devlogs", [[
   hey there. 
   Zexon consists of 2 developers. 
   The identities of the developers will be kept private.
   
   
   ~ Happy to say we fixed playerlist bugs.
   ~ We kinda tweaked some tabs and the releases page but eh minor change no need to list.
   ~ We're also looking to add a universal car speed changer if possible and other much unique features.
   
]], 10)




local releaseV130 = releasePage:CreateSection("Zexon (Zyron) | Release V1.3 - 2024 Dec 14")
releaseV130:CreateParagraph("New features and fixes", [[
   + Added "Fallen Survival" to the blacklist.
   + Fixed ZexonUI's errors (sometimes pages wouldn't load) 
   + Zexon Cyclone Updates
        - Added collapse button to drop Cyclone Parts
        - New seats noclip for Cyclone to reduce getting flung
        - New X,Y,Z configs
        - Added Crazy Mode toggle for fun
        - Updated player dropdown and FINALLY FIXED THIS..
   + Adjusted fling logic for better consistency.
   Note: Cyclone will be disregarded for some time due to lack of development time. This update took quite a bit cause I wanted to fix all of the current ongoing issuses. It involved a lot of testing but I concluded it and the script is more stable.
]], 12)


local releaseV124 = releasePage:CreateSection("Zexon (Zuvok) | Release V1.2.4 - 2024 Dec 7")
releaseV124:CreateParagraph("Config Updates", [[
   + Seperated Cyclone for ease of use.
   + Cyclone now saves configs automatically.
   + New Fling feature for players. (Better fling logic for moving targets.)
   + Anti-cheat safeguard added for safety. (I mean do you really want to get banned? we're protecting you.)
   + New Releases, Custom Game, and Settings tabs!.
   Note: Fixing Cyclone Playerlist dropdown bug soon. 🧐
]], 7)

local releaseV123 = releasePage:CreateSection("Zexon (Zuvok) | Release V1.2.3 - 2024 Dec 4")
releaseV123:CreateParagraph("Bug Fixes and Features", [[
   + Notifications added for better user feedback. 😎
   + Reintroduced Playerlist targeting dropdown for Cyclone.
   + Improved Cyclone toggle logic and respawn handling (trust me i broke it ☹️)
   + Dropdowns now refresh reliably when players join or leave.
]], 3)

local releaseV122 = releasePage:CreateSection("Zexon (Zuvok) | Release V1.2.2 - 2024 Dec 2")
releaseV122:CreateParagraph("UI Hotfix", [[
   + 'Z' keybind added to a toggle to show/hide Zexon (Zuvok).
   - Removed Playerlist targeting due to bugs
   + Tuned some Cyclone node settings.
   Note: no mobile support. 😥
]], 4)

local releaseV121 = releasePage:CreateSection("Zexon (Zuvok) | Release V1.2.1 - 2024 Dec 1")
releaseV121:CreateParagraph("Execution Fix", [[
   + Resolved critical execution issues for a smoother start-up.
   + Optimized UI execution for better performance.
]], 3)

local releaseV120 = releasePage:CreateSection("Zexon (Zuvok) | Release V1.2 - 2024 Nov 30")
releaseV120:CreateParagraph("Cyclone Improvements", [[
   + Playerlist targeting added for Cyclone.
   + Advanced Cyclone settings:
       - Node Response and Torque sliders
   + Fixed Cyclone node stability issues.️
   + Smooth orbit and dynamic node management.
   + UI tweaks for better readability. 🎨
   + performance optimizations.
]], 7)

local releaseV110 = releasePage:CreateSection("Zexon (Zeya) | Release V1.1 - 2024 Nov 27")
releaseV110:CreateParagraph("UI and Stability", [[
   + Switched to ZexonUI (Zeya) - lightweight and responsive UI. 🤩
   + Cyclone Settings added:
       - Range, Speed, and Node adjustments.
       - Toggle to enable or disable Cyclone. 🌪️
   + Cyclone now stable after player respawn. 💪
   + Added Infinite Yield executor for quick commands. 🚀
   Note: Cyclone updates and optimizations in progress.
]], 7)


local releaseV101 = releasePage:CreateSection("Zexon (Sirius) | Release V1.0.1 - 2024 Nov 26")
releaseV101:CreateParagraph("New Rayfield Theme", [[
   + Cool new Rayfield theme added! 😎
   + Removed some UI buttons that were pretty useless.
]], 3)

local releaseV1 = releasePage:CreateSection("Zexon Release V1 - 2024 Nov 21")
releaseV1:CreateParagraph("Zexon Release", [[
   + Switched over to Sirius (RayField)
   + Added WalkSpeed slider feature.
   + Infinite Yield button added.
   + Cyclone - FE introduced!
   Note: The Release of this script. How amusing! 🥳
]], 5)
-- #########################################################
-- ##################### Load Main Script ################
-- #########################################################

log("[zexon] all done! script is executed <3")