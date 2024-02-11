import requests
from bs4 import BeautifulSoup
from Text_summarization import Summarization
from lan_detect import language_detection


def webScrapper(url):

    response = requests.get(url)

    soup = BeautifulSoup(response.content, "html.parser")

    text_elements = soup.find_all("p")  # Replace "p" with the appropriate HTML tag for the text you want to extract

    extracted_text = [element.get_text() for element in text_elements]

    text = " ".join(extracted_text)

    return text

# url = "https://medium.com/@johnidouglasmarangon/how-to-summarize-text-with-openai-and-langchain-e038fc922af"
# Summarized_text = Summarization(webScrapper(url))

# language = language_detection(Summarized_text)

# print(Summarized_text)