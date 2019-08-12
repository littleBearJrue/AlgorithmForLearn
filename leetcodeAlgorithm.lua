-- @Author: Jrue
-- @Date:   2019-07-17 23:15:05
-- @Last Modified by   Jrue
-- @Last Modified time 2019-08-12 16:10:23

require "bit"
local SortUtil = require(".sortingAlgorithm")

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

-------------------------------------- 字符串相关算法 start----------------------------------------------------
function string2Table(str)
    local strTable = {}
    for i = 1, string.len(str) do
        local subStr = string.sub(str, i, i)
        table.insert(strTable, subStr)
    end
    return strTable
end

function table2String(strTable)
    local str = ""
    for i = 1, #strTable do
        str  = str .. strTable[i]
    end
    return str
end

--[[
    字符串反转：
    给定一个字符串，要求将字符串前面的若干字符移到字符串的尾部
--]]
function stringReverse(originStr, n)
    local function shiftSubStr(str, from, to)
        while(from < to) do
            local temp = str[to]
            str[to] = str[from]
            str[from] = temp
            from = from + 1
            to = to - 1
        end
    end
    local strTable = string2Table(originStr)
    -- 先反转前一部分字符串
    shiftSubStr(strTable, 1, n)
    -- 在反转后一部分字符串
    shiftSubStr(strTable, n + 1, #strTable)
    -- 最后对整个字符串进行反转
    shiftSubStr(strTable, 1, #strTable)

    return table2String(strTable)
end

--[[
    字符串的包含
    给定一个长字符串a和短字符串b,判断出短字符串b中是否所有字符都在长字符串中
    方法一： 排序后轮询（O(mlongm) + O(nlogn)）
    方法二： 素数相乘 （O(m + n)）
    方法三：位运算法（O(m + n)）
    这里使用位运算法。也可以尝试使用hashmap的映射方式实现

--]]
function stringContain(originStr, targetStr)
    local hash = 0
    local originTable = string2Table(originStr)
    local targetTable = string2Table(targetStr)
    for i = 1, #originTable do
        hash = bit.bor(hash, bit.lshift(1, string.byte(originTable[i]) - string.byte("A")))
        print("1111:",string.byte(originTable[i]) - string.byte("A"))
        print("2222:",bit.lshift(1, string.byte(originTable[i]) - string.byte("A")))
        print("hash:", hash)
    end
    for j = 1, #targetTable do
        if bit.band(hash, bit.lshift(1, string.byte(targetTable[j]) - string.byte("A"))) == 0 then
            return false
        end
    end
    return true
end

--[[
    字符串全排列
    输入一个字符串，打印出该字符串中字符的所有排列
--]]
function StringAllSort(originStr)
    
end


--[[
    字符串转化为整数输出
--]]
function StringToInt(originStr)
    local originTable = string2Table(originStr)
    if #originTable <= 0 then
        return 0
    end
    local flag = 1
    local result = 0
    local beginIndex = 1
    if originTable[1] == "-" then
        flag = -1
        beginIndex = 2
    end
    for i = beginIndex, #originTable do
        if string.byte(originTable[i]) > string.byte("0") and string.byte(originTable[i]) < string.byte("9") then
            result = result * 10 +  (string.byte(originTable[i]) - string.byte("0"))
        end 
        
    end
    return result * flag
end

--[[
    字符串回文
--]]
function stringPalindrome(originStr)
    local originTable = string2Table(originStr)
    if #originTable <= 0 then
        return false
    end
    local begin = 1
    local last = #originTable
    while(begin < last) do
        if originTable[begin] == originTable[last] then
            begin = begin + 1
            last = last - 1
        else
            return false
        end
    end
    return true
end

--[[
    最长回文子串
    方法一：中心拓展法：从中心向两边拓展，判断两边的数是否相等，记录相等时子串的总长度，这里要奇偶数回文字串
    方法二：manacher算法： 在每个字符之间插入“#”,解决了要处理奇偶的问题，因为插入之后只能变成了变成了奇数。
--]]
function stringLongestPalindrome(originStr)
    local originTable = string2Table(originStr)
    local adjustTable = {}
    for i = 1, #originTable do
        table.insert(adjustTable, "#")
        table.insert(adjustTable, originTable[i])
    end
    table.insert(adjustTable, "#")

    local RL = {}       -- 记录每个index下回文字符串的长度
    local right = -1    -- 当前回文的右边界
    local center = -1   -- 当前回文的中心
    local max = -1      -- 当前回文的最大值

    for i = 1, #adjustTable do
        if right > i then
            RL[i] = math.min(RL[2 * center - i], right - i)
        else
            RL[i] = 1
        end

        while(i - RL[i] > 0 and i + RL[i] < #adjustTable) do
            if (adjustTable[i - RL[i]] == adjustTable[i + RL[i]]) then
                RL[i] = RL[i] + 1
            else
                break
            end
        end

        if i + RL[i] > right then
            right = i + RL[i]
            center = i
        end
        max = math.max(max, RL[i])
    end
    return max - 1
end

-------------------------------------- 字符串相关算法 end----------------------------------------------------


-------------------------------------- 数组相关算法 start----------------------------------------------------

function swap(data, a, b)
    data[a] = data[a] + data[b]
    data[b] = data[a] - data[b]
    data[a] = data[a] - data[b]
end


--[[
    寻找最小的k个数
    1. 快速排序，从小到大筛选
    2. 部分排序，再筛选
    3. 用最小堆的方式来寻找(适用于海量数据，从磁盘硬盘中读取数据部分数据，在进行最小堆操作)
    4. 使用平均复杂度为O(n)的快速排序算法
--]]
function findLastestNumWithHeap(data, k)
    local function buildMinHeap(arr, headNodePos, size)
        if headNodePos < size then
            local leftChildNodePos = 2 * headNodePos
            local rightChildNodePos = 2 * headNodePos + 1
            local minPos = headNodePos

            if leftChildNodePos < size and arr[leftChildNodePos] < arr[minPos] then
                minPos = leftChildNodePos
            end

            if rightChildNodePos < size and arr[rightChildNodePos] < arr[minPos] then
                minPos = rightChildNodePos
            end

            if minPos ~= headNodePos then
                swap(arr, headNodePos, minPos)

                buildMinHeap(arr, minPos, size)
            end
        end
    end

        local function buildMaxHeap(arr, headNodePos, size)
        if headNodePos < size then
            -- 找到左子节点的位置(因为lua语法是从index 1开始算起的，正常的左子节点为 2*x+1)
            local leftNodePos = 2 * headNodePos
            -- 找到右子节点的位置(因为lua语法是从index 1开始算起的，正常的右子节点为 2*x+2)
            local rightNodePos = 2 * headNodePos + 1
            -- 先把当前头节点位置当做是最大值所在位置
            local maxPos = headNodePos
            
            -- 判断左子节点的位置是否大于最大值，则更新最大值所在位置
            if leftNodePos < size and arr[leftNodePos] > arr[maxPos] then
                maxPos = leftNodePos
            end

            -- 判断右子节点的位置是否大于最大值，则更新最大值所在位置
            if rightNodePos < size and arr[rightNodePos] > arr[maxPos] then
                maxPos = rightNodePos
            end

            -- 假如当前的头节点不是最大值所在位置，则需要交换彼此的位置
            if maxPos ~= headNodePos then

                swap(arr, headNodePos, maxPos)
            
                -- 继续比较建堆
                buildMaxHeap(arr, maxPos, size)
            end 
        end
    end

    if data == nil or #data == 1 or #data == 2 then
        return {}
    end

    -- math.floor(k / 2) 最尾父节点
    for i =  math.floor(k / 2), 1, -1 do
        buildMaxHeap(data, i, k)
    end

    for i = k + 1, #data do
        print("data[i]: ", data[i])
        print("data[1]: ", data[1])
        if data[i] < data[1] then
            swap(data, 1, i)
        
            buildMaxHeap(data, 1, k)
        end
    end
    return data
end

--[[
    找出数组中最大的两个数之和：
    先快速排序，时间复杂度为O(nlogn)
    再进行前后指针扫描，找到目标值，时间复杂度为O(n)
    总共为O(nlogn + n) = O(nlogn)
--]]
function findTwoSums(data, targetNum)
    SortUtil.quickSort(data, 1, #data)
    print("data: ",data) 
    local beginIndex = 1
    local endIndex = #data
    while(beginIndex < endIndex) do
        local twoSums = data[beginIndex] + data[endIndex]
        if twoSums  == targetNum then
            break
        else
            if twoSums > targetNum then
                endIndex = endIndex - 1
            else
                beginIndex = beginIndex + 1
            end
        end
    end
    print("111111111: ", beginIndex, endIndex)
    return {data[beginIndex], data[endIndex]} 
end

--[[
    最大连续子数组之和
    时间复杂度为O(n)
--]]
function findMaxSubArray(data)
    local size = #data
    local curSum = 0
    local maxSum = data[1]
    for i = 1, #data do
        if curSum > 0 then
            curSum = curSum + data[i]
        else
            curSum = data[i]
        end

        if curSum > maxSum then
            maxSum = curSum
        end
    end
    return maxSum
end

--[[
    奇偶数排序：给定一个数组，调整数组中的顺序，使得所有奇数位于数组的前半部分，偶数位于数组的后半部分。时间复杂度为O(n)
    这里想到了快速排序方法，只是找找大小值变成了找奇偶数
--]]
function oddEvenSort(data)
    local function isOddNum(value)
        return value % 2 == 0
    end
    local beginIndex = 1
    local endIndex = #data
    while(beginIndex < endIndex) do
        if isOddNum(data[beginIndex]) then
            beginIndex = beginIndex + 1
        elseif not isOddNum(data[endIndex]) then
            endIndex = endIndex - 1
        else
            swap(data, endIndex, beginIndex)
        end
    end
    return data
end

--[[
    荷兰国旗算法
    现有n个红白蓝三种不同颜色的小球乱序排列，请通过两两交换的方式实现从左到右排列为红球，白球，蓝球。
    其中0：红球   1：白球   2：蓝球
--]]
function arrayColorSort(data)
    local beginIndex = 1
    local currentIndex = 1
    local endIndex = #data
    while(currentIndex < endIndex) do
        if data[currentIndex] == 0 then
            swap(data, currentIndex, beginIndex)
            currentIndex = currentIndex + 1
            beginIndex = beginIndex + 1
        elseif data[currentIndex] == 1 then
            currentIndex = currentIndex + 1
        elseif data[currentIndex] == 2 then
            swap(data, currentIndex, endIndex)

            endIndex = endIndex - 1
        end
    end
    return data
end

--[[
    给定一个有序的数组，查找某个数是否存在在这数组中
    （典型的二分查找）
--]]
function BinarySearch(data, targetValue)
    local left = 1
    local right = #data
    while(left <= right) do
        local middle = left + bit.rshift(right - left, 1)
        if data[middle] > targetValue then
            right = middle - 1
        elseif data[middle] < targetValue then
            left = middle + 1
        else
            return true
        end
    end
    return false
end

--[[
    计算最大/最小连续乘积值 时间复杂度O(n)
--]]
function findMaxAndMinMultipleArray(data)
    local maxEnd = data[1]
    local minEnd = data[1]
    local maxResult = data[1]
    local minResult = data[1]
    for i = 2, #data do
        local curVaule1 = maxEnd * data[i]
        local curValue2 = minEnd * data[i]
        maxEnd = math.max(math.max(curVaule1, curValue2), data[i])
        minEnd = math.min(math.min(curVaule1, curValue2), data[i])

        maxResult = math.max(maxResult, maxEnd)
        minResult = math.min(minResult, minEnd)
    end
    return {maxResult, minResult}
end



-------------------------------------- 数组相关算法 end----------------------------------------------------



---------------------------------------- 树相关算法 start--------------------------------------------------



---------------------------------------- 树相关算法 end----------------------------------------------------

-------------------------------------- 屌屌的算法 start----------------------------------------------------
--[[
    约瑟夫环问题：
    编号为 1-N 的 N 个士兵围坐在一起形成一个圆圈，从编号为 1 的士兵开始依次报数（1，2，3...这样依次报），
    数到 m 的 士兵会被杀死出列，之后的士兵再从 1 开始报数。直到最后剩下一士兵，求这个士兵的编号
    1. 使用数组实现，将选中的位置value值置为-1
    2. 使用循环链表实现，将选中的位置节点删除
    3. 使用递归的方式实现,循环条件为old = (new + m - 1) % n + 1
    这里使用递归的方式实现
--]]
function  josephRing(totalNum, targetNum)
    if totalNum == 1 then
        return totalNum
    end
    return (josephRing(totalNum - 1, targetNum) + targetNum - 1) % totalNum + 1
end

--[[
    洗牌算法
--]]
function shuffle(data)
    for i = #data, 2, -1 do
        swap(data, i, math.random(1, i - 1))
    end
    return data
end

--[[
    实现算术加法：1+2+3+4+...+n
    不能使用乘除法，for while if switch case等关键字和判断条件，如三元
--]]
-- function specialAdd(totalNum)
--     local sum = totalNum
--     -- lua语言没法模拟三元运算符
--     local t = (sum ~= 0 and (sum += specialAdd(totalNum - 1)) ~= 0)
--     return sum
-- end


--[[
    通过位运算实现算术相加
     a + b = a ^ b + (a & b) << 1
      a ^ b ： 实现不算进位的相加
      (a & b) << 1： 实现需要进位的相加
--]]
function specialTwoNumsAdd(num1, num2)
    local temp = 0
    while(num1 ~= 0) do
        print("num1-num2:", num1, num2)
        temp = bit.bxor(num1, num2)
        print("temp:", temp)
        num1 = bit.lshift(bit.band(num1, num2), 1)
        print("num1:", num1)
        num2 = temp
        print("num2:", num2)
    end
    return num2
end

--[[
    实现算术相乘的算法
--]]
function specialMult(num1, num2)
    if num1 == 0 or num2 == 0 then
        return 0
    end
    if num1 == 1 then
        return num2
    end
    if num2 == 1 then
        return num1
    end
    return num1 + specialMult(num1, num2 - 1)

end

-------------------------------------- 屌屌的算法 end----------------------------------------------------

---------------------------------------- 查找相关算法 start----------------------------------------------
--[[
    找出数组中出现次数超过一半的数
    1. 对数组进行排序，既然是次数超过一半的数，那n/2肯定就是那个数了 O(nLogn + n)
    2. 散列表 O(n)
    3. 通过每次删除不同的数，最终留下来的数就是想要的 O(n)
--]]
function findHalfOfAppearWithDel(data)
    for i = #data, 1, -1 do
        if data[i - 1] and data[i] ~= data[i - 1] then
            table.remove(data, i)
            table.remove(data, i - 1)
            i = i - 2
        end
    end
    if data and #data > 0 then
        return data[1]
    end
    return -1
end


---------------------------------------- 查找相关算法 end------------------------------------------------


function main()
	-- -- local resultData = countNum(5)
	-- local resultData = twoSums({2, 7,11,15, 1, 8, 3, 6}, 9)
    -- local resultData = stringContain("abcd", "aba")
	-- local resultData = StringToInt("-1234")
    -- local resultData = stringPalindrome("abcacba")
    -- local resultData = stringLongestPalindrome("abcdeedcba")
    -- local resultData = josephRing(12, 6)
    -- local resultData = specialTwoNumsAdd(5, 1)
    -- local resultData = specialMult(2,4)
    -- local resultData = findLastestNumWithHeap({2,10,1,44,6,3,7,8,3,11,6,9}, 5)
    -- local resultData = findTwoSums({2, 7,11,15, 1, 8, 3, 6}, 9)
    -- local resultData = findMaxSubArray({1, -2, 3, 10, -4, 7, 2, -5})
    -- local resultData = oddEvenSort({2, 7,11,15, 1, 8, 3, 6, 8, 63})
    -- local resultData = arrayColorSort({0, 1, 2, 1, 1, 2, 0, 2, 1, 0})
    -- local resultData = shuffle({1, 2, 3, 4, 5, 6, 7, 8, 9})
    -- local resultData = BinarySearch({2, 7,11,15, 1, 8, 3, 6, 8, 63}, 63)
    -- local resultData = findHalfOfAppearWithDel({1, 2, 3, 1, 4, 1,5, 1, 1, 1, 1, 5,1,1})
    local resultData = findMaxAndMinMultipleArray({2,4,5,-8,9,3,1,0,5,6,-7})
    print("输出结果：", table.tostring(resultData))
     -- print("输出结果：", resultData)

end

main()