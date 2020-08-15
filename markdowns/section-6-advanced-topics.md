#### Variable arguments:


```python

def plus(*args):
    return sum(args)

# Calculate the sum
plus(1,4,5)
```




    10



#### Variable keyword arguments:


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

```
