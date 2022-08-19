# Given a sorted array of distinct integers and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.
#
# You must write an algorithm with O(log n) runtime complexity.

def searchInsert(self, nums: List[int], target: int) -> int:
        low, high = 0, len(nums)
        while low < high:
            mid = (low + high) // 2 # floor division
            if target > nums[mid]:
                low = mid + 1
            else:
                high = mid
        return low

#         [2,5,8,11,23] target = 7
#         mid = 0 + 4 = 4 // 2 = 2
#         7 < nums[2]=8
#
#         high = 2 [0,1,2]
#         mid = 0 + 2 = 2 //2 = 1
#         7 > nums[1]=5
#         low = 1 + 1 = 2
#         2 = 2


        # binary search pattern