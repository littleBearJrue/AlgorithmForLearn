--[[--ldoc desc
@module shuffleAlgorithm
@author JrueZhu

Date   2019-07-17 15:20:38
Last Modified by   Jrue
Last Modified time 2019-07-17 15:32:15
]]

--[[
	洗牌算法
--]]

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

local originData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

function swap(data, a, b)
	data[a] = data[a] + data[b]
	data[b] = data[a] - data[b]
	data[a] = data[a] - data[b]
end

function shuffle()
	print("洗牌算法前的数据:", table.tostring(originData))
	for i = #originData, 2, -1 do
		swap(originData, i, math.random(1, i - 1))
	end
	print("洗牌算法后的数据:", table.tostring(originData))
end

shuffle()