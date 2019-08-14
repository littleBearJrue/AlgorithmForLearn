--[[--ldoc desc
@module tableUtils
@author Jrue

Date   2019-08-14 14:17:10
Last Modified by   Jrue
Last Modified time 2019-08-14 16:10:39
]]
function table.tostring(root)
    if not root then return end
    local cache = {  [root] = "root" }
    local flag = {};
    local function _dump(t,name)
        local mt = getmetatable(t)
        if mt and mt.__tostring then
            return tostring(t)
        end
        local temp = {}
        for i,v in ipairs(t) do
            flag[i] = true;
            if cache[v] then
                table.insert(temp, cache[v])
            elseif type(v) == "table" then
                cache[v] = string.format("%s[%d]", name, i)
                table.insert(temp, string.format("%s", _dump(v, cache[v])))
            else
                table.insert(temp, tostring(v))
            end
        end
        for k,v in pairs(t) do
            if not flag[k] then
                local key = tostring(k)
                if cache[v] then
                    table.insert(temp, string.format("%s=%s", key, cache[v]))
                elseif type(v) == "table" then
                    cache[v] = string.format("%s.%s", name, key)
                    table.insert(temp, string.format("%s=%s", key, _dump(v, cache[v])))
                else
                    table.insert(temp, string.format("%s=%s", key, tostring(v)))
                end
            end
        end
        return string.format("{%s}", table.concat(temp,","));
    end
    return _dump(root, "root");
end

local function checktable(value)
    if type(value) ~= "table" then value = {} end
    return value
end

function table.nums(t)
    local temp = checktable(t)
    local count = 0
    for k, v in pairs(temp) do
        count = count + 1
    end
    return count
end

function table.clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function table.swap(data, a, b)
	data[a] = data[a] + data[b]
	data[b] = data[a] - data[b]
	data[a] = data[a] - data[b]
end

return {
	tostring = table.tostring,
	nums = table.nums,
	clone = table.clone,
	swap = table.swap,
}