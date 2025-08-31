local f = CreateFrame("Frame", "Beautimous")

local EXACT = {
	characterambient = "1",
	componentemissive = "1",
	componentspecular = "1",
	specular = "1",
	detaildoodadalpha = "100",
	doodadloddist = "2000",
	entityloddist = "100",
	environmentdetail = "150",
	weatherdensity = "3",
	worldbasemip = "0",
	terrainmiplevel = "0",
	extshadowquality = "5",
	shadowtexturesize = "2048",
	overridefarclip = "1",
	horizonfarclip = "6226",
	horizonfarclipscale = "6",
	lodobjectcullsize = "1",
	lodobjectfadescale = "300",
	lodobjectminsize = "1",
	smallcull = "0",
	ffxglow = "1",
	ffxnetherworld = "1",
	ffxspecial = "1",
	ffxdeath = "1",
	waterdetail = "3",
	reflectionmode = "3",
	rippledetail = "3",
	particlemtdensity = "100",
	spelleffectlevel = "150",
	sunshafts = "2",
	ssao = "2",
	ssaoblur = "2",
	ssaodistance = "750",
	texturefilteringmode = "5",
	showfootprintparticles = "1",
	showfootprints = "1",
	violencelevel = "5",
	projectedtextures = "1",
}

local FLEX = {
	farclip = {"1600","1250","1000","800","600","500","400","300","200"},
	groundeffectdist = {"600","400","300","256","200","180","160","150","140"},
	particledensity = {"100","1.0","1","0.9","0.8","0.75","0.5"},
	skycloudlod = {"3","2","1","0"},
	gxmultisample = {"8","4","2","1"},
}

local ALIAS = {
	characterambient = {"characterAmbient","CharacterAmbient"},
	componentemissive = {"componentEmissive","ComponentEmissive"},
	componentspecular = {"componentSpecular","ComponentSpecular"},
	detaildoodadalpha = {"detailDoodadAlpha","DetailDoodadAlpha"},
	doodadloddist = {"doodadLodDist","doodadLODDist","DoodadLODDist"},
	entityloddist = {"entityLodDist","entityLODDist","EntityLODDist"},
	extshadowquality = {"extShadowQuality","ExtShadowQuality"},
	ffxglow = {"ffxGlow","FfxGlow","FFXGlow"},
	ffxnetherworld = {"ffxNetherworld","FfxNetherworld","FFXNetherworld"},
	ffxspecial = {"ffxSpecial","FfxSpecial","FFXSpecial"},
	ffxdeath = {"ffxDeath","FfxDeath","FFXDeath"},
	groundeffectdist = {"groundEffectDist","GroundEffectDist"},
	groundeffectfade = {"groundEffectFade","GroundEffectFade"},
	groundeffectdensity = {"groundEffectDensity","GroundEffectDensity"},
	horizonfarclip = {"horizonFarclip","horizonFarClip","HorizonFarClip"},
	horizonfarclipscale = {"horizonFarclipScale","horizonFarClipScale","HorizonFarClipScale"},
	lodobjectculldist = {"lodObjectCullDist","LODObjectCullDist"},
	lodobjectcullsize = {"lodObjectCullSize","LODObjectCullSize"},
	lodobjectfadescale = {"lodObjectFadeScale","LODObjectFadeScale"},
	lodobjectminsize = {"lodObjectMinSize","LODObjectMinSize"},
	overridefarclip = {"overrideFarclip","overrideFarClip","OverrideFarClip"},
	particledensity = {"particleDensity","ParticleDensity"},
	particlemtdensity = {"particleMTDensity","ParticleMTDensity"},
	projectedtextures = {"projectedTextures","ProjectedTextures"},
	shadowtexturesize = {"shadowTextureSize","ShadowTextureSize"},
	skycloudlod = {"skyCloudLod","skyCloudLOD","SkyCloudLOD"},
	spelleffectlevel = {"spellEffectLevel","SpellEffectLevel"},
	ssaoblur = {"ssaoBlur","SsaoBlur","SSAOBlur"},
	texturefilteringmode = {"textureFilteringMode","TextureFilteringMode"},
	terrainmiplevel = {"terrainMipLevel","TerrainMipLevel"},
	worldbasemip = {"worldBaseMip","WorldBaseMip"},
}

