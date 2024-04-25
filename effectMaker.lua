local effectMaker = {}

function effectMaker.getSchool(effect)
    print("Received effect:" .. effect.school)
    local autoIcon
    if effect.school == 0 then --Alteration|Cant use tes3.magicShcool.alteration for some reason
        autoIcon = "s\\Tx_s_burden.dds"
        return "s\\Tx_s_burden.dds"
    elseif effect.school == 1 then --Conjuration
        return "s\\tx_s_turn_undead.dds"
    elseif effect.school == 2 then  --Destruction
        return "s\\Tx_s_dmg_fati.tga"
    elseif effect.school == 3 then  --Illusion
        return "s\\tx_s_cm_crture.dds"
    elseif effect.school == 4 then  --Mysticism
        return "s\\tx_s_alm_intervt.dds"
    elseif effect.school == 5 then  --Restoration
        return "s\\Tx_S_ftfy_skill.tga"
    end
    return autoIcon
end

function effectMaker.create(params)
    params.name = params.name or "Error: Unnamed Effect"
    local effect = tes3.addMagicEffect({
        id = params.id,
        name = params.name,
        baseCost = params.baseCost,
        school = params.school,

        size = params.size,
        sizeCap = params.sizeCap,
        speed = params.speed,
        description = params.description,
        lighting = params.lighting,
        icon = params.icon or "default icon.tga", -- "s\\Tx_S_ftfy_skill.tga",
        particleTexture = params.particleTexture,
        castSound = params.castSound,
        boltSound = params.boltSound,
        hitSound = params.hitSound,
        areaSound = params.areaSound,
        castVFX = params.castVFX,
        boltVFX = params.boltVFX,
        hitVFX = params.hitVFX,
        areaVFX = params.areaVFX,
        usesNegativeLighting = params.usesNegativeLighting,
        hasContinuousVFX = params.hasContinuousVFX,

        allowEnchanting = params.allowEnchanting,
        allowSpellmaking = params.allowSpellmaking,
        appliesOnce = params.appliesOnce,
        canCastSelf = params.canCastSelf,
        canCastTarget = params.canCastTarget,
        canCastTouch = params.canCastTouch,
        casterLinked = params.casterLinked,
        hasNoDuration = params.hasNoDuration,
        hasNoMagnitude = params.hasNoMagnitude,
        illegalDaedra = params.illegalDaedra,
        isHarmful = params.isHarmful,
        nonRecastable = params.nonRecastable,
        targetsAttributes = params.targetsAttributes or false,
        targetsSkills = params.targetsSkills or false,
        unreflectable = params.unreflectable,

        onTick = params.onTick,
        onCollision = params.onCollision,
    })
        print("Creating effect with name:" .. params.name)
    local defaultIcon = effectMaker.getSchool(effect)
    local autoIcon = effectMaker.getSchool(effect)
    effect.icon = autoIcon -- defaultIcon

        print("Effect school set to:" .. effect.school) -- Debugging line


        print("Icon Changed to:" .. defaultIcon)
    return effect
end






return effectMaker