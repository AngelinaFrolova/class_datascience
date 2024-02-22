import streamlit as st
import pandas as pd

url = 'https://raw.githubusercontent.com/michalis0/MGT-502-Data-Science-and-Machine-Learning/main/data/yield_df.csv'
df_yield= pd.read_csv(url)
data = df_yield['Item'].value_counts()

# Streamlit app
st.title('Shares of crops')

# Plotting the pie chart
fig, ax = plt.subplots(figsize=(8, 8))

# Display the pie chart using Streamlit
st.pyplot(fig)
