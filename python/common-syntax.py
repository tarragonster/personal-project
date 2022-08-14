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