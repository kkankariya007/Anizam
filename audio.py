from fastapi import FastAPI,File, UploadFile
# import fastapi
import io


app=FastAPI()

@app.post("/")
async def savefile(file: bytes=File(...)):
    s = io.BytesIO(file)
    with open("audi.wav", "wb") as f:
        f.write(s.getbuffer())
    return {"size of file":len(file)}