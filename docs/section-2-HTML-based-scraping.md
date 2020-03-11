
Section II. HTML based scraping (1 hour)
1. URL request and response
2. Run a simple HTTP request and explain response headers, status codes
3. GET and POST calls to retrieve response objects - using urllib2, requests, JSON etc
4. Using bs4 (and lxml) to parse the structure and access different elements within a HTML or XML
5. Manipulate it into a tabular structure - explore the schema
6. Store it in the appropriate format - CSV, TSV and export the results

## 1. URL request and response

A URL is Uniform Resource Locator. It acts as a web address to different webpages. Every URL on the internet work on a request-response basis. The browser requests the server for a webpage and the response by the server would be the content of the webpage. This web content is then displayed on the browser.

URL Request - Requesting a web server for content to be viewed by the user. This HTTP request is triggered whenever you click on a link or open a webpage.

URL Response - A response for the request irrespective of success or failure. For every request to the web server, a mandatory response is provided by the web server and most of the times this would be the respective content requested by the user.

## 2. Run a simple HTTP request and explain response headers, status codes

Instead of the browser requesting for the content of the webpage, Python can be used for the same. A HTTP request to the web server can be sent with the requests library and the response can be examined. Typically every request receives a response with response headers and status code details.

Let us request for the web content for the Monash University front webpage with the URL - https://www.monash.edu/. The requests library can be used to work with webpages and web content. A request is made to get the content of the webpage with the get() method.


```python
import requests

monash_web_url = "https://www.monash.edu/"
response = requests.get(monash_web_url)
```

A response is received from the web server. This response will have response headers and status codes associated to that particular request.
Response headers give the detailed information about the request made to the web server.


```python
response.headers
```




    {'Content-Type': 'text/html; charset=utf-8', 'Transfer-Encoding': 'chunked', 'Connection': 'keep-alive', 'Vary': 'Accept-Encoding, Accept-Encoding', 'Cache-Control': 'max-age=0, private', 'Pragma': 'cache', 'Server': 'openresty', 'X-Content-Type-Options': 'nosniff', 'X-Cache': 'HIT from squizedge.net', 'Date': 'Thu, 20 Feb 2020 02:00:15 GMT', 'Age': '61', 'Via': '1.1 squizedge.net', 'X-upgrade-enabled': 'off', 'X-Frame-Options': 'SAMEORIGIN', 'Expires': 'Thu, 20 Feb 2020 02:30:14 GMT', 'X-Request-ID': '13690024-41c9-4a17-95fb-ff6331c6d576', 'Content-Encoding': 'gzip'}



Every response will have a status code. The status codes indicate whether a specific HTTP request has been successfully completed.
Responses are grouped in five classes:

- Informational responses (100–199)
- Successful responses (200–299)
- Redirects (300–399)
- Client errors (400–499)
- Server errors (500–599)

Let us check the response status code for the HTTP request we placed


```python
response.status_code
```




    200



The response has a status code of 200. This is a successful response and hence there should be relevant content of the webpage in the obtained response. This can be checked by printing the content. This content received is the HTML source code of the webpage


```python
response.content
```







## 1. GET and POST calls to retrieve response objects - using urllib2, requests, JSON etc


There are mainly two types of requests which can be made to the web server. A GET request/call or a POST request/call.

GET call - GET is used to request data from a specified source. They are one of the most common HTTP requests. They are usually used to only receive content from the web server. An example would be to receive the content of the complete webpage.

POST call - POST is used to send data to either update details or request specific content from the web server. In a POST call, data is sent and then a response can be expected from the web server. An example would be to request content from a web server based on a particular selection from a drop-down menu. The selection option is upadted while also respective content is sent back.

Let us scrape a list of the fotune 500 compaies for the year 2018. The website from which the data is to be scraped is https://www.zyxware.com/articles/5914/list-of-fortune-500-companies-and-their-websites-2018.

![image.png](attachment:image.png)

It can be seen on this website that the list contains the rank, company name and the website of the company. The whole content of this website can be received as a response when requested with the request library in Python


```python
import requests
import pandas as pd
from bs4 import BeautifulSoup

web_url = 'https://www.zyxware.com/articles/5914/list-of-fortune-500-companies-and-their-websites-2018'
response = requests.get(web_url)

print('Status code\n', response.status_code)
print('\n--\n')
print('Content of the website\n', response.content)
```

    Status code
     200
    
    --
    
    Content of the website
     b'<!DOCTYPE html>\n<html lang="en" dir="ltr" prefix="content: http://purl.org/rss/1.0/modules/content/  dc: http://purl.org/dc/terms/  foaf: http://xmlns.com/foaf/0.1/  og: http://ogp.me/ns#  rdfs: http://www.w3.org/2000/01/rdf-schema#  schema: http://schema.org/  sioc: http://rdfs.org/sioc/ns#  sioct: http://rdfs.org/sioc/types#  skos: http://www.w3.org/2004/02/skos/core#  xsd: http://www.w3.org/2001/XMLSchema# ">\n  <head>\n    <meta charset="utf-8" />\n<script>dataLayer = [];dataLayer.push({"tag": "5914"});</script>\n<script>window.dataLayer = window.dataLayer || []; window.dataLayer.push({"drupalLanguage":"en","drupalCountry":"IN","siteName":"Zyxware Technologies","entityCreated":"1562300185","entityLangcode":"en","entityStatus":"1","entityUid":"1","entityUuid":"6fdfb477-ce5d-4081-9010-3afd9260cdf7","entityVid":"15541","entityName":"webmaster","entityType":"node","entityBundle":"story","entityId":"5914","entityTitle":"List of Fortune 500 companies and their websites (2018)","entityTaxonomy":{"vocabulary_2":"Misc,Lists"},"userUid":0});</script>\n<script async src="https://www.googletagmanager.com/gtag/js?id=UA-1488254-2"></script>\n<script>window.google_analytics_uacct = "UA-1488254-2";window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments)};gtag("js", new Date());window[\'GoogleAnalyticsObject\'] = \'ga\';\r\n  window[\'ga\'] = window[\'ga\'] || function() {\r\n    (window[\'ga\'].q = window[\'ga\'].q || []).push(arguments)\r\n  };\r\nga("set", "dimension2", window.analytics_manager_node_age);\r\nga("set", "dimension3", window.analytics_manager_node_author);gtag("config", "UA-1488254-2", {"groups":"default","anonymize_ip":true,"page_path":location.pathname + location.search + location.hash,"link_attribution":true,"allow_ad_personalization_signals":false});</script>\n<meta name="title" content="List of Fortune 500 companies and their websites (2018) | Zyxware Technologies" />\n<link rel="canonical" href="https://www.zyxware.com/articles/5914/list-of-fortune-500-companies-and-their-websites-2018" />\n<meta name="description" content="Fortune magazine publishes a list of the largest companies in the US by revenue every year. Here is the list of fortune 500 companies for the year 2018 and their websites. Check out the current list of fortune 500 companies and their websites." />\n<meta name="Generator" content="Drupal 8 (https://www.drupal.org)" />\n<meta name="MobileOptimized" content="width" />\n<meta name="HandheldFriendly" content="true" />\n<meta name="viewport" content="width=device-width, initial-scale=1.0" />\n<style>div#sliding-popup, div#sliding-popup .eu-cookie-withdraw-banner, .eu-cookie-withdraw-tab {background: #733ec0} div#sliding-popup.eu-cookie-withdraw-wrapper { background: transparent; } #sliding-popup h1, #sliding-popup h2, #sliding-popup h3, #sliding-popup p, #sliding-popup label, #sliding-popup div, .eu-cookie-compliance-more-button, .eu-cookie-compliance-secondary-button, .eu-cookie-withdraw-tab { color: #ffffff;} .eu-cookie-withdraw-tab { border-color: #ffffff;}</style>\n<script src="https://www.google.com/recaptcha/api.js?hl=en" async defer></script>\n<link rel="shortcut icon" href="/themes/custom/zyxpro_light/favicon.ico" type="image/vnd.microsoft.icon" />\n<link rel="revision" href="https://www.zyxware.com/articles/5914/list-of-fortune-500-companies-and-their-websites-2018" />\n<script src="/sites/default/files/google_tag/google_tag.script.js?q5ykxj"></script>\n<script>window.a2a_config=window.a2a_config||{};a2a_config.callbacks=[];a2a_config.overlays=[];a2a_config.templates={};</script>\n\n    <title>List of Fortune 500 companies and their websites (2018) | Zyxware Technologies</title>\n    <link rel="stylesheet" media="all" href="/sites/default/files/css/css_20KuxgA9EGPA1Yt5CdQmKTq6xZJpEUDALYwFLBKAYns.css?q5ykxj" />\n<link rel="stylesheet" media="all" href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500,600,700" />\n<link rel="stylesheet" media="all" href="https://fonts.googleapis.com/icon?family=Material+Icons" />\n<link rel="stylesheet" media="all" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />\n<link rel="stylesheet" media="all" href="/sites/default/files/css/css_MBYDfcLceuf-_EyhJv5KkIoqYyE187izQMjN3XdP_0g.css?q5ykxj" />\n\n    \n<!--[if lte IE 8]>\n<script src="/sites/default/files/js/js_VtafjXmRvoUgAzqzYTA3Wrjkx9wcWhjP0G4ZnnqRamA.js"></script>\n<![endif]-->\n<script src="/core/assets/vendor/modernizr/modernizr.min.js?v=3.3.1"></script>\n\n    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>\n  </head>\n  <body class="path-node page-node-type-story articles/5914/list-of-fortune-500-companies-and-their-websites-2018 page-node-5914" >\n        <a href="#main-content" class="visually-hidden focusable">\n      Skip to main content\n    </a>\n    <noscript aria-hidden="true"><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WVXBWZC" height="0" width="0" title="Google Tag Manager"></iframe></noscript>\n      <div class="dialog-off-canvas-main-canvas" data-off-canvas-main-canvas>\n                      <header class="region-header" role="heading">\n          <div class="sticky-head-wrap" >\n              <div class="region--header">\n    <div class="block--id-system-branding-block">\n      <a href="/" title="Home" rel="home">\n      <img src="/themes/custom/zyxpro_light/logo.png" alt="Home" />\n    </a>\n      \n</div>\n\n<div id="block-mainmenuglobal" class="block block--label- block--id-we-megamenu-blockmenu-main-menu-india">\n      \n        \n          <div class="region-we-mega-menu">\n\t<a class="navbar-toggle collapsed">\n\t    <span class="icon-bar"></span>\n\t    <span class="icon-bar"></span>\n\t    <span class="icon-bar"></span>\n\t</a>\n\t<nav  class="menu-main-menu-india navbar navbar-default navbar-we-mega-menu mobile-collapse hover-action" data-menu-name="menu-main-menu-india" data-block-theme="zyxpro_light" data-style="Default" data-animation="None" data-delay="" data-duration="" data-autoarrow="" data-alwayshowsubmenu="" data-action="hover" data-mobile-collapse="0">\n\t  <div class="container-fluid">\n\t    <ul  class="we-mega-menu-ul nav nav-tabs">\n  <li  class="we-mega-menu-li" data-level="0" data-element-type="we-mega-menu-li" description="" data-id="3159c112-2cbb-4015-b128-1604efe0bc82" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/" target="">\n      \n      Home\n\n          </a>\n    \n</li><li  class="we-mega-menu-li dropdown-menu" data-level="0" data-element-type="we-mega-menu-li" description="" data-id="72048f4a-e136-4785-b804-9e73f3aca35c" data-submenu="1" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <span data-drupal-link-system-path="<front>" class="we-megamenu-nolink">Services</span>\n    <div  class="we-mega-menu-submenu" data-element-type="we-mega-menu-submenu" data-submenu-width="700" data-class="" style="width: 700px">\n  <div class="we-mega-menu-submenu-inner">\n    <div  class="we-mega-menu-row" data-element-type="we-mega-menu-row" data-custom-row="0">\n  <div  class="we-mega-menu-col span4" data-element-type="we-mega-menu-col" data-width="4" data-block="" data-blocktitle="0" data-hidewhencollapse="" data-class="">\n  <ul class="nav nav-tabs subul">\n  <li  class="we-mega-menu-li title-submenu" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="434df207-f18e-48ba-ad47-44c2ddcc6c8c" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="title-submenu" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <span data-drupal-link-system-path="<front>" class="we-megamenu-nolink">Platform Engineering </span>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="bf754a9f-5822-4f02-9d3c-ae419db5a0e5" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/services/engineering-services" target="">\n      \n      Application Development Services\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="91f48b0f-fb07-43af-8f4d-d832176c3edd" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/services/ux-design" target="">\n      \n      Design Services\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="0da0f462-edcb-427c-afdc-50fa905e71db" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/services/qualityassurance" target="">\n      \n      Quality Assurance Services\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="a19aed2a-cbcb-4eb9-9a3a-92d7c914b695" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/managed-services" target="">\n      \n      Managed Services\n\n          </a>\n    \n</li>\n</ul>\n</div>\n<div  class="we-mega-menu-col span4" data-element-type="we-mega-menu-col" data-width="4" data-block="" data-blocktitle="1" data-hidewhencollapse="" data-class="">\n  <ul class="nav nav-tabs subul">\n  <li  class="we-mega-menu-li title-submenu" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="6135c31c-4cf9-46d0-9c40-ca95a6739f7f" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="title-submenu" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <span data-drupal-link-system-path="<front>" class="we-megamenu-nolink">Consulting Services</span>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="5f35b9eb-72dc-43d0-8bc2-c728204c497a" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/digital-business-strategy" target="">\n      \n      Digital Business Strategy\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="48b44987-b00b-47eb-a64f-780265272633" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/automation-consulting" target="">\n      \n      Automation Consulting\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="413cacb4-cb6d-4b1d-b628-601d72f1f61f" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/technology-consulting" target="">\n      \n      Technology Consulting\n\n          </a>\n    \n</li>\n</ul>\n</div>\n<div  class="we-mega-menu-col span4" data-element-type="we-mega-menu-col" data-width="4" data-block="" data-blocktitle="1" data-hidewhencollapse="" data-class="">\n  <ul class="nav nav-tabs subul">\n  <li  class="we-mega-menu-li title-submenu" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="24a24f47-0e08-4940-a842-783d91455759" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="title-submenu" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <span data-drupal-link-system-path="<front>" class="we-megamenu-nolink">Impact Services</span>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="a594f1b4-8969-459b-ac7e-d9ee6325fc12" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/services/marketing" target="">\n      \n      Marketing Operations\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="f204b532-7f7d-4765-91a6-c648969df282" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/conversion-optimisation" target="">\n      \n      Conversion Optimization\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="20447454-90f9-4ed1-8c98-a4e21584d79a" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/digital-engagement" target="">\n      \n      Digital Engagement\n\n          </a>\n    \n</li>\n</ul>\n</div>\n\n</div>\n\n  </div>\n</div>\n</li><li  class="we-mega-menu-li dropdown-menu" data-level="0" data-element-type="we-mega-menu-li" description="" data-id="f7e93f29-438b-4885-8b70-b6356be8da1a" data-submenu="1" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <span data-drupal-link-system-path="<front>" class="we-megamenu-nolink">Verticals</span>\n    <div  class="we-mega-menu-submenu" data-element-type="we-mega-menu-submenu" data-submenu-width="" data-class="" style="width: px">\n  <div class="we-mega-menu-submenu-inner">\n    <div  class="we-mega-menu-row" data-element-type="we-mega-menu-row" data-custom-row="0">\n  <div  class="we-mega-menu-col span12" data-element-type="we-mega-menu-col" data-width="12" data-block="" data-blocktitle="0" data-hidewhencollapse="" data-class="">\n  <ul class="nav nav-tabs subul">\n  <li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="0e7a2ab2-cb34-4a73-b572-e64e5cee0299" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/verticals/public-sector" target="">\n      \n      Public Services\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="f7167409-81d9-4bde-a11b-384930e93eda" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/verticals/media" target="">\n      \n      Media\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="86ce2d77-eec3-4abd-bc64-bcf76d758563" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/verticals/education" target="">\n      \n      Education\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="21225a9c-49ae-48bf-8c53-a167ad1d4b39" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/verticals/retail" target="">\n      \n      Retail\n\n          </a>\n    \n</li>\n</ul>\n</div>\n\n</div>\n\n  </div>\n</div>\n</li><li  class="we-mega-menu-li dropdown-menu" data-level="0" data-element-type="we-mega-menu-li" description="" data-id="91b2ccc9-3dc9-4945-a24d-1e490f218ad7" data-submenu="1" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <span data-drupal-link-system-path="<front>" class="we-megamenu-nolink">Technologies</span>\n    <div  class="we-mega-menu-submenu" data-element-type="we-mega-menu-submenu" data-submenu-width="" data-class="" style="width: px">\n  <div class="we-mega-menu-submenu-inner">\n    <div  class="we-mega-menu-row" data-element-type="we-mega-menu-row" data-custom-row="0">\n  <div  class="we-mega-menu-col span12" data-element-type="we-mega-menu-col" data-width="12" data-block="" data-blocktitle="0" data-hidewhencollapse="" data-class="">\n  <ul class="nav nav-tabs subul">\n  <li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="006ed138-3803-4c96-af8a-ec05c734c42f" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/drupal-solutions/web-development-services" target="">\n      \n      Drupal\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="dcbe2554-3336-4f02-86b4-5d28cc553a71" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/technologies/govcms" target="">\n      \n      GovCMS\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="1" data-element-type="we-mega-menu-li" description="" data-id="9e9d8249-2f80-4aed-bdc0-bbdbdddf424f" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/magento-services" target="">\n      \n      Magento\n\n          </a>\n    \n</li>\n</ul>\n</div>\n\n</div>\n\n  </div>\n</div>\n</li><li  class="we-mega-menu-li" data-level="0" data-element-type="we-mega-menu-li" description="" data-id="8fdc4447-6a47-434f-80ee-7010f8a44145" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/articles" target="">\n      \n      Articles\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="0" data-element-type="we-mega-menu-li" description="" data-id="729d26b9-defa-46a8-bbea-7f5d5c434b6f" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/about" target="">\n      \n      About\n\n          </a>\n    \n</li><li  class="we-mega-menu-li" data-level="0" data-element-type="we-mega-menu-li" description="" data-id="2c77eb5d-1be5-4062-8350-e613bf76e7f2" data-submenu="0" hide-sub-when-collapse="" data-group="0" data-class="" data-icon="" data-caption="" data-alignsub="" data-target="">\n      <a class="we-mega-menu-li" title="" href="/contact-us" target="">\n      \n      Contact\n\n          </a>\n    \n</li>\n</ul>\n\t  </div>\n\t</nav>\n</div>\n      </div>\n\n<div id="block-getintouch" class="block block--label- block--id-block-content7ebe1c89-6fa0-4d07-995d-ebbeeb642048 block--type-basic">\n      \n        \n          \n            <div class="field field--body"><p><a class="getin-touch-btn" href="/contact-us">Get in touch</a></p>\n</div>\n      \n      </div>\n\n  </div>\n\n            <button type="button" class="sidebar-toggler hide-on-large-only-modified" onclick="toggleFixedSidebar();return false;">\n              <span class="icon-bar" ></span>\n              <span class="icon-bar" ></span>\n              <span class="icon-bar" ></span>\n            </button>\n          </div>\n        </header>\n          \n\n  <div role="main" class="main-container  js-quickedit-main-content">\n    <div class="clearfix">\n            \n                <div class="region--breadcrumb">\n    \n<div id="block-zyxpro-light-breadcrumbs" class="block block--label- block--id-system-breadcrumb-block">\n      \n        \n            <nav role="navigation" class="breadcrump-wrap" aria-labelledby="system-breadcrumb">\n    <h2 id="system-breadcrumb" class="visually-hidden">Breadcrumb</h2>\n    <ul class="list-inline container">\n              <li class="hidden-xs">\n                  <a href="/">Home</a>\n                        </li>\n      <li class="seperator hidden-xs">|</li>\n          <li class="hidden-xs">\n                  <a href="/categories/misc">Misc</a>\n                        </li>\n      <li class="seperator hidden-xs">|</li>\n        <li class="hidden-xs current-page-title">List of Fortune 500 companies and their websites (2018)</li>\n          <li class="visible-xs" style=""><a onclick="goBack()" > <span style="position: relative;display: inline-block;top: 0px;"><</span> Back</a></li>\n        </ul>\n  </nav>\n\n      </div>\n\n  </div>\n\n      \n                <div class="region--content-top">\n    \n<div id="block-nodeheader" class="block block--label- block--id-node-header">\n      \n        \n          <div class="node_title_rendered">List of Fortune 500 companies and their websites (2018)</div><div class="node_header"><div class="userimg"><img class="circle personpic responsive-img" src="https://www.zyxware.com/sites/default/files/styles/user_image/public/pictures/zyxlogo.png?itok=J9t-ZEoU" alt="https://www.zyxware.com/sites/default/files/styles/user_image/public/pictures/zyxlogo.png?itok=J9t-ZEoU"> <div class="username"> BY webmaster <div class="time">7 months ago</div></div></div><div class="tags"><div class="tag">Misc</div></div><div class="comments"><div class="comment">0 comments <i class="small material-icons">comment</i></div></div><div class="shares"><div class="share">0 shares <i class="small material-icons">shares</i></div></div></div>\n      </div>\n\n  </div>\n\n      \n            \n                  <div class="content-full">\n        <section class="col l9 m12 s12">\n\n                                              <div class="highlighted">  <div class="region--highlighted">\n    <div data-drupal-messages-fallback class="hidden"></div>\n\n  </div>\n</div>\n                      \n                    \n\n                                <a id="main-content"></a>\n              <div class="region--content">\n    \n            <div id="block-zyxpro-light-zyxware-drift-system-main" class="block block--label- block--id-system-main-block">\n          \n            \n                              \n<article data-history-node-id="5914" role="article" about="/articles/5914/list-of-fortune-500-companies-and-their-websites-2018" class="story is-promoted full clearfix node-article">\n\n  \n    \n\n  \n  <div class="content">\n    \n    <div class="zyxpro-casestudy-article-image">\n        \n    </div>\n    <div class="zyxpro-casestudy-article-body">\n        \n            <div class="field field--body"><p>Fortune magazine publishes a list of the largest companies in the US by revenue every year. Here is the list of fortune 500 companies for the year 2018 and their websites. Check out the <a href="/articles/4344/list-of-fortune-500-companies-and-their-websites">current list of fortune 500 companies</a> and their websites. <!--break--></p>\n<!--break-->\n\n<table class="data-table"><thead><tr><th>Rank</th>\n\t\t\t<th>Company</th>\n\t\t\t<th>Website</th>\n\t\t</tr></thead><tbody><tr><td>1</td>\n\t\t\t<td>Walmart</td>\n\t\t\t<td><a href="http://www.stock.walmart.com">http://www.stock.walmart.com</a></td>\n\t\t</tr><tr><td>2</td>\n\t\t\t<td>Exxon Mobil</td>\n\t\t\t<td><a href="http://www.exxonmobil.com">http://www.exxonmobil.com</a></td>\n\t\t</tr><tr><td>3</td>\n\t\t\t<td>Berkshire Hathaway</td>\n\t\t\t<td><a href="http://www.berkshirehathaway.com">http://www.berkshirehathaway.com</a></td>\n\t\t</tr><tr><td>4</td>\n\t\t\t<td>Apple</td>\n\t\t\t<td><a href="http://www.apple.com">http://www.apple.com</a></td>\n\t\t</tr><tr><td>5</td>\n\t\t\t<td>UnitedHealth Group</td>\n\t\t\t<td><a href="http://www.unitedhealthgroup.com">http://www.unitedhealthgroup.com</a></td>\n\t\t</tr><tr><td>6</td>\n\t\t\t<td>McKesson</td>\n\t\t\t<td><a href="http://www.mckesson.com">http://www.mckesson.com</a></td>\n\t\t</tr><tr><td>7</td>\n\t\t\t<td>CVS Health</td>\n\t\t\t<td><a href="http://www.cvshealth.com">http://www.cvshealth.com</a></td>\n\t\t</tr><tr><td>8</td>\n\t\t\t<td>Amazon.com</td>\n\t\t\t<td><a href="http://www.amazon.com">http://www.amazon.com</a></td>\n\t\t</tr><tr><td>9</td>\n\t\t\t<td>AT&amp;T</td>\n\t\t\t<td><a href="http://www.att.com">http://www.att.com</a></td>\n\t\t</tr><tr><td>10</td>\n\t\t\t<td>General Motors</td>\n\t\t\t<td><a href="http://www.gm.com">http://www.gm.com</a></td>\n\t\t</tr><tr><td>11</td>\n\t\t\t<td>Ford Motor</td>\n\t\t\t<td><a href="http://www.corporate.ford.com">http://www.corporate.ford.com</a></td>\n\t\t</tr><tr><td>12</td>\n\t\t\t<td>AmerisourceBergen</td>\n\t\t\t<td><a href="http://www.amerisourcebergen.com">http://www.amerisourcebergen.com</a></td>\n\t\t</tr><tr><td>13</td>\n\t\t\t<td>Chevron</td>\n\t\t\t<td><a href="http://www.chevron.com">http://www.chevron.com</a></td>\n\t\t</tr><tr><td>14</td>\n\t\t\t<td>Cardinal Health</td>\n\t\t\t<td><a href="http://www.cardinalhealth.com">http://www.cardinalhealth.com</a></td>\n\t\t</tr><tr><td>15</td>\n\t\t\t<td>Costco</td>\n\t\t\t<td><a href="http://www.costco.com">http://www.costco.com</a></td>\n\t\t</tr><tr><td>16</td>\n\t\t\t<td>Verizon</td>\n\t\t\t<td><a href="http://www.verizon.com">http://www.verizon.com</a></td>\n\t\t</tr><tr><td>17</td>\n\t\t\t<td>Kroger</td>\n\t\t\t<td><a href="http://www.thekrogerco.com">http://www.thekrogerco.com</a></td>\n\t\t</tr><tr><td>18</td>\n\t\t\t<td>General Electric</td>\n\t\t\t<td><a href="http://www.ge.com">http://www.ge.com</a></td>\n\t\t</tr><tr><td>19</td>\n\t\t\t<td>Walgreens Boots Alliance</td>\n\t\t\t<td><a href="http://www.walgreensbootsalliance.com">http://www.walgreensbootsalliance.com</a></td>\n\t\t</tr><tr><td>20</td>\n\t\t\t<td>JPMorgan Chase</td>\n\t\t\t<td><a href="http://www.jpmorganchase.com">http://www.jpmorganchase.com</a></td>\n\t\t</tr><tr><td>21</td>\n\t\t\t<td>Fannie Mae</td>\n\t\t\t<td><a href="http://www.fanniemae.com">http://www.fanniemae.com</a></td>\n\t\t</tr><tr><td>22</td>\n\t\t\t<td>Alphabet</td>\n\t\t\t<td><a href="http://www.abc.xyz">http://www.abc.xyz</a></td>\n\t\t</tr><tr><td>23</td>\n\t\t\t<td>Home Depot</td>\n\t\t\t<td><a href="http://www.homedepot.com">http://www.homedepot.com</a></td>\n\t\t</tr><tr><td>24</td>\n\t\t\t<td>Bank of America Corp.</td>\n\t\t\t<td><a href="http://www.bankofamerica.com">http://www.bankofamerica.com</a></td>\n\t\t</tr><tr><td>25</td>\n\t\t\t<td>Express Scripts Holding</td>\n\t\t\t<td><a href="http://www.express-scripts.com">http://www.express-scripts.com</a></td>\n\t\t</tr><tr><td>26</td>\n\t\t\t<td>Wells Fargo</td>\n\t\t\t<td><a href="http://www.wellsfargo.com">http://www.wellsfargo.com</a></td>\n\t\t</tr><tr><td>27</td>\n\t\t\t<td>Boeing</td>\n\t\t\t<td><a href="http://www.boeing.com">http://www.boeing.com</a></td>\n\t\t</tr><tr><td>28</td>\n\t\t\t<td>Phillips</td>\n\t\t\t<td><a href="http://www.phillips66.com">http://www.phillips66.com</a></td>\n\t\t</tr><tr><td>29</td>\n\t\t\t<td>Anthem</td>\n\t\t\t<td><a href="http://www.antheminc.com">http://www.antheminc.com</a></td>\n\t\t</tr><tr><td>30</td>\n\t\t\t<td>Microsoft</td>\n\t\t\t<td><a href="http://www.microsoft.com">http://www.microsoft.com</a></td>\n\t\t</tr><tr><td>31</td>\n\t\t\t<td>Valero Energy</td>\n\t\t\t<td><a href="http://www.valero.com">http://www.valero.com</a></td>\n\t\t</tr><tr><td>32</td>\n\t\t\t<td>Citigroup</td>\n\t\t\t<td><a href="http://www.citigroup.com">http://www.citigroup.com</a></td>\n\t\t</tr><tr><td>33</td>\n\t\t\t<td>Comcast</td>\n\t\t\t<td><a href="http://www.comcastcorporation.com">http://www.comcastcorporation.com</a></td>\n\t\t</tr><tr><td>34</td>\n\t\t\t<td>IBM</td>\n\t\t\t<td><a href="http://www.ibm.com">http://www.ibm.com</a></td>\n\t\t</tr><tr><td>35</td>\n\t\t\t<td>Dell Technologies</td>\n\t\t\t<td><a href="http://www.delltechnologies.com">http://www.delltechnologies.com</a></td>\n\t\t</tr><tr><td>36</td>\n\t\t\t<td>State Farm Insurance Cos.</td>\n\t\t\t<td><a href="http://www.statefarm.com">http://www.statefarm.com</a></td>\n\t\t</tr><tr><td>37</td>\n\t\t\t<td>Johnson &amp; Johnson</td>\n\t\t\t<td><a href="http://www.jnj.com">http://www.jnj.com</a></td>\n\t\t</tr><tr><td>38</td>\n\t\t\t<td>Freddie Mac</td>\n\t\t\t<td><a href="http://www.freddiemac.com">http://www.freddiemac.com</a></td>\n\t\t</tr><tr><td>39</td>\n\t\t\t<td>Target</td>\n\t\t\t<td><a href="http://www.target.com">http://www.target.com</a></td>\n\t\t</tr><tr><td>40</td>\n\t\t\t<td>Lowe\xe2\x80\x99s</td>\n\t\t\t<td><a href="http://www.lowes.com">http://www.lowes.com</a></td>\n\t\t</tr><tr><td>41</td>\n\t\t\t<td>Marathon Petroleum</td>\n\t\t\t<td><a href="http://www.marathonpetroleum.com">http://www.marathonpetroleum.com</a></td>\n\t\t</tr><tr><td>42</td>\n\t\t\t<td>Procter &amp; Gamble</td>\n\t\t\t<td><a href="http://www.pg.com">http://www.pg.com</a></td>\n\t\t</tr><tr><td>43</td>\n\t\t\t<td>MetLife</td>\n\t\t\t<td><a href="http://www.metlife.com">http://www.metlife.com</a></td>\n\t\t</tr><tr><td>44</td>\n\t\t\t<td>UPS</td>\n\t\t\t<td><a href="http://www.ups.com">http://www.ups.com</a></td>\n\t\t</tr><tr><td>45</td>\n\t\t\t<td>PepsiCo</td>\n\t\t\t<td><a href="http://www.pepsico.com">http://www.pepsico.com</a></td>\n\t\t</tr><tr><td>46</td>\n\t\t\t<td>Intel</td>\n\t\t\t<td><a href="http://www.intel.com">http://www.intel.com</a></td>\n\t\t</tr><tr><td>47</td>\n\t\t\t<td>DowDuPont</td>\n\t\t\t<td><a href="www.dow-dupont.com">www.dow-dupont.com</a></td>\n\t\t</tr><tr><td>48</td>\n\t\t\t<td>Archer Daniels Midland</td>\n\t\t\t<td><a href="http://www.adm.com">http://www.adm.com</a></td>\n\t\t</tr><tr><td>49</td>\n\t\t\t<td>Aetna</td>\n\t\t\t<td><a href="http://www.aetna.com">http://www.aetna.com</a></td>\n\t\t</tr><tr><td>50</td>\n\t\t\t<td>FedEx</td>\n\t\t\t<td><a href="http://www.fedex.com">http://www.fedex.com</a></td>\n\t\t</tr><tr><td>51</td>\n\t\t\t<td>United Technologies</td>\n\t\t\t<td><a href="http://www.utc.com">http://www.utc.com</a></td>\n\t\t</tr><tr><td>52</td>\n\t\t\t<td>Prudential Financial</td>\n\t\t\t<td><a href="http://www.prudential.com">http://www.prudential.com</a></td>\n\t\t</tr><tr><td>53</td>\n\t\t\t<td>Albertsons Cos.</td>\n\t\t\t<td><a href="http://www.albertsons.com">http://www.albertsons.com</a></td>\n\t\t</tr><tr><td>54</td>\n\t\t\t<td>Sysco</td>\n\t\t\t<td><a href="http://www.sysco.com">http://www.sysco.com</a></td>\n\t\t</tr><tr><td>55</td>\n\t\t\t<td>Disney</td>\n\t\t\t<td><a href="http://www.disney.com">http://www.disney.com</a></td>\n\t\t</tr><tr><td>56</td>\n\t\t\t<td>Humana</td>\n\t\t\t<td><a href="http://www.humana.com">http://www.humana.com</a></td>\n\t\t</tr><tr><td>57</td>\n\t\t\t<td>Pfizer</td>\n\t\t\t<td><a href="http://www.pfizer.com">http://www.pfizer.com</a></td>\n\t\t</tr><tr><td>58</td>\n\t\t\t<td>HP</td>\n\t\t\t<td><a href="http://www.hp.com">http://www.hp.com</a></td>\n\t\t</tr><tr><td>59</td>\n\t\t\t<td>Lockheed Martin</td>\n\t\t\t<td><a href="http://www.lockheedmartin.com">http://www.lockheedmartin.com</a></td>\n\t\t</tr><tr><td>60</td>\n\t\t\t<td>AIG</td>\n\t\t\t<td><a href="http://www.aig.com">http://www.aig.com</a></td>\n\t\t</tr><tr><td>61</td>\n\t\t\t<td>Centene</td>\n\t\t\t<td><a href="http://www.centene.com">http://www.centene.com</a></td>\n\t\t</tr><tr><td>62</td>\n\t\t\t<td>Cisco Systems</td>\n\t\t\t<td><a href="http://www.cisco.com">http://www.cisco.com</a></td>\n\t\t</tr><tr><td>63</td>\n\t\t\t<td>HCA Healthcare</td>\n\t\t\t<td><a href="www.hcahealthcare.com">www.hcahealthcare.com</a></td>\n\t\t</tr><tr><td>64</td>\n\t\t\t<td>Energy Transfer Equity</td>\n\t\t\t<td><a href="http://www.energytransfer.com">http://www.energytransfer.com</a></td>\n\t\t</tr><tr><td>65</td>\n\t\t\t<td>Caterpillar</td>\n\t\t\t<td><a href="http://www.caterpillar.com">http://www.caterpillar.com</a></td>\n\t\t</tr><tr><td>66</td>\n\t\t\t<td>Nationwide</td>\n\t\t\t<td><a href="http://www.nationwide.com">http://www.nationwide.com</a></td>\n\t\t</tr><tr><td>67</td>\n\t\t\t<td>Morgan Stanley</td>\n\t\t\t<td><a href="http://www.morganstanley.com">http://www.morganstanley.com</a></td>\n\t\t</tr><tr><td>68</td>\n\t\t\t<td>Liberty Mutual Insurance Group</td>\n\t\t\t<td><a href="http://www.libertymutual.com">http://www.libertymutual.com</a></td>\n\t\t</tr><tr><td>69</td>\n\t\t\t<td>New York Life Insurance</td>\n\t\t\t<td><a href="http://www.newyorklife.com">http://www.newyorklife.com</a></td>\n\t\t</tr><tr><td>70</td>\n\t\t\t<td>Goldman Sachs Group</td>\n\t\t\t<td><a href="http://www.gs.com">http://www.gs.com</a></td>\n\t\t</tr><tr><td>71</td>\n\t\t\t<td>American Airlines Group</td>\n\t\t\t<td><a href="http://www.aa.com">http://www.aa.com</a></td>\n\t\t</tr><tr><td>72</td>\n\t\t\t<td>Best Buy</td>\n\t\t\t<td><a href="http://www.bestbuy.com">http://www.bestbuy.com</a></td>\n\t\t</tr><tr><td>73</td>\n\t\t\t<td>Cigna</td>\n\t\t\t<td><a href="http://www.cigna.com">http://www.cigna.com</a></td>\n\t\t</tr><tr><td>74</td>\n\t\t\t<td>Charter Communications</td>\n\t\t\t<td><a href="http://www.charter.com">http://www.charter.com</a></td>\n\t\t</tr><tr><td>75</td>\n\t\t\t<td>Delta Air Lines</td>\n\t\t\t<td><a href="http://www.delta.com">http://www.delta.com</a></td>\n\t\t</tr><tr><td>76</td>\n\t\t\t<td>Facebook</td>\n\t\t\t<td><a href="http://www.facebook.com">http://www.facebook.com</a></td>\n\t\t</tr><tr><td>77</td>\n\t\t\t<td>Honeywell International</td>\n\t\t\t<td><a href="http://www.honeywell.com">http://www.honeywell.com</a></td>\n\t\t</tr><tr><td>78</td>\n\t\t\t<td>Merck</td>\n\t\t\t<td><a href="http://www.merck.com">http://www.merck.com</a></td>\n\t\t</tr><tr><td>79</td>\n\t\t\t<td>Allstate</td>\n\t\t\t<td><a href="http://www.allstate.com">http://www.allstate.com</a></td>\n\t\t</tr><tr><td>80</td>\n\t\t\t<td>Tyson Foods</td>\n\t\t\t<td><a href="http://www.tysonfoods.com">http://www.tysonfoods.com</a></td>\n\t\t</tr><tr><td>81</td>\n\t\t\t<td>United Continental Holdings</td>\n\t\t\t<td><a href="http://www.united.com">http://www.united.com</a></td>\n\t\t</tr><tr><td>82</td>\n\t\t\t<td>Oracle</td>\n\t\t\t<td><a href="http://www.oracle.com">http://www.oracle.com</a></td>\n\t\t</tr><tr><td>83</td>\n\t\t\t<td>Tech Data</td>\n\t\t\t<td><a href="http://www.techdata.com">http://www.techdata.com</a></td>\n\t\t</tr><tr><td>84</td>\n\t\t\t<td>TIAA</td>\n\t\t\t<td><a href="http://www.tiaa.org">http://www.tiaa.org</a></td>\n\t\t</tr><tr><td>85</td>\n\t\t\t<td>TJX</td>\n\t\t\t<td><a href="http://www.tjx.com">http://www.tjx.com</a></td>\n\t\t</tr><tr><td>86</td>\n\t\t\t<td>American Express</td>\n\t\t\t<td><a href="http://www.americanexpress.com">http://www.americanexpress.com</a></td>\n\t\t</tr><tr><td>87</td>\n\t\t\t<td>Coca-Cola</td>\n\t\t\t<td><a href="http://www.coca-colacompany.com">http://www.coca-colacompany.com</a></td>\n\t\t</tr><tr><td>88</td>\n\t\t\t<td>Publix Super Markets</td>\n\t\t\t<td><a href="http://www.publix.com">http://www.publix.com</a></td>\n\t\t</tr><tr><td>89</td>\n\t\t\t<td>Nike</td>\n\t\t\t<td><a href="http://www.nike.com">http://www.nike.com</a></td>\n\t\t</tr><tr><td>90</td>\n\t\t\t<td>Andeavor</td>\n\t\t\t<td><a href="www.andeavor.com">www.andeavor.com</a></td>\n\t\t</tr><tr><td>91</td>\n\t\t\t<td>World Fuel Services</td>\n\t\t\t<td><a href="http://www.wfscorp.com">http://www.wfscorp.com</a></td>\n\t\t</tr><tr><td>92</td>\n\t\t\t<td>Exelon</td>\n\t\t\t<td><a href="http://www.exeloncorp.com">http://www.exeloncorp.com</a></td>\n\t\t</tr><tr><td>93</td>\n\t\t\t<td>Massachusetts Mutual Life Insurance</td>\n\t\t\t<td><a href="http://www.massmutual.com">http://www.massmutual.com</a></td>\n\t\t</tr><tr><td>94</td>\n\t\t\t<td>Rite Aid</td>\n\t\t\t<td><a href="http://www.riteaid.com">http://www.riteaid.com</a></td>\n\t\t</tr><tr><td>95</td>\n\t\t\t<td>ConocoPhillips</td>\n\t\t\t<td><a href="http://www.conocophillips.com">http://www.conocophillips.com</a></td>\n\t\t</tr><tr><td>96</td>\n\t\t\t<td>CHS</td>\n\t\t\t<td><a href="http://www.chsinc.com">http://www.chsinc.com</a></td>\n\t\t</tr><tr><td>97</td>\n\t\t\t<td>M</td>\n\t\t\t<td><a href="http://www.3m.com">http://www.3m.com</a></td>\n\t\t</tr><tr><td>98</td>\n\t\t\t<td>Time Warner</td>\n\t\t\t<td><a href="http://www.timewarner.com">http://www.timewarner.com</a></td>\n\t\t</tr><tr><td>99</td>\n\t\t\t<td>General Dynamics</td>\n\t\t\t<td><a href="http://www.generaldynamics.com">http://www.generaldynamics.com</a></td>\n\t\t</tr><tr><td>100</td>\n\t\t\t<td>USAA</td>\n\t\t\t<td><a href="http://www.usaa.com">http://www.usaa.com</a></td>\n\t\t</tr><tr><td>101</td>\n\t\t\t<td>Capital One Financial</td>\n\t\t\t<td><a href="http://www.capitalone.com">http://www.capitalone.com</a></td>\n\t\t</tr><tr><td>102</td>\n\t\t\t<td>Deere</td>\n\t\t\t<td><a href="http://www.johndeere.com">http://www.johndeere.com</a></td>\n\t\t</tr><tr><td>103</td>\n\t\t\t<td>INTL FCStone</td>\n\t\t\t<td><a href="http://www.intlfcstone.com">http://www.intlfcstone.com</a></td>\n\t\t</tr><tr><td>104</td>\n\t\t\t<td>Northwestern Mutual</td>\n\t\t\t<td><a href="http://www.northwesternmutual.com">http://www.northwesternmutual.com</a></td>\n\t\t</tr><tr><td>105</td>\n\t\t\t<td>Enterprise Products Partners</td>\n\t\t\t<td><a href="http://www.enterpriseproducts.com">http://www.enterpriseproducts.com</a></td>\n\t\t</tr><tr><td>106</td>\n\t\t\t<td>Travelers Cos.</td>\n\t\t\t<td><a href="http://www.travelers.com">http://www.travelers.com</a></td>\n\t\t</tr><tr><td>107</td>\n\t\t\t<td>Hewlett Packard Enterprise</td>\n\t\t\t<td><a href="http://www.hpe.com">http://www.hpe.com</a></td>\n\t\t</tr><tr><td>108</td>\n\t\t\t<td>Philip Morris International</td>\n\t\t\t<td><a href="http://www.pmi.com">http://www.pmi.com</a></td>\n\t\t</tr><tr><td>109</td>\n\t\t\t<td>Twenty-First Century Fox</td>\n\t\t\t<td><a href="http://www.21cf.com">http://www.21cf.com</a></td>\n\t\t</tr><tr><td>110</td>\n\t\t\t<td>AbbVie</td>\n\t\t\t<td><a href="http://www.abbvie.com">http://www.abbvie.com</a></td>\n\t\t</tr><tr><td>111</td>\n\t\t\t<td>Abbott Laboratories</td>\n\t\t\t<td><a href="http://www.abbott.com">http://www.abbott.com</a></td>\n\t\t</tr><tr><td>112</td>\n\t\t\t<td>Progressive</td>\n\t\t\t<td><a href="http://www.progressive.com">http://www.progressive.com</a></td>\n\t\t</tr><tr><td>113</td>\n\t\t\t<td>Arrow Electronics</td>\n\t\t\t<td><a href="http://www.arrow.com">http://www.arrow.com</a></td>\n\t\t</tr><tr><td>114</td>\n\t\t\t<td>Kraft Heinz</td>\n\t\t\t<td><a href="http://www.kraftheinzcompany.com">http://www.kraftheinzcompany.com</a></td>\n\t\t</tr><tr><td>115</td>\n\t\t\t<td>Plains GP Holdings</td>\n\t\t\t<td><a href="http://www.plainsallamerican.com">http://www.plainsallamerican.com</a></td>\n\t\t</tr><tr><td>116</td>\n\t\t\t<td>Gilead Sciences</td>\n\t\t\t<td><a href="http://www.gilead.com">http://www.gilead.com</a></td>\n\t\t</tr><tr><td>117</td>\n\t\t\t<td>Mondelez International</td>\n\t\t\t<td><a href="http://www.mondelezinternational.com">http://www.mondelezinternational.com</a></td>\n\t\t</tr><tr><td>118</td>\n\t\t\t<td>Northrop Grumman</td>\n\t\t\t<td><a href="http://www.northropgrumman.com">http://www.northropgrumman.com</a></td>\n\t\t</tr><tr><td>119</td>\n\t\t\t<td>Raytheon</td>\n\t\t\t<td><a href="http://www.raytheon.com">http://www.raytheon.com</a></td>\n\t\t</tr><tr><td>120</td>\n\t\t\t<td>Macy\xe2\x80\x99s</td>\n\t\t\t<td><a href="http://www.macysinc.com">http://www.macysinc.com</a></td>\n\t\t</tr><tr><td>121</td>\n\t\t\t<td>US Foods Holding</td>\n\t\t\t<td><a href="http://www.usfoods.com">http://www.usfoods.com</a></td>\n\t\t</tr><tr><td>122</td>\n\t\t\t<td>U.S. Bancorp</td>\n\t\t\t<td><a href="http://www.usbank.com">http://www.usbank.com</a></td>\n\t\t</tr><tr><td>123</td>\n\t\t\t<td>Dollar General</td>\n\t\t\t<td><a href="http://www.dollargeneral.com">http://www.dollargeneral.com</a></td>\n\t\t</tr><tr><td>124</td>\n\t\t\t<td>International Paper</td>\n\t\t\t<td><a href="http://www.internationalpaper.com">http://www.internationalpaper.com</a></td>\n\t\t</tr><tr><td>125</td>\n\t\t\t<td>Duke Energy</td>\n\t\t\t<td><a href="http://www.duke-energy.com">http://www.duke-energy.com</a></td>\n\t\t</tr><tr><td>126</td>\n\t\t\t<td>Southern</td>\n\t\t\t<td><a href="http://www.southerncompany.com">http://www.southerncompany.com</a></td>\n\t\t</tr><tr><td>127</td>\n\t\t\t<td>Marriott International</td>\n\t\t\t<td><a href="http://www.marriott.com">http://www.marriott.com</a></td>\n\t\t</tr><tr><td>128</td>\n\t\t\t<td>Avnet</td>\n\t\t\t<td><a href="http://www.avnet.com">http://www.avnet.com</a></td>\n\t\t</tr><tr><td>129</td>\n\t\t\t<td>Eli Lilly</td>\n\t\t\t<td><a href="http://www.lilly.com">http://www.lilly.com</a></td>\n\t\t</tr><tr><td>130</td>\n\t\t\t<td>Amgen</td>\n\t\t\t<td><a href="http://www.amgen.com">http://www.amgen.com</a></td>\n\t\t</tr><tr><td>131</td>\n\t\t\t<td>McDonald\xe2\x80\x99s</td>\n\t\t\t<td><a href="http://www.aboutmcdonalds.com">http://www.aboutmcdonalds.com</a></td>\n\t\t</tr><tr><td>132</td>\n\t\t\t<td>Starbucks</td>\n\t\t\t<td><a href="http://www.starbucks.com">http://www.starbucks.com</a></td>\n\t\t</tr><tr><td>133</td>\n\t\t\t<td>Qualcomm</td>\n\t\t\t<td><a href="http://www.qualcomm.com">http://www.qualcomm.com</a></td>\n\t\t</tr><tr><td>134</td>\n\t\t\t<td>Dollar Tree</td>\n\t\t\t<td><a href="http://www.dollartree.com">http://www.dollartree.com</a></td>\n\t\t</tr><tr><td>135</td>\n\t\t\t<td>PBF Energy</td>\n\t\t\t<td><a href="http://www.pbfenergy.com">http://www.pbfenergy.com</a></td>\n\t\t</tr><tr><td>136</td>\n\t\t\t<td>Icahn Enterprises</td>\n\t\t\t<td><a href="http://www.ielp.com">http://www.ielp.com</a></td>\n\t\t</tr><tr><td>137</td>\n\t\t\t<td>Aflac</td>\n\t\t\t<td><a href="http://www.aflac.com">http://www.aflac.com</a></td>\n\t\t</tr><tr><td>138</td>\n\t\t\t<td>AutoNation</td>\n\t\t\t<td><a href="http://www.autonation.com">http://www.autonation.com</a></td>\n\t\t</tr><tr><td>139</td>\n\t\t\t<td>Penske Automotive Group</td>\n\t\t\t<td><a href="http://www.penskeautomotive.com">http://www.penskeautomotive.com</a></td>\n\t\t</tr><tr><td>140</td>\n\t\t\t<td>Whirlpool</td>\n\t\t\t<td><a href="http://www.whirlpoolcorp.com">http://www.whirlpoolcorp.com</a></td>\n\t\t</tr><tr><td>141</td>\n\t\t\t<td>Union Pacific</td>\n\t\t\t<td><a href="http://www.up.com">http://www.up.com</a></td>\n\t\t</tr><tr><td>142</td>\n\t\t\t<td>Southwest Airlines</td>\n\t\t\t<td><a href="http://www.southwest.com">http://www.southwest.com</a></td>\n\t\t</tr><tr><td>143</td>\n\t\t\t<td>ManpowerGroup</td>\n\t\t\t<td><a href="http://www.manpowergroup.com">http://www.manpowergroup.com</a></td>\n\t\t</tr><tr><td>144</td>\n\t\t\t<td>Thermo Fisher Scientific</td>\n\t\t\t<td><a href="http://www.thermofisher.com">http://www.thermofisher.com</a></td>\n\t\t</tr><tr><td>145</td>\n\t\t\t<td>Bristol-Myers Squibb</td>\n\t\t\t<td><a href="http://www.bms.com">http://www.bms.com</a></td>\n\t\t</tr><tr><td>146</td>\n\t\t\t<td>Halliburton</td>\n\t\t\t<td><a href="http://www.halliburton.com">http://www.halliburton.com</a></td>\n\t\t</tr><tr><td>147</td>\n\t\t\t<td>Tenet Healthcare</td>\n\t\t\t<td><a href="http://www.tenethealth.com">http://www.tenethealth.com</a></td>\n\t\t</tr><tr><td>148</td>\n\t\t\t<td>Lear</td>\n\t\t\t<td><a href="http://www.lear.com">http://www.lear.com</a></td>\n\t\t</tr><tr><td>149</td>\n\t\t\t<td>Cummins</td>\n\t\t\t<td><a href="http://www.cummins.com">http://www.cummins.com</a></td>\n\t\t</tr><tr><td>150</td>\n\t\t\t<td>Micron Technology</td>\n\t\t\t<td><a href="http://www.micron.com">http://www.micron.com</a></td>\n\t\t</tr><tr><td>151</td>\n\t\t\t<td>Nucor</td>\n\t\t\t<td><a href="http://www.nucor.com">http://www.nucor.com</a></td>\n\t\t</tr><tr><td>152</td>\n\t\t\t<td>Molina Healthcare</td>\n\t\t\t<td><a href="http://www.molinahealthcare.com">http://www.molinahealthcare.com</a></td>\n\t\t</tr><tr><td>153</td>\n\t\t\t<td>Fluor</td>\n\t\t\t<td><a href="http://www.fluor.com">http://www.fluor.com</a></td>\n\t\t</tr><tr><td>154</td>\n\t\t\t<td>Altria Group</td>\n\t\t\t<td><a href="http://www.altria.com">http://www.altria.com</a></td>\n\t\t</tr><tr><td>155</td>\n\t\t\t<td>Paccar</td>\n\t\t\t<td><a href="http://www.paccar.com">http://www.paccar.com</a></td>\n\t\t</tr><tr><td>156</td>\n\t\t\t<td>Hartford Financial Services</td>\n\t\t\t<td><a href="http://www.thehartford.com">http://www.thehartford.com</a></td>\n\t\t</tr><tr><td>157</td>\n\t\t\t<td>Kohl\xe2\x80\x99s</td>\n\t\t\t<td><a href="http://www.kohls.com">http://www.kohls.com</a></td>\n\t\t</tr><tr><td>158</td>\n\t\t\t<td>Western Digital</td>\n\t\t\t<td><a href="http://www.wdc.com">http://www.wdc.com</a></td>\n\t\t</tr><tr><td>159</td>\n\t\t\t<td>Jabil</td>\n\t\t\t<td><a href="www.jabil.com">www.jabil.com</a></td>\n\t\t</tr><tr><td>160</td>\n\t\t\t<td>Community Health Systems</td>\n\t\t\t<td><a href="http://www.chs.net">http://www.chs.net</a></td>\n\t\t</tr><tr><td>161</td>\n\t\t\t<td>Visa</td>\n\t\t\t<td><a href="http://www.visa.com">http://www.visa.com</a></td>\n\t\t</tr><tr><td>162</td>\n\t\t\t<td>Danaher</td>\n\t\t\t<td><a href="http://www.danaher.com">http://www.danaher.com</a></td>\n\t\t</tr><tr><td>163</td>\n\t\t\t<td>Kimberly-Clark</td>\n\t\t\t<td><a href="http://www.kimberly-clark.com">http://www.kimberly-clark.com</a></td>\n\t\t</tr><tr><td>164</td>\n\t\t\t<td>AECOM</td>\n\t\t\t<td><a href="http://www.aecom.com">http://www.aecom.com</a></td>\n\t\t</tr><tr><td>165</td>\n\t\t\t<td>PNC Financial Services</td>\n\t\t\t<td><a href="http://www.pnc.com">http://www.pnc.com</a></td>\n\t\t</tr><tr><td>166</td>\n\t\t\t<td>CenturyLink</td>\n\t\t\t<td><a href="http://www.centurylink.com">http://www.centurylink.com</a></td>\n\t\t</tr><tr><td>167</td>\n\t\t\t<td>NextEra Energy</td>\n\t\t\t<td><a href="http://www.nexteraenergy.com">http://www.nexteraenergy.com</a></td>\n\t\t</tr><tr><td>168</td>\n\t\t\t<td>PG&amp;E Corp.</td>\n\t\t\t<td><a href="http://www.pgecorp.com">http://www.pgecorp.com</a></td>\n\t\t</tr><tr><td>169</td>\n\t\t\t<td>Synnex</td>\n\t\t\t<td><a href="http://www.synnex.com">http://www.synnex.com</a></td>\n\t\t</tr><tr><td>170</td>\n\t\t\t<td>WellCare Health Plans</td>\n\t\t\t<td><a href="http://www.wellcare.com">http://www.wellcare.com</a></td>\n\t\t</tr><tr><td>171</td>\n\t\t\t<td>Performance Food Group</td>\n\t\t\t<td><a href="http://www.pfgc.com">http://www.pfgc.com</a></td>\n\t\t</tr><tr><td>172</td>\n\t\t\t<td>Sears Holdings</td>\n\t\t\t<td><a href="http://www.searsholdings.com">http://www.searsholdings.com</a></td>\n\t\t</tr><tr><td>173</td>\n\t\t\t<td>Synchrony Financial</td>\n\t\t\t<td><a href="http://www.synchronyfinancial.com">http://www.synchronyfinancial.com</a></td>\n\t\t</tr><tr><td>174</td>\n\t\t\t<td>CarMax</td>\n\t\t\t<td><a href="http://www.carmax.com">http://www.carmax.com</a></td>\n\t\t</tr><tr><td>175</td>\n\t\t\t<td>Bank of New York Mellon</td>\n\t\t\t<td><a href="www.bnymellon.com">www.bnymellon.com</a></td>\n\t\t</tr><tr><td>176</td>\n\t\t\t<td>Freeport-McMoRan</td>\n\t\t\t<td><a href="http://www.fcx.com">http://www.fcx.com</a></td>\n\t\t</tr><tr><td>177</td>\n\t\t\t<td>Genuine Parts</td>\n\t\t\t<td><a href="http://www.genpt.com">http://www.genpt.com</a></td>\n\t\t</tr><tr><td>178</td>\n\t\t\t<td>Emerson Electric</td>\n\t\t\t<td><a href="http://www.emerson.com">http://www.emerson.com</a></td>\n\t\t</tr><tr><td>179</td>\n\t\t\t<td>DaVita</td>\n\t\t\t<td><a href="http://www.davita.com">http://www.davita.com</a></td>\n\t\t</tr><tr><td>180</td>\n\t\t\t<td>Supervalu</td>\n\t\t\t<td><a href="http://www.supervalu.com">http://www.supervalu.com</a></td>\n\t\t</tr><tr><td>181</td>\n\t\t\t<td>Gap</td>\n\t\t\t<td><a href="http://www.gapinc.com">http://www.gapinc.com</a></td>\n\t\t</tr><tr><td>182</td>\n\t\t\t<td>General Mills</td>\n\t\t\t<td><a href="http://www.generalmills.com">http://www.generalmills.com</a></td>\n\t\t</tr><tr><td>183</td>\n\t\t\t<td>Nordstrom</td>\n\t\t\t<td><a href="http://www.nordstrom.com">http://www.nordstrom.com</a></td>\n\t\t</tr><tr><td>184</td>\n\t\t\t<td>Colgate-Palmolive</td>\n\t\t\t<td><a href="http://www.colgatepalmolive.com">http://www.colgatepalmolive.com</a></td>\n\t\t</tr><tr><td>185</td>\n\t\t\t<td>American Electric Power</td>\n\t\t\t<td><a href="http://www.aep.com">http://www.aep.com</a></td>\n\t\t</tr><tr><td>186</td>\n\t\t\t<td>XPO Logistics</td>\n\t\t\t<td><a href="http://www.xpo.com">http://www.xpo.com</a></td>\n\t\t</tr><tr><td>187</td>\n\t\t\t<td>Goodyear Tire &amp; Rubber</td>\n\t\t\t<td><a href="http://www.goodyear.com">http://www.goodyear.com</a></td>\n\t\t</tr><tr><td>188</td>\n\t\t\t<td>Omnicom Group</td>\n\t\t\t<td><a href="http://www.omnicomgroup.com">http://www.omnicomgroup.com</a></td>\n\t\t</tr><tr><td>189</td>\n\t\t\t<td>CDW</td>\n\t\t\t<td><a href="http://www.cdw.com">http://www.cdw.com</a></td>\n\t\t</tr><tr><td>190</td>\n\t\t\t<td>Sherwin-Williams</td>\n\t\t\t<td><a href="http://www.sherwin.com">http://www.sherwin.com</a></td>\n\t\t</tr><tr><td>191</td>\n\t\t\t<td>PPG Industries</td>\n\t\t\t<td><a href="http://www.ppg.com">http://www.ppg.com</a></td>\n\t\t</tr><tr><td>192</td>\n\t\t\t<td>Texas Instruments</td>\n\t\t\t<td><a href="http://www.ti.com">http://www.ti.com</a></td>\n\t\t</tr><tr><td>193</td>\n\t\t\t<td>C.H. Robinson Worldwide</td>\n\t\t\t<td><a href="http://www.chrobinson.com">http://www.chrobinson.com</a></td>\n\t\t</tr><tr><td>194</td>\n\t\t\t<td>WestRock</td>\n\t\t\t<td><a href="http://www.westrock.com">http://www.westrock.com</a></td>\n\t\t</tr><tr><td>195</td>\n\t\t\t<td>Cognizant Technology Solutions</td>\n\t\t\t<td><a href="http://www.cognizant.com">http://www.cognizant.com</a></td>\n\t\t</tr><tr><td>196</td>\n\t\t\t<td>Newell Brands</td>\n\t\t\t<td><a href="http://www.newellbrands.com">http://www.newellbrands.com</a></td>\n\t\t</tr><tr><td>197</td>\n\t\t\t<td>CBS</td>\n\t\t\t<td><a href="http://www.cbscorporation.com">http://www.cbscorporation.com</a></td>\n\t\t</tr><tr><td>198</td>\n\t\t\t<td>Envision Healthcare</td>\n\t\t\t<td><a href="http://www.evhc.net">http://www.evhc.net</a></td>\n\t\t</tr><tr><td>199</td>\n\t\t\t<td>Monsanto</td>\n\t\t\t<td><a href="http://www.monsanto.com">http://www.monsanto.com</a></td>\n\t\t</tr><tr><td>200</td>\n\t\t\t<td>Aramark</td>\n\t\t\t<td><a href="http://www.aramark.com">http://www.aramark.com</a></td>\n\t\t</tr><tr><td>201</td>\n\t\t\t<td>Applied Materials</td>\n\t\t\t<td><a href="http://www.appliedmaterials.com">http://www.appliedmaterials.com</a></td>\n\t\t</tr><tr><td>202</td>\n\t\t\t<td>Waste Management</td>\n\t\t\t<td><a href="http://www.wm.com">http://www.wm.com</a></td>\n\t\t</tr><tr><td>203</td>\n\t\t\t<td>DISH Network</td>\n\t\t\t<td><a href="http://www.dish.com">http://www.dish.com</a></td>\n\t\t</tr><tr><td>204</td>\n\t\t\t<td>Illinois Tool Works</td>\n\t\t\t<td><a href="http://www.itw.com">http://www.itw.com</a></td>\n\t\t</tr><tr><td>205</td>\n\t\t\t<td>Lincoln National</td>\n\t\t\t<td><a href="http://www.lfg.com">http://www.lfg.com</a></td>\n\t\t</tr><tr><td>206</td>\n\t\t\t<td>HollyFrontier</td>\n\t\t\t<td><a href="http://www.hollyfrontier.com">http://www.hollyfrontier.com</a></td>\n\t\t</tr><tr><td>207</td>\n\t\t\t<td>CBRE Group</td>\n\t\t\t<td><a href="http://www.cbre.com">http://www.cbre.com</a></td>\n\t\t</tr><tr><td>208</td>\n\t\t\t<td>Textron</td>\n\t\t\t<td><a href="http://www.textron.com">http://www.textron.com</a></td>\n\t\t</tr><tr><td>209</td>\n\t\t\t<td>Ross Stores</td>\n\t\t\t<td><a href="http://www.rossstores.com">http://www.rossstores.com</a></td>\n\t\t</tr><tr><td>210</td>\n\t\t\t<td>Principal Financial</td>\n\t\t\t<td><a href="http://www.principal.com">http://www.principal.com</a></td>\n\t\t</tr><tr><td>211</td>\n\t\t\t<td>D.R. Horton</td>\n\t\t\t<td><a href="http://www.drhorton.com">http://www.drhorton.com</a></td>\n\t\t</tr><tr><td>212</td>\n\t\t\t<td>Marsh &amp; McLennan</td>\n\t\t\t<td><a href="http://www.mmc.com">http://www.mmc.com</a></td>\n\t\t</tr><tr><td>213</td>\n\t\t\t<td>Devon Energy</td>\n\t\t\t<td><a href="http://www.devonenergy.com">http://www.devonenergy.com</a></td>\n\t\t</tr><tr><td>214</td>\n\t\t\t<td>AES</td>\n\t\t\t<td><a href="http://www.aes.com">http://www.aes.com</a></td>\n\t\t</tr><tr><td>215</td>\n\t\t\t<td>Ecolab</td>\n\t\t\t<td><a href="http://www.ecolab.com">http://www.ecolab.com</a></td>\n\t\t</tr><tr><td>216</td>\n\t\t\t<td>Land O\xe2\x80\x99Lakes</td>\n\t\t\t<td><a href="http://www.landolakesinc.com">http://www.landolakesinc.com</a></td>\n\t\t</tr><tr><td>217</td>\n\t\t\t<td>Loews</td>\n\t\t\t<td><a href="http://www.loews.com">http://www.loews.com</a></td>\n\t\t</tr><tr><td>218</td>\n\t\t\t<td>Kinder Morgan</td>\n\t\t\t<td><a href="http://www.kindermorgan.com">http://www.kindermorgan.com</a></td>\n\t\t</tr><tr><td>219</td>\n\t\t\t<td>FirstEnergy</td>\n\t\t\t<td><a href="http://www.firstenergycorp.com">http://www.firstenergycorp.com</a></td>\n\t\t</tr><tr><td>220</td>\n\t\t\t<td>Occidental Petroleum</td>\n\t\t\t<td><a href="http://www.oxy.com">http://www.oxy.com</a></td>\n\t\t</tr><tr><td>221</td>\n\t\t\t<td>Viacom</td>\n\t\t\t<td><a href="http://www.viacom.com">http://www.viacom.com</a></td>\n\t\t</tr><tr><td>222</td>\n\t\t\t<td>PayPal Holdings</td>\n\t\t\t<td><a href="http://www.paypal.com">http://www.paypal.com</a></td>\n\t\t</tr><tr><td>223</td>\n\t\t\t<td>NGL Energy Partners</td>\n\t\t\t<td><a href="http://www.nglenergypartners.com">http://www.nglenergypartners.com</a></td>\n\t\t</tr><tr><td>224</td>\n\t\t\t<td>Celgene</td>\n\t\t\t<td><a href="http://www.celgene.com">http://www.celgene.com</a></td>\n\t\t</tr><tr><td>225</td>\n\t\t\t<td>Arconic</td>\n\t\t\t<td><a href="http://www.arconic.com">http://www.arconic.com</a></td>\n\t\t</tr><tr><td>226</td>\n\t\t\t<td>Kellogg</td>\n\t\t\t<td><a href="http://www.kelloggcompany.com">http://www.kelloggcompany.com</a></td>\n\t\t</tr><tr><td>227</td>\n\t\t\t<td>Las Vegas Sands</td>\n\t\t\t<td><a href="http://www.sands.com">http://www.sands.com</a></td>\n\t\t</tr><tr><td>228</td>\n\t\t\t<td>Stanley Black &amp; Decker</td>\n\t\t\t<td><a href="http://www.stanleyblackanddecker.com">http://www.stanleyblackanddecker.com</a></td>\n\t\t</tr><tr><td>229</td>\n\t\t\t<td>Booking Holdings</td>\n\t\t\t<td><a href="http://www.bookingholdings.com">http://www.bookingholdings.com</a></td>\n\t\t</tr><tr><td>230</td>\n\t\t\t<td>Lennar</td>\n\t\t\t<td><a href="http://www.lennar.com">http://www.lennar.com</a></td>\n\t\t</tr><tr><td>231</td>\n\t\t\t<td>L Brands</td>\n\t\t\t<td><a href="http://www.lb.com">http://www.lb.com</a></td>\n\t\t</tr><tr><td>232</td>\n\t\t\t<td>DTE Energy</td>\n\t\t\t<td><a href="http://www.dteenergy.com">http://www.dteenergy.com</a></td>\n\t\t</tr><tr><td>233</td>\n\t\t\t<td>Dominion Energy</td>\n\t\t\t<td><a href="www.dominionenergy.com">www.dominionenergy.com</a></td>\n\t\t</tr><tr><td>234</td>\n\t\t\t<td>Reinsurance Group of America</td>\n\t\t\t<td><a href="http://www.rgare.com">http://www.rgare.com</a></td>\n\t\t</tr><tr><td>235</td>\n\t\t\t<td>J.C. Penney</td>\n\t\t\t<td><a href="http://www.jcpenney.com">http://www.jcpenney.com</a></td>\n\t\t</tr><tr><td>236</td>\n\t\t\t<td>Mastercard</td>\n\t\t\t<td><a href="http://www.mastercard.com">http://www.mastercard.com</a></td>\n\t\t</tr><tr><td>237</td>\n\t\t\t<td>BlackRock</td>\n\t\t\t<td><a href="http://www.blackrock.com">http://www.blackrock.com</a></td>\n\t\t</tr><tr><td>238</td>\n\t\t\t<td>Henry Schein</td>\n\t\t\t<td><a href="http://www.henryschein.com">http://www.henryschein.com</a></td>\n\t\t</tr><tr><td>239</td>\n\t\t\t<td>Guardian Life Ins. Co. of America</td>\n\t\t\t<td><a href="http://www.guardianlife.com">http://www.guardianlife.com</a></td>\n\t\t</tr><tr><td>240</td>\n\t\t\t<td>Stryker</td>\n\t\t\t<td><a href="http://www.stryker.com">http://www.stryker.com</a></td>\n\t\t</tr><tr><td>241</td>\n\t\t\t<td>Jefferies Financial Group</td>\n\t\t\t<td><a href="http://www.jefferies.com">http://www.jefferies.com</a></td>\n\t\t</tr><tr><td>242</td>\n\t\t\t<td>VF</td>\n\t\t\t<td><a href="http://www.vfc.com">http://www.vfc.com</a></td>\n\t\t</tr><tr><td>243</td>\n\t\t\t<td>ADP</td>\n\t\t\t<td><a href="http://www.adp.com">http://www.adp.com</a></td>\n\t\t</tr><tr><td>244</td>\n\t\t\t<td>Edison International</td>\n\t\t\t<td><a href="http://www.edisoninvestor.com">http://www.edisoninvestor.com</a></td>\n\t\t</tr><tr><td>245</td>\n\t\t\t<td>Biogen</td>\n\t\t\t<td><a href="http://www.biogen.com">http://www.biogen.com</a></td>\n\t\t</tr><tr><td>246</td>\n\t\t\t<td>United States Steel</td>\n\t\t\t<td><a href="http://www.ussteel.com">http://www.ussteel.com</a></td>\n\t\t</tr><tr><td>247</td>\n\t\t\t<td>Core-Mark Holding</td>\n\t\t\t<td><a href="http://www.core-mark.com">http://www.core-mark.com</a></td>\n\t\t</tr><tr><td>248</td>\n\t\t\t<td>Bed Bath &amp; Beyond</td>\n\t\t\t<td><a href="http://www.bedbathandbeyond.com">http://www.bedbathandbeyond.com</a></td>\n\t\t</tr><tr><td>249</td>\n\t\t\t<td>Oneok</td>\n\t\t\t<td><a href="http://www.oneok.com">http://www.oneok.com</a></td>\n\t\t</tr><tr><td>250</td>\n\t\t\t<td>BB&amp;T Corp.</td>\n\t\t\t<td><a href="http://www.bbt.com">http://www.bbt.com</a></td>\n\t\t</tr><tr><td>251</td>\n\t\t\t<td>Becton Dickinson</td>\n\t\t\t<td><a href="http://www.bd.com">http://www.bd.com</a></td>\n\t\t</tr><tr><td>252</td>\n\t\t\t<td>Ameriprise Financial</td>\n\t\t\t<td><a href="http://www.ameriprise.com">http://www.ameriprise.com</a></td>\n\t\t</tr><tr><td>253</td>\n\t\t\t<td>Farmers Insurance Exchange</td>\n\t\t\t<td><a href="http://www.farmers.com">http://www.farmers.com</a></td>\n\t\t</tr><tr><td>254</td>\n\t\t\t<td>First Data</td>\n\t\t\t<td><a href="http://www.firstdata.com">http://www.firstdata.com</a></td>\n\t\t</tr><tr><td>255</td>\n\t\t\t<td>Consolidated Edison</td>\n\t\t\t<td><a href="http://www.conedison.com">http://www.conedison.com</a></td>\n\t\t</tr><tr><td>256</td>\n\t\t\t<td>Parker-Hannifin</td>\n\t\t\t<td><a href="http://www.parker.com">http://www.parker.com</a></td>\n\t\t</tr><tr><td>257</td>\n\t\t\t<td>Anadarko Petroleum</td>\n\t\t\t<td><a href="http://www.anadarko.com">http://www.anadarko.com</a></td>\n\t\t</tr><tr><td>258</td>\n\t\t\t<td>Estee Lauder</td>\n\t\t\t<td><a href="http://www.elcompanies.com">http://www.elcompanies.com</a></td>\n\t\t</tr><tr><td>259</td>\n\t\t\t<td>State Street Corp.</td>\n\t\t\t<td><a href="http://www.statestreet.com">http://www.statestreet.com</a></td>\n\t\t</tr><tr><td>260</td>\n\t\t\t<td>Tesla</td>\n\t\t\t<td><a href="http://www.tesla.com">http://www.tesla.com</a></td>\n\t\t</tr><tr><td>261</td>\n\t\t\t<td>Netflix</td>\n\t\t\t<td><a href="http://www.netflix.com">http://www.netflix.com</a></td>\n\t\t</tr><tr><td>262</td>\n\t\t\t<td>Alcoa</td>\n\t\t\t<td><a href="http://www.alcoa.com">http://www.alcoa.com</a></td>\n\t\t</tr><tr><td>263</td>\n\t\t\t<td>Discover Financial Services</td>\n\t\t\t<td><a href="http://www.discover.com">http://www.discover.com</a></td>\n\t\t</tr><tr><td>264</td>\n\t\t\t<td>Praxair</td>\n\t\t\t<td><a href="http://www.praxair.com">http://www.praxair.com</a></td>\n\t\t</tr><tr><td>265</td>\n\t\t\t<td>CSX</td>\n\t\t\t<td><a href="http://www.csx.com">http://www.csx.com</a></td>\n\t\t</tr><tr><td>266</td>\n\t\t\t<td>Xcel Energy</td>\n\t\t\t<td><a href="http://www.xcelenergy.com">http://www.xcelenergy.com</a></td>\n\t\t</tr><tr><td>267</td>\n\t\t\t<td>Unum Group</td>\n\t\t\t<td><a href="http://www.unum.com">http://www.unum.com</a></td>\n\t\t</tr><tr><td>268</td>\n\t\t\t<td>Universal Health Services</td>\n\t\t\t<td><a href="http://www.uhsinc.com">http://www.uhsinc.com</a></td>\n\t\t</tr><tr><td>269</td>\n\t\t\t<td>NRG Energy</td>\n\t\t\t<td><a href="http://www.nrg.com">http://www.nrg.com</a></td>\n\t\t</tr><tr><td>270</td>\n\t\t\t<td>EOG Resources</td>\n\t\t\t<td><a href="http://www.eogresources.com">http://www.eogresources.com</a></td>\n\t\t</tr><tr><td>271</td>\n\t\t\t<td>Sempra Energy</td>\n\t\t\t<td><a href="http://www.sempra.com">http://www.sempra.com</a></td>\n\t\t</tr><tr><td>272</td>\n\t\t\t<td>Toys \xe2\x80\x9cR\xe2\x80\x9d Us</td>\n\t\t\t<td><a href="http://www.toysrusinc.com">http://www.toysrusinc.com</a></td>\n\t\t</tr><tr><td>273</td>\n\t\t\t<td>Group Automotive</td>\n\t\t\t<td><a href="http://www.group1auto.com">http://www.group1auto.com</a></td>\n\t\t</tr><tr><td>274</td>\n\t\t\t<td>Entergy</td>\n\t\t\t<td><a href="http://www.entergy.com">http://www.entergy.com</a></td>\n\t\t</tr><tr><td>275</td>\n\t\t\t<td>Molson Coors Brewing</td>\n\t\t\t<td><a href="http://www.molsoncoors.com">http://www.molsoncoors.com</a></td>\n\t\t</tr><tr><td>276</td>\n\t\t\t<td>L Technologies</td>\n\t\t\t<td><a href="http://www.l3t.com">http://www.l3t.com</a></td>\n\t\t</tr><tr><td>277</td>\n\t\t\t<td>Ball</td>\n\t\t\t<td><a href="http://www.ball.com">http://www.ball.com</a></td>\n\t\t</tr><tr><td>278</td>\n\t\t\t<td>AutoZone</td>\n\t\t\t<td><a href="http://www.autozone.com">http://www.autozone.com</a></td>\n\t\t</tr><tr><td>279</td>\n\t\t\t<td>Murphy USA</td>\n\t\t\t<td><a href="http://www.murphyusa.com">http://www.murphyusa.com</a></td>\n\t\t</tr><tr><td>280</td>\n\t\t\t<td>MGM Resorts International</td>\n\t\t\t<td><a href="http://www.mgmresorts.com">http://www.mgmresorts.com</a></td>\n\t\t</tr><tr><td>281</td>\n\t\t\t<td>Office Depot</td>\n\t\t\t<td><a href="http://www.officedepot.com">http://www.officedepot.com</a></td>\n\t\t</tr><tr><td>282</td>\n\t\t\t<td>Huntsman</td>\n\t\t\t<td><a href="http://www.huntsman.com">http://www.huntsman.com</a></td>\n\t\t</tr><tr><td>283</td>\n\t\t\t<td>Baxter International</td>\n\t\t\t<td><a href="http://www.baxter.com">http://www.baxter.com</a></td>\n\t\t</tr><tr><td>284</td>\n\t\t\t<td>Norfolk Southern</td>\n\t\t\t<td><a href="http://www.norfolksouthern.com">http://www.norfolksouthern.com</a></td>\n\t\t</tr><tr><td>285</td>\n\t\t\t<td>salesforce.com</td>\n\t\t\t<td><a href="http://www.salesforce.com">http://www.salesforce.com</a></td>\n\t\t</tr><tr><td>286</td>\n\t\t\t<td>Laboratory Corp. of America</td>\n\t\t\t<td><a href="http://www.labcorp.com">http://www.labcorp.com</a></td>\n\t\t</tr><tr><td>287</td>\n\t\t\t<td>W.W. Grainger</td>\n\t\t\t<td><a href="http://www.grainger.com">http://www.grainger.com</a></td>\n\t\t</tr><tr><td>288</td>\n\t\t\t<td>Qurate Retail</td>\n\t\t\t<td><a href="http://www.libertyinteractive.com">http://www.libertyinteractive.com</a></td>\n\t\t</tr><tr><td>289</td>\n\t\t\t<td>Autoliv</td>\n\t\t\t<td><a href="http://www.autoliv.com">http://www.autoliv.com</a></td>\n\t\t</tr><tr><td>290</td>\n\t\t\t<td>Live Nation Entertainment</td>\n\t\t\t<td><a href="http://www.livenationentertainment.com">http://www.livenationentertainment.com</a></td>\n\t\t</tr><tr><td>291</td>\n\t\t\t<td>Xerox</td>\n\t\t\t<td><a href="http://www.xerox.com">http://www.xerox.com</a></td>\n\t\t</tr><tr><td>292</td>\n\t\t\t<td>Leidos Holdings</td>\n\t\t\t<td><a href="http://www.leidos.com">http://www.leidos.com</a></td>\n\t\t</tr><tr><td>293</td>\n\t\t\t<td>Corning</td>\n\t\t\t<td><a href="http://www.corning.com">http://www.corning.com</a></td>\n\t\t</tr><tr><td>294</td>\n\t\t\t<td>Lithia Motors</td>\n\t\t\t<td><a href="http://www.lithiainvestorrelations.com">http://www.lithiainvestorrelations.com</a></td>\n\t\t</tr><tr><td>295</td>\n\t\t\t<td>Expedia Group</td>\n\t\t\t<td><a href="http://www.expediagroup.com">http://www.expediagroup.com</a></td>\n\t\t</tr><tr><td>296</td>\n\t\t\t<td>Republic Services</td>\n\t\t\t<td><a href="http://www.republicservices.com">http://www.republicservices.com</a></td>\n\t\t</tr><tr><td>297</td>\n\t\t\t<td>Jacobs Engineering Group</td>\n\t\t\t<td><a href="http://www.jacobs.com">http://www.jacobs.com</a></td>\n\t\t</tr><tr><td>298</td>\n\t\t\t<td>Sonic Automotive</td>\n\t\t\t<td><a href="http://www.sonicautomotive.com">http://www.sonicautomotive.com</a></td>\n\t\t</tr><tr><td>299</td>\n\t\t\t<td>Ally Financial</td>\n\t\t\t<td><a href="http://www.ally.com">http://www.ally.com</a></td>\n\t\t</tr><tr><td>300</td>\n\t\t\t<td>LKQ</td>\n\t\t\t<td><a href="http://www.lkqcorp.com">http://www.lkqcorp.com</a></td>\n\t\t</tr><tr><td>301</td>\n\t\t\t<td>BorgWarner</td>\n\t\t\t<td><a href="http://www.borgwarner.com">http://www.borgwarner.com</a></td>\n\t\t</tr><tr><td>302</td>\n\t\t\t<td>Fidelity National Financial</td>\n\t\t\t<td><a href="http://www.fnf.com">http://www.fnf.com</a></td>\n\t\t</tr><tr><td>303</td>\n\t\t\t<td>SunTrust Banks</td>\n\t\t\t<td><a href="http://www.suntrust.com">http://www.suntrust.com</a></td>\n\t\t</tr><tr><td>304</td>\n\t\t\t<td>IQVIA Holdings</td>\n\t\t\t<td><a href="www.iqvia.com">www.iqvia.com</a></td>\n\t\t</tr><tr><td>305</td>\n\t\t\t<td>Reliance Steel &amp; Aluminum</td>\n\t\t\t<td><a href="http://www.rsac.com">http://www.rsac.com</a></td>\n\t\t</tr><tr><td>306</td>\n\t\t\t<td>Nvidia</td>\n\t\t\t<td><a href="http://www.nvidia.com">http://www.nvidia.com</a></td>\n\t\t</tr><tr><td>307</td>\n\t\t\t<td>Voya Financial</td>\n\t\t\t<td><a href="http://www.voya.com">http://www.voya.com</a></td>\n\t\t</tr><tr><td>308</td>\n\t\t\t<td>CenterPoint Energy</td>\n\t\t\t<td><a href="http://www.centerpointenergy.com">http://www.centerpointenergy.com</a></td>\n\t\t</tr><tr><td>309</td>\n\t\t\t<td>eBay</td>\n\t\t\t<td><a href="http://www.ebay.com">http://www.ebay.com</a></td>\n\t\t</tr><tr><td>310</td>\n\t\t\t<td>Eastman Chemical</td>\n\t\t\t<td><a href="http://www.eastman.com">http://www.eastman.com</a></td>\n\t\t</tr><tr><td>311</td>\n\t\t\t<td>American Family Insurance Group</td>\n\t\t\t<td><a href="http://www.amfam.com">http://www.amfam.com</a></td>\n\t\t</tr><tr><td>312</td>\n\t\t\t<td>Steel Dynamics</td>\n\t\t\t<td><a href="http://www.steeldynamics.com">http://www.steeldynamics.com</a></td>\n\t\t</tr><tr><td>313</td>\n\t\t\t<td>Pacific Life</td>\n\t\t\t<td><a href="http://www.pacificlife.com">http://www.pacificlife.com</a></td>\n\t\t</tr><tr><td>314</td>\n\t\t\t<td>Chesapeake Energy</td>\n\t\t\t<td><a href="http://www.chk.com">http://www.chk.com</a></td>\n\t\t</tr><tr><td>315</td>\n\t\t\t<td>Mohawk Industries</td>\n\t\t\t<td><a href="http://www.mohawkind.com">http://www.mohawkind.com</a></td>\n\t\t</tr><tr><td>316</td>\n\t\t\t<td>Quanta Services</td>\n\t\t\t<td><a href="http://www.quantaservices.com">http://www.quantaservices.com</a></td>\n\t\t</tr><tr><td>317</td>\n\t\t\t<td>Advance Auto Parts</td>\n\t\t\t<td><a href="http://www.advanceautoparts.com">http://www.advanceautoparts.com</a></td>\n\t\t</tr><tr><td>318</td>\n\t\t\t<td>Owens &amp; Minor</td>\n\t\t\t<td><a href="http://www.owens-minor.com">http://www.owens-minor.com</a></td>\n\t\t</tr><tr><td>319</td>\n\t\t\t<td>United Natural Foods</td>\n\t\t\t<td><a href="http://www.unfi.com">http://www.unfi.com</a></td>\n\t\t</tr><tr><td>320</td>\n\t\t\t<td>Tenneco</td>\n\t\t\t<td><a href="http://www.tenneco.com">http://www.tenneco.com</a></td>\n\t\t</tr><tr><td>321</td>\n\t\t\t<td>Conagra Brands</td>\n\t\t\t<td><a href="http://www.conagrabrands.com">http://www.conagrabrands.com</a></td>\n\t\t</tr><tr><td>322</td>\n\t\t\t<td>GameStop</td>\n\t\t\t<td><a href="http://www.gamestop.com">http://www.gamestop.com</a></td>\n\t\t</tr><tr><td>323</td>\n\t\t\t<td>Hormel Foods</td>\n\t\t\t<td><a href="http://www.hormelfoods.com">http://www.hormelfoods.com</a></td>\n\t\t</tr><tr><td>324</td>\n\t\t\t<td>Hilton Worldwide Holdings</td>\n\t\t\t<td><a href="http://www.hiltonworldwide.com">http://www.hiltonworldwide.com</a></td>\n\t\t</tr><tr><td>325</td>\n\t\t\t<td>Frontier Communications</td>\n\t\t\t<td><a href="http://www.frontier.com">http://www.frontier.com</a></td>\n\t\t</tr><tr><td>326</td>\n\t\t\t<td>Fidelity National Information Services</td>\n\t\t\t<td><a href="http://www.fisglobal.com">http://www.fisglobal.com</a></td>\n\t\t</tr><tr><td>327</td>\n\t\t\t<td>Public Service Enterprise Group</td>\n\t\t\t<td><a href="http://www.pseg.com">http://www.pseg.com</a></td>\n\t\t</tr><tr><td>328</td>\n\t\t\t<td>Boston Scientific</td>\n\t\t\t<td><a href="http://www.bostonscientific.com">http://www.bostonscientific.com</a></td>\n\t\t</tr><tr><td>329</td>\n\t\t\t<td>O\xe2\x80\x99Reilly Automotive</td>\n\t\t\t<td><a href="http://www.oreillyauto.com">http://www.oreillyauto.com</a></td>\n\t\t</tr><tr><td>330</td>\n\t\t\t<td>Charles Schwab</td>\n\t\t\t<td><a href="http://www.aboutschwab.com">http://www.aboutschwab.com</a></td>\n\t\t</tr><tr><td>331</td>\n\t\t\t<td>Global Partners</td>\n\t\t\t<td><a href="http://www.globalp.com">http://www.globalp.com</a></td>\n\t\t</tr><tr><td>332</td>\n\t\t\t<td>PVH</td>\n\t\t\t<td><a href="http://www.pvh.com">http://www.pvh.com</a></td>\n\t\t</tr><tr><td>333</td>\n\t\t\t<td>Avis Budget Group</td>\n\t\t\t<td><a href="http://www.avisbudgetgroup.com">http://www.avisbudgetgroup.com</a></td>\n\t\t</tr><tr><td>334</td>\n\t\t\t<td>Targa Resources</td>\n\t\t\t<td><a href="http://www.targaresources.com">http://www.targaresources.com</a></td>\n\t\t</tr><tr><td>335</td>\n\t\t\t<td>Hertz Global Holdings</td>\n\t\t\t<td><a href="http://www.hertz.com">http://www.hertz.com</a></td>\n\t\t</tr><tr><td>336</td>\n\t\t\t<td>Calpine</td>\n\t\t\t<td><a href="http://www.calpine.com">http://www.calpine.com</a></td>\n\t\t</tr><tr><td>337</td>\n\t\t\t<td>Mutual of Omaha Insurance</td>\n\t\t\t<td><a href="http://www.mutualofomaha.com">http://www.mutualofomaha.com</a></td>\n\t\t</tr><tr><td>338</td>\n\t\t\t<td>Crown Holdings</td>\n\t\t\t<td><a href="http://www.crowncork.com">http://www.crowncork.com</a></td>\n\t\t</tr><tr><td>339</td>\n\t\t\t<td>Peter Kiewit Sons\xe2\x80\x99</td>\n\t\t\t<td><a href="http://www.kiewit.com">http://www.kiewit.com</a></td>\n\t\t</tr><tr><td>340</td>\n\t\t\t<td>Dick\xe2\x80\x99s Sporting Goods</td>\n\t\t\t<td><a href="http://www.dicks.com">http://www.dicks.com</a></td>\n\t\t</tr><tr><td>341</td>\n\t\t\t<td>PulteGroup</td>\n\t\t\t<td><a href="http://www.pultegroupinc.com">http://www.pultegroupinc.com</a></td>\n\t\t</tr><tr><td>342</td>\n\t\t\t<td>Navistar International</td>\n\t\t\t<td><a href="http://www.navistar.com">http://www.navistar.com</a></td>\n\t\t</tr><tr><td>343</td>\n\t\t\t<td>Thrivent Financial for Lutherans</td>\n\t\t\t<td><a href="http://www.thrivent.com">http://www.thrivent.com</a></td>\n\t\t</tr><tr><td>344</td>\n\t\t\t<td>DCP Midstream</td>\n\t\t\t<td><a href="http://www.dcpmidstream.com">http://www.dcpmidstream.com</a></td>\n\t\t</tr><tr><td>345</td>\n\t\t\t<td>Air Products &amp; Chemicals</td>\n\t\t\t<td><a href="http://www.airproducts.com">http://www.airproducts.com</a></td>\n\t\t</tr><tr><td>346</td>\n\t\t\t<td>Veritiv</td>\n\t\t\t<td><a href="http://www.veritivcorp.com">http://www.veritivcorp.com</a></td>\n\t\t</tr><tr><td>347</td>\n\t\t\t<td>AGCO</td>\n\t\t\t<td><a href="http://www.agcocorp.com">http://www.agcocorp.com</a></td>\n\t\t</tr><tr><td>348</td>\n\t\t\t<td>Genworth Financial</td>\n\t\t\t<td><a href="http://www.genworth.com">http://www.genworth.com</a></td>\n\t\t</tr><tr><td>349</td>\n\t\t\t<td>Univar</td>\n\t\t\t<td><a href="http://www.univar.com">http://www.univar.com</a></td>\n\t\t</tr><tr><td>350</td>\n\t\t\t<td>News Corp.</td>\n\t\t\t<td><a href="http://www.newscorp.com">http://www.newscorp.com</a></td>\n\t\t</tr><tr><td>351</td>\n\t\t\t<td>SpartanNash</td>\n\t\t\t<td><a href="http://www.spartannash.com">http://www.spartannash.com</a></td>\n\t\t</tr><tr><td>352</td>\n\t\t\t<td>Westlake Chemical</td>\n\t\t\t<td><a href="http://www.westlake.com">http://www.westlake.com</a></td>\n\t\t</tr><tr><td>353</td>\n\t\t\t<td>Williams</td>\n\t\t\t<td><a href="http://www.williams.com">http://www.williams.com</a></td>\n\t\t</tr><tr><td>354</td>\n\t\t\t<td>Lam Research</td>\n\t\t\t<td><a href="http://www.lamresearch.com">http://www.lamresearch.com</a></td>\n\t\t</tr><tr><td>355</td>\n\t\t\t<td>Alaska Air Group</td>\n\t\t\t<td><a href="http://www.alaskaair.com">http://www.alaskaair.com</a></td>\n\t\t</tr><tr><td>356</td>\n\t\t\t<td>Jones Lang LaSalle</td>\n\t\t\t<td><a href="http://www.jll.com">http://www.jll.com</a></td>\n\t\t</tr><tr><td>357</td>\n\t\t\t<td>Anixter International</td>\n\t\t\t<td><a href="http://www.anixter.com">http://www.anixter.com</a></td>\n\t\t</tr><tr><td>358</td>\n\t\t\t<td>Campbell Soup</td>\n\t\t\t<td><a href="http://www.campbellsoupcompany.com">http://www.campbellsoupcompany.com</a></td>\n\t\t</tr><tr><td>359</td>\n\t\t\t<td>Interpublic Group</td>\n\t\t\t<td><a href="http://www.interpublic.com">http://www.interpublic.com</a></td>\n\t\t</tr><tr><td>360</td>\n\t\t\t<td>Dover</td>\n\t\t\t<td><a href="http://www.dovercorporation.com">http://www.dovercorporation.com</a></td>\n\t\t</tr><tr><td>361</td>\n\t\t\t<td>Zimmer Biomet Holdings</td>\n\t\t\t<td><a href="http://www.zimmerbiomet.com">http://www.zimmerbiomet.com</a></td>\n\t\t</tr><tr><td>362</td>\n\t\t\t<td>Dean Foods</td>\n\t\t\t<td><a href="http://www.deanfoods.com">http://www.deanfoods.com</a></td>\n\t\t</tr><tr><td>363</td>\n\t\t\t<td>Foot Locker</td>\n\t\t\t<td><a href="http://www.footlocker-inc.com">http://www.footlocker-inc.com</a></td>\n\t\t</tr><tr><td>364</td>\n\t\t\t<td>Eversource Energy</td>\n\t\t\t<td><a href="http://www.eversource.com">http://www.eversource.com</a></td>\n\t\t</tr><tr><td>365</td>\n\t\t\t<td>Alliance Data Systems</td>\n\t\t\t<td><a href="http://www.alliancedata.com">http://www.alliancedata.com</a></td>\n\t\t</tr><tr><td>366</td>\n\t\t\t<td>Fifth Third Bancorp</td>\n\t\t\t<td><a href="http://www.53.com">http://www.53.com</a></td>\n\t\t</tr><tr><td>367</td>\n\t\t\t<td>Quest Diagnostics</td>\n\t\t\t<td><a href="http://www.questdiagnostics.com">http://www.questdiagnostics.com</a></td>\n\t\t</tr><tr><td>368</td>\n\t\t\t<td>EMCOR Group</td>\n\t\t\t<td><a href="http://www.emcorgroup.com">http://www.emcorgroup.com</a></td>\n\t\t</tr><tr><td>369</td>\n\t\t\t<td>W.R. Berkley</td>\n\t\t\t<td><a href="http://www.wrberkley.com">http://www.wrberkley.com</a></td>\n\t\t</tr><tr><td>370</td>\n\t\t\t<td>WESCO International</td>\n\t\t\t<td><a href="http://www.wesco.com">http://www.wesco.com</a></td>\n\t\t</tr><tr><td>371</td>\n\t\t\t<td>Coty</td>\n\t\t\t<td><a href="http://www.coty.com">http://www.coty.com</a></td>\n\t\t</tr><tr><td>372</td>\n\t\t\t<td>WEC Energy Group</td>\n\t\t\t<td><a href="http://www.wecenergygroup.com">http://www.wecenergygroup.com</a></td>\n\t\t</tr><tr><td>373</td>\n\t\t\t<td>Masco</td>\n\t\t\t<td><a href="http://www.masco.com">http://www.masco.com</a></td>\n\t\t</tr><tr><td>374</td>\n\t\t\t<td>DXC Technology</td>\n\t\t\t<td><a href="http://www.dxc.technology">http://www.dxc.technology</a></td>\n\t\t</tr><tr><td>375</td>\n\t\t\t<td>Auto-Owners Insurance</td>\n\t\t\t<td><a href="http://www.auto-owners.com">http://www.auto-owners.com</a></td>\n\t\t</tr><tr><td>376</td>\n\t\t\t<td>Jones Financial (Edward Jones)</td>\n\t\t\t<td><a href="www.iqvia.comwww.edwardjones.com">www.iqvia.comwww.edwardjones.com</a></td>\n\t\t</tr><tr><td>377</td>\n\t\t\t<td>Liberty Media</td>\n\t\t\t<td><a href="http://www.libertymedia.com">http://www.libertymedia.com</a></td>\n\t\t</tr><tr><td>378</td>\n\t\t\t<td>Erie Insurance Group</td>\n\t\t\t<td><a href="http://www.erieinsurance.com">http://www.erieinsurance.com</a></td>\n\t\t</tr><tr><td>379</td>\n\t\t\t<td>Hershey</td>\n\t\t\t<td><a href="http://www.thehersheycompany.com">http://www.thehersheycompany.com</a></td>\n\t\t</tr><tr><td>380</td>\n\t\t\t<td>PPL</td>\n\t\t\t<td><a href="http://www.pplweb.com">http://www.pplweb.com</a></td>\n\t\t</tr><tr><td>381</td>\n\t\t\t<td>Huntington Ingalls Industries</td>\n\t\t\t<td><a href="http://www.huntingtoningalls.com">http://www.huntingtoningalls.com</a></td>\n\t\t</tr><tr><td>382</td>\n\t\t\t<td>Mosaic</td>\n\t\t\t<td><a href="http://www.mosaicco.com">http://www.mosaicco.com</a></td>\n\t\t</tr><tr><td>383</td>\n\t\t\t<td>J.M. Smucker</td>\n\t\t\t<td><a href="http://www.jmsmucker.com">http://www.jmsmucker.com</a></td>\n\t\t</tr><tr><td>384</td>\n\t\t\t<td>Delek US Holdings</td>\n\t\t\t<td><a href="http://www.delekus.com">http://www.delekus.com</a></td>\n\t\t</tr><tr><td>385</td>\n\t\t\t<td>Newmont Mining</td>\n\t\t\t<td><a href="http://www.newmont.com">http://www.newmont.com</a></td>\n\t\t</tr><tr><td>386</td>\n\t\t\t<td>Constellation Brands</td>\n\t\t\t<td><a href="http://www.cbrands.com">http://www.cbrands.com</a></td>\n\t\t</tr><tr><td>387</td>\n\t\t\t<td>Ryder System</td>\n\t\t\t<td><a href="http://www.ryder.com">http://www.ryder.com</a></td>\n\t\t</tr><tr><td>388</td>\n\t\t\t<td>National Oilwell Varco</td>\n\t\t\t<td><a href="http://www.nov.com">http://www.nov.com</a></td>\n\t\t</tr><tr><td>389</td>\n\t\t\t<td>Adobe Systems</td>\n\t\t\t<td><a href="http://www.adobe.com">http://www.adobe.com</a></td>\n\t\t</tr><tr><td>390</td>\n\t\t\t<td>LifePoint Health</td>\n\t\t\t<td><a href="http://www.lifepointhealth.net">http://www.lifepointhealth.net</a></td>\n\t\t</tr><tr><td>391</td>\n\t\t\t<td>Tractor Supply</td>\n\t\t\t<td><a href="http://www.tractorsupply.com">http://www.tractorsupply.com</a></td>\n\t\t</tr><tr><td>392</td>\n\t\t\t<td>Thor Industries</td>\n\t\t\t<td><a href="http://www.thorindustries.com">http://www.thorindustries.com</a></td>\n\t\t</tr><tr><td>393</td>\n\t\t\t<td>Dana</td>\n\t\t\t<td><a href="http://www.dana.com">http://www.dana.com</a></td>\n\t\t</tr><tr><td>394</td>\n\t\t\t<td>Weyerhaeuser</td>\n\t\t\t<td><a href="http://www.weyerhaeuser.com">http://www.weyerhaeuser.com</a></td>\n\t\t</tr><tr><td>395</td>\n\t\t\t<td>J.B. Hunt Transport Services</td>\n\t\t\t<td><a href="http://www.jbhunt.com">http://www.jbhunt.com</a></td>\n\t\t</tr><tr><td>396</td>\n\t\t\t<td>Darden Restaurants</td>\n\t\t\t<td><a href="http://www.darden.com">http://www.darden.com</a></td>\n\t\t</tr><tr><td>397</td>\n\t\t\t<td>Yum China Holdings</td>\n\t\t\t<td><a href="http://ir.yumchina.com">http://ir.yumchina.com</a></td>\n\t\t</tr><tr><td>398</td>\n\t\t\t<td>Blackstone Group</td>\n\t\t\t<td><a href="http://www.blackstone.com">http://www.blackstone.com</a></td>\n\t\t</tr><tr><td>399</td>\n\t\t\t<td>Berry Global Group</td>\n\t\t\t<td><a href="http://www.berryglobal.com">http://www.berryglobal.com</a></td>\n\t\t</tr><tr><td>400</td>\n\t\t\t<td>Builders FirstSource</td>\n\t\t\t<td><a href="http://www.bldr.com">http://www.bldr.com</a></td>\n\t\t</tr><tr><td>401</td>\n\t\t\t<td>Activision Blizzard</td>\n\t\t\t<td><a href="http://www.activisionblizzard.com">http://www.activisionblizzard.com</a></td>\n\t\t</tr><tr><td>402</td>\n\t\t\t<td>JetBlue Airways</td>\n\t\t\t<td><a href="http://www.jetblue.com">http://www.jetblue.com</a></td>\n\t\t</tr><tr><td>403</td>\n\t\t\t<td>Amphenol</td>\n\t\t\t<td><a href="http://www.amphenol.com">http://www.amphenol.com</a></td>\n\t\t</tr><tr><td>404</td>\n\t\t\t<td>A-Mark Precious Metals</td>\n\t\t\t<td><a href="http://www.amark.com">http://www.amark.com</a></td>\n\t\t</tr><tr><td>405</td>\n\t\t\t<td>Spirit AeroSystems Holdings</td>\n\t\t\t<td><a href="http://www.spiritaero.com">http://www.spiritaero.com</a></td>\n\t\t</tr><tr><td>406</td>\n\t\t\t<td>R.R. Donnelley &amp; Sons</td>\n\t\t\t<td><a href="http://www.rrdonnelley.com">http://www.rrdonnelley.com</a></td>\n\t\t</tr><tr><td>407</td>\n\t\t\t<td>Harris</td>\n\t\t\t<td><a href="http://www.harris.com">http://www.harris.com</a></td>\n\t\t</tr><tr><td>408</td>\n\t\t\t<td>Expeditors Intl. of Washington</td>\n\t\t\t<td><a href="http://www.expeditors.com">http://www.expeditors.com</a></td>\n\t\t</tr><tr><td>409</td>\n\t\t\t<td>Discovery</td>\n\t\t\t<td><a href="http://www.discovery.com">http://www.discovery.com</a></td>\n\t\t</tr><tr><td>410</td>\n\t\t\t<td>Owens-Illinois</td>\n\t\t\t<td><a href="http://www.o-i.com">http://www.o-i.com</a></td>\n\t\t</tr><tr><td>411</td>\n\t\t\t<td>Sanmina</td>\n\t\t\t<td><a href="http://www.sanmina.com">http://www.sanmina.com</a></td>\n\t\t</tr><tr><td>412</td>\n\t\t\t<td>KeyCorp</td>\n\t\t\t<td><a href="http://www.key.com">http://www.key.com</a></td>\n\t\t</tr><tr><td>413</td>\n\t\t\t<td>American Financial Group</td>\n\t\t\t<td><a href="http://www.afginc.com">http://www.afginc.com</a></td>\n\t\t</tr><tr><td>414</td>\n\t\t\t<td>Oshkosh</td>\n\t\t\t<td><a href="http://www.oshkoshcorporation.com">http://www.oshkoshcorporation.com</a></td>\n\t\t</tr><tr><td>415</td>\n\t\t\t<td>Rockwell Collins</td>\n\t\t\t<td><a href="http://www.rockwellcollins.com">http://www.rockwellcollins.com</a></td>\n\t\t</tr><tr><td>416</td>\n\t\t\t<td>Kindred Healthcare</td>\n\t\t\t<td><a href="http://www.kindredhealthcare.com">http://www.kindredhealthcare.com</a></td>\n\t\t</tr><tr><td>417</td>\n\t\t\t<td>Insight Enterprises</td>\n\t\t\t<td><a href="http://www.insight.com">http://www.insight.com</a></td>\n\t\t</tr><tr><td>418</td>\n\t\t\t<td>Dr Pepper Snapple Group</td>\n\t\t\t<td><a href="http://www.drpeppersnapplegroup.com">http://www.drpeppersnapplegroup.com</a></td>\n\t\t</tr><tr><td>419</td>\n\t\t\t<td>American Tower</td>\n\t\t\t<td><a href="http://www.americantower.com">http://www.americantower.com</a></td>\n\t\t</tr><tr><td>420</td>\n\t\t\t<td>Fortive</td>\n\t\t\t<td><a href="http://www.fortive.com">http://www.fortive.com</a></td>\n\t\t</tr><tr><td>421</td>\n\t\t\t<td>Ralph Lauren</td>\n\t\t\t<td><a href="http://www.ralphlauren.com">http://www.ralphlauren.com</a></td>\n\t\t</tr><tr><td>422</td>\n\t\t\t<td>HRG Group</td>\n\t\t\t<td><a href="http://www.hrggroup.com">http://www.hrggroup.com</a></td>\n\t\t</tr><tr><td>423</td>\n\t\t\t<td>Ascena Retail Group</td>\n\t\t\t<td><a href="http://www.ascenaretail.com">http://www.ascenaretail.com</a></td>\n\t\t</tr><tr><td>424</td>\n\t\t\t<td>United Rentals</td>\n\t\t\t<td><a href="http://www.unitedrentals.com">http://www.unitedrentals.com</a></td>\n\t\t</tr><tr><td>425</td>\n\t\t\t<td>Casey\xe2\x80\x99s General Stores</td>\n\t\t\t<td><a href="http://www.caseys.com">http://www.caseys.com</a></td>\n\t\t</tr><tr><td>426</td>\n\t\t\t<td>Graybar Electric</td>\n\t\t\t<td><a href="http://www.graybar.com">http://www.graybar.com</a></td>\n\t\t</tr><tr><td>427</td>\n\t\t\t<td>Avery Dennison</td>\n\t\t\t<td><a href="http://www.averydennison.com">http://www.averydennison.com</a></td>\n\t\t</tr><tr><td>428</td>\n\t\t\t<td>MasTec</td>\n\t\t\t<td><a href="http://www.mastec.com">http://www.mastec.com</a></td>\n\t\t</tr><tr><td>429</td>\n\t\t\t<td>CMS Energy</td>\n\t\t\t<td><a href="http://www.cmsenergy.com">http://www.cmsenergy.com</a></td>\n\t\t</tr><tr><td>430</td>\n\t\t\t<td>HD Supply Holdings</td>\n\t\t\t<td><a href="http://www.hdsupply.com">http://www.hdsupply.com</a></td>\n\t\t</tr><tr><td>431</td>\n\t\t\t<td>Raymond James Financial</td>\n\t\t\t<td><a href="http://www.raymondjames.com">http://www.raymondjames.com</a></td>\n\t\t</tr><tr><td>432</td>\n\t\t\t<td>NCR</td>\n\t\t\t<td><a href="http://www.ncr.com">http://www.ncr.com</a></td>\n\t\t</tr><tr><td>433</td>\n\t\t\t<td>Hanesbrands</td>\n\t\t\t<td><a href="http://www.hanes.com">http://www.hanes.com</a></td>\n\t\t</tr><tr><td>434</td>\n\t\t\t<td>Asbury Automotive Group</td>\n\t\t\t<td><a href="http://www.asburyauto.com">http://www.asburyauto.com</a></td>\n\t\t</tr><tr><td>435</td>\n\t\t\t<td>Citizens Financial Group</td>\n\t\t\t<td><a href="http://www.citizensbank.com">http://www.citizensbank.com</a></td>\n\t\t</tr><tr><td>436</td>\n\t\t\t<td>Packaging Corp. of America</td>\n\t\t\t<td><a href="http://www.packagingcorp.com">http://www.packagingcorp.com</a></td>\n\t\t</tr><tr><td>437</td>\n\t\t\t<td>Alleghany</td>\n\t\t\t<td><a href="http://www.alleghany.com">http://www.alleghany.com</a></td>\n\t\t</tr><tr><td>438</td>\n\t\t\t<td>Apache</td>\n\t\t\t<td><a href="http://www.apachecorp.com">http://www.apachecorp.com</a></td>\n\t\t</tr><tr><td>439</td>\n\t\t\t<td>Dillard\xe2\x80\x99s</td>\n\t\t\t<td><a href="http://www.dillards.com">http://www.dillards.com</a></td>\n\t\t</tr><tr><td>440</td>\n\t\t\t<td>Assurant</td>\n\t\t\t<td><a href="http://www.assurant.com">http://www.assurant.com</a></td>\n\t\t</tr><tr><td>441</td>\n\t\t\t<td>Franklin Resources</td>\n\t\t\t<td><a href="http://www.franklinresources.com">http://www.franklinresources.com</a></td>\n\t\t</tr><tr><td>442</td>\n\t\t\t<td>Owens Corning</td>\n\t\t\t<td><a href="http://www.owenscorning.com">http://www.owenscorning.com</a></td>\n\t\t</tr><tr><td>443</td>\n\t\t\t<td>Motorola Solutions</td>\n\t\t\t<td><a href="http://www.motorolasolutions.com">http://www.motorolasolutions.com</a></td>\n\t\t</tr><tr><td>444</td>\n\t\t\t<td>NVR</td>\n\t\t\t<td><a href="http://www.nvrinc.com">http://www.nvrinc.com</a></td>\n\t\t</tr><tr><td>445</td>\n\t\t\t<td>Rockwell Automation</td>\n\t\t\t<td><a href="http://www.rockwellautomation.com">http://www.rockwellautomation.com</a></td>\n\t\t</tr><tr><td>446</td>\n\t\t\t<td>TreeHouse Foods</td>\n\t\t\t<td><a href="http://www.treehousefoods.com">http://www.treehousefoods.com</a></td>\n\t\t</tr><tr><td>447</td>\n\t\t\t<td>Wynn Resorts</td>\n\t\t\t<td><a href="http://www.wynnresorts.com">http://www.wynnresorts.com</a></td>\n\t\t</tr><tr><td>448</td>\n\t\t\t<td>Olin</td>\n\t\t\t<td><a href="http://www.olin.com">http://www.olin.com</a></td>\n\t\t</tr><tr><td>449</td>\n\t\t\t<td>American Axle &amp; Manufacturing</td>\n\t\t\t<td><a href="http://www.aam.com">http://www.aam.com</a></td>\n\t\t</tr><tr><td>450</td>\n\t\t\t<td>Old Republic International</td>\n\t\t\t<td><a href="http://www.oldrepublic.com">http://www.oldrepublic.com</a></td>\n\t\t</tr><tr><td>451</td>\n\t\t\t<td>Chemours</td>\n\t\t\t<td><a href="http://www.chemours.com">http://www.chemours.com</a></td>\n\t\t</tr><tr><td>452</td>\n\t\t\t<td>iHeartMedia</td>\n\t\t\t<td><a href="http://www.iheartmedia.com">http://www.iheartmedia.com</a></td>\n\t\t</tr><tr><td>453</td>\n\t\t\t<td>Ameren</td>\n\t\t\t<td><a href="http://www.ameren.com">http://www.ameren.com</a></td>\n\t\t</tr><tr><td>454</td>\n\t\t\t<td>Arthur J. Gallagher</td>\n\t\t\t<td><a href="http://www.ajg.com">http://www.ajg.com</a></td>\n\t\t</tr><tr><td>455</td>\n\t\t\t<td>Celanese</td>\n\t\t\t<td><a href="http://www.celanese.com">http://www.celanese.com</a></td>\n\t\t</tr><tr><td>456</td>\n\t\t\t<td>Sealed Air</td>\n\t\t\t<td><a href="http://www.sealedair.com">http://www.sealedair.com</a></td>\n\t\t</tr><tr><td>457</td>\n\t\t\t<td>UGI</td>\n\t\t\t<td><a href="http://www.ugicorp.com">http://www.ugicorp.com</a></td>\n\t\t</tr><tr><td>458</td>\n\t\t\t<td>Realogy Holdings</td>\n\t\t\t<td><a href="http://www.realogy.com">http://www.realogy.com</a></td>\n\t\t</tr><tr><td>459</td>\n\t\t\t<td>Burlington Stores</td>\n\t\t\t<td><a href="http://www.burlington.com">http://www.burlington.com</a></td>\n\t\t</tr><tr><td>460</td>\n\t\t\t<td>Regions Financial</td>\n\t\t\t<td><a href="http://www.regions.com">http://www.regions.com</a></td>\n\t\t</tr><tr><td>461</td>\n\t\t\t<td>AK Steel Holding</td>\n\t\t\t<td><a href="http://www.aksteel.com">http://www.aksteel.com</a></td>\n\t\t</tr><tr><td>462</td>\n\t\t\t<td>Securian Financial Group</td>\n\t\t\t<td><a href="http://www.securian.com">http://www.securian.com</a></td>\n\t\t</tr><tr><td>463</td>\n\t\t\t<td>S&amp;P Global</td>\n\t\t\t<td><a href="http://www.spglobal.com">http://www.spglobal.com</a></td>\n\t\t</tr><tr><td>464</td>\n\t\t\t<td>Markel</td>\n\t\t\t<td><a href="http://www.markelcorp.com">http://www.markelcorp.com</a></td>\n\t\t</tr><tr><td>465</td>\n\t\t\t<td>TravelCenters of America</td>\n\t\t\t<td><a href="http://www.ta-petro.com">http://www.ta-petro.com</a></td>\n\t\t</tr><tr><td>466</td>\n\t\t\t<td>Conduent</td>\n\t\t\t<td><a href="http://www.conduent.com">http://www.conduent.com</a></td>\n\t\t</tr><tr><td>467</td>\n\t\t\t<td>M&amp;T Bank Corp.</td>\n\t\t\t<td><a href="http://www.mtb.com">http://www.mtb.com</a></td>\n\t\t</tr><tr><td>468</td>\n\t\t\t<td>Clorox</td>\n\t\t\t<td><a href="http://www.thecloroxcompany.com">http://www.thecloroxcompany.com</a></td>\n\t\t</tr><tr><td>469</td>\n\t\t\t<td>AmTrust Financial Services</td>\n\t\t\t<td><a href="http://www.amtrustfinancial.com">http://www.amtrustfinancial.com</a></td>\n\t\t</tr><tr><td>470</td>\n\t\t\t<td>KKR</td>\n\t\t\t<td><a href="http://www.kkr.com">http://www.kkr.com</a></td>\n\t\t</tr><tr><td>471</td>\n\t\t\t<td>Ulta Beauty</td>\n\t\t\t<td><a href="http://www.ulta.com">http://www.ulta.com</a></td>\n\t\t</tr><tr><td>472</td>\n\t\t\t<td>Yum Brands</td>\n\t\t\t<td><a href="http://www.yum.com">http://www.yum.com</a></td>\n\t\t</tr><tr><td>473</td>\n\t\t\t<td>Regeneron Pharmaceuticals</td>\n\t\t\t<td><a href="http://www.regeneron.com">http://www.regeneron.com</a></td>\n\t\t</tr><tr><td>474</td>\n\t\t\t<td>Windstream Holdings</td>\n\t\t\t<td><a href="http://www.windstream.com">http://www.windstream.com</a></td>\n\t\t</tr><tr><td>475</td>\n\t\t\t<td>Magellan Health</td>\n\t\t\t<td><a href="http://www.magellanhealth.com">http://www.magellanhealth.com</a></td>\n\t\t</tr><tr><td>476</td>\n\t\t\t<td>Western &amp; Southern Financial</td>\n\t\t\t<td><a href="http://www.westernsouthern.com">http://www.westernsouthern.com</a></td>\n\t\t</tr><tr><td>477</td>\n\t\t\t<td>Intercontinental Exchange</td>\n\t\t\t<td><a href="http://www.theice.com">http://www.theice.com</a></td>\n\t\t</tr><tr><td>478</td>\n\t\t\t<td>Ingredion</td>\n\t\t\t<td><a href="http://www.ingredion.com">http://www.ingredion.com</a></td>\n\t\t</tr><tr><td>479</td>\n\t\t\t<td>Wyndham Destinations</td>\n\t\t\t<td><a href="http://www.wyndhamdestinations.com">http://www.wyndhamdestinations.com</a></td>\n\t\t</tr><tr><td>480</td>\n\t\t\t<td>Toll Brothers</td>\n\t\t\t<td><a href="http://www.tollbrothers.com">http://www.tollbrothers.com</a></td>\n\t\t</tr><tr><td>481</td>\n\t\t\t<td>Seaboard</td>\n\t\t\t<td><a href="http://www.seaboardcorp.com">http://www.seaboardcorp.com</a></td>\n\t\t</tr><tr><td>482</td>\n\t\t\t<td>Booz Allen Hamilton</td>\n\t\t\t<td><a href="http://www.boozallen.com">http://www.boozallen.com</a></td>\n\t\t</tr><tr><td>483</td>\n\t\t\t<td>First American Financial</td>\n\t\t\t<td><a href="http://www.firstam.com">http://www.firstam.com</a></td>\n\t\t</tr><tr><td>484</td>\n\t\t\t<td>Cincinnati Financial</td>\n\t\t\t<td><a href="http://www.cinfin.com">http://www.cinfin.com</a></td>\n\t\t</tr><tr><td>485</td>\n\t\t\t<td>Avon Products</td>\n\t\t\t<td><a href="http://www.avoninvestor.com">http://www.avoninvestor.com</a></td>\n\t\t</tr><tr><td>486</td>\n\t\t\t<td>Northern Trust</td>\n\t\t\t<td><a href="http://www.northerntrust.com">http://www.northerntrust.com</a></td>\n\t\t</tr><tr><td>487</td>\n\t\t\t<td>Fiserv</td>\n\t\t\t<td><a href="http://www.fiserv.com">http://www.fiserv.com</a></td>\n\t\t</tr><tr><td>488</td>\n\t\t\t<td>Harley-Davidson</td>\n\t\t\t<td><a href="http://www.harley-davidson.com">http://www.harley-davidson.com</a></td>\n\t\t</tr><tr><td>489</td>\n\t\t\t<td>Cheniere Energy</td>\n\t\t\t<td><a href="http://www.cheniere.com">http://www.cheniere.com</a></td>\n\t\t</tr><tr><td>490</td>\n\t\t\t<td>Patterson</td>\n\t\t\t<td><a href="http://www.pattersoncompanies.com">http://www.pattersoncompanies.com</a></td>\n\t\t</tr><tr><td>491</td>\n\t\t\t<td>Peabody Energy</td>\n\t\t\t<td><a href="http://www.peabodyenergy.com">http://www.peabodyenergy.com</a></td>\n\t\t</tr><tr><td>492</td>\n\t\t\t<td>ON Semiconductor</td>\n\t\t\t<td><a href="http://www.onsemi.com">http://www.onsemi.com</a></td>\n\t\t</tr><tr><td>493</td>\n\t\t\t<td>Simon Property Group</td>\n\t\t\t<td><a href="http://www.simon.com">http://www.simon.com</a></td>\n\t\t</tr><tr><td>494</td>\n\t\t\t<td>Western Union</td>\n\t\t\t<td><a href="http://www.westernunion.com">http://www.westernunion.com</a></td>\n\t\t</tr><tr><td>495</td>\n\t\t\t<td>NetApp</td>\n\t\t\t<td><a href="http://www.netapp.com">http://www.netapp.com</a></td>\n\t\t</tr><tr><td>496</td>\n\t\t\t<td>Polaris Industries</td>\n\t\t\t<td><a href="http://www.polaris.com">http://www.polaris.com</a></td>\n\t\t</tr><tr><td>497</td>\n\t\t\t<td>Pioneer Natural Resources</td>\n\t\t\t<td><a href="http://www.pxd.com">http://www.pxd.com</a></td>\n\t\t</tr><tr><td>498</td>\n\t\t\t<td>ABM Industries</td>\n\t\t\t<td><a href="http://www.abm.com">http://www.abm.com</a></td>\n\t\t</tr><tr><td>499</td>\n\t\t\t<td>Vistra Energy</td>\n\t\t\t<td><a href="http://www.vistraenergy.com">http://www.vistraenergy.com</a></td>\n\t\t</tr><tr><td>500</td>\n\t\t\t<td>Cintas</td>\n\t\t\t<td><a href="http://www.cintas.com">http://www.cintas.com</a></td>\n\t\t</tr></tbody></table><p>\xc2\xa0</p>\n\n<p>The source data for this list is from <a href="http://fortune.com/fortune500/">http://fortune.com/fortune500/</a> and the data is available as a google spreadsheet at <a href="http://bit.ly/1kkTv2A">http://bit.ly/1kkTv2A</a>. You can also check out the list of fortune 500 companies for previous years.</p>\n\n<p>\xc2\xa0</p>\n\n<p>\xc2\xa0</p>\n\n<ul><li><a href="/articles/4404/list-of-fortune-500-companies-and-their-websites-2014">List of fortune 500 companies for 2014</a></li>\n\t<li><a href="/articles/5363/list-of-fortune-500-companies-and-their-websites-2015">List of fortune 500 companies for 2015</a></li>\n\t<li><a href="/articles/5826/list-of-fortune-500-companies-and-their-websites-2016">List of fortune 500 companies for 2016</a></li>\n\t<li><a href="/articles/5827/list-of-fortune-500-companies-and-their-websites-2017">List of fortune 500 companies for 2017</a></li>\n</ul><p>\xc2\xa0</p>\n</div>\n      \n    </div>\n    <div class="zyxpro-casestudy-article-tag">\n        \n      <div class="field field--taxonomy-vocabulary-2">\n              <div><a href="/categories/misc" hreflang="en">Misc</a></div>\n              <div><a href="/categories/lists" hreflang="en">Lists</a></div>\n          </div>\n  \n    </div>\n    <div class="horizontal-row">\n      <hr>\n    </div>\n    <div class="related-zyxpro-casestudy-article-block">\n      <div class="relative-zyxpro-casestudy-article-title">\n        <h2>RELATED ARTICLE</h2>\n      </div>\n      <div class="article-full-related-articles">  <article data-history-node-id="3384" role="article" about="/articles/3384/the-history-of-the-modern-calendar-infographic" class="story is-promoted teaser-insights">\n\n  \n          \n  <div class="content">\n    <div class="insight-content">\n            <div class="insight-images placeholderimage">\n        <img src="/themes/custom/zyxpro_light/images/placeholder.png" alt="/themes/custom/zyxpro_light/images/placeholder.png">\n      </div>\n            <div class="insight-contents card">\n        <div class="insight-title truncate">\n          <a href="/articles/3384/the-history-of-the-modern-calendar-infographic"> <div class="title"><span>The history of the modern calendar - Infographic</span>\n</div> </a>\n        </div>\n        <div class="card-content insights-body ">\n          <div class="activator row field--field-tags">\n            <div class="col l10 m10 s10 truncate">\n              <a href="/categories/infographics" hreflang="en">Infographics</a>\n              <a href="/categories/misc" hreflang="en">Misc</a>\n            </div>\n            <div class="col l2 m2 s2">\n              <i class="material-icons">more_horiz</i>\n            </div>\n          </div>\n        </div>\n        <div class="card-reveal card-addtoany">\n          <span class="card-title grey-text text-darken-4"><i class="material-icons right">close</i></span>\n          <p> <span class="a2a_kit a2a_kit_size_32 addtoany_list" data-a2a-url="https://www.zyxware.com/articles/3384/the-history-of-the-modern-calendar-infographic" data-a2a-title="The history of the modern calendar - Infographic"><a class="a2a_dd addtoany_share" href="https://www.addtoany.com/share#url=https%3A%2F%2Fwww.zyxware.com%2Farticles%2F3384%2Fthe-history-of-the-modern-calendar-infographic&amp;title=The%20history%20of%20the%20modern%20calendar%20-%20Infographic"></a><a class="a2a_button_facebook"></a><a class="a2a_button_twitter"></a><a class="a2a_button_linkedin"></a></span> </p>\n        </div>\n        <div class="author-info truncate">\n          on <span>01st January 2013</span>\n / by <span><a title="View user profile." href="/user/webmaster" lang="" about="/user/webmaster" typeof="Person" property="schema:name" datatype="">webmaster</a></span>\n          \n        </div>\n        \n        <div class="insight-body">\n                                \n            Did you know that year 2013 is the first year after 1987 which had all its digits as distinct. Did you know that Oct 1582 had 10 days removed from the month to adjust for the shift in the year? Did you know that Sumerians had calendars way back in 4000BC?. Here are some interesting pieces of information about the history of calendars.\n\n      \n      \n              Infographics\n              Misc\n              Fun Stuff\n          \n  \n\n      \n      Leave a reply\n      Your email address will not be published. Required fields are marked *\n      \n    \n     \n      \n  \n  \n\n\n          \n          \n        </div>\n      </div>\n    </div>\n  </div>\n\n</article>\n  <article data-history-node-id="4344" role="article" about="/articles/4344/list-of-fortune-500-companies-and-their-websites" class="story teaser-insights">\n\n  \n          \n  <div class="content">\n    <div class="insight-content">\n            <div class="insight-images placeholderimage">\n        <img src="/themes/custom/zyxpro_light/images/placeholder.png" alt="/themes/custom/zyxpro_light/images/placeholder.png">\n      </div>\n            <div class="insight-contents card">\n        <div class="insight-title truncate">\n          <a href="/articles/4344/list-of-fortune-500-companies-and-their-websites"> <div class="title"><span>List of Fortune 500 companies and their websites</span>\n</div> </a>\n        </div>\n        <div class="card-content insights-body ">\n          <div class="activator row field--field-tags">\n            <div class="col l10 m10 s10 truncate">\n              <a href="/categories/misc" hreflang="en">Misc</a>\n              <a href="/categories/lists" hreflang="en">Lists</a>\n            </div>\n            <div class="col l2 m2 s2">\n              <i class="material-icons">more_horiz</i>\n            </div>\n          </div>\n        </div>\n        <div class="card-reveal card-addtoany">\n          <span class="card-title grey-text text-darken-4"><i class="material-icons right">close</i></span>\n          <p> <span class="a2a_kit a2a_kit_size_32 addtoany_list" data-a2a-url="https://www.zyxware.com/articles/4344/list-of-fortune-500-companies-and-their-websites" data-a2a-title="List of Fortune 500 companies and their websites"><a class="a2a_dd addtoany_share" href="https://www.addtoany.com/share#url=https%3A%2F%2Fwww.zyxware.com%2Farticles%2F4344%2Flist-of-fortune-500-companies-and-their-websites&amp;title=List%20of%20Fortune%20500%20companies%20and%20their%20websites"></a><a class="a2a_button_facebook"></a><a class="a2a_button_twitter"></a><a class="a2a_button_linkedin"></a></span> </p>\n        </div>\n        <div class="author-info truncate">\n          on <span>08th July 2014</span>\n / by <span><a title="View user profile." href="/user/webmaster" lang="" about="/user/webmaster" typeof="Person" property="schema:name" datatype="">webmaster</a></span>\n          \n        </div>\n        \n        <div class="insight-body">\n                                \n            Fortune magazine publishes a list of the largest companies in the US by revenue every year. Here is the list of fortune 500 companies for the year 2019 and their websites. \nDownload the full list\n\n      \n      \n              Misc\n              Lists\n          \n  \n\n     \n      \n\n  \n\n\n  \n        \n    \n      \n        \n          \n        \n      \n      \n        \n          \n            Mohamed Faizal (not verified)\n          \n                    \n            access_time\n            \n              23 Feb 2020 - 20:16\n             \n          \n                    \n                  \n\n        \n                      \n                        \n                    \n            \n            I have more Intrested to join high reputed company .\n\n      \n          \n        \n      \n    \n  \n\n\n\n  \n\n\n  \n        \n    \n      \n        \n          \n        \n      \n      \n        \n          \n            anon (not verified)\n          \n                    \n            access_time\n            \n              23 Feb 2020 - 20:16\n             \n          \n                    \n                  \n\n        \n                      \n                        \n                    \n            \n            data is available as a google spreadsheet at http://bit.ly/1mFsbAe\n\n      \n          \n        \n      \n    \n  \n\n\n\n\n  \n\n\n  \n        \n    \n      \n        \n          \n        \n      \n      \n        \n          \n            webmaster\n          \n                    \n            access_time\n            \n              23 Feb 2020 - 20:16\n             \n          \n                                In reply to data not linked correctly by anon (not verified)\n          \n                  \n\n        \n                      \n                        \n                    \n            \n            Thanks for the pointer. Have corrected link in the article.\n\n      \n          \n        \n      \n    \n  \n\n\n\n  \n\n\n  \n        \n    \n      \n        \n          \n        \n      \n      \n        \n          \n            Aashika (not verified)\n          \n                    \n            access_time\n            \n              23 Feb 2020 - 20:16\n             \n          \n                    \n                  \n\n        \n                      \n                        \n                    \n            \n            List looks helpful. Thanks!\n\n      \n          \n        \n      \n    \n  \n\n\n\n  \n\n\n  \n        \n    \n      \n        \n          \n        \n      \n      \n        \n          \n            David Bowman (not verified)\n          \n                    \n            access_time\n            \n              23 Feb 2020 - 20:16\n             \n          \n                    \n                  \n\n        \n                      \n                        \n                    \n            \n            Hello:\nDo you have the 2015 Fortune 500 list available?\nRegards,\nDavidhttp://www.orgchartcity.com\n\n      \n          \n        \n      \n    \n  \n\n  \n    Pagination\n    \n                                                        \n                                          \n            \n              Current page\n            1\n        \n              \n                                          \n            \n              Page\n            2\n        \n                                      \n          \n            Next page\n            Next \xe2\x80\xba\n          \n        \n                          \n          \n            Last page\n            Last \xc2\xbb\n          \n        \n          \n  \n\n  \n  \n\n\n          \n          \n        </div>\n      </div>\n    </div>\n  </div>\n\n</article>\n  <article data-history-node-id="4351" role="article" about="/articles/4351/list-of-fortune-500-companies-using-drupal-for-their-websites" class="story teaser-insights">\n\n  \n          \n  <div class="content">\n    <div class="insight-content">\n            <div class="insight-images placeholderimage">\n        <img src="/themes/custom/zyxpro_light/images/placeholder.png" alt="/themes/custom/zyxpro_light/images/placeholder.png">\n      </div>\n            <div class="insight-contents card">\n        <div class="insight-title truncate">\n          <a href="/articles/4351/list-of-fortune-500-companies-using-drupal-for-their-websites"> <div class="title"><span>List of Fortune 500 companies using Drupal for their websites</span>\n</div> </a>\n        </div>\n        <div class="card-content insights-body ">\n          <div class="activator row field--field-tags">\n            <div class="col l10 m10 s10 truncate">\n              <a href="/categories/drupal" hreflang="en">Drupal</a>\n              <a href="/categories/lists" hreflang="en">Lists</a>\n            </div>\n            <div class="col l2 m2 s2">\n              <i class="material-icons">more_horiz</i>\n            </div>\n          </div>\n        </div>\n        <div class="card-reveal card-addtoany">\n          <span class="card-title grey-text text-darken-4"><i class="material-icons right">close</i></span>\n          <p> <span class="a2a_kit a2a_kit_size_32 addtoany_list" data-a2a-url="https://www.zyxware.com/articles/4351/list-of-fortune-500-companies-using-drupal-for-their-websites" data-a2a-title="List of Fortune 500 companies using Drupal for their websites"><a class="a2a_dd addtoany_share" href="https://www.addtoany.com/share#url=https%3A%2F%2Fwww.zyxware.com%2Farticles%2F4351%2Flist-of-fortune-500-companies-using-drupal-for-their-websites&amp;title=List%20of%20Fortune%20500%20companies%20using%20Drupal%20for%20their%20websites"></a><a class="a2a_button_facebook"></a><a class="a2a_button_twitter"></a><a class="a2a_button_linkedin"></a></span> </p>\n        </div>\n        <div class="author-info truncate">\n          on <span>13th July 2014</span>\n / by <span><a title="View user profile." href="/user/webmaster" lang="" about="/user/webmaster" typeof="Person" property="schema:name" datatype="">webmaster</a></span>\n          \n        </div>\n        \n        <div class="insight-body">\n                                \n            We had earlier published a list of Fortune 500 companies and their websites. We have evaluated these websites and have identified those that run on Drupal. The following is the list of Fortune 500 companies that use Drupal for their corporate websites. Do note that this is the current list of fortune 500 companies for year 2019.\n\n      \n      \n              Drupal\n              Lists\n              Marketing Drupal\n              Misc\n          \n  \n\n      \n      Leave a reply\n      Your email address will not be published. Required fields are marked *\n      \n    \n     \n      \n\n  \n\n\n  \n        \n    \n      \n        \n          \n        \n      \n      \n        \n          \n            Kate (not verified)\n          \n                    \n            access_time\n            \n              23 Feb 2020 - 20:16\n             \n          \n                    \n                  \n\n        \n                      \n                        \n                    \n            \n            I blog quite often and I seriously appreciate your content.\nYour article has really peaked my interest. I\nam going to take a note of your website and keep checking\nfor new details about once per week. I opted in for your RSS feed\nas well.\n\n      \n          \n        \n      \n    \n  \n\n  \n    Pagination\n    \n                                                        \n                                          \n            \n              Current page\n            1\n        \n              \n                                          \n            \n              Page\n            2\n        \n                                      \n          \n            Next page\n            Next \xe2\x80\xba\n          \n        \n                          \n          \n            Last page\n            Last \xc2\xbb\n          \n        \n          \n  \n\n  \n  \n\nAdd new comment\n          \n          \n        </div>\n      </div>\n    </div>\n  </div>\n\n</article>\n</div>\n    </div>\n     <div class="zyxpro-casestudy-article-comment">\n        <section>\n\n      <div class="comments-wrapper">\n      <h6>Leave a reply</h6>\n      <h5>Your email address will not be published. Required fields are marked *</h5>\n      <form class="comment-comment-node-story-form comment-form" data-user-info-from-browser data-drupal-selector="comment-form" action="/comment/reply/node/5914/comment_node_story" method="post" id="comment-form" accept-charset="UTF-8">\n  <div class="field--type-text-long field--name-comment-body field--widget-text-textarea js-form-wrapper form-wrapper" data-drupal-selector="edit-comment-body-wrapper" id="edit-comment-body-wrapper">\n      <div class="js-text-format-wrapper js-form-item form-item">\n  <div class="js-form-item form-item js-form-type-textarea form-item-comment-body-0-value js-form-item-comment-body-0-value">\n      <label for="edit-comment-body-0-value">Comment</label>\n        <div>\n  <textarea class="js-text-full text-full form-textarea" data-drupal-selector="edit-comment-body-0-value" id="edit-comment-body-0-value" name="comment_body[0][value]" rows="5" cols="60" placeholder=""></textarea>\n</div>\n\n        </div>\n<div class="filter-wrapper js-form-wrapper form-wrapper" data-drupal-selector="edit-comment-body-0-format" id="edit-comment-body-0-format"><div class="filter-help js-form-wrapper form-wrapper" data-drupal-selector="edit-comment-body-0-format-help" id="edit-comment-body-0-format-help"><a href="/filter/tips" target="_blank" data-drupal-selector="edit-comment-body-0-format-help-about" id="edit-comment-body-0-format-help-about">About text formats</a></div>\n<div class="filter-guidelines js-form-wrapper form-wrapper" data-drupal-selector="edit-comment-body-0-format-guidelines" id="edit-comment-body-0-format-guidelines"><div>\n  <h4>Filtered HTML</h4>\n  \n  \n    \n          <ul>\n              <li>Web page addresses and email addresses turn into links automatically.</li>\n              <li>Allowed HTML tags: &lt;a href hreflang&gt; &lt;em&gt; &lt;strong&gt; &lt;cite&gt; &lt;blockquote cite&gt; &lt;code&gt; &lt;ul type&gt; &lt;ol start type=&#039;1 A I&#039;&gt; &lt;li&gt; &lt;dl&gt; &lt;dt&gt; &lt;dd&gt; &lt;h2 id=&#039;jump-*&#039;&gt; &lt;h3 id&gt; &lt;h4 id&gt; &lt;h5 id&gt; &lt;h6 id&gt;</li>\n              <li>Lines and paragraphs break automatically.</li>\n            </ul>\n    \n    \n  \n</div>\n</div>\n</div>\n\n  </div>\n\n  </div>\n<input autocomplete="off" data-drupal-selector="form-tmun3fmt-qdrarz2cefosxay-9ta62fmqn5y-fo8gys" type="hidden" name="form_build_id" value="form-TmuN3fmt-qdrARZ2cEFosxAy_9tA62fMQn5Y_fo8gYs" />\n<input data-drupal-selector="edit-comment-comment-node-story-form" type="hidden" name="form_id" value="comment_comment_node_story_form" />\n<div class="js-form-item form-item js-form-type-textfield form-item-name js-form-item-name">\n      <label for="edit-name" class="js-form-required form-required"></label>\n        <input data-drupal-default-value="Anonymous" placeholder="Name" data-drupal-selector="edit-name" type="text" id="edit-name" name="name" value="" size="30" maxlength="60" class="form-text required" required="required" aria-required="true" />\n\n        </div>\n<div class="js-form-item form-item js-form-type-email form-item-mail js-form-item-mail">\n      <label for="edit-mail" class="js-form-required form-required">Email</label>\n        <input data-drupal-selector="edit-mail" aria-describedby="edit-mail--description" type="email" id="edit-mail" name="mail" value="" size="30" maxlength="64" class="form-email required" required="required" aria-required="true" />\n\n            <div id="edit-mail--description" class="description">\n      The content of this field is kept private and will not be shown publicly.\n    </div>\n  </div>\n<div class="js-form-item form-item js-form-type-url form-item-homepage js-form-item-homepage">\n      <label for="edit-homepage">Homepage</label>\n        <input data-drupal-selector="edit-homepage" type="url" id="edit-homepage" name="homepage" value="" size="30" maxlength="255" class="form-url" />\n\n        </div>\n<div class="field--type-language field--name-langcode field--widget-language-select js-form-wrapper form-wrapper" data-drupal-selector="edit-langcode-wrapper" id="edit-langcode-wrapper">\n      \n  </div>\n  <details class="captcha js-form-wrapper form-wrapper" open="open">\n  <summary role="button" aria-expanded="true" aria-pressed="true">CAPTCHA</summary>\n  This question is for testing whether or not you are a human visitor and to prevent automated spam submissions.\n  <input data-drupal-selector="edit-captcha-sid" type="hidden" name="captcha_sid" value="4842639" />\n<input data-drupal-selector="edit-captcha-token" type="hidden" name="captcha_token" value="ba91fa66dd18f9acd8927c2659c649fc" />\n<input data-drupal-selector="edit-captcha-response" type="hidden" name="captcha_response" value="Google no captcha" />\n<div class="g-recaptcha" data-sitekey="6LdTboIUAAAAAPW25o0eHWwF09_VbxjaGKrFwxKq" data-theme="light" data-type="image" data-size="compact"></div>\n  \n</details>\n\n<div data-drupal-selector="edit-actions" class="form-actions js-form-wrapper form-wrapper" id="edit-actions"><input data-drupal-selector="edit-submit" type="submit" id="edit-submit" name="op" value="Post Comments" class="button button--primary js-form-submit form-submit" />\n</div>\n\n</form>\n\n    </div>\n     <div class="comment-wrap">\n      \n  </div>\n  \n</section>\n\n    </div>\n  </div>\n\n</article>\n\n            </div>\n  \n  </div>\n\n                  </section>\n\n                                      <aside class="col l3 m12 s12" role="complementary">\n                <div class="region--sidebar-second">\n    \n<div id="block-zyxwareaddresses" class="block block--label- block--id-block-content50aedcec-9238-4bd3-b32a-06e8366ce094 block--type-basic">\n      \n        \n          \n            <div class="field field--body"><div class="address-info">\n<div class="address-2">\n<h4>US</h4>\n<span class="sub-title">New Jersey (Head Quarters)</span> <span class="address-line">DxForge Inc<br />\n(A subsidiary of Zyxware Technologies)<br />\n190 Moore St Suite 308,<br />\nHackensack, NJ 07601.</span><br /><br /><span class="sub-title">California Office</span> <span class="address-line">4500 The Woods Dr #224,<br />\nSan Jose, CA 95136.</span>\n\n<div class="contact-us-custom-phone-numbers"><strong>Phone Numbers</strong><br />\nToll free number<br />\nPhone: 1-833-999-9273<br />\nNew Jersey (Head Quarters)<br />\nPhone: +1-201-355-2515<br />\nCalifornia Office<br />\nPhone: +1-408-677-1146</div>\n</div>\n\n<div class="address-3">\n<h4>AUSTRALIA</h4>\n<span class="address-line">Zyxware Technologies Pty Ltd,<br />\n(A subsidiary of Zyxware Technologies)<br />\n8 Excelsa Way, Hillside,<br />\nMelbourne, VIC 3037<br />\nPhone: +61 450 405 000</span></div>\n\n<div class="address-1">\n<h4>INDIA</h4>\n\n<p><span class="sub-title">Technopark Office (Registered Office)</span><br /><span class="address-line">SBC 2205, II Floor, Yamuna Building,<br />\nTechnopark Phase III campus,<br />\nTrivandrum, Kerala - 695581 </span></p>\n\n<p><strong><span class="sub-title">Kochi Office</span> </strong></p>\n\n<p><span class="address-line">C3, 3rd Floor,<br />\nV Square IT Hub,<br />\nChembumukku, Kakkanad P. O.,<br />\nErnakulam, Kerala - 682030</span></p>\n\n<p><strong>Phone Numbers</strong><br />\nSoftware Development<br />\nMobile: +91 8157-99-5558<br />\nDomain &amp; Hosting<br />\nMobile: +91-9446-06-9446<br />\nHuman Resources Department<br />\nMobile: +91-8606 01-1187</p>\n</div>\n</div>\n</div>\n      \n      </div>\n\n  </div>\n\n            </aside>\n                        </div>\n    </div>\n  </div>\n\n\n\n      <footer class="footer " role="contentinfo">\n        <div class="region--footer">\n    \n<div id="block-zyxpro-light-locations" class="block block--label-our-locations block--id-block-content4c979bba-b5f2-4829-80eb-8cadf8def118 block--type-our-locations">  \n      <div class="world_map">\n      <div class="world_map_title" >\n\n  <p>OUR LOCATIONS</p>\n\n</div>\n      <div class="world_map__wrap">\n        <img src="/themes/custom/zyxpro_light/images/world_map.png" alt="World Map - Zyxware" />\n        \n\n  \n  <div class="paragraph paragraph--type--location-item paragraph--view-mode--default location--item-wrap location--india">\n    <div class="map-content">\n              \n            <div class="field field--field-location"><p>India</p>\n</div>\n      \n      <div class="field field--field-addresses">\n              <div>  <div class="paragraph paragraph--type--address-item paragraph--view-mode--default">\n          \n            <div class="field field--field-place"><p>Technopark Office (Registered Office)</p>\n</div>\n      \n            <div class="field field--field-contact-address"><p>SBC 2205, II Floor,<br />\nYamuna Building, Phase III Campus,<br />\nThiruvananthapuram, Kerala - 695581</p>\n</div>\n      \n      <div class="field field--field-phone-numbers">\n              <div>  <div class="paragraph paragraph--type--phone-item paragraph--view-mode--default">\n          \n            <div class="field field--field-phone-title"><p>Mobile</p>\n</div>\n      \n            <div class="field field--field-phone-number"><p>+91 8157-99-5558</p>\n</div>\n      \n      </div>\n</div>\n          </div>\n  \n      </div>\n</div>\n              <div>  <div class="paragraph paragraph--type--address-item paragraph--view-mode--default">\n          \n            <div class="field field--field-place"><p>Kochi Office</p>\n</div>\n      \n            <div class="field field--field-contact-address"><p>XI/86 L, Chalakkara Road, Padamugal, Kakkanad P. O.,<br />\nKochi, Kerala - 682030</p>\n</div>\n      \n      </div>\n</div>\n          </div>\n  \n          </div>\n    <div class="map-marker"><img src="/themes/custom/zyxpro_light/images/icons/Map_Marker.png" class="responsive-img img-marker" alt="Map Marker" /></div>\n  </div>\n\n\n\n  \n  <div class="paragraph paragraph--type--location-item paragraph--view-mode--default location--item-wrap location--united-states">\n    <div class="map-content">\n              \n            <div class="field field--field-location"><p>United States</p>\n</div>\n      \n      <div class="field field--field-addresses">\n              <div>  <div class="paragraph paragraph--type--address-item paragraph--view-mode--default">\n          \n            <div class="field field--field-place"><p>190 Moore St</p>\n</div>\n      \n            <div class="field field--field-contact-address"><p>Suite 308,<br />\nHackensack, NJ 07601.<br />\nPhone: +1 408 677 1146</p>\n</div>\n      \n      <div class="field field--field-phone-numbers">\n              <div>  <div class="paragraph paragraph--type--phone-item paragraph--view-mode--default">\n          \n            <div class="field field--field-phone-title"><p>Phone</p>\n</div>\n      \n            <div class="field field--field-phone-number"><p>+1 408 677 1146</p>\n</div>\n      \n      </div>\n</div>\n          </div>\n  \n      </div>\n</div>\n          </div>\n  \n          </div>\n    <div class="map-marker"><img src="/themes/custom/zyxpro_light/images/icons/Map_Marker.png" class="responsive-img img-marker" alt="Map Marker" /></div>\n  </div>\n\n\n\n  \n  <div class="paragraph paragraph--type--location-item paragraph--view-mode--default location--item-wrap location--australia">\n    <div class="map-content">\n              \n            <div class="field field--field-location"><p>Australia</p>\n</div>\n      \n      <div class="field field--field-addresses">\n              <div>  <div class="paragraph paragraph--type--address-item paragraph--view-mode--default">\n          \n            <div class="field field--field-place"><p>8 Excelsa Way</p>\n</div>\n      \n            <div class="field field--field-contact-address"><p>Hillside,<br />\nMelbourne, VIC 3037</p>\n</div>\n      \n      <div class="field field--field-phone-numbers">\n              <div>  <div class="paragraph paragraph--type--phone-item paragraph--view-mode--default">\n          \n            <div class="field field--field-phone-title"><p>Phone</p>\n</div>\n      \n            <div class="field field--field-phone-number"><p>+61 450 405 000</p>\n</div>\n      \n      </div>\n</div>\n          </div>\n  \n      </div>\n</div>\n          </div>\n  \n          </div>\n    <div class="map-marker"><img src="/themes/custom/zyxpro_light/images/icons/Map_Marker.png" class="responsive-img img-marker" alt="Map Marker" /></div>\n  </div>\n\n\n\n\n      </div>\n      <div class="world-map-list-wrap" >\n        <ul>\n          <li><a href="/our-offices">India</a></li>\n          <li><a href="/our-offices">United States</a></li>\n          <li><a href="/our-offices">Australia</a></li>\n        </ul>\n      </div>\n    </div>\n  </div>\n<div class="block--id-system-branding-block">\n      <a href="/" title="Home" rel="home">\n      <img src="/themes/custom/zyxpro_light/logo.png" alt="Home" />\n    </a>\n      \n</div>\n\n\n  \n<div id="block-zyxpro-light-footercopyright" class="block block--label- block--id-block-contentf3debc9e-600d-447f-9d5b-a095d0bdd575 block--type-footer-copyright-section">\n      \n        \n          \n      <div class="footer-bottom  footer-bottom-custom" >\n        \n        \n        <a  href="/" class="include-branding hide-on-large-only" >\n          <img class="responsive-img zyx-img" src="/themes/custom/zyxpro_light/logo.png" alt="ZYXWARE"/>\n        </a>\n        \n            <div class="field field--body"><p><span><a href="/privacy-policy">Privacy</a> .\xc2\xa0<a href="#">T &amp; C</a> . \xc2\xa9 2020 Zyxware Technologies Pvt. Ltd</span></p>\n</div>\n      \n      </div>\n      </div>\n\n  </div>\n\n    </footer>\n  \n  </div>\n\n    \n    <script type="application/json" data-drupal-selector="drupal-settings-json">{"path":{"baseUrl":"\\/","scriptPath":null,"pathPrefix":"","currentPath":"node\\/5914","currentPathIsAdmin":false,"isFront":false,"currentLanguage":"en"},"pluralDelimiter":"\\u0003","dataLayer":{"defaultLang":"en","languages":{"en":{"id":"en","name":"English","direction":"ltr","weight":0}}},"google_analytics":{"account":"UA-1488254-2","trackOutbound":true,"trackMailto":true,"trackDownload":true,"trackDownloadExtensions":"7z|aac|arc|arj|asf|asx|avi|bin|csv|doc(x|m)?|dot(x|m)?|exe|flv|gif|gz|gzip|hqx|jar|jpe?g|js|mp(2|3|4|e?g)|mov(ie)?|msi|msp|pdf|phps|png|ppt(x|m)?|pot(x|m)?|pps(x|m)?|ppam|sld(x|m)?|thmx|qtm?|ra(m|r)?|sea|sit|tar|tgz|torrent|txt|wav|wma|wmv|wpd|xls(x|m|b)?|xlt(x|m)|xlam|xml|z|zip","trackColorbox":true,"trackUrlFragments":true},"eu_cookie_compliance":{"popup_enabled":true,"popup_agreed_enabled":false,"popup_hide_agreed":false,"popup_clicking_confirmation":true,"popup_scrolling_confirmation":false,"popup_html_info":"\\u003Cdiv class=\\u0022eu-cookie-compliance-banner eu-cookie-compliance-banner-info\\u0022\\u003E\\n    \\u003Cdiv class =\\u0022popup-content info eu-cookie-compliance-content\\u0022\\u003E\\n        \\u003Cdiv id=\\u0022popup-text\\u0022 class=\\u0022eu-cookie-compliance-message\\u0022\\u003E\\n            \\u003Cp\\u003EWe use cookies on this site to enhance your user experience. By clicking on the \\u2018OK, I agree\\u2019 button you are giving your consent for us to set cookies.\\u003C\\/p\\u003E\\n\\n        \\u003C\\/div\\u003E\\n        \\u003Cdiv id=\\u0022popup-buttons\\u0022 class=\\u0022eu-cookie-compliance-buttons\\u0022\\u003E\\n            \\u003Cbutton type=\\u0022button\\u0022 class=\\u0022agree-button eu-cookie-compliance-agree-button\\u0022\\u003EOK, I agree\\u003C\\/button\\u003E\\n                            \\u003Cbutton type=\\u0022button\\u0022 class=\\u0022disagree-button find-more-button eu-cookie-compliance-more-button\\u0022\\u003EGive me more info\\u003C\\/button\\u003E\\n                    \\u003C\\/div\\u003E\\n    \\u003C\\/div\\u003E\\n\\u003C\\/div\\u003E","use_mobile_message":false,"mobile_popup_html_info":"\\u003Cdiv class=\\u0022eu-cookie-compliance-banner eu-cookie-compliance-banner-info\\u0022\\u003E\\n    \\u003Cdiv class =\\u0022popup-content info eu-cookie-compliance-content\\u0022\\u003E\\n        \\u003Cdiv id=\\u0022popup-text\\u0022 class=\\u0022eu-cookie-compliance-message\\u0022\\u003E\\n            \\n        \\u003C\\/div\\u003E\\n        \\u003Cdiv id=\\u0022popup-buttons\\u0022 class=\\u0022eu-cookie-compliance-buttons\\u0022\\u003E\\n            \\u003Cbutton type=\\u0022button\\u0022 class=\\u0022agree-button eu-cookie-compliance-agree-button\\u0022\\u003EOK, I agree\\u003C\\/button\\u003E\\n                            \\u003Cbutton type=\\u0022button\\u0022 class=\\u0022disagree-button find-more-button eu-cookie-compliance-more-button\\u0022\\u003EGive me more info\\u003C\\/button\\u003E\\n                    \\u003C\\/div\\u003E\\n    \\u003C\\/div\\u003E\\n\\u003C\\/div\\u003E","mobile_breakpoint":768,"popup_html_agreed":false,"popup_use_bare_css":false,"popup_height":"auto","popup_width":"100%","popup_delay":1000,"popup_link":"\\/","popup_link_new_window":true,"popup_position":false,"fixed_top_position":true,"popup_language":"en","store_consent":false,"better_support_for_screen_readers":false,"cookie_name":"eu-cookie","reload_page":false,"domain":"","domain_all_sites":false,"popup_eu_only_js":false,"cookie_lifetime":90,"cookie_session":0,"disagree_do_not_show_popup":false,"method":"default","whitelisted_cookies":"","withdraw_markup":"\\u003Cbutton type=\\u0022button\\u0022 class=\\u0022eu-cookie-withdraw-tab\\u0022\\u003EPrivacy settings\\u003C\\/button\\u003E\\n\\u003Cdiv class=\\u0022eu-cookie-withdraw-banner\\u0022\\u003E\\n  \\u003Cdiv class=\\u0022popup-content info eu-cookie-compliance-content\\u0022\\u003E\\n    \\u003Cdiv id=\\u0022popup-text\\u0022 class=\\u0022eu-cookie-compliance-message\\u0022\\u003E\\n      \\u003Ch2\\u003EWe use cookies on this site to enhance your user experience\\u003C\\/h2\\u003E\\n\\u003Cp\\u003EYou have given your consent for us to set cookies.\\u003C\\/p\\u003E\\n\\n    \\u003C\\/div\\u003E\\n    \\u003Cdiv id=\\u0022popup-buttons\\u0022 class=\\u0022eu-cookie-compliance-buttons\\u0022\\u003E\\n      \\u003Cbutton type=\\u0022button\\u0022 class=\\u0022eu-cookie-withdraw-button\\u0022\\u003EWithdraw consent\\u003C\\/button\\u003E\\n    \\u003C\\/div\\u003E\\n  \\u003C\\/div\\u003E\\n\\u003C\\/div\\u003E","withdraw_enabled":false,"withdraw_button_on_info_popup":false,"cookie_categories":[],"enable_save_preferences_button":true,"fix_first_cookie_category":true,"select_all_categories_by_default":false},"ajaxTrustedUrl":{"\\/comment\\/reply\\/node\\/5914\\/comment_node_story":true,"\\/comment\\/reply\\/node\\/4351\\/comment_node_story":true,"\\/comment\\/reply\\/node\\/3384\\/comment_node_story":true},"form_placeholder":{"include":"textarea,input","exclude":"","required_indicator":"leave"},"user":{"uid":0,"permissionsHash":"067673b94f2c09cb1418ec8bc677fa1399d00dfbe92db43f62a33a321ec038e1"}}</script>\n<script src="/sites/default/files/js/js_c6sBYcgPYd3dKKsqe7iP6GIHZvyCj-q66Ny81NMgZ7U.js"></script>\n<script src="https://static.addtoany.com/menu/page.js" async></script>\n<script src="/sites/default/files/js/js_YWnkQrju-q-SSMAm1W13pyRnKjG_e_0avilAgVbNyR4.js"></script>\n<script src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>\n<script src="/sites/default/files/js/js_FNmEiseAHSiyAjgDUKr0EXjC_kiqS2sdNZqPEGmrwXg.js"></script>\n\n  </body>\n</html>\n'
    

## 2. Using bs4 (and lxml) to parse the structure and access different elements within a HTML or XML

bs4 is a Python library which parses through HTML content and understands the complete structure of the content. The response content can be passed to a BeautifulSoup method to obtain a soup object which looks very structured.


```python
soup_object = BeautifulSoup(response.content)
print(soup_object)
```

    <!DOCTYPE html>
    <html dir="ltr" lang="en" prefix="content: http://purl.org/rss/1.0/modules/content/  dc: http://purl.org/dc/terms/  foaf: http://xmlns.com/foaf/0.1/  og: http://ogp.me/ns#  rdfs: http://www.w3.org/2000/01/rdf-schema#  schema: http://schema.org/  sioc: http://rdfs.org/sioc/ns#  sioct: http://rdfs.org/sioc/types#  skos: http://www.w3.org/2004/02/skos/core#  xsd: http://www.w3.org/2001/XMLSchema# ">
    <head>
    <meta charset="utf-8"/>
    <script>dataLayer = [];dataLayer.push({"tag": "5914"});</script>
    <script>window.dataLayer = window.dataLayer || []; window.dataLayer.push({"drupalLanguage":"en","drupalCountry":"IN","siteName":"Zyxware Technologies","entityCreated":"1562300185","entityLangcode":"en","entityStatus":"1","entityUid":"1","entityUuid":"6fdfb477-ce5d-4081-9010-3afd9260cdf7","entityVid":"15541","entityName":"webmaster","entityType":"node","entityBundle":"story","entityId":"5914","entityTitle":"List of Fortune 500 companies and their websites (2018)","entityTaxonomy":{"vocabulary_2":"Misc,Lists"},"userUid":0});</script>
    <script async="" src="https://www.googletagmanager.com/gtag/js?id=UA-1488254-2"></script>
    <script>window.google_analytics_uacct = "UA-1488254-2";window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments)};gtag("js", new Date());window['GoogleAnalyticsObject'] = 'ga';
      window['ga'] = window['ga'] || function() {
        (window['ga'].q = window['ga'].q || []).push(arguments)
      };
    ga("set", "dimension2", window.analytics_manager_node_age);
    ga("set", "dimension3", window.analytics_manager_node_author);gtag("config", "UA-1488254-2", {"groups":"default","anonymize_ip":true,"page_path":location.pathname + location.search + location.hash,"link_attribution":true,"allow_ad_personalization_signals":false});</script>
    <meta content="List of Fortune 500 companies and their websites (2018) | Zyxware Technologies" name="title"/>
    <link href="https://www.zyxware.com/articles/5914/list-of-fortune-500-companies-and-their-websites-2018" rel="canonical"/>
    <meta content="Fortune magazine publishes a list of the largest companies in the US by revenue every year. Here is the list of fortune 500 companies for the year 2018 and their websites. Check out the current list of fortune 500 companies and their websites." name="description"/>
    <meta content="Drupal 8 (https://www.drupal.org)" name="Generator"/>
    <meta content="width" name="MobileOptimized"/>
    <meta content="true" name="HandheldFriendly"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <style>div#sliding-popup, div#sliding-popup .eu-cookie-withdraw-banner, .eu-cookie-withdraw-tab {background: #733ec0} div#sliding-popup.eu-cookie-withdraw-wrapper { background: transparent; } #sliding-popup h1, #sliding-popup h2, #sliding-popup h3, #sliding-popup p, #sliding-popup label, #sliding-popup div, .eu-cookie-compliance-more-button, .eu-cookie-compliance-secondary-button, .eu-cookie-withdraw-tab { color: #ffffff;} .eu-cookie-withdraw-tab { border-color: #ffffff;}</style>
    <script async="" defer="" src="https://www.google.com/recaptcha/api.js?hl=en"></script>
    <link href="/themes/custom/zyxpro_light/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon"/>
    <link href="https://www.zyxware.com/articles/5914/list-of-fortune-500-companies-and-their-websites-2018" rel="revision"/>
    <script src="/sites/default/files/google_tag/google_tag.script.js?q5ykxj"></script>
    <script>window.a2a_config=window.a2a_config||{};a2a_config.callbacks=[];a2a_config.overlays=[];a2a_config.templates={};</script>
    <title>List of Fortune 500 companies and their websites (2018) | Zyxware Technologies</title>
    <link href="/sites/default/files/css/css_20KuxgA9EGPA1Yt5CdQmKTq6xZJpEUDALYwFLBKAYns.css?q5ykxj" media="all" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500,600,700" media="all" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" media="all" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" media="all" rel="stylesheet"/>
    <link href="/sites/default/files/css/css_MBYDfcLceuf-_EyhJv5KkIoqYyE187izQMjN3XdP_0g.css?q5ykxj" media="all" rel="stylesheet"/>
    <!--[if lte IE 8]>
    <script src="/sites/default/files/js/js_VtafjXmRvoUgAzqzYTA3Wrjkx9wcWhjP0G4ZnnqRamA.js"></script>
    <![endif]-->
    <script src="/core/assets/vendor/modernizr/modernizr.min.js?v=3.3.1"></script>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    </head>
    <body class="path-node page-node-type-story articles/5914/list-of-fortune-500-companies-and-their-websites-2018 page-node-5914">
    <a class="visually-hidden focusable" href="#main-content">
          Skip to main content
        </a>
    <noscript aria-hidden="true"><iframe height="0" src="https://www.googletagmanager.com/ns.html?id=GTM-WVXBWZC" title="Google Tag Manager" width="0"></iframe></noscript>
    <div class="dialog-off-canvas-main-canvas" data-off-canvas-main-canvas="">
    <header class="region-header" role="heading">
    <div class="sticky-head-wrap">
    <div class="region--header">
    <div class="block--id-system-branding-block">
    <a href="/" rel="home" title="Home">
    <img alt="Home" src="/themes/custom/zyxpro_light/logo.png"/>
    </a>
    </div>
    <div class="block block--label- block--id-we-megamenu-blockmenu-main-menu-india" id="block-mainmenuglobal">
    <div class="region-we-mega-menu">
    <a class="navbar-toggle collapsed">
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    </a>
    <nav class="menu-main-menu-india navbar navbar-default navbar-we-mega-menu mobile-collapse hover-action" data-action="hover" data-alwayshowsubmenu="" data-animation="None" data-autoarrow="" data-block-theme="zyxpro_light" data-delay="" data-duration="" data-menu-name="menu-main-menu-india" data-mobile-collapse="0" data-style="Default">
    <div class="container-fluid">
    <ul class="we-mega-menu-ul nav nav-tabs">
    <li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="3159c112-2cbb-4015-b128-1604efe0bc82" data-level="0" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/" target="" title="">
          
          Home
    
              </a>
    </li><li class="we-mega-menu-li dropdown-menu" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="72048f4a-e136-4785-b804-9e73f3aca35c" data-level="0" data-submenu="1" data-target="" description="" hide-sub-when-collapse="">
    <span class="we-megamenu-nolink" data-drupal-link-system-path="&lt;front&gt;">Services</span>
    <div class="we-mega-menu-submenu" data-class="" data-element-type="we-mega-menu-submenu" data-submenu-width="700" style="width: 700px">
    <div class="we-mega-menu-submenu-inner">
    <div class="we-mega-menu-row" data-custom-row="0" data-element-type="we-mega-menu-row">
    <div class="we-mega-menu-col span4" data-block="" data-blocktitle="0" data-class="" data-element-type="we-mega-menu-col" data-hidewhencollapse="" data-width="4">
    <ul class="nav nav-tabs subul">
    <li class="we-mega-menu-li title-submenu" data-alignsub="" data-caption="" data-class="title-submenu" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="434df207-f18e-48ba-ad47-44c2ddcc6c8c" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <span class="we-megamenu-nolink" data-drupal-link-system-path="&lt;front&gt;">Platform Engineering </span>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="bf754a9f-5822-4f02-9d3c-ae419db5a0e5" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/services/engineering-services" target="" title="">
          
          Application Development Services
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="91f48b0f-fb07-43af-8f4d-d832176c3edd" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/services/ux-design" target="" title="">
          
          Design Services
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="0da0f462-edcb-427c-afdc-50fa905e71db" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/services/qualityassurance" target="" title="">
          
          Quality Assurance Services
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="a19aed2a-cbcb-4eb9-9a3a-92d7c914b695" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/managed-services" target="" title="">
          
          Managed Services
    
              </a>
    </li>
    </ul>
    </div>
    <div class="we-mega-menu-col span4" data-block="" data-blocktitle="1" data-class="" data-element-type="we-mega-menu-col" data-hidewhencollapse="" data-width="4">
    <ul class="nav nav-tabs subul">
    <li class="we-mega-menu-li title-submenu" data-alignsub="" data-caption="" data-class="title-submenu" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="6135c31c-4cf9-46d0-9c40-ca95a6739f7f" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <span class="we-megamenu-nolink" data-drupal-link-system-path="&lt;front&gt;">Consulting Services</span>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="5f35b9eb-72dc-43d0-8bc2-c728204c497a" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/digital-business-strategy" target="" title="">
          
          Digital Business Strategy
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="48b44987-b00b-47eb-a64f-780265272633" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/automation-consulting" target="" title="">
          
          Automation Consulting
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="413cacb4-cb6d-4b1d-b628-601d72f1f61f" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/technology-consulting" target="" title="">
          
          Technology Consulting
    
              </a>
    </li>
    </ul>
    </div>
    <div class="we-mega-menu-col span4" data-block="" data-blocktitle="1" data-class="" data-element-type="we-mega-menu-col" data-hidewhencollapse="" data-width="4">
    <ul class="nav nav-tabs subul">
    <li class="we-mega-menu-li title-submenu" data-alignsub="" data-caption="" data-class="title-submenu" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="24a24f47-0e08-4940-a842-783d91455759" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <span class="we-megamenu-nolink" data-drupal-link-system-path="&lt;front&gt;">Impact Services</span>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="a594f1b4-8969-459b-ac7e-d9ee6325fc12" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/services/marketing" target="" title="">
          
          Marketing Operations
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="f204b532-7f7d-4765-91a6-c648969df282" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/conversion-optimisation" target="" title="">
          
          Conversion Optimization
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="20447454-90f9-4ed1-8c98-a4e21584d79a" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/digital-engagement" target="" title="">
          
          Digital Engagement
    
              </a>
    </li>
    </ul>
    </div>
    </div>
    </div>
    </div>
    </li><li class="we-mega-menu-li dropdown-menu" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="f7e93f29-438b-4885-8b70-b6356be8da1a" data-level="0" data-submenu="1" data-target="" description="" hide-sub-when-collapse="">
    <span class="we-megamenu-nolink" data-drupal-link-system-path="&lt;front&gt;">Verticals</span>
    <div class="we-mega-menu-submenu" data-class="" data-element-type="we-mega-menu-submenu" data-submenu-width="" style="width: px">
    <div class="we-mega-menu-submenu-inner">
    <div class="we-mega-menu-row" data-custom-row="0" data-element-type="we-mega-menu-row">
    <div class="we-mega-menu-col span12" data-block="" data-blocktitle="0" data-class="" data-element-type="we-mega-menu-col" data-hidewhencollapse="" data-width="12">
    <ul class="nav nav-tabs subul">
    <li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="0e7a2ab2-cb34-4a73-b572-e64e5cee0299" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/verticals/public-sector" target="" title="">
          
          Public Services
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="f7167409-81d9-4bde-a11b-384930e93eda" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/verticals/media" target="" title="">
          
          Media
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="86ce2d77-eec3-4abd-bc64-bcf76d758563" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/verticals/education" target="" title="">
          
          Education
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="21225a9c-49ae-48bf-8c53-a167ad1d4b39" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/verticals/retail" target="" title="">
          
          Retail
    
              </a>
    </li>
    </ul>
    </div>
    </div>
    </div>
    </div>
    </li><li class="we-mega-menu-li dropdown-menu" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="91b2ccc9-3dc9-4945-a24d-1e490f218ad7" data-level="0" data-submenu="1" data-target="" description="" hide-sub-when-collapse="">
    <span class="we-megamenu-nolink" data-drupal-link-system-path="&lt;front&gt;">Technologies</span>
    <div class="we-mega-menu-submenu" data-class="" data-element-type="we-mega-menu-submenu" data-submenu-width="" style="width: px">
    <div class="we-mega-menu-submenu-inner">
    <div class="we-mega-menu-row" data-custom-row="0" data-element-type="we-mega-menu-row">
    <div class="we-mega-menu-col span12" data-block="" data-blocktitle="0" data-class="" data-element-type="we-mega-menu-col" data-hidewhencollapse="" data-width="12">
    <ul class="nav nav-tabs subul">
    <li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="006ed138-3803-4c96-af8a-ec05c734c42f" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/drupal-solutions/web-development-services" target="" title="">
          
          Drupal
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="dcbe2554-3336-4f02-86b4-5d28cc553a71" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/technologies/govcms" target="" title="">
          
          GovCMS
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="9e9d8249-2f80-4aed-bdc0-bbdbdddf424f" data-level="1" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/magento-services" target="" title="">
          
          Magento
    
              </a>
    </li>
    </ul>
    </div>
    </div>
    </div>
    </div>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="8fdc4447-6a47-434f-80ee-7010f8a44145" data-level="0" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/articles" target="" title="">
          
          Articles
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="729d26b9-defa-46a8-bbea-7f5d5c434b6f" data-level="0" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/about" target="" title="">
          
          About
    
              </a>
    </li><li class="we-mega-menu-li" data-alignsub="" data-caption="" data-class="" data-element-type="we-mega-menu-li" data-group="0" data-icon="" data-id="2c77eb5d-1be5-4062-8350-e613bf76e7f2" data-level="0" data-submenu="0" data-target="" description="" hide-sub-when-collapse="">
    <a class="we-mega-menu-li" href="/contact-us" target="" title="">
          
          Contact
    
              </a>
    </li>
    </ul>
    </div>
    </nav>
    </div>
    </div>
    <div class="block block--label- block--id-block-content7ebe1c89-6fa0-4d07-995d-ebbeeb642048 block--type-basic" id="block-getintouch">
    <div class="field field--body"><p><a class="getin-touch-btn" href="/contact-us">Get in touch</a></p>
    </div>
    </div>
    </div>
    <button class="sidebar-toggler hide-on-large-only-modified" onclick="toggleFixedSidebar();return false;" type="button">
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    </button>
    </div>
    </header>
    <div class="main-container js-quickedit-main-content" role="main">
    <div class="clearfix">
    <div class="region--breadcrumb">
    <div class="block block--label- block--id-system-breadcrumb-block" id="block-zyxpro-light-breadcrumbs">
    <nav aria-labelledby="system-breadcrumb" class="breadcrump-wrap" role="navigation">
    <h2 class="visually-hidden" id="system-breadcrumb">Breadcrumb</h2>
    <ul class="list-inline container">
    <li class="hidden-xs">
    <a href="/">Home</a>
    </li>
    <li class="seperator hidden-xs">|</li>
    <li class="hidden-xs">
    <a href="/categories/misc">Misc</a>
    </li>
    <li class="seperator hidden-xs">|</li>
    <li class="hidden-xs current-page-title">List of Fortune 500 companies and their websites (2018)</li>
    <li class="visible-xs" style=""><a onclick="goBack()"> <span style="position: relative;display: inline-block;top: 0px;">&lt;</span> Back</a></li>
    </ul>
    </nav>
    </div>
    </div>
    <div class="region--content-top">
    <div class="block block--label- block--id-node-header" id="block-nodeheader">
    <div class="node_title_rendered">List of Fortune 500 companies and their websites (2018)</div><div class="node_header"><div class="userimg"><img alt="https://www.zyxware.com/sites/default/files/styles/user_image/public/pictures/zyxlogo.png?itok=J9t-ZEoU" class="circle personpic responsive-img" src="https://www.zyxware.com/sites/default/files/styles/user_image/public/pictures/zyxlogo.png?itok=J9t-ZEoU"/> <div class="username"> BY webmaster <div class="time">7 months ago</div></div></div><div class="tags"><div class="tag">Misc</div></div><div class="comments"><div class="comment">0 comments <i class="small material-icons">comment</i></div></div><div class="shares"><div class="share">0 shares <i class="small material-icons">shares</i></div></div></div>
    </div>
    </div>
    <div class="content-full">
    <section class="col l9 m12 s12">
    <div class="highlighted"> <div class="region--highlighted">
    <div class="hidden" data-drupal-messages-fallback=""></div>
    </div>
    </div>
    <a id="main-content"></a>
    <div class="region--content">
    <div class="block block--label- block--id-system-main-block" id="block-zyxpro-light-zyxware-drift-system-main">
    <article about="/articles/5914/list-of-fortune-500-companies-and-their-websites-2018" class="story is-promoted full clearfix node-article" data-history-node-id="5914" role="article">
    <div class="content">
    <div class="zyxpro-casestudy-article-image">
    </div>
    <div class="zyxpro-casestudy-article-body">
    <div class="field field--body"><p>Fortune magazine publishes a list of the largest companies in the US by revenue every year. Here is the list of fortune 500 companies for the year 2018 and their websites. Check out the <a href="/articles/4344/list-of-fortune-500-companies-and-their-websites">current list of fortune 500 companies</a> and their websites. <!--break--></p>
    <!--break-->
    <table class="data-table"><thead><tr><th>Rank</th>
    <th>Company</th>
    <th>Website</th>
    </tr></thead><tbody><tr><td>1</td>
    <td>Walmart</td>
    <td><a href="http://www.stock.walmart.com">http://www.stock.walmart.com</a></td>
    </tr><tr><td>2</td>
    <td>Exxon Mobil</td>
    <td><a href="http://www.exxonmobil.com">http://www.exxonmobil.com</a></td>
    </tr><tr><td>3</td>
    <td>Berkshire Hathaway</td>
    <td><a href="http://www.berkshirehathaway.com">http://www.berkshirehathaway.com</a></td>
    </tr><tr><td>4</td>
    <td>Apple</td>
    <td><a href="http://www.apple.com">http://www.apple.com</a></td>
    </tr><tr><td>5</td>
    <td>UnitedHealth Group</td>
    <td><a href="http://www.unitedhealthgroup.com">http://www.unitedhealthgroup.com</a></td>
    </tr><tr><td>6</td>
    <td>McKesson</td>
    <td><a href="http://www.mckesson.com">http://www.mckesson.com</a></td>
    </tr><tr><td>7</td>
    <td>CVS Health</td>
    <td><a href="http://www.cvshealth.com">http://www.cvshealth.com</a></td>
    </tr><tr><td>8</td>
    <td>Amazon.com</td>
    <td><a href="http://www.amazon.com">http://www.amazon.com</a></td>
    </tr><tr><td>9</td>
    <td>AT&amp;T</td>
    <td><a href="http://www.att.com">http://www.att.com</a></td>
    </tr><tr><td>10</td>
    <td>General Motors</td>
    <td><a href="http://www.gm.com">http://www.gm.com</a></td>
    </tr><tr><td>11</td>
    <td>Ford Motor</td>
    <td><a href="http://www.corporate.ford.com">http://www.corporate.ford.com</a></td>
    </tr><tr><td>12</td>
    <td>AmerisourceBergen</td>
    <td><a href="http://www.amerisourcebergen.com">http://www.amerisourcebergen.com</a></td>
    </tr><tr><td>13</td>
    <td>Chevron</td>
    <td><a href="http://www.chevron.com">http://www.chevron.com</a></td>
    </tr><tr><td>14</td>
    <td>Cardinal Health</td>
    <td><a href="http://www.cardinalhealth.com">http://www.cardinalhealth.com</a></td>
    </tr><tr><td>15</td>
    <td>Costco</td>
    <td><a href="http://www.costco.com">http://www.costco.com</a></td>
    </tr><tr><td>16</td>
    <td>Verizon</td>
    <td><a href="http://www.verizon.com">http://www.verizon.com</a></td>
    </tr><tr><td>17</td>
    <td>Kroger</td>
    <td><a href="http://www.thekrogerco.com">http://www.thekrogerco.com</a></td>
    </tr><tr><td>18</td>
    <td>General Electric</td>
    <td><a href="http://www.ge.com">http://www.ge.com</a></td>
    </tr><tr><td>19</td>
    <td>Walgreens Boots Alliance</td>
    <td><a href="http://www.walgreensbootsalliance.com">http://www.walgreensbootsalliance.com</a></td>
    </tr><tr><td>20</td>
    <td>JPMorgan Chase</td>
    <td><a href="http://www.jpmorganchase.com">http://www.jpmorganchase.com</a></td>
    </tr><tr><td>21</td>
    <td>Fannie Mae</td>
    <td><a href="http://www.fanniemae.com">http://www.fanniemae.com</a></td>
    </tr><tr><td>22</td>
    <td>Alphabet</td>
    <td><a href="http://www.abc.xyz">http://www.abc.xyz</a></td>
    </tr><tr><td>23</td>
    <td>Home Depot</td>
    <td><a href="http://www.homedepot.com">http://www.homedepot.com</a></td>
    </tr><tr><td>24</td>
    <td>Bank of America Corp.</td>
    <td><a href="http://www.bankofamerica.com">http://www.bankofamerica.com</a></td>
    </tr><tr><td>25</td>
    <td>Express Scripts Holding</td>
    <td><a href="http://www.express-scripts.com">http://www.express-scripts.com</a></td>
    </tr><tr><td>26</td>
    <td>Wells Fargo</td>
    <td><a href="http://www.wellsfargo.com">http://www.wellsfargo.com</a></td>
    </tr><tr><td>27</td>
    <td>Boeing</td>
    <td><a href="http://www.boeing.com">http://www.boeing.com</a></td>
    </tr><tr><td>28</td>
    <td>Phillips</td>
    <td><a href="http://www.phillips66.com">http://www.phillips66.com</a></td>
    </tr><tr><td>29</td>
    <td>Anthem</td>
    <td><a href="http://www.antheminc.com">http://www.antheminc.com</a></td>
    </tr><tr><td>30</td>
    <td>Microsoft</td>
    <td><a href="http://www.microsoft.com">http://www.microsoft.com</a></td>
    </tr><tr><td>31</td>
    <td>Valero Energy</td>
    <td><a href="http://www.valero.com">http://www.valero.com</a></td>
    </tr><tr><td>32</td>
    <td>Citigroup</td>
    <td><a href="http://www.citigroup.com">http://www.citigroup.com</a></td>
    </tr><tr><td>33</td>
    <td>Comcast</td>
    <td><a href="http://www.comcastcorporation.com">http://www.comcastcorporation.com</a></td>
    </tr><tr><td>34</td>
    <td>IBM</td>
    <td><a href="http://www.ibm.com">http://www.ibm.com</a></td>
    </tr><tr><td>35</td>
    <td>Dell Technologies</td>
    <td><a href="http://www.delltechnologies.com">http://www.delltechnologies.com</a></td>
    </tr><tr><td>36</td>
    <td>State Farm Insurance Cos.</td>
    <td><a href="http://www.statefarm.com">http://www.statefarm.com</a></td>
    </tr><tr><td>37</td>
    <td>Johnson &amp; Johnson</td>
    <td><a href="http://www.jnj.com">http://www.jnj.com</a></td>
    </tr><tr><td>38</td>
    <td>Freddie Mac</td>
    <td><a href="http://www.freddiemac.com">http://www.freddiemac.com</a></td>
    </tr><tr><td>39</td>
    <td>Target</td>
    <td><a href="http://www.target.com">http://www.target.com</a></td>
    </tr><tr><td>40</td>
    <td>Lowe’s</td>
    <td><a href="http://www.lowes.com">http://www.lowes.com</a></td>
    </tr><tr><td>41</td>
    <td>Marathon Petroleum</td>
    <td><a href="http://www.marathonpetroleum.com">http://www.marathonpetroleum.com</a></td>
    </tr><tr><td>42</td>
    <td>Procter &amp; Gamble</td>
    <td><a href="http://www.pg.com">http://www.pg.com</a></td>
    </tr><tr><td>43</td>
    <td>MetLife</td>
    <td><a href="http://www.metlife.com">http://www.metlife.com</a></td>
    </tr><tr><td>44</td>
    <td>UPS</td>
    <td><a href="http://www.ups.com">http://www.ups.com</a></td>
    </tr><tr><td>45</td>
    <td>PepsiCo</td>
    <td><a href="http://www.pepsico.com">http://www.pepsico.com</a></td>
    </tr><tr><td>46</td>
    <td>Intel</td>
    <td><a href="http://www.intel.com">http://www.intel.com</a></td>
    </tr><tr><td>47</td>
    <td>DowDuPont</td>
    <td><a href="www.dow-dupont.com">www.dow-dupont.com</a></td>
    </tr><tr><td>48</td>
    <td>Archer Daniels Midland</td>
    <td><a href="http://www.adm.com">http://www.adm.com</a></td>
    </tr><tr><td>49</td>
    <td>Aetna</td>
    <td><a href="http://www.aetna.com">http://www.aetna.com</a></td>
    </tr><tr><td>50</td>
    <td>FedEx</td>
    <td><a href="http://www.fedex.com">http://www.fedex.com</a></td>
    </tr><tr><td>51</td>
    <td>United Technologies</td>
    <td><a href="http://www.utc.com">http://www.utc.com</a></td>
    </tr><tr><td>52</td>
    <td>Prudential Financial</td>
    <td><a href="http://www.prudential.com">http://www.prudential.com</a></td>
    </tr><tr><td>53</td>
    <td>Albertsons Cos.</td>
    <td><a href="http://www.albertsons.com">http://www.albertsons.com</a></td>
    </tr><tr><td>54</td>
    <td>Sysco</td>
    <td><a href="http://www.sysco.com">http://www.sysco.com</a></td>
    </tr><tr><td>55</td>
    <td>Disney</td>
    <td><a href="http://www.disney.com">http://www.disney.com</a></td>
    </tr><tr><td>56</td>
    <td>Humana</td>
    <td><a href="http://www.humana.com">http://www.humana.com</a></td>
    </tr><tr><td>57</td>
    <td>Pfizer</td>
    <td><a href="http://www.pfizer.com">http://www.pfizer.com</a></td>
    </tr><tr><td>58</td>
    <td>HP</td>
    <td><a href="http://www.hp.com">http://www.hp.com</a></td>
    </tr><tr><td>59</td>
    <td>Lockheed Martin</td>
    <td><a href="http://www.lockheedmartin.com">http://www.lockheedmartin.com</a></td>
    </tr><tr><td>60</td>
    <td>AIG</td>
    <td><a href="http://www.aig.com">http://www.aig.com</a></td>
    </tr><tr><td>61</td>
    <td>Centene</td>
    <td><a href="http://www.centene.com">http://www.centene.com</a></td>
    </tr><tr><td>62</td>
    <td>Cisco Systems</td>
    <td><a href="http://www.cisco.com">http://www.cisco.com</a></td>
    </tr><tr><td>63</td>
    <td>HCA Healthcare</td>
    <td><a href="www.hcahealthcare.com">www.hcahealthcare.com</a></td>
    </tr><tr><td>64</td>
    <td>Energy Transfer Equity</td>
    <td><a href="http://www.energytransfer.com">http://www.energytransfer.com</a></td>
    </tr><tr><td>65</td>
    <td>Caterpillar</td>
    <td><a href="http://www.caterpillar.com">http://www.caterpillar.com</a></td>
    </tr><tr><td>66</td>
    <td>Nationwide</td>
    <td><a href="http://www.nationwide.com">http://www.nationwide.com</a></td>
    </tr><tr><td>67</td>
    <td>Morgan Stanley</td>
    <td><a href="http://www.morganstanley.com">http://www.morganstanley.com</a></td>
    </tr><tr><td>68</td>
    <td>Liberty Mutual Insurance Group</td>
    <td><a href="http://www.libertymutual.com">http://www.libertymutual.com</a></td>
    </tr><tr><td>69</td>
    <td>New York Life Insurance</td>
    <td><a href="http://www.newyorklife.com">http://www.newyorklife.com</a></td>
    </tr><tr><td>70</td>
    <td>Goldman Sachs Group</td>
    <td><a href="http://www.gs.com">http://www.gs.com</a></td>
    </tr><tr><td>71</td>
    <td>American Airlines Group</td>
    <td><a href="http://www.aa.com">http://www.aa.com</a></td>
    </tr><tr><td>72</td>
    <td>Best Buy</td>
    <td><a href="http://www.bestbuy.com">http://www.bestbuy.com</a></td>
    </tr><tr><td>73</td>
    <td>Cigna</td>
    <td><a href="http://www.cigna.com">http://www.cigna.com</a></td>
    </tr><tr><td>74</td>
    <td>Charter Communications</td>
    <td><a href="http://www.charter.com">http://www.charter.com</a></td>
    </tr><tr><td>75</td>
    <td>Delta Air Lines</td>
    <td><a href="http://www.delta.com">http://www.delta.com</a></td>
    </tr><tr><td>76</td>
    <td>Facebook</td>
    <td><a href="http://www.facebook.com">http://www.facebook.com</a></td>
    </tr><tr><td>77</td>
    <td>Honeywell International</td>
    <td><a href="http://www.honeywell.com">http://www.honeywell.com</a></td>
    </tr><tr><td>78</td>
    <td>Merck</td>
    <td><a href="http://www.merck.com">http://www.merck.com</a></td>
    </tr><tr><td>79</td>
    <td>Allstate</td>
    <td><a href="http://www.allstate.com">http://www.allstate.com</a></td>
    </tr><tr><td>80</td>
    <td>Tyson Foods</td>
    <td><a href="http://www.tysonfoods.com">http://www.tysonfoods.com</a></td>
    </tr><tr><td>81</td>
    <td>United Continental Holdings</td>
    <td><a href="http://www.united.com">http://www.united.com</a></td>
    </tr><tr><td>82</td>
    <td>Oracle</td>
    <td><a href="http://www.oracle.com">http://www.oracle.com</a></td>
    </tr><tr><td>83</td>
    <td>Tech Data</td>
    <td><a href="http://www.techdata.com">http://www.techdata.com</a></td>
    </tr><tr><td>84</td>
    <td>TIAA</td>
    <td><a href="http://www.tiaa.org">http://www.tiaa.org</a></td>
    </tr><tr><td>85</td>
    <td>TJX</td>
    <td><a href="http://www.tjx.com">http://www.tjx.com</a></td>
    </tr><tr><td>86</td>
    <td>American Express</td>
    <td><a href="http://www.americanexpress.com">http://www.americanexpress.com</a></td>
    </tr><tr><td>87</td>
    <td>Coca-Cola</td>
    <td><a href="http://www.coca-colacompany.com">http://www.coca-colacompany.com</a></td>
    </tr><tr><td>88</td>
    <td>Publix Super Markets</td>
    <td><a href="http://www.publix.com">http://www.publix.com</a></td>
    </tr><tr><td>89</td>
    <td>Nike</td>
    <td><a href="http://www.nike.com">http://www.nike.com</a></td>
    </tr><tr><td>90</td>
    <td>Andeavor</td>
    <td><a href="www.andeavor.com">www.andeavor.com</a></td>
    </tr><tr><td>91</td>
    <td>World Fuel Services</td>
    <td><a href="http://www.wfscorp.com">http://www.wfscorp.com</a></td>
    </tr><tr><td>92</td>
    <td>Exelon</td>
    <td><a href="http://www.exeloncorp.com">http://www.exeloncorp.com</a></td>
    </tr><tr><td>93</td>
    <td>Massachusetts Mutual Life Insurance</td>
    <td><a href="http://www.massmutual.com">http://www.massmutual.com</a></td>
    </tr><tr><td>94</td>
    <td>Rite Aid</td>
    <td><a href="http://www.riteaid.com">http://www.riteaid.com</a></td>
    </tr><tr><td>95</td>
    <td>ConocoPhillips</td>
    <td><a href="http://www.conocophillips.com">http://www.conocophillips.com</a></td>
    </tr><tr><td>96</td>
    <td>CHS</td>
    <td><a href="http://www.chsinc.com">http://www.chsinc.com</a></td>
    </tr><tr><td>97</td>
    <td>M</td>
    <td><a href="http://www.3m.com">http://www.3m.com</a></td>
    </tr><tr><td>98</td>
    <td>Time Warner</td>
    <td><a href="http://www.timewarner.com">http://www.timewarner.com</a></td>
    </tr><tr><td>99</td>
    <td>General Dynamics</td>
    <td><a href="http://www.generaldynamics.com">http://www.generaldynamics.com</a></td>
    </tr><tr><td>100</td>
    <td>USAA</td>
    <td><a href="http://www.usaa.com">http://www.usaa.com</a></td>
    </tr><tr><td>101</td>
    <td>Capital One Financial</td>
    <td><a href="http://www.capitalone.com">http://www.capitalone.com</a></td>
    </tr><tr><td>102</td>
    <td>Deere</td>
    <td><a href="http://www.johndeere.com">http://www.johndeere.com</a></td>
    </tr><tr><td>103</td>
    <td>INTL FCStone</td>
    <td><a href="http://www.intlfcstone.com">http://www.intlfcstone.com</a></td>
    </tr><tr><td>104</td>
    <td>Northwestern Mutual</td>
    <td><a href="http://www.northwesternmutual.com">http://www.northwesternmutual.com</a></td>
    </tr><tr><td>105</td>
    <td>Enterprise Products Partners</td>
    <td><a href="http://www.enterpriseproducts.com">http://www.enterpriseproducts.com</a></td>
    </tr><tr><td>106</td>
    <td>Travelers Cos.</td>
    <td><a href="http://www.travelers.com">http://www.travelers.com</a></td>
    </tr><tr><td>107</td>
    <td>Hewlett Packard Enterprise</td>
    <td><a href="http://www.hpe.com">http://www.hpe.com</a></td>
    </tr><tr><td>108</td>
    <td>Philip Morris International</td>
    <td><a href="http://www.pmi.com">http://www.pmi.com</a></td>
    </tr><tr><td>109</td>
    <td>Twenty-First Century Fox</td>
    <td><a href="http://www.21cf.com">http://www.21cf.com</a></td>
    </tr><tr><td>110</td>
    <td>AbbVie</td>
    <td><a href="http://www.abbvie.com">http://www.abbvie.com</a></td>
    </tr><tr><td>111</td>
    <td>Abbott Laboratories</td>
    <td><a href="http://www.abbott.com">http://www.abbott.com</a></td>
    </tr><tr><td>112</td>
    <td>Progressive</td>
    <td><a href="http://www.progressive.com">http://www.progressive.com</a></td>
    </tr><tr><td>113</td>
    <td>Arrow Electronics</td>
    <td><a href="http://www.arrow.com">http://www.arrow.com</a></td>
    </tr><tr><td>114</td>
    <td>Kraft Heinz</td>
    <td><a href="http://www.kraftheinzcompany.com">http://www.kraftheinzcompany.com</a></td>
    </tr><tr><td>115</td>
    <td>Plains GP Holdings</td>
    <td><a href="http://www.plainsallamerican.com">http://www.plainsallamerican.com</a></td>
    </tr><tr><td>116</td>
    <td>Gilead Sciences</td>
    <td><a href="http://www.gilead.com">http://www.gilead.com</a></td>
    </tr><tr><td>117</td>
    <td>Mondelez International</td>
    <td><a href="http://www.mondelezinternational.com">http://www.mondelezinternational.com</a></td>
    </tr><tr><td>118</td>
    <td>Northrop Grumman</td>
    <td><a href="http://www.northropgrumman.com">http://www.northropgrumman.com</a></td>
    </tr><tr><td>119</td>
    <td>Raytheon</td>
    <td><a href="http://www.raytheon.com">http://www.raytheon.com</a></td>
    </tr><tr><td>120</td>
    <td>Macy’s</td>
    <td><a href="http://www.macysinc.com">http://www.macysinc.com</a></td>
    </tr><tr><td>121</td>
    <td>US Foods Holding</td>
    <td><a href="http://www.usfoods.com">http://www.usfoods.com</a></td>
    </tr><tr><td>122</td>
    <td>U.S. Bancorp</td>
    <td><a href="http://www.usbank.com">http://www.usbank.com</a></td>
    </tr><tr><td>123</td>
    <td>Dollar General</td>
    <td><a href="http://www.dollargeneral.com">http://www.dollargeneral.com</a></td>
    </tr><tr><td>124</td>
    <td>International Paper</td>
    <td><a href="http://www.internationalpaper.com">http://www.internationalpaper.com</a></td>
    </tr><tr><td>125</td>
    <td>Duke Energy</td>
    <td><a href="http://www.duke-energy.com">http://www.duke-energy.com</a></td>
    </tr><tr><td>126</td>
    <td>Southern</td>
    <td><a href="http://www.southerncompany.com">http://www.southerncompany.com</a></td>
    </tr><tr><td>127</td>
    <td>Marriott International</td>
    <td><a href="http://www.marriott.com">http://www.marriott.com</a></td>
    </tr><tr><td>128</td>
    <td>Avnet</td>
    <td><a href="http://www.avnet.com">http://www.avnet.com</a></td>
    </tr><tr><td>129</td>
    <td>Eli Lilly</td>
    <td><a href="http://www.lilly.com">http://www.lilly.com</a></td>
    </tr><tr><td>130</td>
    <td>Amgen</td>
    <td><a href="http://www.amgen.com">http://www.amgen.com</a></td>
    </tr><tr><td>131</td>
    <td>McDonald’s</td>
    <td><a href="http://www.aboutmcdonalds.com">http://www.aboutmcdonalds.com</a></td>
    </tr><tr><td>132</td>
    <td>Starbucks</td>
    <td><a href="http://www.starbucks.com">http://www.starbucks.com</a></td>
    </tr><tr><td>133</td>
    <td>Qualcomm</td>
    <td><a href="http://www.qualcomm.com">http://www.qualcomm.com</a></td>
    </tr><tr><td>134</td>
    <td>Dollar Tree</td>
    <td><a href="http://www.dollartree.com">http://www.dollartree.com</a></td>
    </tr><tr><td>135</td>
    <td>PBF Energy</td>
    <td><a href="http://www.pbfenergy.com">http://www.pbfenergy.com</a></td>
    </tr><tr><td>136</td>
    <td>Icahn Enterprises</td>
    <td><a href="http://www.ielp.com">http://www.ielp.com</a></td>
    </tr><tr><td>137</td>
    <td>Aflac</td>
    <td><a href="http://www.aflac.com">http://www.aflac.com</a></td>
    </tr><tr><td>138</td>
    <td>AutoNation</td>
    <td><a href="http://www.autonation.com">http://www.autonation.com</a></td>
    </tr><tr><td>139</td>
    <td>Penske Automotive Group</td>
    <td><a href="http://www.penskeautomotive.com">http://www.penskeautomotive.com</a></td>
    </tr><tr><td>140</td>
    <td>Whirlpool</td>
    <td><a href="http://www.whirlpoolcorp.com">http://www.whirlpoolcorp.com</a></td>
    </tr><tr><td>141</td>
    <td>Union Pacific</td>
    <td><a href="http://www.up.com">http://www.up.com</a></td>
    </tr><tr><td>142</td>
    <td>Southwest Airlines</td>
    <td><a href="http://www.southwest.com">http://www.southwest.com</a></td>
    </tr><tr><td>143</td>
    <td>ManpowerGroup</td>
    <td><a href="http://www.manpowergroup.com">http://www.manpowergroup.com</a></td>
    </tr><tr><td>144</td>
    <td>Thermo Fisher Scientific</td>
    <td><a href="http://www.thermofisher.com">http://www.thermofisher.com</a></td>
    </tr><tr><td>145</td>
    <td>Bristol-Myers Squibb</td>
    <td><a href="http://www.bms.com">http://www.bms.com</a></td>
    </tr><tr><td>146</td>
    <td>Halliburton</td>
    <td><a href="http://www.halliburton.com">http://www.halliburton.com</a></td>
    </tr><tr><td>147</td>
    <td>Tenet Healthcare</td>
    <td><a href="http://www.tenethealth.com">http://www.tenethealth.com</a></td>
    </tr><tr><td>148</td>
    <td>Lear</td>
    <td><a href="http://www.lear.com">http://www.lear.com</a></td>
    </tr><tr><td>149</td>
    <td>Cummins</td>
    <td><a href="http://www.cummins.com">http://www.cummins.com</a></td>
    </tr><tr><td>150</td>
    <td>Micron Technology</td>
    <td><a href="http://www.micron.com">http://www.micron.com</a></td>
    </tr><tr><td>151</td>
    <td>Nucor</td>
    <td><a href="http://www.nucor.com">http://www.nucor.com</a></td>
    </tr><tr><td>152</td>
    <td>Molina Healthcare</td>
    <td><a href="http://www.molinahealthcare.com">http://www.molinahealthcare.com</a></td>
    </tr><tr><td>153</td>
    <td>Fluor</td>
    <td><a href="http://www.fluor.com">http://www.fluor.com</a></td>
    </tr><tr><td>154</td>
    <td>Altria Group</td>
    <td><a href="http://www.altria.com">http://www.altria.com</a></td>
    </tr><tr><td>155</td>
    <td>Paccar</td>
    <td><a href="http://www.paccar.com">http://www.paccar.com</a></td>
    </tr><tr><td>156</td>
    <td>Hartford Financial Services</td>
    <td><a href="http://www.thehartford.com">http://www.thehartford.com</a></td>
    </tr><tr><td>157</td>
    <td>Kohl’s</td>
    <td><a href="http://www.kohls.com">http://www.kohls.com</a></td>
    </tr><tr><td>158</td>
    <td>Western Digital</td>
    <td><a href="http://www.wdc.com">http://www.wdc.com</a></td>
    </tr><tr><td>159</td>
    <td>Jabil</td>
    <td><a href="www.jabil.com">www.jabil.com</a></td>
    </tr><tr><td>160</td>
    <td>Community Health Systems</td>
    <td><a href="http://www.chs.net">http://www.chs.net</a></td>
    </tr><tr><td>161</td>
    <td>Visa</td>
    <td><a href="http://www.visa.com">http://www.visa.com</a></td>
    </tr><tr><td>162</td>
    <td>Danaher</td>
    <td><a href="http://www.danaher.com">http://www.danaher.com</a></td>
    </tr><tr><td>163</td>
    <td>Kimberly-Clark</td>
    <td><a href="http://www.kimberly-clark.com">http://www.kimberly-clark.com</a></td>
    </tr><tr><td>164</td>
    <td>AECOM</td>
    <td><a href="http://www.aecom.com">http://www.aecom.com</a></td>
    </tr><tr><td>165</td>
    <td>PNC Financial Services</td>
    <td><a href="http://www.pnc.com">http://www.pnc.com</a></td>
    </tr><tr><td>166</td>
    <td>CenturyLink</td>
    <td><a href="http://www.centurylink.com">http://www.centurylink.com</a></td>
    </tr><tr><td>167</td>
    <td>NextEra Energy</td>
    <td><a href="http://www.nexteraenergy.com">http://www.nexteraenergy.com</a></td>
    </tr><tr><td>168</td>
    <td>PG&amp;E Corp.</td>
    <td><a href="http://www.pgecorp.com">http://www.pgecorp.com</a></td>
    </tr><tr><td>169</td>
    <td>Synnex</td>
    <td><a href="http://www.synnex.com">http://www.synnex.com</a></td>
    </tr><tr><td>170</td>
    <td>WellCare Health Plans</td>
    <td><a href="http://www.wellcare.com">http://www.wellcare.com</a></td>
    </tr><tr><td>171</td>
    <td>Performance Food Group</td>
    <td><a href="http://www.pfgc.com">http://www.pfgc.com</a></td>
    </tr><tr><td>172</td>
    <td>Sears Holdings</td>
    <td><a href="http://www.searsholdings.com">http://www.searsholdings.com</a></td>
    </tr><tr><td>173</td>
    <td>Synchrony Financial</td>
    <td><a href="http://www.synchronyfinancial.com">http://www.synchronyfinancial.com</a></td>
    </tr><tr><td>174</td>
    <td>CarMax</td>
    <td><a href="http://www.carmax.com">http://www.carmax.com</a></td>
    </tr><tr><td>175</td>
    <td>Bank of New York Mellon</td>
    <td><a href="www.bnymellon.com">www.bnymellon.com</a></td>
    </tr><tr><td>176</td>
    <td>Freeport-McMoRan</td>
    <td><a href="http://www.fcx.com">http://www.fcx.com</a></td>
    </tr><tr><td>177</td>
    <td>Genuine Parts</td>
    <td><a href="http://www.genpt.com">http://www.genpt.com</a></td>
    </tr><tr><td>178</td>
    <td>Emerson Electric</td>
    <td><a href="http://www.emerson.com">http://www.emerson.com</a></td>
    </tr><tr><td>179</td>
    <td>DaVita</td>
    <td><a href="http://www.davita.com">http://www.davita.com</a></td>
    </tr><tr><td>180</td>
    <td>Supervalu</td>
    <td><a href="http://www.supervalu.com">http://www.supervalu.com</a></td>
    </tr><tr><td>181</td>
    <td>Gap</td>
    <td><a href="http://www.gapinc.com">http://www.gapinc.com</a></td>
    </tr><tr><td>182</td>
    <td>General Mills</td>
    <td><a href="http://www.generalmills.com">http://www.generalmills.com</a></td>
    </tr><tr><td>183</td>
    <td>Nordstrom</td>
    <td><a href="http://www.nordstrom.com">http://www.nordstrom.com</a></td>
    </tr><tr><td>184</td>
    <td>Colgate-Palmolive</td>
    <td><a href="http://www.colgatepalmolive.com">http://www.colgatepalmolive.com</a></td>
    </tr><tr><td>185</td>
    <td>American Electric Power</td>
    <td><a href="http://www.aep.com">http://www.aep.com</a></td>
    </tr><tr><td>186</td>
    <td>XPO Logistics</td>
    <td><a href="http://www.xpo.com">http://www.xpo.com</a></td>
    </tr><tr><td>187</td>
    <td>Goodyear Tire &amp; Rubber</td>
    <td><a href="http://www.goodyear.com">http://www.goodyear.com</a></td>
    </tr><tr><td>188</td>
    <td>Omnicom Group</td>
    <td><a href="http://www.omnicomgroup.com">http://www.omnicomgroup.com</a></td>
    </tr><tr><td>189</td>
    <td>CDW</td>
    <td><a href="http://www.cdw.com">http://www.cdw.com</a></td>
    </tr><tr><td>190</td>
    <td>Sherwin-Williams</td>
    <td><a href="http://www.sherwin.com">http://www.sherwin.com</a></td>
    </tr><tr><td>191</td>
    <td>PPG Industries</td>
    <td><a href="http://www.ppg.com">http://www.ppg.com</a></td>
    </tr><tr><td>192</td>
    <td>Texas Instruments</td>
    <td><a href="http://www.ti.com">http://www.ti.com</a></td>
    </tr><tr><td>193</td>
    <td>C.H. Robinson Worldwide</td>
    <td><a href="http://www.chrobinson.com">http://www.chrobinson.com</a></td>
    </tr><tr><td>194</td>
    <td>WestRock</td>
    <td><a href="http://www.westrock.com">http://www.westrock.com</a></td>
    </tr><tr><td>195</td>
    <td>Cognizant Technology Solutions</td>
    <td><a href="http://www.cognizant.com">http://www.cognizant.com</a></td>
    </tr><tr><td>196</td>
    <td>Newell Brands</td>
    <td><a href="http://www.newellbrands.com">http://www.newellbrands.com</a></td>
    </tr><tr><td>197</td>
    <td>CBS</td>
    <td><a href="http://www.cbscorporation.com">http://www.cbscorporation.com</a></td>
    </tr><tr><td>198</td>
    <td>Envision Healthcare</td>
    <td><a href="http://www.evhc.net">http://www.evhc.net</a></td>
    </tr><tr><td>199</td>
    <td>Monsanto</td>
    <td><a href="http://www.monsanto.com">http://www.monsanto.com</a></td>
    </tr><tr><td>200</td>
    <td>Aramark</td>
    <td><a href="http://www.aramark.com">http://www.aramark.com</a></td>
    </tr><tr><td>201</td>
    <td>Applied Materials</td>
    <td><a href="http://www.appliedmaterials.com">http://www.appliedmaterials.com</a></td>
    </tr><tr><td>202</td>
    <td>Waste Management</td>
    <td><a href="http://www.wm.com">http://www.wm.com</a></td>
    </tr><tr><td>203</td>
    <td>DISH Network</td>
    <td><a href="http://www.dish.com">http://www.dish.com</a></td>
    </tr><tr><td>204</td>
    <td>Illinois Tool Works</td>
    <td><a href="http://www.itw.com">http://www.itw.com</a></td>
    </tr><tr><td>205</td>
    <td>Lincoln National</td>
    <td><a href="http://www.lfg.com">http://www.lfg.com</a></td>
    </tr><tr><td>206</td>
    <td>HollyFrontier</td>
    <td><a href="http://www.hollyfrontier.com">http://www.hollyfrontier.com</a></td>
    </tr><tr><td>207</td>
    <td>CBRE Group</td>
    <td><a href="http://www.cbre.com">http://www.cbre.com</a></td>
    </tr><tr><td>208</td>
    <td>Textron</td>
    <td><a href="http://www.textron.com">http://www.textron.com</a></td>
    </tr><tr><td>209</td>
    <td>Ross Stores</td>
    <td><a href="http://www.rossstores.com">http://www.rossstores.com</a></td>
    </tr><tr><td>210</td>
    <td>Principal Financial</td>
    <td><a href="http://www.principal.com">http://www.principal.com</a></td>
    </tr><tr><td>211</td>
    <td>D.R. Horton</td>
    <td><a href="http://www.drhorton.com">http://www.drhorton.com</a></td>
    </tr><tr><td>212</td>
    <td>Marsh &amp; McLennan</td>
    <td><a href="http://www.mmc.com">http://www.mmc.com</a></td>
    </tr><tr><td>213</td>
    <td>Devon Energy</td>
    <td><a href="http://www.devonenergy.com">http://www.devonenergy.com</a></td>
    </tr><tr><td>214</td>
    <td>AES</td>
    <td><a href="http://www.aes.com">http://www.aes.com</a></td>
    </tr><tr><td>215</td>
    <td>Ecolab</td>
    <td><a href="http://www.ecolab.com">http://www.ecolab.com</a></td>
    </tr><tr><td>216</td>
    <td>Land O’Lakes</td>
    <td><a href="http://www.landolakesinc.com">http://www.landolakesinc.com</a></td>
    </tr><tr><td>217</td>
    <td>Loews</td>
    <td><a href="http://www.loews.com">http://www.loews.com</a></td>
    </tr><tr><td>218</td>
    <td>Kinder Morgan</td>
    <td><a href="http://www.kindermorgan.com">http://www.kindermorgan.com</a></td>
    </tr><tr><td>219</td>
    <td>FirstEnergy</td>
    <td><a href="http://www.firstenergycorp.com">http://www.firstenergycorp.com</a></td>
    </tr><tr><td>220</td>
    <td>Occidental Petroleum</td>
    <td><a href="http://www.oxy.com">http://www.oxy.com</a></td>
    </tr><tr><td>221</td>
    <td>Viacom</td>
    <td><a href="http://www.viacom.com">http://www.viacom.com</a></td>
    </tr><tr><td>222</td>
    <td>PayPal Holdings</td>
    <td><a href="http://www.paypal.com">http://www.paypal.com</a></td>
    </tr><tr><td>223</td>
    <td>NGL Energy Partners</td>
    <td><a href="http://www.nglenergypartners.com">http://www.nglenergypartners.com</a></td>
    </tr><tr><td>224</td>
    <td>Celgene</td>
    <td><a href="http://www.celgene.com">http://www.celgene.com</a></td>
    </tr><tr><td>225</td>
    <td>Arconic</td>
    <td><a href="http://www.arconic.com">http://www.arconic.com</a></td>
    </tr><tr><td>226</td>
    <td>Kellogg</td>
    <td><a href="http://www.kelloggcompany.com">http://www.kelloggcompany.com</a></td>
    </tr><tr><td>227</td>
    <td>Las Vegas Sands</td>
    <td><a href="http://www.sands.com">http://www.sands.com</a></td>
    </tr><tr><td>228</td>
    <td>Stanley Black &amp; Decker</td>
    <td><a href="http://www.stanleyblackanddecker.com">http://www.stanleyblackanddecker.com</a></td>
    </tr><tr><td>229</td>
    <td>Booking Holdings</td>
    <td><a href="http://www.bookingholdings.com">http://www.bookingholdings.com</a></td>
    </tr><tr><td>230</td>
    <td>Lennar</td>
    <td><a href="http://www.lennar.com">http://www.lennar.com</a></td>
    </tr><tr><td>231</td>
    <td>L Brands</td>
    <td><a href="http://www.lb.com">http://www.lb.com</a></td>
    </tr><tr><td>232</td>
    <td>DTE Energy</td>
    <td><a href="http://www.dteenergy.com">http://www.dteenergy.com</a></td>
    </tr><tr><td>233</td>
    <td>Dominion Energy</td>
    <td><a href="www.dominionenergy.com">www.dominionenergy.com</a></td>
    </tr><tr><td>234</td>
    <td>Reinsurance Group of America</td>
    <td><a href="http://www.rgare.com">http://www.rgare.com</a></td>
    </tr><tr><td>235</td>
    <td>J.C. Penney</td>
    <td><a href="http://www.jcpenney.com">http://www.jcpenney.com</a></td>
    </tr><tr><td>236</td>
    <td>Mastercard</td>
    <td><a href="http://www.mastercard.com">http://www.mastercard.com</a></td>
    </tr><tr><td>237</td>
    <td>BlackRock</td>
    <td><a href="http://www.blackrock.com">http://www.blackrock.com</a></td>
    </tr><tr><td>238</td>
    <td>Henry Schein</td>
    <td><a href="http://www.henryschein.com">http://www.henryschein.com</a></td>
    </tr><tr><td>239</td>
    <td>Guardian Life Ins. Co. of America</td>
    <td><a href="http://www.guardianlife.com">http://www.guardianlife.com</a></td>
    </tr><tr><td>240</td>
    <td>Stryker</td>
    <td><a href="http://www.stryker.com">http://www.stryker.com</a></td>
    </tr><tr><td>241</td>
    <td>Jefferies Financial Group</td>
    <td><a href="http://www.jefferies.com">http://www.jefferies.com</a></td>
    </tr><tr><td>242</td>
    <td>VF</td>
    <td><a href="http://www.vfc.com">http://www.vfc.com</a></td>
    </tr><tr><td>243</td>
    <td>ADP</td>
    <td><a href="http://www.adp.com">http://www.adp.com</a></td>
    </tr><tr><td>244</td>
    <td>Edison International</td>
    <td><a href="http://www.edisoninvestor.com">http://www.edisoninvestor.com</a></td>
    </tr><tr><td>245</td>
    <td>Biogen</td>
    <td><a href="http://www.biogen.com">http://www.biogen.com</a></td>
    </tr><tr><td>246</td>
    <td>United States Steel</td>
    <td><a href="http://www.ussteel.com">http://www.ussteel.com</a></td>
    </tr><tr><td>247</td>
    <td>Core-Mark Holding</td>
    <td><a href="http://www.core-mark.com">http://www.core-mark.com</a></td>
    </tr><tr><td>248</td>
    <td>Bed Bath &amp; Beyond</td>
    <td><a href="http://www.bedbathandbeyond.com">http://www.bedbathandbeyond.com</a></td>
    </tr><tr><td>249</td>
    <td>Oneok</td>
    <td><a href="http://www.oneok.com">http://www.oneok.com</a></td>
    </tr><tr><td>250</td>
    <td>BB&amp;T Corp.</td>
    <td><a href="http://www.bbt.com">http://www.bbt.com</a></td>
    </tr><tr><td>251</td>
    <td>Becton Dickinson</td>
    <td><a href="http://www.bd.com">http://www.bd.com</a></td>
    </tr><tr><td>252</td>
    <td>Ameriprise Financial</td>
    <td><a href="http://www.ameriprise.com">http://www.ameriprise.com</a></td>
    </tr><tr><td>253</td>
    <td>Farmers Insurance Exchange</td>
    <td><a href="http://www.farmers.com">http://www.farmers.com</a></td>
    </tr><tr><td>254</td>
    <td>First Data</td>
    <td><a href="http://www.firstdata.com">http://www.firstdata.com</a></td>
    </tr><tr><td>255</td>
    <td>Consolidated Edison</td>
    <td><a href="http://www.conedison.com">http://www.conedison.com</a></td>
    </tr><tr><td>256</td>
    <td>Parker-Hannifin</td>
    <td><a href="http://www.parker.com">http://www.parker.com</a></td>
    </tr><tr><td>257</td>
    <td>Anadarko Petroleum</td>
    <td><a href="http://www.anadarko.com">http://www.anadarko.com</a></td>
    </tr><tr><td>258</td>
    <td>Estee Lauder</td>
    <td><a href="http://www.elcompanies.com">http://www.elcompanies.com</a></td>
    </tr><tr><td>259</td>
    <td>State Street Corp.</td>
    <td><a href="http://www.statestreet.com">http://www.statestreet.com</a></td>
    </tr><tr><td>260</td>
    <td>Tesla</td>
    <td><a href="http://www.tesla.com">http://www.tesla.com</a></td>
    </tr><tr><td>261</td>
    <td>Netflix</td>
    <td><a href="http://www.netflix.com">http://www.netflix.com</a></td>
    </tr><tr><td>262</td>
    <td>Alcoa</td>
    <td><a href="http://www.alcoa.com">http://www.alcoa.com</a></td>
    </tr><tr><td>263</td>
    <td>Discover Financial Services</td>
    <td><a href="http://www.discover.com">http://www.discover.com</a></td>
    </tr><tr><td>264</td>
    <td>Praxair</td>
    <td><a href="http://www.praxair.com">http://www.praxair.com</a></td>
    </tr><tr><td>265</td>
    <td>CSX</td>
    <td><a href="http://www.csx.com">http://www.csx.com</a></td>
    </tr><tr><td>266</td>
    <td>Xcel Energy</td>
    <td><a href="http://www.xcelenergy.com">http://www.xcelenergy.com</a></td>
    </tr><tr><td>267</td>
    <td>Unum Group</td>
    <td><a href="http://www.unum.com">http://www.unum.com</a></td>
    </tr><tr><td>268</td>
    <td>Universal Health Services</td>
    <td><a href="http://www.uhsinc.com">http://www.uhsinc.com</a></td>
    </tr><tr><td>269</td>
    <td>NRG Energy</td>
    <td><a href="http://www.nrg.com">http://www.nrg.com</a></td>
    </tr><tr><td>270</td>
    <td>EOG Resources</td>
    <td><a href="http://www.eogresources.com">http://www.eogresources.com</a></td>
    </tr><tr><td>271</td>
    <td>Sempra Energy</td>
    <td><a href="http://www.sempra.com">http://www.sempra.com</a></td>
    </tr><tr><td>272</td>
    <td>Toys “R” Us</td>
    <td><a href="http://www.toysrusinc.com">http://www.toysrusinc.com</a></td>
    </tr><tr><td>273</td>
    <td>Group Automotive</td>
    <td><a href="http://www.group1auto.com">http://www.group1auto.com</a></td>
    </tr><tr><td>274</td>
    <td>Entergy</td>
    <td><a href="http://www.entergy.com">http://www.entergy.com</a></td>
    </tr><tr><td>275</td>
    <td>Molson Coors Brewing</td>
    <td><a href="http://www.molsoncoors.com">http://www.molsoncoors.com</a></td>
    </tr><tr><td>276</td>
    <td>L Technologies</td>
    <td><a href="http://www.l3t.com">http://www.l3t.com</a></td>
    </tr><tr><td>277</td>
    <td>Ball</td>
    <td><a href="http://www.ball.com">http://www.ball.com</a></td>
    </tr><tr><td>278</td>
    <td>AutoZone</td>
    <td><a href="http://www.autozone.com">http://www.autozone.com</a></td>
    </tr><tr><td>279</td>
    <td>Murphy USA</td>
    <td><a href="http://www.murphyusa.com">http://www.murphyusa.com</a></td>
    </tr><tr><td>280</td>
    <td>MGM Resorts International</td>
    <td><a href="http://www.mgmresorts.com">http://www.mgmresorts.com</a></td>
    </tr><tr><td>281</td>
    <td>Office Depot</td>
    <td><a href="http://www.officedepot.com">http://www.officedepot.com</a></td>
    </tr><tr><td>282</td>
    <td>Huntsman</td>
    <td><a href="http://www.huntsman.com">http://www.huntsman.com</a></td>
    </tr><tr><td>283</td>
    <td>Baxter International</td>
    <td><a href="http://www.baxter.com">http://www.baxter.com</a></td>
    </tr><tr><td>284</td>
    <td>Norfolk Southern</td>
    <td><a href="http://www.norfolksouthern.com">http://www.norfolksouthern.com</a></td>
    </tr><tr><td>285</td>
    <td>salesforce.com</td>
    <td><a href="http://www.salesforce.com">http://www.salesforce.com</a></td>
    </tr><tr><td>286</td>
    <td>Laboratory Corp. of America</td>
    <td><a href="http://www.labcorp.com">http://www.labcorp.com</a></td>
    </tr><tr><td>287</td>
    <td>W.W. Grainger</td>
    <td><a href="http://www.grainger.com">http://www.grainger.com</a></td>
    </tr><tr><td>288</td>
    <td>Qurate Retail</td>
    <td><a href="http://www.libertyinteractive.com">http://www.libertyinteractive.com</a></td>
    </tr><tr><td>289</td>
    <td>Autoliv</td>
    <td><a href="http://www.autoliv.com">http://www.autoliv.com</a></td>
    </tr><tr><td>290</td>
    <td>Live Nation Entertainment</td>
    <td><a href="http://www.livenationentertainment.com">http://www.livenationentertainment.com</a></td>
    </tr><tr><td>291</td>
    <td>Xerox</td>
    <td><a href="http://www.xerox.com">http://www.xerox.com</a></td>
    </tr><tr><td>292</td>
    <td>Leidos Holdings</td>
    <td><a href="http://www.leidos.com">http://www.leidos.com</a></td>
    </tr><tr><td>293</td>
    <td>Corning</td>
    <td><a href="http://www.corning.com">http://www.corning.com</a></td>
    </tr><tr><td>294</td>
    <td>Lithia Motors</td>
    <td><a href="http://www.lithiainvestorrelations.com">http://www.lithiainvestorrelations.com</a></td>
    </tr><tr><td>295</td>
    <td>Expedia Group</td>
    <td><a href="http://www.expediagroup.com">http://www.expediagroup.com</a></td>
    </tr><tr><td>296</td>
    <td>Republic Services</td>
    <td><a href="http://www.republicservices.com">http://www.republicservices.com</a></td>
    </tr><tr><td>297</td>
    <td>Jacobs Engineering Group</td>
    <td><a href="http://www.jacobs.com">http://www.jacobs.com</a></td>
    </tr><tr><td>298</td>
    <td>Sonic Automotive</td>
    <td><a href="http://www.sonicautomotive.com">http://www.sonicautomotive.com</a></td>
    </tr><tr><td>299</td>
    <td>Ally Financial</td>
    <td><a href="http://www.ally.com">http://www.ally.com</a></td>
    </tr><tr><td>300</td>
    <td>LKQ</td>
    <td><a href="http://www.lkqcorp.com">http://www.lkqcorp.com</a></td>
    </tr><tr><td>301</td>
    <td>BorgWarner</td>
    <td><a href="http://www.borgwarner.com">http://www.borgwarner.com</a></td>
    </tr><tr><td>302</td>
    <td>Fidelity National Financial</td>
    <td><a href="http://www.fnf.com">http://www.fnf.com</a></td>
    </tr><tr><td>303</td>
    <td>SunTrust Banks</td>
    <td><a href="http://www.suntrust.com">http://www.suntrust.com</a></td>
    </tr><tr><td>304</td>
    <td>IQVIA Holdings</td>
    <td><a href="www.iqvia.com">www.iqvia.com</a></td>
    </tr><tr><td>305</td>
    <td>Reliance Steel &amp; Aluminum</td>
    <td><a href="http://www.rsac.com">http://www.rsac.com</a></td>
    </tr><tr><td>306</td>
    <td>Nvidia</td>
    <td><a href="http://www.nvidia.com">http://www.nvidia.com</a></td>
    </tr><tr><td>307</td>
    <td>Voya Financial</td>
    <td><a href="http://www.voya.com">http://www.voya.com</a></td>
    </tr><tr><td>308</td>
    <td>CenterPoint Energy</td>
    <td><a href="http://www.centerpointenergy.com">http://www.centerpointenergy.com</a></td>
    </tr><tr><td>309</td>
    <td>eBay</td>
    <td><a href="http://www.ebay.com">http://www.ebay.com</a></td>
    </tr><tr><td>310</td>
    <td>Eastman Chemical</td>
    <td><a href="http://www.eastman.com">http://www.eastman.com</a></td>
    </tr><tr><td>311</td>
    <td>American Family Insurance Group</td>
    <td><a href="http://www.amfam.com">http://www.amfam.com</a></td>
    </tr><tr><td>312</td>
    <td>Steel Dynamics</td>
    <td><a href="http://www.steeldynamics.com">http://www.steeldynamics.com</a></td>
    </tr><tr><td>313</td>
    <td>Pacific Life</td>
    <td><a href="http://www.pacificlife.com">http://www.pacificlife.com</a></td>
    </tr><tr><td>314</td>
    <td>Chesapeake Energy</td>
    <td><a href="http://www.chk.com">http://www.chk.com</a></td>
    </tr><tr><td>315</td>
    <td>Mohawk Industries</td>
    <td><a href="http://www.mohawkind.com">http://www.mohawkind.com</a></td>
    </tr><tr><td>316</td>
    <td>Quanta Services</td>
    <td><a href="http://www.quantaservices.com">http://www.quantaservices.com</a></td>
    </tr><tr><td>317</td>
    <td>Advance Auto Parts</td>
    <td><a href="http://www.advanceautoparts.com">http://www.advanceautoparts.com</a></td>
    </tr><tr><td>318</td>
    <td>Owens &amp; Minor</td>
    <td><a href="http://www.owens-minor.com">http://www.owens-minor.com</a></td>
    </tr><tr><td>319</td>
    <td>United Natural Foods</td>
    <td><a href="http://www.unfi.com">http://www.unfi.com</a></td>
    </tr><tr><td>320</td>
    <td>Tenneco</td>
    <td><a href="http://www.tenneco.com">http://www.tenneco.com</a></td>
    </tr><tr><td>321</td>
    <td>Conagra Brands</td>
    <td><a href="http://www.conagrabrands.com">http://www.conagrabrands.com</a></td>
    </tr><tr><td>322</td>
    <td>GameStop</td>
    <td><a href="http://www.gamestop.com">http://www.gamestop.com</a></td>
    </tr><tr><td>323</td>
    <td>Hormel Foods</td>
    <td><a href="http://www.hormelfoods.com">http://www.hormelfoods.com</a></td>
    </tr><tr><td>324</td>
    <td>Hilton Worldwide Holdings</td>
    <td><a href="http://www.hiltonworldwide.com">http://www.hiltonworldwide.com</a></td>
    </tr><tr><td>325</td>
    <td>Frontier Communications</td>
    <td><a href="http://www.frontier.com">http://www.frontier.com</a></td>
    </tr><tr><td>326</td>
    <td>Fidelity National Information Services</td>
    <td><a href="http://www.fisglobal.com">http://www.fisglobal.com</a></td>
    </tr><tr><td>327</td>
    <td>Public Service Enterprise Group</td>
    <td><a href="http://www.pseg.com">http://www.pseg.com</a></td>
    </tr><tr><td>328</td>
    <td>Boston Scientific</td>
    <td><a href="http://www.bostonscientific.com">http://www.bostonscientific.com</a></td>
    </tr><tr><td>329</td>
    <td>O’Reilly Automotive</td>
    <td><a href="http://www.oreillyauto.com">http://www.oreillyauto.com</a></td>
    </tr><tr><td>330</td>
    <td>Charles Schwab</td>
    <td><a href="http://www.aboutschwab.com">http://www.aboutschwab.com</a></td>
    </tr><tr><td>331</td>
    <td>Global Partners</td>
    <td><a href="http://www.globalp.com">http://www.globalp.com</a></td>
    </tr><tr><td>332</td>
    <td>PVH</td>
    <td><a href="http://www.pvh.com">http://www.pvh.com</a></td>
    </tr><tr><td>333</td>
    <td>Avis Budget Group</td>
    <td><a href="http://www.avisbudgetgroup.com">http://www.avisbudgetgroup.com</a></td>
    </tr><tr><td>334</td>
    <td>Targa Resources</td>
    <td><a href="http://www.targaresources.com">http://www.targaresources.com</a></td>
    </tr><tr><td>335</td>
    <td>Hertz Global Holdings</td>
    <td><a href="http://www.hertz.com">http://www.hertz.com</a></td>
    </tr><tr><td>336</td>
    <td>Calpine</td>
    <td><a href="http://www.calpine.com">http://www.calpine.com</a></td>
    </tr><tr><td>337</td>
    <td>Mutual of Omaha Insurance</td>
    <td><a href="http://www.mutualofomaha.com">http://www.mutualofomaha.com</a></td>
    </tr><tr><td>338</td>
    <td>Crown Holdings</td>
    <td><a href="http://www.crowncork.com">http://www.crowncork.com</a></td>
    </tr><tr><td>339</td>
    <td>Peter Kiewit Sons’</td>
    <td><a href="http://www.kiewit.com">http://www.kiewit.com</a></td>
    </tr><tr><td>340</td>
    <td>Dick’s Sporting Goods</td>
    <td><a href="http://www.dicks.com">http://www.dicks.com</a></td>
    </tr><tr><td>341</td>
    <td>PulteGroup</td>
    <td><a href="http://www.pultegroupinc.com">http://www.pultegroupinc.com</a></td>
    </tr><tr><td>342</td>
    <td>Navistar International</td>
    <td><a href="http://www.navistar.com">http://www.navistar.com</a></td>
    </tr><tr><td>343</td>
    <td>Thrivent Financial for Lutherans</td>
    <td><a href="http://www.thrivent.com">http://www.thrivent.com</a></td>
    </tr><tr><td>344</td>
    <td>DCP Midstream</td>
    <td><a href="http://www.dcpmidstream.com">http://www.dcpmidstream.com</a></td>
    </tr><tr><td>345</td>
    <td>Air Products &amp; Chemicals</td>
    <td><a href="http://www.airproducts.com">http://www.airproducts.com</a></td>
    </tr><tr><td>346</td>
    <td>Veritiv</td>
    <td><a href="http://www.veritivcorp.com">http://www.veritivcorp.com</a></td>
    </tr><tr><td>347</td>
    <td>AGCO</td>
    <td><a href="http://www.agcocorp.com">http://www.agcocorp.com</a></td>
    </tr><tr><td>348</td>
    <td>Genworth Financial</td>
    <td><a href="http://www.genworth.com">http://www.genworth.com</a></td>
    </tr><tr><td>349</td>
    <td>Univar</td>
    <td><a href="http://www.univar.com">http://www.univar.com</a></td>
    </tr><tr><td>350</td>
    <td>News Corp.</td>
    <td><a href="http://www.newscorp.com">http://www.newscorp.com</a></td>
    </tr><tr><td>351</td>
    <td>SpartanNash</td>
    <td><a href="http://www.spartannash.com">http://www.spartannash.com</a></td>
    </tr><tr><td>352</td>
    <td>Westlake Chemical</td>
    <td><a href="http://www.westlake.com">http://www.westlake.com</a></td>
    </tr><tr><td>353</td>
    <td>Williams</td>
    <td><a href="http://www.williams.com">http://www.williams.com</a></td>
    </tr><tr><td>354</td>
    <td>Lam Research</td>
    <td><a href="http://www.lamresearch.com">http://www.lamresearch.com</a></td>
    </tr><tr><td>355</td>
    <td>Alaska Air Group</td>
    <td><a href="http://www.alaskaair.com">http://www.alaskaair.com</a></td>
    </tr><tr><td>356</td>
    <td>Jones Lang LaSalle</td>
    <td><a href="http://www.jll.com">http://www.jll.com</a></td>
    </tr><tr><td>357</td>
    <td>Anixter International</td>
    <td><a href="http://www.anixter.com">http://www.anixter.com</a></td>
    </tr><tr><td>358</td>
    <td>Campbell Soup</td>
    <td><a href="http://www.campbellsoupcompany.com">http://www.campbellsoupcompany.com</a></td>
    </tr><tr><td>359</td>
    <td>Interpublic Group</td>
    <td><a href="http://www.interpublic.com">http://www.interpublic.com</a></td>
    </tr><tr><td>360</td>
    <td>Dover</td>
    <td><a href="http://www.dovercorporation.com">http://www.dovercorporation.com</a></td>
    </tr><tr><td>361</td>
    <td>Zimmer Biomet Holdings</td>
    <td><a href="http://www.zimmerbiomet.com">http://www.zimmerbiomet.com</a></td>
    </tr><tr><td>362</td>
    <td>Dean Foods</td>
    <td><a href="http://www.deanfoods.com">http://www.deanfoods.com</a></td>
    </tr><tr><td>363</td>
    <td>Foot Locker</td>
    <td><a href="http://www.footlocker-inc.com">http://www.footlocker-inc.com</a></td>
    </tr><tr><td>364</td>
    <td>Eversource Energy</td>
    <td><a href="http://www.eversource.com">http://www.eversource.com</a></td>
    </tr><tr><td>365</td>
    <td>Alliance Data Systems</td>
    <td><a href="http://www.alliancedata.com">http://www.alliancedata.com</a></td>
    </tr><tr><td>366</td>
    <td>Fifth Third Bancorp</td>
    <td><a href="http://www.53.com">http://www.53.com</a></td>
    </tr><tr><td>367</td>
    <td>Quest Diagnostics</td>
    <td><a href="http://www.questdiagnostics.com">http://www.questdiagnostics.com</a></td>
    </tr><tr><td>368</td>
    <td>EMCOR Group</td>
    <td><a href="http://www.emcorgroup.com">http://www.emcorgroup.com</a></td>
    </tr><tr><td>369</td>
    <td>W.R. Berkley</td>
    <td><a href="http://www.wrberkley.com">http://www.wrberkley.com</a></td>
    </tr><tr><td>370</td>
    <td>WESCO International</td>
    <td><a href="http://www.wesco.com">http://www.wesco.com</a></td>
    </tr><tr><td>371</td>
    <td>Coty</td>
    <td><a href="http://www.coty.com">http://www.coty.com</a></td>
    </tr><tr><td>372</td>
    <td>WEC Energy Group</td>
    <td><a href="http://www.wecenergygroup.com">http://www.wecenergygroup.com</a></td>
    </tr><tr><td>373</td>
    <td>Masco</td>
    <td><a href="http://www.masco.com">http://www.masco.com</a></td>
    </tr><tr><td>374</td>
    <td>DXC Technology</td>
    <td><a href="http://www.dxc.technology">http://www.dxc.technology</a></td>
    </tr><tr><td>375</td>
    <td>Auto-Owners Insurance</td>
    <td><a href="http://www.auto-owners.com">http://www.auto-owners.com</a></td>
    </tr><tr><td>376</td>
    <td>Jones Financial (Edward Jones)</td>
    <td><a href="www.iqvia.comwww.edwardjones.com">www.iqvia.comwww.edwardjones.com</a></td>
    </tr><tr><td>377</td>
    <td>Liberty Media</td>
    <td><a href="http://www.libertymedia.com">http://www.libertymedia.com</a></td>
    </tr><tr><td>378</td>
    <td>Erie Insurance Group</td>
    <td><a href="http://www.erieinsurance.com">http://www.erieinsurance.com</a></td>
    </tr><tr><td>379</td>
    <td>Hershey</td>
    <td><a href="http://www.thehersheycompany.com">http://www.thehersheycompany.com</a></td>
    </tr><tr><td>380</td>
    <td>PPL</td>
    <td><a href="http://www.pplweb.com">http://www.pplweb.com</a></td>
    </tr><tr><td>381</td>
    <td>Huntington Ingalls Industries</td>
    <td><a href="http://www.huntingtoningalls.com">http://www.huntingtoningalls.com</a></td>
    </tr><tr><td>382</td>
    <td>Mosaic</td>
    <td><a href="http://www.mosaicco.com">http://www.mosaicco.com</a></td>
    </tr><tr><td>383</td>
    <td>J.M. Smucker</td>
    <td><a href="http://www.jmsmucker.com">http://www.jmsmucker.com</a></td>
    </tr><tr><td>384</td>
    <td>Delek US Holdings</td>
    <td><a href="http://www.delekus.com">http://www.delekus.com</a></td>
    </tr><tr><td>385</td>
    <td>Newmont Mining</td>
    <td><a href="http://www.newmont.com">http://www.newmont.com</a></td>
    </tr><tr><td>386</td>
    <td>Constellation Brands</td>
    <td><a href="http://www.cbrands.com">http://www.cbrands.com</a></td>
    </tr><tr><td>387</td>
    <td>Ryder System</td>
    <td><a href="http://www.ryder.com">http://www.ryder.com</a></td>
    </tr><tr><td>388</td>
    <td>National Oilwell Varco</td>
    <td><a href="http://www.nov.com">http://www.nov.com</a></td>
    </tr><tr><td>389</td>
    <td>Adobe Systems</td>
    <td><a href="http://www.adobe.com">http://www.adobe.com</a></td>
    </tr><tr><td>390</td>
    <td>LifePoint Health</td>
    <td><a href="http://www.lifepointhealth.net">http://www.lifepointhealth.net</a></td>
    </tr><tr><td>391</td>
    <td>Tractor Supply</td>
    <td><a href="http://www.tractorsupply.com">http://www.tractorsupply.com</a></td>
    </tr><tr><td>392</td>
    <td>Thor Industries</td>
    <td><a href="http://www.thorindustries.com">http://www.thorindustries.com</a></td>
    </tr><tr><td>393</td>
    <td>Dana</td>
    <td><a href="http://www.dana.com">http://www.dana.com</a></td>
    </tr><tr><td>394</td>
    <td>Weyerhaeuser</td>
    <td><a href="http://www.weyerhaeuser.com">http://www.weyerhaeuser.com</a></td>
    </tr><tr><td>395</td>
    <td>J.B. Hunt Transport Services</td>
    <td><a href="http://www.jbhunt.com">http://www.jbhunt.com</a></td>
    </tr><tr><td>396</td>
    <td>Darden Restaurants</td>
    <td><a href="http://www.darden.com">http://www.darden.com</a></td>
    </tr><tr><td>397</td>
    <td>Yum China Holdings</td>
    <td><a href="http://ir.yumchina.com">http://ir.yumchina.com</a></td>
    </tr><tr><td>398</td>
    <td>Blackstone Group</td>
    <td><a href="http://www.blackstone.com">http://www.blackstone.com</a></td>
    </tr><tr><td>399</td>
    <td>Berry Global Group</td>
    <td><a href="http://www.berryglobal.com">http://www.berryglobal.com</a></td>
    </tr><tr><td>400</td>
    <td>Builders FirstSource</td>
    <td><a href="http://www.bldr.com">http://www.bldr.com</a></td>
    </tr><tr><td>401</td>
    <td>Activision Blizzard</td>
    <td><a href="http://www.activisionblizzard.com">http://www.activisionblizzard.com</a></td>
    </tr><tr><td>402</td>
    <td>JetBlue Airways</td>
    <td><a href="http://www.jetblue.com">http://www.jetblue.com</a></td>
    </tr><tr><td>403</td>
    <td>Amphenol</td>
    <td><a href="http://www.amphenol.com">http://www.amphenol.com</a></td>
    </tr><tr><td>404</td>
    <td>A-Mark Precious Metals</td>
    <td><a href="http://www.amark.com">http://www.amark.com</a></td>
    </tr><tr><td>405</td>
    <td>Spirit AeroSystems Holdings</td>
    <td><a href="http://www.spiritaero.com">http://www.spiritaero.com</a></td>
    </tr><tr><td>406</td>
    <td>R.R. Donnelley &amp; Sons</td>
    <td><a href="http://www.rrdonnelley.com">http://www.rrdonnelley.com</a></td>
    </tr><tr><td>407</td>
    <td>Harris</td>
    <td><a href="http://www.harris.com">http://www.harris.com</a></td>
    </tr><tr><td>408</td>
    <td>Expeditors Intl. of Washington</td>
    <td><a href="http://www.expeditors.com">http://www.expeditors.com</a></td>
    </tr><tr><td>409</td>
    <td>Discovery</td>
    <td><a href="http://www.discovery.com">http://www.discovery.com</a></td>
    </tr><tr><td>410</td>
    <td>Owens-Illinois</td>
    <td><a href="http://www.o-i.com">http://www.o-i.com</a></td>
    </tr><tr><td>411</td>
    <td>Sanmina</td>
    <td><a href="http://www.sanmina.com">http://www.sanmina.com</a></td>
    </tr><tr><td>412</td>
    <td>KeyCorp</td>
    <td><a href="http://www.key.com">http://www.key.com</a></td>
    </tr><tr><td>413</td>
    <td>American Financial Group</td>
    <td><a href="http://www.afginc.com">http://www.afginc.com</a></td>
    </tr><tr><td>414</td>
    <td>Oshkosh</td>
    <td><a href="http://www.oshkoshcorporation.com">http://www.oshkoshcorporation.com</a></td>
    </tr><tr><td>415</td>
    <td>Rockwell Collins</td>
    <td><a href="http://www.rockwellcollins.com">http://www.rockwellcollins.com</a></td>
    </tr><tr><td>416</td>
    <td>Kindred Healthcare</td>
    <td><a href="http://www.kindredhealthcare.com">http://www.kindredhealthcare.com</a></td>
    </tr><tr><td>417</td>
    <td>Insight Enterprises</td>
    <td><a href="http://www.insight.com">http://www.insight.com</a></td>
    </tr><tr><td>418</td>
    <td>Dr Pepper Snapple Group</td>
    <td><a href="http://www.drpeppersnapplegroup.com">http://www.drpeppersnapplegroup.com</a></td>
    </tr><tr><td>419</td>
    <td>American Tower</td>
    <td><a href="http://www.americantower.com">http://www.americantower.com</a></td>
    </tr><tr><td>420</td>
    <td>Fortive</td>
    <td><a href="http://www.fortive.com">http://www.fortive.com</a></td>
    </tr><tr><td>421</td>
    <td>Ralph Lauren</td>
    <td><a href="http://www.ralphlauren.com">http://www.ralphlauren.com</a></td>
    </tr><tr><td>422</td>
    <td>HRG Group</td>
    <td><a href="http://www.hrggroup.com">http://www.hrggroup.com</a></td>
    </tr><tr><td>423</td>
    <td>Ascena Retail Group</td>
    <td><a href="http://www.ascenaretail.com">http://www.ascenaretail.com</a></td>
    </tr><tr><td>424</td>
    <td>United Rentals</td>
    <td><a href="http://www.unitedrentals.com">http://www.unitedrentals.com</a></td>
    </tr><tr><td>425</td>
    <td>Casey’s General Stores</td>
    <td><a href="http://www.caseys.com">http://www.caseys.com</a></td>
    </tr><tr><td>426</td>
    <td>Graybar Electric</td>
    <td><a href="http://www.graybar.com">http://www.graybar.com</a></td>
    </tr><tr><td>427</td>
    <td>Avery Dennison</td>
    <td><a href="http://www.averydennison.com">http://www.averydennison.com</a></td>
    </tr><tr><td>428</td>
    <td>MasTec</td>
    <td><a href="http://www.mastec.com">http://www.mastec.com</a></td>
    </tr><tr><td>429</td>
    <td>CMS Energy</td>
    <td><a href="http://www.cmsenergy.com">http://www.cmsenergy.com</a></td>
    </tr><tr><td>430</td>
    <td>HD Supply Holdings</td>
    <td><a href="http://www.hdsupply.com">http://www.hdsupply.com</a></td>
    </tr><tr><td>431</td>
    <td>Raymond James Financial</td>
    <td><a href="http://www.raymondjames.com">http://www.raymondjames.com</a></td>
    </tr><tr><td>432</td>
    <td>NCR</td>
    <td><a href="http://www.ncr.com">http://www.ncr.com</a></td>
    </tr><tr><td>433</td>
    <td>Hanesbrands</td>
    <td><a href="http://www.hanes.com">http://www.hanes.com</a></td>
    </tr><tr><td>434</td>
    <td>Asbury Automotive Group</td>
    <td><a href="http://www.asburyauto.com">http://www.asburyauto.com</a></td>
    </tr><tr><td>435</td>
    <td>Citizens Financial Group</td>
    <td><a href="http://www.citizensbank.com">http://www.citizensbank.com</a></td>
    </tr><tr><td>436</td>
    <td>Packaging Corp. of America</td>
    <td><a href="http://www.packagingcorp.com">http://www.packagingcorp.com</a></td>
    </tr><tr><td>437</td>
    <td>Alleghany</td>
    <td><a href="http://www.alleghany.com">http://www.alleghany.com</a></td>
    </tr><tr><td>438</td>
    <td>Apache</td>
    <td><a href="http://www.apachecorp.com">http://www.apachecorp.com</a></td>
    </tr><tr><td>439</td>
    <td>Dillard’s</td>
    <td><a href="http://www.dillards.com">http://www.dillards.com</a></td>
    </tr><tr><td>440</td>
    <td>Assurant</td>
    <td><a href="http://www.assurant.com">http://www.assurant.com</a></td>
    </tr><tr><td>441</td>
    <td>Franklin Resources</td>
    <td><a href="http://www.franklinresources.com">http://www.franklinresources.com</a></td>
    </tr><tr><td>442</td>
    <td>Owens Corning</td>
    <td><a href="http://www.owenscorning.com">http://www.owenscorning.com</a></td>
    </tr><tr><td>443</td>
    <td>Motorola Solutions</td>
    <td><a href="http://www.motorolasolutions.com">http://www.motorolasolutions.com</a></td>
    </tr><tr><td>444</td>
    <td>NVR</td>
    <td><a href="http://www.nvrinc.com">http://www.nvrinc.com</a></td>
    </tr><tr><td>445</td>
    <td>Rockwell Automation</td>
    <td><a href="http://www.rockwellautomation.com">http://www.rockwellautomation.com</a></td>
    </tr><tr><td>446</td>
    <td>TreeHouse Foods</td>
    <td><a href="http://www.treehousefoods.com">http://www.treehousefoods.com</a></td>
    </tr><tr><td>447</td>
    <td>Wynn Resorts</td>
    <td><a href="http://www.wynnresorts.com">http://www.wynnresorts.com</a></td>
    </tr><tr><td>448</td>
    <td>Olin</td>
    <td><a href="http://www.olin.com">http://www.olin.com</a></td>
    </tr><tr><td>449</td>
    <td>American Axle &amp; Manufacturing</td>
    <td><a href="http://www.aam.com">http://www.aam.com</a></td>
    </tr><tr><td>450</td>
    <td>Old Republic International</td>
    <td><a href="http://www.oldrepublic.com">http://www.oldrepublic.com</a></td>
    </tr><tr><td>451</td>
    <td>Chemours</td>
    <td><a href="http://www.chemours.com">http://www.chemours.com</a></td>
    </tr><tr><td>452</td>
    <td>iHeartMedia</td>
    <td><a href="http://www.iheartmedia.com">http://www.iheartmedia.com</a></td>
    </tr><tr><td>453</td>
    <td>Ameren</td>
    <td><a href="http://www.ameren.com">http://www.ameren.com</a></td>
    </tr><tr><td>454</td>
    <td>Arthur J. Gallagher</td>
    <td><a href="http://www.ajg.com">http://www.ajg.com</a></td>
    </tr><tr><td>455</td>
    <td>Celanese</td>
    <td><a href="http://www.celanese.com">http://www.celanese.com</a></td>
    </tr><tr><td>456</td>
    <td>Sealed Air</td>
    <td><a href="http://www.sealedair.com">http://www.sealedair.com</a></td>
    </tr><tr><td>457</td>
    <td>UGI</td>
    <td><a href="http://www.ugicorp.com">http://www.ugicorp.com</a></td>
    </tr><tr><td>458</td>
    <td>Realogy Holdings</td>
    <td><a href="http://www.realogy.com">http://www.realogy.com</a></td>
    </tr><tr><td>459</td>
    <td>Burlington Stores</td>
    <td><a href="http://www.burlington.com">http://www.burlington.com</a></td>
    </tr><tr><td>460</td>
    <td>Regions Financial</td>
    <td><a href="http://www.regions.com">http://www.regions.com</a></td>
    </tr><tr><td>461</td>
    <td>AK Steel Holding</td>
    <td><a href="http://www.aksteel.com">http://www.aksteel.com</a></td>
    </tr><tr><td>462</td>
    <td>Securian Financial Group</td>
    <td><a href="http://www.securian.com">http://www.securian.com</a></td>
    </tr><tr><td>463</td>
    <td>S&amp;P Global</td>
    <td><a href="http://www.spglobal.com">http://www.spglobal.com</a></td>
    </tr><tr><td>464</td>
    <td>Markel</td>
    <td><a href="http://www.markelcorp.com">http://www.markelcorp.com</a></td>
    </tr><tr><td>465</td>
    <td>TravelCenters of America</td>
    <td><a href="http://www.ta-petro.com">http://www.ta-petro.com</a></td>
    </tr><tr><td>466</td>
    <td>Conduent</td>
    <td><a href="http://www.conduent.com">http://www.conduent.com</a></td>
    </tr><tr><td>467</td>
    <td>M&amp;T Bank Corp.</td>
    <td><a href="http://www.mtb.com">http://www.mtb.com</a></td>
    </tr><tr><td>468</td>
    <td>Clorox</td>
    <td><a href="http://www.thecloroxcompany.com">http://www.thecloroxcompany.com</a></td>
    </tr><tr><td>469</td>
    <td>AmTrust Financial Services</td>
    <td><a href="http://www.amtrustfinancial.com">http://www.amtrustfinancial.com</a></td>
    </tr><tr><td>470</td>
    <td>KKR</td>
    <td><a href="http://www.kkr.com">http://www.kkr.com</a></td>
    </tr><tr><td>471</td>
    <td>Ulta Beauty</td>
    <td><a href="http://www.ulta.com">http://www.ulta.com</a></td>
    </tr><tr><td>472</td>
    <td>Yum Brands</td>
    <td><a href="http://www.yum.com">http://www.yum.com</a></td>
    </tr><tr><td>473</td>
    <td>Regeneron Pharmaceuticals</td>
    <td><a href="http://www.regeneron.com">http://www.regeneron.com</a></td>
    </tr><tr><td>474</td>
    <td>Windstream Holdings</td>
    <td><a href="http://www.windstream.com">http://www.windstream.com</a></td>
    </tr><tr><td>475</td>
    <td>Magellan Health</td>
    <td><a href="http://www.magellanhealth.com">http://www.magellanhealth.com</a></td>
    </tr><tr><td>476</td>
    <td>Western &amp; Southern Financial</td>
    <td><a href="http://www.westernsouthern.com">http://www.westernsouthern.com</a></td>
    </tr><tr><td>477</td>
    <td>Intercontinental Exchange</td>
    <td><a href="http://www.theice.com">http://www.theice.com</a></td>
    </tr><tr><td>478</td>
    <td>Ingredion</td>
    <td><a href="http://www.ingredion.com">http://www.ingredion.com</a></td>
    </tr><tr><td>479</td>
    <td>Wyndham Destinations</td>
    <td><a href="http://www.wyndhamdestinations.com">http://www.wyndhamdestinations.com</a></td>
    </tr><tr><td>480</td>
    <td>Toll Brothers</td>
    <td><a href="http://www.tollbrothers.com">http://www.tollbrothers.com</a></td>
    </tr><tr><td>481</td>
    <td>Seaboard</td>
    <td><a href="http://www.seaboardcorp.com">http://www.seaboardcorp.com</a></td>
    </tr><tr><td>482</td>
    <td>Booz Allen Hamilton</td>
    <td><a href="http://www.boozallen.com">http://www.boozallen.com</a></td>
    </tr><tr><td>483</td>
    <td>First American Financial</td>
    <td><a href="http://www.firstam.com">http://www.firstam.com</a></td>
    </tr><tr><td>484</td>
    <td>Cincinnati Financial</td>
    <td><a href="http://www.cinfin.com">http://www.cinfin.com</a></td>
    </tr><tr><td>485</td>
    <td>Avon Products</td>
    <td><a href="http://www.avoninvestor.com">http://www.avoninvestor.com</a></td>
    </tr><tr><td>486</td>
    <td>Northern Trust</td>
    <td><a href="http://www.northerntrust.com">http://www.northerntrust.com</a></td>
    </tr><tr><td>487</td>
    <td>Fiserv</td>
    <td><a href="http://www.fiserv.com">http://www.fiserv.com</a></td>
    </tr><tr><td>488</td>
    <td>Harley-Davidson</td>
    <td><a href="http://www.harley-davidson.com">http://www.harley-davidson.com</a></td>
    </tr><tr><td>489</td>
    <td>Cheniere Energy</td>
    <td><a href="http://www.cheniere.com">http://www.cheniere.com</a></td>
    </tr><tr><td>490</td>
    <td>Patterson</td>
    <td><a href="http://www.pattersoncompanies.com">http://www.pattersoncompanies.com</a></td>
    </tr><tr><td>491</td>
    <td>Peabody Energy</td>
    <td><a href="http://www.peabodyenergy.com">http://www.peabodyenergy.com</a></td>
    </tr><tr><td>492</td>
    <td>ON Semiconductor</td>
    <td><a href="http://www.onsemi.com">http://www.onsemi.com</a></td>
    </tr><tr><td>493</td>
    <td>Simon Property Group</td>
    <td><a href="http://www.simon.com">http://www.simon.com</a></td>
    </tr><tr><td>494</td>
    <td>Western Union</td>
    <td><a href="http://www.westernunion.com">http://www.westernunion.com</a></td>
    </tr><tr><td>495</td>
    <td>NetApp</td>
    <td><a href="http://www.netapp.com">http://www.netapp.com</a></td>
    </tr><tr><td>496</td>
    <td>Polaris Industries</td>
    <td><a href="http://www.polaris.com">http://www.polaris.com</a></td>
    </tr><tr><td>497</td>
    <td>Pioneer Natural Resources</td>
    <td><a href="http://www.pxd.com">http://www.pxd.com</a></td>
    </tr><tr><td>498</td>
    <td>ABM Industries</td>
    <td><a href="http://www.abm.com">http://www.abm.com</a></td>
    </tr><tr><td>499</td>
    <td>Vistra Energy</td>
    <td><a href="http://www.vistraenergy.com">http://www.vistraenergy.com</a></td>
    </tr><tr><td>500</td>
    <td>Cintas</td>
    <td><a href="http://www.cintas.com">http://www.cintas.com</a></td>
    </tr></tbody></table><p> </p>
    <p>The source data for this list is from <a href="http://fortune.com/fortune500/">http://fortune.com/fortune500/</a> and the data is available as a google spreadsheet at <a href="http://bit.ly/1kkTv2A">http://bit.ly/1kkTv2A</a>. You can also check out the list of fortune 500 companies for previous years.</p>
    <p> </p>
    <p> </p>
    <ul><li><a href="/articles/4404/list-of-fortune-500-companies-and-their-websites-2014">List of fortune 500 companies for 2014</a></li>
    <li><a href="/articles/5363/list-of-fortune-500-companies-and-their-websites-2015">List of fortune 500 companies for 2015</a></li>
    <li><a href="/articles/5826/list-of-fortune-500-companies-and-their-websites-2016">List of fortune 500 companies for 2016</a></li>
    <li><a href="/articles/5827/list-of-fortune-500-companies-and-their-websites-2017">List of fortune 500 companies for 2017</a></li>
    </ul><p> </p>
    </div>
    </div>
    <div class="zyxpro-casestudy-article-tag">
    <div class="field field--taxonomy-vocabulary-2">
    <div><a href="/categories/misc" hreflang="en">Misc</a></div>
    <div><a href="/categories/lists" hreflang="en">Lists</a></div>
    </div>
    </div>
    <div class="horizontal-row">
    <hr/>
    </div>
    <div class="related-zyxpro-casestudy-article-block">
    <div class="relative-zyxpro-casestudy-article-title">
    <h2>RELATED ARTICLE</h2>
    </div>
    <div class="article-full-related-articles"> <article about="/articles/3384/the-history-of-the-modern-calendar-infographic" class="story is-promoted teaser-insights" data-history-node-id="3384" role="article">
    <div class="content">
    <div class="insight-content">
    <div class="insight-images placeholderimage">
    <img alt="/themes/custom/zyxpro_light/images/placeholder.png" src="/themes/custom/zyxpro_light/images/placeholder.png"/>
    </div>
    <div class="insight-contents card">
    <div class="insight-title truncate">
    <a href="/articles/3384/the-history-of-the-modern-calendar-infographic"> <div class="title"><span>The history of the modern calendar - Infographic</span>
    </div> </a>
    </div>
    <div class="card-content insights-body ">
    <div class="activator row field--field-tags">
    <div class="col l10 m10 s10 truncate">
    <a href="/categories/infographics" hreflang="en">Infographics</a>
    <a href="/categories/misc" hreflang="en">Misc</a>
    </div>
    <div class="col l2 m2 s2">
    <i class="material-icons">more_horiz</i>
    </div>
    </div>
    </div>
    <div class="card-reveal card-addtoany">
    <span class="card-title grey-text text-darken-4"><i class="material-icons right">close</i></span>
    <p> <span class="a2a_kit a2a_kit_size_32 addtoany_list" data-a2a-title="The history of the modern calendar - Infographic" data-a2a-url="https://www.zyxware.com/articles/3384/the-history-of-the-modern-calendar-infographic"><a class="a2a_dd addtoany_share" href="https://www.addtoany.com/share#url=https%3A%2F%2Fwww.zyxware.com%2Farticles%2F3384%2Fthe-history-of-the-modern-calendar-infographic&amp;title=The%20history%20of%20the%20modern%20calendar%20-%20Infographic"></a><a class="a2a_button_facebook"></a><a class="a2a_button_twitter"></a><a class="a2a_button_linkedin"></a></span> </p>
    </div>
    <div class="author-info truncate">
              on <span>01st January 2013</span>
     / by <span><a about="/user/webmaster" datatype="" href="/user/webmaster" lang="" property="schema:name" title="View user profile." typeof="Person">webmaster</a></span>
    </div>
    <div class="insight-body">
                                    
                Did you know that year 2013 is the first year after 1987 which had all its digits as distinct. Did you know that Oct 1582 had 10 days removed from the month to adjust for the shift in the year? Did you know that Sumerians had calendars way back in 4000BC?. Here are some interesting pieces of information about the history of calendars.
    
          
          
                  Infographics
                  Misc
                  Fun Stuff
              
      
    
          
          Leave a reply
          Your email address will not be published. Required fields are marked *
          
        
         
          
      
      
    
    
              
              
            </div>
    </div>
    </div>
    </div>
    </article>
    <article about="/articles/4344/list-of-fortune-500-companies-and-their-websites" class="story teaser-insights" data-history-node-id="4344" role="article">
    <div class="content">
    <div class="insight-content">
    <div class="insight-images placeholderimage">
    <img alt="/themes/custom/zyxpro_light/images/placeholder.png" src="/themes/custom/zyxpro_light/images/placeholder.png"/>
    </div>
    <div class="insight-contents card">
    <div class="insight-title truncate">
    <a href="/articles/4344/list-of-fortune-500-companies-and-their-websites"> <div class="title"><span>List of Fortune 500 companies and their websites</span>
    </div> </a>
    </div>
    <div class="card-content insights-body ">
    <div class="activator row field--field-tags">
    <div class="col l10 m10 s10 truncate">
    <a href="/categories/misc" hreflang="en">Misc</a>
    <a href="/categories/lists" hreflang="en">Lists</a>
    </div>
    <div class="col l2 m2 s2">
    <i class="material-icons">more_horiz</i>
    </div>
    </div>
    </div>
    <div class="card-reveal card-addtoany">
    <span class="card-title grey-text text-darken-4"><i class="material-icons right">close</i></span>
    <p> <span class="a2a_kit a2a_kit_size_32 addtoany_list" data-a2a-title="List of Fortune 500 companies and their websites" data-a2a-url="https://www.zyxware.com/articles/4344/list-of-fortune-500-companies-and-their-websites"><a class="a2a_dd addtoany_share" href="https://www.addtoany.com/share#url=https%3A%2F%2Fwww.zyxware.com%2Farticles%2F4344%2Flist-of-fortune-500-companies-and-their-websites&amp;title=List%20of%20Fortune%20500%20companies%20and%20their%20websites"></a><a class="a2a_button_facebook"></a><a class="a2a_button_twitter"></a><a class="a2a_button_linkedin"></a></span> </p>
    </div>
    <div class="author-info truncate">
              on <span>08th July 2014</span>
     / by <span><a about="/user/webmaster" datatype="" href="/user/webmaster" lang="" property="schema:name" title="View user profile." typeof="Person">webmaster</a></span>
    </div>
    <div class="insight-body">
                                    
                Fortune magazine publishes a list of the largest companies in the US by revenue every year. Here is the list of fortune 500 companies for the year 2019 and their websites. 
    Download the full list
    
          
          
                  Misc
                  Lists
              
      
    
         
          
    
      
    
    
      
            
        
          
            
              
            
          
          
            
              
                Mohamed Faizal (not verified)
              
                        
                access_time
                
                  23 Feb 2020 - 20:16
                 
              
                        
                      
    
            
                          
                            
                        
                
                I have more Intrested to join high reputed company .
    
          
              
            
          
        
      
    
    
    
      
    
    
      
            
        
          
            
              
            
          
          
            
              
                anon (not verified)
              
                        
                access_time
                
                  23 Feb 2020 - 20:16
                 
              
                        
                      
    
            
                          
                            
                        
                
                data is available as a google spreadsheet at http://bit.ly/1mFsbAe
    
          
              
            
          
        
      
    
    
    
    
      
    
    
      
            
        
          
            
              
            
          
          
            
              
                webmaster
              
                        
                access_time
                
                  23 Feb 2020 - 20:16
                 
              
                                    In reply to data not linked correctly by anon (not verified)
              
                      
    
            
                          
                            
                        
                
                Thanks for the pointer. Have corrected link in the article.
    
          
              
            
          
        
      
    
    
    
      
    
    
      
            
        
          
            
              
            
          
          
            
              
                Aashika (not verified)
              
                        
                access_time
                
                  23 Feb 2020 - 20:16
                 
              
                        
                      
    
            
                          
                            
                        
                
                List looks helpful. Thanks!
    
          
              
            
          
        
      
    
    
    
      
    
    
      
            
        
          
            
              
            
          
          
            
              
                David Bowman (not verified)
              
                        
                access_time
                
                  23 Feb 2020 - 20:16
                 
              
                        
                      
    
            
                          
                            
                        
                
                Hello:
    Do you have the 2015 Fortune 500 list available?
    Regards,
    Davidhttp://www.orgchartcity.com
    
          
              
            
          
        
      
    
      
        Pagination
        
                                                            
                                              
                
                  Current page
                1
            
                  
                                              
                
                  Page
                2
            
                                          
              
                Next page
                Next ›
              
            
                              
              
                Last page
                Last »
              
            
              
      
    
      
      
    
    
              
              
            </div>
    </div>
    </div>
    </div>
    </article>
    <article about="/articles/4351/list-of-fortune-500-companies-using-drupal-for-their-websites" class="story teaser-insights" data-history-node-id="4351" role="article">
    <div class="content">
    <div class="insight-content">
    <div class="insight-images placeholderimage">
    <img alt="/themes/custom/zyxpro_light/images/placeholder.png" src="/themes/custom/zyxpro_light/images/placeholder.png"/>
    </div>
    <div class="insight-contents card">
    <div class="insight-title truncate">
    <a href="/articles/4351/list-of-fortune-500-companies-using-drupal-for-their-websites"> <div class="title"><span>List of Fortune 500 companies using Drupal for their websites</span>
    </div> </a>
    </div>
    <div class="card-content insights-body ">
    <div class="activator row field--field-tags">
    <div class="col l10 m10 s10 truncate">
    <a href="/categories/drupal" hreflang="en">Drupal</a>
    <a href="/categories/lists" hreflang="en">Lists</a>
    </div>
    <div class="col l2 m2 s2">
    <i class="material-icons">more_horiz</i>
    </div>
    </div>
    </div>
    <div class="card-reveal card-addtoany">
    <span class="card-title grey-text text-darken-4"><i class="material-icons right">close</i></span>
    <p> <span class="a2a_kit a2a_kit_size_32 addtoany_list" data-a2a-title="List of Fortune 500 companies using Drupal for their websites" data-a2a-url="https://www.zyxware.com/articles/4351/list-of-fortune-500-companies-using-drupal-for-their-websites"><a class="a2a_dd addtoany_share" href="https://www.addtoany.com/share#url=https%3A%2F%2Fwww.zyxware.com%2Farticles%2F4351%2Flist-of-fortune-500-companies-using-drupal-for-their-websites&amp;title=List%20of%20Fortune%20500%20companies%20using%20Drupal%20for%20their%20websites"></a><a class="a2a_button_facebook"></a><a class="a2a_button_twitter"></a><a class="a2a_button_linkedin"></a></span> </p>
    </div>
    <div class="author-info truncate">
              on <span>13th July 2014</span>
     / by <span><a about="/user/webmaster" datatype="" href="/user/webmaster" lang="" property="schema:name" title="View user profile." typeof="Person">webmaster</a></span>
    </div>
    <div class="insight-body">
                                    
                We had earlier published a list of Fortune 500 companies and their websites. We have evaluated these websites and have identified those that run on Drupal. The following is the list of Fortune 500 companies that use Drupal for their corporate websites. Do note that this is the current list of fortune 500 companies for year 2019.
    
          
          
                  Drupal
                  Lists
                  Marketing Drupal
                  Misc
              
      
    
          
          Leave a reply
          Your email address will not be published. Required fields are marked *
          
        
         
          
    
      
    
    
      
            
        
          
            
              
            
          
          
            
              
                Kate (not verified)
              
                        
                access_time
                
                  23 Feb 2020 - 20:16
                 
              
                        
                      
    
            
                          
                            
                        
                
                I blog quite often and I seriously appreciate your content.
    Your article has really peaked my interest. I
    am going to take a note of your website and keep checking
    for new details about once per week. I opted in for your RSS feed
    as well.
    
          
              
            
          
        
      
    
      
        Pagination
        
                                                            
                                              
                
                  Current page
                1
            
                  
                                              
                
                  Page
                2
            
                                          
              
                Next page
                Next ›
              
            
                              
              
                Last page
                Last »
              
            
              
      
    
      
      
    
    Add new comment
              
              
            </div>
    </div>
    </div>
    </div>
    </article>
    </div>
    </div>
    <div class="zyxpro-casestudy-article-comment">
    <section>
    <div class="comments-wrapper">
    <h6>Leave a reply</h6>
    <h5>Your email address will not be published. Required fields are marked *</h5>
    <form accept-charset="UTF-8" action="/comment/reply/node/5914/comment_node_story" class="comment-comment-node-story-form comment-form" data-drupal-selector="comment-form" data-user-info-from-browser="" id="comment-form" method="post">
    <div class="field--type-text-long field--name-comment-body field--widget-text-textarea js-form-wrapper form-wrapper" data-drupal-selector="edit-comment-body-wrapper" id="edit-comment-body-wrapper">
    <div class="js-text-format-wrapper js-form-item form-item">
    <div class="js-form-item form-item js-form-type-textarea form-item-comment-body-0-value js-form-item-comment-body-0-value">
    <label for="edit-comment-body-0-value">Comment</label>
    <div>
    <textarea class="js-text-full text-full form-textarea" cols="60" data-drupal-selector="edit-comment-body-0-value" id="edit-comment-body-0-value" name="comment_body[0][value]" placeholder="" rows="5"></textarea>
    </div>
    </div>
    <div class="filter-wrapper js-form-wrapper form-wrapper" data-drupal-selector="edit-comment-body-0-format" id="edit-comment-body-0-format"><div class="filter-help js-form-wrapper form-wrapper" data-drupal-selector="edit-comment-body-0-format-help" id="edit-comment-body-0-format-help"><a data-drupal-selector="edit-comment-body-0-format-help-about" href="/filter/tips" id="edit-comment-body-0-format-help-about" target="_blank">About text formats</a></div>
    <div class="filter-guidelines js-form-wrapper form-wrapper" data-drupal-selector="edit-comment-body-0-format-guidelines" id="edit-comment-body-0-format-guidelines"><div>
    <h4>Filtered HTML</h4>
    <ul>
    <li>Web page addresses and email addresses turn into links automatically.</li>
    <li>Allowed HTML tags: &lt;a href hreflang&gt; &lt;em&gt; &lt;strong&gt; &lt;cite&gt; &lt;blockquote cite&gt; &lt;code&gt; &lt;ul type&gt; &lt;ol start type='1 A I'&gt; &lt;li&gt; &lt;dl&gt; &lt;dt&gt; &lt;dd&gt; &lt;h2 id='jump-*'&gt; &lt;h3 id&gt; &lt;h4 id&gt; &lt;h5 id&gt; &lt;h6 id&gt;</li>
    <li>Lines and paragraphs break automatically.</li>
    </ul>
    </div>
    </div>
    </div>
    </div>
    </div>
    <input autocomplete="off" data-drupal-selector="form-tmun3fmt-qdrarz2cefosxay-9ta62fmqn5y-fo8gys" name="form_build_id" type="hidden" value="form-TmuN3fmt-qdrARZ2cEFosxAy_9tA62fMQn5Y_fo8gYs"/>
    <input data-drupal-selector="edit-comment-comment-node-story-form" name="form_id" type="hidden" value="comment_comment_node_story_form"/>
    <div class="js-form-item form-item js-form-type-textfield form-item-name js-form-item-name">
    <label class="js-form-required form-required" for="edit-name"></label>
    <input aria-required="true" class="form-text required" data-drupal-default-value="Anonymous" data-drupal-selector="edit-name" id="edit-name" maxlength="60" name="name" placeholder="Name" required="required" size="30" type="text" value=""/>
    </div>
    <div class="js-form-item form-item js-form-type-email form-item-mail js-form-item-mail">
    <label class="js-form-required form-required" for="edit-mail">Email</label>
    <input aria-describedby="edit-mail--description" aria-required="true" class="form-email required" data-drupal-selector="edit-mail" id="edit-mail" maxlength="64" name="mail" required="required" size="30" type="email" value=""/>
    <div class="description" id="edit-mail--description">
          The content of this field is kept private and will not be shown publicly.
        </div>
    </div>
    <div class="js-form-item form-item js-form-type-url form-item-homepage js-form-item-homepage">
    <label for="edit-homepage">Homepage</label>
    <input class="form-url" data-drupal-selector="edit-homepage" id="edit-homepage" maxlength="255" name="homepage" size="30" type="url" value=""/>
    </div>
    <div class="field--type-language field--name-langcode field--widget-language-select js-form-wrapper form-wrapper" data-drupal-selector="edit-langcode-wrapper" id="edit-langcode-wrapper">
    </div>
    <details class="captcha js-form-wrapper form-wrapper" open="open">
    <summary aria-expanded="true" aria-pressed="true" role="button">CAPTCHA</summary>
      This question is for testing whether or not you are a human visitor and to prevent automated spam submissions.
      <input data-drupal-selector="edit-captcha-sid" name="captcha_sid" type="hidden" value="4842639"/>
    <input data-drupal-selector="edit-captcha-token" name="captcha_token" type="hidden" value="ba91fa66dd18f9acd8927c2659c649fc"/>
    <input data-drupal-selector="edit-captcha-response" name="captcha_response" type="hidden" value="Google no captcha"/>
    <div class="g-recaptcha" data-sitekey="6LdTboIUAAAAAPW25o0eHWwF09_VbxjaGKrFwxKq" data-size="compact" data-theme="light" data-type="image"></div>
    </details>
    <div class="form-actions js-form-wrapper form-wrapper" data-drupal-selector="edit-actions" id="edit-actions"><input class="button button--primary js-form-submit form-submit" data-drupal-selector="edit-submit" id="edit-submit" name="op" type="submit" value="Post Comments"/>
    </div>
    </form>
    </div>
    <div class="comment-wrap">
    </div>
    </section>
    </div>
    </div>
    </article>
    </div>
    </div>
    </section>
    <aside class="col l3 m12 s12" role="complementary">
    <div class="region--sidebar-second">
    <div class="block block--label- block--id-block-content50aedcec-9238-4bd3-b32a-06e8366ce094 block--type-basic" id="block-zyxwareaddresses">
    <div class="field field--body"><div class="address-info">
    <div class="address-2">
    <h4>US</h4>
    <span class="sub-title">New Jersey (Head Quarters)</span> <span class="address-line">DxForge Inc<br/>
    (A subsidiary of Zyxware Technologies)<br/>
    190 Moore St Suite 308,<br/>
    Hackensack, NJ 07601.</span><br/><br/><span class="sub-title">California Office</span> <span class="address-line">4500 The Woods Dr #224,<br/>
    San Jose, CA 95136.</span>
    <div class="contact-us-custom-phone-numbers"><strong>Phone Numbers</strong><br/>
    Toll free number<br/>
    Phone: 1-833-999-9273<br/>
    New Jersey (Head Quarters)<br/>
    Phone: +1-201-355-2515<br/>
    California Office<br/>
    Phone: +1-408-677-1146</div>
    </div>
    <div class="address-3">
    <h4>AUSTRALIA</h4>
    <span class="address-line">Zyxware Technologies Pty Ltd,<br/>
    (A subsidiary of Zyxware Technologies)<br/>
    8 Excelsa Way, Hillside,<br/>
    Melbourne, VIC 3037<br/>
    Phone: +61 450 405 000</span></div>
    <div class="address-1">
    <h4>INDIA</h4>
    <p><span class="sub-title">Technopark Office (Registered Office)</span><br/><span class="address-line">SBC 2205, II Floor, Yamuna Building,<br/>
    Technopark Phase III campus,<br/>
    Trivandrum, Kerala - 695581 </span></p>
    <p><strong><span class="sub-title">Kochi Office</span> </strong></p>
    <p><span class="address-line">C3, 3rd Floor,<br/>
    V Square IT Hub,<br/>
    Chembumukku, Kakkanad P. O.,<br/>
    Ernakulam, Kerala - 682030</span></p>
    <p><strong>Phone Numbers</strong><br/>
    Software Development<br/>
    Mobile: +91 8157-99-5558<br/>
    Domain &amp; Hosting<br/>
    Mobile: +91-9446-06-9446<br/>
    Human Resources Department<br/>
    Mobile: +91-8606 01-1187</p>
    </div>
    </div>
    </div>
    </div>
    </div>
    </aside>
    </div>
    </div>
    </div>
    <footer class="footer " role="contentinfo">
    <div class="region--footer">
    <div class="block block--label-our-locations block--id-block-content4c979bba-b5f2-4829-80eb-8cadf8def118 block--type-our-locations" id="block-zyxpro-light-locations">
    <div class="world_map">
    <div class="world_map_title">
    <p>OUR LOCATIONS</p>
    </div>
    <div class="world_map__wrap">
    <img alt="World Map - Zyxware" src="/themes/custom/zyxpro_light/images/world_map.png"/>
    <div class="paragraph paragraph--type--location-item paragraph--view-mode--default location--item-wrap location--india">
    <div class="map-content">
    <div class="field field--field-location"><p>India</p>
    </div>
    <div class="field field--field-addresses">
    <div> <div class="paragraph paragraph--type--address-item paragraph--view-mode--default">
    <div class="field field--field-place"><p>Technopark Office (Registered Office)</p>
    </div>
    <div class="field field--field-contact-address"><p>SBC 2205, II Floor,<br/>
    Yamuna Building, Phase III Campus,<br/>
    Thiruvananthapuram, Kerala - 695581</p>
    </div>
    <div class="field field--field-phone-numbers">
    <div> <div class="paragraph paragraph--type--phone-item paragraph--view-mode--default">
    <div class="field field--field-phone-title"><p>Mobile</p>
    </div>
    <div class="field field--field-phone-number"><p>+91 8157-99-5558</p>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>
    <div> <div class="paragraph paragraph--type--address-item paragraph--view-mode--default">
    <div class="field field--field-place"><p>Kochi Office</p>
    </div>
    <div class="field field--field-contact-address"><p>XI/86 L, Chalakkara Road, Padamugal, Kakkanad P. O.,<br/>
    Kochi, Kerala - 682030</p>
    </div>
    </div>
    </div>
    </div>
    </div>
    <div class="map-marker"><img alt="Map Marker" class="responsive-img img-marker" src="/themes/custom/zyxpro_light/images/icons/Map_Marker.png"/></div>
    </div>
    <div class="paragraph paragraph--type--location-item paragraph--view-mode--default location--item-wrap location--united-states">
    <div class="map-content">
    <div class="field field--field-location"><p>United States</p>
    </div>
    <div class="field field--field-addresses">
    <div> <div class="paragraph paragraph--type--address-item paragraph--view-mode--default">
    <div class="field field--field-place"><p>190 Moore St</p>
    </div>
    <div class="field field--field-contact-address"><p>Suite 308,<br/>
    Hackensack, NJ 07601.<br/>
    Phone: +1 408 677 1146</p>
    </div>
    <div class="field field--field-phone-numbers">
    <div> <div class="paragraph paragraph--type--phone-item paragraph--view-mode--default">
    <div class="field field--field-phone-title"><p>Phone</p>
    </div>
    <div class="field field--field-phone-number"><p>+1 408 677 1146</p>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>
    <div class="map-marker"><img alt="Map Marker" class="responsive-img img-marker" src="/themes/custom/zyxpro_light/images/icons/Map_Marker.png"/></div>
    </div>
    <div class="paragraph paragraph--type--location-item paragraph--view-mode--default location--item-wrap location--australia">
    <div class="map-content">
    <div class="field field--field-location"><p>Australia</p>
    </div>
    <div class="field field--field-addresses">
    <div> <div class="paragraph paragraph--type--address-item paragraph--view-mode--default">
    <div class="field field--field-place"><p>8 Excelsa Way</p>
    </div>
    <div class="field field--field-contact-address"><p>Hillside,<br/>
    Melbourne, VIC 3037</p>
    </div>
    <div class="field field--field-phone-numbers">
    <div> <div class="paragraph paragraph--type--phone-item paragraph--view-mode--default">
    <div class="field field--field-phone-title"><p>Phone</p>
    </div>
    <div class="field field--field-phone-number"><p>+61 450 405 000</p>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>
    <div class="map-marker"><img alt="Map Marker" class="responsive-img img-marker" src="/themes/custom/zyxpro_light/images/icons/Map_Marker.png"/></div>
    </div>
    </div>
    <div class="world-map-list-wrap">
    <ul>
    <li><a href="/our-offices">India</a></li>
    <li><a href="/our-offices">United States</a></li>
    <li><a href="/our-offices">Australia</a></li>
    </ul>
    </div>
    </div>
    </div>
    <div class="block--id-system-branding-block">
    <a href="/" rel="home" title="Home">
    <img alt="Home" src="/themes/custom/zyxpro_light/logo.png"/>
    </a>
    </div>
    <div class="block block--label- block--id-block-contentf3debc9e-600d-447f-9d5b-a095d0bdd575 block--type-footer-copyright-section" id="block-zyxpro-light-footercopyright">
    <div class="footer-bottom footer-bottom-custom">
    <a class="include-branding hide-on-large-only" href="/">
    <img alt="ZYXWARE" class="responsive-img zyx-img" src="/themes/custom/zyxpro_light/logo.png"/>
    </a>
    <div class="field field--body"><p><span><a href="/privacy-policy">Privacy</a> . <a href="#">T &amp; C</a> . © 2020 Zyxware Technologies Pvt. Ltd</span></p>
    </div>
    </div>
    </div>
    </div>
    </footer>
    </div>
    <script data-drupal-selector="drupal-settings-json" type="application/json">{"path":{"baseUrl":"\/","scriptPath":null,"pathPrefix":"","currentPath":"node\/5914","currentPathIsAdmin":false,"isFront":false,"currentLanguage":"en"},"pluralDelimiter":"\u0003","dataLayer":{"defaultLang":"en","languages":{"en":{"id":"en","name":"English","direction":"ltr","weight":0}}},"google_analytics":{"account":"UA-1488254-2","trackOutbound":true,"trackMailto":true,"trackDownload":true,"trackDownloadExtensions":"7z|aac|arc|arj|asf|asx|avi|bin|csv|doc(x|m)?|dot(x|m)?|exe|flv|gif|gz|gzip|hqx|jar|jpe?g|js|mp(2|3|4|e?g)|mov(ie)?|msi|msp|pdf|phps|png|ppt(x|m)?|pot(x|m)?|pps(x|m)?|ppam|sld(x|m)?|thmx|qtm?|ra(m|r)?|sea|sit|tar|tgz|torrent|txt|wav|wma|wmv|wpd|xls(x|m|b)?|xlt(x|m)|xlam|xml|z|zip","trackColorbox":true,"trackUrlFragments":true},"eu_cookie_compliance":{"popup_enabled":true,"popup_agreed_enabled":false,"popup_hide_agreed":false,"popup_clicking_confirmation":true,"popup_scrolling_confirmation":false,"popup_html_info":"\u003Cdiv class=\u0022eu-cookie-compliance-banner eu-cookie-compliance-banner-info\u0022\u003E\n    \u003Cdiv class =\u0022popup-content info eu-cookie-compliance-content\u0022\u003E\n        \u003Cdiv id=\u0022popup-text\u0022 class=\u0022eu-cookie-compliance-message\u0022\u003E\n            \u003Cp\u003EWe use cookies on this site to enhance your user experience. By clicking on the \u2018OK, I agree\u2019 button you are giving your consent for us to set cookies.\u003C\/p\u003E\n\n        \u003C\/div\u003E\n        \u003Cdiv id=\u0022popup-buttons\u0022 class=\u0022eu-cookie-compliance-buttons\u0022\u003E\n            \u003Cbutton type=\u0022button\u0022 class=\u0022agree-button eu-cookie-compliance-agree-button\u0022\u003EOK, I agree\u003C\/button\u003E\n                            \u003Cbutton type=\u0022button\u0022 class=\u0022disagree-button find-more-button eu-cookie-compliance-more-button\u0022\u003EGive me more info\u003C\/button\u003E\n                    \u003C\/div\u003E\n    \u003C\/div\u003E\n\u003C\/div\u003E","use_mobile_message":false,"mobile_popup_html_info":"\u003Cdiv class=\u0022eu-cookie-compliance-banner eu-cookie-compliance-banner-info\u0022\u003E\n    \u003Cdiv class =\u0022popup-content info eu-cookie-compliance-content\u0022\u003E\n        \u003Cdiv id=\u0022popup-text\u0022 class=\u0022eu-cookie-compliance-message\u0022\u003E\n            \n        \u003C\/div\u003E\n        \u003Cdiv id=\u0022popup-buttons\u0022 class=\u0022eu-cookie-compliance-buttons\u0022\u003E\n            \u003Cbutton type=\u0022button\u0022 class=\u0022agree-button eu-cookie-compliance-agree-button\u0022\u003EOK, I agree\u003C\/button\u003E\n                            \u003Cbutton type=\u0022button\u0022 class=\u0022disagree-button find-more-button eu-cookie-compliance-more-button\u0022\u003EGive me more info\u003C\/button\u003E\n                    \u003C\/div\u003E\n    \u003C\/div\u003E\n\u003C\/div\u003E","mobile_breakpoint":768,"popup_html_agreed":false,"popup_use_bare_css":false,"popup_height":"auto","popup_width":"100%","popup_delay":1000,"popup_link":"\/","popup_link_new_window":true,"popup_position":false,"fixed_top_position":true,"popup_language":"en","store_consent":false,"better_support_for_screen_readers":false,"cookie_name":"eu-cookie","reload_page":false,"domain":"","domain_all_sites":false,"popup_eu_only_js":false,"cookie_lifetime":90,"cookie_session":0,"disagree_do_not_show_popup":false,"method":"default","whitelisted_cookies":"","withdraw_markup":"\u003Cbutton type=\u0022button\u0022 class=\u0022eu-cookie-withdraw-tab\u0022\u003EPrivacy settings\u003C\/button\u003E\n\u003Cdiv class=\u0022eu-cookie-withdraw-banner\u0022\u003E\n  \u003Cdiv class=\u0022popup-content info eu-cookie-compliance-content\u0022\u003E\n    \u003Cdiv id=\u0022popup-text\u0022 class=\u0022eu-cookie-compliance-message\u0022\u003E\n      \u003Ch2\u003EWe use cookies on this site to enhance your user experience\u003C\/h2\u003E\n\u003Cp\u003EYou have given your consent for us to set cookies.\u003C\/p\u003E\n\n    \u003C\/div\u003E\n    \u003Cdiv id=\u0022popup-buttons\u0022 class=\u0022eu-cookie-compliance-buttons\u0022\u003E\n      \u003Cbutton type=\u0022button\u0022 class=\u0022eu-cookie-withdraw-button\u0022\u003EWithdraw consent\u003C\/button\u003E\n    \u003C\/div\u003E\n  \u003C\/div\u003E\n\u003C\/div\u003E","withdraw_enabled":false,"withdraw_button_on_info_popup":false,"cookie_categories":[],"enable_save_preferences_button":true,"fix_first_cookie_category":true,"select_all_categories_by_default":false},"ajaxTrustedUrl":{"\/comment\/reply\/node\/5914\/comment_node_story":true,"\/comment\/reply\/node\/4351\/comment_node_story":true,"\/comment\/reply\/node\/3384\/comment_node_story":true},"form_placeholder":{"include":"textarea,input","exclude":"","required_indicator":"leave"},"user":{"uid":0,"permissionsHash":"067673b94f2c09cb1418ec8bc677fa1399d00dfbe92db43f62a33a321ec038e1"}}</script>
    <script src="/sites/default/files/js/js_c6sBYcgPYd3dKKsqe7iP6GIHZvyCj-q66Ny81NMgZ7U.js"></script>
    <script async="" src="https://static.addtoany.com/menu/page.js"></script>
    <script src="/sites/default/files/js/js_YWnkQrju-q-SSMAm1W13pyRnKjG_e_0avilAgVbNyR4.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script src="/sites/default/files/js/js_FNmEiseAHSiyAjgDUKr0EXjC_kiqS2sdNZqPEGmrwXg.js"></script>
    </body>
    </html>
    
    

## 3. Manipulate it into a tabular structure - explore the schema

To be able to accurately extract relevant data from the webpage, it is important to explore the schema and understand the structure of the webpage. A good way to do this is to inspect the webpage directly on a web browser.
<br>

To do this,
- Open the webpage on a browser
- Right click on the data content to be extracted
- Click on 'Inspect' or 'Inspect element' option

This will open a console window which shows the real time HTML code corresponding to the web content. Now identify the type of HTML tag which contains all the data along with any id names or class names associated to that HTML tag. In our case, the data is enclosed in the 'table' HTML tag with the class name 'data-table'. This information can be used to search for the web content directly in our soup object with the find_all() method. This will return a soup object.


```python
data_table = soup_object.find_all('table', 'data-table')[0]
data_table
```




    <table class="data-table"><thead><tr><th>Rank</th>
    <th>Company</th>
    <th>Website</th>
    </tr></thead><tbody><tr><td>1</td>
    <td>Walmart</td>
    <td><a href="http://www.stock.walmart.com">http://www.stock.walmart.com</a></td>
    </tr><tr><td>2</td>
    <td>Exxon Mobil</td>
    <td><a href="http://www.exxonmobil.com">http://www.exxonmobil.com</a></td>
    </tr><tr><td>3</td>
    <td>Berkshire Hathaway</td>
    <td><a href="http://www.berkshirehathaway.com">http://www.berkshirehathaway.com</a></td>
    </tr><tr><td>4</td>
    <td>Apple</td>
    <td><a href="http://www.apple.com">http://www.apple.com</a></td>
    </tr><tr><td>5</td>
    <td>UnitedHealth Group</td>
    <td><a href="http://www.unitedhealthgroup.com">http://www.unitedhealthgroup.com</a></td>
    </tr><tr><td>6</td>
    <td>McKesson</td>
    <td><a href="http://www.mckesson.com">http://www.mckesson.com</a></td>
    </tr><tr><td>7</td>
    <td>CVS Health</td>
    <td><a href="http://www.cvshealth.com">http://www.cvshealth.com</a></td>
    </tr><tr><td>8</td>
    <td>Amazon.com</td>
    <td><a href="http://www.amazon.com">http://www.amazon.com</a></td>
    </tr><tr><td>9</td>
    <td>AT&amp;T</td>
    <td><a href="http://www.att.com">http://www.att.com</a></td>
    </tr><tr><td>10</td>
    <td>General Motors</td>
    <td><a href="http://www.gm.com">http://www.gm.com</a></td>
    </tr><tr><td>11</td>
    <td>Ford Motor</td>
    <td><a href="http://www.corporate.ford.com">http://www.corporate.ford.com</a></td>
    </tr><tr><td>12</td>
    <td>AmerisourceBergen</td>
    <td><a href="http://www.amerisourcebergen.com">http://www.amerisourcebergen.com</a></td>
    </tr><tr><td>13</td>
    <td>Chevron</td>
    <td><a href="http://www.chevron.com">http://www.chevron.com</a></td>
    </tr><tr><td>14</td>
    <td>Cardinal Health</td>
    <td><a href="http://www.cardinalhealth.com">http://www.cardinalhealth.com</a></td>
    </tr><tr><td>15</td>
    <td>Costco</td>
    <td><a href="http://www.costco.com">http://www.costco.com</a></td>
    </tr><tr><td>16</td>
    <td>Verizon</td>
    <td><a href="http://www.verizon.com">http://www.verizon.com</a></td>
    </tr><tr><td>17</td>
    <td>Kroger</td>
    <td><a href="http://www.thekrogerco.com">http://www.thekrogerco.com</a></td>
    </tr><tr><td>18</td>
    <td>General Electric</td>
    <td><a href="http://www.ge.com">http://www.ge.com</a></td>
    </tr><tr><td>19</td>
    <td>Walgreens Boots Alliance</td>
    <td><a href="http://www.walgreensbootsalliance.com">http://www.walgreensbootsalliance.com</a></td>
    </tr><tr><td>20</td>
    <td>JPMorgan Chase</td>
    <td><a href="http://www.jpmorganchase.com">http://www.jpmorganchase.com</a></td>
    </tr><tr><td>21</td>
    <td>Fannie Mae</td>
    <td><a href="http://www.fanniemae.com">http://www.fanniemae.com</a></td>
    </tr><tr><td>22</td>
    <td>Alphabet</td>
    <td><a href="http://www.abc.xyz">http://www.abc.xyz</a></td>
    </tr><tr><td>23</td>
    <td>Home Depot</td>
    <td><a href="http://www.homedepot.com">http://www.homedepot.com</a></td>
    </tr><tr><td>24</td>
    <td>Bank of America Corp.</td>
    <td><a href="http://www.bankofamerica.com">http://www.bankofamerica.com</a></td>
    </tr><tr><td>25</td>
    <td>Express Scripts Holding</td>
    <td><a href="http://www.express-scripts.com">http://www.express-scripts.com</a></td>
    </tr><tr><td>26</td>
    <td>Wells Fargo</td>
    <td><a href="http://www.wellsfargo.com">http://www.wellsfargo.com</a></td>
    </tr><tr><td>27</td>
    <td>Boeing</td>
    <td><a href="http://www.boeing.com">http://www.boeing.com</a></td>
    </tr><tr><td>28</td>
    <td>Phillips</td>
    <td><a href="http://www.phillips66.com">http://www.phillips66.com</a></td>
    </tr><tr><td>29</td>
    <td>Anthem</td>
    <td><a href="http://www.antheminc.com">http://www.antheminc.com</a></td>
    </tr><tr><td>30</td>
    <td>Microsoft</td>
    <td><a href="http://www.microsoft.com">http://www.microsoft.com</a></td>
    </tr><tr><td>31</td>
    <td>Valero Energy</td>
    <td><a href="http://www.valero.com">http://www.valero.com</a></td>
    </tr><tr><td>32</td>
    <td>Citigroup</td>
    <td><a href="http://www.citigroup.com">http://www.citigroup.com</a></td>
    </tr><tr><td>33</td>
    <td>Comcast</td>
    <td><a href="http://www.comcastcorporation.com">http://www.comcastcorporation.com</a></td>
    </tr><tr><td>34</td>
    <td>IBM</td>
    <td><a href="http://www.ibm.com">http://www.ibm.com</a></td>
    </tr><tr><td>35</td>
    <td>Dell Technologies</td>
    <td><a href="http://www.delltechnologies.com">http://www.delltechnologies.com</a></td>
    </tr><tr><td>36</td>
    <td>State Farm Insurance Cos.</td>
    <td><a href="http://www.statefarm.com">http://www.statefarm.com</a></td>
    </tr><tr><td>37</td>
    <td>Johnson &amp; Johnson</td>
    <td><a href="http://www.jnj.com">http://www.jnj.com</a></td>
    </tr><tr><td>38</td>
    <td>Freddie Mac</td>
    <td><a href="http://www.freddiemac.com">http://www.freddiemac.com</a></td>
    </tr><tr><td>39</td>
    <td>Target</td>
    <td><a href="http://www.target.com">http://www.target.com</a></td>
    </tr><tr><td>40</td>
    <td>Lowe’s</td>
    <td><a href="http://www.lowes.com">http://www.lowes.com</a></td>
    </tr><tr><td>41</td>
    <td>Marathon Petroleum</td>
    <td><a href="http://www.marathonpetroleum.com">http://www.marathonpetroleum.com</a></td>
    </tr><tr><td>42</td>
    <td>Procter &amp; Gamble</td>
    <td><a href="http://www.pg.com">http://www.pg.com</a></td>
    </tr><tr><td>43</td>
    <td>MetLife</td>
    <td><a href="http://www.metlife.com">http://www.metlife.com</a></td>
    </tr><tr><td>44</td>
    <td>UPS</td>
    <td><a href="http://www.ups.com">http://www.ups.com</a></td>
    </tr><tr><td>45</td>
    <td>PepsiCo</td>
    <td><a href="http://www.pepsico.com">http://www.pepsico.com</a></td>
    </tr><tr><td>46</td>
    <td>Intel</td>
    <td><a href="http://www.intel.com">http://www.intel.com</a></td>
    </tr><tr><td>47</td>
    <td>DowDuPont</td>
    <td><a href="www.dow-dupont.com">www.dow-dupont.com</a></td>
    </tr><tr><td>48</td>
    <td>Archer Daniels Midland</td>
    <td><a href="http://www.adm.com">http://www.adm.com</a></td>
    </tr><tr><td>49</td>
    <td>Aetna</td>
    <td><a href="http://www.aetna.com">http://www.aetna.com</a></td>
    </tr><tr><td>50</td>
    <td>FedEx</td>
    <td><a href="http://www.fedex.com">http://www.fedex.com</a></td>
    </tr><tr><td>51</td>
    <td>United Technologies</td>
    <td><a href="http://www.utc.com">http://www.utc.com</a></td>
    </tr><tr><td>52</td>
    <td>Prudential Financial</td>
    <td><a href="http://www.prudential.com">http://www.prudential.com</a></td>
    </tr><tr><td>53</td>
    <td>Albertsons Cos.</td>
    <td><a href="http://www.albertsons.com">http://www.albertsons.com</a></td>
    </tr><tr><td>54</td>
    <td>Sysco</td>
    <td><a href="http://www.sysco.com">http://www.sysco.com</a></td>
    </tr><tr><td>55</td>
    <td>Disney</td>
    <td><a href="http://www.disney.com">http://www.disney.com</a></td>
    </tr><tr><td>56</td>
    <td>Humana</td>
    <td><a href="http://www.humana.com">http://www.humana.com</a></td>
    </tr><tr><td>57</td>
    <td>Pfizer</td>
    <td><a href="http://www.pfizer.com">http://www.pfizer.com</a></td>
    </tr><tr><td>58</td>
    <td>HP</td>
    <td><a href="http://www.hp.com">http://www.hp.com</a></td>
    </tr><tr><td>59</td>
    <td>Lockheed Martin</td>
    <td><a href="http://www.lockheedmartin.com">http://www.lockheedmartin.com</a></td>
    </tr><tr><td>60</td>
    <td>AIG</td>
    <td><a href="http://www.aig.com">http://www.aig.com</a></td>
    </tr><tr><td>61</td>
    <td>Centene</td>
    <td><a href="http://www.centene.com">http://www.centene.com</a></td>
    </tr><tr><td>62</td>
    <td>Cisco Systems</td>
    <td><a href="http://www.cisco.com">http://www.cisco.com</a></td>
    </tr><tr><td>63</td>
    <td>HCA Healthcare</td>
    <td><a href="www.hcahealthcare.com">www.hcahealthcare.com</a></td>
    </tr><tr><td>64</td>
    <td>Energy Transfer Equity</td>
    <td><a href="http://www.energytransfer.com">http://www.energytransfer.com</a></td>
    </tr><tr><td>65</td>
    <td>Caterpillar</td>
    <td><a href="http://www.caterpillar.com">http://www.caterpillar.com</a></td>
    </tr><tr><td>66</td>
    <td>Nationwide</td>
    <td><a href="http://www.nationwide.com">http://www.nationwide.com</a></td>
    </tr><tr><td>67</td>
    <td>Morgan Stanley</td>
    <td><a href="http://www.morganstanley.com">http://www.morganstanley.com</a></td>
    </tr><tr><td>68</td>
    <td>Liberty Mutual Insurance Group</td>
    <td><a href="http://www.libertymutual.com">http://www.libertymutual.com</a></td>
    </tr><tr><td>69</td>
    <td>New York Life Insurance</td>
    <td><a href="http://www.newyorklife.com">http://www.newyorklife.com</a></td>
    </tr><tr><td>70</td>
    <td>Goldman Sachs Group</td>
    <td><a href="http://www.gs.com">http://www.gs.com</a></td>
    </tr><tr><td>71</td>
    <td>American Airlines Group</td>
    <td><a href="http://www.aa.com">http://www.aa.com</a></td>
    </tr><tr><td>72</td>
    <td>Best Buy</td>
    <td><a href="http://www.bestbuy.com">http://www.bestbuy.com</a></td>
    </tr><tr><td>73</td>
    <td>Cigna</td>
    <td><a href="http://www.cigna.com">http://www.cigna.com</a></td>
    </tr><tr><td>74</td>
    <td>Charter Communications</td>
    <td><a href="http://www.charter.com">http://www.charter.com</a></td>
    </tr><tr><td>75</td>
    <td>Delta Air Lines</td>
    <td><a href="http://www.delta.com">http://www.delta.com</a></td>
    </tr><tr><td>76</td>
    <td>Facebook</td>
    <td><a href="http://www.facebook.com">http://www.facebook.com</a></td>
    </tr><tr><td>77</td>
    <td>Honeywell International</td>
    <td><a href="http://www.honeywell.com">http://www.honeywell.com</a></td>
    </tr><tr><td>78</td>
    <td>Merck</td>
    <td><a href="http://www.merck.com">http://www.merck.com</a></td>
    </tr><tr><td>79</td>
    <td>Allstate</td>
    <td><a href="http://www.allstate.com">http://www.allstate.com</a></td>
    </tr><tr><td>80</td>
    <td>Tyson Foods</td>
    <td><a href="http://www.tysonfoods.com">http://www.tysonfoods.com</a></td>
    </tr><tr><td>81</td>
    <td>United Continental Holdings</td>
    <td><a href="http://www.united.com">http://www.united.com</a></td>
    </tr><tr><td>82</td>
    <td>Oracle</td>
    <td><a href="http://www.oracle.com">http://www.oracle.com</a></td>
    </tr><tr><td>83</td>
    <td>Tech Data</td>
    <td><a href="http://www.techdata.com">http://www.techdata.com</a></td>
    </tr><tr><td>84</td>
    <td>TIAA</td>
    <td><a href="http://www.tiaa.org">http://www.tiaa.org</a></td>
    </tr><tr><td>85</td>
    <td>TJX</td>
    <td><a href="http://www.tjx.com">http://www.tjx.com</a></td>
    </tr><tr><td>86</td>
    <td>American Express</td>
    <td><a href="http://www.americanexpress.com">http://www.americanexpress.com</a></td>
    </tr><tr><td>87</td>
    <td>Coca-Cola</td>
    <td><a href="http://www.coca-colacompany.com">http://www.coca-colacompany.com</a></td>
    </tr><tr><td>88</td>
    <td>Publix Super Markets</td>
    <td><a href="http://www.publix.com">http://www.publix.com</a></td>
    </tr><tr><td>89</td>
    <td>Nike</td>
    <td><a href="http://www.nike.com">http://www.nike.com</a></td>
    </tr><tr><td>90</td>
    <td>Andeavor</td>
    <td><a href="www.andeavor.com">www.andeavor.com</a></td>
    </tr><tr><td>91</td>
    <td>World Fuel Services</td>
    <td><a href="http://www.wfscorp.com">http://www.wfscorp.com</a></td>
    </tr><tr><td>92</td>
    <td>Exelon</td>
    <td><a href="http://www.exeloncorp.com">http://www.exeloncorp.com</a></td>
    </tr><tr><td>93</td>
    <td>Massachusetts Mutual Life Insurance</td>
    <td><a href="http://www.massmutual.com">http://www.massmutual.com</a></td>
    </tr><tr><td>94</td>
    <td>Rite Aid</td>
    <td><a href="http://www.riteaid.com">http://www.riteaid.com</a></td>
    </tr><tr><td>95</td>
    <td>ConocoPhillips</td>
    <td><a href="http://www.conocophillips.com">http://www.conocophillips.com</a></td>
    </tr><tr><td>96</td>
    <td>CHS</td>
    <td><a href="http://www.chsinc.com">http://www.chsinc.com</a></td>
    </tr><tr><td>97</td>
    <td>M</td>
    <td><a href="http://www.3m.com">http://www.3m.com</a></td>
    </tr><tr><td>98</td>
    <td>Time Warner</td>
    <td><a href="http://www.timewarner.com">http://www.timewarner.com</a></td>
    </tr><tr><td>99</td>
    <td>General Dynamics</td>
    <td><a href="http://www.generaldynamics.com">http://www.generaldynamics.com</a></td>
    </tr><tr><td>100</td>
    <td>USAA</td>
    <td><a href="http://www.usaa.com">http://www.usaa.com</a></td>
    </tr><tr><td>101</td>
    <td>Capital One Financial</td>
    <td><a href="http://www.capitalone.com">http://www.capitalone.com</a></td>
    </tr><tr><td>102</td>
    <td>Deere</td>
    <td><a href="http://www.johndeere.com">http://www.johndeere.com</a></td>
    </tr><tr><td>103</td>
    <td>INTL FCStone</td>
    <td><a href="http://www.intlfcstone.com">http://www.intlfcstone.com</a></td>
    </tr><tr><td>104</td>
    <td>Northwestern Mutual</td>
    <td><a href="http://www.northwesternmutual.com">http://www.northwesternmutual.com</a></td>
    </tr><tr><td>105</td>
    <td>Enterprise Products Partners</td>
    <td><a href="http://www.enterpriseproducts.com">http://www.enterpriseproducts.com</a></td>
    </tr><tr><td>106</td>
    <td>Travelers Cos.</td>
    <td><a href="http://www.travelers.com">http://www.travelers.com</a></td>
    </tr><tr><td>107</td>
    <td>Hewlett Packard Enterprise</td>
    <td><a href="http://www.hpe.com">http://www.hpe.com</a></td>
    </tr><tr><td>108</td>
    <td>Philip Morris International</td>
    <td><a href="http://www.pmi.com">http://www.pmi.com</a></td>
    </tr><tr><td>109</td>
    <td>Twenty-First Century Fox</td>
    <td><a href="http://www.21cf.com">http://www.21cf.com</a></td>
    </tr><tr><td>110</td>
    <td>AbbVie</td>
    <td><a href="http://www.abbvie.com">http://www.abbvie.com</a></td>
    </tr><tr><td>111</td>
    <td>Abbott Laboratories</td>
    <td><a href="http://www.abbott.com">http://www.abbott.com</a></td>
    </tr><tr><td>112</td>
    <td>Progressive</td>
    <td><a href="http://www.progressive.com">http://www.progressive.com</a></td>
    </tr><tr><td>113</td>
    <td>Arrow Electronics</td>
    <td><a href="http://www.arrow.com">http://www.arrow.com</a></td>
    </tr><tr><td>114</td>
    <td>Kraft Heinz</td>
    <td><a href="http://www.kraftheinzcompany.com">http://www.kraftheinzcompany.com</a></td>
    </tr><tr><td>115</td>
    <td>Plains GP Holdings</td>
    <td><a href="http://www.plainsallamerican.com">http://www.plainsallamerican.com</a></td>
    </tr><tr><td>116</td>
    <td>Gilead Sciences</td>
    <td><a href="http://www.gilead.com">http://www.gilead.com</a></td>
    </tr><tr><td>117</td>
    <td>Mondelez International</td>
    <td><a href="http://www.mondelezinternational.com">http://www.mondelezinternational.com</a></td>
    </tr><tr><td>118</td>
    <td>Northrop Grumman</td>
    <td><a href="http://www.northropgrumman.com">http://www.northropgrumman.com</a></td>
    </tr><tr><td>119</td>
    <td>Raytheon</td>
    <td><a href="http://www.raytheon.com">http://www.raytheon.com</a></td>
    </tr><tr><td>120</td>
    <td>Macy’s</td>
    <td><a href="http://www.macysinc.com">http://www.macysinc.com</a></td>
    </tr><tr><td>121</td>
    <td>US Foods Holding</td>
    <td><a href="http://www.usfoods.com">http://www.usfoods.com</a></td>
    </tr><tr><td>122</td>
    <td>U.S. Bancorp</td>
    <td><a href="http://www.usbank.com">http://www.usbank.com</a></td>
    </tr><tr><td>123</td>
    <td>Dollar General</td>
    <td><a href="http://www.dollargeneral.com">http://www.dollargeneral.com</a></td>
    </tr><tr><td>124</td>
    <td>International Paper</td>
    <td><a href="http://www.internationalpaper.com">http://www.internationalpaper.com</a></td>
    </tr><tr><td>125</td>
    <td>Duke Energy</td>
    <td><a href="http://www.duke-energy.com">http://www.duke-energy.com</a></td>
    </tr><tr><td>126</td>
    <td>Southern</td>
    <td><a href="http://www.southerncompany.com">http://www.southerncompany.com</a></td>
    </tr><tr><td>127</td>
    <td>Marriott International</td>
    <td><a href="http://www.marriott.com">http://www.marriott.com</a></td>
    </tr><tr><td>128</td>
    <td>Avnet</td>
    <td><a href="http://www.avnet.com">http://www.avnet.com</a></td>
    </tr><tr><td>129</td>
    <td>Eli Lilly</td>
    <td><a href="http://www.lilly.com">http://www.lilly.com</a></td>
    </tr><tr><td>130</td>
    <td>Amgen</td>
    <td><a href="http://www.amgen.com">http://www.amgen.com</a></td>
    </tr><tr><td>131</td>
    <td>McDonald’s</td>
    <td><a href="http://www.aboutmcdonalds.com">http://www.aboutmcdonalds.com</a></td>
    </tr><tr><td>132</td>
    <td>Starbucks</td>
    <td><a href="http://www.starbucks.com">http://www.starbucks.com</a></td>
    </tr><tr><td>133</td>
    <td>Qualcomm</td>
    <td><a href="http://www.qualcomm.com">http://www.qualcomm.com</a></td>
    </tr><tr><td>134</td>
    <td>Dollar Tree</td>
    <td><a href="http://www.dollartree.com">http://www.dollartree.com</a></td>
    </tr><tr><td>135</td>
    <td>PBF Energy</td>
    <td><a href="http://www.pbfenergy.com">http://www.pbfenergy.com</a></td>
    </tr><tr><td>136</td>
    <td>Icahn Enterprises</td>
    <td><a href="http://www.ielp.com">http://www.ielp.com</a></td>
    </tr><tr><td>137</td>
    <td>Aflac</td>
    <td><a href="http://www.aflac.com">http://www.aflac.com</a></td>
    </tr><tr><td>138</td>
    <td>AutoNation</td>
    <td><a href="http://www.autonation.com">http://www.autonation.com</a></td>
    </tr><tr><td>139</td>
    <td>Penske Automotive Group</td>
    <td><a href="http://www.penskeautomotive.com">http://www.penskeautomotive.com</a></td>
    </tr><tr><td>140</td>
    <td>Whirlpool</td>
    <td><a href="http://www.whirlpoolcorp.com">http://www.whirlpoolcorp.com</a></td>
    </tr><tr><td>141</td>
    <td>Union Pacific</td>
    <td><a href="http://www.up.com">http://www.up.com</a></td>
    </tr><tr><td>142</td>
    <td>Southwest Airlines</td>
    <td><a href="http://www.southwest.com">http://www.southwest.com</a></td>
    </tr><tr><td>143</td>
    <td>ManpowerGroup</td>
    <td><a href="http://www.manpowergroup.com">http://www.manpowergroup.com</a></td>
    </tr><tr><td>144</td>
    <td>Thermo Fisher Scientific</td>
    <td><a href="http://www.thermofisher.com">http://www.thermofisher.com</a></td>
    </tr><tr><td>145</td>
    <td>Bristol-Myers Squibb</td>
    <td><a href="http://www.bms.com">http://www.bms.com</a></td>
    </tr><tr><td>146</td>
    <td>Halliburton</td>
    <td><a href="http://www.halliburton.com">http://www.halliburton.com</a></td>
    </tr><tr><td>147</td>
    <td>Tenet Healthcare</td>
    <td><a href="http://www.tenethealth.com">http://www.tenethealth.com</a></td>
    </tr><tr><td>148</td>
    <td>Lear</td>
    <td><a href="http://www.lear.com">http://www.lear.com</a></td>
    </tr><tr><td>149</td>
    <td>Cummins</td>
    <td><a href="http://www.cummins.com">http://www.cummins.com</a></td>
    </tr><tr><td>150</td>
    <td>Micron Technology</td>
    <td><a href="http://www.micron.com">http://www.micron.com</a></td>
    </tr><tr><td>151</td>
    <td>Nucor</td>
    <td><a href="http://www.nucor.com">http://www.nucor.com</a></td>
    </tr><tr><td>152</td>
    <td>Molina Healthcare</td>
    <td><a href="http://www.molinahealthcare.com">http://www.molinahealthcare.com</a></td>
    </tr><tr><td>153</td>
    <td>Fluor</td>
    <td><a href="http://www.fluor.com">http://www.fluor.com</a></td>
    </tr><tr><td>154</td>
    <td>Altria Group</td>
    <td><a href="http://www.altria.com">http://www.altria.com</a></td>
    </tr><tr><td>155</td>
    <td>Paccar</td>
    <td><a href="http://www.paccar.com">http://www.paccar.com</a></td>
    </tr><tr><td>156</td>
    <td>Hartford Financial Services</td>
    <td><a href="http://www.thehartford.com">http://www.thehartford.com</a></td>
    </tr><tr><td>157</td>
    <td>Kohl’s</td>
    <td><a href="http://www.kohls.com">http://www.kohls.com</a></td>
    </tr><tr><td>158</td>
    <td>Western Digital</td>
    <td><a href="http://www.wdc.com">http://www.wdc.com</a></td>
    </tr><tr><td>159</td>
    <td>Jabil</td>
    <td><a href="www.jabil.com">www.jabil.com</a></td>
    </tr><tr><td>160</td>
    <td>Community Health Systems</td>
    <td><a href="http://www.chs.net">http://www.chs.net</a></td>
    </tr><tr><td>161</td>
    <td>Visa</td>
    <td><a href="http://www.visa.com">http://www.visa.com</a></td>
    </tr><tr><td>162</td>
    <td>Danaher</td>
    <td><a href="http://www.danaher.com">http://www.danaher.com</a></td>
    </tr><tr><td>163</td>
    <td>Kimberly-Clark</td>
    <td><a href="http://www.kimberly-clark.com">http://www.kimberly-clark.com</a></td>
    </tr><tr><td>164</td>
    <td>AECOM</td>
    <td><a href="http://www.aecom.com">http://www.aecom.com</a></td>
    </tr><tr><td>165</td>
    <td>PNC Financial Services</td>
    <td><a href="http://www.pnc.com">http://www.pnc.com</a></td>
    </tr><tr><td>166</td>
    <td>CenturyLink</td>
    <td><a href="http://www.centurylink.com">http://www.centurylink.com</a></td>
    </tr><tr><td>167</td>
    <td>NextEra Energy</td>
    <td><a href="http://www.nexteraenergy.com">http://www.nexteraenergy.com</a></td>
    </tr><tr><td>168</td>
    <td>PG&amp;E Corp.</td>
    <td><a href="http://www.pgecorp.com">http://www.pgecorp.com</a></td>
    </tr><tr><td>169</td>
    <td>Synnex</td>
    <td><a href="http://www.synnex.com">http://www.synnex.com</a></td>
    </tr><tr><td>170</td>
    <td>WellCare Health Plans</td>
    <td><a href="http://www.wellcare.com">http://www.wellcare.com</a></td>
    </tr><tr><td>171</td>
    <td>Performance Food Group</td>
    <td><a href="http://www.pfgc.com">http://www.pfgc.com</a></td>
    </tr><tr><td>172</td>
    <td>Sears Holdings</td>
    <td><a href="http://www.searsholdings.com">http://www.searsholdings.com</a></td>
    </tr><tr><td>173</td>
    <td>Synchrony Financial</td>
    <td><a href="http://www.synchronyfinancial.com">http://www.synchronyfinancial.com</a></td>
    </tr><tr><td>174</td>
    <td>CarMax</td>
    <td><a href="http://www.carmax.com">http://www.carmax.com</a></td>
    </tr><tr><td>175</td>
    <td>Bank of New York Mellon</td>
    <td><a href="www.bnymellon.com">www.bnymellon.com</a></td>
    </tr><tr><td>176</td>
    <td>Freeport-McMoRan</td>
    <td><a href="http://www.fcx.com">http://www.fcx.com</a></td>
    </tr><tr><td>177</td>
    <td>Genuine Parts</td>
    <td><a href="http://www.genpt.com">http://www.genpt.com</a></td>
    </tr><tr><td>178</td>
    <td>Emerson Electric</td>
    <td><a href="http://www.emerson.com">http://www.emerson.com</a></td>
    </tr><tr><td>179</td>
    <td>DaVita</td>
    <td><a href="http://www.davita.com">http://www.davita.com</a></td>
    </tr><tr><td>180</td>
    <td>Supervalu</td>
    <td><a href="http://www.supervalu.com">http://www.supervalu.com</a></td>
    </tr><tr><td>181</td>
    <td>Gap</td>
    <td><a href="http://www.gapinc.com">http://www.gapinc.com</a></td>
    </tr><tr><td>182</td>
    <td>General Mills</td>
    <td><a href="http://www.generalmills.com">http://www.generalmills.com</a></td>
    </tr><tr><td>183</td>
    <td>Nordstrom</td>
    <td><a href="http://www.nordstrom.com">http://www.nordstrom.com</a></td>
    </tr><tr><td>184</td>
    <td>Colgate-Palmolive</td>
    <td><a href="http://www.colgatepalmolive.com">http://www.colgatepalmolive.com</a></td>
    </tr><tr><td>185</td>
    <td>American Electric Power</td>
    <td><a href="http://www.aep.com">http://www.aep.com</a></td>
    </tr><tr><td>186</td>
    <td>XPO Logistics</td>
    <td><a href="http://www.xpo.com">http://www.xpo.com</a></td>
    </tr><tr><td>187</td>
    <td>Goodyear Tire &amp; Rubber</td>
    <td><a href="http://www.goodyear.com">http://www.goodyear.com</a></td>
    </tr><tr><td>188</td>
    <td>Omnicom Group</td>
    <td><a href="http://www.omnicomgroup.com">http://www.omnicomgroup.com</a></td>
    </tr><tr><td>189</td>
    <td>CDW</td>
    <td><a href="http://www.cdw.com">http://www.cdw.com</a></td>
    </tr><tr><td>190</td>
    <td>Sherwin-Williams</td>
    <td><a href="http://www.sherwin.com">http://www.sherwin.com</a></td>
    </tr><tr><td>191</td>
    <td>PPG Industries</td>
    <td><a href="http://www.ppg.com">http://www.ppg.com</a></td>
    </tr><tr><td>192</td>
    <td>Texas Instruments</td>
    <td><a href="http://www.ti.com">http://www.ti.com</a></td>
    </tr><tr><td>193</td>
    <td>C.H. Robinson Worldwide</td>
    <td><a href="http://www.chrobinson.com">http://www.chrobinson.com</a></td>
    </tr><tr><td>194</td>
    <td>WestRock</td>
    <td><a href="http://www.westrock.com">http://www.westrock.com</a></td>
    </tr><tr><td>195</td>
    <td>Cognizant Technology Solutions</td>
    <td><a href="http://www.cognizant.com">http://www.cognizant.com</a></td>
    </tr><tr><td>196</td>
    <td>Newell Brands</td>
    <td><a href="http://www.newellbrands.com">http://www.newellbrands.com</a></td>
    </tr><tr><td>197</td>
    <td>CBS</td>
    <td><a href="http://www.cbscorporation.com">http://www.cbscorporation.com</a></td>
    </tr><tr><td>198</td>
    <td>Envision Healthcare</td>
    <td><a href="http://www.evhc.net">http://www.evhc.net</a></td>
    </tr><tr><td>199</td>
    <td>Monsanto</td>
    <td><a href="http://www.monsanto.com">http://www.monsanto.com</a></td>
    </tr><tr><td>200</td>
    <td>Aramark</td>
    <td><a href="http://www.aramark.com">http://www.aramark.com</a></td>
    </tr><tr><td>201</td>
    <td>Applied Materials</td>
    <td><a href="http://www.appliedmaterials.com">http://www.appliedmaterials.com</a></td>
    </tr><tr><td>202</td>
    <td>Waste Management</td>
    <td><a href="http://www.wm.com">http://www.wm.com</a></td>
    </tr><tr><td>203</td>
    <td>DISH Network</td>
    <td><a href="http://www.dish.com">http://www.dish.com</a></td>
    </tr><tr><td>204</td>
    <td>Illinois Tool Works</td>
    <td><a href="http://www.itw.com">http://www.itw.com</a></td>
    </tr><tr><td>205</td>
    <td>Lincoln National</td>
    <td><a href="http://www.lfg.com">http://www.lfg.com</a></td>
    </tr><tr><td>206</td>
    <td>HollyFrontier</td>
    <td><a href="http://www.hollyfrontier.com">http://www.hollyfrontier.com</a></td>
    </tr><tr><td>207</td>
    <td>CBRE Group</td>
    <td><a href="http://www.cbre.com">http://www.cbre.com</a></td>
    </tr><tr><td>208</td>
    <td>Textron</td>
    <td><a href="http://www.textron.com">http://www.textron.com</a></td>
    </tr><tr><td>209</td>
    <td>Ross Stores</td>
    <td><a href="http://www.rossstores.com">http://www.rossstores.com</a></td>
    </tr><tr><td>210</td>
    <td>Principal Financial</td>
    <td><a href="http://www.principal.com">http://www.principal.com</a></td>
    </tr><tr><td>211</td>
    <td>D.R. Horton</td>
    <td><a href="http://www.drhorton.com">http://www.drhorton.com</a></td>
    </tr><tr><td>212</td>
    <td>Marsh &amp; McLennan</td>
    <td><a href="http://www.mmc.com">http://www.mmc.com</a></td>
    </tr><tr><td>213</td>
    <td>Devon Energy</td>
    <td><a href="http://www.devonenergy.com">http://www.devonenergy.com</a></td>
    </tr><tr><td>214</td>
    <td>AES</td>
    <td><a href="http://www.aes.com">http://www.aes.com</a></td>
    </tr><tr><td>215</td>
    <td>Ecolab</td>
    <td><a href="http://www.ecolab.com">http://www.ecolab.com</a></td>
    </tr><tr><td>216</td>
    <td>Land O’Lakes</td>
    <td><a href="http://www.landolakesinc.com">http://www.landolakesinc.com</a></td>
    </tr><tr><td>217</td>
    <td>Loews</td>
    <td><a href="http://www.loews.com">http://www.loews.com</a></td>
    </tr><tr><td>218</td>
    <td>Kinder Morgan</td>
    <td><a href="http://www.kindermorgan.com">http://www.kindermorgan.com</a></td>
    </tr><tr><td>219</td>
    <td>FirstEnergy</td>
    <td><a href="http://www.firstenergycorp.com">http://www.firstenergycorp.com</a></td>
    </tr><tr><td>220</td>
    <td>Occidental Petroleum</td>
    <td><a href="http://www.oxy.com">http://www.oxy.com</a></td>
    </tr><tr><td>221</td>
    <td>Viacom</td>
    <td><a href="http://www.viacom.com">http://www.viacom.com</a></td>
    </tr><tr><td>222</td>
    <td>PayPal Holdings</td>
    <td><a href="http://www.paypal.com">http://www.paypal.com</a></td>
    </tr><tr><td>223</td>
    <td>NGL Energy Partners</td>
    <td><a href="http://www.nglenergypartners.com">http://www.nglenergypartners.com</a></td>
    </tr><tr><td>224</td>
    <td>Celgene</td>
    <td><a href="http://www.celgene.com">http://www.celgene.com</a></td>
    </tr><tr><td>225</td>
    <td>Arconic</td>
    <td><a href="http://www.arconic.com">http://www.arconic.com</a></td>
    </tr><tr><td>226</td>
    <td>Kellogg</td>
    <td><a href="http://www.kelloggcompany.com">http://www.kelloggcompany.com</a></td>
    </tr><tr><td>227</td>
    <td>Las Vegas Sands</td>
    <td><a href="http://www.sands.com">http://www.sands.com</a></td>
    </tr><tr><td>228</td>
    <td>Stanley Black &amp; Decker</td>
    <td><a href="http://www.stanleyblackanddecker.com">http://www.stanleyblackanddecker.com</a></td>
    </tr><tr><td>229</td>
    <td>Booking Holdings</td>
    <td><a href="http://www.bookingholdings.com">http://www.bookingholdings.com</a></td>
    </tr><tr><td>230</td>
    <td>Lennar</td>
    <td><a href="http://www.lennar.com">http://www.lennar.com</a></td>
    </tr><tr><td>231</td>
    <td>L Brands</td>
    <td><a href="http://www.lb.com">http://www.lb.com</a></td>
    </tr><tr><td>232</td>
    <td>DTE Energy</td>
    <td><a href="http://www.dteenergy.com">http://www.dteenergy.com</a></td>
    </tr><tr><td>233</td>
    <td>Dominion Energy</td>
    <td><a href="www.dominionenergy.com">www.dominionenergy.com</a></td>
    </tr><tr><td>234</td>
    <td>Reinsurance Group of America</td>
    <td><a href="http://www.rgare.com">http://www.rgare.com</a></td>
    </tr><tr><td>235</td>
    <td>J.C. Penney</td>
    <td><a href="http://www.jcpenney.com">http://www.jcpenney.com</a></td>
    </tr><tr><td>236</td>
    <td>Mastercard</td>
    <td><a href="http://www.mastercard.com">http://www.mastercard.com</a></td>
    </tr><tr><td>237</td>
    <td>BlackRock</td>
    <td><a href="http://www.blackrock.com">http://www.blackrock.com</a></td>
    </tr><tr><td>238</td>
    <td>Henry Schein</td>
    <td><a href="http://www.henryschein.com">http://www.henryschein.com</a></td>
    </tr><tr><td>239</td>
    <td>Guardian Life Ins. Co. of America</td>
    <td><a href="http://www.guardianlife.com">http://www.guardianlife.com</a></td>
    </tr><tr><td>240</td>
    <td>Stryker</td>
    <td><a href="http://www.stryker.com">http://www.stryker.com</a></td>
    </tr><tr><td>241</td>
    <td>Jefferies Financial Group</td>
    <td><a href="http://www.jefferies.com">http://www.jefferies.com</a></td>
    </tr><tr><td>242</td>
    <td>VF</td>
    <td><a href="http://www.vfc.com">http://www.vfc.com</a></td>
    </tr><tr><td>243</td>
    <td>ADP</td>
    <td><a href="http://www.adp.com">http://www.adp.com</a></td>
    </tr><tr><td>244</td>
    <td>Edison International</td>
    <td><a href="http://www.edisoninvestor.com">http://www.edisoninvestor.com</a></td>
    </tr><tr><td>245</td>
    <td>Biogen</td>
    <td><a href="http://www.biogen.com">http://www.biogen.com</a></td>
    </tr><tr><td>246</td>
    <td>United States Steel</td>
    <td><a href="http://www.ussteel.com">http://www.ussteel.com</a></td>
    </tr><tr><td>247</td>
    <td>Core-Mark Holding</td>
    <td><a href="http://www.core-mark.com">http://www.core-mark.com</a></td>
    </tr><tr><td>248</td>
    <td>Bed Bath &amp; Beyond</td>
    <td><a href="http://www.bedbathandbeyond.com">http://www.bedbathandbeyond.com</a></td>
    </tr><tr><td>249</td>
    <td>Oneok</td>
    <td><a href="http://www.oneok.com">http://www.oneok.com</a></td>
    </tr><tr><td>250</td>
    <td>BB&amp;T Corp.</td>
    <td><a href="http://www.bbt.com">http://www.bbt.com</a></td>
    </tr><tr><td>251</td>
    <td>Becton Dickinson</td>
    <td><a href="http://www.bd.com">http://www.bd.com</a></td>
    </tr><tr><td>252</td>
    <td>Ameriprise Financial</td>
    <td><a href="http://www.ameriprise.com">http://www.ameriprise.com</a></td>
    </tr><tr><td>253</td>
    <td>Farmers Insurance Exchange</td>
    <td><a href="http://www.farmers.com">http://www.farmers.com</a></td>
    </tr><tr><td>254</td>
    <td>First Data</td>
    <td><a href="http://www.firstdata.com">http://www.firstdata.com</a></td>
    </tr><tr><td>255</td>
    <td>Consolidated Edison</td>
    <td><a href="http://www.conedison.com">http://www.conedison.com</a></td>
    </tr><tr><td>256</td>
    <td>Parker-Hannifin</td>
    <td><a href="http://www.parker.com">http://www.parker.com</a></td>
    </tr><tr><td>257</td>
    <td>Anadarko Petroleum</td>
    <td><a href="http://www.anadarko.com">http://www.anadarko.com</a></td>
    </tr><tr><td>258</td>
    <td>Estee Lauder</td>
    <td><a href="http://www.elcompanies.com">http://www.elcompanies.com</a></td>
    </tr><tr><td>259</td>
    <td>State Street Corp.</td>
    <td><a href="http://www.statestreet.com">http://www.statestreet.com</a></td>
    </tr><tr><td>260</td>
    <td>Tesla</td>
    <td><a href="http://www.tesla.com">http://www.tesla.com</a></td>
    </tr><tr><td>261</td>
    <td>Netflix</td>
    <td><a href="http://www.netflix.com">http://www.netflix.com</a></td>
    </tr><tr><td>262</td>
    <td>Alcoa</td>
    <td><a href="http://www.alcoa.com">http://www.alcoa.com</a></td>
    </tr><tr><td>263</td>
    <td>Discover Financial Services</td>
    <td><a href="http://www.discover.com">http://www.discover.com</a></td>
    </tr><tr><td>264</td>
    <td>Praxair</td>
    <td><a href="http://www.praxair.com">http://www.praxair.com</a></td>
    </tr><tr><td>265</td>
    <td>CSX</td>
    <td><a href="http://www.csx.com">http://www.csx.com</a></td>
    </tr><tr><td>266</td>
    <td>Xcel Energy</td>
    <td><a href="http://www.xcelenergy.com">http://www.xcelenergy.com</a></td>
    </tr><tr><td>267</td>
    <td>Unum Group</td>
    <td><a href="http://www.unum.com">http://www.unum.com</a></td>
    </tr><tr><td>268</td>
    <td>Universal Health Services</td>
    <td><a href="http://www.uhsinc.com">http://www.uhsinc.com</a></td>
    </tr><tr><td>269</td>
    <td>NRG Energy</td>
    <td><a href="http://www.nrg.com">http://www.nrg.com</a></td>
    </tr><tr><td>270</td>
    <td>EOG Resources</td>
    <td><a href="http://www.eogresources.com">http://www.eogresources.com</a></td>
    </tr><tr><td>271</td>
    <td>Sempra Energy</td>
    <td><a href="http://www.sempra.com">http://www.sempra.com</a></td>
    </tr><tr><td>272</td>
    <td>Toys “R” Us</td>
    <td><a href="http://www.toysrusinc.com">http://www.toysrusinc.com</a></td>
    </tr><tr><td>273</td>
    <td>Group Automotive</td>
    <td><a href="http://www.group1auto.com">http://www.group1auto.com</a></td>
    </tr><tr><td>274</td>
    <td>Entergy</td>
    <td><a href="http://www.entergy.com">http://www.entergy.com</a></td>
    </tr><tr><td>275</td>
    <td>Molson Coors Brewing</td>
    <td><a href="http://www.molsoncoors.com">http://www.molsoncoors.com</a></td>
    </tr><tr><td>276</td>
    <td>L Technologies</td>
    <td><a href="http://www.l3t.com">http://www.l3t.com</a></td>
    </tr><tr><td>277</td>
    <td>Ball</td>
    <td><a href="http://www.ball.com">http://www.ball.com</a></td>
    </tr><tr><td>278</td>
    <td>AutoZone</td>
    <td><a href="http://www.autozone.com">http://www.autozone.com</a></td>
    </tr><tr><td>279</td>
    <td>Murphy USA</td>
    <td><a href="http://www.murphyusa.com">http://www.murphyusa.com</a></td>
    </tr><tr><td>280</td>
    <td>MGM Resorts International</td>
    <td><a href="http://www.mgmresorts.com">http://www.mgmresorts.com</a></td>
    </tr><tr><td>281</td>
    <td>Office Depot</td>
    <td><a href="http://www.officedepot.com">http://www.officedepot.com</a></td>
    </tr><tr><td>282</td>
    <td>Huntsman</td>
    <td><a href="http://www.huntsman.com">http://www.huntsman.com</a></td>
    </tr><tr><td>283</td>
    <td>Baxter International</td>
    <td><a href="http://www.baxter.com">http://www.baxter.com</a></td>
    </tr><tr><td>284</td>
    <td>Norfolk Southern</td>
    <td><a href="http://www.norfolksouthern.com">http://www.norfolksouthern.com</a></td>
    </tr><tr><td>285</td>
    <td>salesforce.com</td>
    <td><a href="http://www.salesforce.com">http://www.salesforce.com</a></td>
    </tr><tr><td>286</td>
    <td>Laboratory Corp. of America</td>
    <td><a href="http://www.labcorp.com">http://www.labcorp.com</a></td>
    </tr><tr><td>287</td>
    <td>W.W. Grainger</td>
    <td><a href="http://www.grainger.com">http://www.grainger.com</a></td>
    </tr><tr><td>288</td>
    <td>Qurate Retail</td>
    <td><a href="http://www.libertyinteractive.com">http://www.libertyinteractive.com</a></td>
    </tr><tr><td>289</td>
    <td>Autoliv</td>
    <td><a href="http://www.autoliv.com">http://www.autoliv.com</a></td>
    </tr><tr><td>290</td>
    <td>Live Nation Entertainment</td>
    <td><a href="http://www.livenationentertainment.com">http://www.livenationentertainment.com</a></td>
    </tr><tr><td>291</td>
    <td>Xerox</td>
    <td><a href="http://www.xerox.com">http://www.xerox.com</a></td>
    </tr><tr><td>292</td>
    <td>Leidos Holdings</td>
    <td><a href="http://www.leidos.com">http://www.leidos.com</a></td>
    </tr><tr><td>293</td>
    <td>Corning</td>
    <td><a href="http://www.corning.com">http://www.corning.com</a></td>
    </tr><tr><td>294</td>
    <td>Lithia Motors</td>
    <td><a href="http://www.lithiainvestorrelations.com">http://www.lithiainvestorrelations.com</a></td>
    </tr><tr><td>295</td>
    <td>Expedia Group</td>
    <td><a href="http://www.expediagroup.com">http://www.expediagroup.com</a></td>
    </tr><tr><td>296</td>
    <td>Republic Services</td>
    <td><a href="http://www.republicservices.com">http://www.republicservices.com</a></td>
    </tr><tr><td>297</td>
    <td>Jacobs Engineering Group</td>
    <td><a href="http://www.jacobs.com">http://www.jacobs.com</a></td>
    </tr><tr><td>298</td>
    <td>Sonic Automotive</td>
    <td><a href="http://www.sonicautomotive.com">http://www.sonicautomotive.com</a></td>
    </tr><tr><td>299</td>
    <td>Ally Financial</td>
    <td><a href="http://www.ally.com">http://www.ally.com</a></td>
    </tr><tr><td>300</td>
    <td>LKQ</td>
    <td><a href="http://www.lkqcorp.com">http://www.lkqcorp.com</a></td>
    </tr><tr><td>301</td>
    <td>BorgWarner</td>
    <td><a href="http://www.borgwarner.com">http://www.borgwarner.com</a></td>
    </tr><tr><td>302</td>
    <td>Fidelity National Financial</td>
    <td><a href="http://www.fnf.com">http://www.fnf.com</a></td>
    </tr><tr><td>303</td>
    <td>SunTrust Banks</td>
    <td><a href="http://www.suntrust.com">http://www.suntrust.com</a></td>
    </tr><tr><td>304</td>
    <td>IQVIA Holdings</td>
    <td><a href="www.iqvia.com">www.iqvia.com</a></td>
    </tr><tr><td>305</td>
    <td>Reliance Steel &amp; Aluminum</td>
    <td><a href="http://www.rsac.com">http://www.rsac.com</a></td>
    </tr><tr><td>306</td>
    <td>Nvidia</td>
    <td><a href="http://www.nvidia.com">http://www.nvidia.com</a></td>
    </tr><tr><td>307</td>
    <td>Voya Financial</td>
    <td><a href="http://www.voya.com">http://www.voya.com</a></td>
    </tr><tr><td>308</td>
    <td>CenterPoint Energy</td>
    <td><a href="http://www.centerpointenergy.com">http://www.centerpointenergy.com</a></td>
    </tr><tr><td>309</td>
    <td>eBay</td>
    <td><a href="http://www.ebay.com">http://www.ebay.com</a></td>
    </tr><tr><td>310</td>
    <td>Eastman Chemical</td>
    <td><a href="http://www.eastman.com">http://www.eastman.com</a></td>
    </tr><tr><td>311</td>
    <td>American Family Insurance Group</td>
    <td><a href="http://www.amfam.com">http://www.amfam.com</a></td>
    </tr><tr><td>312</td>
    <td>Steel Dynamics</td>
    <td><a href="http://www.steeldynamics.com">http://www.steeldynamics.com</a></td>
    </tr><tr><td>313</td>
    <td>Pacific Life</td>
    <td><a href="http://www.pacificlife.com">http://www.pacificlife.com</a></td>
    </tr><tr><td>314</td>
    <td>Chesapeake Energy</td>
    <td><a href="http://www.chk.com">http://www.chk.com</a></td>
    </tr><tr><td>315</td>
    <td>Mohawk Industries</td>
    <td><a href="http://www.mohawkind.com">http://www.mohawkind.com</a></td>
    </tr><tr><td>316</td>
    <td>Quanta Services</td>
    <td><a href="http://www.quantaservices.com">http://www.quantaservices.com</a></td>
    </tr><tr><td>317</td>
    <td>Advance Auto Parts</td>
    <td><a href="http://www.advanceautoparts.com">http://www.advanceautoparts.com</a></td>
    </tr><tr><td>318</td>
    <td>Owens &amp; Minor</td>
    <td><a href="http://www.owens-minor.com">http://www.owens-minor.com</a></td>
    </tr><tr><td>319</td>
    <td>United Natural Foods</td>
    <td><a href="http://www.unfi.com">http://www.unfi.com</a></td>
    </tr><tr><td>320</td>
    <td>Tenneco</td>
    <td><a href="http://www.tenneco.com">http://www.tenneco.com</a></td>
    </tr><tr><td>321</td>
    <td>Conagra Brands</td>
    <td><a href="http://www.conagrabrands.com">http://www.conagrabrands.com</a></td>
    </tr><tr><td>322</td>
    <td>GameStop</td>
    <td><a href="http://www.gamestop.com">http://www.gamestop.com</a></td>
    </tr><tr><td>323</td>
    <td>Hormel Foods</td>
    <td><a href="http://www.hormelfoods.com">http://www.hormelfoods.com</a></td>
    </tr><tr><td>324</td>
    <td>Hilton Worldwide Holdings</td>
    <td><a href="http://www.hiltonworldwide.com">http://www.hiltonworldwide.com</a></td>
    </tr><tr><td>325</td>
    <td>Frontier Communications</td>
    <td><a href="http://www.frontier.com">http://www.frontier.com</a></td>
    </tr><tr><td>326</td>
    <td>Fidelity National Information Services</td>
    <td><a href="http://www.fisglobal.com">http://www.fisglobal.com</a></td>
    </tr><tr><td>327</td>
    <td>Public Service Enterprise Group</td>
    <td><a href="http://www.pseg.com">http://www.pseg.com</a></td>
    </tr><tr><td>328</td>
    <td>Boston Scientific</td>
    <td><a href="http://www.bostonscientific.com">http://www.bostonscientific.com</a></td>
    </tr><tr><td>329</td>
    <td>O’Reilly Automotive</td>
    <td><a href="http://www.oreillyauto.com">http://www.oreillyauto.com</a></td>
    </tr><tr><td>330</td>
    <td>Charles Schwab</td>
    <td><a href="http://www.aboutschwab.com">http://www.aboutschwab.com</a></td>
    </tr><tr><td>331</td>
    <td>Global Partners</td>
    <td><a href="http://www.globalp.com">http://www.globalp.com</a></td>
    </tr><tr><td>332</td>
    <td>PVH</td>
    <td><a href="http://www.pvh.com">http://www.pvh.com</a></td>
    </tr><tr><td>333</td>
    <td>Avis Budget Group</td>
    <td><a href="http://www.avisbudgetgroup.com">http://www.avisbudgetgroup.com</a></td>
    </tr><tr><td>334</td>
    <td>Targa Resources</td>
    <td><a href="http://www.targaresources.com">http://www.targaresources.com</a></td>
    </tr><tr><td>335</td>
    <td>Hertz Global Holdings</td>
    <td><a href="http://www.hertz.com">http://www.hertz.com</a></td>
    </tr><tr><td>336</td>
    <td>Calpine</td>
    <td><a href="http://www.calpine.com">http://www.calpine.com</a></td>
    </tr><tr><td>337</td>
    <td>Mutual of Omaha Insurance</td>
    <td><a href="http://www.mutualofomaha.com">http://www.mutualofomaha.com</a></td>
    </tr><tr><td>338</td>
    <td>Crown Holdings</td>
    <td><a href="http://www.crowncork.com">http://www.crowncork.com</a></td>
    </tr><tr><td>339</td>
    <td>Peter Kiewit Sons’</td>
    <td><a href="http://www.kiewit.com">http://www.kiewit.com</a></td>
    </tr><tr><td>340</td>
    <td>Dick’s Sporting Goods</td>
    <td><a href="http://www.dicks.com">http://www.dicks.com</a></td>
    </tr><tr><td>341</td>
    <td>PulteGroup</td>
    <td><a href="http://www.pultegroupinc.com">http://www.pultegroupinc.com</a></td>
    </tr><tr><td>342</td>
    <td>Navistar International</td>
    <td><a href="http://www.navistar.com">http://www.navistar.com</a></td>
    </tr><tr><td>343</td>
    <td>Thrivent Financial for Lutherans</td>
    <td><a href="http://www.thrivent.com">http://www.thrivent.com</a></td>
    </tr><tr><td>344</td>
    <td>DCP Midstream</td>
    <td><a href="http://www.dcpmidstream.com">http://www.dcpmidstream.com</a></td>
    </tr><tr><td>345</td>
    <td>Air Products &amp; Chemicals</td>
    <td><a href="http://www.airproducts.com">http://www.airproducts.com</a></td>
    </tr><tr><td>346</td>
    <td>Veritiv</td>
    <td><a href="http://www.veritivcorp.com">http://www.veritivcorp.com</a></td>
    </tr><tr><td>347</td>
    <td>AGCO</td>
    <td><a href="http://www.agcocorp.com">http://www.agcocorp.com</a></td>
    </tr><tr><td>348</td>
    <td>Genworth Financial</td>
    <td><a href="http://www.genworth.com">http://www.genworth.com</a></td>
    </tr><tr><td>349</td>
    <td>Univar</td>
    <td><a href="http://www.univar.com">http://www.univar.com</a></td>
    </tr><tr><td>350</td>
    <td>News Corp.</td>
    <td><a href="http://www.newscorp.com">http://www.newscorp.com</a></td>
    </tr><tr><td>351</td>
    <td>SpartanNash</td>
    <td><a href="http://www.spartannash.com">http://www.spartannash.com</a></td>
    </tr><tr><td>352</td>
    <td>Westlake Chemical</td>
    <td><a href="http://www.westlake.com">http://www.westlake.com</a></td>
    </tr><tr><td>353</td>
    <td>Williams</td>
    <td><a href="http://www.williams.com">http://www.williams.com</a></td>
    </tr><tr><td>354</td>
    <td>Lam Research</td>
    <td><a href="http://www.lamresearch.com">http://www.lamresearch.com</a></td>
    </tr><tr><td>355</td>
    <td>Alaska Air Group</td>
    <td><a href="http://www.alaskaair.com">http://www.alaskaair.com</a></td>
    </tr><tr><td>356</td>
    <td>Jones Lang LaSalle</td>
    <td><a href="http://www.jll.com">http://www.jll.com</a></td>
    </tr><tr><td>357</td>
    <td>Anixter International</td>
    <td><a href="http://www.anixter.com">http://www.anixter.com</a></td>
    </tr><tr><td>358</td>
    <td>Campbell Soup</td>
    <td><a href="http://www.campbellsoupcompany.com">http://www.campbellsoupcompany.com</a></td>
    </tr><tr><td>359</td>
    <td>Interpublic Group</td>
    <td><a href="http://www.interpublic.com">http://www.interpublic.com</a></td>
    </tr><tr><td>360</td>
    <td>Dover</td>
    <td><a href="http://www.dovercorporation.com">http://www.dovercorporation.com</a></td>
    </tr><tr><td>361</td>
    <td>Zimmer Biomet Holdings</td>
    <td><a href="http://www.zimmerbiomet.com">http://www.zimmerbiomet.com</a></td>
    </tr><tr><td>362</td>
    <td>Dean Foods</td>
    <td><a href="http://www.deanfoods.com">http://www.deanfoods.com</a></td>
    </tr><tr><td>363</td>
    <td>Foot Locker</td>
    <td><a href="http://www.footlocker-inc.com">http://www.footlocker-inc.com</a></td>
    </tr><tr><td>364</td>
    <td>Eversource Energy</td>
    <td><a href="http://www.eversource.com">http://www.eversource.com</a></td>
    </tr><tr><td>365</td>
    <td>Alliance Data Systems</td>
    <td><a href="http://www.alliancedata.com">http://www.alliancedata.com</a></td>
    </tr><tr><td>366</td>
    <td>Fifth Third Bancorp</td>
    <td><a href="http://www.53.com">http://www.53.com</a></td>
    </tr><tr><td>367</td>
    <td>Quest Diagnostics</td>
    <td><a href="http://www.questdiagnostics.com">http://www.questdiagnostics.com</a></td>
    </tr><tr><td>368</td>
    <td>EMCOR Group</td>
    <td><a href="http://www.emcorgroup.com">http://www.emcorgroup.com</a></td>
    </tr><tr><td>369</td>
    <td>W.R. Berkley</td>
    <td><a href="http://www.wrberkley.com">http://www.wrberkley.com</a></td>
    </tr><tr><td>370</td>
    <td>WESCO International</td>
    <td><a href="http://www.wesco.com">http://www.wesco.com</a></td>
    </tr><tr><td>371</td>
    <td>Coty</td>
    <td><a href="http://www.coty.com">http://www.coty.com</a></td>
    </tr><tr><td>372</td>
    <td>WEC Energy Group</td>
    <td><a href="http://www.wecenergygroup.com">http://www.wecenergygroup.com</a></td>
    </tr><tr><td>373</td>
    <td>Masco</td>
    <td><a href="http://www.masco.com">http://www.masco.com</a></td>
    </tr><tr><td>374</td>
    <td>DXC Technology</td>
    <td><a href="http://www.dxc.technology">http://www.dxc.technology</a></td>
    </tr><tr><td>375</td>
    <td>Auto-Owners Insurance</td>
    <td><a href="http://www.auto-owners.com">http://www.auto-owners.com</a></td>
    </tr><tr><td>376</td>
    <td>Jones Financial (Edward Jones)</td>
    <td><a href="www.iqvia.comwww.edwardjones.com">www.iqvia.comwww.edwardjones.com</a></td>
    </tr><tr><td>377</td>
    <td>Liberty Media</td>
    <td><a href="http://www.libertymedia.com">http://www.libertymedia.com</a></td>
    </tr><tr><td>378</td>
    <td>Erie Insurance Group</td>
    <td><a href="http://www.erieinsurance.com">http://www.erieinsurance.com</a></td>
    </tr><tr><td>379</td>
    <td>Hershey</td>
    <td><a href="http://www.thehersheycompany.com">http://www.thehersheycompany.com</a></td>
    </tr><tr><td>380</td>
    <td>PPL</td>
    <td><a href="http://www.pplweb.com">http://www.pplweb.com</a></td>
    </tr><tr><td>381</td>
    <td>Huntington Ingalls Industries</td>
    <td><a href="http://www.huntingtoningalls.com">http://www.huntingtoningalls.com</a></td>
    </tr><tr><td>382</td>
    <td>Mosaic</td>
    <td><a href="http://www.mosaicco.com">http://www.mosaicco.com</a></td>
    </tr><tr><td>383</td>
    <td>J.M. Smucker</td>
    <td><a href="http://www.jmsmucker.com">http://www.jmsmucker.com</a></td>
    </tr><tr><td>384</td>
    <td>Delek US Holdings</td>
    <td><a href="http://www.delekus.com">http://www.delekus.com</a></td>
    </tr><tr><td>385</td>
    <td>Newmont Mining</td>
    <td><a href="http://www.newmont.com">http://www.newmont.com</a></td>
    </tr><tr><td>386</td>
    <td>Constellation Brands</td>
    <td><a href="http://www.cbrands.com">http://www.cbrands.com</a></td>
    </tr><tr><td>387</td>
    <td>Ryder System</td>
    <td><a href="http://www.ryder.com">http://www.ryder.com</a></td>
    </tr><tr><td>388</td>
    <td>National Oilwell Varco</td>
    <td><a href="http://www.nov.com">http://www.nov.com</a></td>
    </tr><tr><td>389</td>
    <td>Adobe Systems</td>
    <td><a href="http://www.adobe.com">http://www.adobe.com</a></td>
    </tr><tr><td>390</td>
    <td>LifePoint Health</td>
    <td><a href="http://www.lifepointhealth.net">http://www.lifepointhealth.net</a></td>
    </tr><tr><td>391</td>
    <td>Tractor Supply</td>
    <td><a href="http://www.tractorsupply.com">http://www.tractorsupply.com</a></td>
    </tr><tr><td>392</td>
    <td>Thor Industries</td>
    <td><a href="http://www.thorindustries.com">http://www.thorindustries.com</a></td>
    </tr><tr><td>393</td>
    <td>Dana</td>
    <td><a href="http://www.dana.com">http://www.dana.com</a></td>
    </tr><tr><td>394</td>
    <td>Weyerhaeuser</td>
    <td><a href="http://www.weyerhaeuser.com">http://www.weyerhaeuser.com</a></td>
    </tr><tr><td>395</td>
    <td>J.B. Hunt Transport Services</td>
    <td><a href="http://www.jbhunt.com">http://www.jbhunt.com</a></td>
    </tr><tr><td>396</td>
    <td>Darden Restaurants</td>
    <td><a href="http://www.darden.com">http://www.darden.com</a></td>
    </tr><tr><td>397</td>
    <td>Yum China Holdings</td>
    <td><a href="http://ir.yumchina.com">http://ir.yumchina.com</a></td>
    </tr><tr><td>398</td>
    <td>Blackstone Group</td>
    <td><a href="http://www.blackstone.com">http://www.blackstone.com</a></td>
    </tr><tr><td>399</td>
    <td>Berry Global Group</td>
    <td><a href="http://www.berryglobal.com">http://www.berryglobal.com</a></td>
    </tr><tr><td>400</td>
    <td>Builders FirstSource</td>
    <td><a href="http://www.bldr.com">http://www.bldr.com</a></td>
    </tr><tr><td>401</td>
    <td>Activision Blizzard</td>
    <td><a href="http://www.activisionblizzard.com">http://www.activisionblizzard.com</a></td>
    </tr><tr><td>402</td>
    <td>JetBlue Airways</td>
    <td><a href="http://www.jetblue.com">http://www.jetblue.com</a></td>
    </tr><tr><td>403</td>
    <td>Amphenol</td>
    <td><a href="http://www.amphenol.com">http://www.amphenol.com</a></td>
    </tr><tr><td>404</td>
    <td>A-Mark Precious Metals</td>
    <td><a href="http://www.amark.com">http://www.amark.com</a></td>
    </tr><tr><td>405</td>
    <td>Spirit AeroSystems Holdings</td>
    <td><a href="http://www.spiritaero.com">http://www.spiritaero.com</a></td>
    </tr><tr><td>406</td>
    <td>R.R. Donnelley &amp; Sons</td>
    <td><a href="http://www.rrdonnelley.com">http://www.rrdonnelley.com</a></td>
    </tr><tr><td>407</td>
    <td>Harris</td>
    <td><a href="http://www.harris.com">http://www.harris.com</a></td>
    </tr><tr><td>408</td>
    <td>Expeditors Intl. of Washington</td>
    <td><a href="http://www.expeditors.com">http://www.expeditors.com</a></td>
    </tr><tr><td>409</td>
    <td>Discovery</td>
    <td><a href="http://www.discovery.com">http://www.discovery.com</a></td>
    </tr><tr><td>410</td>
    <td>Owens-Illinois</td>
    <td><a href="http://www.o-i.com">http://www.o-i.com</a></td>
    </tr><tr><td>411</td>
    <td>Sanmina</td>
    <td><a href="http://www.sanmina.com">http://www.sanmina.com</a></td>
    </tr><tr><td>412</td>
    <td>KeyCorp</td>
    <td><a href="http://www.key.com">http://www.key.com</a></td>
    </tr><tr><td>413</td>
    <td>American Financial Group</td>
    <td><a href="http://www.afginc.com">http://www.afginc.com</a></td>
    </tr><tr><td>414</td>
    <td>Oshkosh</td>
    <td><a href="http://www.oshkoshcorporation.com">http://www.oshkoshcorporation.com</a></td>
    </tr><tr><td>415</td>
    <td>Rockwell Collins</td>
    <td><a href="http://www.rockwellcollins.com">http://www.rockwellcollins.com</a></td>
    </tr><tr><td>416</td>
    <td>Kindred Healthcare</td>
    <td><a href="http://www.kindredhealthcare.com">http://www.kindredhealthcare.com</a></td>
    </tr><tr><td>417</td>
    <td>Insight Enterprises</td>
    <td><a href="http://www.insight.com">http://www.insight.com</a></td>
    </tr><tr><td>418</td>
    <td>Dr Pepper Snapple Group</td>
    <td><a href="http://www.drpeppersnapplegroup.com">http://www.drpeppersnapplegroup.com</a></td>
    </tr><tr><td>419</td>
    <td>American Tower</td>
    <td><a href="http://www.americantower.com">http://www.americantower.com</a></td>
    </tr><tr><td>420</td>
    <td>Fortive</td>
    <td><a href="http://www.fortive.com">http://www.fortive.com</a></td>
    </tr><tr><td>421</td>
    <td>Ralph Lauren</td>
    <td><a href="http://www.ralphlauren.com">http://www.ralphlauren.com</a></td>
    </tr><tr><td>422</td>
    <td>HRG Group</td>
    <td><a href="http://www.hrggroup.com">http://www.hrggroup.com</a></td>
    </tr><tr><td>423</td>
    <td>Ascena Retail Group</td>
    <td><a href="http://www.ascenaretail.com">http://www.ascenaretail.com</a></td>
    </tr><tr><td>424</td>
    <td>United Rentals</td>
    <td><a href="http://www.unitedrentals.com">http://www.unitedrentals.com</a></td>
    </tr><tr><td>425</td>
    <td>Casey’s General Stores</td>
    <td><a href="http://www.caseys.com">http://www.caseys.com</a></td>
    </tr><tr><td>426</td>
    <td>Graybar Electric</td>
    <td><a href="http://www.graybar.com">http://www.graybar.com</a></td>
    </tr><tr><td>427</td>
    <td>Avery Dennison</td>
    <td><a href="http://www.averydennison.com">http://www.averydennison.com</a></td>
    </tr><tr><td>428</td>
    <td>MasTec</td>
    <td><a href="http://www.mastec.com">http://www.mastec.com</a></td>
    </tr><tr><td>429</td>
    <td>CMS Energy</td>
    <td><a href="http://www.cmsenergy.com">http://www.cmsenergy.com</a></td>
    </tr><tr><td>430</td>
    <td>HD Supply Holdings</td>
    <td><a href="http://www.hdsupply.com">http://www.hdsupply.com</a></td>
    </tr><tr><td>431</td>
    <td>Raymond James Financial</td>
    <td><a href="http://www.raymondjames.com">http://www.raymondjames.com</a></td>
    </tr><tr><td>432</td>
    <td>NCR</td>
    <td><a href="http://www.ncr.com">http://www.ncr.com</a></td>
    </tr><tr><td>433</td>
    <td>Hanesbrands</td>
    <td><a href="http://www.hanes.com">http://www.hanes.com</a></td>
    </tr><tr><td>434</td>
    <td>Asbury Automotive Group</td>
    <td><a href="http://www.asburyauto.com">http://www.asburyauto.com</a></td>
    </tr><tr><td>435</td>
    <td>Citizens Financial Group</td>
    <td><a href="http://www.citizensbank.com">http://www.citizensbank.com</a></td>
    </tr><tr><td>436</td>
    <td>Packaging Corp. of America</td>
    <td><a href="http://www.packagingcorp.com">http://www.packagingcorp.com</a></td>
    </tr><tr><td>437</td>
    <td>Alleghany</td>
    <td><a href="http://www.alleghany.com">http://www.alleghany.com</a></td>
    </tr><tr><td>438</td>
    <td>Apache</td>
    <td><a href="http://www.apachecorp.com">http://www.apachecorp.com</a></td>
    </tr><tr><td>439</td>
    <td>Dillard’s</td>
    <td><a href="http://www.dillards.com">http://www.dillards.com</a></td>
    </tr><tr><td>440</td>
    <td>Assurant</td>
    <td><a href="http://www.assurant.com">http://www.assurant.com</a></td>
    </tr><tr><td>441</td>
    <td>Franklin Resources</td>
    <td><a href="http://www.franklinresources.com">http://www.franklinresources.com</a></td>
    </tr><tr><td>442</td>
    <td>Owens Corning</td>
    <td><a href="http://www.owenscorning.com">http://www.owenscorning.com</a></td>
    </tr><tr><td>443</td>
    <td>Motorola Solutions</td>
    <td><a href="http://www.motorolasolutions.com">http://www.motorolasolutions.com</a></td>
    </tr><tr><td>444</td>
    <td>NVR</td>
    <td><a href="http://www.nvrinc.com">http://www.nvrinc.com</a></td>
    </tr><tr><td>445</td>
    <td>Rockwell Automation</td>
    <td><a href="http://www.rockwellautomation.com">http://www.rockwellautomation.com</a></td>
    </tr><tr><td>446</td>
    <td>TreeHouse Foods</td>
    <td><a href="http://www.treehousefoods.com">http://www.treehousefoods.com</a></td>
    </tr><tr><td>447</td>
    <td>Wynn Resorts</td>
    <td><a href="http://www.wynnresorts.com">http://www.wynnresorts.com</a></td>
    </tr><tr><td>448</td>
    <td>Olin</td>
    <td><a href="http://www.olin.com">http://www.olin.com</a></td>
    </tr><tr><td>449</td>
    <td>American Axle &amp; Manufacturing</td>
    <td><a href="http://www.aam.com">http://www.aam.com</a></td>
    </tr><tr><td>450</td>
    <td>Old Republic International</td>
    <td><a href="http://www.oldrepublic.com">http://www.oldrepublic.com</a></td>
    </tr><tr><td>451</td>
    <td>Chemours</td>
    <td><a href="http://www.chemours.com">http://www.chemours.com</a></td>
    </tr><tr><td>452</td>
    <td>iHeartMedia</td>
    <td><a href="http://www.iheartmedia.com">http://www.iheartmedia.com</a></td>
    </tr><tr><td>453</td>
    <td>Ameren</td>
    <td><a href="http://www.ameren.com">http://www.ameren.com</a></td>
    </tr><tr><td>454</td>
    <td>Arthur J. Gallagher</td>
    <td><a href="http://www.ajg.com">http://www.ajg.com</a></td>
    </tr><tr><td>455</td>
    <td>Celanese</td>
    <td><a href="http://www.celanese.com">http://www.celanese.com</a></td>
    </tr><tr><td>456</td>
    <td>Sealed Air</td>
    <td><a href="http://www.sealedair.com">http://www.sealedair.com</a></td>
    </tr><tr><td>457</td>
    <td>UGI</td>
    <td><a href="http://www.ugicorp.com">http://www.ugicorp.com</a></td>
    </tr><tr><td>458</td>
    <td>Realogy Holdings</td>
    <td><a href="http://www.realogy.com">http://www.realogy.com</a></td>
    </tr><tr><td>459</td>
    <td>Burlington Stores</td>
    <td><a href="http://www.burlington.com">http://www.burlington.com</a></td>
    </tr><tr><td>460</td>
    <td>Regions Financial</td>
    <td><a href="http://www.regions.com">http://www.regions.com</a></td>
    </tr><tr><td>461</td>
    <td>AK Steel Holding</td>
    <td><a href="http://www.aksteel.com">http://www.aksteel.com</a></td>
    </tr><tr><td>462</td>
    <td>Securian Financial Group</td>
    <td><a href="http://www.securian.com">http://www.securian.com</a></td>
    </tr><tr><td>463</td>
    <td>S&amp;P Global</td>
    <td><a href="http://www.spglobal.com">http://www.spglobal.com</a></td>
    </tr><tr><td>464</td>
    <td>Markel</td>
    <td><a href="http://www.markelcorp.com">http://www.markelcorp.com</a></td>
    </tr><tr><td>465</td>
    <td>TravelCenters of America</td>
    <td><a href="http://www.ta-petro.com">http://www.ta-petro.com</a></td>
    </tr><tr><td>466</td>
    <td>Conduent</td>
    <td><a href="http://www.conduent.com">http://www.conduent.com</a></td>
    </tr><tr><td>467</td>
    <td>M&amp;T Bank Corp.</td>
    <td><a href="http://www.mtb.com">http://www.mtb.com</a></td>
    </tr><tr><td>468</td>
    <td>Clorox</td>
    <td><a href="http://www.thecloroxcompany.com">http://www.thecloroxcompany.com</a></td>
    </tr><tr><td>469</td>
    <td>AmTrust Financial Services</td>
    <td><a href="http://www.amtrustfinancial.com">http://www.amtrustfinancial.com</a></td>
    </tr><tr><td>470</td>
    <td>KKR</td>
    <td><a href="http://www.kkr.com">http://www.kkr.com</a></td>
    </tr><tr><td>471</td>
    <td>Ulta Beauty</td>
    <td><a href="http://www.ulta.com">http://www.ulta.com</a></td>
    </tr><tr><td>472</td>
    <td>Yum Brands</td>
    <td><a href="http://www.yum.com">http://www.yum.com</a></td>
    </tr><tr><td>473</td>
    <td>Regeneron Pharmaceuticals</td>
    <td><a href="http://www.regeneron.com">http://www.regeneron.com</a></td>
    </tr><tr><td>474</td>
    <td>Windstream Holdings</td>
    <td><a href="http://www.windstream.com">http://www.windstream.com</a></td>
    </tr><tr><td>475</td>
    <td>Magellan Health</td>
    <td><a href="http://www.magellanhealth.com">http://www.magellanhealth.com</a></td>
    </tr><tr><td>476</td>
    <td>Western &amp; Southern Financial</td>
    <td><a href="http://www.westernsouthern.com">http://www.westernsouthern.com</a></td>
    </tr><tr><td>477</td>
    <td>Intercontinental Exchange</td>
    <td><a href="http://www.theice.com">http://www.theice.com</a></td>
    </tr><tr><td>478</td>
    <td>Ingredion</td>
    <td><a href="http://www.ingredion.com">http://www.ingredion.com</a></td>
    </tr><tr><td>479</td>
    <td>Wyndham Destinations</td>
    <td><a href="http://www.wyndhamdestinations.com">http://www.wyndhamdestinations.com</a></td>
    </tr><tr><td>480</td>
    <td>Toll Brothers</td>
    <td><a href="http://www.tollbrothers.com">http://www.tollbrothers.com</a></td>
    </tr><tr><td>481</td>
    <td>Seaboard</td>
    <td><a href="http://www.seaboardcorp.com">http://www.seaboardcorp.com</a></td>
    </tr><tr><td>482</td>
    <td>Booz Allen Hamilton</td>
    <td><a href="http://www.boozallen.com">http://www.boozallen.com</a></td>
    </tr><tr><td>483</td>
    <td>First American Financial</td>
    <td><a href="http://www.firstam.com">http://www.firstam.com</a></td>
    </tr><tr><td>484</td>
    <td>Cincinnati Financial</td>
    <td><a href="http://www.cinfin.com">http://www.cinfin.com</a></td>
    </tr><tr><td>485</td>
    <td>Avon Products</td>
    <td><a href="http://www.avoninvestor.com">http://www.avoninvestor.com</a></td>
    </tr><tr><td>486</td>
    <td>Northern Trust</td>
    <td><a href="http://www.northerntrust.com">http://www.northerntrust.com</a></td>
    </tr><tr><td>487</td>
    <td>Fiserv</td>
    <td><a href="http://www.fiserv.com">http://www.fiserv.com</a></td>
    </tr><tr><td>488</td>
    <td>Harley-Davidson</td>
    <td><a href="http://www.harley-davidson.com">http://www.harley-davidson.com</a></td>
    </tr><tr><td>489</td>
    <td>Cheniere Energy</td>
    <td><a href="http://www.cheniere.com">http://www.cheniere.com</a></td>
    </tr><tr><td>490</td>
    <td>Patterson</td>
    <td><a href="http://www.pattersoncompanies.com">http://www.pattersoncompanies.com</a></td>
    </tr><tr><td>491</td>
    <td>Peabody Energy</td>
    <td><a href="http://www.peabodyenergy.com">http://www.peabodyenergy.com</a></td>
    </tr><tr><td>492</td>
    <td>ON Semiconductor</td>
    <td><a href="http://www.onsemi.com">http://www.onsemi.com</a></td>
    </tr><tr><td>493</td>
    <td>Simon Property Group</td>
    <td><a href="http://www.simon.com">http://www.simon.com</a></td>
    </tr><tr><td>494</td>
    <td>Western Union</td>
    <td><a href="http://www.westernunion.com">http://www.westernunion.com</a></td>
    </tr><tr><td>495</td>
    <td>NetApp</td>
    <td><a href="http://www.netapp.com">http://www.netapp.com</a></td>
    </tr><tr><td>496</td>
    <td>Polaris Industries</td>
    <td><a href="http://www.polaris.com">http://www.polaris.com</a></td>
    </tr><tr><td>497</td>
    <td>Pioneer Natural Resources</td>
    <td><a href="http://www.pxd.com">http://www.pxd.com</a></td>
    </tr><tr><td>498</td>
    <td>ABM Industries</td>
    <td><a href="http://www.abm.com">http://www.abm.com</a></td>
    </tr><tr><td>499</td>
    <td>Vistra Energy</td>
    <td><a href="http://www.vistraenergy.com">http://www.vistraenergy.com</a></td>
    </tr><tr><td>500</td>
    <td>Cintas</td>
    <td><a href="http://www.cintas.com">http://www.cintas.com</a></td>
    </tr></tbody></table>



It can be seen that relevant block of data has been extracted but further extracted needs to be done to individually extract the rank, company name and the company website data. On further analysis, it can be seen that every row of data is enclosed under a 'tr' HTML tag which means 'table row'. All these row values can be extracted into a list of values by finding the 'tr' values from our newly created soup object 'data_table'


```python
all_values = data_table.find_all('tr')
all_values
```




    [<tr><th>Rank</th>
     <th>Company</th>
     <th>Website</th>
     </tr>, <tr><td>1</td>
     <td>Walmart</td>
     <td><a href="http://www.stock.walmart.com">http://www.stock.walmart.com</a></td>
     </tr>, <tr><td>2</td>
     <td>Exxon Mobil</td>
     <td><a href="http://www.exxonmobil.com">http://www.exxonmobil.com</a></td>
     </tr>, <tr><td>3</td>
     <td>Berkshire Hathaway</td>
     <td><a href="http://www.berkshirehathaway.com">http://www.berkshirehathaway.com</a></td>
     </tr>, <tr><td>4</td>
     <td>Apple</td>
     <td><a href="http://www.apple.com">http://www.apple.com</a></td>
     </tr>, <tr><td>5</td>
     <td>UnitedHealth Group</td>
     <td><a href="http://www.unitedhealthgroup.com">http://www.unitedhealthgroup.com</a></td>
     </tr>, <tr><td>6</td>
     <td>McKesson</td>
     <td><a href="http://www.mckesson.com">http://www.mckesson.com</a></td>
     </tr>, <tr><td>7</td>
     <td>CVS Health</td>
     <td><a href="http://www.cvshealth.com">http://www.cvshealth.com</a></td>
     </tr>, <tr><td>8</td>
     <td>Amazon.com</td>
     <td><a href="http://www.amazon.com">http://www.amazon.com</a></td>
     </tr>, <tr><td>9</td>
     <td>AT&amp;T</td>
     <td><a href="http://www.att.com">http://www.att.com</a></td>
     </tr>, <tr><td>10</td>
     <td>General Motors</td>
     <td><a href="http://www.gm.com">http://www.gm.com</a></td>
     </tr>, <tr><td>11</td>
     <td>Ford Motor</td>
     <td><a href="http://www.corporate.ford.com">http://www.corporate.ford.com</a></td>
     </tr>, <tr><td>12</td>
     <td>AmerisourceBergen</td>
     <td><a href="http://www.amerisourcebergen.com">http://www.amerisourcebergen.com</a></td>
     </tr>, <tr><td>13</td>
     <td>Chevron</td>
     <td><a href="http://www.chevron.com">http://www.chevron.com</a></td>
     </tr>, <tr><td>14</td>
     <td>Cardinal Health</td>
     <td><a href="http://www.cardinalhealth.com">http://www.cardinalhealth.com</a></td>
     </tr>, <tr><td>15</td>
     <td>Costco</td>
     <td><a href="http://www.costco.com">http://www.costco.com</a></td>
     </tr>, <tr><td>16</td>
     <td>Verizon</td>
     <td><a href="http://www.verizon.com">http://www.verizon.com</a></td>
     </tr>, <tr><td>17</td>
     <td>Kroger</td>
     <td><a href="http://www.thekrogerco.com">http://www.thekrogerco.com</a></td>
     </tr>, <tr><td>18</td>
     <td>General Electric</td>
     <td><a href="http://www.ge.com">http://www.ge.com</a></td>
     </tr>, <tr><td>19</td>
     <td>Walgreens Boots Alliance</td>
     <td><a href="http://www.walgreensbootsalliance.com">http://www.walgreensbootsalliance.com</a></td>
     </tr>, <tr><td>20</td>
     <td>JPMorgan Chase</td>
     <td><a href="http://www.jpmorganchase.com">http://www.jpmorganchase.com</a></td>
     </tr>, <tr><td>21</td>
     <td>Fannie Mae</td>
     <td><a href="http://www.fanniemae.com">http://www.fanniemae.com</a></td>
     </tr>, <tr><td>22</td>
     <td>Alphabet</td>
     <td><a href="http://www.abc.xyz">http://www.abc.xyz</a></td>
     </tr>, <tr><td>23</td>
     <td>Home Depot</td>
     <td><a href="http://www.homedepot.com">http://www.homedepot.com</a></td>
     </tr>, <tr><td>24</td>
     <td>Bank of America Corp.</td>
     <td><a href="http://www.bankofamerica.com">http://www.bankofamerica.com</a></td>
     </tr>, <tr><td>25</td>
     <td>Express Scripts Holding</td>
     <td><a href="http://www.express-scripts.com">http://www.express-scripts.com</a></td>
     </tr>, <tr><td>26</td>
     <td>Wells Fargo</td>
     <td><a href="http://www.wellsfargo.com">http://www.wellsfargo.com</a></td>
     </tr>, <tr><td>27</td>
     <td>Boeing</td>
     <td><a href="http://www.boeing.com">http://www.boeing.com</a></td>
     </tr>, <tr><td>28</td>
     <td>Phillips</td>
     <td><a href="http://www.phillips66.com">http://www.phillips66.com</a></td>
     </tr>, <tr><td>29</td>
     <td>Anthem</td>
     <td><a href="http://www.antheminc.com">http://www.antheminc.com</a></td>
     </tr>, <tr><td>30</td>
     <td>Microsoft</td>
     <td><a href="http://www.microsoft.com">http://www.microsoft.com</a></td>
     </tr>, <tr><td>31</td>
     <td>Valero Energy</td>
     <td><a href="http://www.valero.com">http://www.valero.com</a></td>
     </tr>, <tr><td>32</td>
     <td>Citigroup</td>
     <td><a href="http://www.citigroup.com">http://www.citigroup.com</a></td>
     </tr>, <tr><td>33</td>
     <td>Comcast</td>
     <td><a href="http://www.comcastcorporation.com">http://www.comcastcorporation.com</a></td>
     </tr>, <tr><td>34</td>
     <td>IBM</td>
     <td><a href="http://www.ibm.com">http://www.ibm.com</a></td>
     </tr>, <tr><td>35</td>
     <td>Dell Technologies</td>
     <td><a href="http://www.delltechnologies.com">http://www.delltechnologies.com</a></td>
     </tr>, <tr><td>36</td>
     <td>State Farm Insurance Cos.</td>
     <td><a href="http://www.statefarm.com">http://www.statefarm.com</a></td>
     </tr>, <tr><td>37</td>
     <td>Johnson &amp; Johnson</td>
     <td><a href="http://www.jnj.com">http://www.jnj.com</a></td>
     </tr>, <tr><td>38</td>
     <td>Freddie Mac</td>
     <td><a href="http://www.freddiemac.com">http://www.freddiemac.com</a></td>
     </tr>, <tr><td>39</td>
     <td>Target</td>
     <td><a href="http://www.target.com">http://www.target.com</a></td>
     </tr>, <tr><td>40</td>
     <td>Lowe’s</td>
     <td><a href="http://www.lowes.com">http://www.lowes.com</a></td>
     </tr>, <tr><td>41</td>
     <td>Marathon Petroleum</td>
     <td><a href="http://www.marathonpetroleum.com">http://www.marathonpetroleum.com</a></td>
     </tr>, <tr><td>42</td>
     <td>Procter &amp; Gamble</td>
     <td><a href="http://www.pg.com">http://www.pg.com</a></td>
     </tr>, <tr><td>43</td>
     <td>MetLife</td>
     <td><a href="http://www.metlife.com">http://www.metlife.com</a></td>
     </tr>, <tr><td>44</td>
     <td>UPS</td>
     <td><a href="http://www.ups.com">http://www.ups.com</a></td>
     </tr>, <tr><td>45</td>
     <td>PepsiCo</td>
     <td><a href="http://www.pepsico.com">http://www.pepsico.com</a></td>
     </tr>, <tr><td>46</td>
     <td>Intel</td>
     <td><a href="http://www.intel.com">http://www.intel.com</a></td>
     </tr>, <tr><td>47</td>
     <td>DowDuPont</td>
     <td><a href="www.dow-dupont.com">www.dow-dupont.com</a></td>
     </tr>, <tr><td>48</td>
     <td>Archer Daniels Midland</td>
     <td><a href="http://www.adm.com">http://www.adm.com</a></td>
     </tr>, <tr><td>49</td>
     <td>Aetna</td>
     <td><a href="http://www.aetna.com">http://www.aetna.com</a></td>
     </tr>, <tr><td>50</td>
     <td>FedEx</td>
     <td><a href="http://www.fedex.com">http://www.fedex.com</a></td>
     </tr>, <tr><td>51</td>
     <td>United Technologies</td>
     <td><a href="http://www.utc.com">http://www.utc.com</a></td>
     </tr>, <tr><td>52</td>
     <td>Prudential Financial</td>
     <td><a href="http://www.prudential.com">http://www.prudential.com</a></td>
     </tr>, <tr><td>53</td>
     <td>Albertsons Cos.</td>
     <td><a href="http://www.albertsons.com">http://www.albertsons.com</a></td>
     </tr>, <tr><td>54</td>
     <td>Sysco</td>
     <td><a href="http://www.sysco.com">http://www.sysco.com</a></td>
     </tr>, <tr><td>55</td>
     <td>Disney</td>
     <td><a href="http://www.disney.com">http://www.disney.com</a></td>
     </tr>, <tr><td>56</td>
     <td>Humana</td>
     <td><a href="http://www.humana.com">http://www.humana.com</a></td>
     </tr>, <tr><td>57</td>
     <td>Pfizer</td>
     <td><a href="http://www.pfizer.com">http://www.pfizer.com</a></td>
     </tr>, <tr><td>58</td>
     <td>HP</td>
     <td><a href="http://www.hp.com">http://www.hp.com</a></td>
     </tr>, <tr><td>59</td>
     <td>Lockheed Martin</td>
     <td><a href="http://www.lockheedmartin.com">http://www.lockheedmartin.com</a></td>
     </tr>, <tr><td>60</td>
     <td>AIG</td>
     <td><a href="http://www.aig.com">http://www.aig.com</a></td>
     </tr>, <tr><td>61</td>
     <td>Centene</td>
     <td><a href="http://www.centene.com">http://www.centene.com</a></td>
     </tr>, <tr><td>62</td>
     <td>Cisco Systems</td>
     <td><a href="http://www.cisco.com">http://www.cisco.com</a></td>
     </tr>, <tr><td>63</td>
     <td>HCA Healthcare</td>
     <td><a href="www.hcahealthcare.com">www.hcahealthcare.com</a></td>
     </tr>, <tr><td>64</td>
     <td>Energy Transfer Equity</td>
     <td><a href="http://www.energytransfer.com">http://www.energytransfer.com</a></td>
     </tr>, <tr><td>65</td>
     <td>Caterpillar</td>
     <td><a href="http://www.caterpillar.com">http://www.caterpillar.com</a></td>
     </tr>, <tr><td>66</td>
     <td>Nationwide</td>
     <td><a href="http://www.nationwide.com">http://www.nationwide.com</a></td>
     </tr>, <tr><td>67</td>
     <td>Morgan Stanley</td>
     <td><a href="http://www.morganstanley.com">http://www.morganstanley.com</a></td>
     </tr>, <tr><td>68</td>
     <td>Liberty Mutual Insurance Group</td>
     <td><a href="http://www.libertymutual.com">http://www.libertymutual.com</a></td>
     </tr>, <tr><td>69</td>
     <td>New York Life Insurance</td>
     <td><a href="http://www.newyorklife.com">http://www.newyorklife.com</a></td>
     </tr>, <tr><td>70</td>
     <td>Goldman Sachs Group</td>
     <td><a href="http://www.gs.com">http://www.gs.com</a></td>
     </tr>, <tr><td>71</td>
     <td>American Airlines Group</td>
     <td><a href="http://www.aa.com">http://www.aa.com</a></td>
     </tr>, <tr><td>72</td>
     <td>Best Buy</td>
     <td><a href="http://www.bestbuy.com">http://www.bestbuy.com</a></td>
     </tr>, <tr><td>73</td>
     <td>Cigna</td>
     <td><a href="http://www.cigna.com">http://www.cigna.com</a></td>
     </tr>, <tr><td>74</td>
     <td>Charter Communications</td>
     <td><a href="http://www.charter.com">http://www.charter.com</a></td>
     </tr>, <tr><td>75</td>
     <td>Delta Air Lines</td>
     <td><a href="http://www.delta.com">http://www.delta.com</a></td>
     </tr>, <tr><td>76</td>
     <td>Facebook</td>
     <td><a href="http://www.facebook.com">http://www.facebook.com</a></td>
     </tr>, <tr><td>77</td>
     <td>Honeywell International</td>
     <td><a href="http://www.honeywell.com">http://www.honeywell.com</a></td>
     </tr>, <tr><td>78</td>
     <td>Merck</td>
     <td><a href="http://www.merck.com">http://www.merck.com</a></td>
     </tr>, <tr><td>79</td>
     <td>Allstate</td>
     <td><a href="http://www.allstate.com">http://www.allstate.com</a></td>
     </tr>, <tr><td>80</td>
     <td>Tyson Foods</td>
     <td><a href="http://www.tysonfoods.com">http://www.tysonfoods.com</a></td>
     </tr>, <tr><td>81</td>
     <td>United Continental Holdings</td>
     <td><a href="http://www.united.com">http://www.united.com</a></td>
     </tr>, <tr><td>82</td>
     <td>Oracle</td>
     <td><a href="http://www.oracle.com">http://www.oracle.com</a></td>
     </tr>, <tr><td>83</td>
     <td>Tech Data</td>
     <td><a href="http://www.techdata.com">http://www.techdata.com</a></td>
     </tr>, <tr><td>84</td>
     <td>TIAA</td>
     <td><a href="http://www.tiaa.org">http://www.tiaa.org</a></td>
     </tr>, <tr><td>85</td>
     <td>TJX</td>
     <td><a href="http://www.tjx.com">http://www.tjx.com</a></td>
     </tr>, <tr><td>86</td>
     <td>American Express</td>
     <td><a href="http://www.americanexpress.com">http://www.americanexpress.com</a></td>
     </tr>, <tr><td>87</td>
     <td>Coca-Cola</td>
     <td><a href="http://www.coca-colacompany.com">http://www.coca-colacompany.com</a></td>
     </tr>, <tr><td>88</td>
     <td>Publix Super Markets</td>
     <td><a href="http://www.publix.com">http://www.publix.com</a></td>
     </tr>, <tr><td>89</td>
     <td>Nike</td>
     <td><a href="http://www.nike.com">http://www.nike.com</a></td>
     </tr>, <tr><td>90</td>
     <td>Andeavor</td>
     <td><a href="www.andeavor.com">www.andeavor.com</a></td>
     </tr>, <tr><td>91</td>
     <td>World Fuel Services</td>
     <td><a href="http://www.wfscorp.com">http://www.wfscorp.com</a></td>
     </tr>, <tr><td>92</td>
     <td>Exelon</td>
     <td><a href="http://www.exeloncorp.com">http://www.exeloncorp.com</a></td>
     </tr>, <tr><td>93</td>
     <td>Massachusetts Mutual Life Insurance</td>
     <td><a href="http://www.massmutual.com">http://www.massmutual.com</a></td>
     </tr>, <tr><td>94</td>
     <td>Rite Aid</td>
     <td><a href="http://www.riteaid.com">http://www.riteaid.com</a></td>
     </tr>, <tr><td>95</td>
     <td>ConocoPhillips</td>
     <td><a href="http://www.conocophillips.com">http://www.conocophillips.com</a></td>
     </tr>, <tr><td>96</td>
     <td>CHS</td>
     <td><a href="http://www.chsinc.com">http://www.chsinc.com</a></td>
     </tr>, <tr><td>97</td>
     <td>M</td>
     <td><a href="http://www.3m.com">http://www.3m.com</a></td>
     </tr>, <tr><td>98</td>
     <td>Time Warner</td>
     <td><a href="http://www.timewarner.com">http://www.timewarner.com</a></td>
     </tr>, <tr><td>99</td>
     <td>General Dynamics</td>
     <td><a href="http://www.generaldynamics.com">http://www.generaldynamics.com</a></td>
     </tr>, <tr><td>100</td>
     <td>USAA</td>
     <td><a href="http://www.usaa.com">http://www.usaa.com</a></td>
     </tr>, <tr><td>101</td>
     <td>Capital One Financial</td>
     <td><a href="http://www.capitalone.com">http://www.capitalone.com</a></td>
     </tr>, <tr><td>102</td>
     <td>Deere</td>
     <td><a href="http://www.johndeere.com">http://www.johndeere.com</a></td>
     </tr>, <tr><td>103</td>
     <td>INTL FCStone</td>
     <td><a href="http://www.intlfcstone.com">http://www.intlfcstone.com</a></td>
     </tr>, <tr><td>104</td>
     <td>Northwestern Mutual</td>
     <td><a href="http://www.northwesternmutual.com">http://www.northwesternmutual.com</a></td>
     </tr>, <tr><td>105</td>
     <td>Enterprise Products Partners</td>
     <td><a href="http://www.enterpriseproducts.com">http://www.enterpriseproducts.com</a></td>
     </tr>, <tr><td>106</td>
     <td>Travelers Cos.</td>
     <td><a href="http://www.travelers.com">http://www.travelers.com</a></td>
     </tr>, <tr><td>107</td>
     <td>Hewlett Packard Enterprise</td>
     <td><a href="http://www.hpe.com">http://www.hpe.com</a></td>
     </tr>, <tr><td>108</td>
     <td>Philip Morris International</td>
     <td><a href="http://www.pmi.com">http://www.pmi.com</a></td>
     </tr>, <tr><td>109</td>
     <td>Twenty-First Century Fox</td>
     <td><a href="http://www.21cf.com">http://www.21cf.com</a></td>
     </tr>, <tr><td>110</td>
     <td>AbbVie</td>
     <td><a href="http://www.abbvie.com">http://www.abbvie.com</a></td>
     </tr>, <tr><td>111</td>
     <td>Abbott Laboratories</td>
     <td><a href="http://www.abbott.com">http://www.abbott.com</a></td>
     </tr>, <tr><td>112</td>
     <td>Progressive</td>
     <td><a href="http://www.progressive.com">http://www.progressive.com</a></td>
     </tr>, <tr><td>113</td>
     <td>Arrow Electronics</td>
     <td><a href="http://www.arrow.com">http://www.arrow.com</a></td>
     </tr>, <tr><td>114</td>
     <td>Kraft Heinz</td>
     <td><a href="http://www.kraftheinzcompany.com">http://www.kraftheinzcompany.com</a></td>
     </tr>, <tr><td>115</td>
     <td>Plains GP Holdings</td>
     <td><a href="http://www.plainsallamerican.com">http://www.plainsallamerican.com</a></td>
     </tr>, <tr><td>116</td>
     <td>Gilead Sciences</td>
     <td><a href="http://www.gilead.com">http://www.gilead.com</a></td>
     </tr>, <tr><td>117</td>
     <td>Mondelez International</td>
     <td><a href="http://www.mondelezinternational.com">http://www.mondelezinternational.com</a></td>
     </tr>, <tr><td>118</td>
     <td>Northrop Grumman</td>
     <td><a href="http://www.northropgrumman.com">http://www.northropgrumman.com</a></td>
     </tr>, <tr><td>119</td>
     <td>Raytheon</td>
     <td><a href="http://www.raytheon.com">http://www.raytheon.com</a></td>
     </tr>, <tr><td>120</td>
     <td>Macy’s</td>
     <td><a href="http://www.macysinc.com">http://www.macysinc.com</a></td>
     </tr>, <tr><td>121</td>
     <td>US Foods Holding</td>
     <td><a href="http://www.usfoods.com">http://www.usfoods.com</a></td>
     </tr>, <tr><td>122</td>
     <td>U.S. Bancorp</td>
     <td><a href="http://www.usbank.com">http://www.usbank.com</a></td>
     </tr>, <tr><td>123</td>
     <td>Dollar General</td>
     <td><a href="http://www.dollargeneral.com">http://www.dollargeneral.com</a></td>
     </tr>, <tr><td>124</td>
     <td>International Paper</td>
     <td><a href="http://www.internationalpaper.com">http://www.internationalpaper.com</a></td>
     </tr>, <tr><td>125</td>
     <td>Duke Energy</td>
     <td><a href="http://www.duke-energy.com">http://www.duke-energy.com</a></td>
     </tr>, <tr><td>126</td>
     <td>Southern</td>
     <td><a href="http://www.southerncompany.com">http://www.southerncompany.com</a></td>
     </tr>, <tr><td>127</td>
     <td>Marriott International</td>
     <td><a href="http://www.marriott.com">http://www.marriott.com</a></td>
     </tr>, <tr><td>128</td>
     <td>Avnet</td>
     <td><a href="http://www.avnet.com">http://www.avnet.com</a></td>
     </tr>, <tr><td>129</td>
     <td>Eli Lilly</td>
     <td><a href="http://www.lilly.com">http://www.lilly.com</a></td>
     </tr>, <tr><td>130</td>
     <td>Amgen</td>
     <td><a href="http://www.amgen.com">http://www.amgen.com</a></td>
     </tr>, <tr><td>131</td>
     <td>McDonald’s</td>
     <td><a href="http://www.aboutmcdonalds.com">http://www.aboutmcdonalds.com</a></td>
     </tr>, <tr><td>132</td>
     <td>Starbucks</td>
     <td><a href="http://www.starbucks.com">http://www.starbucks.com</a></td>
     </tr>, <tr><td>133</td>
     <td>Qualcomm</td>
     <td><a href="http://www.qualcomm.com">http://www.qualcomm.com</a></td>
     </tr>, <tr><td>134</td>
     <td>Dollar Tree</td>
     <td><a href="http://www.dollartree.com">http://www.dollartree.com</a></td>
     </tr>, <tr><td>135</td>
     <td>PBF Energy</td>
     <td><a href="http://www.pbfenergy.com">http://www.pbfenergy.com</a></td>
     </tr>, <tr><td>136</td>
     <td>Icahn Enterprises</td>
     <td><a href="http://www.ielp.com">http://www.ielp.com</a></td>
     </tr>, <tr><td>137</td>
     <td>Aflac</td>
     <td><a href="http://www.aflac.com">http://www.aflac.com</a></td>
     </tr>, <tr><td>138</td>
     <td>AutoNation</td>
     <td><a href="http://www.autonation.com">http://www.autonation.com</a></td>
     </tr>, <tr><td>139</td>
     <td>Penske Automotive Group</td>
     <td><a href="http://www.penskeautomotive.com">http://www.penskeautomotive.com</a></td>
     </tr>, <tr><td>140</td>
     <td>Whirlpool</td>
     <td><a href="http://www.whirlpoolcorp.com">http://www.whirlpoolcorp.com</a></td>
     </tr>, <tr><td>141</td>
     <td>Union Pacific</td>
     <td><a href="http://www.up.com">http://www.up.com</a></td>
     </tr>, <tr><td>142</td>
     <td>Southwest Airlines</td>
     <td><a href="http://www.southwest.com">http://www.southwest.com</a></td>
     </tr>, <tr><td>143</td>
     <td>ManpowerGroup</td>
     <td><a href="http://www.manpowergroup.com">http://www.manpowergroup.com</a></td>
     </tr>, <tr><td>144</td>
     <td>Thermo Fisher Scientific</td>
     <td><a href="http://www.thermofisher.com">http://www.thermofisher.com</a></td>
     </tr>, <tr><td>145</td>
     <td>Bristol-Myers Squibb</td>
     <td><a href="http://www.bms.com">http://www.bms.com</a></td>
     </tr>, <tr><td>146</td>
     <td>Halliburton</td>
     <td><a href="http://www.halliburton.com">http://www.halliburton.com</a></td>
     </tr>, <tr><td>147</td>
     <td>Tenet Healthcare</td>
     <td><a href="http://www.tenethealth.com">http://www.tenethealth.com</a></td>
     </tr>, <tr><td>148</td>
     <td>Lear</td>
     <td><a href="http://www.lear.com">http://www.lear.com</a></td>
     </tr>, <tr><td>149</td>
     <td>Cummins</td>
     <td><a href="http://www.cummins.com">http://www.cummins.com</a></td>
     </tr>, <tr><td>150</td>
     <td>Micron Technology</td>
     <td><a href="http://www.micron.com">http://www.micron.com</a></td>
     </tr>, <tr><td>151</td>
     <td>Nucor</td>
     <td><a href="http://www.nucor.com">http://www.nucor.com</a></td>
     </tr>, <tr><td>152</td>
     <td>Molina Healthcare</td>
     <td><a href="http://www.molinahealthcare.com">http://www.molinahealthcare.com</a></td>
     </tr>, <tr><td>153</td>
     <td>Fluor</td>
     <td><a href="http://www.fluor.com">http://www.fluor.com</a></td>
     </tr>, <tr><td>154</td>
     <td>Altria Group</td>
     <td><a href="http://www.altria.com">http://www.altria.com</a></td>
     </tr>, <tr><td>155</td>
     <td>Paccar</td>
     <td><a href="http://www.paccar.com">http://www.paccar.com</a></td>
     </tr>, <tr><td>156</td>
     <td>Hartford Financial Services</td>
     <td><a href="http://www.thehartford.com">http://www.thehartford.com</a></td>
     </tr>, <tr><td>157</td>
     <td>Kohl’s</td>
     <td><a href="http://www.kohls.com">http://www.kohls.com</a></td>
     </tr>, <tr><td>158</td>
     <td>Western Digital</td>
     <td><a href="http://www.wdc.com">http://www.wdc.com</a></td>
     </tr>, <tr><td>159</td>
     <td>Jabil</td>
     <td><a href="www.jabil.com">www.jabil.com</a></td>
     </tr>, <tr><td>160</td>
     <td>Community Health Systems</td>
     <td><a href="http://www.chs.net">http://www.chs.net</a></td>
     </tr>, <tr><td>161</td>
     <td>Visa</td>
     <td><a href="http://www.visa.com">http://www.visa.com</a></td>
     </tr>, <tr><td>162</td>
     <td>Danaher</td>
     <td><a href="http://www.danaher.com">http://www.danaher.com</a></td>
     </tr>, <tr><td>163</td>
     <td>Kimberly-Clark</td>
     <td><a href="http://www.kimberly-clark.com">http://www.kimberly-clark.com</a></td>
     </tr>, <tr><td>164</td>
     <td>AECOM</td>
     <td><a href="http://www.aecom.com">http://www.aecom.com</a></td>
     </tr>, <tr><td>165</td>
     <td>PNC Financial Services</td>
     <td><a href="http://www.pnc.com">http://www.pnc.com</a></td>
     </tr>, <tr><td>166</td>
     <td>CenturyLink</td>
     <td><a href="http://www.centurylink.com">http://www.centurylink.com</a></td>
     </tr>, <tr><td>167</td>
     <td>NextEra Energy</td>
     <td><a href="http://www.nexteraenergy.com">http://www.nexteraenergy.com</a></td>
     </tr>, <tr><td>168</td>
     <td>PG&amp;E Corp.</td>
     <td><a href="http://www.pgecorp.com">http://www.pgecorp.com</a></td>
     </tr>, <tr><td>169</td>
     <td>Synnex</td>
     <td><a href="http://www.synnex.com">http://www.synnex.com</a></td>
     </tr>, <tr><td>170</td>
     <td>WellCare Health Plans</td>
     <td><a href="http://www.wellcare.com">http://www.wellcare.com</a></td>
     </tr>, <tr><td>171</td>
     <td>Performance Food Group</td>
     <td><a href="http://www.pfgc.com">http://www.pfgc.com</a></td>
     </tr>, <tr><td>172</td>
     <td>Sears Holdings</td>
     <td><a href="http://www.searsholdings.com">http://www.searsholdings.com</a></td>
     </tr>, <tr><td>173</td>
     <td>Synchrony Financial</td>
     <td><a href="http://www.synchronyfinancial.com">http://www.synchronyfinancial.com</a></td>
     </tr>, <tr><td>174</td>
     <td>CarMax</td>
     <td><a href="http://www.carmax.com">http://www.carmax.com</a></td>
     </tr>, <tr><td>175</td>
     <td>Bank of New York Mellon</td>
     <td><a href="www.bnymellon.com">www.bnymellon.com</a></td>
     </tr>, <tr><td>176</td>
     <td>Freeport-McMoRan</td>
     <td><a href="http://www.fcx.com">http://www.fcx.com</a></td>
     </tr>, <tr><td>177</td>
     <td>Genuine Parts</td>
     <td><a href="http://www.genpt.com">http://www.genpt.com</a></td>
     </tr>, <tr><td>178</td>
     <td>Emerson Electric</td>
     <td><a href="http://www.emerson.com">http://www.emerson.com</a></td>
     </tr>, <tr><td>179</td>
     <td>DaVita</td>
     <td><a href="http://www.davita.com">http://www.davita.com</a></td>
     </tr>, <tr><td>180</td>
     <td>Supervalu</td>
     <td><a href="http://www.supervalu.com">http://www.supervalu.com</a></td>
     </tr>, <tr><td>181</td>
     <td>Gap</td>
     <td><a href="http://www.gapinc.com">http://www.gapinc.com</a></td>
     </tr>, <tr><td>182</td>
     <td>General Mills</td>
     <td><a href="http://www.generalmills.com">http://www.generalmills.com</a></td>
     </tr>, <tr><td>183</td>
     <td>Nordstrom</td>
     <td><a href="http://www.nordstrom.com">http://www.nordstrom.com</a></td>
     </tr>, <tr><td>184</td>
     <td>Colgate-Palmolive</td>
     <td><a href="http://www.colgatepalmolive.com">http://www.colgatepalmolive.com</a></td>
     </tr>, <tr><td>185</td>
     <td>American Electric Power</td>
     <td><a href="http://www.aep.com">http://www.aep.com</a></td>
     </tr>, <tr><td>186</td>
     <td>XPO Logistics</td>
     <td><a href="http://www.xpo.com">http://www.xpo.com</a></td>
     </tr>, <tr><td>187</td>
     <td>Goodyear Tire &amp; Rubber</td>
     <td><a href="http://www.goodyear.com">http://www.goodyear.com</a></td>
     </tr>, <tr><td>188</td>
     <td>Omnicom Group</td>
     <td><a href="http://www.omnicomgroup.com">http://www.omnicomgroup.com</a></td>
     </tr>, <tr><td>189</td>
     <td>CDW</td>
     <td><a href="http://www.cdw.com">http://www.cdw.com</a></td>
     </tr>, <tr><td>190</td>
     <td>Sherwin-Williams</td>
     <td><a href="http://www.sherwin.com">http://www.sherwin.com</a></td>
     </tr>, <tr><td>191</td>
     <td>PPG Industries</td>
     <td><a href="http://www.ppg.com">http://www.ppg.com</a></td>
     </tr>, <tr><td>192</td>
     <td>Texas Instruments</td>
     <td><a href="http://www.ti.com">http://www.ti.com</a></td>
     </tr>, <tr><td>193</td>
     <td>C.H. Robinson Worldwide</td>
     <td><a href="http://www.chrobinson.com">http://www.chrobinson.com</a></td>
     </tr>, <tr><td>194</td>
     <td>WestRock</td>
     <td><a href="http://www.westrock.com">http://www.westrock.com</a></td>
     </tr>, <tr><td>195</td>
     <td>Cognizant Technology Solutions</td>
     <td><a href="http://www.cognizant.com">http://www.cognizant.com</a></td>
     </tr>, <tr><td>196</td>
     <td>Newell Brands</td>
     <td><a href="http://www.newellbrands.com">http://www.newellbrands.com</a></td>
     </tr>, <tr><td>197</td>
     <td>CBS</td>
     <td><a href="http://www.cbscorporation.com">http://www.cbscorporation.com</a></td>
     </tr>, <tr><td>198</td>
     <td>Envision Healthcare</td>
     <td><a href="http://www.evhc.net">http://www.evhc.net</a></td>
     </tr>, <tr><td>199</td>
     <td>Monsanto</td>
     <td><a href="http://www.monsanto.com">http://www.monsanto.com</a></td>
     </tr>, <tr><td>200</td>
     <td>Aramark</td>
     <td><a href="http://www.aramark.com">http://www.aramark.com</a></td>
     </tr>, <tr><td>201</td>
     <td>Applied Materials</td>
     <td><a href="http://www.appliedmaterials.com">http://www.appliedmaterials.com</a></td>
     </tr>, <tr><td>202</td>
     <td>Waste Management</td>
     <td><a href="http://www.wm.com">http://www.wm.com</a></td>
     </tr>, <tr><td>203</td>
     <td>DISH Network</td>
     <td><a href="http://www.dish.com">http://www.dish.com</a></td>
     </tr>, <tr><td>204</td>
     <td>Illinois Tool Works</td>
     <td><a href="http://www.itw.com">http://www.itw.com</a></td>
     </tr>, <tr><td>205</td>
     <td>Lincoln National</td>
     <td><a href="http://www.lfg.com">http://www.lfg.com</a></td>
     </tr>, <tr><td>206</td>
     <td>HollyFrontier</td>
     <td><a href="http://www.hollyfrontier.com">http://www.hollyfrontier.com</a></td>
     </tr>, <tr><td>207</td>
     <td>CBRE Group</td>
     <td><a href="http://www.cbre.com">http://www.cbre.com</a></td>
     </tr>, <tr><td>208</td>
     <td>Textron</td>
     <td><a href="http://www.textron.com">http://www.textron.com</a></td>
     </tr>, <tr><td>209</td>
     <td>Ross Stores</td>
     <td><a href="http://www.rossstores.com">http://www.rossstores.com</a></td>
     </tr>, <tr><td>210</td>
     <td>Principal Financial</td>
     <td><a href="http://www.principal.com">http://www.principal.com</a></td>
     </tr>, <tr><td>211</td>
     <td>D.R. Horton</td>
     <td><a href="http://www.drhorton.com">http://www.drhorton.com</a></td>
     </tr>, <tr><td>212</td>
     <td>Marsh &amp; McLennan</td>
     <td><a href="http://www.mmc.com">http://www.mmc.com</a></td>
     </tr>, <tr><td>213</td>
     <td>Devon Energy</td>
     <td><a href="http://www.devonenergy.com">http://www.devonenergy.com</a></td>
     </tr>, <tr><td>214</td>
     <td>AES</td>
     <td><a href="http://www.aes.com">http://www.aes.com</a></td>
     </tr>, <tr><td>215</td>
     <td>Ecolab</td>
     <td><a href="http://www.ecolab.com">http://www.ecolab.com</a></td>
     </tr>, <tr><td>216</td>
     <td>Land O’Lakes</td>
     <td><a href="http://www.landolakesinc.com">http://www.landolakesinc.com</a></td>
     </tr>, <tr><td>217</td>
     <td>Loews</td>
     <td><a href="http://www.loews.com">http://www.loews.com</a></td>
     </tr>, <tr><td>218</td>
     <td>Kinder Morgan</td>
     <td><a href="http://www.kindermorgan.com">http://www.kindermorgan.com</a></td>
     </tr>, <tr><td>219</td>
     <td>FirstEnergy</td>
     <td><a href="http://www.firstenergycorp.com">http://www.firstenergycorp.com</a></td>
     </tr>, <tr><td>220</td>
     <td>Occidental Petroleum</td>
     <td><a href="http://www.oxy.com">http://www.oxy.com</a></td>
     </tr>, <tr><td>221</td>
     <td>Viacom</td>
     <td><a href="http://www.viacom.com">http://www.viacom.com</a></td>
     </tr>, <tr><td>222</td>
     <td>PayPal Holdings</td>
     <td><a href="http://www.paypal.com">http://www.paypal.com</a></td>
     </tr>, <tr><td>223</td>
     <td>NGL Energy Partners</td>
     <td><a href="http://www.nglenergypartners.com">http://www.nglenergypartners.com</a></td>
     </tr>, <tr><td>224</td>
     <td>Celgene</td>
     <td><a href="http://www.celgene.com">http://www.celgene.com</a></td>
     </tr>, <tr><td>225</td>
     <td>Arconic</td>
     <td><a href="http://www.arconic.com">http://www.arconic.com</a></td>
     </tr>, <tr><td>226</td>
     <td>Kellogg</td>
     <td><a href="http://www.kelloggcompany.com">http://www.kelloggcompany.com</a></td>
     </tr>, <tr><td>227</td>
     <td>Las Vegas Sands</td>
     <td><a href="http://www.sands.com">http://www.sands.com</a></td>
     </tr>, <tr><td>228</td>
     <td>Stanley Black &amp; Decker</td>
     <td><a href="http://www.stanleyblackanddecker.com">http://www.stanleyblackanddecker.com</a></td>
     </tr>, <tr><td>229</td>
     <td>Booking Holdings</td>
     <td><a href="http://www.bookingholdings.com">http://www.bookingholdings.com</a></td>
     </tr>, <tr><td>230</td>
     <td>Lennar</td>
     <td><a href="http://www.lennar.com">http://www.lennar.com</a></td>
     </tr>, <tr><td>231</td>
     <td>L Brands</td>
     <td><a href="http://www.lb.com">http://www.lb.com</a></td>
     </tr>, <tr><td>232</td>
     <td>DTE Energy</td>
     <td><a href="http://www.dteenergy.com">http://www.dteenergy.com</a></td>
     </tr>, <tr><td>233</td>
     <td>Dominion Energy</td>
     <td><a href="www.dominionenergy.com">www.dominionenergy.com</a></td>
     </tr>, <tr><td>234</td>
     <td>Reinsurance Group of America</td>
     <td><a href="http://www.rgare.com">http://www.rgare.com</a></td>
     </tr>, <tr><td>235</td>
     <td>J.C. Penney</td>
     <td><a href="http://www.jcpenney.com">http://www.jcpenney.com</a></td>
     </tr>, <tr><td>236</td>
     <td>Mastercard</td>
     <td><a href="http://www.mastercard.com">http://www.mastercard.com</a></td>
     </tr>, <tr><td>237</td>
     <td>BlackRock</td>
     <td><a href="http://www.blackrock.com">http://www.blackrock.com</a></td>
     </tr>, <tr><td>238</td>
     <td>Henry Schein</td>
     <td><a href="http://www.henryschein.com">http://www.henryschein.com</a></td>
     </tr>, <tr><td>239</td>
     <td>Guardian Life Ins. Co. of America</td>
     <td><a href="http://www.guardianlife.com">http://www.guardianlife.com</a></td>
     </tr>, <tr><td>240</td>
     <td>Stryker</td>
     <td><a href="http://www.stryker.com">http://www.stryker.com</a></td>
     </tr>, <tr><td>241</td>
     <td>Jefferies Financial Group</td>
     <td><a href="http://www.jefferies.com">http://www.jefferies.com</a></td>
     </tr>, <tr><td>242</td>
     <td>VF</td>
     <td><a href="http://www.vfc.com">http://www.vfc.com</a></td>
     </tr>, <tr><td>243</td>
     <td>ADP</td>
     <td><a href="http://www.adp.com">http://www.adp.com</a></td>
     </tr>, <tr><td>244</td>
     <td>Edison International</td>
     <td><a href="http://www.edisoninvestor.com">http://www.edisoninvestor.com</a></td>
     </tr>, <tr><td>245</td>
     <td>Biogen</td>
     <td><a href="http://www.biogen.com">http://www.biogen.com</a></td>
     </tr>, <tr><td>246</td>
     <td>United States Steel</td>
     <td><a href="http://www.ussteel.com">http://www.ussteel.com</a></td>
     </tr>, <tr><td>247</td>
     <td>Core-Mark Holding</td>
     <td><a href="http://www.core-mark.com">http://www.core-mark.com</a></td>
     </tr>, <tr><td>248</td>
     <td>Bed Bath &amp; Beyond</td>
     <td><a href="http://www.bedbathandbeyond.com">http://www.bedbathandbeyond.com</a></td>
     </tr>, <tr><td>249</td>
     <td>Oneok</td>
     <td><a href="http://www.oneok.com">http://www.oneok.com</a></td>
     </tr>, <tr><td>250</td>
     <td>BB&amp;T Corp.</td>
     <td><a href="http://www.bbt.com">http://www.bbt.com</a></td>
     </tr>, <tr><td>251</td>
     <td>Becton Dickinson</td>
     <td><a href="http://www.bd.com">http://www.bd.com</a></td>
     </tr>, <tr><td>252</td>
     <td>Ameriprise Financial</td>
     <td><a href="http://www.ameriprise.com">http://www.ameriprise.com</a></td>
     </tr>, <tr><td>253</td>
     <td>Farmers Insurance Exchange</td>
     <td><a href="http://www.farmers.com">http://www.farmers.com</a></td>
     </tr>, <tr><td>254</td>
     <td>First Data</td>
     <td><a href="http://www.firstdata.com">http://www.firstdata.com</a></td>
     </tr>, <tr><td>255</td>
     <td>Consolidated Edison</td>
     <td><a href="http://www.conedison.com">http://www.conedison.com</a></td>
     </tr>, <tr><td>256</td>
     <td>Parker-Hannifin</td>
     <td><a href="http://www.parker.com">http://www.parker.com</a></td>
     </tr>, <tr><td>257</td>
     <td>Anadarko Petroleum</td>
     <td><a href="http://www.anadarko.com">http://www.anadarko.com</a></td>
     </tr>, <tr><td>258</td>
     <td>Estee Lauder</td>
     <td><a href="http://www.elcompanies.com">http://www.elcompanies.com</a></td>
     </tr>, <tr><td>259</td>
     <td>State Street Corp.</td>
     <td><a href="http://www.statestreet.com">http://www.statestreet.com</a></td>
     </tr>, <tr><td>260</td>
     <td>Tesla</td>
     <td><a href="http://www.tesla.com">http://www.tesla.com</a></td>
     </tr>, <tr><td>261</td>
     <td>Netflix</td>
     <td><a href="http://www.netflix.com">http://www.netflix.com</a></td>
     </tr>, <tr><td>262</td>
     <td>Alcoa</td>
     <td><a href="http://www.alcoa.com">http://www.alcoa.com</a></td>
     </tr>, <tr><td>263</td>
     <td>Discover Financial Services</td>
     <td><a href="http://www.discover.com">http://www.discover.com</a></td>
     </tr>, <tr><td>264</td>
     <td>Praxair</td>
     <td><a href="http://www.praxair.com">http://www.praxair.com</a></td>
     </tr>, <tr><td>265</td>
     <td>CSX</td>
     <td><a href="http://www.csx.com">http://www.csx.com</a></td>
     </tr>, <tr><td>266</td>
     <td>Xcel Energy</td>
     <td><a href="http://www.xcelenergy.com">http://www.xcelenergy.com</a></td>
     </tr>, <tr><td>267</td>
     <td>Unum Group</td>
     <td><a href="http://www.unum.com">http://www.unum.com</a></td>
     </tr>, <tr><td>268</td>
     <td>Universal Health Services</td>
     <td><a href="http://www.uhsinc.com">http://www.uhsinc.com</a></td>
     </tr>, <tr><td>269</td>
     <td>NRG Energy</td>
     <td><a href="http://www.nrg.com">http://www.nrg.com</a></td>
     </tr>, <tr><td>270</td>
     <td>EOG Resources</td>
     <td><a href="http://www.eogresources.com">http://www.eogresources.com</a></td>
     </tr>, <tr><td>271</td>
     <td>Sempra Energy</td>
     <td><a href="http://www.sempra.com">http://www.sempra.com</a></td>
     </tr>, <tr><td>272</td>
     <td>Toys “R” Us</td>
     <td><a href="http://www.toysrusinc.com">http://www.toysrusinc.com</a></td>
     </tr>, <tr><td>273</td>
     <td>Group Automotive</td>
     <td><a href="http://www.group1auto.com">http://www.group1auto.com</a></td>
     </tr>, <tr><td>274</td>
     <td>Entergy</td>
     <td><a href="http://www.entergy.com">http://www.entergy.com</a></td>
     </tr>, <tr><td>275</td>
     <td>Molson Coors Brewing</td>
     <td><a href="http://www.molsoncoors.com">http://www.molsoncoors.com</a></td>
     </tr>, <tr><td>276</td>
     <td>L Technologies</td>
     <td><a href="http://www.l3t.com">http://www.l3t.com</a></td>
     </tr>, <tr><td>277</td>
     <td>Ball</td>
     <td><a href="http://www.ball.com">http://www.ball.com</a></td>
     </tr>, <tr><td>278</td>
     <td>AutoZone</td>
     <td><a href="http://www.autozone.com">http://www.autozone.com</a></td>
     </tr>, <tr><td>279</td>
     <td>Murphy USA</td>
     <td><a href="http://www.murphyusa.com">http://www.murphyusa.com</a></td>
     </tr>, <tr><td>280</td>
     <td>MGM Resorts International</td>
     <td><a href="http://www.mgmresorts.com">http://www.mgmresorts.com</a></td>
     </tr>, <tr><td>281</td>
     <td>Office Depot</td>
     <td><a href="http://www.officedepot.com">http://www.officedepot.com</a></td>
     </tr>, <tr><td>282</td>
     <td>Huntsman</td>
     <td><a href="http://www.huntsman.com">http://www.huntsman.com</a></td>
     </tr>, <tr><td>283</td>
     <td>Baxter International</td>
     <td><a href="http://www.baxter.com">http://www.baxter.com</a></td>
     </tr>, <tr><td>284</td>
     <td>Norfolk Southern</td>
     <td><a href="http://www.norfolksouthern.com">http://www.norfolksouthern.com</a></td>
     </tr>, <tr><td>285</td>
     <td>salesforce.com</td>
     <td><a href="http://www.salesforce.com">http://www.salesforce.com</a></td>
     </tr>, <tr><td>286</td>
     <td>Laboratory Corp. of America</td>
     <td><a href="http://www.labcorp.com">http://www.labcorp.com</a></td>
     </tr>, <tr><td>287</td>
     <td>W.W. Grainger</td>
     <td><a href="http://www.grainger.com">http://www.grainger.com</a></td>
     </tr>, <tr><td>288</td>
     <td>Qurate Retail</td>
     <td><a href="http://www.libertyinteractive.com">http://www.libertyinteractive.com</a></td>
     </tr>, <tr><td>289</td>
     <td>Autoliv</td>
     <td><a href="http://www.autoliv.com">http://www.autoliv.com</a></td>
     </tr>, <tr><td>290</td>
     <td>Live Nation Entertainment</td>
     <td><a href="http://www.livenationentertainment.com">http://www.livenationentertainment.com</a></td>
     </tr>, <tr><td>291</td>
     <td>Xerox</td>
     <td><a href="http://www.xerox.com">http://www.xerox.com</a></td>
     </tr>, <tr><td>292</td>
     <td>Leidos Holdings</td>
     <td><a href="http://www.leidos.com">http://www.leidos.com</a></td>
     </tr>, <tr><td>293</td>
     <td>Corning</td>
     <td><a href="http://www.corning.com">http://www.corning.com</a></td>
     </tr>, <tr><td>294</td>
     <td>Lithia Motors</td>
     <td><a href="http://www.lithiainvestorrelations.com">http://www.lithiainvestorrelations.com</a></td>
     </tr>, <tr><td>295</td>
     <td>Expedia Group</td>
     <td><a href="http://www.expediagroup.com">http://www.expediagroup.com</a></td>
     </tr>, <tr><td>296</td>
     <td>Republic Services</td>
     <td><a href="http://www.republicservices.com">http://www.republicservices.com</a></td>
     </tr>, <tr><td>297</td>
     <td>Jacobs Engineering Group</td>
     <td><a href="http://www.jacobs.com">http://www.jacobs.com</a></td>
     </tr>, <tr><td>298</td>
     <td>Sonic Automotive</td>
     <td><a href="http://www.sonicautomotive.com">http://www.sonicautomotive.com</a></td>
     </tr>, <tr><td>299</td>
     <td>Ally Financial</td>
     <td><a href="http://www.ally.com">http://www.ally.com</a></td>
     </tr>, <tr><td>300</td>
     <td>LKQ</td>
     <td><a href="http://www.lkqcorp.com">http://www.lkqcorp.com</a></td>
     </tr>, <tr><td>301</td>
     <td>BorgWarner</td>
     <td><a href="http://www.borgwarner.com">http://www.borgwarner.com</a></td>
     </tr>, <tr><td>302</td>
     <td>Fidelity National Financial</td>
     <td><a href="http://www.fnf.com">http://www.fnf.com</a></td>
     </tr>, <tr><td>303</td>
     <td>SunTrust Banks</td>
     <td><a href="http://www.suntrust.com">http://www.suntrust.com</a></td>
     </tr>, <tr><td>304</td>
     <td>IQVIA Holdings</td>
     <td><a href="www.iqvia.com">www.iqvia.com</a></td>
     </tr>, <tr><td>305</td>
     <td>Reliance Steel &amp; Aluminum</td>
     <td><a href="http://www.rsac.com">http://www.rsac.com</a></td>
     </tr>, <tr><td>306</td>
     <td>Nvidia</td>
     <td><a href="http://www.nvidia.com">http://www.nvidia.com</a></td>
     </tr>, <tr><td>307</td>
     <td>Voya Financial</td>
     <td><a href="http://www.voya.com">http://www.voya.com</a></td>
     </tr>, <tr><td>308</td>
     <td>CenterPoint Energy</td>
     <td><a href="http://www.centerpointenergy.com">http://www.centerpointenergy.com</a></td>
     </tr>, <tr><td>309</td>
     <td>eBay</td>
     <td><a href="http://www.ebay.com">http://www.ebay.com</a></td>
     </tr>, <tr><td>310</td>
     <td>Eastman Chemical</td>
     <td><a href="http://www.eastman.com">http://www.eastman.com</a></td>
     </tr>, <tr><td>311</td>
     <td>American Family Insurance Group</td>
     <td><a href="http://www.amfam.com">http://www.amfam.com</a></td>
     </tr>, <tr><td>312</td>
     <td>Steel Dynamics</td>
     <td><a href="http://www.steeldynamics.com">http://www.steeldynamics.com</a></td>
     </tr>, <tr><td>313</td>
     <td>Pacific Life</td>
     <td><a href="http://www.pacificlife.com">http://www.pacificlife.com</a></td>
     </tr>, <tr><td>314</td>
     <td>Chesapeake Energy</td>
     <td><a href="http://www.chk.com">http://www.chk.com</a></td>
     </tr>, <tr><td>315</td>
     <td>Mohawk Industries</td>
     <td><a href="http://www.mohawkind.com">http://www.mohawkind.com</a></td>
     </tr>, <tr><td>316</td>
     <td>Quanta Services</td>
     <td><a href="http://www.quantaservices.com">http://www.quantaservices.com</a></td>
     </tr>, <tr><td>317</td>
     <td>Advance Auto Parts</td>
     <td><a href="http://www.advanceautoparts.com">http://www.advanceautoparts.com</a></td>
     </tr>, <tr><td>318</td>
     <td>Owens &amp; Minor</td>
     <td><a href="http://www.owens-minor.com">http://www.owens-minor.com</a></td>
     </tr>, <tr><td>319</td>
     <td>United Natural Foods</td>
     <td><a href="http://www.unfi.com">http://www.unfi.com</a></td>
     </tr>, <tr><td>320</td>
     <td>Tenneco</td>
     <td><a href="http://www.tenneco.com">http://www.tenneco.com</a></td>
     </tr>, <tr><td>321</td>
     <td>Conagra Brands</td>
     <td><a href="http://www.conagrabrands.com">http://www.conagrabrands.com</a></td>
     </tr>, <tr><td>322</td>
     <td>GameStop</td>
     <td><a href="http://www.gamestop.com">http://www.gamestop.com</a></td>
     </tr>, <tr><td>323</td>
     <td>Hormel Foods</td>
     <td><a href="http://www.hormelfoods.com">http://www.hormelfoods.com</a></td>
     </tr>, <tr><td>324</td>
     <td>Hilton Worldwide Holdings</td>
     <td><a href="http://www.hiltonworldwide.com">http://www.hiltonworldwide.com</a></td>
     </tr>, <tr><td>325</td>
     <td>Frontier Communications</td>
     <td><a href="http://www.frontier.com">http://www.frontier.com</a></td>
     </tr>, <tr><td>326</td>
     <td>Fidelity National Information Services</td>
     <td><a href="http://www.fisglobal.com">http://www.fisglobal.com</a></td>
     </tr>, <tr><td>327</td>
     <td>Public Service Enterprise Group</td>
     <td><a href="http://www.pseg.com">http://www.pseg.com</a></td>
     </tr>, <tr><td>328</td>
     <td>Boston Scientific</td>
     <td><a href="http://www.bostonscientific.com">http://www.bostonscientific.com</a></td>
     </tr>, <tr><td>329</td>
     <td>O’Reilly Automotive</td>
     <td><a href="http://www.oreillyauto.com">http://www.oreillyauto.com</a></td>
     </tr>, <tr><td>330</td>
     <td>Charles Schwab</td>
     <td><a href="http://www.aboutschwab.com">http://www.aboutschwab.com</a></td>
     </tr>, <tr><td>331</td>
     <td>Global Partners</td>
     <td><a href="http://www.globalp.com">http://www.globalp.com</a></td>
     </tr>, <tr><td>332</td>
     <td>PVH</td>
     <td><a href="http://www.pvh.com">http://www.pvh.com</a></td>
     </tr>, <tr><td>333</td>
     <td>Avis Budget Group</td>
     <td><a href="http://www.avisbudgetgroup.com">http://www.avisbudgetgroup.com</a></td>
     </tr>, <tr><td>334</td>
     <td>Targa Resources</td>
     <td><a href="http://www.targaresources.com">http://www.targaresources.com</a></td>
     </tr>, <tr><td>335</td>
     <td>Hertz Global Holdings</td>
     <td><a href="http://www.hertz.com">http://www.hertz.com</a></td>
     </tr>, <tr><td>336</td>
     <td>Calpine</td>
     <td><a href="http://www.calpine.com">http://www.calpine.com</a></td>
     </tr>, <tr><td>337</td>
     <td>Mutual of Omaha Insurance</td>
     <td><a href="http://www.mutualofomaha.com">http://www.mutualofomaha.com</a></td>
     </tr>, <tr><td>338</td>
     <td>Crown Holdings</td>
     <td><a href="http://www.crowncork.com">http://www.crowncork.com</a></td>
     </tr>, <tr><td>339</td>
     <td>Peter Kiewit Sons’</td>
     <td><a href="http://www.kiewit.com">http://www.kiewit.com</a></td>
     </tr>, <tr><td>340</td>
     <td>Dick’s Sporting Goods</td>
     <td><a href="http://www.dicks.com">http://www.dicks.com</a></td>
     </tr>, <tr><td>341</td>
     <td>PulteGroup</td>
     <td><a href="http://www.pultegroupinc.com">http://www.pultegroupinc.com</a></td>
     </tr>, <tr><td>342</td>
     <td>Navistar International</td>
     <td><a href="http://www.navistar.com">http://www.navistar.com</a></td>
     </tr>, <tr><td>343</td>
     <td>Thrivent Financial for Lutherans</td>
     <td><a href="http://www.thrivent.com">http://www.thrivent.com</a></td>
     </tr>, <tr><td>344</td>
     <td>DCP Midstream</td>
     <td><a href="http://www.dcpmidstream.com">http://www.dcpmidstream.com</a></td>
     </tr>, <tr><td>345</td>
     <td>Air Products &amp; Chemicals</td>
     <td><a href="http://www.airproducts.com">http://www.airproducts.com</a></td>
     </tr>, <tr><td>346</td>
     <td>Veritiv</td>
     <td><a href="http://www.veritivcorp.com">http://www.veritivcorp.com</a></td>
     </tr>, <tr><td>347</td>
     <td>AGCO</td>
     <td><a href="http://www.agcocorp.com">http://www.agcocorp.com</a></td>
     </tr>, <tr><td>348</td>
     <td>Genworth Financial</td>
     <td><a href="http://www.genworth.com">http://www.genworth.com</a></td>
     </tr>, <tr><td>349</td>
     <td>Univar</td>
     <td><a href="http://www.univar.com">http://www.univar.com</a></td>
     </tr>, <tr><td>350</td>
     <td>News Corp.</td>
     <td><a href="http://www.newscorp.com">http://www.newscorp.com</a></td>
     </tr>, <tr><td>351</td>
     <td>SpartanNash</td>
     <td><a href="http://www.spartannash.com">http://www.spartannash.com</a></td>
     </tr>, <tr><td>352</td>
     <td>Westlake Chemical</td>
     <td><a href="http://www.westlake.com">http://www.westlake.com</a></td>
     </tr>, <tr><td>353</td>
     <td>Williams</td>
     <td><a href="http://www.williams.com">http://www.williams.com</a></td>
     </tr>, <tr><td>354</td>
     <td>Lam Research</td>
     <td><a href="http://www.lamresearch.com">http://www.lamresearch.com</a></td>
     </tr>, <tr><td>355</td>
     <td>Alaska Air Group</td>
     <td><a href="http://www.alaskaair.com">http://www.alaskaair.com</a></td>
     </tr>, <tr><td>356</td>
     <td>Jones Lang LaSalle</td>
     <td><a href="http://www.jll.com">http://www.jll.com</a></td>
     </tr>, <tr><td>357</td>
     <td>Anixter International</td>
     <td><a href="http://www.anixter.com">http://www.anixter.com</a></td>
     </tr>, <tr><td>358</td>
     <td>Campbell Soup</td>
     <td><a href="http://www.campbellsoupcompany.com">http://www.campbellsoupcompany.com</a></td>
     </tr>, <tr><td>359</td>
     <td>Interpublic Group</td>
     <td><a href="http://www.interpublic.com">http://www.interpublic.com</a></td>
     </tr>, <tr><td>360</td>
     <td>Dover</td>
     <td><a href="http://www.dovercorporation.com">http://www.dovercorporation.com</a></td>
     </tr>, <tr><td>361</td>
     <td>Zimmer Biomet Holdings</td>
     <td><a href="http://www.zimmerbiomet.com">http://www.zimmerbiomet.com</a></td>
     </tr>, <tr><td>362</td>
     <td>Dean Foods</td>
     <td><a href="http://www.deanfoods.com">http://www.deanfoods.com</a></td>
     </tr>, <tr><td>363</td>
     <td>Foot Locker</td>
     <td><a href="http://www.footlocker-inc.com">http://www.footlocker-inc.com</a></td>
     </tr>, <tr><td>364</td>
     <td>Eversource Energy</td>
     <td><a href="http://www.eversource.com">http://www.eversource.com</a></td>
     </tr>, <tr><td>365</td>
     <td>Alliance Data Systems</td>
     <td><a href="http://www.alliancedata.com">http://www.alliancedata.com</a></td>
     </tr>, <tr><td>366</td>
     <td>Fifth Third Bancorp</td>
     <td><a href="http://www.53.com">http://www.53.com</a></td>
     </tr>, <tr><td>367</td>
     <td>Quest Diagnostics</td>
     <td><a href="http://www.questdiagnostics.com">http://www.questdiagnostics.com</a></td>
     </tr>, <tr><td>368</td>
     <td>EMCOR Group</td>
     <td><a href="http://www.emcorgroup.com">http://www.emcorgroup.com</a></td>
     </tr>, <tr><td>369</td>
     <td>W.R. Berkley</td>
     <td><a href="http://www.wrberkley.com">http://www.wrberkley.com</a></td>
     </tr>, <tr><td>370</td>
     <td>WESCO International</td>
     <td><a href="http://www.wesco.com">http://www.wesco.com</a></td>
     </tr>, <tr><td>371</td>
     <td>Coty</td>
     <td><a href="http://www.coty.com">http://www.coty.com</a></td>
     </tr>, <tr><td>372</td>
     <td>WEC Energy Group</td>
     <td><a href="http://www.wecenergygroup.com">http://www.wecenergygroup.com</a></td>
     </tr>, <tr><td>373</td>
     <td>Masco</td>
     <td><a href="http://www.masco.com">http://www.masco.com</a></td>
     </tr>, <tr><td>374</td>
     <td>DXC Technology</td>
     <td><a href="http://www.dxc.technology">http://www.dxc.technology</a></td>
     </tr>, <tr><td>375</td>
     <td>Auto-Owners Insurance</td>
     <td><a href="http://www.auto-owners.com">http://www.auto-owners.com</a></td>
     </tr>, <tr><td>376</td>
     <td>Jones Financial (Edward Jones)</td>
     <td><a href="www.iqvia.comwww.edwardjones.com">www.iqvia.comwww.edwardjones.com</a></td>
     </tr>, <tr><td>377</td>
     <td>Liberty Media</td>
     <td><a href="http://www.libertymedia.com">http://www.libertymedia.com</a></td>
     </tr>, <tr><td>378</td>
     <td>Erie Insurance Group</td>
     <td><a href="http://www.erieinsurance.com">http://www.erieinsurance.com</a></td>
     </tr>, <tr><td>379</td>
     <td>Hershey</td>
     <td><a href="http://www.thehersheycompany.com">http://www.thehersheycompany.com</a></td>
     </tr>, <tr><td>380</td>
     <td>PPL</td>
     <td><a href="http://www.pplweb.com">http://www.pplweb.com</a></td>
     </tr>, <tr><td>381</td>
     <td>Huntington Ingalls Industries</td>
     <td><a href="http://www.huntingtoningalls.com">http://www.huntingtoningalls.com</a></td>
     </tr>, <tr><td>382</td>
     <td>Mosaic</td>
     <td><a href="http://www.mosaicco.com">http://www.mosaicco.com</a></td>
     </tr>, <tr><td>383</td>
     <td>J.M. Smucker</td>
     <td><a href="http://www.jmsmucker.com">http://www.jmsmucker.com</a></td>
     </tr>, <tr><td>384</td>
     <td>Delek US Holdings</td>
     <td><a href="http://www.delekus.com">http://www.delekus.com</a></td>
     </tr>, <tr><td>385</td>
     <td>Newmont Mining</td>
     <td><a href="http://www.newmont.com">http://www.newmont.com</a></td>
     </tr>, <tr><td>386</td>
     <td>Constellation Brands</td>
     <td><a href="http://www.cbrands.com">http://www.cbrands.com</a></td>
     </tr>, <tr><td>387</td>
     <td>Ryder System</td>
     <td><a href="http://www.ryder.com">http://www.ryder.com</a></td>
     </tr>, <tr><td>388</td>
     <td>National Oilwell Varco</td>
     <td><a href="http://www.nov.com">http://www.nov.com</a></td>
     </tr>, <tr><td>389</td>
     <td>Adobe Systems</td>
     <td><a href="http://www.adobe.com">http://www.adobe.com</a></td>
     </tr>, <tr><td>390</td>
     <td>LifePoint Health</td>
     <td><a href="http://www.lifepointhealth.net">http://www.lifepointhealth.net</a></td>
     </tr>, <tr><td>391</td>
     <td>Tractor Supply</td>
     <td><a href="http://www.tractorsupply.com">http://www.tractorsupply.com</a></td>
     </tr>, <tr><td>392</td>
     <td>Thor Industries</td>
     <td><a href="http://www.thorindustries.com">http://www.thorindustries.com</a></td>
     </tr>, <tr><td>393</td>
     <td>Dana</td>
     <td><a href="http://www.dana.com">http://www.dana.com</a></td>
     </tr>, <tr><td>394</td>
     <td>Weyerhaeuser</td>
     <td><a href="http://www.weyerhaeuser.com">http://www.weyerhaeuser.com</a></td>
     </tr>, <tr><td>395</td>
     <td>J.B. Hunt Transport Services</td>
     <td><a href="http://www.jbhunt.com">http://www.jbhunt.com</a></td>
     </tr>, <tr><td>396</td>
     <td>Darden Restaurants</td>
     <td><a href="http://www.darden.com">http://www.darden.com</a></td>
     </tr>, <tr><td>397</td>
     <td>Yum China Holdings</td>
     <td><a href="http://ir.yumchina.com">http://ir.yumchina.com</a></td>
     </tr>, <tr><td>398</td>
     <td>Blackstone Group</td>
     <td><a href="http://www.blackstone.com">http://www.blackstone.com</a></td>
     </tr>, <tr><td>399</td>
     <td>Berry Global Group</td>
     <td><a href="http://www.berryglobal.com">http://www.berryglobal.com</a></td>
     </tr>, <tr><td>400</td>
     <td>Builders FirstSource</td>
     <td><a href="http://www.bldr.com">http://www.bldr.com</a></td>
     </tr>, <tr><td>401</td>
     <td>Activision Blizzard</td>
     <td><a href="http://www.activisionblizzard.com">http://www.activisionblizzard.com</a></td>
     </tr>, <tr><td>402</td>
     <td>JetBlue Airways</td>
     <td><a href="http://www.jetblue.com">http://www.jetblue.com</a></td>
     </tr>, <tr><td>403</td>
     <td>Amphenol</td>
     <td><a href="http://www.amphenol.com">http://www.amphenol.com</a></td>
     </tr>, <tr><td>404</td>
     <td>A-Mark Precious Metals</td>
     <td><a href="http://www.amark.com">http://www.amark.com</a></td>
     </tr>, <tr><td>405</td>
     <td>Spirit AeroSystems Holdings</td>
     <td><a href="http://www.spiritaero.com">http://www.spiritaero.com</a></td>
     </tr>, <tr><td>406</td>
     <td>R.R. Donnelley &amp; Sons</td>
     <td><a href="http://www.rrdonnelley.com">http://www.rrdonnelley.com</a></td>
     </tr>, <tr><td>407</td>
     <td>Harris</td>
     <td><a href="http://www.harris.com">http://www.harris.com</a></td>
     </tr>, <tr><td>408</td>
     <td>Expeditors Intl. of Washington</td>
     <td><a href="http://www.expeditors.com">http://www.expeditors.com</a></td>
     </tr>, <tr><td>409</td>
     <td>Discovery</td>
     <td><a href="http://www.discovery.com">http://www.discovery.com</a></td>
     </tr>, <tr><td>410</td>
     <td>Owens-Illinois</td>
     <td><a href="http://www.o-i.com">http://www.o-i.com</a></td>
     </tr>, <tr><td>411</td>
     <td>Sanmina</td>
     <td><a href="http://www.sanmina.com">http://www.sanmina.com</a></td>
     </tr>, <tr><td>412</td>
     <td>KeyCorp</td>
     <td><a href="http://www.key.com">http://www.key.com</a></td>
     </tr>, <tr><td>413</td>
     <td>American Financial Group</td>
     <td><a href="http://www.afginc.com">http://www.afginc.com</a></td>
     </tr>, <tr><td>414</td>
     <td>Oshkosh</td>
     <td><a href="http://www.oshkoshcorporation.com">http://www.oshkoshcorporation.com</a></td>
     </tr>, <tr><td>415</td>
     <td>Rockwell Collins</td>
     <td><a href="http://www.rockwellcollins.com">http://www.rockwellcollins.com</a></td>
     </tr>, <tr><td>416</td>
     <td>Kindred Healthcare</td>
     <td><a href="http://www.kindredhealthcare.com">http://www.kindredhealthcare.com</a></td>
     </tr>, <tr><td>417</td>
     <td>Insight Enterprises</td>
     <td><a href="http://www.insight.com">http://www.insight.com</a></td>
     </tr>, <tr><td>418</td>
     <td>Dr Pepper Snapple Group</td>
     <td><a href="http://www.drpeppersnapplegroup.com">http://www.drpeppersnapplegroup.com</a></td>
     </tr>, <tr><td>419</td>
     <td>American Tower</td>
     <td><a href="http://www.americantower.com">http://www.americantower.com</a></td>
     </tr>, <tr><td>420</td>
     <td>Fortive</td>
     <td><a href="http://www.fortive.com">http://www.fortive.com</a></td>
     </tr>, <tr><td>421</td>
     <td>Ralph Lauren</td>
     <td><a href="http://www.ralphlauren.com">http://www.ralphlauren.com</a></td>
     </tr>, <tr><td>422</td>
     <td>HRG Group</td>
     <td><a href="http://www.hrggroup.com">http://www.hrggroup.com</a></td>
     </tr>, <tr><td>423</td>
     <td>Ascena Retail Group</td>
     <td><a href="http://www.ascenaretail.com">http://www.ascenaretail.com</a></td>
     </tr>, <tr><td>424</td>
     <td>United Rentals</td>
     <td><a href="http://www.unitedrentals.com">http://www.unitedrentals.com</a></td>
     </tr>, <tr><td>425</td>
     <td>Casey’s General Stores</td>
     <td><a href="http://www.caseys.com">http://www.caseys.com</a></td>
     </tr>, <tr><td>426</td>
     <td>Graybar Electric</td>
     <td><a href="http://www.graybar.com">http://www.graybar.com</a></td>
     </tr>, <tr><td>427</td>
     <td>Avery Dennison</td>
     <td><a href="http://www.averydennison.com">http://www.averydennison.com</a></td>
     </tr>, <tr><td>428</td>
     <td>MasTec</td>
     <td><a href="http://www.mastec.com">http://www.mastec.com</a></td>
     </tr>, <tr><td>429</td>
     <td>CMS Energy</td>
     <td><a href="http://www.cmsenergy.com">http://www.cmsenergy.com</a></td>
     </tr>, <tr><td>430</td>
     <td>HD Supply Holdings</td>
     <td><a href="http://www.hdsupply.com">http://www.hdsupply.com</a></td>
     </tr>, <tr><td>431</td>
     <td>Raymond James Financial</td>
     <td><a href="http://www.raymondjames.com">http://www.raymondjames.com</a></td>
     </tr>, <tr><td>432</td>
     <td>NCR</td>
     <td><a href="http://www.ncr.com">http://www.ncr.com</a></td>
     </tr>, <tr><td>433</td>
     <td>Hanesbrands</td>
     <td><a href="http://www.hanes.com">http://www.hanes.com</a></td>
     </tr>, <tr><td>434</td>
     <td>Asbury Automotive Group</td>
     <td><a href="http://www.asburyauto.com">http://www.asburyauto.com</a></td>
     </tr>, <tr><td>435</td>
     <td>Citizens Financial Group</td>
     <td><a href="http://www.citizensbank.com">http://www.citizensbank.com</a></td>
     </tr>, <tr><td>436</td>
     <td>Packaging Corp. of America</td>
     <td><a href="http://www.packagingcorp.com">http://www.packagingcorp.com</a></td>
     </tr>, <tr><td>437</td>
     <td>Alleghany</td>
     <td><a href="http://www.alleghany.com">http://www.alleghany.com</a></td>
     </tr>, <tr><td>438</td>
     <td>Apache</td>
     <td><a href="http://www.apachecorp.com">http://www.apachecorp.com</a></td>
     </tr>, <tr><td>439</td>
     <td>Dillard’s</td>
     <td><a href="http://www.dillards.com">http://www.dillards.com</a></td>
     </tr>, <tr><td>440</td>
     <td>Assurant</td>
     <td><a href="http://www.assurant.com">http://www.assurant.com</a></td>
     </tr>, <tr><td>441</td>
     <td>Franklin Resources</td>
     <td><a href="http://www.franklinresources.com">http://www.franklinresources.com</a></td>
     </tr>, <tr><td>442</td>
     <td>Owens Corning</td>
     <td><a href="http://www.owenscorning.com">http://www.owenscorning.com</a></td>
     </tr>, <tr><td>443</td>
     <td>Motorola Solutions</td>
     <td><a href="http://www.motorolasolutions.com">http://www.motorolasolutions.com</a></td>
     </tr>, <tr><td>444</td>
     <td>NVR</td>
     <td><a href="http://www.nvrinc.com">http://www.nvrinc.com</a></td>
     </tr>, <tr><td>445</td>
     <td>Rockwell Automation</td>
     <td><a href="http://www.rockwellautomation.com">http://www.rockwellautomation.com</a></td>
     </tr>, <tr><td>446</td>
     <td>TreeHouse Foods</td>
     <td><a href="http://www.treehousefoods.com">http://www.treehousefoods.com</a></td>
     </tr>, <tr><td>447</td>
     <td>Wynn Resorts</td>
     <td><a href="http://www.wynnresorts.com">http://www.wynnresorts.com</a></td>
     </tr>, <tr><td>448</td>
     <td>Olin</td>
     <td><a href="http://www.olin.com">http://www.olin.com</a></td>
     </tr>, <tr><td>449</td>
     <td>American Axle &amp; Manufacturing</td>
     <td><a href="http://www.aam.com">http://www.aam.com</a></td>
     </tr>, <tr><td>450</td>
     <td>Old Republic International</td>
     <td><a href="http://www.oldrepublic.com">http://www.oldrepublic.com</a></td>
     </tr>, <tr><td>451</td>
     <td>Chemours</td>
     <td><a href="http://www.chemours.com">http://www.chemours.com</a></td>
     </tr>, <tr><td>452</td>
     <td>iHeartMedia</td>
     <td><a href="http://www.iheartmedia.com">http://www.iheartmedia.com</a></td>
     </tr>, <tr><td>453</td>
     <td>Ameren</td>
     <td><a href="http://www.ameren.com">http://www.ameren.com</a></td>
     </tr>, <tr><td>454</td>
     <td>Arthur J. Gallagher</td>
     <td><a href="http://www.ajg.com">http://www.ajg.com</a></td>
     </tr>, <tr><td>455</td>
     <td>Celanese</td>
     <td><a href="http://www.celanese.com">http://www.celanese.com</a></td>
     </tr>, <tr><td>456</td>
     <td>Sealed Air</td>
     <td><a href="http://www.sealedair.com">http://www.sealedair.com</a></td>
     </tr>, <tr><td>457</td>
     <td>UGI</td>
     <td><a href="http://www.ugicorp.com">http://www.ugicorp.com</a></td>
     </tr>, <tr><td>458</td>
     <td>Realogy Holdings</td>
     <td><a href="http://www.realogy.com">http://www.realogy.com</a></td>
     </tr>, <tr><td>459</td>
     <td>Burlington Stores</td>
     <td><a href="http://www.burlington.com">http://www.burlington.com</a></td>
     </tr>, <tr><td>460</td>
     <td>Regions Financial</td>
     <td><a href="http://www.regions.com">http://www.regions.com</a></td>
     </tr>, <tr><td>461</td>
     <td>AK Steel Holding</td>
     <td><a href="http://www.aksteel.com">http://www.aksteel.com</a></td>
     </tr>, <tr><td>462</td>
     <td>Securian Financial Group</td>
     <td><a href="http://www.securian.com">http://www.securian.com</a></td>
     </tr>, <tr><td>463</td>
     <td>S&amp;P Global</td>
     <td><a href="http://www.spglobal.com">http://www.spglobal.com</a></td>
     </tr>, <tr><td>464</td>
     <td>Markel</td>
     <td><a href="http://www.markelcorp.com">http://www.markelcorp.com</a></td>
     </tr>, <tr><td>465</td>
     <td>TravelCenters of America</td>
     <td><a href="http://www.ta-petro.com">http://www.ta-petro.com</a></td>
     </tr>, <tr><td>466</td>
     <td>Conduent</td>
     <td><a href="http://www.conduent.com">http://www.conduent.com</a></td>
     </tr>, <tr><td>467</td>
     <td>M&amp;T Bank Corp.</td>
     <td><a href="http://www.mtb.com">http://www.mtb.com</a></td>
     </tr>, <tr><td>468</td>
     <td>Clorox</td>
     <td><a href="http://www.thecloroxcompany.com">http://www.thecloroxcompany.com</a></td>
     </tr>, <tr><td>469</td>
     <td>AmTrust Financial Services</td>
     <td><a href="http://www.amtrustfinancial.com">http://www.amtrustfinancial.com</a></td>
     </tr>, <tr><td>470</td>
     <td>KKR</td>
     <td><a href="http://www.kkr.com">http://www.kkr.com</a></td>
     </tr>, <tr><td>471</td>
     <td>Ulta Beauty</td>
     <td><a href="http://www.ulta.com">http://www.ulta.com</a></td>
     </tr>, <tr><td>472</td>
     <td>Yum Brands</td>
     <td><a href="http://www.yum.com">http://www.yum.com</a></td>
     </tr>, <tr><td>473</td>
     <td>Regeneron Pharmaceuticals</td>
     <td><a href="http://www.regeneron.com">http://www.regeneron.com</a></td>
     </tr>, <tr><td>474</td>
     <td>Windstream Holdings</td>
     <td><a href="http://www.windstream.com">http://www.windstream.com</a></td>
     </tr>, <tr><td>475</td>
     <td>Magellan Health</td>
     <td><a href="http://www.magellanhealth.com">http://www.magellanhealth.com</a></td>
     </tr>, <tr><td>476</td>
     <td>Western &amp; Southern Financial</td>
     <td><a href="http://www.westernsouthern.com">http://www.westernsouthern.com</a></td>
     </tr>, <tr><td>477</td>
     <td>Intercontinental Exchange</td>
     <td><a href="http://www.theice.com">http://www.theice.com</a></td>
     </tr>, <tr><td>478</td>
     <td>Ingredion</td>
     <td><a href="http://www.ingredion.com">http://www.ingredion.com</a></td>
     </tr>, <tr><td>479</td>
     <td>Wyndham Destinations</td>
     <td><a href="http://www.wyndhamdestinations.com">http://www.wyndhamdestinations.com</a></td>
     </tr>, <tr><td>480</td>
     <td>Toll Brothers</td>
     <td><a href="http://www.tollbrothers.com">http://www.tollbrothers.com</a></td>
     </tr>, <tr><td>481</td>
     <td>Seaboard</td>
     <td><a href="http://www.seaboardcorp.com">http://www.seaboardcorp.com</a></td>
     </tr>, <tr><td>482</td>
     <td>Booz Allen Hamilton</td>
     <td><a href="http://www.boozallen.com">http://www.boozallen.com</a></td>
     </tr>, <tr><td>483</td>
     <td>First American Financial</td>
     <td><a href="http://www.firstam.com">http://www.firstam.com</a></td>
     </tr>, <tr><td>484</td>
     <td>Cincinnati Financial</td>
     <td><a href="http://www.cinfin.com">http://www.cinfin.com</a></td>
     </tr>, <tr><td>485</td>
     <td>Avon Products</td>
     <td><a href="http://www.avoninvestor.com">http://www.avoninvestor.com</a></td>
     </tr>, <tr><td>486</td>
     <td>Northern Trust</td>
     <td><a href="http://www.northerntrust.com">http://www.northerntrust.com</a></td>
     </tr>, <tr><td>487</td>
     <td>Fiserv</td>
     <td><a href="http://www.fiserv.com">http://www.fiserv.com</a></td>
     </tr>, <tr><td>488</td>
     <td>Harley-Davidson</td>
     <td><a href="http://www.harley-davidson.com">http://www.harley-davidson.com</a></td>
     </tr>, <tr><td>489</td>
     <td>Cheniere Energy</td>
     <td><a href="http://www.cheniere.com">http://www.cheniere.com</a></td>
     </tr>, <tr><td>490</td>
     <td>Patterson</td>
     <td><a href="http://www.pattersoncompanies.com">http://www.pattersoncompanies.com</a></td>
     </tr>, <tr><td>491</td>
     <td>Peabody Energy</td>
     <td><a href="http://www.peabodyenergy.com">http://www.peabodyenergy.com</a></td>
     </tr>, <tr><td>492</td>
     <td>ON Semiconductor</td>
     <td><a href="http://www.onsemi.com">http://www.onsemi.com</a></td>
     </tr>, <tr><td>493</td>
     <td>Simon Property Group</td>
     <td><a href="http://www.simon.com">http://www.simon.com</a></td>
     </tr>, <tr><td>494</td>
     <td>Western Union</td>
     <td><a href="http://www.westernunion.com">http://www.westernunion.com</a></td>
     </tr>, <tr><td>495</td>
     <td>NetApp</td>
     <td><a href="http://www.netapp.com">http://www.netapp.com</a></td>
     </tr>, <tr><td>496</td>
     <td>Polaris Industries</td>
     <td><a href="http://www.polaris.com">http://www.polaris.com</a></td>
     </tr>, <tr><td>497</td>
     <td>Pioneer Natural Resources</td>
     <td><a href="http://www.pxd.com">http://www.pxd.com</a></td>
     </tr>, <tr><td>498</td>
     <td>ABM Industries</td>
     <td><a href="http://www.abm.com">http://www.abm.com</a></td>
     </tr>, <tr><td>499</td>
     <td>Vistra Energy</td>
     <td><a href="http://www.vistraenergy.com">http://www.vistraenergy.com</a></td>
     </tr>, <tr><td>500</td>
     <td>Cintas</td>
     <td><a href="http://www.cintas.com">http://www.cintas.com</a></td>
     </tr>]




```python
print(all_values[0])
print('--')
print(all_values[1])
print('--')
print(all_values[2])
```

    <tr><th>Rank</th>
    <th>Company</th>
    <th>Website</th>
    </tr>
    --
    <tr><td>1</td>
    <td>Walmart</td>
    <td><a href="http://www.stock.walmart.com">http://www.stock.walmart.com</a></td>
    </tr>
    --
    <tr><td>2</td>
    <td>Exxon Mobil</td>
    <td><a href="http://www.exxonmobil.com">http://www.exxonmobil.com</a></td>
    </tr>
    

The first element of the list contains the column names 'Rank, Company and Website'. The next elements of the list contain soup objects which contain the company data including the rank. This data can be extracted in a loop since the structure for all the list elements is the same.

- An empty dataframe fortune_500_df is created with the column names 'rank', 'company_name' and 'company_website'
- The index is initiated to zero
- A for loop is designed to go through all the elements of the list in order and extract the rank, company name and company website from the list element which are enclosed in the 'td' HTML tag. A find_all() will return a list of td tags.
- The '.text' attribute can be used to just pick the text part from the tag. In our case this is the rank, company name and the compnay website
- These values are then put into the dataframe and the index value is incremented


```python
fortune_500_df = pd.DataFrame(columns = ['rank', 'company_name', 'company_website'])
ix = 0

for row in all_values[1:]:
    values = row.find_all('td')
    rank = values[0].text
    company = values[1].text
    website = values[2].text
    
    fortune_500_df.loc[ix] = [rank, company, website]
    ix += 1
    
fortune_500_df.head()
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
      <td>0</td>
      <td>1</td>
      <td>Walmart</td>
      <td>http://www.stock.walmart.com</td>
    </tr>
    <tr>
      <td>1</td>
      <td>2</td>
      <td>Exxon Mobil</td>
      <td>http://www.exxonmobil.com</td>
    </tr>
    <tr>
      <td>2</td>
      <td>3</td>
      <td>Berkshire Hathaway</td>
      <td>http://www.berkshirehathaway.com</td>
    </tr>
    <tr>
      <td>3</td>
      <td>4</td>
      <td>Apple</td>
      <td>http://www.apple.com</td>
    </tr>
    <tr>
      <td>4</td>
      <td>5</td>
      <td>UnitedHealth Group</td>
      <td>http://www.unitedhealthgroup.com</td>
    </tr>
  </tbody>
</table>
</div>



## 4. Store it in the appropriate format - CSV, TSV and export the results

The dataframe can now be stored as a csv file. Pandas has a 'to_csv' method which can be used to save the data into the file '


```python
fortune_500_df.to_csv('./fortune_500_companies.csv', index=False)
```