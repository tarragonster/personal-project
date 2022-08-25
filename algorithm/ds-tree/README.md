# Tree Data Structure

## Questions and Answer
### 1. what is tree data structure?
- A collection of objects or entities known as nodes that are linked
together to  represent or simulate hierarchy
- A non-linear data structure because it does not store in sequence manner
- Elements in Tree are arranged in multiple level
- The topmost node is known as a root node
- Each node contains some data and the link or reference of 
other nodes that can be called children
- Branches must not create any cycles between the different nodes

### 2. What are basic terms used in Tree DS?

- `Root`: topmost node in the tree hierarchy. 
the root node is the one that doesn't have any parent.
If a node is directly linked to some other node, it would be called 
a parent-child relationship

- `Child node`: If the node is a descendant of any node, 
then the node is known as a child node

- `Sibling`: The nodes that have the same parent are known as siblings

- `Leaf Node` (external node): The node of the tree, which doesn't have any child node

- `Internal Node`: A node has atleast one child node known as an internal

- `Ancestor node`: Is any predecessor node on a path from the root to that node (including root node)

- `Descendant`: The immediate successor of the given node

- `Level of a node`: The count of edges on the path from the root node to that node. The root node has level 0

- `Neighbour of a Node`: Parent or child nodes of that node are called neighbors of that node

- `Subtree`: Any node of the tree along with its descendant

- `Keys`: represents a value of a node based on which a search operation is to be carried out for a node

- `Traversing`: Traversing means passing through nodes in a specific order

### 3. What are common properties of Tree DS?

- `Recursive DS`: partially composed of smaller or simpler instances 
of the same data structure (Ex: binary trees)

- `Number of Edge`: If there are n nodes, then there would n-1 edges,
Each node, except the root node, will have atleast one incoming link known as an edge

- `Depth of node x`: The number of edges between the root node and the node x
(Length of the path from the root to the node x)

- `Height of node x`: Longest path from the node x to the leaf node

- `Height of the Tree`: The length of the longest path from the root of the tree to a leaf node of the tree

- `Degree of a Node`: Lower bound on the number of children a node,
The degree of a leaf node must be 0 (minimum number of children possible)

- `Order of a Node`: Upper bound on the number of children (the maximum number possible)

### 4. How to implement Tree DS?

```shell
struct node  
{  
  int data;  
struct node *left;  
struct node *right;   
}  
```

### 5. What are types of Tree DS?

- `Genenal Tree`:
  * A node can have either 0 or maximum n number of nodes
  * The subtrees are unordered as the nodes in the subtree cannot be ordered
  * These two child nodes are known as the left child and right child
  * Usage: store hierarchical data such as folder structures

- `Binary Tree`:
  * A node of a binary tree can have a maximum of two child nodes
  * Usage: Used by compilers to build syntax trees
  * Usage: Implement expression parsers and expression solvers
  * Usage: Store router-tables in routers

- `Balanced tree`:
  * If the height of the left sub-tree and the right sub-tree is equal 
  or differs at most by 1, the tree is known as a balanced tree.
  * Usage: Implement simple sorting algorithms
  * Usage: Priority queues
  * Usage: search applications where data are constantly entering and leaving

- `Binary Search Tree`:
  * value of the left node is less than its parent, while the value of the right node is greater than its parent

- `AVL Tree` (Adelson Velsky Lindas Tree):
  * Self-balancing binary search tree
  * difference between heights of left and right subtrees cannot be more than one for all nodes
  * Each node stores a value called a balance factor which is the difference in height between its left subtree and right subtree
  * All the nodes must have a balance factor of -1, 0 or 1
  * After performing insertions or deletions, if there is at least one node that does 
  not have a balance factor of -1, 0 or 1 then rotations should be performed to balance the tree
  * Usage: Used in situations where frequent insertions are involved
  * Usage: Memory management subsystem of the Linux kernel to search memory regions of processes during preemption
  
- `Red-Black Tree`:
  * Self-balancing binary search tree
  * Each node has a colour; red or black
  * The colours of the nodes are used to make sure that the tree 
  remains approximately balanced during insertions and deletions
  * The root is black (sometimes omitted)
  * All leaves (denoted as NIL) are black
  * If a node is red, then both its children are black
  * Every path from a given node to any of its leaf nodes must 
  go through the same number of black nodes
  * Usage: base for data structures used in computational geometry
  * Usage: the Completely Fair Scheduler used in current Linux kernels
  * Usage: the epoll system call implementation of Linux kernel

- `Splay Tree`:
  * Self-balancing binary search tree
  * Recently accessed elements are quick to access again
  * After performing a search, insertion or deletion, splay 
  trees perform an action called splaying where the tree is 
  rearranged (using rotations) so that the particular element is 
  placed at the root of the tree
  * Usage: implement caches, garbage collectors, data compression

- `Teap` (tree + heap):
  * A binary search tree
  * Each node has two values; a key and a priority
  * The keys follow the binary-search-tree property
  * The priorities (which are random values) follow the heap property
  * Usage: maintain authorization certificates in public-key cryptosystems
  * Usage: perform fast set operations

- `B-tree`:
  * Self-balancing search tree
  * order of m (maximum m children)
  * A none-leaf node with k children have (k -1) keys
  * The root has at least 2 children if it is not a leaf-node
  * Every none-leaf node (except root) have at least (m/2) children
  * All leaf appear in a same level
  * Usage: database indexing to speed up the search
  * Usage: file systems to implement directories
  * Ref: [An Introduction to B-Trees](https://www.youtube.com/watch?v=C_q5ccN84C8&ab_channel=FullstackAcademy)

- `Trie`:
  * The root node of the trie always represents the null node
  * Each child of nodes is sorted alphabetically
  * Each node can have a maximum of 26 children (A to Z)
  * Each node (except the root) can store one letter of the alphabet
  * Usage: Fast and efficient way for dynamic spell checking
  * Usage: Auto-complete
  * Usage: Browser history

### 6. What are action taken to work on binary tree?
- Create: creates an empty tree.
- Insert: insert a node in the tree.
- Search: Searches for a node in the tree.
- Delete: deletes a node from the tree.
- Inorder: in-order traversal of the tree.
  * Left, Root, Right
- Preorder: pre-order traversal of the tree.
- Postorder: post-order traversal of the tree.

### 7. What are methods to work with binary tree?

- Depth-First Search (DFS): type of traversal that goes deep as much 
as possible in every child before exploring the next sibling

- Breadth-First Search (BFS): visits all the nodes of a level before going to the next level

## Reference
[Article] javapoint - [Tree Data Structure](https://www.javatpoint.com/tree) \
[Article] Vijini Mallawaarachchi - [8 Useful Tree Data Structures Worth Knowing](https://towardsdatascience.com/8-useful-tree-data-structures-worth-knowing-8532c7231e8c) \
[Article] baeldung - [Applications of Binary Trees](https://www.baeldung.com/cs/applications-of-binary-trees#:~:text=In%20computing,%20binary%20trees%20are,insertion,%20deletion,%20and%20traversal.) \
[Docs] tutorialspoint - [Data Structure and Algorithms - Tree](https://www.tutorialspoint.com/data_structures_algorithms/tree_data_structure.htm) \
[Article] Aaron Juarez - [Differences Between Tree Structures](https://www.baeldung.com/cs/tree-structures-differences) \
