import streamlit as st
import pandas as pd

# Assuming df_yield is your DataFrame
data = df_yield['Item'].value_counts()

# Create a Streamlit app
st.write("""
# Shares of Crops
""")

# Plot the pie chart directly using Streamlit's st.pyplot()
st.pyplot(plt.pie(data.values, labels=data.index, autopct='%1.1f%%'))


# Display the chart using Streamlit's st.pyplot()
st.pyplot(fig)


