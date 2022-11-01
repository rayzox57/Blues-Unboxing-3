--The global table that stores everything
BU3 = {}
BU3.Language = {}

if SERVER then
	AddCSLuaFile("bu3_config.lua")
end

include("bu3_config.lua")

--Load all of the files

print("-----------------------------------------------------")
print("               LOADING BLUE'S UNBOXING 3             ") 
print("-----------------------------------------------------")
local files, folders = file.Find("bu3/*", "LUA")
for _, v in pairs(files) do
	if string.sub(v, 1, 3) == "cl_" then
		if CLIENT then
			include("bu3/"..v)
			print("Loaded "..v)
		else 
			AddCSLuaFile("bu3/"..v)
		end
	elseif string.sub(v, 1, 3) == "sh_" then 
		if CLIENT then
			include("bu3/"..v)
			print("Loaded "..v) 
		else
			AddCSLuaFile("bu3/"..v)
			include("bu3/"..v)
			print("Loaded "..v) 
		end
	elseif string.sub(v, 1, 3) == "sv_" then
		include("bu3/"..v)
		print("Loaded "..v)
	end
end

--Add all files for all Languages
files, folders = file.Find("bu3/languages/*", "LUA")

local languageFound = false

for _, v in pairs(files) do
	if languageFound == true then continue end

	if v == string.format('%s.lua',BU3.Config.Lang) then
		languageFound = true
		if CLIENT then
			include("bu3/languages/"..v)
			print("Lang Loaded "..v) 
		else
			AddCSLuaFile("bu3/languages/"..v)
			include("bu3/languages/"..v)
			print("Lang Loaded "..v) 
		end

		local lang = BU3.Language[BU3.Config.Lang]

		if lang ~= nil then
			BU3.Lang.Current = BU3.Config.Lang
			BU3.Lang.Pack = lang
		else
			MsgC(Color(255,0,0,255), string.format('[! BU3 ERROR !] : The config language missing ! Make sure in you\'re lua/bu3/languages/%s.lua the array is : BU3.Language["%s"] = { ... } ! Switch to english \n',BU3.Config.Lang,BU3.Config.Lang))
			languageFound = false
		end

	end
end




local dfl = "bu3/languages/en.lua"

if languageFound == false then
	local l = BU3.Lang.Current
	print(string.format("Language %s file not found ... To fix you need to create %s.lua in lua/bu3/languages/%s.lua with en.lua base and translate !",l,l,l))
	print("Try to found en.lua ...")
	
	if file.Exists(dfl,"LUA") then
		languageFound = true
		if CLIENT then
			include(dfl)
			print("Default Language Loaded "..dfl) 
		else
			AddCSLuaFile(dfl)
			include(dfl)
			print("Default Language Loaded "..dfl) 
		end

		local lang = BU3.Language[BU3.Lang.Current]

		if lang ~= nil then
			BU3.Lang.Pack = lang
		else
			MsgC(Color(255,0,0,255), '[! BU3 ERROR !] : The default language missing ! Go to :\n https://github.com/rayzox57/Blues-Unboxing-3/tree/master/lua/bu3/languages/en.lua\n And copy this file in the same repository !!!\n For moment all string translation are missing bro :(\n')
			languageFound = false
		end

	else
		MsgC(Color(255,0,0,255), '[! BU3 ERROR !] : The default language missing ! Go to :\n https://github.com/rayzox57/Blues-Unboxing-3/tree/master/lua/bu3/languages/en.lua\n And copy this file in the same repository !!!\n For moment all string translation are missing bro :(\n')
	end 
end



--Add CSLua file to all the pages
files, folders = file.Find("bu3/pages/*", "LUA")

for _, v in pairs(files) do
	if SERVER then
		AddCSLuaFile("bu3/pages/"..v)
		print("Added page '"..v.."'")
	end
end

print("-----------------------------------------------------")
print("         FINISHED LOADING BLUES UNBOXING 3           ")
print("-----------------------------------------------------")

if SERVER then
	util.AddNetworkString("BU3:OpenGUI")
	hook.Add("PlayerSay" , "BU3:OpenTextCommand" , function(ply , text)
		if string.lower(text) == "!unbox" or string.lower(text) == "/unbox" then
			ply:UB3UpdateClient()
			net.Start("BU3:OpenGUI")
			net.Send(ply)
		end
	end) 
end