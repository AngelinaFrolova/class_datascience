import streamlit as st
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
import numpy as np

# Load the water quality data
url_water = 'https://raw.githubusercontent.com/michalis0/MGT-502-Data-Science-and-Machine-Learning/main/data/waterQuality1.csv'
df_water = pd.read_csv(url_water)

# Features (X) and target variable (y)
Xw = df_water.drop('Potability', axis=1)
yw = df_water['Potability']

# Split data set into a train and a test data sets
Xw_train, Xw_test, yw_train, yw_test = train_test_split(Xw, yw, test_size=0.2, random_state=39, shuffle=True)

# Define the scaler
scaler = StandardScaler()

# Fit the scaler
scaler.fit(Xw_train)

# Transform the train and the test set
Xw_train = scaler.transform(Xw_train)
Xw_test = scaler.transform(Xw_test)

# Set up our model
modelw = LogisticRegression(penalty='l2', solver='lbfgs', max_iter=1000)

# Fit our model
modelw.fit(Xw_train, yw_train)

# Streamlit app
st.title('Water Potability Prediction')

# Input form for user to enter chemical elements and impurities
ph = st.slider('pH Value', min_value=0.0, max_value=14.0, step=0.1, value=7.0)
hardness = st.slider('Hardness', min_value=0, max_value=400, step=1, value=200)
# Add more sliders or input fields for other features

# Create a user input DataFrame
user_input = pd.DataFrame({
    'ph': [ph],
    'Hardness': [hardness],
    # Add more columns for other features
})

# Scale the user input using the same scaler
user_input_scaled = scaler.transform(user_input)

# Make prediction
prediction = modelw.predict(user_input_scaled)

# Display prediction result
if prediction[0] == 1:
    st.write('Prediction: This water sample is unsafe.')
else:
    st.write('Prediction: This water sample is safe.')
