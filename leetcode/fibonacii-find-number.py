# Find the value of Fibonacii frequent by position

def findFibonacii(n: int):
    arr = [0 for i in range(n)]
    arr[0], arr[1] = 1, 1
    for i in range(2, n):
        arr[i] = arr[i - 1] + arr[i - 2]
    print(arr)
    return arr[n - 1]

findFibonacii(6)