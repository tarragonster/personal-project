# Ref https://www.youtube.com/watch?v=i1wQOiljBvY&list=WL&index=20&ab_channel=NeuralNine

# a = 28 -> 16 + 8 + 4 + 0 + 0-> 11100
# b = 19 -> 16 + 0 + 0 + 2 + 1 -> 10011

# AND OR XOR

n1 = 23477
n2 = 31213

# print(bin(n1)[2:])
# print(bin(n2)[2:])

# AND (1 and 1 = 1 | 0 and 0 = 0 | 1 and 0 = 0 | 0 and 1 = 0)

n3 = n1 & n2
# print(bin(n3)[2:])

# OR (0 or 0 = 0 | 0 or 1 = 1 | 1 or 0 = 1 | 1 or 1 = 1)

n4 = n1 | n2

# print(bin(n4)[2:])

# XOR (1 XOR 0 = 1 | 0 XOR 1 = 1 | 0 XOR 0 = 0 | 1 XOR 1 = 0)

n5 = n1 ^ n2
# print("0" + bin(n5)[2:])

# NOT

# print("0" + bin(0b111111111111111 - n1)[2:])

# SHIFTS

# Shift to the left an extra bit pops up at the tail of binary = *2
# number = 20
# print(bin(number)[2:])
# number <<= 1 # *2
# print(bin(number)[2:])

# Shift tp the right a bit removed from the tail of the binary = /2

# number = 20
# print(bin(number)[2:])
# number >>= 1 # /2
# print(bin(number)[2:])

# Flags

NEURAL_READ = 0b1000
NEURAL_WRITE = 0b0100
NEURAL_EXEC = 0b0010
NEURAL_CHANGE = 0b0001

def myFunc(permission):
    print(bin(permission)[2:])

# myFunc(NEURAL_READ | NEURAL_WRITE)

# Swap value of two variables without a placeholder variable

a = 10 #01010
b = 20 #10100

# a, b = b, a

a ^= b #11110
b ^= a #01010
a ^= b #10100

# print("a: " + str(a))
# print("b: " + str(b))

# Event or Odd

someNumer = 345927

# if someNumer & 1 == 0:
#     print("event")
# else:
#     print("odd")

# Same?

num = 20 # 16 + 0 + 4 + 0 + 0 -> 10100

num ^= 0
print(num)
print(bin(num)[2:])


# Important properties of XOR

# Commutative : A ⊕ B = B ⊕ A
# This is clear from the definition of XOR: it doesn’t matter which way round you order the two inputs.
#
# Associative : A ⊕ ( B ⊕ C ) = ( A ⊕ B ) ⊕ C
# This means that XOR operations can be chained together and the order doesn’t matter. If you aren’t convinced of the truth of this statement, try drawing the truth tables.
#
# Identity element : A ⊕ 0 = A
# This means that any value XOR’d with zero is left unchanged.
#
# Self-inverse : A ⊕ A = 0
# This means that any value XOR’d with itself gives zero.
# Ref https://accu.org/journals/overload/20/109/lewin_1915/#:~:text=This%20means%20that%20any%20value,with%20zero%20is%20left%20unchanged.&text=This%20means%20that%20any%20value%20XOR'd%20with%20itself%20gives%20zero.