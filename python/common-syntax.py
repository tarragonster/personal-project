import datetime

# Time Date
rawTime=datetime.datetime.now()
print("abc" + "\n\n" + rawTime.strftime("%B %d,%Y"))

# text replacement method
txt = "I like bananas"

x = txt.replace("bananas", "apples")

print(x)

# Populate array value
res = [0 for i in range(15)]
print(res)

# to string
integer_value = 1
str(integer_value)

# merge array
a = [1, 2] + [3, 4]
print(a)


# if not -> check null
if not root

# What Is Difference Between Del, Remove and Pop
# The del keyword delete any variable, list of values from a list.
numbers = [1, 2, 3, 2, 3, 4, 5]
del numbers[2]

# The remove() method removes the first matching value from the list.

numbers = [1, 2, 3, 2, 3, 4, 5]
numbers.remove(3)

# The pop() method like del deletes value at a particular index. But pop() method returns deleted value from the list

numbers = [1, 2, 3, 2, 3, 4, 5]
numbers.pop(3)

# How to spread a python array
a = [1,2,3,4]
b = [10]

b = [*b, *a]

# Python Dictionaries
# Ref https://www.w3schools.com/python/python_dictionaries_access.asp

thisdict = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}

# Access item

x = thisdict.get("model")
x = thisdict.items()

# if else shorthand

a = headA if a is None else a.next
