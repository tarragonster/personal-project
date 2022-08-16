# Given head, the head of a linked list, determine if the linked list has a cycle in it.
#
# There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the next pointer. Internally, pos is used to denote the index of the node that tail's next pointer is connected to. Note that pos is not passed as a parameter.
#
# Return true if there is a cycle in the linked list. Otherwise, return false.

# 3 - 2 - 0 - 4
#     |- - - -|

# Floyd's Cycle Detection Algorithm
#Time complexity: O(n)
#Space complexity: O(1)
def hasCycle(self, head: Optional[ListNode]) -> bool:
    slow = head
    fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    return False

# Using hashmap
#Time complexity: O(n)
#Space complexity: O(n)
def hasCycle(self, head: Optional[ListNode]) -> bool:
        dict = {}
        while head:
            if dict.get(head) == 1:
                return True
            else:
                dict[head] = 1
                head = head.next
        return False

# Change value of link list
#Time complexity: O(n)
#Space complexity: O(1)
def hasCycle(self, head: Optional[ListNode]) -> bool:
        if head is None:
            return False
        while head and head.next:
            if (head.val == "a"):
                return True
            head.val = "a"
            head = head.next
        return False