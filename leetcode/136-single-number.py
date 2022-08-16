#Given a non-empty array of integers nums, every element appears twice except for one. Find that single one.
#You must implement a solution with a linear runtime complexity and use only constant extra space.

# n = [4,1,2,1,2]

# brute force
# def singleNumber(nums: [int]):
#     num2 = nums.copy()
#     for index in range(len(nums)):
#         for index2 in range(index + 1, len(nums)):
#             if nums[index] == nums[index2]:
#                 num2.remove(nums[index])
#                 num2.remove(nums[index2])
#
#     onlyValue, *res = num2
#     print(onlyValue)
#
# singleNumber([1,1,4,2,2])

# sorting
# TC: O(NlogN)
# SC: O(1)
# [1,1,2,2,4]
# def singleNumber(nums: [int]):
#     sortedNums = sorted(nums)
#     for idx in range(1, len(sortedNums), 2):
#         if sortedNums[idx] != sortedNums[idx - 1]:
#             return sortedNums[idx - 1]
#
#     return sortedNums[len(sortedNums) - 1]
# singleNumber([1,1,2,4,4])

# Using hashmap/dict
# def singleNumber(self, nums: List[int]) -> int:
#         dict = {}
#         for i in range(len(nums)):
#             dict[nums[i]] = dict.get(nums[i], 0) + 1
#         print(dict)
#         for key, val in dict.items():
#             if val == 1:
#                 return key

# Using bitwise xor operator
def singleNumber(self, nums: List[int]) -> int:
        xor = 0
        for i in range(len(nums)):
            xor ^= nums[i]
        return xor