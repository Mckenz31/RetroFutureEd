from flask import Flask, request, jsonify
from flask_cors import CORS
from openai import OpenAI
import os
from dotenv import load_dotenv
import json
import requests
from personalities import personalities 

load_dotenv()

# openai.api_key = os.getenv("OPENAI_API_KEY")

app = Flask(__name__)
CORS(app)

client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))

@app.route("/members", methods=['POST'])
def members():
    data = request.json
    personality_name = data.get('name')
    if personality_name:
        response = simulate_conversation(personality_name)
        return jsonify({"response": response})
    else:
        return jsonify({"error": "Personality name not provided"}), 400

def simulate_conversation(personality_name, user_messages=[]):
    personality_info = personalities.get(personality_name)

    if not personality_info:
        return "I'm sorry, I don't have information on that personality."

    bio = ("Background: " + personality_info.get('Background', '') + "\n" +
           "Personality: " + personality_info.get('Personality', '') + "\n" +
           "Communication Style: " + personality_info.get('Communication Style', ''))

    system_message = {
        "role": "system", 
        "content": "You are a chatbot that simulates a conversation with the personality of " + 
                   personality_name + " as described. Please respond in a manner consistent with this personality's known communication style. " + 
                   "The current person's personality is based on this bio:\n" + bio + "Do not generate any response here"
    }

    messages = [system_message] + user_messages
    print(messages)

    try:
        chat_completion = client.chat.completions.create(
            messages=messages,
            model="gpt-4",
        )
        # Check the structure of the response and extract the content
        if hasattr(chat_completion, 'choices') and chat_completion.choices:
            if hasattr(chat_completion.choices[0], 'message') and chat_completion.choices[0].message:
                return chat_completion.choices[0].message.content
            else:
                return "No message content found."
        else:
            return "No choices found in the response."
    except Exception as e:
        print(f"An error occurred: {e}")
        return ""


@app.route("/process_question", methods=['POST'])
def process_question():
    data = request.json
    user_question = data.get('question')
    personality = data.get('personality')  
    print(personality)

    if user_question:
        user_message = {"role": "user", "content": user_question}
        response = simulate_conversation(personality, [user_message])  
        return jsonify({"response": response})
    else:
        return jsonify({"error": "No question provided"}), 400


if __name__ == "__main__":
    app.run(debug = True)


# @app.route("/gpt", methods=['POST'])
# def gpt():
#     data = request.get_json()
#     user_question = data.get('question')

#     if user_question:
#         conversation_history = data.get('textHistory', [])  
#         conversation_history.append({"role": "user", "content": user_question})

#         personality = data.get('personality', "Elon Musk")  
#         bio = data.get('bio')

#         response = simulate_conversation(personality, conversation_history, bio)

#         return jsonify({"response": response, "textHistory": conversation_history})

#     return jsonify({"error": "Invalid request"}), 400



