# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def isPalindrome(self, head: Optional[ListNode]) -> bool:
        # Stack to save prev node
        # Loop to
        stack = []
        curr = head

        while curr:
            stack.append(curr.val)
            curr = curr.next

        while head:
            if head.val != stack.pop():
                return False
            head = head.next
        return True