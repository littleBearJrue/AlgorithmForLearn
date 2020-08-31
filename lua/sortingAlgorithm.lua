--[[--ldoc desc
@module sortingAlgorithm
@author JrueZhu

Date   2019-07-10 10:32:54
Last Modified by   Jrue
Last Modified time 2019-08-14 17:19:04
]]

local tableUtil = require(".tableUtils")

local function checktable(value)
    if type(value) ~= "table" then value = {} end
    return value
end


function table.split(data, splitIndex)
	local leftArr = {}
	local rightArr = {}
	if data then	
		for i, v in ipairs(data) do
			if i <= splitIndex then
				table.insert(leftArr, v)
			else
				table.insert(rightArr, v)
			end
		end
	end
	return leftArr, rightArr
end



-- 原始数据
-- local originData = {10,1,25,64,69,32,56,98,21,53,75,86,34,67,13,65,24,76,32,88,11,43,56,22,59,2,7,9,11,65,87,41,14,64,84,33,40,80,77,66}

local originData = {10,1,25,64,69,32,56,98,21,53}


function printSortedResult(sortedData, type)
	if type == 0 then
		print("排序前的结果： ", tableUtil.tostring(sortedData))
	elseif type == 1 then
		print("排序后的结果： ", tableUtil.tostring(sortedData))
	end
	
end


--[[
	冒泡排序：分别比较相邻的两个数，如果前一个数比后一个数大则交换彼此的位置，达到从小到大排序的目的	
--]]

function bubbleSort(data)
	for i = 1, tableUtil.nums(data) - 1 do
		local flag = true
		for j = 1, tableUtil.nums(data) - i do
			if data[j] > data[j + 1] then
				tableUtil.swap(data, j, j + 1)
				flag = false
			end
		end

		if flag then
			break
		end
	end
end


--[[
	选择排序：从未排序序列中找到最小的元素，将其放到排序序列的起始位置。继续找未排序序列的最小元素，将其放置排序序列的第二个位置...
--]]
function SelectionSort(data)
	for i = 1, tableUtil.nums(data) - 1 do   -- 总共只需要进行N+1次比较
		local minIndex = i
		for j = i + 1, tableUtil.nums(data) do
			if data[j] < data[minIndex] then
				minIndex = j
			end
		end
		tableUtil.swap(data, i, minIndex)
	end
end

--[[
	插入排序：依次读取未排序序列，将元素插入到已排序序列中对应的位置中
--]]
function insertSort(data)
	for i = 2, tableUtil.nums(data) do
		for j = i, 2, -1 do
			if data[j] < data[j - 1] then
				tableUtil.swap(data, j, j - 1)
			else
				break
			end
		end
	end
end

--[[
	希尔排序：递减增量排序：先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序，待整个序列中记录“基本有序”时，再对全体记录依次直接插入排序
--]]
function shellSort(data)
	local gap = 1
	while(gap < tableUtil.nums(data)) do
		gap = gap * 3 + 1
	end

	while(gap > 0) do
		print("gap--->", gap)
		for i = gap, tableUtil.nums(data) do
			local tmp = data[i]
			print("i--->" , i)
			print("temp--->" , tmp)
			local j = i - gap
			print("j--->" , j)
			while j > 0 and data[j] > tmp do
				print("j + gap--->" , j + gap)
				data[j + gap] = data[j]
				j = j - gap
			end
			data[j + gap] = tmp
		end
		gap = math.floor(gap / 3)
	end
end


--[[
	归并排序：分而治之，时间复杂度为O(nlogn), 空间复杂度O(n) 所以是比较耗内存的，用内存换时间效率
--]]
function mergeSort(data)

	local function merge(leftData, rightData)
		local mergeData = {}
		while(tableUtil.nums(leftData) > 0 and tableUtil.nums(rightData) > 0) do
			if leftData[1] <= rightData[1] then
				table.insert(mergeData, leftData[1])
				table.remove(leftData, 1)
			else
				table.insert(mergeData, rightData[1])
				table.remove(rightData, 1)
			end
		end

		while(tableUtil.nums(leftData) > 0) do
			table.insert(mergeData, leftData[1])
			table.remove(leftData, 1)
		end

		while(tableUtil.nums(rightData) > 0) do
			table.insert(mergeData, rightData[1])
			table.remove(rightData, 1)
		end

		return mergeData
	end

	if tableUtil.nums(data) < 2 then
		return data
	end

	local middle = math.floor(tableUtil.nums(data)/2)
	local leftArr, rightArr = table.split(data, middle)

	return merge(mergeSort(leftArr), mergeSort(rightArr))
