import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

# Assuming df_yield is your DataFrame
data = df_yield['Item'].value_counts()

# Create a Streamlit app
st.write("""
# Shares of Crops
""")

# Create a matplotlib figure
fig, ax = plt.subplots(figsize=(8, 8))
ax.set_title('Shares of crops')

# Use Pastel1 colormap
cmap = plt.get_cmap('Pastel1')
colors = cmap(range(len(data)))

# Plot the pie chart
ax.pie(data.values, labels=data.index, colors=colors, autopct='%1.1f%%')

# Display the chart using Streamlit's st.pyplot()
st.pyplot(fig)


