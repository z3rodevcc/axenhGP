--[[
    AXENH v0.2
    Author: Axenh
    Website: Axenh
    Description: Premium Marketplace Spoofer & Utility
]]

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local CoreGui = game:GetService("CoreGui")

--// Variables
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat task.wait() LocalPlayer = Players.LocalPlayer until LocalPlayer
end
if setclipboard then setclipboard("discord.gg/hile") end

--// Configuration
local Config = {
    Colors = {
        Background = Color3.fromRGB(12, 12, 15),
        Surface = Color3.fromRGB(18, 18, 22),
        SurfaceHigh = Color3.fromRGB(25, 25, 30),
        Accent = Color3.fromRGB(160, 160, 255),
        Text = Color3.fromRGB(240, 240, 240),
        TextMuted = Color3.fromRGB(150, 150, 160),
        Border = Color3.fromRGB(50, 50, 80),
        Green = Color3.fromRGB(0, 200, 100),
        Red = Color3.fromRGB(200, 50, 50)
    },
    Font = Enum.Font.Arcade,
    TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

--// UI Utilities
local Utils = {}

function Utils:ApplyStroke(instance, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Config.Colors.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = instance
    return stroke
end

function Utils:Tween(instance, properties)
    local tween = TweenService:Create(instance, Config.TweenInfo, properties)
    tween:Play()
    return tween
end

local Seluwia = {
    Tabs = {},
    ActiveTab = nil,
    Settings = {
        AutoFire = false,
        CrashMode = false,
        CPS = 1,
        Key = "",
        ActiveLoops = {}
    }
}

function Seluwia:SaveConfig()
    local data = {
        AutoFire = self.Settings.AutoFire,
        CrashMode = self.Settings.CrashMode,
        CPS = self.Settings.CPS,
        Key = self.Settings.Key
    }
    pcall(function()
        if writefile then
            writefile("axenh.json", HttpService:JSONEncode(data))
        end
    end)
end

function Seluwia:LoadConfig()
    pcall(function()
        if isfile and isfile("axenh.json") then
            local data = HttpService:JSONDecode(readfile("axenh.json"))
            if data then
                self.Settings.AutoFire = data.AutoFire or false
                self.Settings.CrashMode = data.CrashMode or false
                self.Settings.CPS = data.CPS or 1
                self.Settings.Key = data.Key or ""
            end
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxenhRecode"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Config.Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false
Utils:ApplyStroke(MainFrame, Config.Colors.Border, 1.5)

--// Key System UI
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyGate"
KeyFrame.Size = UDim2.new(0, 350, 0, 180)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
KeyFrame.BackgroundColor3 = Config.Colors.Background
KeyFrame.ClipsDescendants = true
KeyFrame.Parent = ScreenGui
Utils:ApplyStroke(KeyFrame, Config.Colors.Border, 1.5)

local KeyLogo = Instance.new("TextLabel")
KeyLogo.Size = UDim2.new(1, 0, 0, 50)
KeyLogo.BackgroundTransparency = 1
KeyLogo.Text = "Axenh"
KeyLogo.TextColor3 = Config.Colors.Accent
KeyLogo.TextSize = 24
KeyLogo.Font = Config.Font
KeyLogo.Parent = KeyFrame

local KeyInstruction = Instance.new("TextLabel")
KeyInstruction.Size = UDim2.new(1, 0, 0, 30)
KeyInstruction.Position = UDim2.new(0, 0, 0, 50)
KeyInstruction.BackgroundTransparency = 1
KeyInstruction.Text = "Please enter your access key"
KeyInstruction.TextColor3 = Config.Colors.TextMuted
KeyInstruction.TextSize = 14
KeyInstruction.Font = Config.Font
KeyInstruction.Parent = KeyFrame

local InputContainer = Instance.new("Frame")
InputContainer.Name = "InputContainer"
InputContainer.Size = UDim2.new(0, 250, 0, 35)
InputContainer.Position = UDim2.new(0.5, -125, 0, 90)
InputContainer.BackgroundColor3 = Config.Colors.Surface
InputContainer.ClipsDescendants = true
InputContainer.Parent = KeyFrame
Utils:ApplyStroke(InputContainer)

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -10, 1, 0)
KeyInput.Position = UDim2.new(0, 5, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Key here..."
KeyInput.TextColor3 = Config.Colors.Text
KeyInput.PlaceholderColor3 = Config.Colors.TextMuted
KeyInput.Font = Config.Font
KeyInput.TextSize = 14
KeyInput.Parent = InputContainer

local KeySubmit = Instance.new("TextButton")
KeySubmit.Size = UDim2.new(0, 100, 0, 30)
KeySubmit.Position = UDim2.new(0.5, -50, 0, 135)
KeySubmit.BackgroundColor3 = Config.Colors.Accent
KeySubmit.Text = "Enter"
KeySubmit.TextColor3 = Config.Colors.Background
KeySubmit.Font = Config.Font
KeySubmit.TextSize = 16
KeySubmit.Parent = KeyFrame

local TargetKey = "hile"

Seluwia:LoadConfig()
if Seluwia.Settings.Key == TargetKey then
    MainFrame.Visible = true
    KeyFrame:Destroy()
else
    KeyFrame.Visible = true
end

KeySubmit.MouseButton1Click:Connect(function()
    if KeyInput.Text == TargetKey then
        Seluwia.Settings.Key = TargetKey
        Seluwia:SaveConfig()
        KeyInstruction.Text = "Access Granted"
        KeyInstruction.TextColor3 = Config.Colors.Green
        task.wait(0.5)
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyInstruction.Text = "Invalid Key"
        KeyInstruction.TextColor3 = Config.Colors.Red
        task.wait(1)
        KeyInstruction.Text = "Please enter your access key"
        KeyInstruction.TextColor3 = Config.Colors.TextMuted
    end
end)

--// Draggable Logic
do
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

--// Navigation Setup
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Config.Colors.Surface
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Logo = Instance.new("TextLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.BackgroundTransparency = 1
Logo.Text = "Axenh"
Logo.TextColor3 = Config.Colors.Accent
Logo.TextSize = 18
Logo.Font = Config.Font
Logo.Parent = Sidebar

local NavContainer = Instance.new("Frame")
NavContainer.Name = "Navigation"
NavContainer.Size = UDim2.new(1, -20, 1, -120)
NavContainer.Position = UDim2.new(0, 10, 0, 70)
NavContainer.BackgroundTransparency = 1
NavContainer.Parent = Sidebar

local NavList = Instance.new("UIListLayout")
NavList.Padding = UDim.new(0, 5)
NavList.Parent = NavContainer

local BottomNav = Instance.new("Frame")
BottomNav.Name = "BottomNav"
BottomNav.Size = UDim2.new(1, -20, 0, 40)
BottomNav.Position = UDim2.new(0, 10, 1, -50)
BottomNav.BackgroundTransparency = 1
BottomNav.Parent = Sidebar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "Version"
VersionLabel.Size = UDim2.new(1, 0, 0, 20)
VersionLabel.Position = UDim2.new(0, 0, 1, -20)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v0.2"
VersionLabel.TextColor3 = Config.Colors.TextMuted
VersionLabel.TextSize = 10
VersionLabel.Font = Config.Font
VersionLabel.Parent = Sidebar

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -170, 1, -20)
ContentFrame.Position = UDim2.new(0, 170, 0, 10)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

--// Tab System
function Seluwia:SwitchTab(name)
    if self.ActiveTab == name then return end
    self.ActiveTab = name
    
    for tabName, data in pairs(self.Tabs) do
        local isActive = (tabName == name)
        data.Page.Visible = isActive
        
        Utils:Tween(data.Button, {
            BackgroundColor3 = isActive and Config.Colors.SurfaceHigh or Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = isActive and 0 or 1
        })
        
        Utils:Tween(data.Button:FindFirstChildOfClass("TextLabel"), {
            TextColor3 = isActive and Config.Colors.Accent or Config.Colors.TextMuted,
            TextSize = isActive and 16 or 14
        })
        Utils:Tween(data.Button:FindFirstChildOfClass("UIStroke"), {
            Color = isActive and Config.Colors.Accent or Config.Colors.Border,
            Transparency = isActive and 0 or 0.5
        })
    end
end

function Seluwia:CreateTab(name, isScrollable, parent)
    local button = Instance.new("TextButton")
    button.Name = name .. "Tab"
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent or NavContainer
    Utils:ApplyStroke(button)
    
    if parent == BottomNav then
        button.Size = UDim2.new(1, 0, 1, 0)
    end
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Config.Colors.TextMuted
    label.TextSize = 14
    label.Font = Config.Font
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button
    
    local page = isScrollable and Instance.new("ScrollingFrame") or Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.Parent = ContentFrame
    
    if isScrollable then
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Config.Colors.Accent
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    end
    
    self.Tabs[name] = {Button = button, Page = page}
    button.MouseButton1Click:Connect(function() self:SwitchTab(name) end)
    
    return page
end

--// Initialize Tabs
local HomePage = Seluwia:CreateTab("Home", false)
local ListenerPage = Seluwia:CreateTab("Listener", false)
local ConsolePage = Seluwia:CreateTab("Console", true)

--// Home Tab Content
local UserCard = Instance.new("Frame")
UserCard.Name = "UserCard"
UserCard.Size = UDim2.new(1, -10, 0, 100)
UserCard.BackgroundColor3 = Config.Colors.Surface
UserCard.Parent = HomePage
Utils:ApplyStroke(UserCard)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "Avatar"
AvatarImage.Size = UDim2.new(0, 80, 0, 80)
AvatarImage.Position = UDim2.new(0, 10, 0, 10)
AvatarImage.BackgroundColor3 = Config.Colors.SurfaceHigh
AvatarImage.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", LocalPlayer.UserId)
AvatarImage.Parent = UserCard

local DisplayNameLabel = Instance.new("TextLabel")
DisplayNameLabel.Name = "DisplayName"
DisplayNameLabel.Size = UDim2.new(1, -110, 0, 25)
DisplayNameLabel.Position = UDim2.new(0, 100, 0, 20)
DisplayNameLabel.BackgroundTransparency = 1
DisplayNameLabel.Text = LocalPlayer.DisplayName
DisplayNameLabel.TextColor3 = Config.Colors.Text
DisplayNameLabel.TextSize = 18
DisplayNameLabel.Font = Config.Font
DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
DisplayNameLabel.Parent = UserCard

local HandleLabel = Instance.new("TextLabel")
HandleLabel.Name = "Handle"
HandleLabel.Size = UDim2.new(1, -110, 0, 20)
HandleLabel.Position = UDim2.new(0, 100, 0, 45)
HandleLabel.BackgroundTransparency = 1
HandleLabel.Text = "@" .. LocalPlayer.Name
HandleLabel.TextColor3 = Config.Colors.TextMuted
HandleLabel.TextSize = 14
HandleLabel.Font = Config.Font
HandleLabel.TextXAlignment = Enum.TextXAlignment.Left
HandleLabel.Parent = UserCard

--// Discord Integration
local function GetExternalAsset(url, name)
    local success, asset = pcall(function()
        if writefile and getcustomasset and readfile and game.HttpGet then
            local path = "axenh_" .. name .. ".png"
            if not isfile(path) then
                writefile(path, game:HttpGet(url))
            end
            return getcustomasset(path)
        end
    end)
    return success and asset or "rbxassetid://13834161834"
end

local DiscordCard = Instance.new("Frame")
DiscordCard.Name = "DiscordCard"
DiscordCard.Size = UDim2.new(1, -10, 0, 100)
DiscordCard.Position = UDim2.new(0, 0, 0, 110)
DiscordCard.BackgroundColor3 = Config.Colors.Surface
DiscordCard.Parent = HomePage
Utils:ApplyStroke(DiscordCard)

local DiscordIcon = Instance.new("ImageLabel")
DiscordIcon.Name = "Icon"
DiscordIcon.Size = UDim2.new(0, 80, 0, 80)
DiscordIcon.Position = UDim2.new(0, 10, 0, 10)
DiscordIcon.BackgroundTransparency = 1
DiscordIcon.Image = GetExternalAsset("https://files.catbox.moe/2w07o0.gif", "server_icon")
DiscordIcon.Parent = DiscordCard

local DiscordTitle = Instance.new("TextLabel")
DiscordTitle.Name = "Title"
DiscordTitle.Size = UDim2.new(1, -110, 0, 25)
DiscordTitle.Position = UDim2.new(0, 100, 0, 20)
DiscordTitle.BackgroundTransparency = 1
DiscordTitle.Text = "Axenh"
DiscordTitle.TextColor3 = Config.Colors.Text
DiscordTitle.TextSize = 18
DiscordTitle.Font = Config.Font
DiscordTitle.TextXAlignment = Enum.TextXAlignment.Left
DiscordTitle.Parent = DiscordCard

local DiscordJoinBtn = Instance.new("TextButton")
DiscordJoinBtn.Name = "JoinButton"
DiscordJoinBtn.Size = UDim2.new(0, 100, 0, 30)
DiscordJoinBtn.Position = UDim2.new(0, 100, 0, 50)
DiscordJoinBtn.BackgroundColor3 = Config.Colors.Accent
DiscordJoinBtn.Text = "Join"
DiscordJoinBtn.TextColor3 = Config.Colors.Background
DiscordJoinBtn.Font = Config.Font
DiscordJoinBtn.TextSize = 14
DiscordJoinBtn.Parent = DiscordCard

DiscordJoinBtn.MouseButton1Click:Connect(function()
    local invite = "https://discord.gg/hile"
    if setclipboard then
        setclipboard(invite)
        local toast = Instance.new("Frame")
        toast.Size = UDim2.new(0, 200, 0, 40)
        toast.Position = UDim2.new(0.5, -100, 1, 10)
        toast.BackgroundColor3 = Config.Colors.SurfaceHigh
        toast.Parent = ScreenGui
        Utils:ApplyStroke(toast, Config.Colors.Accent)
        
        local msg = Instance.new("TextLabel")
        msg.Size = UDim2.new(1, 0, 1, 0)
        msg.BackgroundTransparency = 1
        msg.Text = "Link Copied!"
        msg.TextColor3 = Config.Colors.Text
        msg.Font = Config.Font
        msg.TextSize = 12
        msg.Parent = toast
        
        Utils:Tween(toast, {Position = UDim2.new(0.5, -100, 1, -60)})
        task.delay(2, function()
            Utils:Tween(toast, {Position = UDim2.new(0.5, -100, 1, 10)})
            task.wait(0.2)
            toast:Destroy()
        end)
    end
end)

--// Listener Tab Content
local ListenerHeader = Instance.new("Frame")
ListenerHeader.Name = "Header"
ListenerHeader.Size = UDim2.new(1, 0, 0, 30)
ListenerHeader.BackgroundTransparency = 1
ListenerHeader.Parent = ListenerPage

local ClearListenerBtn = Instance.new("TextButton")
ClearListenerBtn.Name = "Clear"
ClearListenerBtn.Size = UDim2.new(0, 60, 0, 20)
ClearListenerBtn.Position = UDim2.new(1, -65, 0, 5)
ClearListenerBtn.BackgroundColor3 = Config.Colors.SurfaceHigh
ClearListenerBtn.Text = "Clear"
ClearListenerBtn.TextColor3 = Config.Colors.TextMuted
ClearListenerBtn.Font = Config.Font
ClearListenerBtn.TextSize = 10
ClearListenerBtn.Parent = ListenerHeader
Utils:ApplyStroke(ClearListenerBtn)

local ListenerScroll = Instance.new("ScrollingFrame")
ListenerScroll.Name = "Events"
ListenerScroll.Size = UDim2.new(1, 0, 1, -30)
ListenerScroll.Position = UDim2.new(0, 0, 0, 30)
ListenerScroll.BackgroundTransparency = 1
ListenerScroll.ScrollBarThickness = 2
ListenerScroll.ScrollBarImageColor3 = Config.Colors.Accent
ListenerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListenerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListenerScroll.Parent = ListenerPage

local ListenerList = Instance.new("UIListLayout")
ListenerList.Padding = UDim.new(0, 8)
ListenerList.SortOrder = Enum.SortOrder.LayoutOrder
ListenerList.Parent = ListenerScroll

ClearListenerBtn.MouseButton1Click:Connect(function()
    for _, stopFunc in pairs(Seluwia.Settings.ActiveLoops) do stopFunc() end
    Seluwia.Settings.ActiveLoops = {}
    for _, child in pairs(ListenerScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end)

local function CreateListenerEntry(label, id, sigType, name)
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, -10, 0, 60)
    entry.BackgroundColor3 = Config.Colors.Surface
    entry.LayoutOrder = -tick()
    entry.Parent = ListenerScroll
    Utils:ApplyStroke(entry)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -120, 0, 25)
    title.Position = UDim2.new(0, 12, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = name or "Unknown Asset"
    title.TextColor3 = Config.Colors.Text
    title.TextSize = 14
    title.Font = Config.Font
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = entry
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -120, 0, 20)
    info.Position = UDim2.new(0, 12, 0, 30)
    info.BackgroundTransparency = 1
    info.Text = string.format("%s | ID: %s", label, tostring(id))
    info.TextColor3 = Config.Colors.TextMuted
    info.TextSize = 12
    info.Font = Config.Font
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.Parent = entry
    
    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(0, 80, 0, 30)
    runBtn.Position = UDim2.new(1, -90, 0.5, -15)
    runBtn.BackgroundColor3 = Config.Colors.Accent
    runBtn.Text = "Run"
    runBtn.TextColor3 = Config.Colors.Background
    runBtn.Font = Config.Font
    runBtn.TextSize = 12
    runBtn.Parent = entry
    
    runBtn.MouseButton1Click:Connect(function()
        local function fire(silent)
            pcall(function()
                if sigType == "Product" then MarketplaceService:SignalPromptProductPurchaseFinished(LocalPlayer.UserId, id, true)
                elseif sigType == "Gamepass" then MarketplaceService:SignalPromptGamePassPurchaseFinished(LocalPlayer, id, true)
                elseif sigType == "Bulk" then MarketplaceService:SignalPromptBulkPurchaseFinished(LocalPlayer.UserId, id, true)
                elseif sigType == "Purchase" then MarketplaceService:SignalPromptPurchaseFinished(LocalPlayer.UserId, id, true) end
                if not silent then
                    print(("[Axenh] EXECUTED: %s Signal for ID %s"):format(sigType, tostring(id)))
                end
            end)
        end

        if Seluwia.Settings.CrashMode then
            print("[Axenh] CRASH MODE ACTIVE: LAG SHIELD ENGAGED.")
            
            local RS = game:GetService("RunService")
            local SG = game:GetService("StarterGui")
            pcall(function() RS:Set3dRenderingEnabled(false) end)
            pcall(function() SG:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) end)

            task.spawn(function()
                local target = 100000000000
                local current = 0
                while current < target and entry.Parent do
                    for j = 1, 5000 do 
                        fire(true) 
                        current = current + 1
                    end
                    task.wait()
                end
                
                pcall(function() RS:Set3dRenderingEnabled(true) end)
                pcall(function() SG:SetCoreGuiEnabled(Enum.CoreGuiType.All, true) end)
                print("[Axenh] 100 BILLION BURST COMPLETE. LAG SHIELD DISENGAGED.")
            end)
        elseif Seluwia.Settings.AutoFire then
            task.spawn(function()
                while entry.Parent do
                    local cps = Seluwia.Settings.CPS
                    fire()
                    if cps > 60 then
                        for i = 1, math.floor(cps / 60) - 1 do
                            if not entry.Parent then break end
                            fire(true)
                        end
                        task.wait(1/60)
                    else
                        task.wait(1/cps)
                    end
                end
            end)
        else
            fire()
        end
    end)
end

--// Console Tab Content
local ConsoleContainer = Instance.new("ScrollingFrame")
ConsoleContainer.Size = UDim2.new(1, -10, 1, -10)
ConsoleContainer.Position = UDim2.new(0, 5, 0, 5)
ConsoleContainer.BackgroundTransparency = 1
ConsoleContainer.ScrollBarThickness = 2
ConsoleContainer.ScrollBarImageColor3 = Config.Colors.Accent
ConsoleContainer.Parent = ConsolePage

local ConsoleList = Instance.new("UIListLayout")
ConsoleList.Padding = UDim.new(0, 4)
ConsoleList.Parent = ConsoleContainer

local function AddConsoleLog(message, messageType)
    local color = Config.Colors.Text
    if messageType == Enum.MessageType.MessageWarning then color = Color3.fromRGB(255, 200, 0)
    elseif messageType == Enum.MessageType.MessageError then color = Config.Colors.Red
    elseif messageType == Enum.MessageType.MessageInfo then color = Config.Colors.Accent end
    
    local logLabel = Instance.new("TextLabel")
    logLabel.Size = UDim2.new(1, 0, 0, 18)
    logLabel.BackgroundTransparency = 1
    logLabel.Text = string.format("[%s] %s", os.date("%H:%M:%S"), message)
    logLabel.TextColor3 = color
    logLabel.TextSize = 12
    logLabel.Font = Enum.Font.RobotoMono
    logLabel.TextXAlignment = Enum.TextXAlignment.Left
    logLabel.TextWrapped = true
    logLabel.AutomaticSize = Enum.AutomaticSize.Y
    logLabel.LayoutOrder = -tick()
    logLabel.Parent = ConsoleContainer
end

--// Settings Tab Content
Seluwia:LoadConfig()
local SettingsPage = Seluwia:CreateTab("Settings", false, BottomNav)
Instance.new("UIListLayout", SettingsPage).Padding = UDim.new(0, 10)

local AutoFrame = Instance.new("Frame", SettingsPage)
AutoFrame.Size, AutoFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 40), 1

