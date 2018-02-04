--- The Core module loads some helper functions usefull in all stages
-- of a mods lifecyle.
-- @module Core
-- @usage local Core = require('stdlib/core')

require('stdlib/utils/table')
require('stdlib/utils/string')
require('stdlib/utils/iterators')
require('stdlib/utils/math')
require('stdlib/defines/color')
require('stdlib/defines/time')

local Core = {
    _module_name = "Core",
    _protect = function(this, caller, class_name)
        local meta = getmetatable(this)
        local name = this._module_name or class_name or "Unknown"

        if meta and not meta.__metatable then
            meta.__newindex = function() error("Attempt to mutatate read-only "..name.." Module") end
            meta.__metatable = meta
            meta.__call = caller
        end
        return this
    end,

    _setmetatable = function(this, meta)
        return setmetatable(this, meta)
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

--- Returns true if the passed variable is a table.
-- @tparam mixed var The variable to check
-- @treturn boolean
function Core.is_table(var)
    return type(var) == "table"
end

--- Returns true if the passed variable is a string.
-- @tparam mixed var The variable to check
-- @treturn boolean
function Core.is_string(var)
    return type(var) == "string"
end

--- Returns true if the passed variable is a number.
-- @tparam mixed var The variable to check
-- @treturn boolean
function Core.is_number(var)
    return type(var) == "number"
end

--- Returns true if the passed variable is a boolean.
-- @tparam mixed var The variable to check
-- @treturn boolean
function Core.is_bool(var)
    return type(var) == "boolean"
end

--- Returns true if the passed variable is nil.
-- @tparam mixed var The variable to check
-- @treturn boolean
function Core.is_nil(var)
    return type(var) == "nil"
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

--- Sets the __call metamethod on the metatable.
-- @tparam table this The object to get the metatable for
-- @tparam function caller The function to set to __call
-- @treturn table with metatable attached
function Core.set_caller(this, caller)
    if getmetatable(this) then
        getmetatable(this).__call = caller
        return this
    else
        error("Metatable not found", 2)
    end
end

return Core
