print("\nQ1a\n")
# Q1a: Print only the first 5 numbers in this list
x = [2, 5, 4, 87, 34, 2, 1, 31, 103, 99]

# A1a:
for number in x[:5]:
    print(number)

print("\nQ1b\n")
# Q1b: Now print only the even numbers in this list (the elements that are themselves even)
x = [2, 5, 4, 87, 34, 2, 1, 31, 103, 99]

# A1b:
for number in x:
    if number % 2 == 0:
        print (number)

print("\nQ1c\n")
# Q1c: Now only print the even numbers up to the fifth element in the list (e.g. 2, 4, 34)
x = [2, 5, 4, 87, 34, 2, 1, 31, 103, 99]

# A1c:
for number in x[:5]:
    if number % 2 == 0:
        print (number)


# -------------------------------------------------------------------------------------- #

print("\nQ2a\n")
# Q2a: from the list of names, create another list that consists of only the first letters of each first name
# e.g. ["Alan Turing", "Leonardo Fibonacci"] -> ["A", "L"]
names = ["Alan Turing", "Leonardo Fibonacci", "Katherine Johnson", "Annie Easley", "Terence Tao"]

# A2a:
first_letters = []

for letter in names:
    first_letter = letter[0]
    first_letters.append(first_letter)

print(first_letters)



print("\nQ2b\n")
# Q2b: from the list of names, create another list that consists of only the index of the space in the string
# HINT: use your_string.index("substring")
names = ["Alan Turing", "Leonardo Fibonacci", "Katherine Johnson", "Annie Easley", "Terence Tao"]

# A2b:
space_letters = []

for space in names:

    space_letters.append(space.index(" "))

print(space_letters)



print("\nQ2c\n")
# Q2c: from the list of names, create another list that consists of the first and last initial of each individual
names = ["Alan Turing", "Leonardo Fibonacci", "Katherine Johnson", "Annie Easley", "Terence Tao"]

# A2c:
initials_list = []

for name in names:
    first_initial = name[0]
    last_initial = name[name.index(" ") + 1]
    initials_list.append(f"{first_initial} {last_initial}")

print(initials_list)

# -------------------------------------------------------------------------------------- #

print("\nQ3a\n")
# Q3a: Here is a list of lists, print only the lists which have no duplicates
# Hint: This can be easily done by using sets as a set does not contain duplicates
list_of_lists = [[1,5,7,3,44,4,1],
                 ["A", "B", "C"],
                 ["Hi", "Hello", "Ciao", "By", "Goodbye", "Ciao"],
                 ["one", "Two", "Three", "Four"]]


# A3a:
for items in list_of_lists:
    if len(items) == len(set(items)):
        print(items)

# -------------------------------------------------------------------------------------- #

print("\nQ4a\n")
# Q4a: Using a while loop, ask the user to input a number greater than 100, if they enter anything else,
# get them to enter again (and repeat until the conditions are satisfied). Finally print the number that
# they entered

# A4a:
number = 0

while number <= 100:
    number = int(input("Enter a number that is greater than 100: "))
    if number < 100:
        print("please retry a new number")



print("\nQ4b\n")
# Q4b: Continue this code and print "prime" if the number is a prime number and "not prime" otherwise

# A4b:
number = 0

while number <= 100:
    number = int(input("Enter a number that is greater than 100: "))

prime_number = True

for i in range(2, number):
    if number % i == 0:
        prime_number = False
        break
if prime_number:
    print("prime number")
else:
    print("not prime number")