local AutoLabel = Instance.new("TextLabel", AutoFrame)
AutoLabel.Size, AutoLabel.BackgroundTransparency, AutoLabel.Text, AutoLabel.TextColor3, AutoLabel.Font, AutoLabel.TextSize, AutoLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), 1, "Auto Fire", Config.Colors.Text, Config.Font, 14, Enum.TextXAlignment.Left

local AutoBtn = Instance.new("TextButton", AutoFrame)
AutoBtn.Size, AutoBtn.Position, AutoBtn.BackgroundColor3, AutoBtn.Text, AutoBtn.TextColor3, AutoBtn.Font, AutoBtn.TextSize = UDim2.new(0, 80, 0, 30), UDim2.new(1, -80, 0.5, -15), Config.Colors.SurfaceHigh, "OFF", Config.Colors.Red, Config.Font, 14
Utils:ApplyStroke(AutoBtn)

local function updateAutoUI()
    AutoBtn.Text = Seluwia.Settings.AutoFire and "ON" or "OFF"
    AutoBtn.TextColor3 = Seluwia.Settings.AutoFire and Config.Colors.Green or Config.Colors.Red
end
updateAutoUI()

AutoBtn.MouseButton1Click:Connect(function()
    Seluwia.Settings.AutoFire = not Seluwia.Settings.AutoFire
    updateAutoUI()
    Seluwia:SaveConfig()
end)

