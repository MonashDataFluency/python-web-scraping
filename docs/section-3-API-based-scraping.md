## Web API based scraping

### A brief introduction to APIs
---

In this section, we will take a look at an alternative way to gather data than the previous pattern based, HTML scraping. Sometimes websites offer an API (or Application Programming Interface) as a service which provides a high level interface to directly retrieve data from their repositories or databases at the backend. 

From wikipedia,

> An API is typically defined as a set of specifications, such as Hypertext Transfer Protocol (HTTP) request messages, along with a definition of the structure of response messages, usually in an Extensible Markup Language (XML) or JavaScript Object Notation (JSON) format.

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

Here we focus on the latter approach and will use a Python library (a wrapper) called `wptools` based around the MediaWiki API.

One advantage of using official APIs is that they are usually compliant of the terms of service (ToS) of a particular service that researchers are looking to gather data from. However, third-party libraries or packages which claim to provide more throughput than the official APIs (rate limits, number of requests/sec) generally operate in a gray area as they tend to violate ToS.

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
import itertools
import wikipedia
import pandas as pd
from pathlib import Path
from wordcloud import WordCloud
import matplotlib.pyplot as plt
from IPython.display import Image

%matplotlib inline
plt.style.use('ggplot')              # setting the style to ggplot

print(wptools.__version__)           # checking the installed version
```

    0.4.17
    

Now let's load the data which we scrapped in the previous section as follows,


```python
fname = 'fortune_500_companies.csv' # filename
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

Now let's take a brief look as follows,


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

Right off the bat, as you might have guessed, a tricky issue with matching the top 20 Fortune 500 companies to their wikipedia article names is that both of them would not be exactly the same i.e. they match character for character.

