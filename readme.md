# 有效知识

### 十大排序算法

具体见`sortingAlgorithm.lua`,都是`lua`语法实现的各种常见的排序算法

### 洗牌算法

具体见`shuffleAlgorithm.lua`

### 进程间通信方式

#### 1. 管道

管道的通信方式是单向的，只能从第一个进程的输出数据作为第二个进程的输入数据，所以如果要做到双向通信只能开启两个管道。通信机制类似缓存，一边往管道写数据，一边从管道读数据，否则，一方会处于等待状态。所以本质上这种通信方式是效率比较低下的。在linux中比较常用

#### 2. 消息队列

#### 3. 共享内存

系统加载一个进程的时候，分配给进程的内存并不是**实际物理内存**，而是**虚拟内存空间**。那么我们可以让两个进程各自拿出一块虚拟地址空间来，然后映射到相同的物理内存中，这样，两个进程虽然有着独立的虚拟内存空间，但有一部分却是映射到相同的物理内存，这就完成了**内存共享**机制了

#### 4. 信号量

解决共享内存多进程竞争的问题，也就是线程安全问题

#### 5. Socket

解决不同服务器之前的进程间通信