end

--[[
	快速排序：是一种就地排序，时间复杂度为O(nlogn),空间复杂度为O(n)
--]]
function quickSort(data, low, high)

	local function partition(arr, left, right)
		local left = left
		local right = right
		local pivot = arr[left]
		-- 双向扫描
		--  遍历找寻至到左右指针接触
		while left < right do
			-- 从右往左找，找到比中介值小的数，跟中介值做交换
			while left < right and arr[right] >= pivot do
				right = right - 1
			end
			-- 跟中介交换
			 arr[left], arr[right] = arr[right], arr[left]

			-- 从左往右找，找到比中介值大的数，跟中介值做交换
			while left < right and arr[left] <= pivot do
				left = left + 1
			end
			-- 跟中介交换
			 arr[left], arr[right] = arr[right], arr[left]
		end
		return left
	end

	if low < high then
		local partitionIndex = partition(data, low, high)
		-- quickSort(data, low, partitionIndex - 1)
		-- quickSort(data, partitionIndex + 1, high)
	end
end

--[[
	堆排序：使用二叉堆的方式进行的（也就是完全二叉树，即字节点的键值总是大于或者小于它的父节点）分为，大顶堆和小顶堆。时间复杂度为O(nlogn)
--]]
function heapSort(data)

	--[[
		建堆
	--]]
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

				tableUtil.swap(arr, headNodePos, maxPos)
			
				-- 继续比较建堆
				buildMaxHeap(arr, maxPos, size)
			end 
		end
	end

	local function buildMinHeap(arr, headNodePos, size)
		if headNodePos < size then
			-- 找到左子节点的位置(因为lua语法是从index 1开始算起的，正常的左子节点为 2*x+1)
			local leftNodePos = 2 * headNodePos
			-- 找到右子节点的位置(因为lua语法是从index 1开始算起的，正常的右子节点为 2*x+2)
			local rightNodePos = 2 * headNodePos + 1
			-- 先把当前头节点位置当做是最大值所在位置
			local minPos = headNodePos
			
			-- 判断左子节点的位置是否大于最大值，则更新最大值所在位置
			if leftNodePos < size and arr[leftNodePos] < arr[minPos] then
				minPos = leftNodePos
			end

			-- 判断右子节点的位置是否大于最大值，则更新最大值所在位置
			if rightNodePos < size and arr[rightNodePos] < arr[minPos] then
				minPos = rightNodePos
			end

			-- 假如当前的头节点不是最大值所在位置，则需要交换彼此的位置
			if minPos ~= headNodePos then

				tableUtil.swap(arr, headNodePos, minPos)
			
				-- 继续比较建堆
				buildMinHeap(arr, minPos, size)
			end 
		end
	end


	if data == nil or tableUtil.nums(data) == 1 or tableUtil.nums(data) == 2 then
		return
	end



	-- 建最大堆(目前根节点已经是数组中的最大值了)
	local size = tableUtil.nums(data)
	-- 这里通过math.floor(size / 2)找到最后一个非叶子节点的位置，从后往前遍历取构建最大堆
	for i = math.floor(size / 2), 1, -1 do
		buildMaxHeap(data, i, size)
		-- buildMinHeap(data, i, size)
	end

	print("1111111111: ", tableUtil.tostring(data))

	for i = tableUtil.nums(data), 2, -1 do
		
		-- 每次都将建好的堆的根节点(最大值)与堆的最后一个元素进行交换，再继续建堆，再交换。。。
		tableUtil.swap(data, 1, i)

		buildMaxHeap(data, 1, i)
		-- buildMinHeap(data, 1, i)
	end
end


function main()
	local data = tableUtil.clone(originData)
	-- printSortedResult(data, 0)
	-- bubbleSort(data)
	-- SelectionSort(data)
	-- insertSort(data)
	-- shellSort(data)
	data = mergeSort(data)
	-- quickSort(data, 1, tableUtil.nums(data))
	-- heapSort(data)
	printSortedResult(data, 1)
end

main()

return {
	bubbleSort = bubbleSort,
	SelectionSort = SelectionSort,
	insertSort = insertSort,
	shellSort = shellSort,
	mergeSort = mergeSort,
	quickSort = quickSort,
	heapSort = heapSort,
}

