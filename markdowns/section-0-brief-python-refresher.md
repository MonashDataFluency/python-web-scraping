<center><img src="../images/xkcd_python.png"></center>
<center>https://xkcd.com/license.html (CC BY-NC 2.5)</center>

### Jupyter-style notebooks on Google Colaboratory - A quick tour
---

Go to https://colab.research.google.com and login with your Google account.

Select **NEW NOTEBOOK** - a new Python3 notebook will be created.

Type some Python code in the top cell, eg:


```python
print("Hello world!!")
```

    Hello world!!
    

**Shift-Enter** to run the contents of the cell

In this section we will take a quick tour of some of the concepts that will be used for the rest of our web scraping workshop.


### Dataframes
---

One of the most powerful data structures in Python is the Pandas `DataFrame`. It allows tabular data, including `csv` (comma seperated values) and `tsv` (tab seperated values), to be processed and manipulated. People familiar with Excel will no doubt find it intuitive and easy to grasp. Since most `csv` (or `tsv`) has become the de facto standard for sharing datasets both large and small, Pandas dataframe is the way to go.


```python
import pandas as pd # importing the package and using `pd` as the alias 
print('Pandas version : {}'.format(pd.__version__))
```

    Pandas version : 1.0.5
    

Suppose we wanted to create a dataframe as follows,

| name | title     |
|------|-----------|
| sam  | physicist |
| rob  | economist |

Let's create a dictionary with the headers as keys and their corresponding values as a list as follows,


```python
data = {'name': ['sam', 'rob'], 'title': ['physicist', 'economist']}
```

Converting the same to a dataframe,


```python
df = pd.DataFrame(data)
# print(df.to_markdown()) # converting to markdown for ease of display
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>name</th>
      <th>title</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>sam</td>
      <td>physicist</td>
    </tr>
    <tr>
      <th>1</th>
      <td>rob</td>
      <td>economist</td>
    </tr>
  </tbody>
</table>
</div>



Now lets create a bigger dataframe and learn some useful functions that can be performed on them.


```python
data = {'Name': ['Sam', 'Rob', 'Jack', 'Jill', 'Dave', 'Alex', 'Steve'],\
        'Title': ['Physicist', 'Economist', 'Statistician', 'Data Scientist', 'Designer', 'Architect', 'Doctor'], \
        'Age': [59, 66, 42, 28, 24, 39, 52],\
        'City': ['Melbourne', 'Melbourne', 'Sydney', 'Sydney', 'Melbourne', 'Perth', 'Brisbane'],\
        'University': ['Monash', 'Monash', 'UNSW', 'UTS', 'Uni Mel', 'UWA', 'UQ']}
```


```python
df = pd.DataFrame(data)
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>Title</th>
      <th>Age</th>
      <th>City</th>
      <th>University</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Sam</td>
      <td>Physicist</td>
      <td>59</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Rob</td>
      <td>Economist</td>
      <td>66</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Jack</td>
      <td>Statistician</td>
      <td>42</td>
      <td>Sydney</td>
      <td>UNSW</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Jill</td>
      <td>Data Scientist</td>
      <td>28</td>
      <td>Sydney</td>
      <td>UTS</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Dave</td>
      <td>Designer</td>
      <td>24</td>
      <td>Melbourne</td>
      <td>Uni Mel</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Alex</td>
      <td>Architect</td>
      <td>39</td>
      <td>Perth</td>
      <td>UWA</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Steve</td>
      <td>Doctor</td>
      <td>52</td>
      <td>Brisbane</td>
      <td>UQ</td>
    </tr>
  </tbody>
</table>
</div>



We can also take a quick glance at its contents by using :

- `df.head()` : To display the first 5 rows

- `df.tail()` : To display the last 5 rows


