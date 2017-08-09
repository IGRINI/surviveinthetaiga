
require('changes')
require('libs/timers')

nPlayers = 0

_G.resources = {}

for playerid = 0, nPlayers do
	_G.resources[playerid] = {}
end


if SurviveInTheTaiga == nil then
	SurviveInTheTaiga = class({})
end

function Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_viper/viper_base_attack_drips.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", context)
end

function Activate()
	GameRules.AddonTemplate = SurviveInTheTaiga()
	GameRules.AddonTemplate:InitGameMode()
end

function SurviveInTheTaiga:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity()
	--GameMode:SetThink( "OnThink", self, "GlobalThink", 2 )
    ListenToGameEvent('npc_spawned',Dynamic_Wrap(SurviveInTheTaiga,'OnNPCSpawned'),self )
    ListenToGameEvent('dota_item_picked_up',Dynamic_Wrap(SurviveInTheTaiga,'OnPickUpItem'),self)
    ListenToGameEvent('player_connect_full',Dynamic_Wrap(SurviveInTheTaiga,'OnConnectFull'),self)
    GameRules:SetGoldPerTick(0)
	GameRules:SetGoldTickTime(60)
    GameRules:SetTreeRegrowTime(1000000000)
    GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS,10)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS,0)
	GameRules:SetHeroSelectionTime(15)
	GameRules:SetPreGameTime(0)
    GameRules:SetPostGameTime(30)
    GameMode:SetBuybackEnabled(false)
    GameMode:SetStashPurchasingDisabled(true)
    GameMode:SetLoseGoldOnDeath(false)
end

function SurviveInTheTaiga:OnPickUpItem(event)
	DeepPrintTable(event)
end

function SurviveInTheTaiga:OnNPCSpawned(event)
	local spawnedUnit = EntIndexToHScript(event.entindex)
	if spawnedUnit:IsRealHero() then
		OnHeroSpawn(spawnedUnit)
	end
end

function OnHeroSpawn(spawned_hero)
	local hero = spawned_hero
	local steam_id = PlayerResource:GetSteamAccountID(hero:GetPlayerOwnerID())
	if not steam_id then return end
	if steam_id == 0 then
	end
	local children = hero:GetChildren()
	if children then
		for k,child in pairs(children) do
		   if child:GetClassname() == "dota_item_wearable" then
		       UTIL_Remove(child)
		   end
		end
	end
	local gathering = hero:FindAbilityByName("gathering")
	if gathering then
		if gathering:GetLevel() < 1 then
			gathering:SetLevel(1)
		end
	end
	local craft_bonfire = hero:FindAbilityByName("craft_bonfire")
	if craft_bonfire then
		if craft_bonfire:GetLevel() < 1 then
			craft_bonfire:SetLevel(1)
		end
	end
	changes:hunger(hero:GetPlayerOwnerID())
	changes:heat(hero:GetPlayerOwnerID())
end

function SurviveInTheTaiga:OnConnectFull(event)
    local entIndex = event.index+1
    local player = EntIndexToHScript(entIndex)
    local playerID = player:GetPlayerID()
   	local hero = player:GetAssignedHero()
   	if not player or not playerID then return end

    nPlayers = nPlayers + 1

    if not hero then return end
end

--[[function SurviveInTheTaiga:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end]]
