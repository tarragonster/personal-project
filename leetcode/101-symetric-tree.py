# Given the root of a binary tree, check whether it is a mirror of itself (i.e., symmetric around its center).

#Iterative
class Solution:
    def isSymmetric(self, root: Optional[TreeNode]) -> bool:
        stack = [(root.left, root.right)]
        while stack:
            left, right = stack.pop()
            if left is None and right is None:
                continue
            if left is None or right is None:
                return False
            if left.val == right.val:
                stack.append((left.left, right.right))
                stack.append((left.right, right.left))
            else:
                return False
        return True

#Recursive
class Solution:
    def isSymmetric(self, root: Optional[TreeNode]) -> bool:
        if root is None:
            return True
        else:
            def isMirror(left, right):
                if left is None and right is None:
                    return True
                if left is None or right is None:
                    return False
                if left.val == right.val:
                    onFar = isMirror(left.left, right.right)
                    onClose = isMirror(left.right, right.left)
                    return onFar and onClose
                else:
                    return False
            return isMirror(root.left, root.right)