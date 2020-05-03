In this section, we will clean, join perform some basic analysis on the data to answer a few questions. Let's import a few libraries we will require.


```python
import re 
import json
import itertools
import pandas as pd
from pathlib import Path
from wordcloud import WordCloud 
import matplotlib.pyplot as plt

%matplotlib inline
plt.style.use('ggplot') # setting the style to ggplot
```

Now let's read the `infoboxes.json` file we exported from Section 3 to a dictionary as follows,


```python
with open('../data/infoboxes.json', 'r') as file:
    wiki_data = json.load(file)
```

and have a quick glance at the first element of the same,


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



 For this excercise, we will primarily focus on the following attributes :
 - `products` 	
 - `industries` and 	
 - `assets`  
 
and try to answer a few questions using the data.

### What type of products are sold by the top 20 companies?

Looking at a sample for `products`,


```python
for i in range(0,3):
    print(wiki_data[i]['products'])
```

    {{hlist|Electronics|Movies and music|Home and furniture|Home improvement|Clothing|Footwear|Jewelry|Toys|Health and beauty|Pet supplies|Sporting goods and fitness|Auto|Photo finishing|Craft supplies|Party supplies|Grocery}}
    {{Unbulleted list
      | [[Crude oil]]
      | [[Oil products]]
      | [[Natural gas]]
      | [[Petrochemical]]s
      | [[Power generation]]}}
    [[Investment|Diversified investments]], [[Insurance#Types|Property & casualty insurance]], [[Public utility|Utilities]], [[Restaurants]], [[Food processing]], [[Aerospace]], [[Toys]], [[Mass media|Media]], [[Automotive industry|Automotive]], [[Sports equipment|Sporting goods]], [[Final good|Consumer products]], [[Internet]], [[Real estate]]


We can observe that we need to :
- Extract products from between `{{` and `}}` OR `[[` and `]]`
- Split and seperate by the delimiter `|`
- Only keep alphanumeric characters, `-` and preserve spaces

Let's define a few regular expressions to clean and extract the products from the dictionary.


```python
regex1 = re.compile('[\{\[]+(.*?)[\]\}]')
```

Regex breakdown :

- `[\{\[]+` : matches one or more `{` or `]`
- `(.*?)` : captures anything between the previous pattern and the next
- `[\]\}]` : matches ending in either `]` or `}` 


 > Note : `\` is used to escape `[]`

Similarly,


```python
regex2 = re.compile('[^a-zA-Z\- ]') # describe the expr
```

Regex breakdown :

- `[^a-zA-Z\- ]` : matches anything other than (signified by `^`) `a` to `z` OR `A` to `Z` OR `-` OR empty space. 

Patterns like these are useful for replacing or filtering everything else. Now lets clean and extract the data we need as follows,


```python
products = []
data = []

for x in wiki_data:
    y = x['products'] # get products
    z = regex1.findall(y) # extract all products
    z = [d.lower().split('|') for d in z] # get a list 
    m = list(itertools.chain(*z)) # flatten the list of lists using itertools
    m = [regex2.sub('', t) for t in m  if t != 'hlist'] # remove "hlist" (a rogue token)
    data.append({
                'wiki_title' : x['company_name'], 
                'product' : '|'.join(m)
                })
    products.extend(m)
    
print(products)
```

    ['electronics', 'movies and music', 'home and furniture', 'home improvement', 'clothing', 'footwear', 'jewelry', 'toys', 'health and beauty', 'pet supplies', 'sporting goods and fitness', 'auto', 'photo finishing', 'craft supplies', 'party supplies', 'grocery', 'crude oil', 'oil products', 'natural gas', 'petrochemical', 'power generation', 'investment', 'diversified investments', 'insurancetypes', 'property  casualty insurance', 'public utility', 'utilities', 'restaurants', 'food processing', 'aerospace', 'toys', 'mass media', 'media', 'automotive industry', 'automotive', 'sports equipment', 'sporting goods', 'final good', 'consumer products', 'internet', 'real estate', 'macintosh', 'ipod', 'iphone', 'ipad', 'apple watch', 'apple tv', 'homepod', 'macos', 'ios', 'ipados', 'watchos', 'tvos', 'ilife', 'iwork', 'final cut pro', 'logic pro', 'garageband', 'shazam application', 'shazam', 'siri', 'uniprise', 'health care', 'service economics', 'services', 'ingenix', 'pharmaceuticals', 'medical technology', 'health care services', 'amazon echo', 'amazon fire tablet', 'amazon fire', 'amazon fire tv', 'fire os', 'amazon fire os', 'amazon kindle', 'satellite television', 'landline', 'fixed-line telephones', 'mobile phone', 'mobile telephones', 'internet service provider', 'internet services', 'broadband', 'digital television', 'home security', 'iptv', 'over-the-top media services', 'ott services', 'network security', 'filmmaking', 'film production', 'television production', 'cable television', 'pay television', 'publishing', 'podcast', 'sports management', 'news agency', 'video game', 'car', 'automobiles', 'commercial vehicle', 'car', 'automobiles', 'luxury car', 'luxury vehicles', 'commercial vehicle', 'commercial vehicles', 'list of auto parts', 'automotive parts', 'pickup trucks', 'suvs', 'pharmaceutical', 'pharmacy', 'petroleum', 'natural gas', 'petrochemical', 'marketing brands', 'see chevron products', 'cable television', 'landline', 'mobile phone', 'broadband', 'digital television', 'iptv', 'digital media', 'internet of things', 'internet', 'telematics', 'supercenter', 'superstore', 'supermarket', 'aircraft engine', 'electric power distribution', 'electrical distribution', 'electric motor', 'energy', 'finance', 'health care', 'lighting', 'software', 'wind turbine', 'drug store', 'pharmacy', 'alternative financial service', 'american depositary receipt', 'asset allocation', 'asset management', 'bond finance', 'bond', 'broker', 'capital market', 'collateralized debt obligation', 'commercial banking', 'commodity market', 'commodities', 'commercial bank', 'credit card', 'credit default swap', 'credit derivative', 'currency exchange', 'custodian bank', 'debt settlement', 'digital banking', 'estate planning', 'exchange-traded fund', 'financial analysis', 'financial market', 'foreign exchange market', 'futures exchange', 'hedge fund', 'index fund', 'information processing', 'institutional investor', 'institutional investing', 'insurance', 'investment bank', 'financial capital', 'investment capital', 'investment management', 'portfolio finance', 'portfolios', 'loan servicing', 'merchant services', 'mobile banking', 'money market', 'mortgage brokers', 'mortgage broker', 'mortgage loan', 'mortgage-backed security', 'mortgagebacked securities', 'mutual fund', 'pension fund', 'prime brokerage', 'private banking', 'private equity', 'remittance', 'retail banking', 'broker', 'risk management', 'securities lending', 'security finance', 'security', 'stock trader', 'stock trading', 'subprime lending', 'treasury services', 'trustee', 'underwriting', 'venture capital', 'wealth management', 'wholesale funding', 'wholesale mortgage lenders', 'wholesale mortgage lending', 'wire transfer']


Now let's create a wordcloud function which will visually inform us about which products are more prominent than the others. The size of the word would indicate its frequency.


```python
def create_wordcloud(items, stopwords=[]):
    '''create the wordcloud object
    args
    items :     the items we need to display
    stopwords : a list of stopwords to filter out tokens
    ''' 
    
    text = ' '.join(items)
    wordcloud = WordCloud(width=1600, 
                          height=800, 
                          margin=0, 
                          stopwords=stopwords
                         ).generate(text) # optionally we can set max_words=20 
    
    plt.figure( figsize=(20,10)) # set the final figure size
    plt.imshow(wordcloud, interpolation="bilinear") # pass the image and set interpolation type
    plt.axis("off") # turn all axes off
    plt.tight_layout(pad=0) # no padding
    plt.show() # display plot
```

Creating wordclouds for `products`,


```python
create_wordcloud(products, ['and']) # adding "and" to the stopword list
```


![png](section-4-wrangling-and-analysis_files/section-4-wrangling-and-analysis_22_0.png)


### What type of industries do the top 20 company belong from?

Similarly, looking at a sample for `industry`,


```python
for i in range(0,5):
    print(wiki_data[i]['industry'])
```

    [[Retail]]
    [[Energy industry|Energy]]: [[Oil and gas industry|Oil and gas]]
    [[Conglomerate (company)|Conglomerate]]
    {{Unbulleted list | [[Computer hardware]] | [[Computer software]] | [[Consumer electronics]] | [[Cloud computing]] | [[Digital distribution]] | [[Fabless manufacturing|Fabless silicon design]] | [[Semiconductors]] | [[Financial technology]] | [[Artificial intelligence]]}}
    [[Managed health care]]


We can observe that we need to :
- Extract products from between `[[` and `]]`
- Split and seperate by the delimiter `|`
- Only keep alphanumeric characters, `-` and preserve spaces

We define a new regular expression as follows,


```python
regex = re.compile('[\[]+(.*?)[\]]')
```

Regex breakdown :

- `[\[]+` : matches one or more `[` 
- `(.*?)` : captures anything between the previous pattern and the next
- `[\]]` : matches ending in `]` 


Using the same to clean and extract the industries,


```python
industries = []
for i, x in enumerate(wiki_data):
    y = x['industry'] # get industries
    z = regex.findall(y) # extract industries
    z = [d.lower().split('|') for d in z] # get a list
    m = list(itertools.chain(*z)) # flatten
    data[i]['industry'] = '|'.join(m)
    industries.extend(m)

print(industries)
```

    ['retail', 'energy industry', 'energy', 'oil and gas industry', 'oil and gas', 'conglomerate (company)', 'conglomerate', 'computer hardware', 'computer software', 'consumer electronics', 'cloud computing', 'digital distribution', 'fabless manufacturing', 'fabless silicon design', 'semiconductors', 'financial technology', 'artificial intelligence', 'managed health care', 'healthcare', 'retail', 'health care', 'cloud computing', 'e-commerce', 'artificial intelligence', 'consumer electronics', 'digital distribution', 'grocery stores', 'telecommunications industry', 'telecommunications', 'technology company', 'technology', 'mass media', 'entertainment', 'automotive industry', 'automotive', 'automotive industry', 'automotive', 'pharmaceutical', 'oil and gas industry', 'oil and gas', 'pharmaceuticals', 'retail', 'telecommunications industry', 'telecommunications', 'mass media', 'retail', 'conglomerate (company)', 'conglomerate', 'pharmaceutical', 'retail', 'bank', 'financial services']


Just as before let's create a wordcloud for `industry`,


```python
create_wordcloud(industries, ['industry', 'and']) # adding "industry" and "and" to the stopword list 
```


![png](section-4-wrangling-and-analysis_files/section-4-wrangling-and-analysis_33_0.png)


### What the assets of the top 20 companies look like?

Taking a look at a sample of `assets` below,


```python
for i in range(0,len(wiki_data)):
    print(wiki_data[i]['assets'])
```

    {{increase}} {{US$|219.295 billion}} (2019)
    {{Nowrap|Decrease| |US$|346.2 billion|ref| name="201310K"}} {{Decrease}} {{US$|346.2 billion}}
    {{increase}} US$707.8 billion (2018)
    {{Decrease}} {{US$|338.516&nbsp;billion}}
    {{increase}} $173.889 billion (2019)
    {{nowrap|increase| |US$|60.381 billion| |small|(2018)|ref| name=FY}} {{increase}} {{US$|60.381 billion}} {{small|(2018)}}
    {{increase}} {{US$|196.456 billion}}
    {{decrease}} {{US$|162.648 billion}}
    {{increase}} {{US$|link|=|yes}} 531 billion     (2018)
    {{increase}} US$227.339 billion {{small|(2018)}}
    {{decrease}} {{US$|256.54 billion}} {{small|(2018)}}
    {{increase}} {{US$|37.66 billion}} (2018)
    {{decrease}} {{US$|253.9 billion}} {{small|(2018)}}
    {{increase}} US$39.95 billion {{small|(2018)}}
    {{increase}} US$45.40 billion
    {{increase}} {{US$|264.82 billion}}
    {{increase}} {{US$|38.11 billion}} (2019)
    {{nowrap|Decrease| US$ 309.129 billion |small|(2018)}} {{Decrease}} US$ 309.129 billion {{small|(2018)}}
    {{decrease}} {{US$|67.59 billion}}
    {{increase}} [[United States dollar|US$]]2.687 [[trillion]]


We would need to :
- Extract both numbers and the unit i.e. `billion` or `trillion`  
- Keep only the monetary values (discard year)

We can also observe that the asset value always appears first and then the year follows.

Defining a simple regular expression for the same,


```python
regex1 = re.compile('([\d\.]+)')
```

Regex breakdown :

- `([\d\.]+)` : matches and captures one or more numbers or `.` (for decimal).


```python
regex2 = re.compile('(billion|trillion)')
```

Regex breakdown :

- `(billion|trillion)` : matches and captures either `billion` or `trillion`


```python
assets = []
for i, x in enumerate(wiki_data):
    y = x['assets'] # get assets
    z = regex1.findall(y)[0] # extract assets
    unit = regex2.findall(y)[0] # extract the magnitude
    asset = float(z) # convert to the numeric
    data[i]['assets'] = str(asset) + ' ' + unit
    assets.append({'company' : x['company_name'], 'value' : asset, 'unit' : unit})

assets
```




    [{'company': 'Walmart', 'value': 219.295, 'unit': 'billion'},
     {'company': 'ExxonMobil', 'value': 346.2, 'unit': 'billion'},
     {'company': 'Berkshire Hathaway', 'value': 707.8, 'unit': 'billion'},
     {'company': 'Apple Inc.', 'value': 338.516, 'unit': 'billion'},
     {'company': 'UnitedHealth Group', 'value': 173.889, 'unit': 'billion'},
     {'company': 'McKesson Corporation', 'value': 60.381, 'unit': 'billion'},
     {'company': 'CVS Health', 'value': 196.456, 'unit': 'billion'},
     {'company': 'Amazon (company)', 'value': 162.648, 'unit': 'billion'},
     {'company': 'AT&T', 'value': 531.0, 'unit': 'billion'},
     {'company': 'General Motors', 'value': 227.339, 'unit': 'billion'},
     {'company': 'Ford Motor Company', 'value': 256.54, 'unit': 'billion'},
     {'company': 'AmerisourceBergen', 'value': 37.66, 'unit': 'billion'},
     {'company': 'Chevron Corporation', 'value': 253.9, 'unit': 'billion'},
     {'company': 'Cardinal Health', 'value': 39.95, 'unit': 'billion'},
     {'company': 'Costco', 'value': 45.4, 'unit': 'billion'},
     {'company': 'Verizon Communications', 'value': 264.82, 'unit': 'billion'},
     {'company': 'Kroger', 'value': 38.11, 'unit': 'billion'},
     {'company': 'General Electric', 'value': 309.129, 'unit': 'billion'},
     {'company': 'Walgreens Boots Alliance', 'value': 67.59, 'unit': 'billion'},
     {'company': 'JPMorgan Chase', 'value': 2.687, 'unit': 'trillion'}]



Since we have both `billion` as well as `trillion`, let's normalize all the values,


```python
for i, asset in enumerate(assets):
    if asset['unit'] == 'trillion': # if unit is in trillion
        assets[i]['value'] = asset['value']*1000 # convert to trillion to billion
        assets[i]['unit'] = 'billion'
```

And create a new dataframe from the same,


```python
df_assets = pd.DataFrame(assets)
df_assets.head()
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
      <th>company</th>
      <th>value</th>
      <th>unit</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Walmart</td>
      <td>219.295</td>
      <td>billion</td>
    </tr>
    <tr>
      <th>1</th>
      <td>ExxonMobil</td>
      <td>346.200</td>
      <td>billion</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Berkshire Hathaway</td>
      <td>707.800</td>
      <td>billion</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apple Inc.</td>
      <td>338.516</td>
      <td>billion</td>
    </tr>
    <tr>
      <th>4</th>
      <td>UnitedHealth Group</td>
      <td>173.889</td>
      <td>billion</td>
    </tr>
  </tbody>
</table>
</div>



Now finally let's create a bar plot showcasing the assets from all the companies,


```python
ax = df_assets.plot(kind='bar', 
               title ="Assets from the Top 20 Companies on Fortune 500", color='skyblue',
               figsize=(15, 10), 
               legend=True, 
               fontsize=12
              )

ax.set_xticklabels(df_assets.company)
ax.set_xlabel("Company Name", fontsize=12)
ax.set_ylabel("Assets (in Billions)", fontsize=12)
plt.show()
```


![png](section-4-wrangling-and-analysis_files/section-4-wrangling-and-analysis_49_0.png)


Now let's create a new dataframe containing data related to `products`, `industry` and `assets` as follows,


```python
df_wiki = pd.DataFrame(data)
df_wiki.head()
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
      <th>wiki_title</th>
      <th>product</th>
      <th>industry</th>
      <th>assets</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Walmart</td>
      <td>electronics|movies and music|home and furnitur...</td>
      <td>retail</td>
      <td>219.295 billion</td>
    </tr>
    <tr>
      <th>1</th>
      <td>ExxonMobil</td>
      <td>crude oil|oil products|natural gas|petrochemic...</td>
      <td>energy industry|energy|oil and gas industry|oi...</td>
      <td>346.2 billion</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Berkshire Hathaway</td>
      <td>investment|diversified investments|insurancety...</td>
      <td>conglomerate (company)|conglomerate</td>
      <td>707.8 billion</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apple Inc.</td>
      <td>macintosh|ipod|iphone|ipad|apple watch|apple t...</td>
      <td>computer hardware|computer software|consumer e...</td>
      <td>338.516 billion</td>
    </tr>
    <tr>
      <th>4</th>
      <td>UnitedHealth Group</td>
      <td>uniprise|health care|service economics|service...</td>
      <td>managed health care</td>
      <td>173.889 billion</td>
    </tr>
  </tbody>
</table>
</div>



And finally let's combine the datasets from Section 2 and 3 as follows,


```python
df = pd.read_csv('../data/fortune_500_companies.csv', nrows=20) # reading only the first 20 rows
df = pd.concat([df, df_wiki], axis=1) # concatenating both the datasets
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
      <th>rank</th>
      <th>company_name</th>
      <th>company_website</th>
      <th>wiki_title</th>
      <th>product</th>
      <th>industry</th>
      <th>assets</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>Walmart</td>
      <td>http://www.stock.walmart.com</td>
      <td>Walmart</td>
      <td>electronics|movies and music|home and furnitur...</td>
      <td>retail</td>
      <td>219.295 billion</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>Exxon Mobil</td>
      <td>http://www.exxonmobil.com</td>
      <td>ExxonMobil</td>
      <td>crude oil|oil products|natural gas|petrochemic...</td>
      <td>energy industry|energy|oil and gas industry|oi...</td>
      <td>346.2 billion</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>Berkshire Hathaway</td>
      <td>http://www.berkshirehathaway.com</td>
      <td>Berkshire Hathaway</td>
      <td>investment|diversified investments|insurancety...</td>
      <td>conglomerate (company)|conglomerate</td>
      <td>707.8 billion</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>Apple</td>
      <td>http://www.apple.com</td>
      <td>Apple Inc.</td>
      <td>macintosh|ipod|iphone|ipad|apple watch|apple t...</td>
      <td>computer hardware|computer software|consumer e...</td>
      <td>338.516 billion</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>UnitedHealth Group</td>
      <td>http://www.unitedhealthgroup.com</td>
      <td>UnitedHealth Group</td>
      <td>uniprise|health care|service economics|service...</td>
      <td>managed health care</td>
      <td>173.889 billion</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>McKesson</td>
      <td>http://www.mckesson.com</td>
      <td>McKesson Corporation</td>
      <td>pharmaceuticals|medical technology|health care...</td>
      <td>healthcare</td>
      <td>60.381 billion</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>CVS Health</td>
      <td>http://www.cvshealth.com</td>
      <td>CVS Health</td>
      <td></td>
      <td>retail|health care</td>
      <td>196.456 billion</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>Amazon.com</td>
      <td>http://www.amazon.com</td>
      <td>Amazon (company)</td>
      <td>amazon echo|amazon fire tablet|amazon fire|ama...</td>
      <td>cloud computing|e-commerce|artificial intellig...</td>
      <td>162.648 billion</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>AT&amp;T</td>
      <td>http://www.att.com</td>
      <td>AT&amp;T</td>
      <td>satellite television|landline|fixed-line telep...</td>
      <td>telecommunications industry|telecommunications...</td>
      <td>531.0 billion</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>General Motors</td>
      <td>http://www.gm.com</td>
      <td>General Motors</td>
      <td>car|automobiles|commercial vehicle</td>
      <td>automotive industry|automotive</td>
      <td>227.339 billion</td>
    </tr>
    <tr>
      <th>10</th>
      <td>11</td>
      <td>Ford Motor</td>
      <td>http://www.corporate.ford.com</td>
      <td>Ford Motor Company</td>
      <td>car|automobiles|luxury car|luxury vehicles|com...</td>
      <td>automotive industry|automotive</td>
      <td>256.54 billion</td>
    </tr>
    <tr>
      <th>11</th>
      <td>12</td>
      <td>AmerisourceBergen</td>
      <td>http://www.amerisourcebergen.com</td>
      <td>AmerisourceBergen</td>
      <td>pharmaceutical|pharmacy</td>
      <td>pharmaceutical</td>
      <td>37.66 billion</td>
    </tr>
    <tr>
      <th>12</th>
      <td>13</td>
      <td>Chevron</td>
      <td>http://www.chevron.com</td>
      <td>Chevron Corporation</td>
      <td>petroleum|natural gas|petrochemical|marketing ...</td>
      <td>oil and gas industry|oil and gas</td>
      <td>253.9 billion</td>
    </tr>
    <tr>
      <th>13</th>
      <td>14</td>
      <td>Cardinal Health</td>
      <td>http://www.cardinalhealth.com</td>
      <td>Cardinal Health</td>
      <td></td>
      <td>pharmaceuticals</td>
      <td>39.95 billion</td>
    </tr>
    <tr>
      <th>14</th>
      <td>15</td>
      <td>Costco</td>
      <td>http://www.costco.com</td>
      <td>Costco</td>
      <td></td>
      <td>retail</td>
      <td>45.4 billion</td>
    </tr>
    <tr>
      <th>15</th>
      <td>16</td>
      <td>Verizon</td>
      <td>http://www.verizon.com</td>
      <td>Verizon Communications</td>
      <td>cable television|landline|mobile phone|broadba...</td>
      <td>telecommunications industry|telecommunications...</td>
      <td>264.82 billion</td>
    </tr>
    <tr>
      <th>16</th>
      <td>17</td>
      <td>Kroger</td>
      <td>http://www.thekrogerco.com</td>
      <td>Kroger</td>
      <td>supercenter|superstore|supermarket</td>
      <td>retail</td>
      <td>38.11 billion</td>
    </tr>
    <tr>
      <th>17</th>
      <td>18</td>
      <td>General Electric</td>
      <td>http://www.ge.com</td>
      <td>General Electric</td>
      <td>aircraft engine|electric power distribution|el...</td>
      <td>conglomerate (company)|conglomerate</td>
      <td>309.129 billion</td>
    </tr>
    <tr>
      <th>18</th>
      <td>19</td>
      <td>Walgreens Boots Alliance</td>
      <td>http://www.walgreensbootsalliance.com</td>
      <td>Walgreens Boots Alliance</td>
      <td>drug store|pharmacy</td>
      <td>pharmaceutical|retail</td>
      <td>67.59 billion</td>
    </tr>
    <tr>
      <th>19</th>
      <td>20</td>
      <td>JPMorgan Chase</td>
      <td>http://www.jpmorganchase.com</td>
      <td>JPMorgan Chase</td>
      <td>alternative financial service|american deposit...</td>
      <td>bank|financial services</td>
      <td>2.687 trillion</td>
    </tr>
  </tbody>
</table>
</div>



And export them to a csv file,


```python
df.to_csv('../data/top_20_companies.csv', index=False)
```
