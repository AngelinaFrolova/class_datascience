import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

url = 'https://raw.githubusercontent.com/michalis0/MGT-502-Data-Science-and-Machine-Learning/main/data/yield_df.csv'
df_yield= pd.read_csv(url)

# Assuming df_yield is your DataFrame
data = df_yield['Item'].value_counts()

# Streamlit app
st.title('Shares of crops')

# Define a Pastel1 colormap for better visualization
pastel1_colors = ['#fbb4ae', '#b3cde3', '#ccebc5', '#decbe4', '#fed9a6', '#ffffcc', '#e5d8bd', '#fddaec']

# Plotting the pie chart
fig, ax = plt.subplots(figsize=(8, 8))
ax.pie(data, labels=data.index, colors=pastel1_colors, autopct='%1.1f%%')

# Display the pie chart using Streamlit
st.pyplot(fig)

