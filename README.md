# Customer-revenue-prediction
## Executive Summary
The aim of this project is two-fold, analyzing the customer behavior and predicting each customer’s transaction revenue. Generalized linear model (GLM) is used for customer behavior analysis, and in order to get deeper into shopping channels, Markov Chain Model is used to identify significant channels for first-time users and returning users. A two-stage model consisting of Logistic Regression and Linear Regression is adopted for revenue prediction. For prediction models, the logistic model has 98% of prediction accuracy in classifying the customers who are likely to make a purchase from those who do not and gives the probability values whereas the Linear Regression model identifies the value of each transaction made by the customer and it has an RMSE value of 1.19.

The customer behavior has been analyzed from the interpretation model and some insights such as ideal time of sale which is around 4PM to 6PM, Countries and Cities that generate maximum revenue such as New York, San Francisco and Chicago , the quarter that generated maximum sale (second quarter) have been identified.

Based on the analysis that was carried out some recommendations are provided such as: (1) reconsideration budget allocated to each channel; (2) need for improvement of the interface design, especially for bowser Firefox and Chrome; (3) engaging the regular visitors by offer promotion; (4) ensuring enough inventory for peak visit time, and also the maintenance of the website.

## Data Understanding 
An online-store dataset split into training and testing datasets was provided, which contains 451,626 and 452,027 records respectively. Twelve variables were presented including 4 JSON columns. R programming is used for developing the model.

## Data Preparation
The data provided had missing values (NA’s), variables containing multiple fields and variables with only one level of data. Thereby data cleaning was adopted to replace the NA values with zeros, flattening the JSON fields into individual variables, eliminating the variables with only one level of data. R and Rstudio platform are used in this process and in the following analysis.

For categorical variables, according to frequency tables, values which occurred frequently were aggregated to multiple levels, whereas other values that were not so frequent was aggregated to a level called ‘Others’. For continuous variables, missing data were replaced by median value. However, missing values in transaction revenue were replaced with 0.

Variables that have only one level which is “not available in demo dataset” were deleted, along with variables that have more than 60% missing data, for they were not informative for prediction or user behavior analysis. After cleaning the data, dummy coding was implemented on all the categorical variables for the convenience of analysis and modeling.

## Modeling
## Interpretation Model 
For interpretation, generalized linear regression model (a conventional model for a continuous response variable/dependent variable with categorical and continuous predictors) was established to understand how the customer behaviors and geographical factors influence the transaction revenue.The dependent variable is log(transaction revenue+1).

Due to the results of correlation procedure and their importance to business decisions, ten variables were included into the model: channel grouping, browser, device category, the hours of visit start time, new visit, visit number, quarter, country, city and pageviews. To get greater insight into customer behaviors, six types of the channel groups and four types of browsers were adopted based on their frequency; ten countries and four cities were adopted based on their total amount of transaction revenue. Moreover, considering the diminishing value of pageviews, after a turning point, the more pageviews will lead to less marginal effect on transaction revenue, the square of pageviews was also included into the model.

To further understanding how marketing channels contributions in different scenario Markov Chain method (Appendix VII) is used to do attribution analysis. Transaction revenue is recorded as 1 and 0;one transaction is recognized as one success conversion; one fullvisitorId is one unique customer. After arranging data by date in ascending order, customers who generate revenues were grouped as first_purchase customer and returning customer. For example, customer 1 and customer 2 got touch with the website from several channels (1:social>referral>organic research> first transaction) (2:display>referral> first transaction )before finally making a purchase. We take all those purchase paths and each point (channel) of one path into consideration. Markov chain method is applied here to calculate the how many weighted transactions each channel contributed.

## Revenue Prediction Model
To capture the purchase probability, Logistic Regression is carried out initially, which is used to predict binary response from a binary predictor (target = 0 or 1), and predict the outcome of a categorical dependent variable based on one or more predictor variables. Information Value has been used to determine the predictive power / strength of different variables.

To calculate the conditional purchase amount, after filtering out the records where the transaction revenue equals zero, the rest of the data, referred as conditional training data set, is adopted to train predictive model. In order to improve prediction accuracy, stepwise selection is used with the lowest AIC. 
