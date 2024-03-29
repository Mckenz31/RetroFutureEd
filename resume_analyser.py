import streamlit as st
import google.generativeai as genai
import os
import PyPDF2 as pdf
from dotenv import load_dotenv
import json

load_dotenv()

genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

def get_gemini_repsonse(input):
    model = genai.GenerativeModel('gemini-pro')
    response = model.generate_content(input)
    return response.text

def input_pdf_text(uploaded_file):
    reader=pdf.PdfReader(uploaded_file)
    text=""
    for page in range(len(reader.pages)):
        page=reader.pages[page]
        text+=str(page.extract_text())
    return text

#Prompt Template

input_prompt = """
Hey Act Like a skilled or very experience ATS(Application Tracking System)
with a deep understanding of tech field,software engineering,data science ,data analyst
and big data engineer. Your task is to evaluate the resume based on the given job description.
You must consider the job market is very competitive and you should provide 
best assistance for improving the resumes. Assign the percentage Matching based 
on Jd and the missing keywords with high accuracy
resume:{resume_info}
description:{job_description}

I want the response in one single string having the structure
{{"JD Match":"%","MissingKeywords":[],"Profile Summary":"", "Areas of improvement":""}}
"""

## streamlit app
st.title("TimeBridger AI - Smart ATS")
st.text("Upload your resume to get an analysis Report")
jd = st.text_area("Paste the Job Description")
uploaded_file = st.file_uploader("Upload Your Resume",type="pdf",help="Please upload the pdf")


submit = st.button("Submit")

if submit:
    if uploaded_file is not None:
        text=input_pdf_text(uploaded_file)
        formatted_input_prompt = input_prompt.format(resume_info = text, job_description = jd)
        response = get_gemini_repsonse(formatted_input_prompt)
        parsed_response = json.loads(response)
        
        st.subheader("Analysis Result:")
        st.write(f"JD Match: {parsed_response['JD Match']}")
        st.write(f"Missing Keywords: {', '.join(parsed_response['MissingKeywords'])}")
        st.write("Profile Summary:")
        st.write(parsed_response['Profile Summary'])
        st.write("Areas of Improvement:")
        st.write('\n'.join(parsed_response['Areas of improvement']))
