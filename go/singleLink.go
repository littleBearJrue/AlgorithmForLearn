package main

type Node struct {
	Data interface{}
	Next *Node
}

type SingleLink struct {
	HeadNode *Node
}

/*
	创建单链表结构
*/
func (l *SingleLink) CreateSingleLink (data []interface{}) {

	//for _, v := range data {
	//	//node := &Node{Data: data}
	//}
}

func (l *SingleLink) IsEmpty() bool {
	return l.HeadNode == nil
}

func (l *SingleLink) Length() int {
	curNode := l.HeadNode
	curNum := 0
	for curNode.Next != nil {
		curNode = curNode.Next
		curNum++
	}
	return curNum
}

/*
	往单链表头部插入节点
*/
func (l *SingleLink) AddToHead(data interface{}) {
	node := &Node{Data:data}
	node.Next = l.HeadNode
	l.HeadNode = node
}

/*
	往单链表尾部插入节点
*/
func (l *SingleLink) AppendToTail(data interface{}) {
	node := &Node{Data: data, Next: nil}
	if l.IsEmpty() {
		l.HeadNode = node
	} else {
		curNode := l.HeadNode
		for curNode.Next != nil {
			curNode = curNode.Next
		}
		curNode.Next = node
	}

}

/*
	往单链表指定位置插入节点
*/
func (l *SingleLink) Insert(index int, data interface{}) {
	node := &Node{Data: data}
	if index < 0 {
		l.AddToHead(data)
	} else if index > l.Length() {
		l.AppendToTail(data)
	} else {
		preNode := l.HeadNode
		curNum := 0
		for preNode.Next != nil {
			if curNum == index - 1 {
				break
			}
			preNode = preNode.Next
			curNum++
		}
		node.Next = preNode.Next
		preNode.Next = node
	}

}

/*
	从链表中删除指定节点的节点
*/
func (l *SingleLink) RemoveByData(data interface{}) {
	preNode := l.HeadNode
	if preNode.Data == data {
		l.HeadNode = preNode.Next
	} else {
		for preNode.Next != nil {
			if preNode.Next.Data == data {
				preNode.Next = preNode.Next.Next
				preNode.Next.Next = nil
			}
			preNode = preNode.Next
		}
	}


}

/*
	从链表中删除指定位置的节点
*/
func (l *SingleLink) RemoveAtIndex(index int) {
	preNode := l.HeadNode
	if index == 0 {
		l.HeadNode = preNode.Next
	} else if index == -1 {
		curNum := 0
		for preNode.Next != nil && curNum != index - 1{
			preNode = preNode.Next
			curNum++
		}
		preNode.Next = preNode.Next.Next

	} else if index >= l.Length() {
		panic("beyong List Length!")
	} else {
		curNum := 0
		for preNode.Next != nil && curNum != index - 1{
			preNode = preNode.Next
			curNum++
		}
		preNode.Next = preNode.Next.Next
	}

}

/*
	是否存在指定元素的节点
*/
func (l *SingleLink) Contain(data interface{}) {

}

