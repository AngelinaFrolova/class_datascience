import streamlit as st
import pandas as pd

url = 'https://raw.githubusercontent.com/michalis0/MGT-502-Data-Science-and-Machine-Learning/main/data/yield_df.csv'
df_yield= pd.read_csv(url)

data = df_yield['Item'].value_counts()

# Streamlit app
st.title('Shares of crops')

# Use Pastel1 colormap for better visualization
colors = st.get_option("theme.colorway")

# Plotting the pie chart
fig, ax = plt.subplots(figsize=(8, 8))

# Display the pie chart using Streamlit
st.pie(data, labels=data.index, colors=colors, autopct='%1.1f%%')

