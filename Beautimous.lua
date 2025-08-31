local f = CreateFrame("Frame", "Beautimous")

local EXACT = {
	characterambient = "1",
	componentemissive = "1",
	componentspecular = "1",
	detaildoodadalpha = "100",
	doodadloddist = "2000",
	entityloddist = "100",
	environmentdetail = "150",
	extshadowquality = "5",
	ffxdeath = "1",
	ffxglow = "1",
	ffxnetherworld = "1",
	ffxspecial = "1",
	gxtexturecachesize = "512",
	horizonfarclip = "6226",
	horizonfarclipscale = "6",
	lodobjectcullsize = "1",
	lodobjectfadescale = "300",
	lodobjectminsize = "1",
	m2faster = "3",
	objectfade = "0",
	overridefarclip = "1",
	particlemtdensity = "100",
	projectedtextures = "1",
	reflectionmode = "3",
	rippledetail = "3",
	screenshotquality = "10",
	shadowtexturesize = "2048",
	showfootprintparticles = "1",
	showfootprints = "1",
	skycloudlod = "3",
	smallcull = "0",
	spelleffectlevel = "150",
	specular = "1",
	ssao = "2",
	ssaoblur = "2",
	ssaodistance = "750",
	sunshafts = "2",
	terrainmiplevel = "0",
	texturefilteringmode = "5",
	violencelevel = "5",
	waterdetail = "3",
	weatherdensity = "3",
	worldbasemip = "0",
}

local FLEX = {
	farclip = {"1600","1250","1000","800","600","500","400","300","200"},
	groundeffectdensity = {"256","128","64","32","16","8","4","2","1"},
	groundeffectdist = {"600","400","300","256","200","180","160","150","140"},
	gxmultisample = {"8","4","2","1"},
	particledensity = {"100","1.0","1","0.9","0.8","0.75","0.5"},
	skycloudlod = {"3","2","1","0"},
}

local ALIAS = {
	characterambient = {"characterAmbient","CharacterAmbient"},
	componentemissive = {"componentEmissive","ComponentEmissive"},
	componentspecular = {"componentSpecular","ComponentSpecular"},
	detaildoodadalpha = {"detailDoodadAlpha","DetailDoodadAlpha"},
	doodadloddist = {"doodadLodDist","doodadLODDist","DoodadLODDist"},
	entityloddist = {"entityLodDist","entityLODDist","EntityLODDist"},
	environmentdetail = {"environmentDetail","EnvironmentDetail"},
	extshadowquality = {"extShadowQuality","ExtShadowQuality"},
	ffxdeath = {"ffxDeath","FfxDeath","FFXDeath"},
	ffxglow = {"ffxGlow","FfxGlow","FFXGlow"},
	ffxnetherworld = {"ffxNetherworld","FfxNetherworld","FFXNetherworld"},
	ffxspecial = {"ffxSpecial","FfxSpecial","FFXSpecial"},
	farclip = {"farClip","Farclip","FarClip"},
	groundeffectdist = {"groundEffectDist","GroundEffectDist"},
	groundeffectfade = {"groundEffectFade","GroundEffectFade"},
	groundeffectdensity = {"groundEffectDensity","GroundEffectDensity"},
	gxmultisample = {"gxMultisample","GxMultisample","GxMultiSample","GXMultisample","GXMultiSample"},
	gxtexturecachesize = {"gxTextureCacheSize","GxTextureCacheSize","GXTextureCacheSize"},
	horizonfarclip = {"horizonFarclip","horizonFarClip","HorizonFarClip"},
	horizonfarclipscale = {"horizonFarclipScale","horizonFarClipScale","HorizonFarClipScale"},
	lodobjectculldist = {"lodObjectCullDist","LODObjectCullDist"},
	lodobjectcullsize = {"lodObjectCullSize","LODObjectCullSize"},
	lodobjectfadescale = {"lodObjectFadeScale","LODObjectFadeScale"},
	lodobjectminsize = {"lodObjectMinSize","LODObjectMinSize"},
	m2faster = {"m2Faster","M2Faster"},
	objectfade = {"objectFade","ObjectFade"},
	overridefarclip = {"overrideFarclip","overrideFarClip","OverrideFarClip"},
	particledensity = {"particleDensity","ParticleDensity"},
	particlemtdensity = {"particleMTDensity","ParticleMTDensity"},
	projectedtextures = {"projectedTextures","ProjectedTextures"},
	reflectionmode = {"reflectionMode","ReflectionMode"},
	rippledetail = {"rippleDetail","RippleDetail"},
	screenshotquality = {"screenshotQuality","ScreenshotQuality","ScreenShotQuality"},
	shadowtexturesize = {"shadowTextureSize","ShadowTextureSize"},
	showfootprintparticles = {"showFootprintParticles","ShowFootprintParticles"},
	showfootprints = {"showFootprints","ShowFootprints"},
	skycloudlod = {"skyCloudLod","skyCloudLOD","SkyCloudLOD"},
	smallcull = {"smallCull","SmallCull"},
	specular = {"Specular"},
	spelleffectlevel = {"spellEffectLevel","SpellEffectLevel"},
	ssao = {"Ssao","SSAO"},
	ssaoblur = {"ssaoBlur","SsaoBlur","SSAOBlur"},
	ssaodistance = {"ssaoDistance","SsaoDistance","SSAODistance"},
	sunshafts = {"sunShafts","SunShafts"},
	terrainmiplevel = {"terrainMipLevel","TerrainMipLevel"},
	texturefilteringmode = {"textureFilteringMode","TextureFilteringMode"},
	violencelevel = {"violenceLevel","ViolenceLevel"},
	waterdetail = {"waterDetail","WaterDetail"},
	weatherdensity = {"weatherDensity","WeatherDensity"},
	worldbasemip = {"worldBaseMip","WorldBaseMip"},
}

