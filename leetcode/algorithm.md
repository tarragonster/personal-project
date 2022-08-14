# Algorithm

### Time Space Complexity (Big O)

1. What is Big O notation?
- the efficiency of your algorithm

2. 2 type of big 0?
- Time complexity -> performance (efficiency & fast)
- Space complexity -> memory usage (extra variable & data structure)

3. Big-0 complexity ranking
- O(1) - constant -> good
- O(log n) - logarithmic -> good
- O(n) - linear -> fair
- O(n log n) - linear * log -> bad
- O(n * n) - quadratic -> horrible
- O(2 ^ n) - exponential -> horrible
- O(n!) - factorial -> max horrible

4. Range of efficiency
- best - average - worst
- Big-o normally addressed with the worst case scenarios

### Common questions

1. What is algorithm and what problem does it solve?
- An algorithm is a defined set of step-by-step procedures that 
provides the correct answer to a particular problem

1. What is potential pitfalls when using Algorithms?
- this process tends to be very time-consuming
- if you face a situation where a decision needs to be made very quickly, 
you might be better off using a different problem-solving strategy

### Dynamic Programming

- We divide the large problem into multiple subproblems
- Solve the subproblem and store the result 
- Using the subproblem result, we can build the solution for the large problem
- While solving the large problem, if the same subproblem occurs again, we can 
reuse the already stored result rather than recomputing it again. This is also called memoization.

1. Bottom-Up approach

- Start computing result for the subproblem. Using the subproblem result solve another subproblem and 
finally solve the whole problem.

- Example:
  Let's find the nth member of a Fibonacci series.
  Fibonacci(0) = 0
  Fibonacci(1) = 1
  Fibonacci(2) = 1 (Fibonacci(0) + Fibonacci(1))
  Fibonacci(3) = 2 (Fibonacci(1) + Fibonacci(2))
  We can solve the problem step by step.
  Find Oth member
  Find 1st member
  Calculate the 2nd member using 0th and 1st member
  Calculate the 3rd member using 1st and 2nd member
  By doing this we can easily find the nth member.

```shell
#include<stdio.h>

int Fibonacci(int N)
{
    //if N = 2, we need to store 3 fibonacci members(0,1,1)
    //if N = 3, we need to store 4 fibonacci members(0,1,1,2)
    //In general to compute Fib(N), we need N+1 size array.
    int Fib[N+1],i;

    //we know Fib[0] = 0, Fib[1]=1
    Fib[0] = 0;
    Fib[1] = 1;

    for(i = 2; i <= N; i++)
        Fib[i] = Fib[i-1]+Fib[i-2];

    //last index will have the result
    return Fib[N];
}

int main()
{
    int n;
    scanf("%d",&n);

    //if n == 0 or n == 1 the result is n
    if(n <= 1)
        printf("Fib(%d) = %d\n",n,n);
    else
        printf("Fib(%d) = %d\n",n,Fibonacci(n));

    return 0;
}
```

2. Top-Down approach
- Top-Down breaks the large problem into multiple subproblems.
- if the subproblem solved already just reuse the answer.
- Otherwise, Solve the subproblem and store the result.
- Top-Down uses memoization to avoid recomputing the same subproblem again.

```shell
#include<stdio.h>

int Fibonacci(int N)
{
    if(N <= 1)
        return N;
    return Fibonacci(N-1) + Fibonacci(N-2);
}

int main()
{
    int n;
    scanf("%d",&n);
    printf("Fib(%d) = %d\n",n,Fibonacci(n));

    return 0;
}
```
3. Optimizing Top-Down program using memoization

- Declare an array to store the subproblem results. i.e. result[1000]
- Initialize the array to -1. -1 indicates that the subproblem needs to be computed.
- Fib(N)
- if result[N] == -1 compute and store it in result[N] using above algorithm.
- Otherwise, return the already computed result directly.

```shell
#include<stdio.h>
#define size 50

int result[size];

//initially set the result array to -1
void init_result()
{
    int i;

    for(i = 0; i < size; i++)
        result[i] = -1;
    //-1 indicates that the subproblem result needs to be computed
}

int Fibonacci(int N)
{
    //if the subproblem is not computed yet,
    //recursively compute and store the result
    if(result[N] == -1)
    {
        if(N <= 1)
            result[N] = N;
        else
            result[N] = Fibonacci(N-1) + Fibonacci(N-2);
    }
    //Otherwise, just return the result
    return result[N];
}

int main()
{
    int n;
    scanf("%d",&n);
    init_result();
    printf("Fib(%d) = %d\n",n,Fibonacci(n));
    return 0;
}
```

Ref: log2base2 [Dynamic Programming](https://www.log2base2.com/algorithms/dynamic-programming/dynamic-programming.html) \

### Dynamic Programming Vs. Recursion: What Is The Difference?

- Recursion is when a function can be called and executed by itself, 
while dynamic programming is the process of solving problems by breaking them 
down into sub-problems to resolve the complex one.

Ref: RANDY - [Dynamic Programming Vs. Recursion: What Is The Difference?](https://whatsabyte.com/dynamic-programming-vs-recursion-difference/#:~:text=other%20recursive%20functions.-,What%20Is%20the%20Difference%20Between%20Dynamic%20Programming%20and%20Recursion?,to%20resolve%20the%20complex%20one.) \
Ref: Live To Code - [How Recursion Works? - Explained with animation](https://www.youtube.com/watch?v=BNeOE1qMyRA&ab_channel=LiveToCode) \


### Binary Tree (Left-Root-Right)

1. Inorder Traversals
- In normal inorder traversal, we visit the left subtree before the right subtree. If we visit the right subtree before visiting the left subtree, it is referred to as reverse inorder traversal

- from root
- go left
- if left -> go left not? go parent node

```shell
''' Construct the following tree
           1
         /   \
        /     \
       2       3
      /      /   \
     /      /     \
    4      5       6
          / \
         /   \
        7     8
'''
```
4-2-1-7-5-8-3-6

Ref: [Inorder Traversal](https://www.javatpoint.com/inorder-traversal) \
Ref: [Inorder Tree Traversal – Iterative and Recursive](https://www.techiedelight.com/inorder-tree-traversal-iterative-recursive/) \
Ref: [Iterative & Recursive - Binary Tree Inorder Traversal](https://www.youtube.com/watch?v=g_S5WuasWUE&ab_channel=NeetCode) \

2. Preorder Traversal (Root-Left-Right)

3. Postorder Traversal (Left-Right-Root)

## References

[Cheatsheet] [Know Thy Complexities!](https://www.bigocheatsheet.com) \
[Cheatsheet] [Algorithms and Data Structures Cheatsheet](https://algs4.cs.princeton.edu/cheatsheet/) \
[Blog] [Big-O Notation for beginners](https://medium.com/@changminlim/big-o-notation-for-beginners-ae17e8f70414#:~:text=Common%20types%20of%20Big-O,(n%C2%B2)%20%E2%80%94%20Quadratic%20time%20complexity) \
[Blog] GreeksforGreeks - [Time Complexity and Space Complexity](https://www.geeksforgeeks.org/time-complexity-and-space-complexity/) \