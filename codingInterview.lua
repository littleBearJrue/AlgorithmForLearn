--[[--ldoc desc
@module codingInterview
@author Jrue

Date   2019-08-14 14:17:26
Last Modified by   Jrue
Last Modified time 2019-08-14 18:35:24
]]

local tableUtil = require(".tableUtils")

--[[
	剑指offer
--]]

--[[
	lua实现链表结构
--]]
function createLinkList(data)
	local linkList = {}
	for i = #data, 1, -1 do
		linkList = {value = data[i], next = linkList}
	end
	return linkList
end

function printLinkList(list)
	local printData = {}
	while list do
		table.insert(printData, list.value)
		list = list.next
	end
	print("打印链表数据: ", tableUtil.tostring(printData))
end

--[[
	从尾到头打印链表
	这里使用的是递归的方式实现，递归本质上就是栈的数据结构
	但是有个问题：
	当链表非常长的时候，就会导致函数调用的层级很深，从而有可能到只函数调用栈溢出
--]]
function reverseLinkList(list)
	local printList = {}
	if list and list.next then
		reverseLinkList(list.next)

		table.insert(printList, list.value)
	end
	print("打印链表数据: ", tableUtil.tostring(printList))
end

--[[
	根据前序遍历和后序遍历的数据重构二叉树
--]]
function reConstructBinaryTree(preData, vinData)
	local function treeNode(val)
		return {
			value = val,
			left = nil,
			right = nil,
		}
	end
	local rootNode = treeNode(preData[1])
	local index = tableUtil.keyof(vin, preData[1])
	rootNode.left = reConstructBinaryTree()

end


function main()
	local list = createLinkList({2, 4, 3, 1, 6, 9})
	reverseLinkList(list)
end

main()