local CPSFrame = Instance.new("Frame", SettingsPage)
CPSFrame.Size, CPSFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 40), 1

local CPSLabel = Instance.new("TextLabel", CPSFrame)
CPSLabel.Size, CPSLabel.BackgroundTransparency, CPSLabel.Text, CPSLabel.TextColor3, CPSLabel.Font, CPSLabel.TextSize, CPSLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), 1, "CPS (No Limit)", Config.Colors.Text, Config.Font, 14, Enum.TextXAlignment.Left

local CPSInput = Instance.new("TextBox", CPSFrame)
CPSInput.Size, CPSInput.Position, CPSInput.BackgroundColor3, CPSInput.Text, CPSInput.TextColor3, CPSInput.Font, CPSInput.TextSize = UDim2.new(0, 80, 0, 30), UDim2.new(1, -80, 0.5, -15), Config.Colors.SurfaceHigh, tostring(Seluwia.Settings.CPS), Config.Colors.Text, Config.Font, 14
Utils:ApplyStroke(CPSInput)

CPSInput.FocusLost:Connect(function()
    local num = tonumber(CPSInput.Text)
    if num then
        Seluwia.Settings.CPS = math.max(num, 1)
        CPSInput.Text = tostring(Seluwia.Settings.CPS)
        Seluwia:SaveConfig()
    else
        CPSInput.Text = tostring(Seluwia.Settings.CPS)
    end
end)

