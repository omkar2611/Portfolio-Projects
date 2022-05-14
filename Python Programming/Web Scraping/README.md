## Web Scraping using BeautifulSoup

The below code scrapes the Amazon webpage. The URL contains the details of the book selling on Amazon Website. The code scrapes the details of the Books like, 'Title','Price','Publisher, 'Language' and other details. Finally the details are stored into a '.csv' file.

```
# import libraries

from bs4 import BeautifulSoup
import re
import csv
import requests
import smtplib
import time
import datetime

# Connection URL
URL = 'https://www.amazon.in/Business-Intelligence-Analytics-Data-Science/dp/9353067022/ref=sr_1_1_sspa?keywords=data+analytics+books&qid=1652177305&sprefix=data+ana%2Caps%2C104&sr=8-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUFRNTRWS1IwSlI3M1ImZW5jcnlwdGVkSWQ9QTA4ODY1NzczU1FCVDFVRVJaT1czJmVuY3J5cHRlZEFkSWQ9QTEwMjU5ODkxM0NFN1hFUU9PWlROJndpZGdldE5hbWU9c3BfYXRmJmFjdGlvbj1jbGlja1JlZGlyZWN0JmRvTm90TG9nQ2xpY2s9dHJ1ZQ=='
# User-Agent from "https://httpbin.org/get"
headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.41 Safari/537.36", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

# Sending request
page = requests.get(URL, headers=headers)

# Checking response
print(page)

# Writing HTML to a file
out = open("amazon_page.html","w",encoding="utf-8")
out.write(str(soup))
out.close()

# Reading from HTML(Local) file
soup = BeautifulSoup(open("amazon_page.html",encoding="utf-8"), "html.parser")
# print(soup.prettify())

```
##### Scraping Basic Details
```
title = soup.find(id = 'productTitle').get_text()             # Scraping Title
price = soup.find(id = 'price').get_text()                    # Scraping Price
title = re.sub(r"[^a-zA-Z0-9: ]","",title)
title = title.split('Fourth', 1)[0]
price = re.sub(r"[^a-zA-Z0-9: ]","",price)
print("Title: ", title)
print("Price: ", price)

d = dict([('Title',title),('Price',price)]) 

describe = []
for element in soup.find(id = 'bookDescription_feature_div'):  # Scraping Description
    temp = element.get_text()
    describe.append(temp)
description = describe[1]
description = re.sub(r"[^a-zA-Z0-9: ]","",description)
d['Description'] = description.strip()
print(description)

```
##### Scraping further Details
```
details = soup.find('ul', attrs = {'class':'a-unordered-list a-nostyle a-vertical a-spacing-none detail-bullet-list'})
inf = []
info = []
for child in details.children:
    inf.append(child.get_text())
for element in inf:
    element = re.sub(r"[^a-zA-Z0-9: ]","",element)
    info.append(element)
info = list(filter(str.strip,info))

keys = [i.split(':', 1)[0] for i in info]
values = [i.split(':', 1)[1] for i in info]

key = []
for element in keys:
    element = re.sub(" +", " ",element)
    key.append(element)
value = []
for element in values:
    element = re.sub(" +", " ",element)
    value.append(element)
   
for i in range(0,len(key)):
    d[key[i]] = value[i]

print(d)
```
##### Saving the data into CSV file
```
with open('book_data.csv', 'w') as f:
    for key in d.keys():
        f.write("%s, %s\n" % (key, d[key]))
```
