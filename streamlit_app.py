import pandas as pd
import numpy as np

st.write("""
#CROPS YIELD DATA VISUALIZATION

based on rainfall, average temperature and pesticides used

""")

url = 'https://raw.githubusercontent.com/michalis0/MGT-502-Data-Science-and-Machine-Learning/main/data/yield_df.csv'
df_yield= pd.read_csv(url)

st.area_chart(data=df_yield, x=Year, y=hg/ha_yield, use_container_width=True)
