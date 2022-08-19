class Solution:
    def moveZeroes(self, nums: List[int]) -> None:
        """
        Do not return anything, modify nums in-place instead.
        """
        stack = []
        for idx in range(len(nums)):
            if nums[idx] == 0:
                stack.append(nums[idx])
        while 0 in nums: nums.remove(0)
        nums.extend(stack)