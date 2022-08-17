class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        dict = {}
        for idx in range(len(nums)):
            cur = target - nums[idx]
            if cur in dict:
                return [dict[cur], idx]
            else:
                dict[nums[idx]] = idx