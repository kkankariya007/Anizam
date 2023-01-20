import pandas as pd
import difflib

df=pd.read_csv("AnimeQuotes.csv")

word=" like a wound The wound may heal but "

predict=difflib.get_close_matches(word,df.Quote, n=1, cutoff=0.5)

if(len(predict)!=0):
    for i in predict:
        # print(i)
        for j in df.index:
            if(i==df['Quote'][j]):
                print(df['Name'][j])
                print(df['Anime'][j])
                break
else:
    print("Please be more accurate")