--[[-------------------------------------------------------------------------
Handles the store and purchased etc
---------------------------------------------------------------------------]]

BU3.Shop = {}

BU3.Shop.ENUMS = {
	success = 0,
	notEnought = 1,
	itemNotValid = 2,
	cannotBeBought = 3,
	unknown = 4
}

--Tries to purchase an item, can fail and returns an enum if it does
function BU3.Shop.Purchase(ply, itemID, amount)
	amount = math.Round(amount)

	if amount <= 0 or amount > 16 then
		return false, BU3.Shop.ENUMS.unknown
	end

	--Check if the item exists
	if BU3.Items.Items[itemID] == nil then
		return false, BU3.Shop.ENUMS.itemNotValid
	end

	local item = BU3.Items.Items[itemID]

	--Check if they have the required rank
	if item.rankRestricted == true then
		if not table.HasValue(item.ranks, ply:GetUserGroup()) then
			print("sending message")
			net.Start("BU3:PromptUser")
			net.WriteString("Oh no!")
			net.WriteString("You don't have the rank required to purchase this.")
			net.WriteBool(false)
			net.Send(ply)

			--ply:SendLua([[notification.AddLegacy("You don't have the rank required to purchase this item!", NOTIFY_ERROR, 5)]])
			return
		end
	end

	if not item.canBeBought then
		return false, BU3.Shop.ENUMS.cannotBeBought
	end

	if not item.canBeBought then
		return false, BU3.Shop.ENUMS.cannotBeBought
	end

	if BU3.Config.Currency == "darkrp" then
		if not ply:canAfford(item.price * amount) then
			return false, BU3.Shop.ENUMS.notEnought
		end
		ply:addMoney(-(item.price * amount))
	end

	if BU3.Config.Currency == "ps1" then
		if not ply:PS_HasPoints(item.price * amount) then
			return false, BU3.Shop.ENUMS.notEnought
		end

		ply:PS_TakePoints(item.price * amount)
	end

	if BU3.Config.Currency == "ps2" then
		if ply.PS2_Wallet.points < item.price * amount then
			return false, BU3.Shop.ENUMS.notEnought
		end
		ply:PS2_AddStandardPoints(-(item.price * amount))
	end

	if BU3.Config.Currency == "zpn" then
		if zpn and zpn.Candy.ReturnPoints(ply) < amount then
			return false, BU3.Shop.ENUMS.notEnought
		end
		zpn.Candy.TakePoints(ply, item.price * amount)
	end

	if BU3.Config.Currency == "custom" then
		if BU3.Config.CanAfford(ply, item.price * amount) then
			return false, BU3.Shop.ENUMS.notEnought
		end
		BU3.Config.TakeMoney(ply, item.price * amount)
	end

	--All checks passed, lets buy it and give them the items
	ply:UB3AddItem(itemID, amount)

	ply:BU3AddStat("purchase", amount)

	return true, BU3.Shop.ENUMS.success
end



--[[-------------------------------------------------------------------------
Networking stuff
---------------------------------------------------------------------------]]

util.AddNetworkString("BU3:PurchaseItem")

--Purchase item
net.Receive("BU3:PurchaseItem", function(len, ply)
	local itemID = net.ReadInt(32)
	local amount = net.ReadInt(32)

	local worked, result = BU3.Shop.Purchase(ply, itemID, amount)

	if result == BU3.Shop.ENUMS.notEnought then
		ply:SendLua('notification.AddLegacy("' .. BU3.Lang.Get('NO_ENOUGH') .. '", NOTIFY_ERROR, 5)')
	end
end)



