from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
from dotenv import load_dotenv
from Text_summarization import Summarization
from Word_meanings import word_meaning
from translator import language_translation
from Chat_with_website import VectorizationURL, ChatWebsite
from Chat_with_GPT import ChatApp
from txt_to_speech import T_T_speech
#pythfrom database import add_word, get_dictionary

app = Flask(__name__)
CORS(app)

@app.route("/members", methods=['GET'])
def members():
    return {"members": ["Member1", "Member2", "Member3"]}

@app.route("/definition", methods=['POST'])
def definition():
    data = request.get_json()
    user_word = data.get('word')
    return jsonify({"response": word_meaning(user_word)}) #return the summarize function here

@app.route("/summarize", methods=['POST'])
def summarize():
    data = request.get_json()
    para = data.get('para')
    return jsonify({"response": Summarization(para)}) #return the summarize function here.

@app.route("/translate", methods=['POST'])
def translate():
    data = request.get_json()
    para = data.get('para')
    language = data.get('lang')
    return jsonify({"response": language_translation(para, language)}) #return the summarize function here.

@app.route("/webchat", methods =['POST'])
def webchat():
    data = request.get_json()
    message = data.get('text')
    url = data.get('webLink')
    conversation = VectorizationURL(url)
    response = ChatWebsite(conversation, message)
    return jsonify({"response": response})

@app.route("/gptchat", methods =['POST'])
def gptchat():
    data = request.get_json()
    message = data.get('text')
    chat_app = ChatApp()

    assistant_response = chat_app.chat(message)
    response = assistant_response['content']

    return jsonify({"response": response})

# needs to be edited.
@app.route("/tts", methods =['POST'])
def txtSpeech():
    data = request.get_json()
    message = data.get('para')
    T_T_speech(message)
    audio_path = './read_aloud.mp3'
    return send_file(audio_path, as_attachment=True)

@app.route("/flashcards", methods=['GET'])
def flashcards():
    return([{"term":"Invest", "definition":"To take interest and participate in something"},
            {"term":"Invest", "definition":"To take interest and participate in something"},
            {"term":"Invest", "definition":"To take interest and participate in something"},
            {"term":"Invest", "definition":"To take interest and participate in something"},
            {"term":"Invest", "definition":"To take interest and participate in something"}])

'''@app.route("/addcard", methods=['POST'])
def addcard():
    data = request.get_json()
    word = data.get('word')
    definition = data.get('def')
    add_word(word, definition)
'''
if __name__ == "__main__":
    app.run(debug = True)