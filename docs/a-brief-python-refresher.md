#### Strings


```python
my_str = "This is a string"
my_str[0]
```


```python
my_str[::-1]
```




    'gnirts a si sihT'




```python
my_str[0:4]
```




    'one,'




```python
my_str = "one,two,three,four,five"
my_str.split(',')
```




    ['one', 'two', 'three', 'four', 'five']




```python
my_str = " hello "
print(my_str)
my_str.strip()
```

     hello 





    'hello'



#### Lists


```python
my_list = ['item1', 'item2', 100, 3.14]
my_list[2]
```




    100




```python
len(my_list)
```




    4




```python
num_list = range(0,10)
num_list
```




    range(0, 10)




```python
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



```python
num_squares = [num * num for num in num_list]
num_squares
```




    [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]




```python
num_evens = [num for num in num_list if num %2 == 0]
num_evens
```




    [0, 2, 4, 6, 8]




```python
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
my_list = [954, 341, 100, 3.14]
my_list.sort()
my_list
```




    [3.14, 100, 341, 954]



#### Loops


```python
languages = [['Spanish', 'English',  'French', 'German'], ['Python', 'Java', 'Javascript', 'C++']]
```


```python
for lang in languages:
    print(lang)
```

    ['Spanish', 'English', 'French', 'German']
    ['Python', 'Java', 'Javascript', 'C++']



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



```python
for lang_list in languages:
    print("--------------")
    for lang in lang_list:
        if lang == "German":
            continue
        print(lang)
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



```python
for lang_list in languages:
    print("--------------")
    for lang in lang_list:
        if lang == "Java":
            break
        print(lang)
```

    --------------
    Spanish
    English
    French
    German
    --------------
    Python



```python
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


```python
my_set = {1, 2, 3}
print(my_set)
```

    {1, 2, 3}



```python
my_set = {1.0, "Hello", (1, 2, 3)}
print(my_set)
```

    {1.0, 'Hello', (1, 2, 3)}



```python
my_set = {1,2,3,4,3,2}
print(my_set)
```

    {1, 2, 3, 4}



```python
#Creating an empty set is a bit tricky
my_set = {}
print(type(my_set))
my_set = set()
print(type(my_set))
```

    <class 'dict'>
    <class 'set'>



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
A|B
```




    {1, 2, 3, 4, 5, 6, 7, 8}




```python
# Intersection
A = {1, 2, 3, 4, 5}
B = {4, 5, 6, 7, 8}
A&B
```




    {4, 5}



#### Dictionary


```python
dict1 = {'a': 1, 'b': 2, 'c': 3, 'd': 4}
dict1
```




    {'a': 1, 'b': 2, 'c': 3, 'd': 4}




```python
dict1['e'] = 5
dict1
```




    {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5}




```python
dict1.keys()
```




    dict_keys(['a', 'b', 'c', 'd', 'e'])




```python
dict1.items()
```




    dict_items([('a', 1), ('b', 2), ('c', 3), ('d', 4), ('e', 5)])




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




```python

```

#### Data frames


```python

```

#### Functions


```python
def hello():
    print("Hello World") 
    return
```


```python
hello()
```

    Hello World



```python
def plus(a,b):
    return a + b
plus(2, 5)

# Parameters vs arguments
# Parameters are a and b. Arguments are 2 and 5.
```




    7




```python
def run():
    for x in range(10):
        if x == 2:
            return
    print("Run!")
    
run()
```


```python
def plus(a,b = 2):
    return a + b
  
# Call `plus()` with only `a` parameter
print(plus(a=1))

# Call `plus()` with `a` and `b` parameters
print(plus(a=1, b=3))
```

    3
    4



```python
# Variable arguments
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
# Define `main()` function
def main():
    hello()
    print("This is a main function")

main()

# As is, if the script is imported, it will execute the main function.
```

    Hello World
    This is a main function



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

    <ipython-input-28-136638963fdb> in <module>()
         14 
         15 # (Try to) access the local variable
    ---> 16 print("this is the sum " + str(total))
    

    NameError: name 'total' is not defined


#### Libraries


```python
# json, requests, bs
```


```python
# argparse????
```


```python

```
