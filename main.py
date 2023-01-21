from fastapi import FastAPI,File
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
import difflib
import speech_recognition as sr
filename = "audi.wav"
import io


app = FastAPI()

origins = [
    "http://localhost.tiangolo.com",
    "https://localhost.tiangolo.com",
    "http://localhost",
    "http://localhost:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# @app.get("/")
# async def root():
#     return {"message": "Hello World"}

@app.get("/name")
async def savefile(file: bytes=File(...)):
    s = io.BytesIO(file)
    with open("audi .wav", "wb") as f:
        f.write(s.getbuffer())

    df=pd.read_csv("AnimeQuotes.csv")

    r = sr.Recognizer()
    with sr.AudioFile(filename) as source:
        audio_data = r.record(source)
        word = r.recognize_google(audio_data)
        print(word)

    predict=difflib.get_close_matches(word,df.Quote, n=1, cutoff=0.5)

    if(len(predict)!=0):
        for i in predict:
            # print(i)
            for j in df.index:
                if(i==df['Quote'][j]):
                    print(df['Name'][j])
                    print(df['Anime'][j])
                    return {df['Name'][j]:df['Anime'][j]}
                    break
    else:
        return {"0":"Please be more accurate"}

