<img src="../images/api.png">

### A brief introduction to APIs
---

In this section, we will take a look at an alternative way to gather data than the previous pattern based, HTML scraping. Sometimes websites offer an API (or Application Programming Interface) as a service which provides a high level interface to directly retrieve data from their repositories or databases at the backend. 

From Wikipedia,

> "*An API is typically defined as a set of specifications, such as Hypertext Transfer Protocol (HTTP) request messages, along with a definition of the structure of response messages, usually in an Extensible Markup Language (XML) or JavaScript Object Notation (JSON) format.*"

They typically tend to be URL endpoints (to be fired as requests) that need to be modified based on our requirements (what we desire in the response body) which then returns some a payload (data) within the response, formatted as either JSON, XML or HTML. 

A popular web architecture style called REST (or representational state transfer) allows users to interact with web services via `GET` and `POST` calls (two most commonly used).

An API in the context of web scraping would be :
- Requests (through Hypertext Transfer Protocol HTTP
- Headers

talk more here!

E.g.

- For example, Twitter's REST API allows developers to access core Twitter data and the Search API provides methods for developers to interact with Twitter Search and trends data.

https://en.wikipedia.org/w/api.php

There are primarily two ways to use APIs :
- Through the command terminal using URL endpoints, or
- Through programming language specific *wrappers*

For e.g. `Tweepy` is a famous python wrapper for Twitter API whereas `twurl` is a command line interface (CLI) tool but both can achieve the same outcomes.

Here we focus on the latter approach and will use a Python library (a wrapper) called `wptools` based around the original MediaWiki API.

One advantage of using official APIs is that they are usually compliant of the terms of service (ToS) of a particular service that researchers are looking to gather data from. However, third-party libraries or packages which claim to provide more throughput than the official APIs (rate limits, number of requests/sec) generally operate in a gray area as they tend to violate ToS. Always be sure to read their documentation throughly.

### Wikipedia API
---

Let's say we want to gather some additional data about the Fortune 500 companies and since wikipedia is a rich source for data we decide to use the MediaWiki API to scrape this data. One very good place to start would be to look at the **infoboxes** (as wikipedia defines them) of articles corresponsing to each company on the list. They essentially contain a wealth of metadata about a particular entity the article belongs to which in our case is a company. 

For e.g. consider the wikipedia article for **walmart** (https://en.wikipedia.org/wiki/Walmart) which includes the following infobox :

![An infobox](../images/infobox.png)

As we can see from above, the infoboxes could provide us with a lot of valuable information such as :
- Year of founding 
- Industry
- Founder(s)
- Products	
- Services	
- Operating income
- Net income
- Total assets
- Total equity
- Number of employees etc

Although we expect this data to be fairly organized, it would require some post-processing which we will tackle in our next section. We pick a subset of our data and focus only on the top **20** of the Fortune 500 from the full list. 

Let's begin by installing some of libraries we will use for this excercise as follows,


```python
# sudo apt install libcurl4-openssl-dev libssl-dev
!pip install wptools
!pip install wikipedia
# pip install pandas
!pip install wordcloud
```

Importing the same,


```python
import json
import wptools
import wikipedia
import pandas as pd
from pathlib import Path

print('wptools version : {}'.format(wptools.__version__)) # checking the installed version
```

    wptools version : 0.4.17
    

Now let's load the data which we scrapped in the previous section as follows,


```python
fname = 'fortune_500_companies.csv' # scrapped data from previous section
path = Path('../data/')             # path to the csv file
df = pd.read_csv(path/fname)        # reading the csv file as a pandas df
df.head()                           # displaying the first 5 rows
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
      <th>rank</th>
      <th>company_name</th>
      <th>company_website</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>Walmart</td>
      <td>http://www.stock.walmart.com</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>Exxon Mobil</td>
      <td>http://www.exxonmobil.com</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>Berkshire Hathaway</td>
      <td>http://www.berkshirehathaway.com</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>Apple</td>
      <td>http://www.apple.com</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>UnitedHealth Group</td>
      <td>http://www.unitedhealthgroup.com</td>
    </tr>
  </tbody>
</table>
</div>



Let's focus and select only the top 20 companies from the list as follows,


```python
no_of_companies = 20                         # no of companies we are interested 
df_sub = df.iloc[:no_of_companies, :].copy() # only selecting the top 20 companies
companies = df_sub['company_name'].tolist()  # converting the column to a list
```

Taking a brief look at the same,


```python
for i, j in enumerate(companies):   # looping through the list of 20 company 
    print('{}. {}'.format(i+1, j))  # printing out the same
```

    1. Walmart
    2. Exxon Mobil
    3. Berkshire Hathaway
    4. Apple
    5. UnitedHealth Group
    6. McKesson
    7. CVS Health
    8. Amazon.com
    9. AT&T
    10. General Motors
    11. Ford Motor
    12. AmerisourceBergen
    13. Chevron
    14. Cardinal Health
    15. Costco
    16. Verizon
    17. Kroger
    18. General Electric
    19. Walgreens Boots Alliance
    20. JPMorgan Chase
    

### Getting article names from wiki

Right off the bat, as you might have guessed, one issue with matching the top 20 Fortune 500 companies to their wikipedia article names is that both of them would not be exactly the same i.e. they match character for character. There will be slight variation in their names.

To overcome this problem and ensure that we have all the company names and its corresponding wikipedia article, we will use the `wikipedia` package (https://wikipedia.readthedocs.io/en/latest/code.html) to get suggestions for the company names and their equivalent in wikipedia.


```python
wiki_search = [{company : wikipedia.search(company)} for company in companies]
```

Inspecting the same,


```python
for idx, company in enumerate(wiki_search):
    for i, j in company.items():
        print('{}. {} :\n{}'.format(idx+1, i ,', '.join(j)))
        print('\n')
```

    1. Walmart :
    Walmart, Criticism of Walmart, History of Walmart, Walmarting, Walmart Canada, Walmart Labs, People of Walmart, List of Walmart brands, Walmart (disambiguation), Walmart Watch
    
    
    2. Exxon Mobil :
    ExxonMobil, Exxon, ExxonMobil climate change controversy, Mobil, ExxonMobil Building, 2020 Qatar ExxonMobil Open, Darren Woods, ExxonMobil Tower, Exxon Valdez oil spill, Exxon Valdez
    
    
    3. Berkshire Hathaway :
    Berkshire Hathaway, List of assets owned by Berkshire Hathaway, Berkshire Hathaway Energy, Berkshire Hathaway Assurance, Berkshire Hathaway GUARD Insurance Companies, List of Berkshire Hathaway publications, Warren Buffett, Ajit Jain, Berkshire Hathaway Travel Protection, The World's Billionaires
    
    
    4. Apple :
    Apple, Apple Inc., Apple (disambiguation), IPhone, Apple Music, Apple A13, Apple TV, Apple ID, Apple Watch, Apple Records
    
    
    5. UnitedHealth Group :
    UnitedHealth Group, Pharmacy benefit management, Optum, List of largest companies in the United States by revenue, William W. McGuire, Golden Rule Insurance Company, Stephen J. Hemsley, Amelia Warren Tyagi, PacifiCare Health Systems, Gail Koziara Boudreaux
    
    
    6. McKesson :
    McKesson Corporation, DeRay Mckesson, Malcolm McKesson, McKesson & Robbins scandal (1938), Celesio, McKesson Plaza, John Hammergren, McKesson (disambiguation), Rexall Pharmacy Group, Coindre Hall
    
    
    7. CVS Health :
    CVS Health, CVS Pharmacy, CVS Caremark, CVS, Pharmacy benefit management, Larry Merlo, CVS Health Charity Classic, Helena Foulkes, MinuteClinic, List of largest companies by revenue
    
    
    8. Amazon.com :
    Amazon (company), History of Amazon, List of Amazon products and services, Amazon Web Services, List of original programs distributed by Amazon, .amazon, Criticism of Amazon, Amazon.ae, Amazon S3, List of mergers and acquisitions by Amazon
    
    
    9. AT&T :
    AT&T, AT&T Mobility, AT&T Corporation, AT&T TV, T, T & T Supermarket, AT&T Stadium, AT&T Communications, T-54/T-55, AT&T Mexico
    
    
    10. General Motors :
    General Motors, History of General Motors, List of General Motors factories, General Motors India, General Motors EV1, General Motors Canada, General Motors Vortec engine, GMC (automobile), General Motors Chapter 11 reorganization, General Motors Firebird
    
    
    11. Ford Motor :
    Ford Motor Company, History of Ford Motor Company, Henry Ford, Lincoln Motor Company, Ford Trimotor, Edsel Ford, Ford of Britain, Ford Germany, Henry Ford II, Ford Motor Argentina
    
    
    12. AmerisourceBergen :
    AmerisourceBergen, Steven H. Collis, List of largest companies by revenue, List of largest companies in the United States by revenue, Family Pharmacy, Ornella Barra, Good Neighbor Pharmacy, Cardinal Health, Michael DiCandilo, PharMerica
    
    
    13. Chevron :
    Chevron Corporation, Chevron, Chevron (insignia), Chevron Cars, Philip Chevron, Wound Chevron, Chevron (geology), Chevron Engineering, Chevron Cars Ltd, Chevron U.S.A., Inc. v. Natural Resources Defense Council, Inc.
    
    
    14. Cardinal Health :
    Cardinal Health, Cardinal, Catalent, Cordis (medical), Robert D. Walter, List of largest companies by revenue, George S. Barrett, Pyxis Corporation, List of largest Central Ohio employers, List of largest companies in the United States by revenue
    
    
    15. Costco :
    Costco, Costco bear, Warehouse club, Price Club, Coca-Cola, American Express, Rotisserie chicken, James Sinegal, Most-Favoured-Customer Clause, Sol Price
    
    
    16. Verizon :
    Verizon Communications, Verizon Wireless, Verizon Fios, Verizon Media, Verizon Delaware, Verizon Business, Verizon Center, Verizon Building, Verizon Pennsylvania, Verizon Hum
    
    
    17. Kroger :
    Kroger, Murder Kroger, Bernard Kroger, Michael Kroger, John Kroger, Jeffersontown Kroger shooting, Uwe Kröger, Chad Kroeger, Smith's Food and Drug, Kroger (disambiguation)
    
    
    18. General Electric :
    General Electric, General Electric GEnx, General Electric Building, General Electric CF6, General Electric Theater, General Electric GE9X, General Electric Company, General Electric GE90, General Electric LM6000, General Electric CF34
    
    
    19. Walgreens Boots Alliance :
    Walgreens Boots Alliance, Alliance Boots, Walgreens, Boots (company), Alliance Healthcare, Stefano Pessina, Boots Opticians, Ornella Barra, Gregory Wasson, James A. Skinner
    
    
    20. JPMorgan Chase :
    JPMorgan Chase, Chase Bank, 2012 JPMorgan Chase trading loss, JPMorgan Chase Tower (Houston), 2014 JPMorgan Chase data breach, JPMorgan Chase Building (San Francisco), JPMorgan Corporate Challenge, Chase Tower (Dallas), 270 Park Avenue, Chase Paymentech
    
    
    

Now let's get the most probable ones (the first suggestion) for each of the first 20 companies on the Fortune 500 list,


```python
most_probable = [(company, wiki_search[i][company][0]) for i, company in enumerate(companies)]
companies = [x[1] for x in most_probable]

print(most_probable)
```




    [('Walmart', 'Walmart'),
     ('Exxon Mobil', 'ExxonMobil'),
     ('Berkshire Hathaway', 'Berkshire Hathaway'),
     ('Apple', 'Apple'),
     ('UnitedHealth Group', 'UnitedHealth Group'),
     ('McKesson', 'McKesson Corporation'),
     ('CVS Health', 'CVS Health'),
     ('Amazon.com', 'Amazon (company)'),
     ('AT&T', 'AT&T'),
     ('General Motors', 'General Motors'),
     ('Ford Motor', 'Ford Motor Company'),
     ('AmerisourceBergen', 'AmerisourceBergen'),
     ('Chevron', 'Chevron Corporation'),
     ('Cardinal Health', 'Cardinal Health'),
     ('Costco', 'Costco'),
     ('Verizon', 'Verizon Communications'),
     ('Kroger', 'Kroger'),
     ('General Electric', 'General Electric'),
     ('Walgreens Boots Alliance', 'Walgreens Boots Alliance'),
     ('JPMorgan Chase', 'JPMorgan Chase')]



We can notice that most of the wiki article titles make sense. However, **Apple** is quite ambiguous in this regard as it can indicate the fruit as well as the company. However we can see that the second suggestion returned by was **Apple Inc.**. Hence, we can manually replace it with **Apple Inc.** as follows,


```python
companies[companies.index('Apple')] = 'Apple Inc.' # replacing "Apple"
print(companies) # final list of wikipedia article titles
```

    ['Walmart', 'ExxonMobil', 'Berkshire Hathaway', 'Apple Inc.', 'UnitedHealth Group', 'McKesson Corporation', 'CVS Health', 'Amazon (company)', 'AT&T', 'General Motors', 'Ford Motor Company', 'AmerisourceBergen', 'Chevron Corporation', 'Cardinal Health', 'Costco', 'Verizon Communications', 'Kroger', 'General Electric', 'Walgreens Boots Alliance', 'JPMorgan Chase']
    

### Retrieving the infoboxes

Now that we have mapped the names of the companies to their corresponding wikipedia article let's retrieve the infobox data from those pages. 

`wptools` provides easy to use methods to directly call the MediaWiki API on our behalf and get us all the wikipedia data. Let's try retrieving data for **Walmart** as follows,


```python
page = wptools.page('Walmart')
page.get_parse()    # parses the wikipedia article
```

    en.wikipedia.org (parse) Walmart
    en.wikipedia.org (imageinfo) File:Walmart store exterior 5266815680.jpg
    Walmart (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:Walmart s...
      infobox: <dict(30)> name, logo, logo_caption, image, image_size,...
      iwlinks: <list(2)> https://commons.wikimedia.org/wiki/Category:W...
      pageid: 33589
      parsetree: <str(330390)> <root><template><title>about</title><pa...
      requests: <list(2)> parse, imageinfo
      title: Walmart
      wikibase: Q483551
      wikidata_url: https://www.wikidata.org/wiki/Q483551
      wikitext: <str(263955)> {{about|the retail chain|other uses}}{{p...
    }
    




    <wptools.page.WPToolsPage at 0x7f37cc054518>



As we can see from the output above, `wptools` successfully retrieved the wikipedia and wikidata corresponding to the query **Walmart**. Now inspecting the fetched attributes,


```python
page.data.keys()
```




    dict_keys(['requests', 'iwlinks', 'pageid', 'wikitext', 'parsetree', 'infobox', 'title', 'wikibase', 'wikidata_url', 'image'])



The attribute **infobox** contains the data we require,


```python
page.data['infobox']
```




    {'name': 'Walmart Inc.',
     'logo': 'Walmart logo.svg',
     'logo_caption': "Walmart's current logo since 2008",
     'image': 'Walmart store exterior 5266815680.jpg',
     'image_size': '270px',
     'image_caption': 'Exterior of a Walmart store',
     'former_name': "{{Unbulleted list|Walton's (1950–1969)|Wal-Mart, Inc. (1969–1970)|Wal-Mart Stores, Inc. (1970–2018)}}",
     'type': '[[Public company|Public]]',
     'ISIN': 'US9311421039',
     'industry': '[[Retail]]',
     'traded_as': '{{Unbulleted list|NYSE|WMT|[[DJIA]] component|[[S&P 100]] component|[[S&P 500]] component}} {{NYSE|WMT}}',
     'foundation': '{{Start date and age|1962|7|2}} (in [[Rogers, Arkansas]])',
     'founder': '[[Sam Walton]]',
     'location_city': '[[Bentonville, Arkansas]]',
     'location_country': 'U.S.',
     'locations': '{{increase}} 11,503 stores worldwide (January 31, 2020)',
     'area_served': 'Worldwide',
     'key_people': '{{plainlist|\n* [[Greg Penner]] ([[Chairman]])\n* [[Doug McMillon]] ([[President (corporate title)|President]], [[CEO]])}}',
     'products': '{{hlist|Electronics|Movies and music|Home and furniture|Home improvement|Clothing|Footwear|Jewelry|Toys|Health and beauty|Pet supplies|Sporting goods and fitness|Auto|Photo finishing|Craft supplies|Party supplies|Grocery}}',
     'services': '{{hlist|[[Ria Money Transfer|Walmart-2-Walmart]]|Walmart MoneyCard|Pickup Today|Walmart.com|Financial Services| Walmart Pay}}',
     'revenue': '{{increase}} {{US$|523.964 billion|link|=|yes}} {{small|([[Fiscal Year|FY]] 2020)}}',
     'operating_income': '{{decrease}} {{US$|20.568 billion}} {{small|(FY 2020)}}',
     'net_income': '{{increase}} {{US$|14.881 billion}} {{small|(FY 2020)}}',
     'assets': '{{increase}} {{US$|236.495 billion}} {{small|(FY 2020)}}',
     'equity': '{{increase}} {{US$|74.669 billion}} {{small|(FY 2020)}}',
     'owner': '[[Walton family]] (51%)',
     'num_employees': '{{plainlist|\n* 2.2|nbsp|million, Worldwide (2018)|ref| name="xbrlus_1" |\n* 1.5|nbsp|million, U.S. (2017)|ref| name="Walmart"|{{cite web |url = http://corporate.walmart.com/our-story/locations/united-states |title = Walmart Locations Around the World – United States |publisher = |url-status=live |archiveurl = https://web.archive.org/web/20150926012456/http://corporate.walmart.com/our-story/locations/united-states |archivedate = September 26, 2015 |df = mdy-all }}|</ref>|\n* 700,000, International}} {{nbsp}} million, Worldwide (2018) * 1.5 {{nbsp}} million, U.S. (2017) * 700,000, International',
     'divisions': "{{Unbulleted list|Walmart U.S.|Walmart International|[[Sam's Club]]|Global eCommerce}}",
     'subsid': '[[List of assets owned by Walmart|List of subsidiaries]]',
     'homepage': '{{URL|walmart.com}}'}



Let's define a list of features that we want from the infoboxes as follows,


```python
wiki_data = []
# attributes of interest contained within the wiki infoboxes
features = ['founder', 'location_country', 'revenue', 'operating_income', 'net_income', 'assets',
        'equity', 'type', 'industry', 'products', 'num_employees']
```

Now fetching the data for all the companies (this may take a while),


```python
for company in companies:    
    page = wptools.page(company) # calling 
    try:
        page.get_parse()
        if page.data['infobox'] != None:
            infobox = page.data['infobox']
            data = { feature : infobox[feature] if feature in infobox else '' 
                         for feature in features }
        else:
            data = { feature : '' for feature in features }
        
        data['company_name'] = company
        wiki_data.append(data)
        
    except KeyError:
        pass
```

    en.wikipedia.org (parse) Walmart
    en.wikipedia.org (imageinfo) File:Walmart store exterior 5266815680.jpg
    Walmart (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:Walmart s...
      infobox: <dict(30)> name, logo, logo_caption, image, image_size,...
      iwlinks: <list(2)> https://commons.wikimedia.org/wiki/Category:W...
      pageid: 33589
      parsetree: <str(346504)> <root><template><title>about</title><pa...
      requests: <list(2)> parse, imageinfo
      title: Walmart
      wikibase: Q483551
      wikidata_url: https://www.wikidata.org/wiki/Q483551
      wikitext: <str(274081)> {{about|the retail chain|other uses}}{{p...
    }
    en.wikipedia.org (parse) ExxonMobil
    en.wikipedia.org (imageinfo) File:ExxonMobilBuilding.JPG
    ExxonMobil (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:ExxonMobi...
      infobox: <dict(29)> name, logo, image, image_caption, type, trad...
      iwlinks: <list(3)> https://commons.wikimedia.org/wiki/Category:E...
      pageid: 18848197
      parsetree: <str(187433)> <root><template><title>About</title><pa...
      requests: <list(2)> parse, imageinfo
      title: ExxonMobil
      wikibase: Q156238
      wikidata_url: https://www.wikidata.org/wiki/Q156238
      wikitext: <str(152792)> {{About|Exxon Mobil Corp|the company's s...
    }
    en.wikipedia.org (parse) Berkshire Hathaway
    Berkshire Hathaway (en) data
    {
      image: <list(0)> 
      infobox: <dict(24)> name, former_name, logo, image, image_captio...
      iwlinks: <list(1)> https://commons.wikimedia.org/wiki/Category:B...
      pageid: 314333
      parsetree: <str(101434)> <root><template><title>short descriptio...
      requests: <list(1)> parse
      title: Berkshire Hathaway
      wikibase: Q217583
      wikidata_url: https://www.wikidata.org/wiki/Q217583
      wikitext: <str(86730)> {{short description|American multinationa...
    }
    en.wikipedia.org (parse) Apple Inc.
    en.wikipedia.org (imageinfo) File:Apple park cupertino 2019.jpg
    Apple Inc. (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:Apple par...
      infobox: <dict(36)> name, logo, logo_size, image, image_size, im...
      iwlinks: <list(8)> https://commons.wikimedia.org/wiki/Special:Se...
      pageid: 856
      parsetree: <str(403082)> <root><template><title>Redirect</title>...
      requests: <list(2)> parse, imageinfo
      title: Apple Inc.
      wikibase: Q312
      wikidata_url: https://www.wikidata.org/wiki/Q312
      wikitext: <str(321377)> {{Redirect|Apple (company)|other compani...
    }
    en.wikipedia.org (parse) UnitedHealth Group
    UnitedHealth Group (en) data
    {
      infobox: <dict(17)> name, logo, type, traded_as, founder, key_pe...
      pageid: 1845551
      parsetree: <str(86142)> <root><template><title>Redirect</title><...
      requests: <list(1)> parse
      title: UnitedHealth Group
      wikibase: Q2103926
      wikidata_url: https://www.wikidata.org/wiki/Q2103926
      wikitext: <str(73971)> {{Redirect|UnitedHealthcare|the cycling t...
    }
    en.wikipedia.org (parse) McKesson Corporation
    McKesson Corporation (en) data
    {
      infobox: <dict(19)> name, logo, type, traded_as, founder, locati...
      pageid: 1041603
      parsetree: <str(38152)> <root><template><title>Redirect</title><...
      requests: <list(1)> parse
      title: McKesson Corporation
      wikibase: Q570473
      wikidata_url: https://www.wikidata.org/wiki/Q570473
      wikitext: <str(30274)> {{Redirect|McKesson}}{{short description|...
    }
    en.wikipedia.org (parse) CVS Health
    CVS Health (en) data
    {
      infobox: <dict(28)> name, logo, logo_size, former_name, type, tr...
      pageid: 10377597
      parsetree: <str(69373)> <root><template><title>short description...
      requests: <list(1)> parse
      title: CVS Health
      wikibase: Q624375
      wikidata_url: https://www.wikidata.org/wiki/Q624375
      wikitext: <str(54045)> {{short description|American healthcare c...
    }
    en.wikipedia.org (parse) Amazon (company)
    en.wikipedia.org (imageinfo) File:Seattle Spheres on May 10, 2018.jpg
    Amazon (company) (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:Seattle S...
      infobox: <dict(33)> name, logo, logo_size, image, image_size, im...
      iwlinks: <list(2)> https://commons.wikimedia.org/wiki/Category:A...
      pageid: 90451
      parsetree: <str(153139)> <root><template><title>pp</title><part>...
      requests: <list(2)> parse, imageinfo
      title: Amazon (company)
      wikibase: Q3884
      wikidata_url: https://www.wikidata.org/wiki/Q3884
      wikitext: <str(116580)> {{pp|small=yes}}{{short description|Amer...
    }
    en.wikipedia.org (parse) AT&T
    en.wikipedia.org (imageinfo) File:AT&THQDallas.jpg
    AT&T (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:AT&THQDal...
      infobox: <dict(27)> name, logo, logo_size, image, image_size, im...
      iwlinks: <list(1)> https://commons.wikimedia.org/wiki/Category:AT%26T
      pageid: 17555269
      parsetree: <str(130159)> <root><template><title>about</title><pa...
      requests: <list(2)> parse, imageinfo
      title: AT&T
      wikibase: Q35476
      wikidata_url: https://www.wikidata.org/wiki/Q35476
      wikitext: <str(104995)> {{about|the company known as AT&T since ...
    }
    en.wikipedia.org (parse) General Motors
    en.wikipedia.org (imageinfo) File:RenCen.JPG
    General Motors (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:RenCen.JP...
      infobox: <dict(29)> name, former_name, logo, logo_size, image, i...
      iwlinks: <list(2)> https://commons.wikimedia.org/wiki/Category:G...
      pageid: 12102
      parsetree: <str(190450)> <root><template><title>short descriptio...
      requests: <list(2)> parse, imageinfo
      title: General Motors
      wikibase: Q81965
      wikidata_url: https://www.wikidata.org/wiki/Q81965
      wikitext: <str(150285)> {{short description|American automotive ...
    }
    en.wikipedia.org (parse) Ford Motor Company
    en.wikipedia.org (imageinfo) File:FordGlassHouse.jpg
    Ford Motor Company (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:FordGlass...
      infobox: <dict(27)> name, logo, image, image_size, image_caption...
      iwlinks: <list(8)> https://commons.wikimedia.org/wiki/Category:F...
      pageid: 30433662
      parsetree: <str(193764)> <root><template><title>Redirect</title>...
      requests: <list(2)> parse, imageinfo
      title: Ford Motor Company
      wikibase: Q44294
      wikidata_url: https://www.wikidata.org/wiki/Q44294
      wikitext: <str(157653)> {{Redirect|Ford}}{{pp-semi-indef}}{{pp-m...
    }
    en.wikipedia.org (parse) AmerisourceBergen
    AmerisourceBergen (en) data
    {
      infobox: <dict(17)> name, logo, type, traded_as, foundation, loc...
      pageid: 1445945
      parsetree: <str(16501)> <root><template><title>short description...
      requests: <list(1)> parse
      title: AmerisourceBergen
      wikibase: Q470156
      wikidata_url: https://www.wikidata.org/wiki/Q470156
      wikitext: <str(11755)> {{short description|American healthcare c...
    }
    en.wikipedia.org (parse) Chevron Corporation
    Chevron Corporation (en) data
    {
      image: <list(0)> 
      infobox: <dict(24)> name, logo, logo_size, logo_caption, image, ...
      iwlinks: <list(2)> https://commons.wikimedia.org/wiki/Category:C...
      pageid: 284749
      parsetree: <str(120598)> <root><template><title>short descriptio...
      requests: <list(1)> parse
      title: Chevron Corporation
      wikibase: Q319642
      wikidata_url: https://www.wikidata.org/wiki/Q319642
      wikitext: <str(97793)> {{short description|American multinationa...
    }
    en.wikipedia.org (parse) Cardinal Health
    Cardinal Health (en) data
    {
      infobox: <dict(17)> name, logo, type, traded_as, industry, found...
      pageid: 1041632
      parsetree: <str(32814)> <root><template><title>Infobox company</...
      requests: <list(1)> parse
      title: Cardinal Health
      wikibase: Q902397
      wikidata_url: https://www.wikidata.org/wiki/Q902397
      wikitext: <str(25715)> {{Infobox company| name = Cardinal Health...
    }
    en.wikipedia.org (parse) Costco
    en.wikipedia.org (imageinfo) File:Costcoheadquarters.jpg
    Costco (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:Costcohea...
      infobox: <dict(35)> name, logo, logo_caption, image, image_size,...
      iwlinks: <list(1)> https://commons.wikimedia.org/wiki/Category:Costco
      pageid: 446056
      parsetree: <str(97750)> <root><template><title>Distinguish</titl...
      requests: <list(2)> parse, imageinfo
      title: Costco
      wikibase: Q715583
      wikidata_url: https://www.wikidata.org/wiki/Q715583
      wikitext: <str(71853)> {{Distinguish|COSCO|Cosco (India) Limited...
    }
    en.wikipedia.org (parse) Verizon Communications
    en.wikipedia.org (imageinfo) File:Verizon Building (8156005279).jpg
    Verizon Communications (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:Verizon B...
      infobox: <dict(30)> name, logo, image, image_caption, former_nam...
      iwlinks: <list(3)> https://commons.wikimedia.org/wiki/Category:T...
      pageid: 18619278
      parsetree: <str(147152)> <root><template><title>short descriptio...
      requests: <list(2)> parse, imageinfo
      title: Verizon Communications
      wikibase: Q467752
      wikidata_url: https://www.wikidata.org/wiki/Q467752
      wikitext: <str(124812)> {{short description|American communicati...
    }
    en.wikipedia.org (parse) Kroger
    en.wikipedia.org (imageinfo) File:Cincinnati-kroger-building.jpg
    Kroger (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:Cincinnat...
      infobox: <dict(24)> name, logo, image, image_caption, type, trad...
      iwlinks: <list(1)> https://commons.wikimedia.org/wiki/Category:Kroger
      pageid: 367762
      parsetree: <str(121519)> <root><template><title>Use American Eng...
      requests: <list(2)> parse, imageinfo
      title: Kroger
      wikibase: Q153417
      wikidata_url: https://www.wikidata.org/wiki/Q153417
      wikitext: <str(102176)> {{Use American English|date = August 201...
    }
    en.wikipedia.org (parse) General Electric
    General Electric (en) data
    {
      infobox: <dict(20)> name, logo, type, traded_as, ISIN, industry,...
      iwlinks: <list(1)> https://commons.wikimedia.org/wiki/Category:G...
      pageid: 12730
      parsetree: <str(162543)> <root><template><title>redirect</title>...
      requests: <list(1)> parse
      title: General Electric
      wikibase: Q54173
      wikidata_url: https://www.wikidata.org/wiki/Q54173
      wikitext: <str(137546)> {{redirect|GE}}{{distinguish|text=the fo...
    }
    en.wikipedia.org (parse) Walgreens Boots Alliance
    Walgreens Boots Alliance (en) data
    {
      infobox: <dict(29)> name, logo, logo_size, type, traded_as, pred...
      pageid: 44732533
      parsetree: <str(32631)> <root><template><title>Use mdy dates</ti...
      requests: <list(1)> parse
      title: Walgreens Boots Alliance
      wikibase: Q18712620
      wikidata_url: https://www.wikidata.org/wiki/Q18712620
      wikitext: <str(25099)> {{Use mdy dates|date=October 2019}}{{shor...
    }
    en.wikipedia.org (parse) JPMorgan Chase
    en.wikipedia.org (imageinfo) File:383 Madison Ave Bear Stearns C ...
    JPMorgan Chase (en) data
    {
      image: <list(1)> {'kind': 'parse-image', 'file': 'File:383 Madis...
      infobox: <dict(31)> name, logo, image, image_caption, type, trad...
      iwlinks: <list(2)> https://commons.wikimedia.org/wiki/Category:J...
      pageid: 231001
      parsetree: <str(137921)> <root><template><title>About</title><pa...
      requests: <list(2)> parse, imageinfo
      title: JPMorgan Chase
      wikibase: Q192314
      wikidata_url: https://www.wikidata.org/wiki/Q192314
      wikitext: <str(112397)> {{About|JPMorgan Chase & Co|its main sub...
    }
    

Let's take a look at `wiki_data` for the first instance i.e. **Walmart**,


```python
wiki_data[0]
```




    {'founder': '[[Sam Walton]]',
     'location_country': 'U.S.',
     'revenue': '{{increase}} {{US$|514.405 billion|link|=|yes}} (2019)',
     'operating_income': '{{increase}} {{US$|21.957 billion}} (2019)',
     'net_income': '{{decrease}} {{US$|6.67 billion}} (2019)',
     'assets': '{{increase}} {{US$|219.295 billion}} (2019)',
     'equity': '{{decrease}} {{US$|79.634 billion}} (2019)',
     'type': '[[Public company|Public]]',
     'industry': '[[Retail]]',
     'products': '{{hlist|Electronics|Movies and music|Home and furniture|Home improvement|Clothing|Footwear|Jewelry|Toys|Health and beauty|Pet supplies|Sporting goods and fitness|Auto|Photo finishing|Craft supplies|Party supplies|Grocery}}',
     'num_employees': '{{plainlist|\n* 2.2|nbsp|million, Worldwide (2018)|ref| name="xbrlus_1" |\n* 1.5|nbsp|million, U.S. (2017)|ref| name="Walmart"|{{cite web |url = http://corporate.walmart.com/our-story/locations/united-states |title = Walmart Locations Around the World – United States |publisher = |url-status=live |archiveurl = https://web.archive.org/web/20150926012456/http://corporate.walmart.com/our-story/locations/united-states |archivedate = September 26, 2015 |df = mdy-all }}|</ref>|\n* 700,000, International}} {{nbsp}} million, Worldwide (2018) * 1.5 {{nbsp}} million, U.S. (2017) * 700,000, International',
     'company_name': 'Walmart'}



So, we have successfully retrived all the infobox data for the companies. Also we can notice that some additional wrangling and cleaning is required which we will perform in the next section. 

Finally, let's export all the scapped infoboxes as a single JSON file to a convenient location as follows,


```python
with open('../data/infoboxes.json', 'w') as file:
    json.dump(wiki_data, file)
```

### References

- https://phpenthusiast.com/blog/what-is-rest-api
- https://github.com/siznax/wptools/wiki/Data-captured
