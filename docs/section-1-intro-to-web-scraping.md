
## What is web scraping?

Web scraping is a technique for extracting information from websites. This can be done manually but it is usually faster, more efficient and less error-prone to automate the task.

Web scraping allows you to acquire non-tabular or poorly structured data from websites and convert it into a usable, structured format, such as a .csv file or spreadsheet.

Scraping is about more than just acquiring data: it can also help you archive data and track changes to data online.

It is closely related to the practice of web indexing, which is what search engines like Google do when mass-analysing the Web to build their indices. But contrary to web indexing, which typically parses the entire content of a web page to make it searchable, web scraping targets specific information on the pages visited.

For example, online stores will often scour the publicly available pages of their competitors, scrape item prices, and then use this information to adjust their own prices. Another common practice is “contact scraping” in which personal information like email addresses or phone numbers is collected for marketing purposes.

### Why do we need it as a skill?
Web scraping is increasingly being used by scholars to create data sets for text mining projects; these might be collections of journal articles or digitised texts. The practice of data journalism, in particular, relies on the ability of investigative journalists to harvest data that is not always presented or published in a form that allows analysis.

### When do we need scraping?

As useful as scraping is, there might be better options for the task. Choose the right (i.e. the easiest) tool for the job.

- Check whether or not you can easily copy and paste data from a site into Excel or Google Sheets. This might be quicker than scraping.
- Check if the site or service already provides an API to extract structured data. If it does, that will be a much more efficient and effective pathway. Good examples are the Facebook API, the Twitter APIs or the YouTube comments API.
- For much larger needs, Freedom of information requests can be useful. Be specific about the formats required for the data you want.


### Structured vs unstructured data

When presented with information, human beings are good at quickly categorizing it and extracting the data that they are interested in. For example, when we look at a magazine rack, provided the titles are written in a script that we are able to read, we can rapidly figure out the titles of the magazines, the stories they contain, the language they are written in, etc. and we can probably also easily organize them by topic, recognize those that are aimed at children, or even whether they lean toward a particular end of the political spectrum. Computers have a much harder time making sense of such unstructured data unless we specifically tell them what elements data is made of, for example by adding labels such as this is the title of this magazine or this is a magazine about food. Data in which individual elements are separated and labelled is said to be structured.

Refer to the file 'fortune_500_basic_example.html'.

<!--
<thead>
    <tr>
        <th>Rank</th>
        <th>Company</th>
        <th>Website</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td>1</td>
        <td>Walmart</td>
        <td><a href="http://www.stock.walmart.com">http://www.stock.walmart.com</a></td>
    </tr>
    <tr>
        <td>2</td>
        <td>Exxon Mobil</td>
        <td><a href="http://www.exxonmobil.com">http://www.exxonmobil.com</a></td>
    (...)
    </tr>
    <tr>
        <td>500</td>
        <td>Cintas</td>
        <td><a href="http://www.cintas.com">http://www.cintas.com</a></td>
    </tr>
</tbody>
-->

We see that this data has been structured for displaying purposes (it is arranged in rows inside a table) but the different elements of information are not clearly labelled.

What if we wanted to download this dataset and, for example, compare the revenues of these companies against each other or the industry that they work in? We could try copy-pasting the entire table into a spreadsheet or even manually copy-pasting the names and parties in another document, but this can quickly become impractical when faced with a large set of data. What if we wanted to collect this information for all the companies that are there?

Fortunately, there are tools to automate at least part of the process. This technique is called web scraping.

> Web scraping (web harvesting or web data extraction) is a computer software technique of extracting information from websites.(Source: Wikipedia)

Web scraping typically targets one web site at a time to extract unstructured information and put it in a structured form for reuse.

In this lesson, we will continue exploring the examples above and try different techniques to extract the information they contain. But before we launch into web scraping proper, we need to look a bit closer at how information is organized within an HTML document and how to build queries to access a specific subset of that information.

Create a basic html:
```html
<!DOCTYPE html>
<html>
<head>
<title>Page Title</title>
</head>
<body>

<h1>My First Heading</h1>
<p>My first paragraph.</p>

</body>
</html>
```


```python
# Select image from https://www.w3schools.com/html/html_intro.asp
```


```python
!wget "https://www.zyxware.com/articles/5914/list-of-fortune-500-companies-and-their-websites-2018"
```

    'wget' is not recognized as an internal or external command,
    operable program or batch file.
    

xml https://www.w3schools.com/xml/xml_whatis.asp
