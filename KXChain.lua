
a = readfile('kxguilib/as.lua')
local Library = loadstring(a)()

local Window = Library:CreateWindow("Main")

local safe = Window:AddFolder"Safe"
local plys = Window:AddFolder"Players"
local liv = Window:AddFolder"Living"
local rof = Window:AddFolder"Rofls"
local dan = Window:AddFolder"Danger"
local serv = Window:AddFolder"Server"

local tweenservice = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local plrs = game.Players
local lp = plrs.LocalPlayer
local twtp = false
local ptarget
local ltarget
local heart = {}

function tpt(targ)
	if twtp == false then
		lp.Character.HumanoidRootPart.CFrame = targ.CFrame
	else
		tweenservice:Create(lp.Character.HumanoidRootPart, TweenInfo.new(0.5 +(lp.Character.HumanoidRootPart.Position - targ.Position).Magnitude / 1000) , { CFrame = targ.CFrame + Vector3.new(0,5,0) }):Play()
	end
end

function livlistupd()
	livlist:Clear()
	for i,v in pairs(game.Workspace.Living:GetChildren()) do
		livlist:AddValue(v)
	end
end
function pllistupd()
	pllist:Clear()
	for i,v in pairs(game.Players:GetPlayers()) do
		pllist:AddValue(v)
	end
end
--
function toglanti(a)
	game:GetService("Players").LocalPlayer.PlayerScripts.Effects.Disabled = a
	game:GetService("Players").LocalPlayer.PlayerScripts["Anti Exploit"].Disabled = a
end
safe:AddToggle({text = "Safe tp", flag = "toggle", state = false, callback = function(a) twtp = a end})
safe:AddToggle({text = "Disable AntiCheat", flag = "toggle", state = false, callback = function(a) toglanti( a) end})

--

pllist = plys:AddList({text = "Player", flag = "list", value = '',values = '', callback = function(a) 
	ptarget = a 
	pllistupd() 
end})
plys:AddButton({text = "TP to target", flag = "button", callback = function() tpt(ptarget.Character.HumanoidRootPart) end})


--

livlist = liv:AddList({text = "Living", flag = "list", value = '',values = '', callback = function(a) 
	ltarget = a 
	livlistupd()
end})
liv:AddButton({text = "TP to target", flag = "button", callback = function() tpt(ltarget.HumanoidRootPart) end})

--

function fly()
	local MOUSE = lp:GetMouse()
	local CONTROL = {F = 0,B = 0,L = 0,R = 0}
	local speed = 100
	local BV = nil
	local function flystart()
		spawn(function ()
			while wait() do
				local crb = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
				if BV ~= nil then
					BV.velocity = crb
				else
					break
				end
			end
		end)
	end

	MOUSE.KeyDown:connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 1
		elseif KEY:lower() == 's' then
			CONTROL.B = -1
		elseif KEY:lower() == 'a' then
			CONTROL.L = -1 
		elseif KEY:lower() == 'd' then 
			CONTROL.R = 1
		elseif KEY:lower() == 'e' then 
			speed = speed * 3
		elseif KEY:lower() == 'p' then 
			if BV ~= nil then
				BV:Destroy()
				BV = nil
				print('destr')
			else
				BV = Instance.new("BodyVelocity", lp.Character.Torso)
				flystart()
				print('start')
			end
		end
	end)
	 
	MOUSE.KeyUp:connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then 
			speed = speed / 3
		end
	end)
end

dan:AddButton({text = "FLY P", flag = "button", callback = function() fly() end})


--
rof:AddButton({text = "Destroy", flag = "button", callback = function() Library:Destr() end})
rof:AddButton({text = "New window", flag = "button", callback = 
function() 
	Library:CreateWindow("yay")
	Library:Init()
end})
--
local selserv = game.JobId
serv:AddButton({text = "Join to server (Server id box)", flag = "button", callback = function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, selserv, lp)
end})
serv:AddButton({text = "Change Server", flag = "button", callback = function()
	TeleportService:Teleport(game.PlaceId, lp)
end})
sidcheck  = serv:AddButton({text = "Get Current Server id", flag = "button", callback = function()
	sid:SetValue(game.JobId)
	selserv = game.JobId
end})
sid = serv:AddBox({text = "Server id ", flag = "button", value = selserv, callback = function(a)
	selserv = a
end})


hlist = serv:AddList({text = "Heart check", flag = "list", value = 'None',values = heart, callback = function(a) 
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name:match('^(.-)'..'eart'..'(.*)$') then
			print(i,v:GetFullName())
			table.insert(heart, i, v)
			hlist:Clear()
			hlist:AddValue(v)
		end
	end
end})


--

Library:Init()

pllistupd()
livlistupd()
-- print("Toggle is currently:", Library.flags["toggle"])

