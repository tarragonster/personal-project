# Given the heads of two singly linked-lists headA and headB, return the node at which the two lists intersect. If the two linked lists have no intersection at all, return null.
#
# For example, the following two linked lists begin to intersect at node c1:

# The test cases are generated such that there are no cycles anywhere in the entire linked structure.
#
# Note that the linked lists must retain their original structure after the function returns.
#
# Custom Judge:
#
# The inputs to the judge are given as follows (your program is not given these inputs):
#
# intersectVal - The value of the node where the intersection occurs. This is 0 if there is no intersected node.
# listA - The first linked list.
# listB - The second linked list.
# skipA - The number of nodes to skip ahead in listA (starting from the head) to get to the intersected node.
# skipB - The number of nodes to skip ahead in listB (starting from the head) to get to the intersected node.
# The judge will then create the linked structure based on these inputs and pass the two heads, headA and headB to your program. If you correctly return the intersected node, then your solution will be accepted.

# 8
# [4,1,8,4,5]
# [5,6,1,8,4,5]
# 2
# 3

# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

# Hashmap solution
#Time complexity: O(n + m)
#Space complexity: O(n)

class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> Optional[ListNode]:
        dict = {}
        while headA:
            dict[headA] = 1
            headA = headA.next

        while headB:
            if dict.get(headB) == 1:
                return headB
            headB = headB.next
        return None

#No need hashmap
#Time complexity: O(n + m)
#Space complexity: O(1)
def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> Optional[ListNode]:
        if headA is None or headB is None:
            return None

        a = headA
        b = headB

        while a is not b:
            a = headA if a is None else a.next
            b = headB if b is None else b.next

        return a