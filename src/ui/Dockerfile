FROM python:3.6-alpine

WORKDIR /opt/app
ADD . .

RUN pip install -r requirements.txt -r requirements-test.txt

ENV MONGO server-mongodb
ENV MONGO_PORT 27017
ENV FLASK_APP ui.py

WORKDIR /opt/app/ui

EXPOSE 8000

CMD ["gunicorn", "ui:app", "-b", "0.0.0.0"]
