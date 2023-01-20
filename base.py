import speech_recognition as sr
from os import path
from pydub import AudioSegment

src = "audi.mp3"

# filename = ".wav"
filename = "fin.wav"

# convert wav to mp3                                                            
sound = AudioSegment.from_mp3(src)
sound.export(filename, format="wav")


r = sr.Recognizer()
with sr.AudioFile(filename) as source:
    audio_data = r.record(source)
    text = r.recognize_google(audio_data)
    print(type(text))
    print(text)
                                                                         
