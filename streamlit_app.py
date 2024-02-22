pip install matplotlib

import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

# Assuming df_yield is your DataFrame
url = 'https://raw.githubusercontent.com/michalis0/MGT-502-Data-Science-and-Machine-Learning/main/data/yield_df.csv'
df_yield = pd.read_csv(url)

# Assuming df_yield is your DataFrame
data = df_yield['Item'].value_counts()

# Streamlit app
st.title('Shares of crops')

# Use Pastel1 colormap for better visualization
cmap = plt.get_cmap('Pastel1')
colors = cmap(range(len(data)))

# Plotting the pie chart
fig, ax = plt.subplots(figsize=(8, 8))
ax.pie(data.values, labels=data.index, colors=colors, autopct='%1.1f%%')

# Display the pie chart using Streamlit
st.pyplot(fig)
