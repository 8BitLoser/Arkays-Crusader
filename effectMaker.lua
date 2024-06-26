local effectMaker = {}

function effectMaker.getSchool(school)
    print("Received effect:" .. school)
    -- Setup all the variables I'll be returning to .create
    local autoIcon, areaSound, areaVFX, boltSound, boltVFX, castSound, castVFX, hitSound, hitVFX, particleTexture 
    --Setup all default required fx/sounds
    if school == 0 then --Alteration|Cant use tes3.magicShcool.alteration for some reason
        autoIcon = "s\\Tx_s_burden.dds"
        areaSound = "alteration area"
        areaVFX = "VFX_AlterationArea"
        boltSound = "alteration bolt"
        boltVFX = "VFX_AlterationBolt"
        castSound = "alteration cast"
        castVFX = "VFX_AlterationCast"
        hitSound = "alteration hit"
        hitVFX = "VFX_AlterationHit"
        particleTexture = "vfx_alt_glow.tga"
    elseif school == 1 then --Conjuration
        autoIcon = "s\\tx_s_turn_undead.dds"
        areaSound = "conjuration area"
        areaVFX = "VFX_DefaultArea"
        boltSound = "conjuration bolt"
        boltVFX = "VFX_DefaultBolt"
        castSound = "conjuration cast"
        castVFX = "VFX_ConjureCast"
        hitSound = "conjuration hit"
        hitVFX = "VFX_DefaultHit"
        particleTexture = "vfx_conj_flare02.tga"
    elseif school == 2 then  --Destruction
        autoIcon = "s\\Tx_s_dmg_fati.tga"
        areaSound = "destruction area"
        areaVFX = "VFX_DestructArea"
        boltSound = "destruction bolt"
        boltVFX = "VFX_DestructBolt"
        castSound = "destruction cast"
        castVFX = "VFX_DestructCast"
        hitSound = "destruction hit"
        hitVFX = "VFX_DestructHit"
        particleTexture = "vfx_alpha_bolt01.tga"
    elseif school == 3 then  --Illusion
        autoIcon = "s\\tx_s_cm_crture.dds"
        areaSound = "illusion area"
        areaVFX = "VFX_IllusionArea"
        boltSound = "illusion bolt"
        boltVFX = "VFX_IllusionBolt"
        castSound = "illusion cast"
        castVFX = "VFX_IllusionCast"
        hitSound = "illusion hit"
        hitVFX = "VFX_IllusionHit"
        particleTexture = "vfx_grnflare.tga"
    elseif school == 4 then  --Mysticism
        autoIcon = "s\\tx_s_alm_intervt.dds"
        areaSound = "mysticism area"
        areaVFX = "VFX_MysticismArea"
        boltSound = "mysticism bolt"
        boltVFX = "VFX_MysticismBolt"
        castSound = "mysticism cast"
        castVFX = "VFX_MysticismCast"
        hitSound = "mysticism hit"
        hitVFX = "VFX_MysticismHit"
        particleTexture = "vfx_bluecloud.tga"
    elseif school == 5 then  --Restoration
        autoIcon = "s\\Tx_S_ftfy_skill.tga"
        areaSound = "restoration area"
        areaVFX = "VFX_RestorationArea"
        boltSound = "restoration bolt"
        boltVFX = "VFX_RestoreBolt"
        castSound = "restoration cast"
        castVFX = "VFX_RestorationCast"
        hitSound = "restoration hit"
        hitVFX = "VFX_RestorationHit"
        particleTexture = "vfx_myst_flare01.tga"
    end
    --Return all the variables to be used in .create
    return autoIcon, areaSound, areaVFX, boltSound, boltVFX, castSound, castVFX, hitSound, hitVFX, particleTexture
end