local CrashFrame = Instance.new("Frame", SettingsPage)
CrashFrame.Size, CrashFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 40), 1

local CrashLabel = Instance.new("TextLabel", CrashFrame)
CrashLabel.Size, CrashLabel.BackgroundTransparency, CrashLabel.Text, CrashLabel.TextColor3, CrashLabel.Font, CrashLabel.TextSize, CrashLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), 1, "Crash Mode", Config.Colors.Text, Config.Font, 14, Enum.TextXAlignment.Left

local CrashBtn = Instance.new("TextButton", CrashFrame)
CrashBtn.Size, CrashBtn.Position, CrashBtn.BackgroundColor3, CrashBtn.Text, CrashBtn.TextColor3, CrashBtn.Font, CrashBtn.TextSize = UDim2.new(0, 80, 0, 30), UDim2.new(1, -80, 0.5, -15), Config.Colors.SurfaceHigh, "OFF", Config.Colors.Red, Config.Font, 14
Utils:ApplyStroke(CrashBtn)

local function updateCrashUI()
    CrashBtn.Text = Seluwia.Settings.CrashMode and "ON" or "OFF"
    CrashBtn.TextColor3 = Seluwia.Settings.CrashMode and Config.Colors.Green or Config.Colors.Red
end
updateCrashUI()