local lastChanged, lastSkipped = {}, {}

local function variantsFor(name)
	local t = {name}
	local a = ALIAS[name]
	if a then
		for i = 1, #a do
			t[#t+1] = a[i]
		end
	end
	return t
end

local function firstExistingCVar(...)
	for i = 1, select("#", ...) do
		local name = select(i, ...)
		local v = GetCVar(name)
		if v ~= nil then
			return name
		end
	end
end

local function setExact(name, value, changed, skipped)
	local key = firstExistingCVar(unpack(variantsFor(name)))
	if not key then
		table.insert(skipped, name)
		return
	end
	local cur = GetCVar(key)
	if cur ~= value then
		SetCVar(key, value)
		if GetCVar(key) == value then
			table.insert(changed, key .. "=" .. value)
		end
	end
end

local function setMax(name, list, changed, skipped)
	local key = firstExistingCVar(unpack(variantsFor(name)))
	if not key then
		table.insert(skipped, name)
		return
	end
	local original = GetCVar(key)
	for _, v in ipairs(list) do
		SetCVar(key, v)
		local after = GetCVar(key)
		if after == v then
			if after ~= original then
				table.insert(changed, key .. "=" .. after)
			end
			return
		end
	end
end

local function apply()
	local changed, skipped = {}, {}

	for k, v in pairs(EXACT) do
		setExact(k, v, changed, skipped)
	end

	setMax("farclip", FLEX.farclip, changed, skipped)
	setMax("groundeffectdist", FLEX.groundeffectdist, changed, skipped)
	setMax("particledensity", FLEX.particledensity, changed, skipped)
	setMax("skycloudlod", FLEX.skycloudlod, changed, skipped)
	setMax("gxmultisample", FLEX.gxmultisample, changed, skipped)

	do
		local fadeKey = firstExistingCVar(unpack(variantsFor("groundeffectfade")))
		if fadeKey then
			local distKey = firstExistingCVar(unpack(variantsFor("groundeffectdist"))) or "groundeffectdist"
			local want = GetCVar(distKey)
			if want and GetCVar(fadeKey) ~= want then
				SetCVar(fadeKey, want)
				table.insert(changed, fadeKey .. "=" .. GetCVar(fadeKey))
			end
		else
			table.insert(skipped, "groundeffectfade")
		end
	end

	lastChanged, lastSkipped = changed, skipped
end

local function printReport()
	if #lastChanged > 0 then
		DEFAULT_CHAT_FRAME:AddMessage("Beautimous set: " .. table.concat(lastChanged, ", "), 0.3, 1, 0.3)
	else
		DEFAULT_CHAT_FRAME:AddMessage("Beautimous made no changes.", 0.7, 0.7, 0.7)
	end
	if #lastSkipped > 0 then
		DEFAULT_CHAT_FRAME:AddMessage("Beautimous skipped: " .. table.concat(lastSkipped, ", "), 1, 0.4, 0.4)
	end
end

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", apply)

SLASH_BEAUTIMOUS1 = "/beauty"
SlashCmdList.BEAUTIMOUS = function(msg)
	msg = tostring(msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
	if msg == "apply" then
		apply()
	elseif msg == "report" then
		printReport()
	elseif msg == "both" then
		apply()
		printReport()
	else
		DEFAULT_CHAT_FRAME:AddMessage("Beautimous usage:", 0.6, 0.8, 1)
		DEFAULT_CHAT_FRAME:AddMessage("/beauty apply      Apply settings now", 0.9, 0.9, 0.9)
		DEFAULT_CHAT_FRAME:AddMessage("/beauty report     Show last apply report", 0.9, 0.9, 0.9)
		DEFAULT_CHAT_FRAME:AddMessage("/beauty both       Apply then show report", 0.9, 0.9, 0.9)
	end
end