```python
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>Title</th>
      <th>Age</th>
      <th>City</th>
      <th>University</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Sam</td>
      <td>Physicist</td>
      <td>59</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Rob</td>
      <td>Economist</td>
      <td>66</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Jack</td>
      <td>Statistician</td>
      <td>42</td>
      <td>Sydney</td>
      <td>UNSW</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Jill</td>
      <td>Data Scientist</td>
      <td>28</td>
      <td>Sydney</td>
      <td>UTS</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Dave</td>
      <td>Designer</td>
      <td>24</td>
      <td>Melbourne</td>
      <td>Uni Mel</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.tail()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>Title</th>
      <th>Age</th>
      <th>City</th>
      <th>University</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>Jack</td>
      <td>Statistician</td>
      <td>42</td>
      <td>Sydney</td>
      <td>UNSW</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Jill</td>
      <td>Data Scientist</td>
      <td>28</td>
      <td>Sydney</td>
      <td>UTS</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Dave</td>
      <td>Designer</td>
      <td>24</td>
      <td>Melbourne</td>
      <td>Uni Mel</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Alex</td>
      <td>Architect</td>
      <td>39</td>
      <td>Perth</td>
      <td>UWA</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Steve</td>
      <td>Doctor</td>
      <td>52</td>
      <td>Brisbane</td>
      <td>UQ</td>
    </tr>
  </tbody>
</table>
</div>



Lets say we want to fiter out all the people from `Sydney`.


```python
df[df['City'] == 'Sydney']
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>Title</th>
      <th>Age</th>
      <th>City</th>
      <th>University</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>Jack</td>
      <td>Statistician</td>
      <td>42</td>
      <td>Sydney</td>
      <td>UNSW</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Jill</td>
      <td>Data Scientist</td>
      <td>28</td>
      <td>Sydney</td>
      <td>UTS</td>
    </tr>
  </tbody>
</table>
</div>



Now, lets say we want to look at all the people in `Melbourne` and in `Monash`. Notice the usage of `()` and `&`.


```python
df[(df['City'] == 'Melbourne') & (df['University'] == 'Monash')]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>Title</th>
      <th>Age</th>
      <th>City</th>
      <th>University</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Sam</td>
      <td>Physicist</td>
      <td>59</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Rob</td>
      <td>Economist</td>
      <td>66</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
  </tbody>
</table>
</div>



#### Challenge
---

How can we filter people from `Melbourne` and above the Age of `50`?


We can also fetch specific rows based on their indexes as well.


```python
df.iloc[1:3]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>Title</th>
      <th>Age</th>
      <th>City</th>
      <th>University</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>Rob</td>
      <td>Economist</td>
      <td>66</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Jack</td>
      <td>Statistician</td>
      <td>42</td>
      <td>Sydney</td>
      <td>UNSW</td>
    </tr>
  </tbody>
</table>
</div>



Lets try changing Jack's age to 43, because today is his Birthday and he has now turned 43.


```python
df.loc[2, 'Age'] = 43
```

The above is just one way to do this. Some of the other ways are as follows:
- df.at[2, 'Age'] = 43
- df.loc[df[df['Name'] == 'Jack'].index, 'Age'] = 43

Lets look at the updated data frame.