CrashBtn.MouseButton1Click:Connect(function()
    Seluwia.Settings.CrashMode = not Seluwia.Settings.CrashMode
    updateCrashUI()
    Seluwia:SaveConfig()
end)

--// Logic Integration
local StartTime = tick()
local NameCache = {}

local function GetProductName(id, sigType)
    if NameCache[id] then return NameCache[id] end
    local name = nil
    pcall(function()
        local infoType = Enum.InfoType.Asset
        if sigType == "Product" then infoType = Enum.InfoType.Product
        elseif sigType == "Gamepass" then infoType = Enum.InfoType.GamePass end
        local info = MarketplaceService:GetProductInfo(id, infoType)
        if info and info.Name then name = info.Name end
    end)
    if name then NameCache[id] = name end
    return name or "Unknown Asset"
end

LogService.MessageOut:Connect(function(message, messageType)
    if tick() - StartTime < 0.5 then return end
    local lowerMessage = message:lower()
    if lowerMessage == "destruct" or lowerMessage == "/destruct" or lowerMessage == "!destruct" then
        ScreenGui:Destroy()
        return
    end
    AddConsoleLog(message, messageType)
end)

MarketplaceService.PromptProductPurchaseFinished:Connect(function(player, id)
    if player == LocalPlayer or player == LocalPlayer.UserId then CreateListenerEntry("Product", id, "Product", GetProductName(id, "Product")) end
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, id)
    if player == LocalPlayer or player == LocalPlayer.UserId then CreateListenerEntry("Gamepass", id, "Gamepass", GetProductName(id, "Gamepass")) end
