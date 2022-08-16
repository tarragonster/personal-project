# Best time to buy and sell stock

# dynamic programming and Kadane’s Algorithm
# class Solution:
#     def maxProfit(self, prices: List[int]) -> int:
#         maxCur = 0
#         maxSoFar = 0
#         for i in range(1, len(prices)):
#             maxCur += (prices[i] - prices[i -1])
#             maxCur = max(0, maxCur)
#             maxSoFar = max(maxCur, maxSoFar)
#             print(maxCur)
#         return maxSoFar


# Best solution
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        left = 0
        right = 1
        maxProfit = 0
        while right < len(prices):
            currentProfit = prices[right] - prices[left]
            if prices[left] < prices[right]:
                maxProfit = max(maxProfit, currentProfit)
            else:
                left = right
            right += 1
        return maxProfit