```python
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>Title</th>
      <th>Age</th>
      <th>City</th>
      <th>University</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Sam</td>
      <td>Physicist</td>
      <td>59</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Rob</td>
      <td>Economist</td>
      <td>66</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Jack</td>
      <td>Statistician</td>
      <td>43</td>
      <td>Sydney</td>
      <td>UNSW</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Jill</td>
      <td>Data Scientist</td>
      <td>28</td>
      <td>Sydney</td>
      <td>UTS</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Dave</td>
      <td>Designer</td>
      <td>24</td>
      <td>Melbourne</td>
      <td>Uni Mel</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Alex</td>
      <td>Architect</td>
      <td>39</td>
      <td>Perth</td>
      <td>UWA</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Steve</td>
      <td>Doctor</td>
      <td>52</td>
      <td>Brisbane</td>
      <td>UQ</td>
    </tr>
  </tbody>
</table>
</div>



For exporting a Pandas dataframe to a `csv` file, we can use `to_csv()` as follows
```python
df.to_csv(filename, index=False)
```

Lets try writing our data frame to a file.


```python
df.to_csv('researchers.csv', index=False)
```

In order to read external files we use `read_csv()` function,
```python
pd.read_csv(filename, sep=',')
```

We can read back the file that we just created.


```python
df_res = pd.read_csv('researchers.csv', sep=',')
df_res
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>Title</th>
      <th>Age</th>
      <th>City</th>
      <th>University</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Sam</td>
      <td>Physicist</td>
      <td>59</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Rob</td>
      <td>Economist</td>
      <td>66</td>
      <td>Melbourne</td>
      <td>Monash</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Jack</td>
      <td>Statistician</td>
      <td>43</td>
      <td>Sydney</td>
      <td>UNSW</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Jill</td>
      <td>Data Scientist</td>
      <td>28</td>
      <td>Sydney</td>
      <td>UTS</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Dave</td>
      <td>Designer</td>
      <td>24</td>
      <td>Melbourne</td>
      <td>Uni Mel</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Alex</td>
      <td>Architect</td>
      <td>39</td>
      <td>Perth</td>
      <td>UWA</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Steve</td>
      <td>Doctor</td>
      <td>52</td>
      <td>Brisbane</td>
      <td>UQ</td>
    </tr>
  </tbody>
</table>
</div>



### JSON
---

JSON: JavaScript Object Notation.

When exchanging data between a browser and a server, the data can only be text.

Python has a built-in package called json, which can be used to work with JSON data.


```python
import json
```


```python
# Convert from JSON to Python:

# some JSON:
x =  '{ "name":"John", "age":30, "city":"New York"}'

# parse x:
y = json.loads(x)

# the result is a Python dictionary:
print(y["age"])
```

    30
    


```python
y
```




    {'name': 'John', 'age': 30, 'city': 'New York'}




```python
# Convert from Python to JSON

# a Python object (dict):
x = {
  "name": "John",
  "age": 30,
  "city": "New York"
}

# convert into JSON:
y = json.dumps(x)

# the result is a JSON string:
print(y)
```

    {"name": "John", "age": 30, "city": "New York"}
    


```python
# Indentation
y = json.dumps(x, indent=4)
print(y)

```

    {
        "name": "John",
        "age": 30,
        "city": "New York"
    }
    

### Regex
---

Regular expressions or regex are a powerful tool to extract key pieces of data from raw text.

You can try your regex expressions in : 

- https://pythex.org/ for a python oriented regex editor
- https://regexr.com/ for a more visual explanation behind the expressions (good for getting started)


```python
import re # regex package in python is named 're'
```


```python
my_str = 'python123good'
re.search('123', my_str)
```




    <_sre.SRE_Match object; span=(6, 9), match='123'>




```python
if re.search('123', my_str):
    print("Found")
else:
    print("Not found")
```

    Found
    

We can use `[0-9]` in the regular expression to identify any one number in the string.


```python
my_str = 'python123good'
re.search('[0-9]', my_str)
```




    <_sre.SRE_Match object; span=(6, 7), match='1'>



Notice that it matches the first occurance only.

Now, the above regex can be modified to match any three numbers in a string.


```python
my_str = 'python123good'
re.search('[0-9][0-9][0-9]', my_str)
```




    <_sre.SRE_Match object; span=(6, 9), match='123'>




