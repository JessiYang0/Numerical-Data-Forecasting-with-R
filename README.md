# Numerical-Data-Forecasting-with-R
To analyze whether a patient will be rehospitalized (a binary classification problem).

# Data
Each patient's data, including gender, age, weight, etc., totals 70,000 records with 48 features.

# Feature Engineering
Features are categorized into categorical data and numerical data, each with different methods of analysis and processing.

## categorical data (feature)
* medical_specialty


  ** There are too many types of this feature, which raises concerns about the potential for noise generation. 

  ** The box plot reveals the relationship between each category of 'medical_specialty' and the target variable 'readmitted'. The x-axis represents the target variable 'readmitted', and the y-axis represents each category within the 'medical_specialty' feature. The red dots indicate the average number of readmissions for each category, showing where the average readmission falls for each category. Categories with similar averages of readmitted, such as 'Resident' and 'AllergyandImmunology' which both have averages around 1.5, are grouped together into one category.

## numerical data (feature)
