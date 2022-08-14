def searchInsert(self, nums: List[int], target: int) -> int:
        low, high = 0, len(nums)
        while low < high:
            mid = (low + high) // 2 # floor division
            if target > nums[mid]:
                low = mid + 1
            else:
                high = mid
        return low