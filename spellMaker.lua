local spellMaker = {}

function spellMaker.calculateSpellCost(effect)
    local totalCost = 0
    for _, effect in ipairs(effect) do
        local minMag = effect.min or 0
        local maxMag = effect.max or 1
        local duration = effect.duration or 1
        local area = effect.area or 1
        local baseEffectCost = effect.object.baseMagickaCost or 150 --TEST VALUE REMOVE!
        local ranged = 1

        if effect.rangeType == tes3.effectRange.target then
            ranged = 1.5 -- Increase cost by 50% for target range effects
        end

        -- Calculate the cost of the effect
        local cost = ((minMag + maxMag) * (duration + 1)+ area) * (baseEffectCost / 40) * ranged
        totalCost = totalCost + cost
    end
    return totalCost
end

--[[
Spell Cost (the amount of Magicka a spell takes to cast) for Custom Spells is:
( { Min Magnitude + Max Magnitude } * {Duration + 1 }+ Area ) * Base Cost / 40,
rounded down
]]



--- @class SpellParams
--- @field id string The unique identifier for the spell.
--- @field name string The name of the spell.
--- @field castType tes3.spellType? Optional. Defaults to spell
--- @field alwaysSucceeds boolean? Optional. A flag that determines if casting the spell will always succeed. Defaults to false.
--- @field effect tes3.effect The effect ID from the tes3.effect table.
--- @field min integer The minimum magnitude of the spell's effect.
--- @field max? integer Optional. The maximum magnitude of the spell's effect. Defaults to min.
--- @field duration? integer Optional. The duration of the spell's effect. Defaults to 0.
--- @field range 'target' | 'touch' | 'self'? Optional. The range type of the spell. Must be 'self' for abilities. Defaults to 'self'.
--- @field radius integer? The radius of the effect in feet.
--- @field attribute tes3.attribute? Use for Fortify Attribute Spells. The attribute associated with this effect. Defaults to nil.
--- @field cost number? Optional. The base magicka cost of this effect.
--- @field skill tes3.skill? Optional. The skill associated with this effect. Defaults to nil
--- @field autoCalc boolean? Optional. Defaults to falseDetermines if the magicka cost for the spell is autocalculated, and if the spell may be automatically assigned to NPCs if they are skillful enough to cast it.
--- @field sourceless boolean? Optional. Defaults to true. Sets the spell to sourceless
--- @field playerStart boolean? Optional. Defaults to false. A flag that determines if the spell may be assigned to the player at character generation if the player has enough skill to cast it.
--- @param params SpellParams The configuration table for the new spell.
function spellMaker.createBasic(params)
    local spell = tes3.getObject(params.id) or tes3.createObject({
        objectType = tes3.objectType.spell,
        id = params.id,
        name = params.name,
        castType = params.castType or tes3.spellType["spell"],
        alwaysSucceeds = params.alwaysSucceeds or false,

        

        effects = {{
            id = params.effect,
            min = params.min,
            max = params.max or params.min,
            duration = params.duration or 0,
            rangeType = tes3.effectRange[params.range] or tes3.effectRange["self"],
            radius = params.radius,

            attribute = params.attribute or nil,
            -- cost = params.cost,
            skill = params.skill or nil,
            -- cost = calculatedCost,
        }},

        

        autoCalc = params.autoCalc or false,
        playerStart = params.playerStart or false,
        sourceless = params.sourceless or true,
    })
    local calculatedCost = params.cost or spellMaker.calculateSpellCost(spell)

    return spell
end
return spellMaker






































---- @param params SpellParams The configuration table for the new spell.
---- @return tes3spell spell The
-- @param params table: Configuration table for the new spell.
-- @field id string: The unique identifier for the spell.
-- @field name string: The name of the spell.
-- @field effectId integer: The effect ID from the tes3.effect table.
-- @field min integer: The minimum magnitude of the spell's effect.
-- @field max integer: The maximum magnitude of the spell's effect.
-- @field duration integer: The duration of the spell's effect.
-- @field range string: The range type of the spell ('target', 'touch', 'self').
-- @return tes3spell: The newly created spell object.
