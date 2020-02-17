
#### Strings

A string can be defined by enclosing it in a single quote(') or a double quote(")


```python
my_str = "This is a string"
```

The characters of a string can be accessed by indices and the indices go from 0 to n-1


```python
my_str[0]
```




    'T'



Slice notation "[a:b:c]" means "count in increments of c starting at a inclusive, up to b exclusive".


```python
my_str[0:4]
```




    'This'



A string can be reversed using the following way. The first index corresponds to the start, second to the end and the last one indicates the increment that needs to be done. 


```python
my_str[::-1]
```




    'gnirts a si sihT'



A string can be splitted as well based on a delimmitter. A list is returned after splitting


```python
my_str = "one,two,three,four,five"
my_str.split(',')
```




    ['one', 'two', 'three', 'four', 'five']



A string can be stripped as well of extra spaces at the ends. 


```python
my_str = " hello "
print(my_str)
my_str.strip()
```

     hello 
    




    'hello'



#### Lists


```python
# List can be of a mixed type
my_list = ['item1', 'item2', 100, 3.14]

```


```python
# List elements can be accessed by the indices starting from 0 to n-1
my_list[2]
```




    100




```python
# Function to find the length of the list
len(my_list)
```




    4




```python
# range function to generate a range object
num_list = range(0,10)
num_list
```




    range(0, 10)




```python
# use list() to get a list out of the range object
list(range(0,10))
```




    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]




```python
# Iterate over a list using for loop
for num in num_list:
    print(num)
```

    0
    1
    2
    3
    4
    5
    6
    7
    8
    9
    

#### List comprehension

new_list = [expression(item) for item in old_list]


```python
num_squares = [num * num for num in num_list]
num_squares
```




    [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]




```python
# The list can be filtered based on a condition
num_evens = [num for num in num_list if num %2 == 0]
num_evens
```




    [0, 2, 4, 6, 8]




```python
# zip() function to combine 2 lists

country_list = ["Australia", "France", "USA", "Italy"]
capital_list = ["Canberra", "Paris", "Washington DC", "Rome"]
pairs = zip(country_list, capital_list)
for country, capital in pairs:
    print("The country is {0} and the capital is {1}".format(country, capital))
```

    The country is Australia and the capital is Canberra
    The country is France and the capital is Paris
    The country is USA and the capital is Washington DC
    The country is Italy and the capital is Rome
    


```python
# sort() function to sort a list. It stores the sorted list in the original list itself.

my_list = [954, 341, 100, 3.14]
my_list.sort()
my_list
```




    [3.14, 100, 341, 954]



#### Loops


```python
# Loops can be run over list of lists as well
languages = [['Spanish', 'English',  'French', 'German'], ['Python', 'Java', 'Javascript', 'C++']]
```


```python
for lang in languages:
    print(lang)
```

    ['Spanish', 'English', 'French', 'German']
    ['Python', 'Java', 'Javascript', 'C++']
    

As we see above, in each iteration, we get one list at a time. 

If each element of the nested list is needed, then a nested loop should be written as below:


```python
for lang_list in languages:
    print("--------------")
    for lang in lang_list:
        print(lang)
```

    --------------
    Spanish
    English
    French
    German
    --------------
    Python
    Java
    Javascript
    C++
    

There are various ways to manipulate the functioning of a loop. 

* continue: This will skip the rest of the statements of that iteration and continue with the next iteration.
* break: This will break the entire loop and go to the next statement after the loop.


```python
for lang_list in languages:
    print("--------------")
    for lang in lang_list:
        if lang == "German":
            continue
        print(lang)
print("End of loops")
```

    --------------
    Spanish
    English
    French
    --------------
    Python
    Java
    Javascript
    C++
    End of loops
    


```python
for lang_list in languages:
    print("--------------")
    for lang in lang_list:
        if lang == "Java":
            break
        print(lang)
print("End of loops")
```

    --------------
    Spanish
    English
    French
    German
    --------------
    Python
    End of loops
    


```python
# another example of continue
from math import sqrt
number = 0

for i in range(10):
    number = i ** 2
    if i % 2 == 0:
        continue    # continue here
    
    print(str(round(sqrt(number))) + ' squared is equal to ' + str(number))
```

    1 squared is equal to 1
    3 squared is equal to 9
    5 squared is equal to 25
    7 squared is equal to 49
    9 squared is equal to 81
    

#### Sets

Sets is an unordered collections of unique elements. Common uses include membership testing, removing duplicates from a sequence, and computing standard math operations on sets such as intersection, union, difference, and symmetric difference.


A set can be created using the '{}' brackets. 


```python
my_set = {1, 2, 3}
print(my_set)
```

    {1, 2, 3}
    


```python
my_list = [1,2,3,4,2,3]
print(set(my_list))
```

    {1, 2, 3, 4}
    


```python
# A set can be made of mixed types as well. 
my_set = {1.0, "Hello", (1, 2, 3)}
print(my_set)
```

    {1.0, 'Hello', (1, 2, 3)}
    


