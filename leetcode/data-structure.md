# Data Structure

### Classification of Data Structure:

1. Linear data structure
- Data structure in which data elements are arranged sequentially or linearly, 
where each element is attached to its previous and next adjacent elements, is called a linear data structure
    * Static data structure: Static data structure has a fixed memory size. 
    It is easier to access the elements in a static data structure (Array).
    * Dynamic data structure: In dynamic data structure, the size is not fixed. 
    It can be randomly updated during the runtime which may be considered efficient 
    concerning the memory (space) complexity of the code. (Queue, Stack, Linked-list)

2. Non-linear data structure
- Data structures where data elements are not placed sequentially or linearly are 
called non-linear data structures. In a non-linear data structure, we can’t traverse all the elements in a single run only
- (Tree, Graph)

### Popular type of data structure

1. Array
2. Linked List
3. Stack
4. Queue
5. Binary Tree
6. Binary Search Tree
7. Heap
8. Hashing
9. Graph
10. Matrix
11. Misc
12. Advanced Data Structure

## Common Questions

1. What is difference between B-tree and BST tree in data structure?
- The difference between the B-tree and the binary tree is that B-tree must have all 
of its child nodes on the same level whereas binary tree does not have such constraint. 
A binary tree can have maximum 2 sub-trees or nodes whereas in B-tree can have M no of sub-trees or nodes where M 
is the order of the B-tree.

- The B-tree is used over binary and binary search tree the main reason behind this is the memory hierarchy
where CPU is connected to cache with the high bandwidth channels while CPU is connected to disk through low 
bandwidth channel. A binary tree is used when records are stored in RAM (small and fast) and B-tree are used 
when records are stored in disk (large and slow). So, use of B-tree instead of Binary tree significantly reduces
access time because of high branching factor and reduced height of the tree

Ref: [What is difference between B-tree and BST tree in data structure?](https://www.quora.com/What-is-difference-between-B-tree-and-BST-tree-in-data-structure) \

## References

[Blog] GreeksforGreeks [Data Structures](https://www.geeksforgeeks.org/data-structures/) \