local lastChanged, lastSkipped, lastClamped = {}, {}, {}

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

local function setExact(name, value, changed, skipped, clamped)
	local key = firstExistingCVar(unpack(variantsFor(name)))
	if not key then
		table.insert(skipped, name)
		return
	end
	local cur = GetCVar(key)
	if cur ~= value then
		SetCVar(key, value)
		local after = GetCVar(key)
		if after == value then
			table.insert(changed, key .. "=" .. value)
		elseif after ~= cur then
			table.insert(clamped, key .. " (" .. value .. "→" .. after .. ")")
		end
	end
end

local function setMax(name, list, changed, skipped, clamped)
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
		elseif after ~= original then
			table.insert(clamped, key .. " (" .. v .. "→" .. after .. ")")
			return
		end
	end
end

local function apply()
	local changed, skipped, clamped = {}, {}, {}

	for k, v in pairs(EXACT) do
		setExact(k, v, changed, skipped, clamped)
	end

	setMax("farclip", FLEX.farclip, changed, skipped, clamped)
	setMax("groundeffectdist", FLEX.groundeffectdist, changed, skipped, clamped)
	setMax("groundeffectdensity", FLEX.groundeffectdensity, changed, skipped, clamped)
	setMax("particledensity", FLEX.particledensity, changed, skipped, clamped)
	setMax("skycloudlod", FLEX.skycloudlod, changed, skipped, clamped)
	setMax("gxmultisample", FLEX.gxmultisample, changed, skipped, clamped)

	local fadeKey = firstExistingCVar(unpack(variantsFor("groundeffectfade")))
	if fadeKey then
		local distKey = firstExistingCVar(unpack(variantsFor("groundeffectdist"))) or "groundeffectdist"
		local want = GetCVar(distKey)
		if want and GetCVar(fadeKey) ~= want then
			SetCVar(fadeKey, want)
			local after = GetCVar(fadeKey)
			if after == want then
				table.insert(changed, fadeKey .. "=" .. after)
			else
				table.insert(clamped, fadeKey .. " (" .. want .. "→" .. after .. ")")
			end
		end
	else
		table.insert(skipped, "groundeffectfade")
	end

	lastChanged, lastSkipped, lastClamped = changed, skipped, clamped
end

local function printReport()
	if #lastChanged > 0 then
		DEFAULT_CHAT_FRAME:AddMessage("Beautimous set: " .. table.concat(lastChanged, ", "), 0.3, 1, 0.3)
	else
		DEFAULT_CHAT_FRAME:AddMessage("Beautimous made no changes", 0.7, 0.7, 0.7)
	end
	if #lastClamped > 0 then
		DEFAULT_CHAT_FRAME:AddMessage("Beautimous clamped: " .. table.concat(lastClamped, ", "), 1, 0.8, 0.2)
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