```python
# Even if duplicate elements are added while initialising, they get remived. 
my_set = {1,2,3,4,3,2}
print(my_set)
```

    {1, 2, 3, 4}
    


```python
#Creating an empty set is a bit tricky.
my_set = {}
print(type(my_set))
my_set = set()
print(type(my_set))
```

    <class 'dict'>
    <class 'set'>
    

Elements can be added individualy or as a list.


```python
my_set = {1, 2, 3}
my_set.add(4)
print(my_set)
my_set.update([6, 7, 8])
my_set
```

    {1, 2, 3, 4}
    




    {1, 2, 3, 4, 6, 7, 8}




```python
# Union
A = {1, 2, 3, 4, 5}
B = {4, 5, 6, 7, 8}
A|B  # or A.union(B)
```




    {1, 2, 3, 4, 5, 6, 7, 8}




```python
# Intersection
A = {1, 2, 3, 4, 5}
B = {4, 5, 6, 7, 8}
A&B # A.intersection(B)
```




    {4, 5}



#### Dictionary

Dictionaries are a container that store key-value pairs. They are unordered.

Other programming languages might call this a 'hash', 'hashtable' or 'hashmap'.


```python
dict1 = {'a': 1, 'b': 2, 'c': 3, 'd': 4}
dict1
```




    {'a': 1, 'b': 2, 'c': 3, 'd': 4}




```python
# Adding a key to the dictionary
dict1['e'] = 5
dict1
```




    {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5}



keys() method returns the keys in the dictionary. 


```python
dict1.keys()
```




    dict_keys(['a', 'b', 'c', 'd', 'e'])




```python
# items() method can be used to get all the pairs of the dictionary.
dict1.items()
```




    dict_items([('a', 1), ('b', 2), ('c', 3), ('d', 4), ('e', 5)])



Dictionary comprehension can be used to manipulate the elements of a dictionary. 


```python
double_dict1 = {k:v*2 for (k,v) in dict1.items()}
double_dict1
```




    {'a': 2, 'b': 4, 'c': 6, 'd': 8, 'e': 10}




```python
dict1_cond = {k:v for (k,v) in dict1.items() if v>2}
dict1_cond
```




    {'c': 3, 'd': 4, 'e': 5}



#### Data frames

#### Functions

A function is a block of organized, reusable code that is used to perform a single, related action. Functions provide better modularity for your application and a high degree of code reusing.


```python
# Function definition
def hello():
    print("Hello World") 
    return
```


```python
# Function calling
hello()
```

    Hello World
    

Parameters vs arguments: 
Parameters are a and b. Arguments are 2 and 5.


```python
def plus(a,b):
    return a + b
plus(2, 5)

```




    7



A function can return nothing (null/None) as well. 


```python
def run():
    for x in range(10):
        if x == 2:
            return
    print("Run!")
    
```


```python
run()
```

#### Keyword arguments with default values


```python
# Here the value of parameter `b` is 2 by default if the value is not passed. 
def plus(a,b = 2):
    return a + b
  
```


```python
# Call `plus()` with only `a` parameter
print(plus(a=1))
```

    3
    


```python
# Call `plus()` with `a` and `b` parameters
print(plus(a=1, b=3))
```

    4
    

#### Variable arguments:




```python

def plus(*args):
    return sum(args)

# Calculate the sum
plus(1,4,5)
```




    10




```python
def concatenate(**kwargs):
    result = ""
    # Iterating over the Python kwargs dictionary
    for arg in kwargs.values():
        result = result + arg + " "
    return result

print(concatenate(a="Real", b="Python", c="Is", d="Great", e="!"))
```

    Real Python Is Great ! 
    

the correct order for your parameters is:

    Standard arguments
    *args arguments
    **kwargs arguments



```python
# Anonymous functions: lambda
# `sum()` lambda function
sum = lambda x, y: x + y;

# Call the `sum()` anonymous function
sum(4,5)

# "Translate" to a UDF
# def sum(x, y):
#     return x+y

```




    9



#### Use of main()


```python
def hello():
    print("Hello World") 
    return

# Define `main()` function
def main():
    hello()
    print("This is a main function")

main()

# As is, if the script is imported, it will execute the main function.
```

    Hello World
    This is a main function
    

The following code needs a script mode to show the use. 


```python
# Define `main()` function
def main():
    hello()
    print("This is a main function")
    
# Execute `main()` function 
if __name__ == '__main__':
    main()
```

    Hello World
    This is a main function
    

#### Global vs local variables


```python
# Global variable `init`
init = 1

# Define `plus()` function to accept a variable number of arguments
def plus(*args):
    # Local variable `sum()`
    total = 0
    for i in args:
        total += i
    return total
  
# Access the global variable
print("this is the initialized value " + str(init))

# (Try to) access the local variable
print("this is the sum " + str(total))
```

    this is the initialized value 1
    


    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    <ipython-input-57-136638963fdb> in <module>()
         14 
         15 # (Try to) access the local variable
    ---> 16 print("this is the sum " + str(total))
    

    NameError: name 'total' is not defined


#### Libraries


```python
# json, requests, bs, regex
```


```python
# argparse????
```
