if light_a_fire == nil then
	light_a_fire = class({})
end

LinkLuaModifier("modifier_bonfire","abilities/light_a_fire",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bonfire_aura","abilities/light_a_fire",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heat","abilities/light_a_fire",LUA_MODIFIER_MOTION_NONE)

function light_a_fire:OnSpellStart()
	local defaultchance = self:GetSpecialValueFor("defaultchance")
	local chance = defaultchance
	if GameRules:IsDaytime() then
		chance = chance
	else
		chance = chance - 30
	end
	if RollPercentage(chance) then
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_bonfire",{})
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_bonfire_aura",{})
	end
end


if modifier_bonfire == nil then
	modifier_bonfire = class({})
end

function modifier_bonfire:IsHidden()
	return false
end

function modifier_bonfire:GetTexture()
	return "item_bonfire"
end

function modifier_bonfire:OnCreated()
	if IsServer() then
		local orig = self:GetParent():GetAbsOrigin()
		Timers:CreateTimer(0, function()
				local hp = self:GetParent():GetHealth()
				if hp >= 10 then
		      		ApplyDamage({victim = self:GetParent(), attacker = self:GetParent(), damage = 5, damage_type = DAMAGE_TYPE_PURE,})
		      	else
		      		self:GetParent():Heal(95, self:GetAbility())
		      		self:GetParent():RemoveModifierByName("modifier_bonfire")
		      		self:GetParent():RemoveModifierByName("modifier_bonfire_aura")
		      		return nil
		      	end
		      	if GameRules:IsDaytime() then
	      			return 3.0
	      		else
	      			return 1.0
	      		end
	    	end
	  	)
	  	self.part = ParticleManager:CreateParticle("particles/bonfire.vpcf",PATTACH_ABSORIGIN,self:GetParent())
	  	ParticleManager:SetParticleControl(self.part,0,Vector(orig.x-12,orig.y,orig.z+30))
	end
end

function  modifier_bonfire:OnDestroy()
	ParticleManager:DestroyParticle(self.part,false)
end

function modifier_bonfire:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_bonfire:IsPurgable()
	return false
end


if modifier_bonfire_aura == nil then
	modifier_bonfire_aura = class({})
end

function modifier_bonfire_aura:IsHidden()
	return true
end

function modifier_bonfire_aura:IsAura()
	return true
end

function modifier_bonfire_aura:IsPurgable()
	return false
end

function modifier_bonfire_aura:GetModifierAura()
	return "modifier_heat"
end

function modifier_bonfire_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_bonfire_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_bonfire_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_bonfire_aura:GetAuraRadius()
	return 350
end


if modifier_heat == nil then
	modifier_heat = class({})
end

function modifier_heat:IsHidden()
	return false
end

function modifier_heat:IsPurgable()
	return false
end

function modifier_heat:GetTexture()
	return "item_bonfire"
end

function modifier_heat:IsDebuff()
	return false
end

function modifier_heat:OnCreated()
	if IsServer() then
		local id = self:GetParent():GetPlayerOwnerID()
		self.timer = Timers:CreateTimer(1, function()
				_G.resources[id]["heat"] = (_G.resources[id]["heat"] or 100) + 5
				if _G.resources[id]["heat"] >= 100 then
					_G.resources[id]["heat"] = 100
				end
	      	return 1.0
	    	end
	  	)
	end
end

function modifier_heat:OnDestroy()
	Timers:RemoveTimer(self.timer)
end