```python
print(re.search('[0-9][0-9][0-9]','hello123')) # matches 123
print(re.search('[0-9][0-9][0-9]','great678python')) # matches 678
print(re.search('[0-9][0-9][0-9]','01234webscraing')) # matches 012
print(re.search('[0-9][0-9][0-9]','01web5678scraing')) # matches 567
print(re.search('[0-9][0-9][0-9]','hello world')) # matches nothing
```

    <_sre.SRE_Match object; span=(5, 8), match='123'>
    <_sre.SRE_Match object; span=(5, 8), match='678'>
    <_sre.SRE_Match object; span=(0, 3), match='012'>
    <_sre.SRE_Match object; span=(5, 8), match='567'>
    None
    

As seen above, it matches the first occurance of three digits occuring together.

The above example can be extended to match any number of numbers using the wild character `*` which matches `zero or more repetitions`.


```python
print(re.search('[a-z]*[0-9]*','hello123@@')) # matches hello123
```

    <_sre.SRE_Match object; span=(0, 8), match='hello123'>
    

What if we just want to capture only the numbers? `Capture group` is the answer.


```python
num_regex = re.compile('[a-z]*([0-9]*)[a-z]*')
my_str = 'python123good'
num_regex.findall(my_str)
```




    ['123', '']



We see that it matchs an empty string as well because `*` matches zero or more occurances. 

To avoid this, we can use `+` which matches one or more occurances.


```python
num_regex = re.compile('[a-z]*([0-9]+)[a-z]*')
my_str = 'python123good'
num_regex.findall(my_str)
```




    ['123']



We can use `^` and `$` to match at the beginning and end of string.

As shown in the below 2 examples, we use `^` to get the numbers by which the string is starting.


```python
num_regex = re.compile('^([0-9]+)[a-z]*')
my_str = '123good'
num_regex.findall(my_str)
```




    ['123']




```python
my_str = 'hello123good'
num_regex.findall(my_str)
```




    []



#### Challenge
---

What regular expression can be used to match the numbers **only** at the end of the string:

- '[a-z]*([0-9]+)[a-z]+'
- '[a-z]*([0-9]+)\$'
- $[a-z]*([0-9]+)
- '([0-9]+)'

Now, having learnt the regular expressions on basic strings, the same concept can be applied to an html as well as shown below:


```python
html = r'''
         <!DOCTYPE html>
        <html>
        <head>
        <title>site</title>
        </head>
        <body>

        <h1>Sam</h1>
        <h2>Physicist</h2>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.</p>

        <h1>Rob</h1>
        <h2>Economist</h2>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et.</p>


        </body>
        </html> 
        '''

print(html)
```

    
             <!DOCTYPE html>
            <html>
            <head>
            <title>site</title>
            </head>
            <body>
    
            <h1>Sam</h1>
            <h2>Physicist</h2>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.</p>
    
            <h1>Rob</h1>
            <h2>Economist</h2>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et.</p>
    
    
            </body>
            </html> 
            
    

Now, if we are only interested in : 
- names i.e. the data inside the `<h1></h1>` tags, and
- title i.e. the data inside the `<h2></h2>` tags
we can extract the same using regex.


Lets define the expressions (or patterns) to capture all text between the tags as follows :

- `<h1>(.*?)</h1>` : capture all text contained within `<h1></h1>` tags
- `<h2>(.*?)</h2>` : capture all text contained within `<h2></h2>` tags




```python
regex_h1 = re.compile('<h1>(.*?)</h1>')
regex_h2 = re.compile('<h2>(.*?)</h2>')
```

and use `findall()` to return all the instances that match with our pattern,


```python
names = regex_h1.findall(html)
titles = regex_h2.findall(html)

print(names, titles)
```

    ['Sam', 'Rob'] ['Physicist', 'Economist']
    

### From a web scraping perspective
- `JSON` and `XML` are the most widely used formats to carry data all over the internet.
- To work with `CSV`s (or `TSV`s), Pandas DataFrames are the de facto standard.
- Regexes help us extract key pieces of information (sub-strings) from raw, messy and unstructured text (strings).

### References

- https://xkcd.com/353/
- https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html
- https://realpython.com/regex-python/