--- @class EffectParams
--- @field id integer The unique identifier for the magic effect. (tes3.effect.light)
--- @field name string The name of the magic effect.
--- @field baseCost number? Default:1. The base cost of the magic effect.
--- @field school tes3.magicSchool The school of magic the effect belongs to.
--- @field icon string? Optional. The path to the icon representing the effect.
--- @field areaSound string? Default:Will Use placeholder fx for school. The sound played for area effects.
--- @field areaVFX string? Default:Will Use placeholder fx for school. The visual effects played for area effects.
--- @field boltSound string? Default:Will Use placeholder fx for school. The sound played when the effect is used in a bolt.
--- @field boltVFX string? Default:Will Use placeholder fx for school. The visual effects played when the effect is used in a bolt.
--- @field castSound string? Default:Will Use placeholder fx for school. The sound played when the effect is cast.
--- @field castVFX string? Default:Will Use placeholder fx for school. The visual effects played when the effect is cast.
--- @field hitSound string? Default:Will Use placeholder fx for school. The sound played when the effect hits a target.
--- @field hitVFX string? Default:Will Use placeholder fx for school. The visual effects played when the effect hits a target.
--- @field particleTexture string? Default:Will Use placeholder fx for school. The texture of the particles used in the effect.
--- @field description string? Optional. A description of the effect.
--- @field size number? Default:1. The size parameter of the effect.
--- @field sizeCap number? Default:1. The maximum size of the effect.
--- @field speed number? Default:1. The speed at which the effect travels.
--- @field lighting table? Optional. Example { x = 0.99, y = 0.26, z = 0.53 }. Lighting effects associated with the magic effect.
--- @field usesNegativeLighting boolean? Whether the effect uses negative lighting.
--- @field hasContinuousVFX boolean? Default:false. Whether the effect has continuous visual effects.
--- @field allowEnchanting boolean? Whether the effect can be used in enchanting.
--- @field allowSpellmaking boolean? Whether the effect can be used in spellmaking.
--- @field appliesOnce boolean? Whether the effect applies once or continuously.
--- @field canCastSelf boolean? Default: true. Whether the effect can be cast on self.
--- @field canCastTarget boolean? Default: true. Whether the effect can be cast on a target.
--- @field canCastTouch boolean? Default: true. Whether the effect can be cast by touch.
--- @field casterLinked boolean? Default: true. Whether the effect is linked to the caster.
--- @field hasNoDuration boolean? Default: false. Whether the effect has no duration.
--- @field hasNoMagnitude boolean? Default: false. Whether the effect has no magnitude.
--- @field illegalDaedra boolean? Default: false. Whether the effect is illegal for Daedra.
--- @field isHarmful boolean? Default: false. Whether the effect is considered harmful.
--- @field nonRecastable boolean? Whether the effect is non-recastable.
--- @field targetsAttributes boolean? Whether the effect targets attributes.
--- @field targetsSkills boolean? Whether the effect targets skills.
--- @field unreflectable boolean? Whether the effect is unreflectable.
--- @field onTick function? Optional. The function called each tick the effect is active.
--- @field onCollision function? Optional. The function called when the effect collides.

--- @param params EffectParams The configuration table for the new magic effect.
function effectMaker.create(params)
    --Default name if not supplied. (dont remember why i needed this, something wasnt working right)
    params.name = params.name or "Error: Unnamed Effect"
    -- Set school variable to either the entered school or a default if something goes wrong.
    local school = params.school or tes3.magicSchool["alteration"]
    -- Getting all the variables from .getSchool, get in same order, and use _, to skip
    local autoIcon, areaSound, areaVFX, boltSound, boltVFX, castSound, castVFX, hitSound, hitVFX, particleTexture = effectMaker.getSchool(school)

    print("Registering " .. params.id .. " in school index" .. params.school)
    local effect = tes3.addMagicEffect({
        id = params.id,
        name = params.name,
        baseCost = params.baseCost or 1,
        school = params.school,

        areaSound = params.areaSound or areaSound,
        areaVFX = params.areaVFX or areaVFX,
        boltSound = params.boltSound or boltSound,
        boltVFX = params.boltVFX or boltVFX,
        castSound = params.castSound or castSound,
        castVFX = params.castVFX or castVFX,
        description = params.description,
        hasContinuousVFX = params.hasContinuousVFX or false,
        hitSound = params.hitSound or hitSound,
        hitVFX = params.hitVFX or hitVFX,
        icon = params.icon or autoIcon or "default icon.tga",
        lighting = params.lighting,
        particleTexture = params.particleTexture or particleTexture,
        size = params.size or 1,
        sizeCap = params.sizeCap or 1,
        speed = params.speed or 1,
        usesNegativeLighting = params.usesNegativeLighting or false,

        allowEnchanting = params.allowEnchanting or false,
        allowSpellmaking = params.allowSpellmaking or false,
        appliesOnce = params.appliesOnce or false,
        canCastSelf = params.canCastSelf or true,
        canCastTarget = params.canCastTarget or true,
        canCastTouch = params.canCastTouch or true,
        casterLinked = params.casterLinked or true,
        hasNoDuration = params.hasNoDuration or false,
        hasNoMagnitude = params.hasNoMagnitude or false,
        illegalDaedra = params.illegalDaedra or false,
        isHarmful = params.isHarmful or false,
        nonRecastable = params.nonRecastable or false,
        targetsAttributes = params.targetsAttributes or false,
        targetsSkills = params.targetsSkills or false,
        unreflectable = params.unreflectable or false,

        onTick = params.onTick or nil,
        onCollision = params.onCollision or nil,
    })
    return effect
end

return effectMaker
