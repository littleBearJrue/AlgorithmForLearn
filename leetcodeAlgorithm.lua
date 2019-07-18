-- @Author: Jrue
-- @Date:   2019-07-17 23:15:05
-- @Last Modified by:   Jrue
-- @Last Modified time: 2019-07-18 23:11:16


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


--[[
	问题描述：
	报数序列是一个整数序列，按照其中的整数的顺序进行报数，得到下一个数。其前五项如下：
	1. 1
	2. 11
	3. 21
	4. 1211
	5. 111221
--]]
--[[
	递归实现：
	1. 递归的终止条件
	2. 函数的等价关系式
--]]
-- function countNum(num)
-- 	if num == 1 then
-- 		return "1"
-- 	end
-- 	local preResult = countNum(num - 1)
-- 	print("preResult:", preResult)
-- 	local reuslt
-- 	local sameCount = 1
-- 	for i = 1, #preResult do
-- 		print("preResult[i]:", preResult[i])
-- 		print("preResult[i + 1]:", preResult[i + 1])
-- 		if preResult[i + 1] then
-- 			if preResult[i] == preResult[i + 1] then
-- 				sameCount = sameCount + 1
-- 			elseif preResult[i] ~= preResult[i + 1] then
-- 				reuslt = tostring(sameCount) + tostring(preResult[i])
-- 				sameCount = 1
-- 			end
-- 		end
-- 	end

-- 	return reuslt
-- end


--[[
	TWO SUMS
	在数组中找到2个数之和等于给定值的数字，结果返回2个数字在数组中的下标。
	Given nums = [2, 7, 11, 15], target = 9,
	Because nums[0] + nums[1] = 2 + 7 = 9,
	return [0, 1].

--]]
function twoSums(data, target)
	local result = {}
	if data and #data > 0 then
		for i = 1, #data do
			local another = target - data[i]
			if result[another] then
				return {result[another], i}
			end
			result[data[i]] = i
		end
	end
	return result
end

function main()
	-- local resultData = countNum(5)
	local resultData = twoSums({2, 7,11,15, 1, 8, 3, 6}, 9)
	print("输出结果：", table.tostring(resultData))
end

main()