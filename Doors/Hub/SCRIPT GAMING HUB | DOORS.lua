local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SCRIPT GAMING HUB | DOORS",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Main")

local Toggle = Tab:CreateToggle({
   Name = "Instant Interact",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
     InstantEnabled = Value
    
    if Value then
        if Connection then Connection:Disconnect() end
        
        Connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
            if not InstantEnabled then return end
            if input.KeyCode == Enum.KeyCode.E or input.UserInputType == Enum.UserInputType.Touch then
                local player = game.Players.LocalPlayer
                local char = player.Character
                if not char then return end
                
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj:FindFirstChild("ClickDetector") then
                        local dist = (obj.Position - root.Position).Magnitude
                        if dist < 20 then
                            fireclickdetector(obj.ClickDetector) -- LANGSUNG AMBIL, GAK ADA PROGRESS
                        end
                    end
                    
                    if obj:IsA("ProximityPrompt") then
                        local dist = (obj.Parent.Position - root.Position).Magnitude
                        if dist < obj.MaxActivationDistance then
                            -- BYPASS PROGRESS: langsung trigger HoldEnd tanpa nunggu
                            obj:InputHoldBegin()
                            wait(0.01) -- delay kecil biar kedetect
                            obj:InputHoldEnd() -- LANGSUNG SELESAI, GAK JALANIN PROGRESS
                        end
                    end
                end
            end
        end)
        
    else
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
    end
  
    local statusText = Value and "✅ INSTANT (BYPASS PROGRESS)" or "Not NORMAL (PROGRESS)"
    local progressValue = Value and 100 or 0
    
    local progressBar = Tab:CreateProgress({
        Name = "Mode",
        CurrentValue = progressValue,
        Callback = function() end
    })
    
    for i = 0, 100, 5 do
        if Value then
            progressBar:Set(i)
        else
            progressBar:Set(100 - i)
        end
        wait(0.01)
    end
    
    print("Status: " .. statusText)
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Coming Soon",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
     warn("sorry")
   end,
})

local Tab = Window:CreateTab("Player", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Player")

local Slider = Tab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Walkspeed",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
        
        local speedNow = Value
        local playerName = player and player.Name or "Unknown"
      
        print("⚡ Speed " .. playerName .. ": " .. speedNow)
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        if Value then
            game:GetService("RunService").Stepped:Connect(function()
                if not Value then return end
                local player = game.Players.LocalPlayer
                if player and player.Character then
                    for _, v in pairs(player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)

            print("Noclip ON")           
        else
            local player = game.Players.LocalPlayer
            if player and player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
              
            print("Noclip OFF")
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        if Value then
            local lighting = game:GetService("Lighting")
            lighting.Ambient = Color3.new(1, 1, 1)
            lighting.Brightness = 2
            lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
            lighting.ColorShift_Top = Color3.new(1, 1, 1)

            print("Fullbright ON")            
        else
            local lighting = game:GetService("Lighting")
            lighting.Ambient = Color3.new(0, 0, 0)
            lighting.Brightness = 1
            lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            lighting.ColorShift_Top = Color3.new(0, 0, 0)
            
            print("Fullbright OFF")
   end,
}) 

local Tab = Window:CreateTab("Visual", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Visual")

local Toggle = Tab:CreateToggle({
   Name = "Notify Entities",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        if Value then
            local notified = {}

            spawn(function()
                while Value do
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                            local name = v.Name:lower()
                            local monsterType = nil
                            
                            if name:find("rush") then
                                monsterType = "Rush"
                            elseif name:find("ambush") then
                                monsterType = "Ambush"
                            elseif name:find("eyes") then
                                monsterType = "Eyes"
                            end
                            
                            if monsterType and not notified[v] then
                                notified[v] = true
                              
                                Rayfield:Notify({
                                    Title = "⚠️ " .. monsterType .. " SPAWNED",
                                    Content = monsterType .. " muncul! Siap-siap bro!",
                                    Duration = 3
                                })
                                
                                print("🚨 " .. monsterType .. " muncul pada " .. os.date("%H:%M:%S"))
                                
                                if game:GetService("UserInputService").VibrationSupported then
                                    game:GetService("UserInputService"):SetVibration(0, 0.5, 0.2)
                                end
                            end
                        end
                    end
                    wait(0.5)
                end
            end)
            
            spawn(function()
                while Value do
                    wait(30)
                    notified = {}
                end
            end)
      
            print("Notify Entities: ON")            
          else
            print("Notify Entities: OFF")
   end,
})
