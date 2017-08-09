if changes == nil then
  	changes = class({})
end

LinkLuaModifier("modifier_hunger","modifiers/modifiers",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cold","modifiers/modifiers",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_freeze","modifiers/modifiers",LUA_MODIFIER_MOTION_NONE)

function changes:changewood(playerid,changewood)
	_G.resources[playerid]["wood"] = (_G.resources[playerid]["wood"] or 0) + changewood
	print("Wood",_G.resources[playerid]["wood"])
end

function changes:changestone(playerid,changestone)
	_G.resources[playerid]["stones"] = (_G.resources[playerid]["stones"] or 0) + changestone
	print("Stones",_G.resources[playerid]["stones"])
end

function changes:hunger(playerid)
	_G.resources[playerid]["hunger"] = (_G.resources[playerid]["hunger"] or 100)
	Timers:CreateTimer(10, function()
			if _G.resources[playerid]["hunger"] >= 100 then
				_G.resources[playerid]["hunger"] = 100
			elseif _G.resources[playerid]["hunger"] <= 0 then
				_G.resources[playerid]["hunger"] = 0
			end
	    return 1.5
	   	end
	)
	Timers:CreateTimer(10, function()
			local hero = PlayerResource:GetSelectedHeroEntity(playerid)
			print("Hunger",_G.resources[playerid]["hunger"])
			if hero:HasModifier("modifier_satiety") then
			elseif _G.resources[playerid]["hunger"] < 1 then
				hero:AddNewModifier(hero,nil,"modifier_hunger",{})
				Timers:CreateTimer(2.5, function()
				      	hero:AddNewModifier(hero,nil,"modifier_freeze",{})
				      	return nil
				    end
				)
			else
				_G.resources[playerid]["hunger"] = (_G.resources[playerid]["hunger"] or 100) - 1
			end
	    return 1.5
	   	end
	)
end

function changes:heat(playerid)
	_G.resources[playerid]["heat"] = (_G.resources[playerid]["heat"] or 100)
	Timers:CreateTimer(15, function()
			if _G.resources[playerid]["heat"] >= 100 then
				_G.resources[playerid]["heat"] = 100
			elseif _G.resources[playerid]["heat"] <= 0 then
				_G.resources[playerid]["heat"] = 0
			end
	    return 1.0
	   	end
	)
	Timers:CreateTimer(15, function()
			local hero = PlayerResource:GetSelectedHeroEntity(playerid)
			if hero:HasModifier("modifier_heat") then
			elseif _G.resources[playerid]["heat"] < 1 then
				hero:AddNewModifier(hero,nil,"modifier_cold",{})
				Timers:CreateTimer(2.5, function()
				      	hero:AddNewModifier(hero,nil,"modifier_freeze",{})
				      	return nil
				    end
				)
			else
				_G.resources[playerid]["heat"] = (_G.resources[playerid]["heat"] or 100) - 1
			end
			print("Heat",_G.resources[playerid]["heat"])
			if GameRules:IsDaytime() then
	    		return 3.0
	    	else
	    		return 1.0
	    	end
	   	end
	)
end

function changes:spendwood(playerid,wood)
	_G.resources[playerid]["wood"] = (_G.resources[playerid]["wood"] or 0) - wood
	print("Wood",_G.resources[playerid]["wood"])
end

function changes:spendstone(playerid,stone)
	_G.resources[playerid]["stones"] = (_G.resources[playerid]["stones"] or 0) - stone
	print("Stones",_G.resources[playerid]["stones"])
end

function changes:woodinspection(playerid,wood)
	if wood <= (_G.resources[playerid]["wood"] or 0) then
		return true
	else
		return false
	end
end

function changes:stoneinspection(playerid,stone)
	if stone <= (_G.resources[playerid]["stones"] or 0) then
		return true
	else
		return false
	end
end