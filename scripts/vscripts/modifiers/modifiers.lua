LinkLuaModifier("modifier_pukes","modifiers/modifiers",LUA_MODIFIER_MOTION_NONE)

if modifier_hunger == nil then
	modifier_hunger = class({})
end

function modifier_hunger:IsHidden()
	return false
end

function modifier_hunger:IsDebuff()
	return true
end

function modifier_hunger:GetTexture()
	return "item_winter_greevil_treat"
end

function modifier_hunger:IsStunDebuff()
	return true
end

function modifier_hunger:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_hunger:GetOverrideAnimation()
	return ACT_DOTA_DIE
end

function modifier_hunger:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

if modifier_cold == nil then
	modifier_cold = class({})
end

function modifier_cold:IsHidden()
	return false
end

function modifier_cold:IsDebuff()
	return true
end

function modifier_cold:GetTexture()
	return "item_winter_stocking"
end

function modifier_cold:IsStunDebuff()
	return true
end

function modifier_cold:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_cold:GetOverrideAnimation()
	return ACT_DOTA_DIE
end

function modifier_cold:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

if modifier_freeze == nil then
	modifier_freeze = class({})
end

function modifier_freeze:IsHidden()
	return true
end

function modifier_freeze:IsDebuff()
	return true
end

function modifier_freeze:CheckState()
	local state = {
	[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end

if modifier_eat == nil then
	modifier_eat = class({})
end
function modifier_eat:IsHidden()
	return true
end
function modifier_eat:IsDebuff()
	return false
end
function modifier_eat:IsPurgable()
	return false
end
function modifier_eat:OnCreated()
	if IsServer() then
		local eat = self:GetAbility():GetSpecialValueFor("eat")
		local id = self:GetParent():GetPlayerOwnerID()
		self.timer = Timers:CreateTimer(1, function()
				_G.resources[id]["hunger"] = (_G.resources[id]["hunger"] or 100) + eat
				if _G.resources[id]["hunger"] >= 100 then
					_G.resources[id]["hunger"] = 100
				end
	      	return 1.0
	    	end
	  	)
	end
end
function modifier_eat:GetAttributes ()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_eat:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end
function modifier_eat:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("regen")
end
function modifier_eat:OnDestroy()
	Timers:RemoveTimer(self.timer)
end

if modifier_satiety == nil then
	modifier_satiety = class({})
end
function modifier_satiety:IsHidden()
	return false
end
function modifier_satiety:IsDebuff()
	return false
end
function modifier_satiety:GetTexture()
	return "item_winter_cake"
end
function modifier_satiety:IsPurgable()
	return false
end

--[[if modifier_fried_rat == nil then
	modifier_fried_rat = class({})
end
function modifier_fried_rat:IsHidden()
	return true
end
function modifier_fried_rat:IsDebuff()
	return false
end
function modifier_fried_rat:IsPurgable()
	return false
end
function modifier_fried_rat:OnCreated()
	if IsServer() then
		local id = self:GetParent():GetPlayerOwnerID()
		self.timer = Timers:CreateTimer(1, function()
				_G.resources[id]["hunger"] = (_G.resources[id]["hunger"] or 100) + 7
				if _G.resources[id]["hunger"] >= 100 then
					_G.resources[id]["hunger"] = 100
				end
	      	return 1.0
	    	end
	  	)
	end
end
function modifier_fried_rat:GetAttributes ()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_fried_rat:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end
function modifier_fried_rat:GetModifierHealthRegenPercentage()
	return 10
end
function modifier_fried_rat:OnDestroy()
	Timers:RemoveTimer(self.timer)
end]]

if modifier_indigestion == nil then
	modifier_indigestion = class({})
end
function modifier_indigestion:IsHidden()
	return false
end
function modifier_indigestion:GetTexture()
	return "modifier_indigestion"
end
function modifier_indigestion:IsDebuff()
	return false
end
function modifier_indigestion:IsPurgable()
	return false
end
function modifier_indigestion:OnCreated()
	if IsServer() then
		local id = self:GetParent():GetPlayerOwnerID()
		self.timer = Timers:CreateTimer(1, function()
				_G.resources[id]["hunger"] = (_G.resources[id]["hunger"] or 100) - 1
				if _G.resources[id]["hunger"] <= 0 then
					_G.resources[id]["hunger"] = 0
				end
				if RollPercentage(20) then
					if not self:GetParent():HasModifier("modifier_pukes") then
						self:GetParent():AddNewModifier(self:GetParent(),nil,"modifier_pukes",{duration = 4})
					end
				end
	      	return 2.0
	    	end
	  	)
	end
end
function modifier_indigestion:GetAttributes ()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_indigestion:OnDestroy()
	Timers:RemoveTimer(self.timer)
end
function modifier_indigestion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end
function modifier_indigestion:GetModifierMoveSpeedBonus_Percentage()
	return -30
end

if modifier_pukes == nil then
	modifier_pukes = class({})
end

function modifier_pukes:IsHidden()
	return false
end

function modifier_pukes:IsDebuff()
	return true
end

function modifier_pukes:GetTexture()
	return "modifier_pukes"
end

function modifier_pukes:IsStunDebuff()
	return true
end
function modifier_pukes:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_pukes:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_pukes:OnCreated()
	if IsServer() then
		local id = self:GetParent():GetPlayerOwnerID()
		self.timer = Timers:CreateTimer(1, function()
				_G.resources[id]["hunger"] = (_G.resources[id]["hunger"] or 100) - 8
				if _G.resources[id]["hunger"] <= 0 then
					_G.resources[id]["hunger"] = 0
				end
	      	return 1.0
	    	end
	  	)
	end
	local orig = self:GetParent():GetAbsOrigin()
	self.pukesdown = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf",PATTACH_ABSORIGIN,self:GetParent())
	ParticleManager:SetParticleControl(self.pukesdown,1,Vector(20,1,1))
end

function modifier_pukes:OnDestroy()
	ParticleManager:DestroyParticle(self.pukesdown,false)
	Timers:RemoveTimer(self.timer)
end

function modifier_pukes:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end