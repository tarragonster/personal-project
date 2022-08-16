# Given the head of a singly linked list, reverse the list, and return the reversed list.
# [1,2,3,4,5]


# Iterative
# TC: O(n)
# SC: O(1)
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        prev = None
        while head:
            curr = head
            head = head.next
            curr.next = prev
            prev = curr
        return prev

# Recursive

