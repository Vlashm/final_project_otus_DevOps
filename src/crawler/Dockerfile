FROM python:3.6-alpine

WORKDIR /opt/app
ADD . .

RUN pip install -r requirements.txt -r requirements-test.txt

ENV MONGO server-mongodb
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE crawler
ENV RMQ_USERNAME user
ENV RMQ_PASSWORD user_pass
ENV CHECK_INTERVAL 10
ENV EXCLUDE_URLS '.*github.com'

EXPOSE 8000

CMD ["python", "-u", "crawler/crawler.py", "https://vitkhab.github.io/search_engine_test_site/"]
