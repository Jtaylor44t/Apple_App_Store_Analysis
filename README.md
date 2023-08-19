# Apple_App_Store_Analysis

I used sqliteonline.com for this project. It is a browser based SQL IDE. You can upload your data directly to it and immediately begin querying it.
It also has a built in function that allows you to display your query results as graphs/charts. That's why some select statements may have graph types 
in front of them like 'BAR-SELECT' and 'LINE-SELECT'. This represents the query result as the respected chart type when ran.

I wanted to put the raw code into this repository and also a pdf that includes the graphs/charts under the query results so they are visible and easy to understand.
So there will be a file with the raw code, and a PDF with the graphs/charts included under the code blocks.

I wanted to make this analysis practical, so I'm using a fictional stakeholder to give myself some accountability and a clear purpose of this analysis. 

My fictional stake holder is an aspiring app developer looking into building an app. They need some questions answered first:
1) what app categories are the most popular? 
2) what price should they set? 
3) how can they maximize user ratings?

I answered these questions using Exploratory Data Analysis (EDA). 
Here are some of the steps I took:
1) I checked the number of unique apps in both tables
2) I performed some basic data cleaning (checked for any missing/NULL values in some key fields).
3) I found out the number of apps per genre
4) I got an overview of the apps' ratings (minimum, maximum, and average user rating).
5) I checked to see if paid apps had a higher average rating than free apps.
6) I checked to see if apps with more supported languages had higher ratings.
7) I checked the genres with the lowest ratings. (This was a good way to see what app categories don't have much competition).
8) I checked for correlation between length of app description and the user rating
        - I did this by joining the two tables together by the id(which was the key present in both tables)
9) I checked the top-rated apps for each genre by using a window function in a sub-query.
10) I checked the most expensive app in each genre and it's user rating.
11) After that I wanted to explore if the number of devices an app supported had anything to do with increased success/user ratings of the app.
        - I did this by finding out the minimum, maximum, and average number of devices supported by apps.
12) I then checked if more supported devices meant a higher average rating. 

Top insights 
1) Paid apps have better ratings 
2) apps supporting between 10 and 30 languages have better ratings 
3) finance and book apps have low ratings 
4) apps with a longer description have better ratings 
5) a new app should aim for an average rating above 3.5 
6) games and entertainment have high competition

Conclusion for the client/stakeholder:
Since there are quite a few genres with low average user ratings, there might be good opportunity in these genres to make a good functioning app.
There represents a good market opportunity where user's needs are not being met. If you can create a quality app in these categories that better address the user needs than the current offerings,
there is a strong potential for high user ratings and market penetration. 
