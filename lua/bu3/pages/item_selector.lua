local PAGE = {}

--This is called when the page is called to load
function PAGE:Load(contentFrame)

	self.mirrorPanel = vgui.Create("DPanel", contentFrame)
	self.mirrorPanel:SetSize(contentFrame:GetWide(), contentFrame:GetTall())
	self.mirrorPanel.Paint = function() end --Clear background

	local textPanel = vgui.Create("DPanel", self.mirrorPanel)
	textPanel:SetSize(400, 75)
	textPanel:SetPos(self.mirrorPanel:GetWide()/2 - 200,9)
	textPanel.Paint = function(s , w , h)
		draw.SimpleText(BU3.Lang.Get("SETTINGS"), BU3.UI.Fonts["large_bold"], w/2, h/2, Color(255,255,255,20),1 ,1)
	end

	local createWeapon = BU3.UI.Elements.CreateStandardButton(BU3.Lang.Get("CREATE_WPN"), self.mirrorPanel, function()
		contentFrame:LoadPage("weaponeditor")
	end)
	createWeapon:SetPos(self.mirrorPanel:GetWide()/4 - (240/2), 230 - 60)
	createWeapon:SetSize(240, 45)

	local createPS1PS2Points = BU3.UI.Elements.CreateStandardButton(BU3.Lang.Get("CREATE_PS1"), self.mirrorPanel, function()
		contentFrame:LoadPage("points1editor")
	end)
	createPS1PS2Points:SetPos(((self.mirrorPanel:GetWide()/4) * 3) - (240/2), 230 - 60)
	createPS1PS2Points:SetSize(240, 45)

	local createEntity = BU3.UI.Elements.CreateStandardButton(BU3.Lang.Get("CREATE_ENT"), self.mirrorPanel, function()
		contentFrame:LoadPage("entityeditor")
	end)
	createEntity:SetPos(self.mirrorPanel:GetWide()/4 - (240/2), 370 - 60)
	createEntity:SetSize(240, 45)

	local _createPS1PS2Item = BU3.UI.Elements.CreateStandardButton(BU3.Lang.Get("CREATE_PS2"), self.mirrorPanel, function()
		contentFrame:LoadPage("points2editor")
	end)
	_createPS1PS2Item:SetPos(((self.mirrorPanel:GetWide()/4) * 3) - (240/2), 370 - 60)
	_createPS1PS2Item:SetSize(240, 45)

	local createRPCash = BU3.UI.Elements.CreateStandardButton(BU3.Lang.Get("CREATE_RPC"), self.mirrorPanel, function()
		contentFrame:LoadPage("moneyeditor")
	end)
	createRPCash:SetPos(self.mirrorPanel:GetWide()/4 - (240/2), 515 - 60)
	createRPCash:SetSize(240, 45)

	local createLuaItem = BU3.UI.Elements.CreateStandardButton(BU3.Lang.Get("CREATE_LUA"), self.mirrorPanel, function()
		contentFrame:LoadPage("luaeditor")
	end)
	createLuaItem:SetPos(((self.mirrorPanel:GetWide()/4) * 3) - (240/2), 515 - 60)
	createLuaItem:SetSize(240, 45)

	local createRPCash = BU3.UI.Elements.CreateStandardButton(BU3.Lang.Get("CREATE_PS1_I"), self.mirrorPanel, function()
		contentFrame:LoadPage("points1itemeditor")
	end)
	createRPCash:SetPos(self.mirrorPanel:GetWide()/4 - (240/2), 515 - 60 + 145)
	createRPCash:SetSize(240, 45)

	local createLuaItem = BU3.UI.Elements.CreateStandardButton(BU3.Lang.Get("CREATE_PS2_I"), self.mirrorPanel, function()
		contentFrame:LoadPage("points2itemeditor")
	end)
	createLuaItem:SetPos(((self.mirrorPanel:GetWide()/4) * 3) - (240/2), 515 - 60 + 145)
	createLuaItem:SetSize(240, 45)

end

--This is called when the page should unload
function PAGE:Unload(contentFrame, direction)
	self.mirrorPanel:Remove() --Remove all the UI we added to the content frame
end

--This can be called by anything to pass a message to the page
function PAGE:Message(message, data)

end

--Register the page
BU3.UI.RegisterPage("itemselector", PAGE)