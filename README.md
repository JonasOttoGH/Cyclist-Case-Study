# Cyclitic-Case-Study
The cyclist case study is the capstone project the Google Data Analytics Professional Certificate.

This is my first project on processing data through Excel and SQL. Finally using Tableau to show the visualizations of the given data.

Introduction
For the capstone project, I have selected the ‘Cyclitic Bike Share Analysis Case Study’ to work on. For the case study, I will perform the real-world tasks of a junior data analyst for the marketing team at Cyclistic, a bike-share company in Chicago.
To answer key business questions, I followed the six steps of the data analysis process taught in the course which are: Ask, Prepare, Process, Analyse, Share and Act.

1. Ask: Identify the business task:
Strategy to maximize the number of annual memberships by converting casual riders into annual riders.
Stakeholder perspective:
The company believes that the future of the company depends on maximising the number of annual memberships. Instead of than using a marketing campaign to target new customers, rather focus on converting casual riders into members.

Questions to Analyse:
How do annual members and casual riders use Cyclistic bikes differently?
Why would casual riders buy Cyclistic annual memberships?
How can Cyclistic use digital media to influence casual riders to become members?

2. Prepare: 
Twelve months of dataset from 2019 were extracted as 4 zipped .cvs files. 
3. Process:
Tools used to process:
- Original files are backed up in a separate folder.
- Microsoft Excel
- Microsoft SQL server

As the 4 datasets combined contain over a few million rows of data and as excels limitations is just over a million rows, I would use Microsoft SQL server to preform most of my tasks. 

Data verification using Microsoft Excel:
- Replace empty cells with "NULL" 
- Check for any invalid and unusable data and remove them if necessary
- Create a column named 'ride length' which calculates the ride length of each ride.
- Create a column named 'Day_of_week' to calculate the day of each week that the ride took place
- Filter columns for any abnormal data

Data cleaning and verification using Microsoft SQL: (Script for this process can be viewed in the attached document)
- I started with a few SELECT statements to double check the data
- Next I altered columns by using DROP to get rid of column F16 in two of the files
- Then I used ALTER TABLE to make a standardised date in a separate column for each file

- I then proceeded with the WITH clause, as I thought it was better modularize each sub-query block by giving a name each so that it will be clearer for extraction in the later part.
- For the first sub-query, by using the UNION command, 12 month datasets are then combined to form a yearly dataset.
- Then, I started to aggregate the data. To find out the ride length of each ride, DATEDIFF clause was used and defined in MINUTE. CASE clause is used to convert given condition into different strings from Monday to Sunday.
- To make sure that all the ride_id only contained 16 characters, LEN command is used. There are some ride length which is less than 1 minutes. Those will be treated as error rides and filtered out.
- Finally I created a final table with including all the useful information

4. Analyse Data (Script for this process can be viewed in the attached document):
For this step of the process I continued to use Microsoft SQL and continued to run with the CTE created earlier.
- I queried the total amount of user types (Subscriber/Customer) using bikes first using the COUNT function
- I then queried the total amount of user types using bikes for each day of the week using the COUNT function
- Next I queried average ride times and total ride times for user types (subscriber/customer) using the AVG and SUM functions
- I then queried ride times for (subscriber/customer) per date using the COUNT function

5. Sharing Insights:
For this step I used Tableau to visualize my data and create a dashboard.
Link to dashboard: https://public.tableau.com/views/CyclistCaseStudyDashboard/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link

6. Act:
Summary of the insights gained from Tableau Visualization
- The length of ride time for casual riders (customers) is relativity shorter than members. This might be due to short ride transit from train stations to their offices / home for member rider type.
- Ridership for both riders (customers and subscribers) peak in the summer months as amount of riders correlate with seasonal changes. 
- Casual customers ridership peaks on Saturday, Sunday and Monday which is most likely due to weekends and Monday public holidays.
- Around three quarters of the riders are members, indicating that the company have already sustained some level of loyalty among their bike users. Thus, the company has chance to convert more casual riders to members.

My recommendations for the company using the analysed data would be:
- If a marketing campaign were to be done then I would recommend that this is to be done before the summer months of the calendar year as this is when most ridership’s take place.
- As casual members peak in weekends and Monday long weekend/weekend promotions could be considered.
- Although subscribers make up more than 3/4 of the yearly ridership, total hours ridden are almost the same meaning that some sort of incitive could be done around ride time and membership or price.
