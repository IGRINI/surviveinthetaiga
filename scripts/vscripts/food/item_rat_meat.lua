if item_rat_meat == nil then
	item_rat_meat = class({})
end
LinkLuaModifier( "modifier_eat","modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_satiety","modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_indigestion","modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
function item_rat_meat:GetChannelTime()
	return self:GetSpecialValueFor("vreamyacasta")
end
function item_rat_meat:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_eat",{})
end
function item_rat_meat:OnChannelFinish(bInterrupted)
	local hansesliprervano = self:GetSpecialValueFor("hansesliprervano")
	local hanseslinorm = self:GetSpecialValueFor("hanseslinorm")
	local stacks = self:GetCurrentCharges()
	local dlitelnostsitostiesliprervano = self:GetSpecialValueFor("dlitelnostsitostiesliprervano")
	local dlitelnostnesvareniaesliprervano = self:GetSpecialValueFor("dlitelnostnesvareniaesliprervano")
	local dlitelnostsitosti = self:GetSpecialValueFor("dlitelnostsitosti")
	local dlitelnostnesvarenia = self:GetSpecialValueFor("dlitelnostnesvarenia")
	if bInterrupted then
		self:GetCursorTarget():RemoveModifierByName("modifier_eat")
		if RollPercentage(hansesliprervano) then
			self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_indigestion",{duration = dlitelnostnesvareniaesliprervano})
		else
			self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_satiety",{duration = dlitelnostsitostiesliprervano})
		end
		if stacks > 1 then
			self:SetCurrentCharges(stacks - 1)
		else
			self:RemoveSelf()
		end
	else
		self:GetCursorTarget():RemoveModifierByName("modifier_eat")
		if RollPercentage(hanseslinorm) then
			self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_indigestion",{duration = dlitelnostnesvarenia})
		else
			self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_satiety",{duration = dlitelnostsitosti})
		end
		if stacks > 1 then
			self:SetCurrentCharges(stacks - 1)
		else
			self:RemoveSelf()
		end
	end
end