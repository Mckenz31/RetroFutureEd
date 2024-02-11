from gtts import gTTS
import os
import speech_recognition as sr
import openai 
from dotenv import load_dotenv

load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

role = input("What kind of role are you interviewing for? ")
job_description = input("Please provide a brief job description: ")
questionnaire_type = input("Do you prefer a technical or behavioral questionnaire? ")
num_questions = input("How many questions do you expect in the test?")

interview_info = {
    "Role": role,
    "Job Description": job_description,
    "Questionnaire Type": questionnaire_type,
    "No. of Questions": num_questions
}

def feedback(final_interview_data):
    prompt = f"Based on the information in {final_interview_data} dictionary Use the star framework and analyze the answers by the candidate for each of the questions, and prepare a feedback as an interviewee of this particular role, highlighting action items, reading links or YouTube links for the candidate in a clear and concise manner."

    messages = [
        {"role": "system", "content": prompt}
    ]

    try:
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=messages
        )

        # Split the response into a list of questions
        questions_list = response.choices[0].message["content"].split("\n")
        
        # Remove any empty strings from the list
        questions_list = [question.strip() for question in questions_list if question.strip()]

        # Concatenate the questions into a single string
        feedback_string = "\n".join(questions_list)

        return feedback_string
    except Exception as e:
        print(f"An error occurred: {e}")
        return ""
    
def query_questions(role, job_description, questionnaire_type, num_questions):
    prompt = f"Generate {num_questions} questions for a {questionnaire_type} interview for the role of {role} with the following job description: {job_description}"

    messages = [
        {"role": "system", "content": prompt}
    ]

    try:
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=messages
        )

        # Split the response into a list of questions
        questions_list = response.choices[0].message["content"].split("\n")
        
        # Remove any empty strings from the list
        questions_list = [question.strip() for question in questions_list if question.strip()]

        return questions_list
    except Exception as e:
        print(f"An error occurred: {e}")
        return []

# Assuming you have defined role, job_description, questionnaire_type, num_questions
questions = query_questions(role, job_description, questionnaire_type, num_questions)
recognizer = sr.Recognizer()

def conduct_interview(questions):
    answers = {}
    recognizer = sr.Recognizer()

    for question in questions:
        print("Question:", question)
        tts = gTTS(text=question, lang='en')
        tts.save("question.mp3")
        os.system("afplay question.mp3")
        
  
        with sr.Microphone() as source:
            print("Please answer the question. Type 'end' and press Enter to move to the next question.")
            recognizer.adjust_for_ambient_noise(source)
            audio = recognizer.listen(source)
            
        try:
          
            answer = recognizer.recognize_google(audio)
            print("Answer:", answer)
            answers[question] = answer
        except sr.UnknownValueError:
            print("Sorry, I could not understand your response.")
        except sr.RequestError as e:
            print("Error fetching results; {0}".format(e))
        
        while True:
            user_input = input("Type 'end' and press Enter to move to the next question: ")
            if user_input.lower() == 'end':
                break
        
            # Check for end signal
            if 'end' in user_input.lower():
                break
    
    return answers

interview_answers = conduct_interview(questions)
final_interview_data = {**interview_info, **interview_answers}


print("Final Interview Data:")
for question, answer in final_interview_data.items():
    print("Question:", question)
    print("Answer:", answer)
    print()

feedback = feedback(final_interview_data)
print(feedback)