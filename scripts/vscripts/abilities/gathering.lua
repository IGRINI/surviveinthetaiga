function Gather(keys)
	local caster = keys.caster
	local ability = keys.ability
   local point = caster:GetCursorPosition()
   local findents = GridNav:GetAllTreesAroundPoint(point, 150, true)
   local playerid = caster:GetPlayerOwnerID()
   local owner = caster:GetPlayerOwner()
   local woodmsg = "particles/wood_msg.vpcf"
   local stonemsg = "particles/stone_msg.vpcf"
   local woodmin = ability:GetSpecialValueFor("woodmin")
   local woodmax = ability:GetSpecialValueFor("woodmax")
   local stonemin = ability:GetSpecialValueFor("stonemin")
   local stonemax = ability:GetSpecialValueFor("stonemax")
   local multiplier = ability:GetSpecialValueFor("treemultiplier")
   local wood = math.random(woodmin,woodmax)
   local stone = math.random(stonemin,stonemax)
   local life = 3.0
   if #findents >= 1 then
      for _,tree in pairs(findents) do
         tree.health = tree.health or RandomInt(6, 10)
         tree.health = tree.health - 1
         if tree.health == 0 then
            tree:CutDown(keys.caster:GetTeam())
         end
      end
   	local trees = tonumber(#findents)
   	local woodtotranslate = math.floor(wood * (1 + trees * multiplier))
   	print(woodtotranslate)
   	changes:changewood(playerid,tonumber(woodtotranslate))
      local string = string.len(woodtotranslate)
      local numbers = ParticleManager:CreateParticleForPlayer(woodmsg,PATTACH_OVERHEAD_FOLLOW,caster,owner)
      ParticleManager:SetParticleControl( numbers, 1, Vector( 1, woodtotranslate, 0 ) )
      ParticleManager:SetParticleControl( numbers, 2, Vector( life, string, 0 ) )
   else
   	print(stone)
   	changes:changestone(playerid,tonumber(stone))
      local string = string.len(stone)
      local numbers = ParticleManager:CreateParticleForPlayer(stonemsg,PATTACH_OVERHEAD_FOLLOW,caster,owner)
      ParticleManager:SetParticleControl( numbers, 1, Vector( 1, stone, 0 ) )
      ParticleManager:SetParticleControl( numbers, 2, Vector( life, string, 0 ) )
   end
end