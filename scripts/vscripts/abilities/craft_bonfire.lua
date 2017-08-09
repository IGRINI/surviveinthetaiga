if craft_bonfire == nil then
	craft_bonfire = class({})
end

function craft_bonfire:GetChannelTime()
	return self:GetSpecialValueFor("craftingtime")
end

function craft_bonfire:CastFilterResult()
	local caster = self:GetCaster()
	local id = caster:GetPlayerOwnerID()
	local wood = self:GetSpecialValueFor("wood")
	local stone = self:GetSpecialValueFor("stone")
	if changes:woodinspection(id,wood) then
		if changes:stoneinspection(id,stone) then
			return UF_SUCCESS
		else
			return UF_FAIL_CUSTOM
		end
	else
		return UF_FAIL_CUSTOM
	end
	return UF_FAIL_CUSTOM
end
function craft_bonfire:GetCustomCastError()
	local caster = self:GetCaster()
	local id = caster:GetPlayerOwnerID()
	local wood = self:GetSpecialValueFor("wood")
	local stone = self:GetSpecialValueFor("stone")
	if changes:woodinspection(id,wood) then
		if changes:stoneinspection(id,stone) then
			return ""
		else
			return "#error_not_enought_stones"
		end
	else
		return "#error_not_enought_wood"
	end
	return "#error_not_recources"
end

function craft_bonfire:OnSpellStart()
end

function craft_bonfire:OnChannelFinish(bInterrupted)
	if bInterrupted then
		local caster = self:GetCaster()
		local id = caster:GetPlayerOwnerID()
		local wood = self:GetSpecialValueFor("wood")
		local stone = self:GetSpecialValueFor("stone")
		changes:spendwood(id,math.floor(wood/2))
		changes:spendstone(id,math.floor(stone/2))
	else
		local caster = self:GetCaster()
		local id = caster:GetPlayerOwnerID()
		local wood = self:GetSpecialValueFor("wood")
		local stone = self:GetSpecialValueFor("stone")
		changes:spendwood(id,wood)
		changes:spendstone(id,stone)
		local abs = caster:GetAbsOrigin()
		--local owner = caster:GetOwner()
		local item = CreateItem("item_bonfire",caster,caster)
		item:SetPurchaseTime(0)
		CreateItemOnPositionSync(abs,item)
	end
end