To overcome this problem and ensure that we have all the company names and its corresponding wikipedia article, we will use (https://wikipedia.readthedocs.io/en/latest/code.html) to get suggestions for the company names and their equivalent in wikipedia.


```python
wiki_search = [{company : wikipedia.search(company)} for company in companies]
```


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
    
    
    


```python
most_probable = [(company, wiki_search[i][company][0]) for i, company in enumerate(companies)]
most_probable
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




```python
companies = [x[1] for x in most_probable]
companies
```




    ['Walmart',
     'ExxonMobil',
     'Berkshire Hathaway',
     'Apple',
     'UnitedHealth Group',
     'McKesson Corporation',
     'CVS Health',
     'Amazon (company)',
     'AT&T',
     'General Motors',
     'Ford Motor Company',
     'AmerisourceBergen',
     'Chevron Corporation',
     'Cardinal Health',
     'Costco',
     'Verizon Communications',
     'Kroger',
     'General Electric',
     'Walgreens Boots Alliance',
     'JPMorgan Chase']



For **Apple**, lets manually replace it with **Apple Inc.** as follows,


```python
companies[companies.index('Apple')] = 'Apple Inc.'
print(companies)
```

    ['Walmart', 'ExxonMobil', 'Berkshire Hathaway', 'Apple Inc.', 'UnitedHealth Group', 'McKesson Corporation', 'CVS Health', 'Amazon (company)', 'AT&T', 'General Motors', 'Ford Motor Company', 'AmerisourceBergen', 'Chevron Corporation', 'Cardinal Health', 'Costco', 'Verizon Communications', 'Kroger', 'General Electric', 'Walgreens Boots Alliance', 'JPMorgan Chase']
    

> Note : Wiki data dump link (last updated 2015) : https://old.datahub.io/dataset/wikidata

## wptools

- https://github.com/siznax/wptools/wiki/Data-captured


```python
page = wptools.page('Walmart')
page.get_parse()
page.get_wikidata()
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
    www.wikidata.org (wikidata) Q483551
    www.wikidata.org (labels) Q180816|Q219635|P18|Q478758|Q10382887|Q...
    www.wikidata.org (labels) P740|Q54862513|P966|P3500|Q6383259|Q694...
    www.wikidata.org (labels) Q818364|P6160|P1278|P3347|Q17343056|P37...
    en.wikipedia.org (imageinfo) File:Walmart Home Office.jpg
    Walmart (en) data
    {
      aliases: <list(5)> Wal-Mart, Wal Mart, Wal-Mart Stores, Inc., Wa...
      claims: <dict(63)> P112, P946, P373, P31, P856, P910, P159, P414...
      description: U.S. discount retailer based in Arkansas
      image: <list(2)> {'kind': 'parse-image', 'file': 'File:Walmart s...
      infobox: <dict(30)> name, logo, logo_caption, image, image_size,...
      iwlinks: <list(2)> https://commons.wikimedia.org/wiki/Category:W...
      label: Walmart
      labels: <dict(116)> Q180816, Q219635, P18, Q478758, Q10382887, Q...
      modified: <dict(1)> wikidata
      pageid: 33589
      parsetree: <str(346504)> <root><template><title>about</title><pa...
      requests: <list(7)> parse, imageinfo, wikidata, labels, labels, ...
      title: Walmart
      what: retail chain
      wikibase: Q483551
      wikidata: <dict(63)> founded by (P112), ISIN (P946), Commons cat...
      wikidata_pageid: 455133
      wikidata_url: https://www.wikidata.org/wiki/Q483551
      wikitext: <str(274081)> {{about|the retail chain|other uses}}{{p...
    }
    




    <wptools.page.WPToolsPage at 0x7f1fc48660f0>




```python
page.data.keys()
```




    dict_keys(['requests', 'iwlinks', 'pageid', 'wikitext', 'parsetree', 'infobox', 'title', 'wikibase', 'wikidata_url', 'image', 'labels', 'wikidata', 'wikidata_pageid', 'aliases', 'modified', 'description', 'label', 'claims', 'what'])



Alternatively,


```python
page.data['wikidata']
```




    {'founded by (P112)': 'Sam Walton (Q497827)',
     'ISIN (P946)': 'US9311421039',
     'Commons category (P373)': 'Walmart',
     'instance of (P31)': ['retail chain (Q507619)', 'enterprise (Q6881511)'],
     'official website (P856)': 'https://www.walmart.com',
     "topic's main category (P910)": 'Category:Walmart (Q6383259)',
     'headquarters location (P159)': ['Bentonville (Q818364)', 'Arkansas (Q1612)'],
     'stock exchange (P414)': 'New York Stock Exchange (Q13677)',
     'subsidiary (P355)': ["Sam's Club (Q1972120)",
      'Massmart (Q3297791)',
      'Walmart Canada (Q1645718)',
      'Walmart Chile (Q5283104)',
      'Walmart de México y Centroamérica (Q1064887)',
      'Seiyu Group (Q3108542)',
      'Asda (Q297410)',
      'Walmart Labs (Q3816562)',
      'Walmart (Q30338489)',
      'Más Club (Q6949810)',
      'Líder (Q6711261)',
      'Hypermart USA (Q16845747)',
      'Amigo Supermarkets (Q4746234)',
      'Walmart Neighborhood Market (Q7963529)',
      'Asda Mobile (Q4804093)',
      'Marketside (Q6770960)',
      'Vudu (Q5371838)',
      'Walmart Nicaragua (Q22121904)'],
     'owned by (P127)': ['Walton Enterprises (Q17343056)',
      'State Street Corporation (Q2037125)',
      'The Vanguard Group (Q849363)',
      'BlackRock (Q219635)'],
     'VIAF ID (P214)': '128951275',
     'Freebase ID (P646)': '/m/0841v',
     'inception (P571)': '+1962-07-02T00:00:00Z',
     'industry (P452)': ['retail (Q126793)',
      'retail chain (Q507619)',
      'discount store (Q261428)'],
     'chairperson (P488)': ['Doug McMillon (Q16196595)',
      'Greg Penner (Q20177269)'],
     'motto text (P1451)': 'Save money. Live better.',
     'Facebook ID (P2013)': 'walmart',
     'Twitter username (P2002)': 'Walmart',
     'part of (P361)': ['S&P 500 (Q242345)',
      'Dow Jones Industrial Average (Q180816)'],
     'image (P18)': 'Walmart Home Office.jpg',
     'location of formation (P740)': 'Rogers (Q79497)',
     'country (P17)': 'United States of America (Q30)',
     'legal form (P1454)': 'public company (Q891723)',
     'named after (P138)': 'Sam Walton (Q497827)',
     'total revenue (P2139)': [{'amount': '+482130000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+482130500000',
       'lowerBound': '+482129500000'},
      {'amount': '+485651000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+485651500000',
       'lowerBound': '+485650500000'},
      {'amount': '+476294000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+476294500000',
       'lowerBound': '+476293500000'},
      {'amount': '+468651000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+468651500000',
       'lowerBound': '+468650500000'},
      {'amount': '+446509000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+446509500000',
       'lowerBound': '+446508500000'},
      {'amount': '+485873000000', 'unit': 'http://www.wikidata.org/entity/Q4917'}],
     'net profit (P2295)': [{'amount': '+14694000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+14694500000',
       'lowerBound': '+14693500000'},
      {'amount': '+16182000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+16182500000',
       'lowerBound': '+16181500000'},
      {'amount': '+15918000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+15918500000',
       'lowerBound': '+15917500000'},
      {'amount': '+16963000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+16963500000',
       'lowerBound': '+16962500000'},
      {'amount': '+15734000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+15734500000',
       'lowerBound': '+15733500000'},
      {'amount': '+13643000000', 'unit': 'http://www.wikidata.org/entity/Q4917'}],
     'total assets (P2403)': [{'amount': '+199581000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+199581500000',
       'lowerBound': '+199580500000'},
      {'amount': '+203490000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+203490500000',
       'lowerBound': '+203489500000'},
      {'amount': '+204541000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+204541500000',
       'lowerBound': '+204540500000'},
      {'amount': '+202910000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+202910500000',
       'lowerBound': '+202909500000'},
      {'amount': '+193120000000',
       'unit': 'http://www.wikidata.org/entity/Q4917',
       'upperBound': '+193120500000',
       'lowerBound': '+193119500000'},
      {'amount': '+198825000000', 'unit': 'http://www.wikidata.org/entity/Q4917'}],
     'employees (P1128)': {'amount': '+2300000', 'unit': '1'},
     'Legal Entity Identifier (P1278)': 'Y87794H0US1R65VBXU25',
     'Instagram username (P2003)': 'walmart',
     'Google+ ID (P2847)': '111852759168797891317',
     'chief executive officer (P169)': ['Doug McMillon (Q16196595)',
      'Mike Duke (Q1933118)',
      'Lee Scott (Q478758)',
      'David Glass (Q5234167)',
      'Sam Walton (Q497827)'],
     'Quora topic ID (P3417)': 'Walmart-company',
     'Justia Patents company ID (P3875)': 'wal-mart',
     'logo image (P154)': 'Walmart logo.svg',
     'IPv4 routing prefix (P3761)': '156.94.0.0/16',
     'ISNI (P213)': '0000 0004 0616 1876',
     'operating income (P3362)': [{'amount': '+22764000000',
       'unit': 'http://www.wikidata.org/entity/Q4917'},
      {'amount': '+24105000000', 'unit': 'http://www.wikidata.org/entity/Q4917'},
      {'amount': '+27147000000', 'unit': 'http://www.wikidata.org/entity/Q4917'}],
     'website account on (P553)': 'WeChat (Q283233)',
     'PermID (P3347)': '4295905298',
     'Encyclopædia Britannica Online ID (P1417)': 'topic/Wal-Mart',
     'GRID ID (P2427)': 'grid.480455.8',
     'award received (P166)': 'Public Eye Labour Law Award (Q54862513)',
     'Central Index Key (P5531)': '0000104169',
     'IdRef ID (P269)': '050771116',
     'owner of (P1830)': ['Asda (Q297410)',
      "Sam's Club (Q1972120)",
      'Seiyu Group (Q3108542)',
      'Bodega Aurrerá (Q3365858)',
      'Asda Mobile (Q4804093)',
      'Bompreço (Q4940907)',
      'Hayneedle (Q5687056)',
      'Mercadorama (Q10328812)',
      None,
      'Jet.com (Q22079907)',
      '.george (Q26911051)',
      '.samsclub (Q26972795)',
      'Shoes.com (Q46438789)'],
     'NKCR AUT ID (P691)': 'osa2010597558',
     'Microsoft Academic ID (P6366)': '1330693074',
     'market capitalization (P2226)': {'amount': '+239000000000',
      'unit': 'http://www.wikidata.org/entity/Q4917'},
     'member of (P463)': 'Linux Foundation (Q858851)',
     'Library of Congress authority ID (P244)': 'n90648829',
     'MusicBrainz label ID (P966)': 'b3a104e8-eed0-4a3e-aae8-676c6e7ab016',
     'ROR ID (P6782)': '04j0gge90',
     'Ringgold ID (P3500)': '48990',
     'BoardGameGeek game publisher ID (P6160)': '29995',
     'total equity (P2137)': {'amount': '+80535000000',
      'unit': 'http://www.wikidata.org/entity/Q4917'},
     'DR topic ID (P6849)': 'walmart',
     'BBC News topic ID (P6200)': 'ce1qrvlex0et',
     'Gran Enciclopèdia Catalana ID (P1296)': '0256072',
     'Downdetector ID (P7306)': 'wal-mart',
     'LittleSis organisation ID (P3393)': '1-Walmart',
     'WeChat ID (P7650)': 'Walmart_Hyper',
     'Pinterest username (P3836)': 'walmart'}




```python
wiki_data = []
# attributes of interest contained within the wiki infoboxes
features = ['founder', 'location_country', 'revenue', 'operating_income', 'net_income', 'assets',
        'equity', 'type', 'industry', 'products', 'num_employees']
```

Now lets fetch results for all the companies as follows,


```python
for company in companies:    
    page = wptools.page(company)
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
    


```python
wiki_data
```




    [{'founder': '[[Sam Walton]]',
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
      'company_name': 'Walmart'},
     {'founder': '',
      'location_country': '',
      'revenue': '{{Nowrap|Increase| |US$|279.3 billion|link|=|yes|ref| name="201310K"|[https://corporate.exxonmobil.com/-/media/global/files/annual-report/2018-financial-and-operating-review.pdf EXXON MOBIL CORPORATION Form 10-K] {{Webarchive|url=https://web.archive.org/web/20190404044022/https://corporate.exxonmobil.com/-/media/global/files/annual-report/2018-financial-and-operating-review.pdf |date=April 4, 2019 }}, \'\'Google Finance\'\', March 21, 2019|</ref>}} {{Increase}} {{US$|279.3 billion|link|=|yes}}',
      'operating_income': '{{Nowrap|Increase| |US$|21.53 billion|ref| name="201310K"}} {{Increase}} {{US$|21.53 billion}}',
      'net_income': '{{Nowrap|Increase| |US$|20.84 billion|ref| name="201310K"}} {{Increase}} {{US$|20.84 billion}}',
      'assets': '{{Nowrap|Decrease| |US$|346.2 billion|ref| name="201310K"}} {{Decrease}} {{US$|346.2 billion}}',
      'equity': '{{Nowrap|Increase| |US$|191.8 billion|ref| name="201310K"}} {{Increase}} {{US$|191.8 billion}}',
      'type': '[[Public company|Public]]',
      'industry': '[[Energy industry|Energy]]: [[Oil and gas industry|Oil and gas]]',
      'products': '{{Unbulleted list\n  | [[Crude oil]]\n  | [[Oil products]]\n  | [[Natural gas]]\n  | [[Petrochemical]]s\n  | [[Power generation]]}}',
      'num_employees': '71,000',
      'company_name': 'ExxonMobil'},
     {'founder': '[[Oliver Chace]]<br>[[Warren Buffett]] (Modern era)',
      'location_country': '',
      'revenue': '{{increase}} US$247.5 billion (2018)',
      'operating_income': '{{Decrease}} US$10.02 billion (2018)',
      'net_income': '{{Decrease}} US$4.02 billion (2018)',
      'assets': '{{increase}} US$707.8 billion (2018)',
      'equity': '{{increase}} US$348.7 billion (2018)',
      'type': '[[Public company|Public]]',
      'industry': '[[Conglomerate (company)|Conglomerate]]',
      'products': '[[Investment|Diversified investments]], [[Insurance#Types|Property & casualty insurance]], [[Public utility|Utilities]], [[Restaurants]], [[Food processing]], [[Aerospace]], [[Toys]], [[Mass media|Media]], [[Automotive industry|Automotive]], [[Sports equipment|Sporting goods]], [[Final good|Consumer products]], [[Internet]], [[Real estate]]',
      'num_employees': '{{nowrap|389,373 (2018)}}',
      'company_name': 'Berkshire Hathaway'},
     {'founder': '',
      'location_country': '',
      'revenue': '{{Decrease}} {{US$|260.174&nbsp;billion|link|=|yes}}',
      'operating_income': '{{Decrease}} {{US$|63.930&nbsp;billion}}',
      'net_income': '{{Decrease}} {{US$|55.256&nbsp;billion}}',
      'assets': '{{Decrease}} {{US$|338.516&nbsp;billion}}',
      'equity': '{{Decrease}} {{US$|90.488&nbsp;billion}}',
      'type': '[[Public company|Public]]',
      'industry': '{{Unbulleted list | [[Computer hardware]] | [[Computer software]] | [[Consumer electronics]] | [[Cloud computing]] | [[Digital distribution]] | [[Fabless manufacturing|Fabless silicon design]] | [[Semiconductors]] | [[Financial technology]] | [[Artificial intelligence]]}}',
      'products': '{{Flatlist|\n* [[Macintosh]]\n* [[iPod]]\n* [[iPhone]]\n* [[iPad]]\n* [[Apple Watch]]\n* [[Apple TV]]\n* [[HomePod]]\n* [[macOS]]\n* [[iOS]]\n* [[iPadOS]]\n* [[watchOS]]\n* [[tvOS]]\n* [[iLife]]\n* [[iWork]]\n* [[Final Cut Pro]]\n* [[Logic Pro]]\n* [[GarageBand]]\n* [[Shazam (application)|Shazam]]\n* [[Siri]]}}',
      'num_employees': '137,000',
      'company_name': 'Apple Inc.'},
     {'founder': 'Richard T. Burke',
      'location_country': '',
      'revenue': '{{increase}} $242.155 billion (2019)',
      'operating_income': '{{increase}} $17.981 billion (2019)',
      'net_income': '{{increase}} $14.239 billion (2019)',
      'assets': '{{increase}} $173.889 billion (2019)',
      'equity': '{{increase}} $60.436 billion (2019)',
      'type': '[[Public company]]',
      'industry': '[[Managed health care]]',
      'products': '[[Uniprise]], [[Health Care]] [[Service (economics)|Services]], Specialized Care Services, and [[Ingenix]]',
      'num_employees': '300,000 (2019)',
      'company_name': 'UnitedHealth Group'},
     {'founder': 'John McKesson<br>Charles Olcott',
      'location_country': '',
      'revenue': '{{increase}} {{US$|208.4 billion}} {{small|(2018)}}',
      'operating_income': '{{increase}} {{US$|2.921 billion}} {{small|(2018)}}',
      'net_income': '{{increase}} {{US$|67 million}} {{small|(2018)}}',
      'assets': '{{nowrap|increase| |US$|60.381 billion| |small|(2018)|ref| name=FY}} {{increase}} {{US$|60.381 billion}} {{small|(2018)}}',
      'equity': '{{decrease}} {{US$|10.057 billion}} {{small|(2018)}}',
      'type': '[[Public company|Public]]',
      'industry': '[[Healthcare]]',
      'products': '[[Pharmaceuticals]]<br>[[Medical technology]]<br>[[Health care services]]',
      'num_employees': '~78,000 {{small|(2018)}}',
      'company_name': 'McKesson Corporation'},
     {'founder': '',
      'location_country': '',
      'revenue': '{{ublist|class|=|nowrap|increase| |US$|194.579 billion| (2018)|US$|184.786 billion| (2017)}} {{increase}} {{US$|194.579 billion}} (2018) {{US$|184.786 billion}} (2017)',
      'operating_income': '{{ublist|class|=|nowrap|decrease| |US$|4.021 billion| (2018)|US$|9.538 billion| (2017)}} {{decrease}} {{US$|4.021 billion}} (2018) {{US$|9.538 billion}} (2017)',
      'net_income': '{{ublist|class|=|nowrap|decrease| |US$|-596 million| (2018)|US$|6.623 billion| (2017)}} {{decrease}} {{US$|-596 million}} (2018) {{US$|6.623 billion}} (2017)',
      'assets': '{{increase}} {{US$|196.456 billion}}',
      'equity': '{{increase}} {{US$|58.225 billion}}',
      'type': '[[Public company|Public]]',
      'industry': '{{flat list|\n* [[Retail]]\n* [[health care]]}}',
      'products': '',
      'num_employees': '295,000',
      'company_name': 'CVS Health'},
     {'founder': '[[Jeff Bezos]]',
      'location_country': '',
      'revenue': '{{increase}} {{US$|232.887 billion|link|=|yes}}',
      'operating_income': '{{increase}} {{US$|12.421 billion}}',
      'net_income': '{{increase}} {{US$|10.073 billion}}',
      'assets': '{{decrease}} {{US$|162.648 billion}}',
      'equity': '{{decrease}} {{US$|43.549 billion}}',
      'type': '[[Public company|Public]]',
      'industry': '{{plainlist|\n* [[Cloud computing]]\n* [[E-commerce]]\n* [[Artificial intelligence]]\n* [[Consumer electronics]]\n* [[Digital distribution]]\n* [[Grocery stores]]}}',
      'products': '{{Hlist|[[Amazon Echo]]|[[Amazon Fire tablet|Amazon Fire]]|[[Amazon Fire TV]]|[[Fire OS|Amazon Fire OS]]|[[Amazon Kindle]]}}',
      'num_employees': '{{increase}} 750,000 (2019)',
      'company_name': 'Amazon (company)'},
     {'founder': '',
      'location_country': '',
      'revenue': '{{increase}} {{US$|link|=|yes}} 170.756 billion (2018)',
      'operating_income': '{{increase}} {{US$|link|=|yes}} 26.096 billion  (2018)',
      'net_income': '{{increase}} {{US$|link|=|yes}} 19.953 billion  (2018)',
      'assets': '{{increase}} {{US$|link|=|yes}} 531 billion     (2018)',
      'equity': '{{increase}} {{US$|link|=|yes}} 193.884 billion (2018)',
      'type': '[[Public company|Public]]',
      'industry': '{{Unbulleted list|[[Telecommunications industry|Telecommunications]]|[[Technology company|Technology]]|[[Mass media]]|[[Entertainment]]}}',
      'products': '{{Hlist|[[Satellite television]]|[[Landline|Fixed-line telephones]]|[[Mobile phone|Mobile telephones]]|[[Internet service provider|Internet services]]|[[Broadband]]|[[Digital television]]|[[Home security]]|[[IPTV]]|[[Over-the-top media services|OTT services]]|[[Network security]]|[[Filmmaking|Film production]]|[[Television production]]|[[Cable television]]|[[Pay television]]|[[Publishing]]|[[Podcast]]s|[[Sports management]]|[[News agency]]|[[Video game]]s}}',
      'num_employees': '251,840 (2019)',
      'company_name': 'AT&T'},
     {'founder': '[[William C. Durant]]',
      'location_country': 'US',
      'revenue': '{{decrease}} [[United States dollar|US$]]147.049 billion {{small|(2018)}}',
      'operating_income': '{{decrease}} US$11.783 billion {{small|(2018)}}',
      'net_income': '{{increase}} US$8.014 billion {{small|(2018)}}',
      'assets': '{{increase}} US$227.339 billion {{small|(2018)}}',
      'equity': '{{increase}} US$42.777 billion {{small|(2018)}}',
      'type': '[[Public company|Public]]',
      'industry': '[[Automotive industry|Automotive]]',
      'products': '[[Car|Automobiles]]<br />Automobile parts<br />[[Commercial vehicle]]s',
      'num_employees': '170,483 {{small|(December 2018)}}',
      'company_name': 'General Motors'},
     {'founder': '[[Henry Ford]]',
      'location_country': 'U.S.',
      'revenue': '{{increase}} {{US$|160.33 billion|link|=|yes}} {{small|(2018)}}',
      'operating_income': '{{decrease}} {{US$|3.27 billion}} {{small|(2018)}}',
      'net_income': '{{decrease}} {{US$|3.67 billion}} {{small|(2018)}}',
      'assets': '{{decrease}} {{US$|256.54 billion}} {{small|(2018)}}',
      'equity': '{{decrease}} {{US$|35.93 billion}} {{small|(2018)}}',
      'type': '[[Public company|Public]]',
      'industry': '[[Automotive industry|Automotive]]',
      'products': '{{unbulleted list\n  | [[Car|Automobiles]]\n  | [[Luxury Car|Luxury Vehicles]]\n  | [[Commercial vehicle|Commercial Vehicles]]\n  | [[List of auto parts|Automotive parts]]\n  | [[Pickup trucks]]\n  | [[SUVs]]}}',
      'num_employees': '199,000 {{small|(December 2018)}}',
      'company_name': 'Ford Motor Company'},
     {'founder': '',
      'location_country': '',
      'revenue': '{{increase}} {{US$|167.93 billion|link|=|yes}} (2018)',
      'operating_income': '{{increase}} {{US$|1.44 billion}} (2018)',
      'net_income': '{{increase}} {{US$|1.65 billion}} (2018)',
      'assets': '{{increase}} {{US$|37.66 billion}} (2018)',
      'equity': '{{increase}} {{US$|2.93 billion}} (2018)',
      'type': '[[Public company|Public]]',
      'industry': '[[Pharmaceutical]]',
      'products': '[[Pharmaceutical]]s and [[pharmacy]] services',
      'num_employees': '20,000 (2018)',
      'company_name': 'AmerisourceBergen'},
     {'founder': '',
      'location_country': '',
      'revenue': '{{increase}} {{US$|158.9 billion|link|=|yes}} {{small|(2018)}}',
      'operating_income': '{{increase}} {{US$|15.45 billion}} {{small|(2018)}}',
      'net_income': '{{increase}} {{US$|14.82 billion}} {{small|(2018)}}',
      'assets': '{{decrease}} {{US$|253.9 billion}} {{small|(2018)}}',
      'equity': '{{increase}} {{US$|154.5 billion}} {{small|(2018)}}',
      'type': '[[Public company|Public]]',
      'industry': '[[Oil and gas industry|Oil and gas]]',
      'products': "[[Petroleum]], [[natural gas]] and other [[petrochemical]]s, ''[[#Marketing brands|See Chevron products]]''",
      'num_employees': '~51,900 {{small|(December 2018)}}',
      'company_name': 'Chevron Corporation'},
     {'founder': '',
      'location_country': '',
      'revenue': '{{increase}} [[US$]]136.80 billion {{small|(2018)}}',
      'operating_income': '{{decrease}} US$126 million {{small|(2018)}}',
      'net_income': '{{decrease}} US$256 million {{small|(2018)}}',
      'assets': '{{increase}} US$39.95 billion {{small|(2018)}}',
      'equity': '{{increase}} US$6.05 billion {{small|(2018)}}',
      'type': '[[Public company|Public]]',
      'industry': '[[Pharmaceuticals]]',
      'products': 'Medical and pharmaceutical products and services',
      'num_employees': '~50,000 {{small|(2018)}}',
      'company_name': 'Cardinal Health'},
     {'founder': '',
      'location_country': 'United States',
      'revenue': '{{increase}} {{US$|152.7 billion}}',
      'operating_income': '{{increase}} US$4.74 billion (2018)',
      'net_income': '{{increase}} US$3.66 billion',
      'assets': '{{increase}} US$45.40 billion',
      'equity': '{{increase}} US$15.24 billion',
      'type': '[[Public company|Public]]',
      'industry': '[[Retail]]',
      'products': '',
      'num_employees': '{{increase}} 254,000',
      'company_name': 'Costco'},
     {'founder': '',
      'location_country': '',
      'revenue': '{{increase}} {{US$|130.86 [[1,000,000,000|billion]]|link|=|yes}}',
      'operating_income': '{{decrease}} {{US$|22.27 billion}}',
      'net_income': '{{decrease}} {{US$|15.52 billion}}',
      'assets': '{{increase}} {{US$|264.82 billion}}',
      'equity': '{{increase}} {{US$|53.14 billion}}',
      'type': '[[Public company|Public]]',
      'industry': '{{Plainlist|\n*[[Telecommunications industry|Telecommunications]]\n*[[Mass media]]}}',
      'products': '{{Plainlist|\n*[[Cable television]]\n*[[Landline]]\n*[[Mobile phone]]\n*[[Broadband]]\n*[[Digital television]]\n*[[IPTV]]\n*[[Digital Media]]\n*[[Internet of things|Internet]]\n*[[Telematics]]}}',
      'num_employees': '135,400 (2020)',
      'company_name': 'Verizon Communications'},
     {'founder': '[[Bernard Kroger]]',
      'location_country': 'U.S.',
      'revenue': '{{increase}} {{US$|121.16 billion|link|=|yes}} (2019)',
      'operating_income': '{{increase}} {{US$|2.67 billion}} (2019)',
      'net_income': '{{increase}} {{US$|3.11 billion}} (2019)',
      'assets': '{{increase}} {{US$|38.11 billion}} (2019)',
      'equity': '{{increase}} {{US$|7.88 billion}} (2019)',
      'type': '[[Public company|Public]]',
      'industry': '[[Retail]]',
      'products': '[[Supercenter]]/[[superstore]],<br>Other specialty, [[supermarket]]',
      'num_employees': '453,000 (2019)',
      'company_name': 'Kroger'},
     {'founder': '',
      'location_country': '',
      'revenue': '{{nowrap|Increase| [[US$]] 121.615 billion |small|(2018)}} {{Increase}} [[US$]] 121.615 billion {{small|(2018)}}',
      'operating_income': '{{nowrap|Decrease| US$ |color|red|&minus;20.717| billion |small|(2018)}} {{Decrease}} US$ {{color|red|&minus;20.717}} billion {{small|(2018)}}',
      'net_income': '{{nowrap|Decrease| US$ |color|red|&minus;22.355| billion |small|(2018)}} {{Decrease}} US$ {{color|red|&minus;22.355}} billion {{small|(2018)}}',
      'assets': '{{nowrap|Decrease| US$ 309.129 billion |small|(2018)}} {{Decrease}} US$ 309.129 billion {{small|(2018)}}',
      'equity': '{{nowrap|Decrease| US$ 30.981 billion |small|(2018)}} {{Decrease}} US$ 30.981 billion {{small|(2018)}}',
      'type': '[[Public company|Public]]',
      'industry': '[[Conglomerate (company)|Conglomerate]]',
      'products': '{{hlist|[[Aircraft engine]]s|[[Electric power distribution|Electrical distribution]]|[[Electric motor]]s|[[Energy]]|[[Finance]]|[[Health care]]|[[Lighting]]|[[Software]]|[[Wind turbine]]s}}',
      'num_employees': '283,000 {{small|(2018)}}',
      'company_name': 'General Electric'},
     {'founder': '',
      'location_country': '',
      'revenue': "{{nowrap|increase| |US$|136.9 billion|link|=|yes|ref| name='10-K'|{{cite web|url=https://sec.report/Document/0001618921-19-000069/ |title=Walgreens Boots Alliance Annual Report (Form 10-K) |publisher=[[U.S. Securities and Exchange Commission]]}}|</ref>}} {{increase}} {{US$|136.9 billion|link|=|yes}}",
      'operating_income': '{{decrease}} {{US$|4.9 billion}}',
      'net_income': '{{decrease}} {{US$|3.9 billion}}',
      'assets': '{{decrease}} {{US$|67.59 billion}}',
      'equity': '{{decrease}} {{US$|24.15 billion}}',
      'type': '[[Public company|Public]]',
      'industry': '[[Pharmaceutical]]<br>[[Retail]]',
      'products': '[[Drug store]]<br>[[Pharmacy]]',
      'num_employees': '440,000',
      'company_name': 'Walgreens Boots Alliance'},
     {'founder': '[[Aaron Burr]] (Bank of the Manhattan Company)<br>[[J. P. Morgan|John Pierpont Morgan]]',
      'location_country': '',
      'revenue': '{{increase}} [[United States dollar|US$]]115.627 [[Billion (short scale)|billion]]',
      'operating_income': '{{increase}} [[United States dollar|US$]]44.545 billion',
      'net_income': '{{increase}} [[United States dollar|US$]]36.431 billion',
      'assets': '{{increase}} [[United States dollar|US$]]2.687 [[trillion]]',
      'equity': '{{increase}} [[United States dollar|US$]]261.330 billion',
      'type': '[[Public company|Public]]',
      'industry': '[[Bank]]ing<br>[[Financial services]]',
      'products': '[[Alternative financial service]]s, [[American depositary receipt]]s, [[asset allocation]], [[asset management]], [[Bond (finance)|bond]] trading, [[broker]] services, [[capital market]] services, [[collateralized debt obligation]]s, [[commercial banking]], [[commodity market|commodities]] trading, [[commercial bank]]ing, [[credit card]]s, [[credit default swap]], [[credit derivative]] trading, [[currency exchange]], [[custodian bank]]ing, [[debt settlement]], [[digital banking]], [[estate planning]], [[exchange-traded fund]]s, [[financial analysis]], [[financial market]]s, [[foreign exchange market]], [[futures exchange]], [[hedge fund]]s, [[index fund]]s, [[information processing]], [[institutional investor|institutional investing]], [[insurance]], [[investment bank]]ing, [[Financial capital|investment capital]], [[investment management]], investment [[Portfolio (finance)|portfolios]], [[loan servicing]], [[merchant services]], [[mobile banking]], [[money market]] trading,  [[mortgage brokers|mortgage broker]]ing, [[mortgage loan]]s, [[Mortgage-backed security|mortgage–backed securities]], [[mutual fund]]s, [[pension fund]]s, [[prime brokerage]], [[private banking]], [[private equity]], [[remittance]], [[retail banking]], retail [[broker]]age, [[risk management]], [[securities lending]], [[Security (finance)|security]] services, [[stock trader|stock trading]], [[subprime lending]], [[treasury services]], [[trustee]] services, [[underwriting]], [[venture capital]], [[wealth management]], [[wholesale funding]], [[Wholesale mortgage lenders|wholesale mortgage lending]], [[wire transfer]]s',
      'num_employees': '{{increase}} 256,981',
      'company_name': 'JPMorgan Chase'}]



Finally, let's export all the scapped infoboxes as a single JSON file to a convenient location as follows,


```python
with open('../data/infoboxes.json', 'w') as file:
    json.dump(wiki_data, file)
```

Import :


```python
with open('../data/infoboxes.json', 'r') as file:
    wiki_data = json.load(file)
```

### References

- https://phpenthusiast.com/blog/what-is-rest-api


```python

```
