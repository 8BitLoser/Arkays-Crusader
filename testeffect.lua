




local function onFireDmgTick(tickParams)
    local target = tickParams.effectInstance.target
    local targetHealth = target.mobile.health
    -- This will print current health for any actor our spell hit,
    -- so we can see if it works as expected
    tes3.messageBox(
        "%s, health: %s",
        target.object.id,
        targetHealth.current
    )

    tickParams:trigger({
        type = tes3.effectEventType.modStatistic,
        -- The resistance attribute against Fire Damage should be Resist Fire
        attribute = tes3.effectAttribute.resistFire,

        -- The variable this effect affects
        value = targetHealth,
        negateOnExpiry = false,
        isUncapped = true,
    })
end

tes3.claimSpellEffectId("testEffect", 220)
local effectMaker = require("BeefStranger.Arkays Crusader.effectMaker")
local function addEffects()

    local effectTester = effectMaker.create({
        id = tes3.effect.testEffect,
        name = "effectTester",
        school = tes3.magicSchool["conjuration"],
        ontick = onFireDmgTick
    })
end

event.register("magicEffectsResolved", addEffects)






-- tes3.claimSpellEffectId("testEffect", 220)








-- local function addEffects()    
--     tes3.addMagicEffect({
--         -- The ID we claimed before is now available in tes3.effect namespace
--         id = tes3.effect.testEffect,

--         -- This information is copied from the Construction Set
--         name = "Fire Damage",
--         description = ("This spell effect produces a manifestation of elemental fire. Upon " ..
--         "contact with an object, this manifestation explodes, causing damage."),
--         baseCost = 5,
--         school = tes3.magicSchool.destruction,
--         size = 1.25,
--         sizeCap = 50,
--         speed = 1,
--         lighting = { x = 0.99, y = 0.26, z = 0.53 },
--         usesNegativeLighting = false,

--         icon = "s\\Tx_S_fire_damage.tga",
--         particleTexture = "vfx_firealpha00A.tga",
--         castSound = "destruction cast",
--         -- castVFX = "VFX_DestructCast",
--         boltSound = "destruction bolt",
--         -- boltVFX = "VFX_DestructBolt",
--         hitSound = "destruction hit",
--         -- hitVFX = "VFX_DestructHit",
--         areaSound = "destruction area",
--         -- areaVFX = "VFX_DestructArea",

--         --optional
--         -- appliesOnce = false,
--         -- hasNoDuration = false,
--         -- hasNoMagnitude = false,
--         -- illegalDaedra = false,
--         -- unreflectable = false,
--         -- casterLinked = false,
--         -- nonRecastable = false,

--         --MUST BE DEFINED OR NAME BREAKS
--         targetsAttributes = false,
--         targetsSkills = false,

--         -- onTick = onFireDmgTick,
--     })
-- end

-- event.register("magicEffectsResolved", addEffects)
