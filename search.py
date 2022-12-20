import pandas as pd
import difflib

df=pd.read_csv("AnimeQuotes.csv")
# print(df.head())
word="All we can do is live Contrand fly free"

predict=difflib.get_close_matches(word,df.Quote, n=1, cutoff=0.5)

if(len(predict)!=0):
    for i in predict:
        print(i)
else:
    print("Please be more accurate")