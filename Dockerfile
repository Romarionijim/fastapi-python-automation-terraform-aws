FROM python:3.11-slim

WORKDIR /app 

COPY requirements.txt . 

RUN pip install -r requirements.txt 

COPY . . 

EXPOSE 3000

CMD [ "uvicorn", "app.person:app", "--host", "0.0.0.0", "--port", "3000" ]