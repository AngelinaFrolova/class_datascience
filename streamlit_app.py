import streamlit as st
import pandas as pd

# Assuming df_yield is your DataFrame
data = df_yield['Item'].value_counts()

# Streamlit app
st.title('Shares of crops')

# Use Pastel1 colormap for better visualization
colors = st.color_palette("Pastel1", len(data))

# Plotting the pie chart
fig, ax = plt.subplots(figsize=(8, 8))

# Display the pie chart using Streamlit
st.pie(data, labels=data.index, colors=colors, autopct='%1.1f%%')
