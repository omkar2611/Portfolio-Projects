## Analysing and Visualizing the Indian Movies dataset
The following code visualize the IMDB dataset of indian movies. The code is divided into four sections:

##### Importing Dataset
```
# import libraries

import numpy as np
import pandas as pd

import seaborn as sns
from matplotlib import pyplot as plt
import plotly.graph_objects as go
import plotly.express as px

import collections
from collections import namedtuple

import pandas_profiling
from IPython.display import display

import warnings
warnings.filterwarnings('ignore')

# Read Data

df = pd.read_csv("indian_movies.csv",encoding="ISO-8859-1")
df.head()

```

##### Analysing Dataset
```
# Analysing Data
report = pandas_profiling.ProfileReport(df)
report.to_file(output_file='profilingReport.html')

```

##### Cleaning Data
After looking at the Pandas Profiling Report we come to a following conclusion:

<li>There are multiple duplicate values in the dataset which needs to be removed.</li>
<li>There are many missing values in the dataset and if a movie does not have the required rating or year or director name then it will hard to the visualise the data. Hence, such rows needs to be eliminated.</li>
<li>The year field has brackets which are not required and the movie duration field has 'min' at the end. This has to be removed so we have datatype 'int' and not ''string'.</li>
<li>There are multiple entries in Genre column seperate by a ' , ' . Spliting of data into multiple columns is required for such data.</li>

```
# Missing Values
null_rows = df[df.iloc[: , 1:9].isna().apply(lambda x: all(x), axis=1)]
print("Missing values from each column:")
null_rows.head()

# Duplicate Values
duplicate = df[df.duplicated(subset = ['Name', 'Year'], keep = False)]
print("Duplicate rows according to Name and Year:")
duplicate.head()

# Droping Duplicates
df.drop_duplicates(subset=['Name', 'Year'], inplace=True)
df.shape

null_rows = df[df.iloc[: , [1,2,4,5]].isna().apply(lambda x: all(x), axis=1)]
df = df[~df.iloc[: , [1,2,4,5]].isna().apply(lambda x: all(x), axis=1)]
df['Year'] = df['Year'].str.replace(r'(', '').str.replace(r')', '')   # Removing brackets from Year
df['Duration'] = df['Duration'].str.replace(r' min', '')              # Removing min from Duration
df.drop(df.loc[df['Year']=='2022'].index, inplace = True)             # Removing 2022 movies data     
df.head()

```

##### Plotting Data

Plotting various graphs to visualize the data throughout the years.

![1](https://user-images.githubusercontent.com/30657155/168446599-9e0ff811-9993-46fb-928e-e7fffb1ebccc.png)

![2](https://user-images.githubusercontent.com/30657155/168446606-9c576580-b5d6-4a83-8a7f-e53529251624.png)

![3](https://user-images.githubusercontent.com/30657155/168446611-6697d3d1-b3fb-4340-90f6-00918045ec1b.png)

![4](https://user-images.githubusercontent.com/30657155/168446613-517de69d-b09a-46c2-b308-8c77ca5b19a2.png)



