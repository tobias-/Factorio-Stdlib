--- The Core module loads some helper functions usefull in all stages
-- of a mods lifecyle.
-- @module Core
-- @usage local Core = require('stdlib/core')

require 'stdlib/utils/table'
require 'stdlib/utils/string'
require 'stdlib/utils/iterators'
require 'stdlib/utils/math'
require 'stdlib/defines/color'
require 'stdlib/defines/time'

local Core = {
    _protect = function(module_name)
        return {
            __newindex = function() error("Attempt to mutatate read-only "..module_name.." Module") end,
            __metatable = {}
        }
    end,
    _concat = function(lhs, rhs)
        --Sanatize to remove address
        return tostring(lhs):gsub("(%w+)%: %x+", "%1: (ADDR)") .. tostring(rhs):gsub("(%w+)%: %x+", "%1: (ADDR)")
    end,
    _rawstring = function (t)
        local m = getmetatable(t)
        local f = m.__tostring
        m.__tostring = nil
        local s = tostring(t)
        m.__tostring = f
        return s
    end,
    -- No Doc
    -- This is a helper global and functions until .16 to set the name of your mod in control.lua set _stdlib_mod_name = 'name of your mod'
    _get_mod_name = function(name)
        local ok, mod_name = pcall(function() return script.mod_name end)
        return ok and mod_name or name or _stdlib_mod_name or "stdlib" -- luacheck: ignore _stdlib_mod_name
    end,
}

--- Print msg if specified var evaluates to false.
-- @tparam Mixed var variable to evaluate
-- @tparam[opt="missing value"] string msg message
function Core.fail_if_missing(var, msg)
    if not var then
        error(msg or "Missing value", 3)
    end
    return false
end

function Core.fail_if_not_type(var, types)
    error("Required parameter "..var.." must be: " .. table.concat(types, ", or"), 2)
end

--- Require a file that may not exist
-- @tparam string module path to the module
-- @treturn mixed
function Core.prequire(module)
    local ok, err = pcall(require, module)
    if ok then
        return err
    end
end

function Core.add_fields(to, from)
    for k, v in pairs(from) do
        to[k] = v
    end
end

return Core
