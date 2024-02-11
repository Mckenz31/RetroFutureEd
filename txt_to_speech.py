from gtts import gTTS
import os

def T_T_speech(mytext, Language = 'en'):

    # have a high speed
    myobj = gTTS(text = mytext, lang = Language, slow=False)

    # Saving the converted audio in a mp3 file named
    myobj.save("read_aloud.mp3")
    os.system("read_aloud.mp3")

# T_T_speech("Hello I how are you")