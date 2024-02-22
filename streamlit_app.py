import streamlit as st
import pandas as pd

url = 'https://raw.githubusercontent.com/michalis0/MGT-502-Data-Science-and-Machine-Learning/main/data/yield_df.csv'
df_yield= pd.read_csv(url)

# Assuming df_yield is your DataFrame
data = df_yield['Item'].value_counts()

# Streamlit app
st.title('Shares of crops')

# Display the pie chart using Streamlit
st.pie_chart(data)


# Display the pie chart using Streamlit
st.pyplot(fig)

