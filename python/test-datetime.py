import datetime
rawTime=datetime.datetime.now()
print("abc" + "\n\n" + rawTime.strftime("%B %d,%Y"))

# text replacement method
txt = "I like bananas"

x = txt.replace("bananas", "apples")

print(x)