local spellMaker = {}
local logger = require("logging.logger")
local log = logger.getLogger("Arkays Logger") or "Logger Not Found"

function spellMaker.calculateEffectCost(spell)
    local totalCost = 0 --Initialize totalCost to add too
    for i=1, spell:getActiveEffectCount() do -- this line straight taken from magickaExpanded framework
        local effect = spell.effects[i] --set effect to for every id.effects[1-2-3-etc] 
        if (effect ~= nil) then --if effect is valid
            local minMag = effect.min or 0
            local maxMag = effect.max or 1
            local duration = effect.duration or 1
            local area = effect.area or 1
            local baseEffectCost = effect.object.baseMagickaCost
            local ranged = 1

            if effect.rangeType == tes3.effectRange.target then
                ranged = 1.5 -- Increase cost by 50% for target range effects
            end

            -- Calculate the cost of the effect
            local cost = ((minMag + maxMag) * (duration + 1)+ area) * (baseEffectCost / 40) * ranged
            totalCost = totalCost + cost
        end
    end
    return totalCost
end

--- @class SpellParams
--- @field id string The unique identifier for the spell.
--- @field name string The name of the spell.
--- @field castType tes3.spellType? 'ability' | 'blight' | 'curse' | 'disease' | 'power' | 'spell'? Optional. Defaults to spell
--- @field alwaysSucceeds boolean? Optional. A flag that determines if casting the spell will always succeed. Defaults to false.
--- @field effect tes3.effect The effect ID from the tes3.effect table.
--- @field min integer The minimum magnitude of the spell's effect.
--- @field max? integer Optional. The maximum magnitude of the spell's effect. Defaults to min.
--- @field duration? integer Optional. The duration of the spell's effect. Defaults to 0.
--- @field range tes3.effectRange? Optional. The range type of the spell. Must be 'self' for abilities. Defaults to 'self'.
--- @field radius integer? The radius of the effect in feet.
--- @field attribute tes3.attribute? Use for Fortify Attribute Spells. The attribute associated with this effect. Defaults to nil.
--- @field cost number? Optional. If not set spell Auto Calculates cost using vanilla Formula. The base magicka cost of this effect.
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
            rangeType = params.range or tes3.effectRange["self"],
            radius = params.radius,
            attribute = params.attribute or nil,
            skill = params.skill or nil,
        }},

        autoCalc = params.autoCalc or false,
        playerStart = params.playerStart or false,
        sourceless = params.sourceless or true,
    })
    -- if (spell.effects[1].id == nil) then
    --     error("Nil Effect")
    -- end
    spell.magickaCost = params.cost or spellMaker.calculateEffectCost(spell) --Auto Calculate spell cost if, you dont set one
    return spell
end

function spellMaker.createAdvanced(params)
    local spell = tes3.getObject(params.id) or tes3.createObject({
        objectType = tes3.objectType.spell,
        id = params.id,
        name = params.name,
        castType = params.castType or tes3.spellType["spell"],
        alwaysSucceeds = params.alwaysSucceeds or false,

        effects = {},

        autoCalc = params.autoCalc or false,
        playerStart = params.playerStart or false,
        sourceless = params.sourceless or true,
    })
    --Really struggling with for loops :(
    for i, newEffect in ipairs(params.effects) do
        local effect = spell.effects[i] or {}

        effect.id = newEffect.effect
        effect.rangeType = newEffect.range or tes3.effectRange.self
        effect.min = newEffect.min or 0
        effect.max = newEffect.max or newEffect.min
        effect.duration = newEffect.duration or 0
        effect.radius = newEffect.radius or 0
        effect.skill = newEffect.skill or nil
        effect.attribute = newEffect.attribute or nil

        spell.effects[i] = effect
    end


    -- for i=1, #params.effects do
    --     local effect = spell.effects[i]
    --     local newEffect = params.effects[i]

    --     effect.id = newEffect.effect
    --     effect.rangeType = newEffect.range or tes3.effectRange.self
    --     effect.min = newEffect.min or 0
    --     effect.max = newEffect.max or newEffect.min
    --     effect.duration = newEffect.duration or 0
    --     effect.radius = newEffect.radius or 0
    --     effect.skill = newEffect.skill or nil
    --     effect.attribute = newEffect.attribute or nil
    -- end




    spell.magickaCost = params.cost or
    spellMaker.calculateEffectCost(spell)                                    --Auto Calculate spell cost if, you dont set one
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