end)

MarketplaceService.PromptPurchaseFinished:Connect(function(player, id)
    if player == LocalPlayer or player == LocalPlayer.UserId then CreateListenerEntry("Purchase", id, "Purchase", GetProductName(id, "Purchase")) end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Delete then MainFrame.Visible = not MainFrame.Visible end
end)

Seluwia:SwitchTab("Home")
task.spawn(function()
    local watermark = [[
    
  /$$$$$$  /$$   /$$ /$$$$$$$$ /$$   /$$ /$$   /$$
 /$$__  $$| $$  / $$| $$_____/| $$$ | $$| $$  | $$
| $$  \ $$|  $$/ $$/| $$      | $$$$| $$| $$  | $$
| $$$$$$$$ \  $$$$/ | $$$$$   | $$ $$ $$| $$$$$$$$
| $$__  $$  >$$  $$ | $$__/   | $$  $$$$| $$__  $$
| $$  | $$ /$$/\  $$| $$      | $$\  $$$| $$  | $$
| $$  | $$| $$  \ $$| $$$$$$$$| $$ \  $$| $$  | $$
|__/  |__/|__/  |__/|________/|__/  \__/|__/  |__/
                                                  

         discord.gg/hile
Axenh | script made by galatasaray.c0m
]]
    print(watermark)
    for line in watermark:gmatch("[^\r\n]+") do 
        AddConsoleLog(line, Enum.MessageType.MessageInfo) 
    end
end)
