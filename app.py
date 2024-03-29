# import streamlit as st
# import os
# from dotenv import load_dotenv
# from PyPDF2 import PdfReader
# from langchain.text_splitter import CharacterTextSplitter
# from langchain.embeddings import OpenAIEmbeddings
# # FAISS runs locally saves the embeddings on the local machine.
# from langchain.vectorstores import FAISS
# from langchain.chat_models import ChatOpenAI
# from langchain.memory import ConversationBufferMemory
# from langchain.chains import ConversationalRetrievalChain
# from htmlTemplates import css, bot_template, user_template
# from langchain.llms import HuggingFaceHub

# # Function to return extracted values of the pdf.
# def get_pdf_text(pdf_docs):
#     text = ""
#     for pdf in pdf_docs:
#         pdf_reader = PdfReader(pdf)
#         for page in pdf_reader.pages:
#             text += page.extract_text()
#     return text

# # Function to return chunks of data from the extracted pdf data.
# def get_text_chunks(text):
#     text_splitter = CharacterTextSplitter(
#         separator="\n",
#         chunk_size=1000,
#         chunk_overlap=200,
#         length_function=len
#     )
#     chunks = text_splitter.split_text(text)
#     return chunks

# # Function to get vector data from the text chunks.
# def get_vectorstore(text_chunks):
#     embeddings = OpenAIEmbeddings()
#     # For free embeddings creation since OpenAIEmbeddings is paid service.
#     # embeddings = HuggingFaceInstructEmbeddings(model_name="hkunlp/instructor-xl")
#     vectorstore = FAISS.from_texts(texts=text_chunks, embedding=embeddings)
#     return vectorstore

# # Function for the conversation chain.
# def get_conversation_chain(vectorstore):
#     llm = ChatOpenAI()
#     # llm = HuggingFaceHub(repo_id="google/flan-t5-xxl", model_kwargs={"temperature":0.5, "max_length":512})

#     memory = ConversationBufferMemory(
#         memory_key='chat_history', return_messages=True)
#     conversation_chain = ConversationalRetrievalChain.from_llm(
#         llm=llm,
#         retriever=vectorstore.as_retriever(),
#         memory=memory
#     )
#     return conversation_chain

# # To handle the user input and repsonse for continous chat.
# def handle_userinput(user_question):
#     response = st.session_state.conversation({'question': user_question})
#     st.session_state.chat_history = response['chat_history']

#     for i, message in enumerate(st.session_state.chat_history):
#         if i % 2 == 0:
#             st.write(user_template.replace(
#                 "{{MSG}}", message.content), unsafe_allow_html=True)
#         else:
#             st.write(bot_template.replace(
#                 "{{MSG}}", message.content), unsafe_allow_html=True)


# def main():
#     load_dotenv()
#     st.set_page_config(page_title="Ask Jake!",
#                        page_icon="https://www.statefarm.com/content/dam/sf-library/en-us/secure/legacy/state-farm/SF_Logo_Red_Standard_Horzintal.png")
#     st.write(css, unsafe_allow_html=True)

#     if "conversation" not in st.session_state:
#         st.session_state.conversation = None
#     if "chat_history" not in st.session_state:
#         st.session_state.chat_history = None

#     st.image('data\SF_Logo_Red_Standard_Horzintal.png')
#     st.header("Ask Jake!")


#     folder_path = "data"
#     pdf_docs = []
#     for filename in os.listdir(folder_path):
#         if filename.endswith(".pdf"):
#             file_path = os.path.join(folder_path, filename)
#             pdf_docs.append(file_path)
    
#     raw_text = get_pdf_text(pdf_docs)

#     # get the text chunks
#     text_chunks = get_text_chunks(raw_text)

#     user_question = st.text_input("How can I assist yout today?")
    
#     if user_question:
#         handle_userinput(user_question)
#         # Now you can process the PDF documents in the `pdf_docs` list


#     # create vector store
#     vectorstore = get_vectorstore(text_chunks)

#     # create conversation chain
#     st.session_state.conversation = get_conversation_chain(
#             vectorstore)

# if __name__ == '__main__':
#     main()
import streamlit as st
from dotenv import load_dotenv
from PyPDF2 import PdfReader
from langchain.text_splitter import CharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
# FAISS runs locally saves the embeddings on the local machine.
from langchain.vectorstores import FAISS
from langchain.chat_models import ChatOpenAI
from langchain.memory import ConversationBufferMemory
from langchain.chains import ConversationalRetrievalChain
# from htmlTemplates import css, bot_template, user_template
from langchain.llms import HuggingFaceHub
import os
from flask import Flask, request, jsonify


