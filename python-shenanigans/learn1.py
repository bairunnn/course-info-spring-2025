# Learn Python 3 the hard way by Zed Shaw

# Some math operations
print(12 % 7) # denotes the remainder of 12 divided by 7

# Declaring variables
nomen_clature = "Zed A. Shaw"
floating_point_number = 1.0
integer_number = 1
print(f"{nomen_clature} tells us about {floating_point_number} and {integer_number}") # notice the use of f here

# Some odd formatting
formatter = "{} {} {} {}"
print(formatter.format("I like", "Python", "and", "R"))

# \n denotes a new line
# \t denotes a tab
# \t* denotes a tab followed by asterisk

# Prompting the user using `input`
print("What is your name?")
name = input("Enter your name: ")
print(f"你好, {name}!")

# Importing modules
import math # math is a built-in module
print(math.pi) # prints the value of pi