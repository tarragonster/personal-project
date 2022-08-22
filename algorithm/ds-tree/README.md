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

- `Degree of a Node`: The total number of children of that node,
The degree of a leaf node must be 0
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

- `Binary Tree`:
  * A node of a binary tree can have a maximum of two child nodes

- `Balanced tree`:
  * If the height of the left sub-tree and the right sub-tree is equal 
  or differs at most by 1, the tree is known as a balanced tree.



## Reference
[Artical] javapoint - [Tree Data Structure](https://www.javatpoint.com/tree) \