conversation_state = {
    'conversation': None,  
    'chat_history': []
}

# Function to return extracted values of the pdf.
def get_pdf_text(pdf_docs):
    text = ""
    for pdf in pdf_docs:
        pdf_reader = PdfReader(pdf)
        for page in pdf_reader.pages:
            text += page.extract_text()
    return text

# Function to return chunks of data from the extracted pdf data.
def get_text_chunks(text):
    text_splitter = CharacterTextSplitter(
        separator="\n",
        chunk_size=1000,
        chunk_overlap=200,
        length_function=len
    )
    chunks = text_splitter.split_text(text)
    return chunks

# Function to get vector data from the text chunks.
def get_vectorstore(text_chunks):
    embeddings = OpenAIEmbeddings()
    # For free embeddings creation since OpenAIEmbeddings is paid service.
    # embeddings = HuggingFaceInstructEmbeddings(model_name="hkunlp/instructor-xl")
    vectorstore = FAISS.from_texts(texts=text_chunks, embedding=embeddings)
    return vectorstore

# Function for the conversation chain.
def get_conversation_chain(vectorstore):
    llm = ChatOpenAI()
    # llm = HuggingFaceHub(repo_id="google/flan-t5-xxl", model_kwargs={"temperature":0.5, "max_length":512})

    memory = ConversationBufferMemory(
        memory_key='chat_history', return_messages=True)
    conversation_chain = ConversationalRetrievalChain.from_llm(
        llm=llm,
        retriever=vectorstore.as_retriever(),
        memory=memory
    )
    return conversation_chain

# To handle the user input and repsonse for continous chat.
# def handle_userinput(user_question):
#     response = st.session_state.conversation({'question': user_question})
#     st.session_state.chat_history = response['chat_history']

#     for i, message in enumerate(st.session_state.chat_history):
#         if i % 2 == 0:
#             st.write(user_template.replace(
#                 "{{MSG}}", message.content), unsafe_allow_html=True)
#         else:
#             st.write(bot_template.replace(
#                 "{{MSG}}", message.content), unsafe_allow_html=True)

app = Flask(__name__)
def conversation(question_data):
    
    user_question = question_data['question']
    return {"chat_history": ["User: " + user_question, "Bot: Response to the question."]}

def ChatWebsite(conversation, user_question):
    response = conversation({'question': user_question})
    chat_history = response['chat_history']
    for i, message in enumerate(chat_history[-2:]):
        if i % 2 == 0:
            pass
        else:
            return message  

@app.route('/handle_userinput', methods=['POST'])
def handle_userinput():
    data = request.json
    user_question = data.get('question')

    if not user_question:
        return jsonify({'error': 'No question provided'}), 400

    # Get the bot's response using ChatWebsite function
    bot_response = ChatWebsite(conversation, user_question)

    return jsonify({'bot_response': bot_response})

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})
    
    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No selected file'})

    if file and allowed_file(file.filename):
        
        raw_text = get_pdf_text(file.stream)
        text_chunks = get_text_chunks(raw_text)  
        vectorstore = get_vectorstore(text_chunks)  
        conversation_chain = get_conversation_chain(vectorstore)  
        

        return jsonify({'message': 'Test'})

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ['pdf']

if __name__ == '__main__':
    app.run(debug=True)


# def main():
#     load_dotenv()
#     st.set_page_config(page_title="JakeAI",
#                        page_icon="https://www.statefarm.com/content/dam/sf-library/en-us/secure/legacy/state-farm/SF_Logo_Red_Standard_Horzintal.png")
#     st.write(css, unsafe_allow_html=True)

    # if "conversation" not in st.session_state:
    #     st.session_state.conversation = None
    # if "chat_history" not in st.session_state:
    #     st.session_state.chat_history = None

#     st.image('data\SF_Logo_Red_Standard_Horzintal.png')
#     st.header("Ask Jake!")
#     user_question = st.text_input("How can I assist yout today?")
#     if user_question:
#         handle_userinput(user_question)

#     with st.sidebar:
#         st.subheader("Your documents")
#         pdf_docs = st.file_uploader(
#             "Upload your PDFs here and click on 'Process'", accept_multiple_files=True)
#         if st.button("Process"):
#             with st.spinner("Processing"):
#                 # get pdf text
#                 raw_text = get_pdf_text(pdf_docs)

#                 # get the text chunks
#                 text_chunks = get_text_chunks(raw_text)

#                 # create vector store
#                 vectorstore = get_vectorstore(text_chunks)

#                 # create conversation chain
#                 st.session_state.conversation = get_conversation_chain(
#                     vectorstore)


if __name__ == '__main__':
    main()
