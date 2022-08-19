# Implement an algorithm that takes as input an array of distinct elements and a size
# returns a subset of the given size of the array elements
# All subsets should be equally likely.
# Return the result in input array itself.
import random

def randomSampling(k, A):
    res = []
    for i in range(k): # input 3 indexes from 0 -> 2
        r = random.randint(i, len(A) - 1) # len -> length, len(A) - 1 -> last index (pick a random index)
        A[i], A[r] = A[r], A[i]
    print(A)

randomSampling(2,[1,4,7,2,8])