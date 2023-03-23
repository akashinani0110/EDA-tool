Criteria Fulfilled
-------------------

Created a shiny dashboard using data from the [link](https://drive.google.com/file/d/1l1ymMg-K_xLriFv1b8MgddH851d6n2sU/view?usp=sharing) provided in assignment.

1. Intutive and descriptive analysis done over full dataset of more than 39 million object's.

2. Deployed the application on AWS EC2 instance (shiny server on ubuntu environment).

3. Some of the shiny components are customized through css or javascript.
    1. Sidebar
    2. Header
    3. Color theme
    4. custom value box
    5. Get selected word from wordcloud
    6. Object Popup on click of image in all view(s)
    
    </br>
4. Three different visualization created
    1. Gallery View - Only object(s) with available images are displayed. On clicking the image, popup will appear
    2. Table view - Option to view all data set or only with available images. On clicking the image, popup will appear
    3. Map View - Markers will appear on map based on selection. On click of every marker image, object link will popup. On clicking the image, popup will appear
    
     </br>
5. Loader is copied from Gmail footer and Logo from google images


Optimization Technique
-----------------------
1. Distributed data set of more than 39 millon record(s) divided into 37 occurence file through R script.

2. Files were divided on the basis of 'scientific name'.

3. Get 'count vs attribute' file for location`location.csv`, vernacular name`vernacularName.csv`, scientific name`scientificName.csv` and taxon rank `taxonRank.json`.

4. Created `mapping.json` where scientific names are mapped with occurence file(s) based on the item number in list.

5. Created 2nd mapping file `vern_scien.csv` to map vernacular name with scientific name.

6. Get an analytic report out of the data, stored in `distinct_stats.json` for fast loading.

7. Extract transformed data from the [link](https://appsilon-dataset.s3.eu-central-1.amazonaws.com/occurence.zip) to Data folder 

What can be done to make it real time
----------------------------------------------------
Add dataset file to AWS S3 bucket and trigger a lamnda function (with R docker image) to get stats and distributed file out of it



EDA Tab
----------------------------------------------------
1. Upload csv file
2. Validate data types
3. Based on different attribute different analysis chart have been created


Univariate Attribute
----------------------------------------------------
1. Text Attribute - pie and bar
2. Numeric Attribute - density histogram
3. Time frame attribute - trend and bar chart

bivariate Attribute
----------------------------------------------------
1. Text vs Text -> Donought Chart, Group Bar Chart, Stack Bar Chart
2. Text vs Numeric -> Buble chart, Grouped bar chart
3. Text vs Timeframe -> Line Chart, Trend Chart
4. Numeric vs Numeric -> density chart