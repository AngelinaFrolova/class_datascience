import streamlit as st
import pandas as pd

# Assuming df_yield is your DataFrame
url = 'https://raw.githubusercontent.com/michalis0/MGT-502-Data-Science-and-Machine-Learning/main/data/yield_df.csv'
df_yield = pd.read_csv(url)

# Create a Streamlit app
st.write("""
# Shares of Crops
""")

# Display the raw DataFrame for debugging
st.write(df_yield)

# Check if df_yield is not empty
if not df_yield.empty:
    # Plot the pie chart directly using Streamlit's st.pyplot()
    st.pyplot(plt.pie(df_yield['Item'].value_counts().values, labels=df_yield['Item'].value_counts().index, autopct='%1.1f%%'))
else:
    st.write("Error: DataFrame is empty.")
